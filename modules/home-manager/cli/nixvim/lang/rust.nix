{
  lib,
  pkgs,
}: {
  lsp.rust_analyzer = {};
  treesitter = ["rust"];
  extraPackages = with pkgs; [rustc cargo];
}
