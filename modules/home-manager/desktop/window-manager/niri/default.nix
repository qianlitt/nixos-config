{
  config,
  lib,
  pkgs,
  osConfig,
  mylib,
  ...
}: let
  cfg = config.modules.desktop.windowManager.niri;

  nixosNiriEnabled = osConfig.modules.desktop.windowManager.niri.enable;
in {
  imports = mylib.scanModules ./.;

  options.modules.desktop.windowManager.niri = {
    enable = lib.mkEnableOption "启用 Niri 窗口管理器";

    quickshell = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "在 Niri 中启用一些 quickshell 配置";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = nixosNiriEnabled;
        message = ''
          Home Manager 的 Niri 配置已启用，但对应的 NixOS 模块未启用，它会配置二进制缓存并安装必要的组件。
          请在你的 NixOS 配置中添加：
            modules.desktop.windowManager.niri.enable = true;
        '';
      }
    ];

    programs.niri.settings = {
      xwayland-satellite.path = "${lib.getExe pkgs.xwayland-satellite-unstable}";

      prefer-no-csd = true; # 禁止 CSD，让 Niri 负责窗口装饰

      input = {
        # focus-follows-mouse.enable = true; # 焦点跟随鼠标
        keyboard = {
          numlock = true;
          track-layout = "window";
        };
      };
    };

    programs.kitty.enable = true; # 确保进入 Niri 时有终端可用
  };
}
