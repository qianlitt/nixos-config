{
  config,
  lib,
  ...
}: let
  cfg = config.modules.nixos.immich;
in {
  options.modules.nixos.immich = {
    enable = lib.mkEnableOption "启用 Immich 照片管理服务";

    host = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "Immich 服务监听地址";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 2283;
      description = "Immich 服务监听端口";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "immich";
      description = "Immich 运行用户";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "immich";
      description = "Immich 运行用户组";
    };

    mediaLocation = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/immich";
      description = "Immich 媒体文件存储目录";
    };

    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Immich 服务环境变量";
    };

    machine-learning = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "是否启用 Immich 机器学习功能";
      };

      environment = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {};
        description = "Immich 机器学习服务环境变量";
      };
    };

    virtualHostName = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "photo.example.com";
      description = "Immich WebUI 的 Nginx 虚拟主机域名";
    };

    useACMEHost = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "使用的 ACME 主机证书配置";
    };
  };

  config = lib.mkIf cfg.enable {
    services.immich = {
      enable = true;
      inherit (cfg) host port user group mediaLocation environment;
      openFirewall = true;
      machine-learning = {
        enable = cfg.machine-learning.enable;
        environment = cfg.machine-learning.environment;
      };

      # 使用本地 PostgreSQL Unix socket
      database = {
        enable = true;
        createDB = true;
        user = "immich";
        name = "immich";
        host = "/run/postgresql";
        port = 5432;
      };

      redis.enable = true;
    };

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
