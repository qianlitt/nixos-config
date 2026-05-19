{
  lib,
  config,
  ...
}: let
  inherit (config.programs.nixvim.plugins.treesitter.package) builtGrammars;
in {
  programs.nixvim = {
    lsp.servers.tombi.enable = true;

    plugins.conform-nvim.settings = {
      formatters_by_ft = {
        toml = ["tombi"];
      };
    };

    plugins.treesitter.grammarPackages = lib.mkAfter [
      builtGrammars.toml
    ];
  };
}
