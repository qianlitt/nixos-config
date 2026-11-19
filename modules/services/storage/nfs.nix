{
  flake.modules.nixos."services.nfs" = {
    services.nfs.server = {
      enable = true;
      createMountPoints = true;
    };

    networking.firewall.allowedTCPPorts = [2049];
  };
}
