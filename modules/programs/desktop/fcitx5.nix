{inputs, ...}: {
  flake.modules.nixos.fcitx5 = {pkgs, ...}: {
    # 导入 Overlays
    nixpkgs.overlays = [
      inputs.self.overlays.fcitx5
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
            classicui.globalSection = {
              Theme = "catppuccin-mocha-lavender";
              DarkTheme = "catppuccin-mocha-lavender";
              Font = "LXGW WenKai 14";
              MenuFont = "LXGW WenKai 14";
            };
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

  flake.modules.homeManager.fcitx5 = {
    # rime 配置
    home.file = {
      ".local/share/fcitx5/rime/default.custom.yaml".text = ''
        patch:
          __include: rime_ice_suggestion:/
          schema_list:
            - schema: tiger
            - schema: rime_ice
            - schema: double_pinyin_flypy
          # 方案选单快捷键
          "switcher/hotkeys":
            - "Control+F8"
          # 由 fcitx5 控制中英文切换
          ascii_composer/good_old_caps_lock: true
          ascii_composer/switch_key:
            Caps_Lock: clear
            Control_L: noop
            Control_R: noop
            Shift_L: noop
            Shift_R: noop
      '';

      # 覆盖雾凇拼音配置
      ".local/share/fcitx5/rime/rime_ice.custom.yaml".text = ''
        patch:
          switches/@3:
            name: emoji
            states: [ 💀, 😄 ]
            reset: 0
      '';

      # 覆盖小鹤双拼配置
      ".local/share/fcitx5/rime/double_pinyin_flypy.custom.yaml".text = ''
        patch:
          switches/@3:
            name: emoji
            states: [ 💀, 😄 ]
            reset: 0
      '';
    };
  };
}
