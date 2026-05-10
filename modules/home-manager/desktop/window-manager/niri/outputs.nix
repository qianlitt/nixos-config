{
  config,
  lib,
  ...
}: let
  cfg = config.modules.desktop.windowManager.niri;

  mkNiriOutputs = monitors:
    lib.mapAttrs (name: m: {
      mode = {
        width = m.width;
        height = m.height;
        refresh = m.refreshRate;
      };
      scale = m.scale;
      position = {
        x = m.position.x;
        y = m.position.y;
      };
      focus-at-startup = m.primaryMonitor or false;
    })
    monitors;
in {
  options.modules.desktop.windowManager.niri = {
    monitors = lib.mkOption {
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
            description = "是否设为启动时聚焦的显示器 (Niri 没有 primary 概念)";
          };
        };
      });
      default = {};
      description = "显示器配置集合，键为输出端口名称 (如 eDP-2, DP-3)";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.niri.settings.outputs = mkNiriOutputs cfg.monitors;
  };
}
