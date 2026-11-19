{
  flake.modules.nixos."services.seerr" = {
    services.seerr = {
      enable = true;
      openFirewall = true;
    };
  };
}
