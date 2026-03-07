{
  description = "A flake for NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: {
    nixosConfigurations = {
      # x86_64-linux Hosts
      frieren = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/server-frieren
        ];
      };
    };
  };
}
