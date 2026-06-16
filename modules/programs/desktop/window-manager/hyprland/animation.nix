{
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.settings = {
      curve = [
        {
          _args = [
            "expressiveFastSpatial"
            {
              type = "bezier";
              points = [
                [0.42 1.67]
                [0.21 0.90]
              ];
            }
          ];
        }
        {
          _args = [
            "expressiveSlowSpatial"
            {
              type = "bezier";
              points = [
                [0.39 1.29]
                [0.35 0.98]
              ];
            }
          ];
        }
        {
          _args = [
            "expressiveDefaultSpatial"
            {
              type = "bezier";
              points = [
                [0.38 1.21]
                [0.22 1.00]
              ];
            }
          ];
        }
        {
          _args = [
            "emphasizedDecel"
            {
              type = "bezier";
              points = [
                [0.05 0.70]
                [0.10 1.00]
              ];
            }
          ];
        }
        {
          _args = [
            "emphasizedAccel"
            {
              type = "bezier";
              points = [
                [0.30 0.00]
                [0.00 0.15]
              ];
            }
          ];
        }
        {
          _args = [
            "standardDecel"
            {
              type = "bezier";
              points = [
                [0.00 0.00]
                [0.00 1.00]
              ];
            }
          ];
        }
        {
          _args = [
            "menu_decel"
            {
              type = "bezier";
              points = [
                [0.10 1.00]
                [0.00 1.00]
              ];
            }
          ];
        }
        {
          _args = [
            "menu_accel"
            {
              type = "bezier";
              points = [
                [0.52 0.03]
                [0.72 0.08]
              ];
            }
          ];
        }
        {
          _args = [
            "stall"
            {
              type = "bezier";
              points = [
                [1.00 (-0.1)]
                [0.70 0.85]
              ];
            }
          ];
        }
      ];
      animation = [
        # windows
        {
          leaf = "windowsIn"; # 窗口打开
          enabled = true;
          speed = 3;
          bezier = "emphasizedDecel";
          style = "popin 80%";
        }
        {
          leaf = "fadeIn"; # 渐淡窗口打开
          enabled = true;
          speed = 3;
          bezier = "emphasizedDecel";
        }
        {
          leaf = "windowsOut"; # 窗口关闭
          enabled = true;
          speed = 2;
          bezier = "emphasizedDecel";
          style = "popin 90%";
        }
        {
          leaf = "fadeOut"; # 渐淡窗口关闭
          enabled = true;
          speed = 2;
          bezier = "emphasizedDecel";
        }
        {
          leaf = "windowsMove";
          enabled = true;
          speed = 3;
          bezier = "emphasizedDecel";
          style = "slide";
        }
        {
          leaf = "border";
          enabled = true;
          speed = 10;
          bezier = "emphasizedDecel";
        }

        # layers
        {
          leaf = "layersIn";
          enabled = true;
          speed = 2.7;
          bezier = "emphasizedDecel";
          style = "popin 93%";
        }
        {
          leaf = "layersOut";
          enabled = true;
          speed = 2.4;
          bezier = "menu_accel";
          style = "popin 94%";
        }
        {
          leaf = "fadeLayersIn";
          enabled = true;
          speed = 0.5;
          bezier = "menu_decel";
        }
        {
          leaf = "fadeLayersOut";
          enabled = true;
          speed = 2.7;
          bezier = "stall";
        }

        # workspaces
        {
          leaf = "workspaces";
          enabled = true;
          speed = 7;
          bezier = "menu_decel";
          style = "slide";
        }

        # zoom
        {
          leaf = "zoomFactor";
          enabled = true;
          speed = 3;
          bezier = "standardDecel";
        }
      ];
    };
  };
}
