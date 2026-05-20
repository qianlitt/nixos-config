{
  lib,
  pkgs,
}: {
  lsp.bashls = {};
  conform = {
    formatters_by_ft.bash = ["shellcheck" "shellharden" "shfmt"];
    commands = {
      shellcheck = lib.getExe pkgs.shellcheck;
      shellharden = lib.getExe pkgs.shellharden;
      shfmt = lib.getExe pkgs.shfmt;
    };
  };
  lint.bash = ["bash"];
  treesitter = ["bash"];
}
