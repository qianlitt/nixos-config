{
  lib,
  config,
  pkgs,
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

    plugins.conform-nvim.settings = {
      formatters_by_ft = {
        typst = ["typstyle"];
      };

      formatters = {
        typstyle.command = lib.getExe pkgs.typstyle;
      };
    };

    plugins.treesitter.grammarPackages = lib.mkAfter [
      builtGrammars.typst
    ];
  };
}
