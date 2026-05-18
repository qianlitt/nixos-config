{
  lib,
  config,
  ...
}: let
  inherit (config.programs.nixvim.plugins.treesitter.package) builtGrammars;
in {
  programs.nixvim = {
    lsp.servers.rust_analyzer.enable = true; # Rust

    plugins.treesitter.grammarPackages = lib.mkAfter [
      builtGrammars.rust
    ];
  };
}
