# noice.nvim - 取代 message, cmdline, popupmenu UI
#
# Home Page: https://github.com/folke/noice.nvim
{
  flake.modules.homeManager.nixvim = {
    programs.nixvim = {
      plugins = {
        nui.enable = true; # noice 依赖

        noice = {
          enable = true;

          lazyLoad.settings.event = "DeferredUIEnter";

          settings = {
            lsp.override = {
              "cmp.entry.get_documentation" = true;
              "vim.lsp.util.convert_input_to_markdown_lines" = true;
            };

            # 消息的显示方式
            routes = [
              {
                view = "mini";
                filter = {
                  event = "msg_show";
                  any = [
                    {find = "%d+L, %d+B";}
                    {find = "; after #%d+";}
                    {find = "; before #%d+";}
                  ];
                };
              }
            ];

            # 预设
            presets = {
              bottom_search = true; # 使用传统的底部搜索栏
              command_palette = true; # 命令输入框与补全整合到一个浮动窗口中
              long_message_to_split = true; # 长消息重定向到水平分割窗口
            };
          };
        };

        which-key.settings.spec = [
          {
            __unkeyed-1 = "<leader>sn";
            group = "+noice";
          }
        ];
      };

      keymaps = [
        {
          key = "<leader>snl";
          action.__raw = ''function() require("noice").cmd("last") end'';
          options.desc = "Noice Last Message";
        }
        {
          key = "<leader>snh";
          action.__raw = ''function() require("noice").cmd("history") end'';
          options.desc = "Noice History";
        }
        {
          key = "<leader>sna";
          action.__raw = ''function() require("noice").cmd("all") end'';
          options.desc = "Noice All";
        }
        {
          key = "<leader>snd";
          action.__raw = ''function() require("noice").cmd("dismiss") end'';
          options.desc = "Dismiss All";
        }
        {
          key = "<leader>snt";
          action.__raw = ''function() require("noice").cmd("pick") end'';
          options.desc = "Noice Picker (Telescope/FzfLua)";
        }
        {
          key = "<c-f>";
          action.__raw = ''function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end'';
          options = {
            silent = true;
            expr = true;
            desc = "Scroll Forward";
          };
          mode = ["i" "n" "s"];
        }
        {
          key = "<c-b>";
          action.__raw = ''function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end'';
          options = {
            silent = true;
            expr = true;
            desc = "Scroll Backward";
          };
          mode = ["i" "n" "s"];
        }
      ];
    };
  };
}
