{pkgs, ...}: {
  programs.fish.plugins = [
    {
      /**
      * autopair.fish - 自动补全括号、引号等
      * Home Page: https://github.com/jorgebucaran/autopair.fish
      */
      name = "autopair";
      src = pkgs.fishPlugins.autopair.src;
    }
    {
      /**
      * fzf.fish - 提供 fzf 快捷键
      * Home Page: https://github.com/PatrickF1/fzf.fish
      *
      * dependencies: fish, fzf, fd, bat
      */
      name = "fzf-fish";
      src = pkgs.fishPlugins.fzf-fish.src;
    }
    {
      /**
      * puffer-fish - 文本扩展
      * Home Page: https://github.com/nickeb96/puffer-fish
      */
      name = "puffer-fish";
      src = pkgs.fishPlugins.puffer.src;
    }
    {
      /**
      * colored_man_pages.fish - 为 man 页面提供彩色输出
      * Home Page: https://github.com/PatrickF1/colored_man_pages.fish
      */
      # bug: man 页面没有颜色
      name = "colored-man-pages";
      src = pkgs.fishPlugins.colored-man-pages.src;
    }
    {
      /**
      * plugin-git - 提供 git 别名
      * Home Page: https://github.com/jhillyerd/plugin-git
      */
      name = "plugin-git";
      src = pkgs.fishPlugins.plugin-git.src;
    }
    {
      /**
      * plugin-sudope - 按两次 `esc` 添加 sudo
      * Home Page: https://github.com/oh-my-fish/plugin-sudope
      */
      name = "plugin-sudope";
      src = pkgs.fishPlugins.plugin-sudope.src;
    }
    {
      /**
      * sponge - 过滤历史
      * Home Page: https://github.com/meaningful-ooo/sponge
      */
      name = "sponge";
      src = pkgs.fishPlugins.sponge.src;
    }
  ];
}
