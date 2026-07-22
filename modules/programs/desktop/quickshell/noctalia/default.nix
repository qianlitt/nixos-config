{inputs, ...}: {
  flake-file.inputs = {
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.nixos.noctalia = {
    config,
    lib,
    ...
  }: let
    cfg = config.modules.desktop.quickshell.noctalia;
  in {
    options.modules.desktop.quickshell.noctalia = {
      enable = lib.mkEnableOption "启用 Noctalia Shell";
    };

    config = lib.mkIf cfg.enable {
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
  };

  flake.modules.homeManager.noctalia = {
    config,
    lib,
    pkgs,
    osConfig,
    ...
  }: let
    cfg = config.modules.desktop.quickshell.noctalia;

    nixosNoctaliaEnabled = osConfig.modules.desktop.quickshell.noctalia.enable or false;
  in {
    imports = [inputs.noctalia.homeModules.default];

    options.modules.desktop.quickshell.noctalia = {
      enable = lib.mkEnableOption "启用 Noctalia Shell";
    };

    config = lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = nixosNoctaliaEnabled;
          message = ''
            Home Manager 的 noctalia 配置已启用，但对应的 NixOS 模块未启用。
            请在你的 NixOS 配置中添加：
              modules.desktop.quickshell.noctalia.enable = true;
          '';
        }
      ];

      programs.noctalia = {
        enable = true;
      };

      home.packages = with pkgs; [
        # 剪贴板工具
        cliphist
        wl-clipboard

        gpu-screen-recorder # Screen Recorder 插件依赖
      ];
    };
  };
}
