{
  lib,
  config,
  ...
}: let
  inherit (config.programs.nixvim.plugins.treesitter.package) builtGrammars;
in {
  programs.nixvim = {
    lsp.servers.texlab.enable = true;

    plugins.treesitter.grammarPackages = lib.mkAfter [
      builtGrammars.latex
    ];
  };
}
