{
  config,
  lib,
  ...
}: let
  cfg = config.modules.windowManager.hyprland;

  ipc = "noctalia-shell ipc call";

  # Misc
  kbControlCenter = "Super, S";
  kbSettings = "Super, Comma";
  kbLock = "Super, L";

  # Workspaces
  kbMoveWinToWs = "Super+Alt";
  kbGoToWs = "Super";

  kbNextWs = "Ctrl+Super, right";
  kbPrevWs = "Ctrl+Super, left";

  # Window actions
  kbMoveWindow = "Super, Z";
  kbResizeWindow = "Super, X";
  kbWindowFullscreen = "Super, F";
  kbWindowBorderedFullscreen = "Super+Alt, F";
  kbToggleWindowFloating = "Super+Alt, Space";
  kbCloseWindow = "Super, C";

  # Apps
  kbTerminal = "Super, Q";
  kbBrowser = "Super, W";
  kbEditor = "Super, D";
  kbFileExplorer = "Super, E";
  kbMusicApp = "Super, A";
in {
  config = lib.mkIf cfg.enable {
    home-manager.users.${cfg.user}.wayland.windowManager.hyprland.extraConfig = ''
      $mainMod = SUPER

      # quickshell
      bind = SUPER, Super_L, exec, ${ipc} launcher toggle
      bind = SUPER, Super_R, exec, ${ipc} launcher toggle
      bind = ${kbControlCenter}, exec, ${ipc} controlCenter toggle
      bind = ${kbSettings}, exec, ${ipc} settings toggle
      bind = ${kbLock}, exec, ${ipc} lockScreen lock

      # Media
      bindel = , XF86AudioRaiseVolume, exec, ${ipc} volume increase
      bindel = , XF86AudioLowerVolume, exec, ${ipc} volume decrease
      bindl = , XF86AudioMute, exec, ${ipc} volume muteOutput
      bindel = , XF86MonBrightnessUp, exec, ${ipc} brightness increase
      bindel = , XF86MonBrightnessDown, exec, ${ipc} brightness decrease

      # Go to workspace
      bind = ${kbGoToWs}, 1, workspace, 1
      bind = ${kbGoToWs}, 2, workspace, 2
      bind = ${kbGoToWs}, 3, workspace, 3
      bind = ${kbGoToWs}, 4, workspace, 4
      bind = ${kbGoToWs}, 5, workspace, 5
      bind = ${kbGoToWs}, 6, workspace, 6
      bind = ${kbGoToWs}, 7, workspace, 7
      bind = ${kbGoToWs}, 8, workspace, 8
      bind = ${kbGoToWs}, 9, workspace, 9
      bind = ${kbGoToWs}, 0, workspace, 10
      # Go to workspace -1/+1
      bind = $mainMod, mouse_down, workspace, -1
      bind = $mainMod, mouse_up, workspace, +1
      bind = ${kbPrevWs}, workspace, -1
      bind = ${kbNextWs}, workspace, +1
      binde = Super, Page_Up, workspace, -1
      binde = Super, Page_Down, workspace, +1
      # Move focused window to workspace -1/+1
      binde = ${kbMoveWinToWs}, Page_Up, movetoworkspace, -1
      binde = ${kbMoveWinToWs}, Page_Down, movetoworkspace, +1
      bind = ${kbMoveWinToWs}, mouse_down, movetoworkspace, -1
      bind = ${kbMoveWinToWs}, mouse_up, movetoworkspace, +1
      binde = Ctrl+Super+Shift, right, movetoworkspace, +1
      binde = Ctrl+Super+Shift, left, movetoworkspace, -1

      # Window actions
      bind = SUPER, left, movefocus, l
      bind = SUPER, right, movefocus, r
      bind = SUPER, up, movefocus, u
      bind = SUPER, down, movefocus, d
      bind = Super+Shift, left, movewindow, l
      bind = Super+Shift, right, movewindow, r
      bind = Super+Shift, up, movewindow, u
      bind = Super+Shift, down, movewindow, d
      binde = Super, Minus, splitratio, -0.1
      binde = Super, Equal, splitratio, 0.1
      bindm = Super, mouse:272, movewindow    # Super+左键：移动窗口
      bindm = ${kbMoveWindow}, movewindow
      bindm = Super, mouse:273, resizewindow  # Super+右键：改变窗口大小
      bindm = ${kbResizeWindow}, resizewindow
      bind = ${kbWindowFullscreen}, fullscreen, 0
      bind = ${kbWindowBorderedFullscreen}, fullscreen, 1  # Fullscreen with borders
      bind = ${kbToggleWindowFloating}, togglefloating,

      # Apps
      bind = ${kbTerminal}, exec, kitty
      bind = $mainMod, Return, exec, kitty
      bind = ${kbEditor}, exec, code
      bind = ${kbBrowser}, exec, chromium
      bind = ${kbCloseWindow}, killactive,
      bind = $mainMod, M, exec, command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit
    '';
  };
}
