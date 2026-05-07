{
  config,
  lib,
  pkgs,
  mylib,
  ...
}: let
  cfg = config.modules.fcitx5;
in {
  options.modules.fcitx5 = {
    enable = lib.mkEnableOption "启用 Fcitx5 输入法框架";
  };

  config = lib.mkIf cfg.enable {
    # 导入 Overlays
    nixpkgs.overlays = [
      (import (mylib.root "overlays/fcitx5"))
    ];

    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-gtk
          kdePackages.fcitx5-qt
          fcitx5-rime
          catppuccin-fcitx5 # theme
        ];

        settings = {
          addons = {
            classicui.globalSection.Theme = "catppuccin-mocha-lavender";
            classicui.globalSection.DarkTheme = "catppuccin-mocha-lavender";
            classicui.globalSection.Font = "LXGW WenKai 14";
            classicui.globalSection.MenuFont = "LXGW WenKai 14";
          };
          inputMethod = {
            "Groups/0" = {
              Name = "Default";
              "Default Layout" = "us";
              DefaultIM = "rime";
            };
            "Groups/0/Items/0".Name = "keyboard-us";
            "Groups/0/Items/1".Name = "rime";
            GroupOrder."0" = "Default";
          };
        };
      };
    };
  };
}
