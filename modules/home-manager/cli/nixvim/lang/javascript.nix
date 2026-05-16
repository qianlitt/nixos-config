{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.programs.nixvim.plugins.treesitter.package) builtGrammars;
in {
  home.packages = with pkgs; [prettierd prettier];

  programs.nixvim = {
    plugins.conform-nvim.settings = {
      formatters_by_ft = {
        javascript = {
          __unkeyed-1 = "prettierd";
          __unkeyed-2 = "prettier";
          timeout_ms = 2000;
          stop_after_first = true;
        };
      };

      formatters = {
        prettierd.command = lib.getExe pkgs.prettierd;
        prettier.command = lib.getExe' pkgs.prettier "prettier";
      };
    };

    plugins.treesitter.grammarPackages = lib.mkAfter [
      builtGrammars.javascript
      builtGrammars.jsdoc
      builtGrammars.json
      builtGrammars.tsx
      builtGrammars.typescript
      builtGrammars.html
    ];
  };
}
