{
  description = "A flake for NixOS configuration";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

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

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      perSystem = {pkgs, ...}: {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            git
            nil # nix lsp
            nixd # nix lsp
            alejandra # nix 格式化工具
            nurl # Generate Nix fetcher calls from repository URLs

            # MCP Dependencise
            uv
            nodejs

            # secrets
            age
            sops
          ];

          shellHook = ''
            echo "缓存 mcp-nixos..."
            ${pkgs.nix}/bin/nix build --no-link github:utensils/mcp-nixos 2>/dev/null || true
            echo "mcp-nixos 已缓存"
          '';
        };
      };

      flake = {
        nixosConfigurations = let
          inherit (inputs.nixpkgs) lib;
          mylib = import ./lib {inherit lib;};
          myvar = import ./var;

          mkHost = hostname: hostPath:
            lib.nixosSystem {
              specialArgs = {
                inherit inputs mylib myvar hostname;
                hostConfig = myvar.hosts.${hostname} or {};
              };
              modules = [
                hostPath
                inputs.home-manager.nixosModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.extraSpecialArgs = {
                    inherit inputs mylib myvar hostname;
                    hostConfig = myvar.hosts.${hostname} or {};
                  };
                  home-manager.users."${myvar.user.name}" = {
                    imports = [./home/${myvar.user.name}];
                  };
                }
              ];
            };
        in {
          frieren = mkHost "frieren" ./hosts/server-frieren;
          rin = mkHost "rin" ./hosts/desktop-rin;
        };
      };
    };
}
