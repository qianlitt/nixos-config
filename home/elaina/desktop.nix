{
  modules.fcitx5.enable = true;

  modules.desktop = {
    quickshell.noctalia.enable = true;
    windowManager.hyprland = {
      enable = true;
      quickshell = "noctalia";
    };
    windowManager.niri = {
      enable = true;
      quickshell = "noctalia";
    };
  };

  modules.desktop.game.enable = true;
  modules.desktop.terminal.kitty.enable = true;
}
