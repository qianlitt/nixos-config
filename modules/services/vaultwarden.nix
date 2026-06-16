{
  flake.modules.nixos."services.vaultwarden" = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.modules.services.vaultwarden;
  in {
    options.modules.services.vaultwarden = {
      enable = lib.mkEnableOption "启用 Vaultwarden 密码管理服务";

      port = lib.mkOption {
        type = lib.types.port;
        default = 8000;
        description = "Vaultwarden 服务监听端口";
      };

      database = {
        name = lib.mkOption {
          type = lib.types.str;
          default = "vaultwarden";
          description = "PostgreSQL 数据库名";
        };

        user = lib.mkOption {
          type = lib.types.str;
          default = "vaultwarden";
          description = "PostgreSQL 用户名";
        };
      };
    };

    config = lib.mkIf cfg.enable {
      # Vaultwarden 服务配置
      services.vaultwarden = {
        enable = true;
        package = pkgs.vaultwarden-postgresql;

        dbBackend = "postgresql";
        config = {
          ROCKET_ADDRESS = "127.0.0.1";
          ROCKET_PORT = cfg.port;

          DATABASE_URL = "postgresql:///${cfg.database.name}?host=/run/postgresql";
        };
      };

      # PostgreSQL 数据库和用户管理
      services.postgresql = {
        ensureDatabases = [cfg.database.name];
        ensureUsers = [
          {
            name = cfg.database.user;
            ensureDBOwnership = true;
          }
        ];
      };
    };
  };
}
