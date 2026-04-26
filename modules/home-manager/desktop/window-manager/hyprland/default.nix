{
  config,
  lib,
  osConfig,
  mylib,
  ...
}: let
  cfg = config.modules.desktop.windowManager.hyprland;

  nixosHyprlandEnabled = osConfig.modules.desktop.windowManager.hyprland.enable;
in {
  imports = mylib.scanModules ./.;

  options.modules.desktop.windowManager.hyprland = {
    enable = lib.mkEnableOption "启用 Hyprland 窗口管理器";

    quickshell = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "在 Hyprland 中启用一些 quickshell 配置";
    };

    layout = lib.mkOption {
      type = lib.types.enum ["dwindle" "master" "scrolling" "scrolling"];
      default = "dwindle";
      description = "Hyprland 的布局";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = nixosHyprlandEnabled;
        message = ''
          Home Manager 的 Hyprland 配置已启用，但对应的 NixOS 模块未启用。
          请在你的 NixOS 配置中添加：
            modules.desktop.windowManager.hyprland.enable = true;
        '';
      }
    ];

    wayland.windowManager.hyprland = {
      enable = true;

      settings = {
        general = {
          layout = cfg.layout;
          gaps_workspaces = "20";
          gaps_in = "10";
          gaps_out = "20";
          border_size = "3";

          "col.active_border" = lib.mkDefault "rgba(c2c1ffe6)"; # 活动窗口的边框颜色
          "col.inactive_border" = lib.mkDefault "rgba(c8c5d111)"; # 非活动窗口的边框颜色
        };

        input = {
          kb_layout = "us"; # 键盘布局
          numlock_by_default = true; # 默认开启 NumLock
          repeat_delay = 250; # 键盘重复的延迟（毫秒）
          repeat_rate = 35; # 键盘重复的速率（每秒重复次数）

          follow_mouse = "1"; # 光标与焦点关系

          touchpad = {
            natural_scroll = true; # 反转滚动方向
            disable_while_typing = true; # 打字时禁用触摸板
            scroll_factor = 0.7; # 滚动速度因子
          };
        };

        gesture = [
          "3, swipe, move" # 三指滑动 → 切换窗口
          "3, pinch, float" # 三指捏合 → 切换窗口浮动/平铺
          "4, horizontal, workspace" # 四指水平滑动 → 切换到 相邻工作区。
        ];

        gestures = {
          workspace_swipe_distance = 700;
          workspace_swipe_cancel_ratio = "0.2";
          workspace_swipe_min_speed_to_force = 5;
          workspace_swipe_direction_lock = true;
          workspace_swipe_direction_lock_threshold = 10;
          workspace_swipe_create_new = true;
        };

        misc = {
          disable_hyprland_logo = true; # 禁止显示 Hyprland logo
          disable_splash_rendering = true; # 禁止显示启动画面
          focus_on_activate = true;
        };
      };
    };

    programs.kitty.enable = true; # 确保进入 Hyprland 时有终端可用
  };
}
