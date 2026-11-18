{
  flake.factory.hyprlandMonitors = {monitors}: {lib, ...}: let
    # 用局部模块系统校验显示器数据并应用默认值，
    # 不向 HM/NixOS 注册任何 modules.* 选项。
    schema = lib.evalModules {
      modules = [
        {
          options.monitors = lib.mkOption {
            type = lib.types.attrsOf (lib.types.submodule {
              options = {
                width = lib.mkOption {
                  type = lib.types.int;
                  description = "显示器宽度 (像素)";
                };
                height = lib.mkOption {
                  type = lib.types.int;
                  description = "显示器高度 (像素)";
                };
                refreshRate = lib.mkOption {
                  type = lib.types.either lib.types.int lib.types.float;
                  description = "刷新率 (Hz)";
                };
                scale = lib.mkOption {
                  type = lib.types.either lib.types.int lib.types.float;
                  default = 1.0;
                  description = "显示缩放比例";
                };
                position = lib.mkOption {
                  type = lib.types.submodule {
                    options = {
                      x = lib.mkOption {
                        type = lib.types.int;
                        default = 0;
                      };
                      y = lib.mkOption {
                        type = lib.types.int;
                        default = 0;
                      };
                    };
                  };
                  default = {
                    x = 0;
                    y = 0;
                  };
                  description = "显示器在布局中的坐标位置";
                };
                primaryMonitor = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                  description = ''
                    是否设为启动时聚焦的显示器

                    Hyprland 没有主显示器的概念，可以配置启动时光标默认所处的显示器。
                  '';
                };
              };
            });
            default = {};
            description = "显示器配置集合，键为输出端口名称 (如 eDP-2, DP-3)";
          };
        }
        {config.monitors = monitors;}
      ];
    };

    cfg = schema.config;

    mkHyprMonitors = monitors:
      lib.mapAttrsToList (name: m: {
        output = name;
        mode = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
        position = "${toString m.position.x}x${toString m.position.y}";
        inherit (m) scale;
      })
      monitors;

    primaryMonitorName = let
      candidates = lib.filter (name: cfg.monitors.${name}.primaryMonitor) (lib.attrNames cfg.monitors);
    in
      lib.optionalString (candidates != []) (lib.head candidates);
  in {
    wayland.windowManager.hyprland.settings = {
      monitor = mkHyprMonitors cfg.monitors;
      config.cursor.default_monitor = lib.mkIf (primaryMonitorName != "") primaryMonitorName;
    };
  };
}
