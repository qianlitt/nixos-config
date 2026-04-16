{
  config,
  lib,
  inputs,
  mylib,
  ...
}: let
  cfg = config.modules.nixos.desktop.quickshell.noctalia;
in {
  options.modules.nixos.desktop.quickshell.noctalia = {
    enable = lib.mkEnableOption "启用 Noctalia Shell";

    user = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "启用 Noctalia Shell 的用户";
    };
  };

  config = lib.mkIf cfg.enable {
    # Cachix 配置
    nix.settings = {
      extra-substituters = ["https://noctalia.cachix.org"];
      extra-trusted-public-keys = ["noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="];
    };
    networking.networkmanager.enable = lib.mkDefault true;
    hardware.bluetooth.enable = true;
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;

    assertions = [
      {
        assertion = cfg.user != null;
        message = "必须为 Noctalia Shell 的 home-manager 配置指定用户名";
      }
    ];
    home-manager.users.${cfg.user} = {
      imports =
        mylib.scanModules ./.
        ++ [inputs.noctalia.homeModules.default];

      programs.noctalia-shell = {
        enable = true;
      };
    };
  };
}
