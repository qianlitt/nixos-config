{inputs, ...}: {
  flake-file.inputs = {
    niri.url = "github:sodiboo/niri-flake/3754a033e05c750ef46fe4f078d79b826c4f9287";
  };

  flake.modules.nixos.niri = {pkgs, ...}: {
    # 二进制缓存命中需要:
    # 1. 导入 niri 的 NixOS 模块: `niri.nixosModules.niri`。
    # 2. 第一次重建时不启用 niri，让缓存配置生效后再正式启用。
    #   - `programs.niri.enable = false;` 构建一次。
    #   - `programs.niri.enable = true;` 再次构建时可发现二进制缓存生效（niri 包完全从缓存服务器中下载，本地 CPU 无负载）。
    imports = [
      inputs.niri.nixosModules.niri
    ];

    # 使用 niri-unstable（需要 overlay）
    nixpkgs.overlays = [inputs.niri.overlays.niri];
    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable; # 或 pkgs.niri
    };
  };

  flake.modules.homeManager.niri = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.modules.desktop.windowManager.niri;
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
      # 请确保已导入 `flake.modules.nixos.niri`
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
