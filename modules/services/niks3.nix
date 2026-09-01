# niks3 - Nix binary cache
{inputs, ...}: {
  flake-file.inputs = {
    niks3.url = "github:Mic92/niks3";
    niks3.inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos."services.niks3" = {lib, ...}: {
    imports = [inputs.niks3.nixosModules.niks3];

    services.niks3 = {
      enable = true;
      httpAddr = lib.mkDefault "127.0.0.1:5751";

      gc = lib.mkDefault {
        enable = true;
        failedUploadsOlderThan = "6h";
        olderThan = "720h";
        randomizedDelaySec = 1800;
        schedule = "daily";
      };
    };
  };
}
