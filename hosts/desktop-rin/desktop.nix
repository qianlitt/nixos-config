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

    audio.enable = true;
    displayManager.enable = true;
    dolphin.enable = true;
    fcitx5.enable = true;
    fonts.enable = true;
    game.enable = true;
    keyd.enable = true;
  };
}
