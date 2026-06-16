{inputs, ...}: {
  flake.modules = {
    nixos.profile-desktop = {
      imports = with inputs.self.modules.nixos; [
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
        stylix
      ];

      modules.desktop.stylix.enable = true;
    };

    darwin.profile-desktop = {
      imports = with inputs.self.modules.darwin; [
        profile-cli
      ];
    };

    homeManager.profile-desktop = {
      imports = with inputs.self.modules.homeManager; [
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

        hyprland
        niri
        noctalia
        game
        stylix
      ];
    };
  };
}
