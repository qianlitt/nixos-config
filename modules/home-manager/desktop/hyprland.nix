{
  pkgs,
  inputs,
  ...
}: let
  hyprlandPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
in {
  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprlandPackage;
    portalPackage = portalPackage;

    extraConfig = ''
      $mainMod = SUPER

      bind = $mainMod, Q, exec, kitty
      bind = $mainMod, C, killactive,
      bind = $mainMod, M, exec, command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit
      bind = $mainMod, D, exec, code
      bind = $mainMod, W, exec, chromium

      exec-once=fcitx5 -d
    '';
  };

  programs.kitty.enable = true;
}
