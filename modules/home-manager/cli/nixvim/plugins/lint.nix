/**
* nvim-lint - lint plugin
*
* Home Page: https://github.com/mfussenegger/nvim-lint
*/
{
  config,
  lib,
  ...
}: let
  inherit (config.modules.cli.nixvim) lint;
in
  lib.mkIf lint.enable {
    programs.nixvim = {
      plugins.lint = {
        enable = true;

        lazyLoad.settings.event = ["BufWritePost" "BufReadPost" "InsertLeave"];
      };
    };
  }
