{
  lib,
  pkgs,
}: {
  lsp.marksman = {};
  conform = {
    formatters_by_ft.markdown = ["mdformat" "prettier"];
    commands = {
      mdformat = lib.getExe pkgs.mdformat;
      prettier = lib.getExe' pkgs.prettier "prettier";
    };
  };
  treesitter = ["markdown" "markdown_inline"];
}
