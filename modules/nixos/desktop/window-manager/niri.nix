{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.modules.desktop.windowManager.niri;
in {
  /**
  * 二进制缓存命中需要:
  * 1. 导入 niri 的 NixOS 模块: `niri.nixosModules.niri`。
  * 2. 第一次重建时不启用 niri，让缓存配置生效后再正式启用。
  *   - `programs.niri.enable = false;` 构建一次。
  *   - `programs.niri.enable = true;` 再次构建时可发现二进制缓存生效（niri 包完全从缓存服务器中下载，本地 CPU 无负载）。
  */
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
}
