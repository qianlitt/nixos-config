# indent-blankline - 缩进线
#
# Home Page: https://github.com/lukas-reineke/indent-blankline.nvim
{
  flake.modules.homeManager.nixvim = {
    programs.nixvim = {
      plugins.indent-blankline = {
        enable = true;

        lazyLoad.settings.event = ["BufReadPost" "BufNewFile"];

        settings = {
          indent = {
            char = "┊";
            highlight = ["IblIndent"];
          };
          scope.enabled = false;
          exclude = {
            filetypes = ["help" "dashboard" "neo-tree"];
            buftypes = ["terminal" "nofile"];
          };
        };
      };

      highlight = {
        IblIndent = {fg = "#4e5a8d";}; # 缩进线颜色
      };
    };
  };
}
