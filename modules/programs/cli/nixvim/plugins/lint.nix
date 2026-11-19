# nvim-lint - lint plugin
#
# Home Page: https://github.com/mfussenegger/nvim-lint
{
  flake.modules.homeManager."nixvim.plugins" = {
    programs.nixvim = {
      plugins.lint = {
        enable = true;

        lazyLoad.settings.event = ["BufWritePost" "BufReadPost" "InsertLeave"];

        autoCmd = {
          event = ["BufWritePost"]; # 保存时运行
          callback.__raw = ''
            function()
              require('lint').try_lint()
            end
          '';
        };
      };
    };
  };
}
