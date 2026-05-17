{
  mylib,
  hostConfig,
  ...
}: {
  imports = map mylib.root [
    "modules/home-manager/desktop"
  ];

  modules.fcitx5.enable = true;

  modules.desktop = {
    quickshell.noctalia.enable = true;
    windowManager.hyprland = {
      enable = true;
      quickshell = "noctalia";
      monitors = hostConfig.monitors;
    };
    windowManager.niri = {
      enable = true;
      quickshell = "noctalia";
      monitors = hostConfig.monitors;
    };

    game.enable = true;

    terminal.kitty.enable = true;
  };
}
