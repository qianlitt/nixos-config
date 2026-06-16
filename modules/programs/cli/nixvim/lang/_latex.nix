{
  lib,
  pkgs,
}: {
  lsp.texlab = {};
  conform = {
    formatters_by_ft.tex = ["tex-fmt"];
    commands.tex-fmt = lib.getExe pkgs.tex-fmt;
  };
  treesitter = ["latex"];
}
