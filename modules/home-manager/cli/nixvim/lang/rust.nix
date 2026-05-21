{
  lib,
  pkgs,
}: {
  lsp.rust_analyzer = {};
  conform = {
    formatters_by_ft.rust = ["rustfmt"];
    commands.rustfmt = lib.getExe pkgs.rustfmt;
  };
  lint.rust = ["clippy"];
  treesitter = ["rust"];
  extraPackages = with pkgs; [rustc cargo clippy];
}
