/**
* conform.nvim - formatter plugin
*
* Home Page: https://github.com/stevearc/conform.nvim
*/
{
  lib,
  pkgs,
  ...
}: {
  programs.nixvim = {
    plugins.conform-nvim = {
      enable = true;

      lazyLoad.settings = {
        event = "BufWritePre";
        cmd = "ConformInfo";
        keys = [
          {
            __unkeyed-1 = "<leader>cf";
            __unkeyed-3.__raw = ''
              function()
                require("conform").format({ async = true })
              end
            '';
            desc = "Format buffer";
          }
        ];
      };

      settings = {
        formatters_by_ft."_" = ["squeeze_blanks" "trim_whitespace" "trim_newlines"];
        formatters.squeeze_blanks.command = lib.getExe' pkgs.coreutils "cat";
      };
    };
  };
}
