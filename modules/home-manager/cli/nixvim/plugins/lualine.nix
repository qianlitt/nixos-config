/**
* lualine.nvim
*
* Home Page: https://github.com/nvim-lualine/lualine.nvim
*/
let
  utils = import ../utils;
in {
  programs.nixvim.plugins = {
    # 提供文件类型图标
    web-devicons = {
      enable = true;

      lazyLoad.settings.event = "DeferredUIEnter";
    };

    lualine = {
      enable = true;

      lazyLoad.settings.event = "DeferredUIEnter";

      settings = {
        options = {
          theme = "auto";
          globalstatus = true; # 使用全局状态栏
          disabled_filetypes = {
            statusline = ["dashboard" "alpha" "ministarter" "snacks_dashboard"];
          };
        };

        sections = {
          lualine_a = ["mode"];
          lualine_b = ["branch"];
          lualine_c = [
            {
              # 诊断信息: 由 LSP 提供
              __unkeyed-1 = "diagnostics";
              symbles = {
                error = utils.icons.diagnostics.Error;
                warn = utils.icons.diagnostics.Warn;
                info = utils.icons.diagnostics.Info;
                hint = utils.icons.diagnostics.Hint;
              };
            }
            {
              # 文件类型: 依赖 nvim-web-devicons 插件
              __unkeyed-1 = "filetype";
              icon_only = true; # 只显示文件类型的图标
              separator = ""; # 无分隔符
              padding = {
                # 组件两侧填充
                left = 1;
                right = 0;
              };
            }
            {
              # TODO: 当前只显示文件名，计划实现 LazyVim.lualine.pretty_path() 功能
              __unkeyed-1 = "filename";
            }
          ];

          lualine_x = [
            {
              # snacks.profiler 状态栏组件
              __raw = "require('snacks').profiler.status()";
            }
          ];
          lualine_y = [
            {
              # 文件进度 (百分比)
              __unkeyed-1 = "progress";
              separator = " ";
              padding = {
                left = 1;
                right = 0;
              };
            }
            {
              # 文件位置 (line:column)
              __unkeyed-1 = "location";
              padding = {
                left = 0;
                right = 1;
              };
            }
          ];
          lualine_z = [
            {
              # 当前时间
              __unkeyed-1.__raw = ''
                function()
                  return " " .. os.date("%R")
                end
              '';
            }
          ];
        };

        extensions = ["neo-tree" "lazy" "fzf"];
      };
    };
  };
}
