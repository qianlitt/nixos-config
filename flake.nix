{
  description = "A flake for NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: {
    nixosConfigurations = {
      # x86_64-linux Hosts
      frieren = let
        inherit (inputs.nixpkgs) lib;
        mylib = import ./lib {inherit lib;};
      in
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs mylib;
          };

          modules = [
            ./hosts/server-frieren
          ];
        };
    };
  };
}
