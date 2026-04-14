{myvar, ...}: {
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];

      trusted-users = [myvar.user.name];
      substituters = [
        # cache mirror located in China
        # status: https://mirrors.ustc.edu.cn/status/
        "https://mirrors.ustc.edu.cn/nix-channels/store/"

        # Hyprland cachix
        "https://hyprland.cachix.org"
      ];

      trusted-substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };

    # 每周自动垃圾回收
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    # 定时优化存储
    optimise = {
      automatic = true;
      dates = ["03:45"];
    };
  };
}
