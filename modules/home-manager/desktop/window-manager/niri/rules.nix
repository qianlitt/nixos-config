{
  programs.niri.settings.workspaces = {
    "chat" = {};
    "game" = {};
    "book" = {};
    "music" = {};
  };
  programs.niri.settings.window-rules = let
    windowOpacity = 0.95;
    matchAppIDs = appIDs: map (appID: {app-id = appID;}) appIDs;
  in [
    {
      # 圆角
      geometry-corner-radius = {
        bottom-left = 10.0;
        bottom-right = 10.0;
        top-left = 10.0;
        top-right = 10.0;
      };
      clip-to-geometry = true; # 将窗口内容裁剪为圆角
      draw-border-with-background = false;
    }
    {
      # 焦点窗口不透明
      matches = [{is-focused = true;}];
      opacity = 1.0;
    }
    {
      # 非焦点窗口半透明
      matches = [
        {is-focused = false;}
      ];
      opacity = windowOpacity;
    }

    # App
    {
      # 终端
      matches = matchAppIDs [
        "alacritty"
        "foot"
        "ghostty"
        "kitty"
      ];
      open-maximized = true; # 最大化列
    }
    {
      # 视频播放器
      matches = matchAppIDs ["mpv"];
      open-fullscreen = true; # 全屏
    }
    {
      # 图片浏览器
      matches = matchAppIDs ["org.nomacs.ImageLounge"];
      open-maximized = true; # 最大化列
      open-floating = true; # 浮动窗口
    }
    {
      matches = matchAppIDs ["steam"];
      open-fullscreen = true;
      open-on-workspace = "game";
      open-focused = true;
    }
    {
      matches = matchAppIDs [
        "calibre-gui"
        "calibre-ebook-edit"
        "calibre-ebook-viewer"
      ];
      default-window-height.proportion = 1.0;
      default-column-width.proportion = 1.0;
      open-on-workspace = "book";
      open-focused = true;
    }
    {
      # 聊天工具
      matches = matchAppIDs [
        "org.telegram.desktop"
        "vesktop"
      ];
      default-window-height.proportion = 1.0;
      default-column-width.proportion = 1.0;
      open-on-workspace = "chat";
      open-focused = true;
    }
    {
      # 音乐播放器
      matches = matchAppIDs ["spotify"];
      default-window-height.proportion = 1.0;
      default-column-width.proportion = 1.0;
      open-on-workspace = "music";
    }
  ];
}
