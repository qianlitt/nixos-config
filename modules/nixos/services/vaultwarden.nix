{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.nixos.vaultwarden;
in {
  options.modules.nixos.vaultwarden = {
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

    virtualHostName = lib.mkOption {
      type = lib.types.str;
      default = "vw.lan.luna-sama.xyz";
      example = "bitwarden.example.com";
      description = "Vaultwarden WebUI 的 Nginx 虚拟主机域名";
    };

    useACMEHost = lib.mkOption {
      type = lib.types.str;
      default = "wildcard.lan";
      description = "使用的 ACME 主机证书配置";
    };
  };

  config = lib.mkIf cfg.enable {
    # 确保所需子系统启用
    modules.nixos.postgresql.enable = true;
    modules.nixos.nginx.enable = true;

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

    # Nginx 反代配置
    modules.nixos.nginx.virtualHosts.${cfg.virtualHostName} = {
      forceSSL = cfg.useACMEHost != "";
      useACMEHost = lib.mkIf (cfg.useACMEHost != "") cfg.useACMEHost;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.port}/";
        proxyWebsockets = true;
      };
    };
  };
}
