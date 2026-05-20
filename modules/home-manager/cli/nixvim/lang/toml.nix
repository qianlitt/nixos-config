{
  lib,
  pkgs,
}: {
  lsp.tombi = {};
  conform.formatters_by_ft.toml = ["tombi"];
  treesitter = ["toml"];
}
