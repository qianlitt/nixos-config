{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.modules.desktop.windowManager.hyprland;

  hyprlandPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
in {
  options.modules.desktop.windowManager.hyprland = {
    enable = lib.mkEnableOption "启用 Hyprland 窗口管理器";
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      package = hyprlandPackage;
      portalPackage = portalPackage;
    };
    # 添加 Hyprland cachix
    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
  };
}
