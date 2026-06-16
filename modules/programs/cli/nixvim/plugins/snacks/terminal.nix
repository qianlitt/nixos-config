# terminal - 终端
#
# Docs: https://github.com/folke/snacks.nvim/blob/main/docs/terminal.md
{
  flake.modules.homeManager.nixvim = let
    term_nav = dir: ''
      function(self)
        return self:is_floating() and "<c-${dir}>" or vim.schedule(function()
          vim.cmd.wincmd("${dir}")
        end)
      end
    '';

    root = ''
      vim.fs.root(0, {".git", "package.json", ".svn"}) or vim.fn.getcwd()
    '';
  in {
    programs.nixvim = {
      plugins.snacks.settings = {
        terminal.win.keys = {
          # 终端中使用 Ctrl+h/j/k/l 在窗口间导航
          nav_h = {
            __raw = ''{ "<C-h>", ${term_nav "h"}, desc = "Go to Left Window", expr = true, mode = "t" }'';
          };
          nav_j = {
            __raw = ''{ "<C-j>", ${term_nav "j"}, desc = "Go to Lower Window", expr = true, mode = "t" }'';
          };
          nav_k = {
            __raw = ''{ "<C-k>", ${term_nav "k"}, desc = "Go to Upper Window", expr = true, mode = "t" }'';
          };
          nav_l = {
            __raw = ''{ "<C-l>", ${term_nav "l"}, desc = "Go to Right Window", expr = true, mode = "t" }'';
          };

          # 隐藏终端
          hide_slash = {
            __raw = ''{ "<C-/>", "hide", desc = "Hide Terminal", mode = "t" }'';
          };
          hide_underscore = {
            __raw = ''{ "<c-_>", "hide", desc = "which_key_ignore", mode = "t" }'';
          };
        };
      };

      keymaps = [
        {
          key = "<leader>fT";
          mode = ["n"];
          action.__raw = "function() Snacks.terminal() end";
          options.desc = "Terminal (cwd)";
        }
        {
          key = "<leader>ft";
          mode = ["n"];
          action.__raw = "function() Snacks.terminal(nil, { cwd = ${root} }) end";
          options.desc = "Terminal (Root Dir)";
        }
        {
          key = "<c-/>";
          mode = ["n" "t"];
          action.__raw = "function() Snacks.terminal.focus(nil, { cwd = ${root} }) end";
          options.desc = "Terminal (Root Dir)";
        }
        {
          key = "<c-_>";
          mode = ["n" "t"];
          action.__raw = "function() Snacks.terminal.focus(nil, { cwd = ${root} }) end";
          options.desc = "which_key_ignore";
        }
      ];
    };
  };
}
