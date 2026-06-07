{
  description = "A flake for NixOS configuration";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    dolphin-overlay.url = "github:MattiDragon/dolphin-overlay";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.git-hooks.flakeModule
      ];

      systems = ["x86_64-linux"];

      perSystem = {
        config,
        pkgs,
        ...
      }: {
        pre-commit = {
          settings = {
            hooks = {
              # Nix formatter
              alejandra.enable = true;
            };
          };
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [config.pre-commit.devShell];

          packages = with pkgs; [
            # git tools
            git
            pre-commit

            # Nix
            nil # lsp
            nixd # lsp
            alejandra # formatter
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
        formatter = pkgs.alejandra;
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
