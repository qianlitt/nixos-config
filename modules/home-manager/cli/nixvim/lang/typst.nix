{
  lib,
  config,
  ...
}: let
  inherit (config.programs.nixvim.plugins.treesitter.package) builtGrammars;
in {
  programs.nixvim = {
    lsp.servers.tinymist = {
      enable = true;
      config = {
        exportPdf = "onType";
        formatterMode = "typstyle";
      };
    };

    plugins.treesitter.grammarPackages = lib.mkAfter [
      builtGrammars.typst
    ];
  };
}
