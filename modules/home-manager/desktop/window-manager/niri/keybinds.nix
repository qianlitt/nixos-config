{config, ...}: let
  terminal = {
    program = "kitty";
    key = "Mod+Q";
  };
  browser = {
    program = "chromium";
    key = "Mod+W";
  };
  editor = {
    program = "code";
    key = "Mod+D";
  };
  music = {
    program = "spotify";
    key = "Mod+A";
  };
  fileManager = {
    program = "dolphin";
    key = "Mod+E";
  };
in {
  programs.niri.settings.binds = with config.lib.niri.actions; {
    # Mod-Shift-/ 快捷键列表
    "Mod+Shift+Slash".action = show-hotkey-overlay;
    # Open/close the Overview
    "Mod+O".action = toggle-overview;
    "Mod+Tab".action = toggle-overview;

    # Apps
    "${terminal.key}" = {
      action = spawn terminal.program;
      hotkey-overlay.title = "Terminal: <b>${terminal.program}</b>";
    };
    "Mod+Return".action = spawn terminal.program;
    "Mod+Z".action = spawn-sh "kitten quick-access-terminal";
    "${browser.key}" = {
      action = spawn browser.program;
      hotkey-overlay.title = "Browser: <b>${browser.program}</b>";
    };
    "${editor.key}" = {
      action = spawn editor.program;
      hotkey-overlay.title = "Editor: <b>${editor.program}</b>";
    };
    "${music.key}" = {
      action = spawn-sh music.program;
      hotkey-overlay.title = "Music: <b>${music.program}</b>";
    };
    "${fileManager.key}" = {
      action = spawn-sh fileManager.program;
      hotkey-overlay.title = "File Manager: <b>${fileManager.program}</b>";
    };

    # Column & window
    "Super+C".action = close-window; # 关闭当前聚焦的窗口

    "Mod+Left".action = focus-column-left; # 移焦点
    "Mod+Down".action = focus-window-down;
    "Mod+Up".action = focus-window-up;
    "Mod+Right".action = focus-column-right;
    "Mod+H".action = focus-column-left;
    "Mod+J".action = focus-window-down;
    "Mod+K".action = focus-window-up;
    "Mod+L".action = focus-column-right;

    "Mod+Ctrl+Left".action = move-column-left; # 移窗口
    "Mod+Ctrl+Down".action = move-window-down;
    "Mod+Ctrl+Up".action = move-window-up;
    "Mod+Ctrl+Right".action = move-column-right;
    "Mod+Ctrl+H".action = move-column-left;
    "Mod+Ctrl+J".action = move-window-down;
    "Mod+Ctrl+K".action = move-window-up;
    "Mod+Ctrl+L".action = move-column-right;

    "Mod+Home".action = focus-column-first; # 头尾
    "Mod+End".action = focus-column-last;
    "Mod+Ctrl+Home".action = move-column-to-first;
    "Mod+Ctrl+End".action = move-column-to-last;

    "Mod+Shift+Left".action = focus-monitor-left; # 焦点在显示器间移动
    "Mod+Shift+Down".action = focus-monitor-down;
    "Mod+Shift+Up".action = focus-monitor-up;
    "Mod+Shift+Right".action = focus-monitor-right;
    "Mod+Shift+H".action = focus-monitor-left;
    "Mod+Shift+J".action = focus-monitor-down;
    "Mod+Shift+K".action = focus-monitor-up;
    "Mod+Shift+L".action = focus-monitor-right;

    "Mod+Shift+Ctrl+Left".action = move-column-to-monitor-left; # 列在显示器间移动
    "Mod+Shift+Ctrl+Down".action = move-column-to-monitor-down;
    "Mod+Shift+Ctrl+Up".action = move-column-to-monitor-up;
    "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;
    "Mod+Shift+Ctrl+H".action = move-column-to-monitor-left;
    "Mod+Shift+Ctrl+J".action = move-column-to-monitor-down;
    "Mod+Shift+Ctrl+K".action = move-column-to-monitor-up;
    "Mod+Shift+Ctrl+L".action = move-column-to-monitor-right;

    "Mod+Page_Down".action = focus-workspace-down; # 焦点在工作区间移动
    "Mod+Page_Up".action = focus-workspace-up;
    "Mod+U".action = focus-workspace-up;
    "Mod+I".action = focus-workspace-down;
    "Mod+Ctrl+Page_Down".action = move-column-to-workspace-down; # 列在工作区间移动
    "Mod+Ctrl+Page_Up".action = move-column-to-workspace-up;
    "Mod+Ctrl+U".action = move-column-to-workspace-up;
    "Mod+Ctrl+I".action = move-column-to-workspace-down;

    "Mod+Shift+Page_Down".action = move-workspace-down;
    "Mod+Shift+Page_Up".action = move-workspace-up;
    "Mod+Shift+U".action = move-workspace-down;
    "Mod+Shift+I".action = move-workspace-up;

    "Mod+WheelScrollDown" = {
      action = focus-workspace-down; # 鼠标滚轮移动工作区焦点
      cooldown-ms = 150;
    };
    "Mod+WheelScrollUp" = {
      action = focus-workspace-up;
      cooldown-ms = 150;
    };
    "Mod+Ctrl+WheelScrollDown" = {
      action = move-column-to-workspace-down; # 鼠标滚轮在工作区间移动列
      cooldown-ms = 150;
    };
    "Mod+Ctrl+WheelScrollUp" = {
      action = move-column-to-workspace-up;
      cooldown-ms = 150;
    };

    "Mod+WheelScrollRight".action = focus-column-right; # 鼠标滚轮左右滚动
    "Mod+WheelScrollLeft".action = focus-column-left;
    "Mod+Ctrl+WheelScrollRight".action = move-column-right;
    "Mod+Ctrl+WheelScrollLeft".action = move-column-left;

    "Mod+Shift+WheelScrollDown".action = focus-column-right; # 鼠标滚轮移动列焦点
    "Mod+Shift+WheelScrollUp".action = focus-column-left;
    "Mod+Ctrl+Shift+WheelScrollDown".action = move-column-right; # 鼠标滚轮移动列
    "Mod+Ctrl+Shift+WheelScrollUp".action = move-column-left;

    "Mod+1".action = focus-workspace 1; # 工作区焦点
    "Mod+2".action = focus-workspace 2;
    "Mod+3".action = focus-workspace 3;
    "Mod+4".action = focus-workspace 4;
    "Mod+5".action = focus-workspace 5;
    "Mod+6".action = focus-workspace 6;
    "Mod+7".action = focus-workspace 7;
    "Mod+8".action = focus-workspace 8;
    "Mod+9".action = focus-workspace 9;
    "Mod+Ctrl+1".action.move-column-to-workspace = [1]; # 移动列到工作区
    "Mod+Ctrl+2".action.move-column-to-workspace = [2];
    "Mod+Ctrl+3".action.move-column-to-workspace = [3];
    "Mod+Ctrl+4".action.move-column-to-workspace = [4];
    "Mod+Ctrl+5".action.move-column-to-workspace = [5];
    "Mod+Ctrl+6".action.move-column-to-workspace = [6];
    "Mod+Ctrl+7".action.move-column-to-workspace = [7];
    "Mod+Ctrl+8".action.move-column-to-workspace = [8];
    "Mod+Ctrl+9".action.move-column-to-workspace = [9];

    # Mod+[ or Mod+]
    "Mod+BracketLeft".action = consume-or-expel-window-left;
    "Mod+BracketRight".action = consume-or-expel-window-right;

    # Mod+, 移动一个窗口到列中（类似水平分割）
    "Mod+Comma".action = consume-window-into-column;
    # Mod+.
    "Mod+Period".action = expel-window-from-column;

    "Mod+R".action = switch-preset-column-width; # 切换预设列宽
    "Mod+Shift+R".action = switch-preset-window-height; # 切换窗口宽度
    "Mod+Ctrl+R".action = reset-window-height; # 恢复窗口宽度
    "Mod+F".action = maximize-column; # 最大化列
    "Mod+Shift+F".action = fullscreen-window; # 全屏
    "Mod+Ctrl+F".action = expand-column-to-available-width; # 列占满宽度
    "Mod+C".action = center-column; # 列居中
    "Mod+Ctrl+C".action = center-visible-columns; # 所有可见列放到屏幕中央

    # Mod+- or Mod+=
    "Mod+Minus".action = set-column-width "-10%";
    "Mod+Equal".action = set-column-width "+10%";
    # Mod+Shift+- or Mod+Shift+=
    "Mod+Shift+Minus".action = set-window-height "-10%";
    "Mod+Shift+Equal".action = set-window-height "+10%";

    "Mod+V".action = toggle-window-floating;
    "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;

    # column 有两种显示方式：
    # 1. normal: column 垂直并排
    # 2. tabbed: column 上下排列，只能看见聚焦窗口（最上面的）
    "Mod+Shift+N".action = toggle-column-tabbed-display;

    # 截图
    "Print".action.screenshot = {};
    "Super+Shift+S".action.screenshot = {};
    "Mod+Print".action.screenshot-screen = {show-pointer = false;};
    "Super+Ctrl+Shift+S".action.screenshot-screen = {show-pointer = false;};

    "Mod+Shift+E".action = quit;
    "Mod+Shift+P".action = power-off-monitors;
  };
}
