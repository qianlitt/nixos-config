{
  flake.modules.homeManager.anki = {
    config,
    pkgs,
    ...
  }: {
    sops.secrets = {
      "programs/anki/official/username" = {};
      "programs/anki/official/key" = {};
      "programs/anki/mysync/username" = {};
      "programs/anki/mysync/key" = {};
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
            url = "https://anki.lan.1806016.xyz/";
            usernameFile = config.sops.secrets."programs/anki/mysync/username".path;
            keyFile = config.sops.secrets."programs/anki/mysync/key".path;
            autoSync = true;
          };
        };
      };
    };
  };
}
