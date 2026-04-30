/**
* which-key.nvim - 显示按键绑定
*
* Home Page: https://github.com/folke/which-key.nvim
*/
{
  programs.nixvim.plugins.which-key = {
    enable = true;

    lazyLoad.settings.event = "DeferredUIEnter"; # DeferredUIEnter: 相当于 lazy.nvim 的 "VeryLazy"

    settings = {
      preset = "helix"; # 外观: false | "classic" | "modern" | "helix"
    };
  };
}
