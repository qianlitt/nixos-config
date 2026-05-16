{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.programs.nixvim.plugins.treesitter.package) builtGrammars;
in {
  home.packages = [pkgs.clang-tools];

  programs.nixvim = {
    lsp.servers = {
      clangd.enable = true;
    };

    plugins.conform-nvim.settings = {
      formatters_by_ft = {
        cpp = ["clang-format"];
      };

      formatters.clang-format.command = lib.getExe' pkgs.clang-tools "clang-format";
    };

    plugins.treesitter.grammarPackages = lib.mkAfter [
      builtGrammars.c
      builtGrammars.cpp
    ];
  };
}
