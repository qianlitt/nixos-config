{inputs, ...}: {
  flake-file.inputs = {
    niri.url = "github:sodiboo/niri-flake";
  };

  flake.modules.nixos.niri = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.modules.desktop.windowManager.niri;
  in {
    # 二进制缓存命中需要:
    # 1. 导入 niri 的 NixOS 模块: `niri.nixosModules.niri`。
    # 2. 第一次重建时不启用 niri，让缓存配置生效后再正式启用。
    #   - `programs.niri.enable = false;` 构建一次。
    #   - `programs.niri.enable = true;` 再次构建时可发现二进制缓存生效（niri 包完全从缓存服务器中下载，本地 CPU 无负载）。
    imports = [
      inputs.niri.nixosModules.niri
    ];

    options.modules.desktop.windowManager.niri = {
      enable = lib.mkEnableOption "启用 niri 窗口管理器";
    };

    config = lib.mkIf cfg.enable {
      # 使用 niri-unstable（需要 overlay）
      nixpkgs.overlays = [inputs.niri.overlays.niri];
      programs.niri = {
        enable = true;
        package = pkgs.niri-unstable; # 或 pkgs.niri
      };
    };
  };

  flake.modules.homeManager.niri = {
    config,
    lib,
    pkgs,
    osConfig,
    ...
  }: let
    cfg = config.modules.desktop.windowManager.niri;

    nixosNiriEnabled = osConfig.modules.desktop.windowManager.niri.enable;
  in {
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
  };
}
