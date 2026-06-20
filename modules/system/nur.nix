{inputs, ...}: {
  flake-file.inputs = {
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.nixos.nur = {
    nixpkgs.overlays = [inputs.nur.overlays.default];
  };
}
