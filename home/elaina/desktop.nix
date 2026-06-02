{
  mylib,
  hostConfig,
  ...
}: {
  imports = map mylib.root [
    "modules/home-manager/desktop"
  ];

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

    fcitx5.enable = true;
    game.enable = true;
    terminal.kitty.enable = true;
  };
}
