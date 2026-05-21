{
  lib,
  pkgs,
}: {
  lsp.rust_analyzer = {};
  conform = {
    formatters_by_ft.rust = ["rustfmt"];
    commands.rustfmt = lib.getExe pkgs.rustfmt;
  };
  treesitter = ["rust"];
  extraPackages = with pkgs; [rustc cargo];
}
