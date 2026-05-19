/**
* nvim-lint - lint plugin
*
* Home Page: https://github.com/mfussenegger/nvim-lint
*/
{
  programs.nixvim = {
    plugins.lint = {
      enable = true;

      lazyLoad.settings.event = ["BufWritePost" "BufReadPost" "InsertLeave"];
    };
  };
}
