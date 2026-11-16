{
  inputs,
  self,
  ...
}: {
  flake-file.inputs = {
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    secrets = {
      url = "path:./secrets";
      flake = false;
    };
  };

  flake.modules.nixos.sops = {
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];

    sops = {
      defaultSopsFile = "${self.inputs.secrets}/common.yaml";

      age.keyFile = "/var/lib/sops-nix/host-key.txt";
    };
  };

  flake.modules.homeManager.sops = {
    imports = [
      inputs.sops-nix.homeManagerModules.sops
    ];

    sops.defaultSopsFile = "${self.inputs.secrets}/common.yaml";
  };
}
