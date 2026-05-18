/**
* blink.cmp - 代码补全
*
* Home Page: https://github.com/saghen/blink.cmp
*/
{
  programs.nixvim = {
    plugins.blink-cmp = {
      enable = true;

      settings = {
        appearance = {
          nerd_font_variant = "mono";
          use_nvim_cmp_as_default = false; # 使用 blink 样式
        };
        keymap = {
          # 预设: https://main.cmp.saghen.dev/configuration/keymap.html#presets
          preset = "enter";
          "<C-i>" = ["show" "show_documentation" "hide_documentation"]; # 显示补全菜单
          "<C-y>" = ["select_and_accept"]; # 选中并应用

          "<Tab>" = ["select_next" "fallback"]; # 绑定 Tab/S-Tab 切换选项
          "<S-Tab>" = ["select_prev" "fallback"];
        };
        completion = {
          accept = {
            auto_brackets.enabled = true; # 接受补全时自动添加括号
          };
          documentation = {
            auto_show = true; # 自动弹出文档窗口
            auto_show_delay_ms = 200; # 延迟 200ms，避免闪烁
          };
          ghost_text.enabled = true; # 在行内显示灰色预览文本
          menu = {
            draw.treesitter = ["lsp"];
          };
        };
        sources = {
          default = ["lsp" "path" "snippets" "buffer"]; # 补全来源优先级
        };
        fuzzy = {
          implementation = "rust"; # 使用 rust 实现的模糊匹配算法
        };

        # cmdline 的补全行为
        cmdline = {
          enabled = true;
          keymap = {
            preset = "cmdline";
            "<Right>" = false;
            "<Left>" = false;
          };
          completion = {
            list.selection.preselect = false; # 不会自动选择
            menu = {
              # 自动显示菜单
              auto_show.__raw = ''
                function(ctx)
                  return vim.fn.getcmdtype() == ":"
                end
              '';
            };
            ghost_text.enabled = true; # 在行内显示灰色预览文本
          };
        };
      };
    };
  };
}
