{
  flake.modules.nixos."services.anki-sync" = {
    services.anki-sync-server = {
      enable = true;
      address = "127.0.0.1";
    };

    # 同步负载上限：2000 MiB
    systemd.services.anki-sync-server.environment.MAX_SYNC_PAYLOAD_MEGS = "2000";
  };
}
