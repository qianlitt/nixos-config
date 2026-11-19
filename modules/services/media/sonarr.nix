{
  flake.modules.nixos."services.sonarr" = {
    services.sonarr = {
      enable = true;
      openFirewall = true;
    };
  };
}
