{mylib, ...}: {
  imports = map mylib.root [
    "modules/nixos/desktop"
  ];

  modules.desktop = {
    quickshell.noctalia.enable = true;
    windowManager.hyprland.enable = true;
  };

  modules.fcitx5.enable = true;
}
