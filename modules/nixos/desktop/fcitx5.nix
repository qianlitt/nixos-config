{
  config,
  lib,
  pkgs,
  mylib,
  ...
}: let
  cfg = config.modules.nixos.fcitx5;
in {
  options.modules.nixos.fcitx5 = {
    enable = lib.mkEnableOption "启用 Fcitx5 输入法框架";

    user = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "启用 fcitx5 配置的用户";
    };
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
            "Groups/0/Items/0".Name = "rime";
            GroupOrder."0" = "Default";
          };
        };
      };
    };

    home-manager.users.${cfg.user} = lib.mkIf (cfg.user
      != null) {
      home.file.".local/share/fcitx5/rime/default.custom.yaml".text = ''
        patch:
          __include: rime_ice_suggestion:/
          schema_list:
            - schema: tiger
            - schema: rime_ice
            - schema: double_pinyin_flypy
      '';
    };
  };
}
