{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.programs.nixvim.plugins.treesitter.package) builtGrammars;
in {
  programs.nixvim = {
    lsp.servers.marksman.enable = true;

    plugins.conform-nvim.settings = {
      formatters_by_ft = {
        markdown = ["mdformat" "prettier"];
      };

      formatters = {
        mdformat.command = lib.getExe pkgs.mdformat;
        prettier.command = lib.getExe' pkgs.prettier "prettier";
      };
    };

    plugins.treesitter.grammarPackages = lib.mkAfter [
      builtGrammars.markdown
      builtGrammars.markdown_inline
    ];
  };
}
