{
  config,
  lib,
  pkgs,
  inputs,
  myvar,
  ...
}: let
  cfg = config.modules.nixos.windowManager.hyprland;

  hyprlandPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
in {
  options.modules.nixos.windowManager.hyprland = {
    enable = lib.mkEnableOption "启用 Hyprland 窗口管理器";

    user = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "启用 Hyprland 的用户";
    };
  };

  config = lib.mkIf cfg.enable {
    #  NixOS 配置
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

    #  Home Manager 配置
    assertions = [
      {
        assertion = cfg.user != null;
        message = "必须为 Hyprland 的 home-manager 配置指定用户名";
      }
    ];
    home-manager.users.${cfg.user} = {
      wayland.windowManager.hyprland = {
        enable = true;

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

      programs.kitty.enable = true; # 确保进入 Hyprland 时有终端可用
    };
  };
}
