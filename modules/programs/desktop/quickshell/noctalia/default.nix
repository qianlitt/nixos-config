{inputs, ...}: {
  flake-file.inputs = {
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.nixos.noctalia = {lib, ...}: {
    # 缓存配置
    nix.settings = {
      substituters = lib.mkOrder 700 ["https://noctalia.cachix.org"];
      trusted-public-keys = ["noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="];
    };
    networking.networkmanager.enable = lib.mkDefault true;
    hardware.bluetooth.enable = true;
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;
  };

  flake.modules.homeManager.noctalia = {pkgs, ...}: {
    imports = [inputs.noctalia.homeModules.default];

    programs.noctalia = {
      enable = true;
    };

    home.packages = with pkgs; [
      # 剪贴板工具
      cliphist
      wl-clipboard

      gpu-screen-recorder # Screen Recorder 插件依赖
      ddcutil # 显示器亮度调节工具
    ];
  };
}
