{inputs, ...}: {
  flake-file.inputs = {
    hyprland.url = "github:hyprwm/Hyprland";
  };

  flake.modules.nixos.hyprland = {
    lib,
    pkgs,
    ...
  }: let
    hyprlandPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  in {
    programs.hyprland = {
      enable = true;
      package = hyprlandPackage;
      inherit portalPackage;
    };
    # 缓存配置
    nix.settings = {
      substituters = lib.mkOrder 600 ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
  };

  flake.modules.homeManager.hyprland = {
    lib,
    pkgs,
    ...
  }: {
    wayland.windowManager.hyprland = {
      enable = true;

      settings = {
        config = {
          xwayland.force_zero_scaling = true;

          general = {
            layout = lib.mkDefault "scrolling";
            gaps_workspaces = 20;
            gaps_in = 10;
            gaps_out = 20;
            border_size = 3;

            "col.active_border" = lib.mkDefault "rgba(c2c1ffe6)"; # 活动窗口的边框颜色
            "col.inactive_border" = lib.mkDefault "rgba(c8c5d111)"; # 非活动窗口的边框颜色
          };

          input = {
            kb_layout = "us"; # 键盘布局
            numlock_by_default = true; # 默认开启 NumLock
            repeat_delay = 250; # 键盘重复的延迟（毫秒）
            repeat_rate = 35; # 键盘重复的速率（每秒重复次数）

            follow_mouse = 2; # 光标与焦点关系

            touchpad = {
              natural_scroll = true; # 反转滚动方向
              disable_while_typing = true; # 打字时禁用触摸板
              scroll_factor = 0.7; # 滚动速度因子
            };
          };
        };

        gesture = [
          {
            # 三指滑动 → 切换窗口
            fingers = 3;
            direction = "swipe";
            action = "move";
          }
          {
            # 三指捏合 → 切换窗口浮动/平铺
            fingers = 3;
            direction = "pinch";
            action = "float";
          }
          {
            # 四指水平滑动 → 切换到相邻工作区
            fingers = 4;
            direction = "horizontal";
            action = "workspace";
          }
        ];

        config.gestures = {
          workspace_swipe_distance = 700;
          workspace_swipe_cancel_ratio = "0.2";
          workspace_swipe_min_speed_to_force = 5;
          workspace_swipe_direction_lock = true;
          workspace_swipe_direction_lock_threshold = 10;
          workspace_swipe_create_new = true;
        };

        config.misc = {
          disable_hyprland_logo = true; # 禁止显示 Hyprland logo
          disable_splash_rendering = true; # 禁止显示启动画面
          focus_on_activate = true;
        };
      };
    };

    programs = {
      kitty.enable = true; # 确保进入 Hyprland 时有终端可用

      # 截图标注
      swappy = {
        enable = true;
        settings.Default = {
          save_dir = "$HOME/Pictures/Screenshots";
          save_filename_format = "swappy-%Y%m%d-%H%M%S.png";
        };
      };
    };

    home.packages = with pkgs; [
      libnotify

      # 截图
      hyprshot # Hyprland 截图工具
      grim # 截图
      slurp # 区域选择
    ];
  };
}
