{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.programs.nixvim.plugins.treesitter.package) builtGrammars;
in {
  programs.nixvim = {
    lsp.servers = {
      basedpyright.enable = true;
      ruff.enable = true;
    };

    plugins = {
      lsp.servers = {
        basedpyright = {
          enable = true;
          settings = {
            basedpyright = {
              disableOrganizeImports = true;
            };
            python = {
              analysis = {
                typeCheckingMode = "recommended";
              };
            };
          };
        };

        ruff = {
          enable = true;
          rootMarkers = ["pyproject.toml" "ruff.toml" ".ruff.toml" ".git"];
          onAttach.function = ''
            client.server_capabilities.hoverProvider = false
          '';
        };
      };

      conform-nvim.settings = {
        formatters_by_ft = {
          python = ["ruff"];
        };

        formatters.ruff.command = lib.getExe pkgs.ruff;
      };

      treesitter.grammarPackages = lib.mkAfter [
        builtGrammars.python
      ];
    };
  };
}
