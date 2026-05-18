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
      basedpyright = {
        enable = true;
        config = {
          settings = {
            basedpyright = {disableOrganizeImports = true;};
            python = {analysis = {typeCheckingMode = "recommended";};};
          };
        };
      };
      ruff.enable = true;
    };

    plugins = {
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
