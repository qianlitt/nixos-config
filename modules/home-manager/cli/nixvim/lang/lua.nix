{
  lib,
  config,
  ...
}: let
  inherit (config.programs.nixvim.plugins.treesitter.package) builtGrammars;
in {
  programs.nixvim = {
    lsp.servers.lua_ls.enable = true;

    plugins.treesitter.grammarPackages = lib.mkAfter [
      builtGrammars.lua
      builtGrammars.luadoc
      builtGrammars.luap
    ];
  };
}
