{inputs, ...}: {
  flake.modules.nixos.rin = {
    imports = with inputs.self.lib.modules.nixos;
    with inputs.self.factory; [
      elaina
    ];

    home-manager.users.elaina = {
      config,
      pkgs,
      ...
    }: {
      home.pointerCursor.enable = true;

      imports =
        (with inputs.self.lib.modules;
          with inputs.self.lib.modules.homeManager; [
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
            calibre
            zathura
            zeal
            godot
            aseprite
            homeManager."git.full"
            homeManager."nixvim.full"

            hyprland
            homeManager."hyprland<->noctalia"
            # niri
            # homeManager."niri<->noctalia"
            noctalia
            game
            stylix
          ])
        ++ (with inputs.self.factory; [
          (gpgImportKey {
            fingerprint = config.systemConstants.gpg.fingerprint;
          })
          (gitSigningKey {
            signingKey = config.systemConstants.git.signingKey;
          })
          (gitUser {
            name = config.systemConstants.git.user.name;
            email = config.systemConstants.git.user.email;
          })
          (hyprlandMonitors {
            monitors = config.systemConstants.host.rin.monitors;
          })
          # (niriOutputs {
          #   outputs = config.systemConstants.host.rin.monitors;
          # })
        ]);

      sops.secrets = {
        gpg = {
          sopsFile = "${inputs.self.inputs.secrets}/users/elaina.yaml";
        };
        "programs/anki/official/username" = {
          sopsFile = "${inputs.self.inputs.secrets}/users/elaina.yaml";
        };
        "programs/anki/official/key" = {
          sopsFile = "${inputs.self.inputs.secrets}/users/elaina.yaml";
        };
        "programs/anki/mysync/username" = {
          sopsFile = "${inputs.self.inputs.secrets}/users/elaina.yaml";
        };
        "programs/anki/mysync/key" = {
          sopsFile = "${inputs.self.inputs.secrets}/users/elaina.yaml";
        };
        "programs/ssh" = {
          sopsFile = "${inputs.self.inputs.secrets}/users/elaina.yaml";
        };
      };

      services.gpg-agent.sshKeys = [config.systemConstants.gpg.keygrip];

      programs = {
        btop.package = pkgs.btop-cuda;
        anki.profiles."账户 1".sync = {
          url = "https://anki.lan.1806016.xyz/";
          usernameFile = config.sops.secrets."programs/anki/mysync/username".path;
          keyFile = config.sops.secrets."programs/anki/mysync/key".path;
        };
        ssh.includes = [
          config.sops.secrets."programs/ssh".path
        ];
      };
    };
  };
}
