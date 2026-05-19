{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.programs.nixvim.plugins.treesitter.package) builtGrammars;
in {
  programs.nixvim = {
    lsp.servers.ts_ls.enable = true;

    plugins.conform-nvim.settings = {
      formatters_by_ft = {
        javascript = {
          __unkeyed-1 = "prettierd";
          __unkeyed-2 = "prettier";
          timeout_ms = 2000;
          stop_after_first = true; # 使用第一个可用的 formatter
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
