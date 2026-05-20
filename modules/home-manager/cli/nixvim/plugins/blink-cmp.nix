/**
* blink.cmp - 代码补全
*
* Home Page: https://github.com/saghen/blink.cmp
*/
{
  config,
  lib,
  ...
}: let
  inherit (config.modules.cli.nixvim) completion;
in
  lib.mkIf completion.enable {
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

            # Alt + space: 显示补全菜单
            "<M-Space>" = ["show" "show_documentation" "hide_documentation"];
            # Ctrl + y: 选中并应用
            "<C-y>" = ["select_and_accept"];
            # Tab: 显示补全菜单时，选择下一项
            "<Tab>" = [
              {
                __raw = ''
                  function(cmp)
                    if cmp.is_visible() then
                      return cmp.select_next()
                    end
                  end
                '';
              }
              "fallback"
            ];
            # Shift + Tab: 显示补全菜单时，选择上一项
            "<S-Tab>" = [
              {
                __raw = ''
                  function(cmp)
                    if cmp.is_visible() then
                      return cmp.select_prev()
                    end
                  end
                '';
              }
              "fallback"
            ];
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
            # 补全来源优先级
            default = [
              "lsp" # LSP 提供的语义级补全
              "path" # 文件路径补全
              "snippets" # 代码片段
              "buffer" # 当前所有已打开缓冲区中的已有单词补全
            ];
            providers = {
              git = {
                module = "blink-cmp-git";
                name = "git";
                score_offset = 100;
                opts = {
                  commit = {};
                  git_centers = {git_hub = {};};
                };
              };
              thesaurus = {
                name = "blink-cmp-words";
                module = "blink-cmp-words.thesaurus";
                opts = {
                  score_offset = 0;
                  definition_pointers = ["!" "&" "^"];
                  similarity_pointers = ["&" "^"];
                  similarity_depth = 2;
                };
              };
              dictionary = {
                name = "blink-cmp-words";
                module = "blink-cmp-words.dictionary";
                opts = {
                  dictionary_search_threshold = 3;
                  score_offset = 0;
                  definition_pointers = ["!" "&" "^"];
                };
              };
            };
            per_filetype = {
              gitcommit = ["git" "buffer"];
              text = ["thesaurus" "buffer"];
              markdown = ["thesaurus" "buffer"];
            };
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

      # Home Page: https://github.com/Kaiser-Yang/blink-cmp-git
      plugins.blink-cmp-git.enable = true;

      # Home Page: https://github.com/archie-judd/blink-cmp-words
      plugins.blink-cmp-words.enable = true;
    };
  }
