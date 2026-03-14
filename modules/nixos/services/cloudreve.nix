{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.nixos.cloudreve;

  # 检测是否使用远程数据库（非本地回环地址）
  useRemoteDb =
    !(
      cfg.database.host
      == "127.0.0.1"
      || cfg.database.host == "localhost"
      || cfg.database.host == "::1"
    );
in {
  options.modules.nixos.cloudreve = {
    enable = lib.mkEnableOption "启用 Cloudreve 云存储系统";

    image = lib.mkOption {
      type = lib.types.str;
      default = "docker.io/cloudreve/cloudreve:v4";
      description = "Cloudreve Docker 镜像";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/cloudreve";
      description = "Cloudreve 数据存储目录";
    };

    webPort = lib.mkOption {
      type = lib.types.port;
      default = 5212;
      description = "Cloudreve Web 服务监听端口";
    };

    offlineDownloadPort = lib.mkOption {
      type = lib.types.port;
      default = 6888;
      description = "离线下载功能监听端口";
    };

    database = {
      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1"; # host 网络模式下使用 localhost
        description = "PostgreSQL 服务器地址";
      };
      port = lib.mkOption {
        type = lib.types.port;
        default = 5432;
        description = "PostgreSQL 监听端口";
      };
      user = lib.mkOption {
        type = lib.types.str;
        default = "cloudreve";
        description = "PostgreSQL 用户名";
      };
      name = lib.mkOption {
        type = lib.types.str;
        default = "cloudreve";
        description = "PostgreSQL 数据库名";
      };
      passwordFile = lib.mkOption {
        type = lib.types.str;
        example = "/run/secrets/cloudreve-db-password";
        description = "包含 PostgreSQL 密码的文件路径（必须设置）";
      };
      containerNetwork = lib.mkOption {
        type = lib.types.str;
        default = "10.88.0.0/16";
        description = "容器网络 CIDR（host 网络模式下不生效）";
      };
    };

    redis = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "是否启用 Redis 缓存（建议启用）";
      };
      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1"; # host 网络模式下使用 localhost
        description = "Redis 服务器地址";
      };
      port = lib.mkOption {
        type = lib.types.port;
        default = 6379;
        description = "Redis 监听端口";
      };
    };

    virtualHostName = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "cloudreve.example.com";
      description = "Cloudreve WebUI 的 Nginx 虚拟主机域名";
    };

    useACMEHost = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "使用的 ACME 主机证书配置";
    };
  };

  config = lib.mkIf cfg.enable {
    # 前置条件校验
    assertions = [
      {
        assertion = cfg.database.passwordFile != "";
        message = "Cloudreve: database.passwordFile 必须设置，且文件内容应为 PostgreSQL 密码";
      }
    ];

    # 确保所需子系统启用
    modules.nixos.podman.enable = true;
    modules.nixos.quadlet.enable = true;

    # PostgreSQL 配置
    services.postgresql = lib.mkIf (!useRemoteDb) {
      enable = true;
      ensureDatabases = [cfg.database.name];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensureDBOwnership = true;
        }
      ];
      # 如果使用 host 网络，PostgreSQL 只需监听 localhost
      # 但如果 useRemoteDb 为 true，则需要允许远程连接
      authentication = lib.mkIf useRemoteDb (lib.mkAfter ''
        host ${cfg.database.name} ${cfg.database.user} ${cfg.database.containerNetwork} md5
      '');
    };

    systemd.services.cloudreve-db-init = lib.mkIf (!useRemoteDb) {
      description = "Initialize Cloudreve database user";
      after = ["postgresql.service"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        User = "postgres";
        RemainAfterExit = true;
      };
      script = ''
        PSQL="${config.services.postgresql.package}/bin/psql"
        PASSWORD="$(< ${cfg.database.passwordFile})"
        $PSQL -tAc "SELECT 1 FROM pg_roles WHERE rolname='${cfg.database.user}'" | grep -q 1 || \
        $PSQL -c "CREATE USER ${cfg.database.user} WITH PASSWORD '$PASSWORD';"
        $PSQL -c "ALTER USER ${cfg.database.user} WITH PASSWORD '$PASSWORD';"
        $PSQL -c "GRANT ALL PRIVILEGES ON DATABASE ${cfg.database.name} TO ${cfg.database.user};"
      '';
    };

    # Redis 服务
    services.redis.servers."cloudreve" = lib.mkIf cfg.redis.enable {
      enable = true;
      bind = cfg.redis.host;
      port = cfg.redis.port;
    };

    # 创建数据目录，所有权设为 root（容器以 root 运行）
    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0755 0 0 - -"
    ];

    # Quadlet 容器定义
    virtualisation.quadlet.containers.cloudreve = {
      autoStart = true;
      containerConfig = {
        image = cfg.image;
        networks = ["host"]; # 使用主机网络
        volumes = [
          "${cfg.dataDir}:/cloudreve/data"
        ];
        environments = {
          "CR_CONF_Database.Type" = "postgres";
          "CR_CONF_Database.Host" = cfg.database.host;
          "CR_CONF_Database.Port" = toString cfg.database.port;
          "CR_CONF_Database.User" = cfg.database.user;
          "CR_CONF_Database.Name" = cfg.database.name;
          "CR_CONF_Redis.Server" = "${cfg.redis.host}:${toString cfg.redis.port}";
        };
        environmentFiles = ["/run/cloudreve/db-password.env"];
      };
      unitConfig = {
        After = ["postgresql.service" "redis-cloudreve.service"];
        Requires = ["postgresql.service" "redis-cloudreve.service"];
      };
      serviceConfig = {
        Restart = "always";
        RuntimeDirectory = "cloudreve";
        RuntimeDirectoryMode = "0750";
        ExecStartPre = [
          "${pkgs.bash}/bin/bash -c 'echo \"CR_CONF_Database.Password=$(< ${cfg.database.passwordFile})\" > /run/cloudreve/db-password.env'"
        ];
      };
    };

    # Nginx 反代配置
    modules.nixos.nginx.virtualHosts.${cfg.virtualHostName} = lib.mkIf (cfg.virtualHostName != "") {
      forceSSL = cfg.useACMEHost != "";
      useACMEHost = lib.mkIf (cfg.useACMEHost != "") cfg.useACMEHost;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.webPort}/";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 0;        # 不限大小，或设为 1024m
          tcp_nopush on;
          tcp_nodelay on;
          proxy_send_timeout 600s;
          proxy_read_timeout 600s;

          # 流式传输（适合超大文件，减少内存使用）
          proxy_request_buffering off;   # 关闭请求缓冲，直接流式传输到后端
          proxy_buffering off;           # 关闭响应缓冲
          chunked_transfer_encoding on;  # 分块传输编码
        '';
      };
    };

    # 开放防火墙端口
    networking.firewall.allowedTCPPorts = [
      cfg.webPort
      cfg.offlineDownloadPort
    ];
    networking.firewall.allowedUDPPorts = [
      cfg.offlineDownloadPort
    ];
  };
}
