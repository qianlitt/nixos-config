{
  config,
  lib,
  ...
}: let
  cfg = config.modules.nixos.jellyseerr;
in {
  options.modules.nixos.jellyseerr = {
    enable = lib.mkEnableOption "启用 Jellyseerr 用户界面";

    port = lib.mkOption {
      type = lib.types.port;
      default = 5055;
      description = "Jellyseerr 服务端口";
    };

    configDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/jellyseerr/config";
      description = "Jellyseerr 配置目录";
    };
  };

  config = lib.mkIf cfg.enable {
    services.jellyseerr = {
      enable = true;

      openFirewall = true;

      inherit (cfg) port configDir;
    };
  };
}
