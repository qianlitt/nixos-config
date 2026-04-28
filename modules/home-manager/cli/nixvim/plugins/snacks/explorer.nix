/**
* explorer - 文件浏览器
*
* Docs: https://github.com/folke/snacks.nvim/blob/main/docs/explorer.md
*/
{config, ...}: let
  mkRaw = config.lib.nixvim.mkRaw;
in {
  programs.nixvim = {
    plugins.snacks.settings.explorer = {
      enabled = true;

      replace_netrw = true; # 替换 netrw
      trash = true; # 删除文件到系统回收站
    };

    keymaps = [
      {
        /**
        * 打开项目目录
        *
        * - 优先查找 ".git" 文件夹
        * - 其次查找 "package.json" 文件或目录
        * - 若都没找到，则打开当前工作目录
        */
        key = "<leader>fe";
        action = mkRaw ''
          function()
            local root = vim.fs.root(0, {".git", "package.json", ".svn"}) or vim.fn.getcwd()
            require("snacks").explorer({ cwd = root })
          end
        '';
        options.desc = "Explorer Snacks (root dir)";
      }
      {
        /**
        * 打开当前工作目录
        */
        key = "<leader>fE";
        action = mkRaw ''
          function()
            Snacks.explorer()
          end
        '';
        options.desc = "Explorer Snacks (cwd)";
      }
      {
        key = "<leader>e";
        action = "<leader>fe";
        options = {
          desc = "Explorer Snacks (root dir)";
          remap = true;
        };
      }
      {
        key = "<leader>E";
        action = "<leader>fE";
        options = {
          desc = "Explorer Snacks (cwd)";
          remap = true;
        };
      }
    ];
  };
}
