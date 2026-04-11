{
  config,
  lib,
  ...
}: let
  cfg = config.modules.nixos.seerr;
  useNewConfigLocation = lib.versionAtLeast config.system.stateVersion "26.05";
in {
  options.modules.nixos.seerr = {
    enable = lib.mkEnableOption "启用 Seerr 用户界面";

    port = lib.mkOption {
      type = lib.types.port;
      default = 5055;
      description = "Seerr 服务端口";
    };

    configDir = lib.mkOption {
      type = lib.types.path;
      default =
        if useNewConfigLocation
        then "/var/lib/seerr/"
        else "/var/lib/jellyseerr/config";
      description = "Seerr 配置目录";
    };
  };

  config = lib.mkIf cfg.enable {
    services.seerr = {
      enable = true;

      openFirewall = true;

      inherit (cfg) port configDir;
    };
  };
}
