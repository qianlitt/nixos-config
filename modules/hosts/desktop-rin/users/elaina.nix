{inputs, ...}: {
  flake.modules.nixos.rin = {config, ...}: {
    imports = with inputs.self.modules.nixos;
    with inputs.self.factory; [
      elaina
    ];

    home-manager.users.elaina = {
      home.pointerCursor.enable = true;

      imports = with inputs.self.modules.homeManager; [
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
        stylix
      ];

      modules = {
        cli = {
          git = {
            enable = true;
            user = {
              name = config.systemConstants.git.user.name;
              email = config.systemConstants.git.user.email;
            };
            signing = {
              enable = true;
              key = config.systemConstants.git.signingKey;
            };
            gh.enable = true;
            tui.enable = true;
          };

          gpg = {
            enable = true;
            sshKeys = [config.systemConstants.gpg.keygrip];
            importKey = {
              enable = true;
              fingerprint = config.systemConstants.gpg.fingerprint;
            };
          };

          ai.enable = true;

          nixvim = {
            enable = true;

            completion.enable = true;
            lsp.enable = true;
            format.enable = true;
            lint.enable = true;
            treesitter.enable = true;
          };
        };

        desktop = {
          quickshell.noctalia.enable = true;
          windowManager.hyprland = {
            enable = true;
            quickshell = "noctalia";
            monitors = config.systemConstants.host.rin.monitors;
          };
          windowManager.niri = {
            enable = true;
            quickshell = "noctalia";
            monitors = config.systemConstants.host.rin.monitors;
          };

          fcitx5.enable = true;
          game.enable = true;
          terminal.kitty.enable = true;
        };
      };
    };
  };
}
