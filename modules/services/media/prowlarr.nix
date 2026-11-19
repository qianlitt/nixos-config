{
  flake.modules.nixos."services.prowlarr" = {
    services.prowlarr = {
      enable = true;
      openFirewall = true;
    };
  };
}
