{
  lib,
  pkgs,
}: {
  lsp.tinymist = {
    config = {
      exportPdf = "onType";
      formatterMode = "typstyle";
    };
  };
  conform = {
    formatters_by_ft.typst = ["typstyle"];
    commands.typstyle = lib.getExe pkgs.typstyle;
  };
  treesitter = ["typst"];
}
