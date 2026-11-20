{
  flake.modules.nixos."services.gitea" = {lib, ...}: {
    services.gitea = {
      enable = true;

      database = lib.mkDefault {
        type = "postgres";
        createDatabase = true;
      };

      settings = {
        server = {
          HTTP_ADDR = "127.0.0.1";
          HTTP_PORT = 3000;
        };

        "cron.update_checker".ENABLED = false;
      };
    };
  };
}
