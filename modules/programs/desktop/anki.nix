{
  flake.modules.homeManager.anki = {
    config,
    pkgs,
    ...
  }: {
    sops.secrets = {
      "programs/anki/username" = {};
      "programs/anki/key" = {};
    };

    programs.anki = {
      enable = true;

      language = "zh_CN";
      answerKeys = [
        {
          ease = 1;
          key = "a";
        }
        {
          ease = 2;
          key = "s";
        }
        {
          ease = 3;
          key = "d";
        }
        {
          ease = 4;
          key = "f";
        }
      ];
      addons = with pkgs.ankiAddons; [
        review-heatmap
      ];
      profiles = {
        "账户 1" = {
          default = true;
          sync = {
            usernameFile = config.sops.secrets."programs/anki/username".path;
            keyFile = config.sops.secrets."programs/anki/key".path;
            autoSync = true;
          };
        };
      };
    };
  };
}
