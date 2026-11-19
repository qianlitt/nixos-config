# mini.indentscope - 缩进线
#
# Home Page: https://github.com/nvim-mini/mini.indentscope
{
  flake.modules.homeManager."nixvim.plugins" = {
    programs.nixvim.plugins.mini-indentscope = {
      enable = true;

      lazyLoad.settings.event = ["BufReadPost" "BufNewFile"];

      settings = {
        symbol = "│";
      };
    };
  };
}
