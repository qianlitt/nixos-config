{
  lib,
  pkgs,
}: {
  lsp.yamlls = {};
  conform = {
    formatters_by_ft.yaml = ["yamlfmt"];
    commands.yamlfmt = lib.getExe pkgs.yamlfmt;
  };
  treesitter = ["yaml"];
}
