/**
* snacks.nvim - 插件合集
*
* Home Page: https://github.com/folke/snacks.nvim
*/
{mylib, ...}: {
  imports = mylib.scanModules ./.;

  programs.nixvim = {
    plugins.snacks = {
      enable = true;

      settings = {
        bigfile.enabled = true; # 对大文件优化
        indent.enabled = false; # 缩进线
        input.enabled = true; # 输入框
        notifier.enabled = true; # 通知
        quickfile.enabled = true; # 尽快加载文件
        scope.enabled = true; # 检测当前行所属的 scope
        scroll.enabled = true; # 平滑滚动
        statuscolumn.enabled = true; # 状态栏
        words.enabled = true; # LSP 引用查看和跳转
      };
    };

    keymaps = [
      # stratch - 临时缓冲区
      # Docs: https://github.com/folke/snacks.nvim/blob/main/docs/scratch.md
      {
        key = "<leader>.";
        action.__raw = "function() Snacks.scratch() end";
        options.desc = "Toggle Scratch Buffer";
      }
      {
        key = "<leader>S";
        action.__raw = "function() Snacks.scratch.select() end";
        options.desc = "Select Scratch Buffer";
      }

      # notifier
      {
        key = "<leader>un";
        action.__raw = "function() Snacks.notifier.hide() end";
        options.desc = "Dismiss All Notifications";
      }
    ];
  };
}
