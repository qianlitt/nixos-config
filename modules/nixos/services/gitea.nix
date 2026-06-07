{
  config,
  lib,
  ...
}: let
  cfg = config.modules.services.gitea;
in {
  options.modules.services.gitea = {
    enable = lib.mkEnableOption "启用 Gitea 服务";

    # 基础配置
    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "Gitea Web 端口";
    };

    # 数据库配置
    database = {
      type = lib.mkOption {
        type = lib.types.enum ["postgres" "mysql" "sqlite3"];
        default = "postgres";
        description = "数据库类型";
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "数据库主机地址";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 5432;
        description = "数据库端口";
      };

      name = lib.mkOption {
        type = lib.types.str;
        default = "gitea";
        description = "数据库名称";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "gitea";
        description = "数据库用户";
      };
    };

    # SSH 配置
    ssh = {
      enable = lib.mkEnableOption "启用 SSH 访问" // {default = true;};

      port = lib.mkOption {
        type = lib.types.port;
        default = 22;
        description = "SSH 监听端口";
      };
    };

    # 服务配置
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "额外的 Gitea 配置，透传给 services.gitea.settings";
    };
  };

  config = lib.mkIf cfg.enable {
    # 启用 Gitea 服务
    services.gitea = {
      enable = true;

      # 数据库配置
      database = {
        inherit (cfg.database) type host port name user;
        createDatabase = true;
      };

      # 额外配置
      settings =
        cfg.settings
        // {
          server = {
            HTTP_PORT = cfg.port;
            DISABLE_SSH = !cfg.ssh.enable;
            SSH_PORT = cfg.ssh.port;
          };
        };
    };

    # 防火墙配置
    networking.firewall.allowedTCPPorts =
      [
        cfg.port
      ]
      ++ lib.optional cfg.ssh.enable cfg.ssh.port;
  };
}
