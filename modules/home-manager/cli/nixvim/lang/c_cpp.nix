{
  lib,
  pkgs,
}: {
  lsp.clangd = {};
  conform = {
    formatters_by_ft.cpp = ["clang-format"];
    commands.clang-format = lib.getExe' pkgs.clang-tools "clang-format";
  };
  lint.cpp = ["clangtidy"];
  treesitter = ["c" "cpp"];
}
