{
  lib,
  pkgs,
}: {
  lsp.lua_ls = {};
  conform = {
    formatters_by_ft.lua = ["stylua"];
    commands.stylua = lib.getExe pkgs.stylua;
  };
  treesitter = ["lua" "luadoc" "luap"];
}
