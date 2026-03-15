{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.nixos.openlist;
in {
  options.modules.nixos.openlist = {
    enable = lib.mkEnableOption "启用 OpenList 服务";

    image = lib.mkOption {
      type = lib.types.str;
      default = "docker.io/openlistteam/openlist:latest";
      description = "OpenList Docker 镜像";
    };

    adminPasswordFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/openlist-admin-password";
      description = ''
        OpenList 管理员密码文件

        包含 OpenList 管理员密码的文件路径。文件内容应为 `OPENLIST_ADMIN_PASSWORD=<your_password>`。如果为 null，则需要在首次启动后手动配置管理员密码。
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/openlist";
      description = "OpenList 数据存储目录";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 5244;
      description = "OpenList 监听端口";
    };

    virtualHostName = lib.mkOption {
      type = lib.types.str;
      default = "op.lan.luna-sama.xyz";
      example = "openlist.example.com";
      description = "OpenList WebUI 的 Nginx 虚拟主机域名";
    };

    useACMEHost = lib.mkOption {
      type = lib.types.str;
      default = "wildcard.lan";
      description = "使用的 ACME 主机证书配置";
    };
  };

  config = lib.mkIf cfg.enable {
    # 确保所需子系统启用
    modules.nixos.podman.enable = true;
    modules.nixos.quadlet.enable = true;

    # 创建用户和用户组
    users.users.openlist = {
      isSystemUser = true;
      group = "openlist";
      home = cfg.dataDir;
      createHome = true;
    };
    users.groups.openlist = {};

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0755 openlist openlist -"
    ];

    virtualisation.quadlet.containers.openlist = {
      autoStart = true;
      containerConfig = {
        image = cfg.image;
        publishPorts = ["${toString cfg.port}:${toString cfg.port}"];
        user = "${toString config.users.users.openlist.uid}:${toString config.users.groups.openlist.gid}";
        volumes = [
          "${cfg.dataDir}:/opt/openlist/data:Z"
        ];
        environments = {
          "TZ" = config.time.timeZone;
          "UMASK" = "022";
        };
        environmentFiles = [cfg.adminPasswordFile];
      };
      serviceConfig = {
        Restart = "unless-stopped";
      };
    };

    networking.firewall.allowedTCPPorts = [cfg.port];

    # Nginx 反代配置
    modules.nixos.nginx.virtualHosts.${cfg.virtualHostName} = lib.mkIf (cfg.virtualHostName != "") {
      forceSSL = cfg.useACMEHost != "";
      useACMEHost = lib.mkIf (cfg.useACMEHost != "") cfg.useACMEHost;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.port}/";
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
  };
}
