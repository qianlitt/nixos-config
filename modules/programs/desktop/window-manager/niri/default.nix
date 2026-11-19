{inputs, ...}: {
  flake-file.inputs = {
    niri.url = "github:epireyn/niri-flake";
  };

  flake.modules.nixos.niri = {
    lib,
    pkgs,
    ...
  }: {
    # 二进制缓存命中需要:
    # 1. 导入 niri 的 NixOS 模块: `niri.nixosModules.niri`。
    # 2. 第一次重建时不启用 niri，让缓存配置生效后再正式启用。
    #   - `programs.niri.enable = false;` 构建一次。
    #   - `programs.niri.enable = true;` 再次构建时可发现二进制缓存生效（niri 包完全从缓存服务器中下载，本地 CPU 无负载）。
    imports = [
      inputs.niri.nixosModules.niri
    ];

    # 缓存配置
    niri-flake.cache.enable = false;
    nix.settings = {
      substituters = lib.mkOrder 600 ["https://niri-epireyn.cachix.org"];
      trusted-public-keys = ["niri-epireyn.cachix.org-1:tlVyFN7CtsDT+ZcLPS+ekFWeT1X6X4OqvWqbBMyIzFA="];
    };

    # 使用 niri-unstable（需要 overlay）
    nixpkgs.overlays = [inputs.niri.overlays.niri];
    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable; # 或 pkgs.niri
    };
  };

  flake.modules.homeManager.niri = {
    lib,
    pkgs,
    ...
  }: {
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
