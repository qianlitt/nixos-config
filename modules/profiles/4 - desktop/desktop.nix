{inputs, ...}: {
  flake.modules = {
    nixos.profile-desktop = {
      imports = with inputs.self.lib.modules.nixos; [
        profile-cli

        audio
        displayManager
        dolphin
        fcitx5
        fonts
        keyboard
        localsend

        hyprland
        niri
        noctalia
        game
      ];
    };

    darwin.profile-desktop = {
      imports = with inputs.self.lib.modules.darwin; [
        profile-cli
      ];
    };

    homeManager.profile-desktop = {
      imports = with inputs.self.lib.modules.homeManager; [
        profile-cli

        anki
        discord
        fcitx5
        kitty
        obsidian
        telegram
        chromium
        zen-browser
        neovide
        vscode
        wps

        hyprland
        niri
        noctalia
        game
      ];
    };
  };
}
