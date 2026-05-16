{
  lib,
  config,
  ...
}: let
  inherit (config.programs.nixvim.plugins.treesitter.package) builtGrammars;
in {
  programs.nixvim.plugins.treesitter.grammarPackages = lib.mkAfter [
    builtGrammars.markdown
    builtGrammars.markdown_inline
  ];
}
