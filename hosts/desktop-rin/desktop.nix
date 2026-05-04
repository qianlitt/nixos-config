{mylib, ...}: {
  imports = map mylib.root [
    "modules/nixos/desktop"
  ];

  modules.desktop = {
    quickshell.noctalia.enable = true;
    windowManager = {
      hyprland.enable = true;
      niri.enable = true;
    };
  };

  modules.desktop.game.enable = true;

  modules.fcitx5.enable = true;
}
