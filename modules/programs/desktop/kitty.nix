# kitty
# Docs: https://sw.kovidgoyal.net/kitty
{
  flake.modules.homeManager.kitty = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.modules.desktop.terminal.kitty;
  in {
    options.modules.desktop.terminal.kitty = {
      enable = lib.mkEnableOption "安装和配置 kitty 终端模拟器";
    };

    config = lib.mkIf cfg.enable {
      programs.kitty = {
        enable = true;

        shellIntegration = {
          mode = "no-rc";
          enableBashIntegration = true;
          enableFishIntegration = true;
          enableZshIntegration = true;
        };

        font = lib.mkDefault {
          name = "Maple Mono NF CN";
          package = pkgs.maple-mono.NF-CN-unhinted;
          size = 12;
        };

        # `ctrl+shift+f3` 查看所有映射
        keybindings = {
          # == Layout ==
          "alt+f4" = "launch --location=split"; # 分割
          "alt+f5" = "launch --location=hsplit"; # 水平分割
          "alt+f6" = "launch --location=vsplit"; # 垂直分割
        };

        settings = {
          # == 文本光标 ==
          # 光标轨迹动画
          cursor_trail = 3;

          # == 鼠标 ==
          # 选中即复制
          copy_on_select = "clipboard"; # 复制到剪贴板
          # 剪贴板内容失效后，清除 kitty 的的选区
          clear_selection_on_clipboard_loss = "yes";

          # == 窗口 ==
          # 窗口边距
          #                      上 右 下 左
          window_margin_width = "10 10  0 10";

          # == Tab bar ==
          # tab bar 的位置
          tab_bar_edge = "top";
          # tab bar 风格
          tab_bar_style = "powerline";
          tab_powerline_style = "slanted";

          # == 布局 ==
          enabled_layouts = "splits,horizontal,vertical";
        };

        # 快速访问终端
        quickAccessTerminalConfig = {
          hide_on_focus_loss = "yes"; # 窗口失焦后隐藏
        };
      };
    };
  };
}
