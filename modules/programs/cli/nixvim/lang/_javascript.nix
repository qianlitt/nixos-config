{
  lib,
  pkgs,
}: {
  lsp.ts_ls = {};
  conform = {
    formatters_by_ft.javascript = {
      __unkeyed-1 = "prettierd";
      __unkeyed-2 = "prettier";
      timeout_ms = 2000;
      stop_after_first = true;
    };
    commands = {
      prettierd = lib.getExe pkgs.prettierd;
      prettier = lib.getExe' pkgs.prettier "prettier";
    };
  };
  treesitter = ["javascript" "jsdoc" "json" "tsx" "typescript" "html"];
}
