{
  flake.modules.nixos."services.immich" = {lib, ...}: {
    services.immich = {
      enable = true;

      machine-learning.enable = lib.mkDefault true;

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
