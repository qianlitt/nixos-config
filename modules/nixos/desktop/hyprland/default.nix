{
  config,
  lib,
  pkgs,
  inputs,
  mylib,
  ...
}: let
  cfg = config.modules.nixos.windowManager.hyprland;

  hyprlandPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
in {
  imports = mylib.scanModules ./.;

  options.modules.nixos.windowManager.hyprland = {
    enable = lib.mkEnableOption "启用 Hyprland 窗口管理器";

    user = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "启用 Hyprland 的用户";
    };

    quickshell = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "在 Hyprland 启动的同时运行的 quickshell";
    };

    layout = lib.mkOption {
      type = lib.types.enum ["dwindle" "master" "scrolling" "scrolling"];
      default = "dwindle";
      description = "Hyprland 的布局";
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
    modules.nixos.desktop.quickshell = {
      noctalia = lib.mkIf (cfg.quickshell == "noctalia") {
        enable = true;
        inherit (cfg) user;
      };
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

        settings = {
          exec-once = lib.mkIf (cfg.quickshell == "noctalia") ["noctalia-shell"];

          general = {
            layout = cfg.layout;
            gaps_workspaces = "20";
            gaps_in = "10";
            gaps_out = "20";
            border_size = "3";

            "col.active_border" = "rgba(c2c1ffe6)"; # 活动窗口的边框颜色
            "col.inactive_border" = "rgba(c8c5d111)"; # 非活动窗口的边框颜色
          };
        };
      };

      programs.kitty.enable = true; # 确保进入 Hyprland 时有终端可用
    };
  };
}
