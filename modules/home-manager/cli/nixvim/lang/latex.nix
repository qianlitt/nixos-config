{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (config.programs.nixvim.plugins.treesitter.package) builtGrammars;
in {
  programs.nixvim = {
    lsp.servers.texlab.enable = true;

    plugins.conform-nvim.settings = {
      formatters_by_ft = {
        tex = ["tex-fmt"];
      };

      formatters = {
        tex-fmt.command = lib.getExe pkgs.tex-fmt;
      };
    };

    plugins.treesitter.grammarPackages = lib.mkAfter [
      builtGrammars.latex
    ];
  };
}
