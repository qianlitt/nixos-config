{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.programs.nixvim.plugins.treesitter.package) builtGrammars;
in {
  programs.nixvim = {
    lsp.servers.yamlls.enable = true;

    plugins.conform-nvim.settings = {
      formatters_by_ft = {
        yaml = ["yamlfmt"];
      };

      formatters = {
        yamlfmt.command = lib.getExe pkgs.yamlfmt;
      };
    };

    plugins.treesitter.grammarPackages = lib.mkAfter [
      builtGrammars.yaml
    ];
  };
}
