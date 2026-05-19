{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.programs.nixvim.plugins.treesitter.package) builtGrammars;
in {
  programs.nixvim = {
    lsp.servers.lua_ls.enable = true;

    plugins.conform-nvim.settings = {
      formatters_by_ft = {
        lua = ["stylua"];
      };

      formatters = {
        stylua = {
          command = lib.getExe pkgs.stylua;
        };
      };
    };

    plugins.treesitter.grammarPackages = lib.mkAfter [
      builtGrammars.lua
      builtGrammars.luadoc
      builtGrammars.luap
    ];
  };
}
