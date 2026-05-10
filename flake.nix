{
  description = "A flake for NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quadlet-nix = {
      url = "github:SEIAROTg/quadlet-nix";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    niri.url = "github:sodiboo/niri-flake";
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim.url = "github:nix-community/nixvim";
    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    llm-agents.url = "github:numtide/llm-agents.nix";
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
        myvar = import ./var;
      in
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs mylib myvar;
          };

          modules = [
            ./hosts/server-frieren

            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {inherit inputs mylib myvar;};
              home-manager.users."${myvar.user.name}" = {
                imports = [
                  ./home/${myvar.user.name}
                ];
              };
            }
          ];
        };
      rin = let
        inherit (inputs.nixpkgs) lib;
        mylib = import ./lib {inherit lib;};
        myvar = import ./var;
      in
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs mylib myvar;
          };

          modules = [
            ./hosts/desktop-rin

            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {inherit inputs mylib myvar;};
              home-manager.users."${myvar.user.name}" = {
                imports = [
                  ./home/${myvar.user.name}
                ];
              };
            }
          ];
        };
    };
  };
}
