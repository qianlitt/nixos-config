{
  flake.modules.nixos."services.radarr" = {
    services.radarr = {
      enable = true;
      openFirewall = true;
    };
  };
}
