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

      # 映射空间
      spec = [
        {
          __unkeyed-1 = "<leader><tab>";
          group = "tabs";
        }
        {
          __unkeyed-1 = "<leader>b";
          group = "buffer";
          expand.__raw = ''
            function()
              return require("which-key.extras").expand.buf()
            end
          '';
        }
        {
          __unkeyed-1 = "<leader>c";
          group = "code";
        }
        {
          __unkeyed-1 = "<leader>d";
          group = "debug";
        }
        {
          __unkeyed-1 = "<leader>f";
          group = "file/find";
        }
        {
          __unkeyed-1 = "<leader>g";
          group = "git";
        }
        {
          __unkeyed-1 = "<leader>gh";
          group = "hunks";
        }
        {
          __unkeyed-1 = "<leader>q";
          group = "quit/session";
        }
        {
          __unkeyed-1 = "<leader>s";
          group = "search";
        }
        {
          __unkeyed-1 = "<leader>u";
          group = "ui";
        }
        {
          __unkeyed-1 = "<leader>w";
          group = "window";
          proxy = "<c-w>";
          expand.__raw = ''
            function()
              return require("which-key.extras").expand.win()
            end
          '';
        }
        {
          __unkeyed-1 = "<leader>x";
          group = "diagnostics/quickfix";
        }
        {
          __unkeyed-1 = "[";
          group = "prev";
        }
        {
          __unkeyed-1 = "]";
          group = "next";
        }
        {
          __unkeyed-1 = "g";
          group = "goto";
        }
        {
          __unkeyed-1 = "z";
          group = "fold";
        }
      ];
    };
  };
}
