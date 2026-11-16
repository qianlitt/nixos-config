{
  flake.modules.homeManager.anki = {pkgs, ...}: {
    programs.anki = {
      enable = true;

      language = "zh_CN";
      answerKeys = [
        {
          ease = 1;
          key = "q";
        }
        {
          ease = 2;
          key = "w";
        }
        {
          ease = 3;
          key = "e";
        }
        {
          ease = 4;
          key = "r";
        }
      ];
      addons = with pkgs.ankiAddons; [
        review-heatmap
      ];
      profiles = {
        "账户 1" = {
          default = true;
          sync.autoSync = true;
        };
      };
    };
  };
}
