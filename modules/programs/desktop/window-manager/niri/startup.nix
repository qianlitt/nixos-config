{
  flake.modules.homeManager.niri = {
    programs.niri.settings.spawn-at-startup = [
      {argv = ["fcitx5" "-d"];}
    ];
  };
}
