{
  config,
  lib,
  ...
}: let
  cfg = config.modules.services.immich;
in {
  options.modules.services.immich = {
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
  };
}
