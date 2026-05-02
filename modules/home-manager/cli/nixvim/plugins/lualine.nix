/**
* lualine.nvim
*
* Home Page: https://github.com/nvim-lualine/lualine.nvim
*/
{
  programs.nixvim.plugins.lualine = {
    enable = true;

    lazyLoad.settings.event = "DeferredUIEnter";
  };
}
