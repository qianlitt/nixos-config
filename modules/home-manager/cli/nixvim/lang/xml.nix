{
  lib,
  config,
  ...
}: let
  inherit (config.programs.nixvim.plugins.treesitter.package) builtGrammars;
in {
  programs.nixvim = {
    lsp.servers.lemminx.enable = true;

    plugins.treesitter.grammarPackages = lib.mkAfter [
      builtGrammars.xml
    ];
  };
}
