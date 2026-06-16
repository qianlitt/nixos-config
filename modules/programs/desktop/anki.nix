{
  flake.modules.homeManager.anki = {
    # config,
    pkgs,
    ...
  }: {
    home.packages = with pkgs; [
      (anki.withAddons [
        ankiAddons.review-heatmap
      ])
    ];

    # BUG: Anki 的声明式配置，现在同步配置不起作用
    # sops.secrets = {
    #   "programs/anki/username" = {};
    #   "programs/anki/key" = {};
    # };
    # programs.anki = {
    #   enable = true;
    #
    #   language = "zh_CN";
    #   answerKeys = [
    #     {
    #       ease = 1;
    #       key = "a";
    #     }
    #     {
    #       ease = 2;
    #       key = "s";
    #     }
    #     {
    #       ease = 3;
    #       key = "d";
    #     }
    #     {
    #       ease = 4;
    #       key = "f";
    #     }
    #   ];
    #   addons = with pkgs.ankiAddons; [
    #     review-heatmap
    #   ];
    #   profiles = {
    #     "User 1" = {
    #       default = true;
    #       sync = {
    #         usernameFile = config.sops.secrets."programs/anki/username".path;
    #         keyFile = config.sops.secrets."programs/anki/key".path;
    #         autoSync = true;
    #       };
    #     };
    #   };
    # };
  };
}
