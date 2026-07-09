{inputs, ...}: {
  imports = [
    inputs.git-hooks.flakeModule
  ];

  flake-file.inputs = {
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  perSystem = {
    config,
    pkgs,
    ...
  }: {
    pre-commit = {
      settings = {
        hooks = {
          # Nix Formatter
          alejandra.enable = true;

          # Nix Linter
          deadnix.enable = true;
          statix.enable = true;
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
        deadnix # linter
        statix # linter
        nurl # Generate Nix fetcher calls from repository URLs

        # MCP Dependencies
        uv
        nodejs

        # secrets
        age
        sops
      ];

      shellHook = ''
        echo "缓存 mcp-nixos..."
        ${pkgs.nix}/bin/nix build --no-link github:utensils/mcp-nixos
        echo "mcp-nixos 已缓存"
      '';
    };
    formatter = pkgs.alejandra;
  };
}
