{
  flake.modules.nixos."services.vaultwarden" = {pkgs, ...}: {
    # Vaultwarden 服务配置
    services.vaultwarden = {
      enable = true;
      package = pkgs.vaultwarden-postgresql;

      dbBackend = "postgresql";
      config = {
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;
        ENABLE_WEBSOCKET = true;

        DATABASE_URL = "postgresql:///vaultwarden?host=/run/postgresql";
      };
    };

    # PostgreSQL 数据库和用户管理
    services.postgresql = {
      ensureDatabases = ["vaultwarden"];
      ensureUsers = [
        {
          name = "vaultwarden";
          ensureDBOwnership = true;
        }
      ];
    };
  };
}
