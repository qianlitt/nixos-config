{
  flake.modules.nixos."services.jellyfin" = {
    config,
    lib,
    ...
  }: let
    cfg = config.modules.services.jellyfin;
  in {
    options.modules.services.jellyfin = {
      enable = lib.mkEnableOption "启用 Jellyfin 媒体服务器";

      port = lib.mkOption {
        type = lib.types.port;
        default = 8096;
        description = "Jellyfin 服务监听端口";
      };

      # 用户和用户组选项
      user = lib.mkOption {
        type = lib.types.str;
        default = "jellyfin";
        description = "Jellyfin 服务用户";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "jellyfin";
        description = "Jellyfin 服务用户组";
      };

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/jellyfin";
        description = "Jellyfin 数据存储目录";
      };

      transcoding = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = "Jellyfin 转码配置";
      };

      hardwareAcceleration = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = "Jellyfin 硬件加速配置";
      };
    };

    config = lib.mkIf cfg.enable {
      services.jellyfin = {
        enable = true;

        openFirewall = true;

        inherit (cfg) user group dataDir transcoding hardwareAcceleration;
      };
    };
  };
}
