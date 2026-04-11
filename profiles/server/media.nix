{
  config,
  lib,
  mylib,
  ...
}: let
  cfg = config.profiles.server.media;
in {
  imports = [(mylib.root "modules/nixos/services")];

  options.profiles.server.media = {
    enable = lib.mkEnableOption "启用媒体服务预设";

    dir = lib.mkOption {
      type = lib.types.path;
      default = "/mnt/media";
      description = "媒体服务数据存储根目录";
    };

    jellyfin = {
      enable = lib.mkEnableOption "启用 Jellyfin 媒体服务器";
      virtualHostName = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Jellyfin 虚拟主机域名";
      };
      useACMEHost = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Jellyfin 使用的 ACME 主机证书配置";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # 创建 media 用户组
    users.groups.media = {};

    # 将媒体服务用户添加到 media 组
    users.users = {
      jellyfin.extraGroups = ["media"];
      radarr.extraGroups = ["media"];
      sonarr.extraGroups = ["media"];
    };

    # 创建存储目录
    systemd.tmpfiles.rules =
      [
        "d '${toString cfg.dir}' 0775 root media - -"
        "d '${toString cfg.dir}/movie' 0775 root media - -"
        "d '${toString cfg.dir}/tv' 0775 root media - -"
        "d '${toString cfg.dir}/anime' 0775 root media - -"
      ]
      ++ [
        # Radarr/Sonarr 分类下载路径
        "d '${toString cfg.dir}/downloads/movie' 2775 qbittorrent media - -"
        "d '${toString cfg.dir}/downloads/tv' 2775 qbittorrent media - -"
      ];
    # 媒体服务器
    modules.nixos.jellyfin = {inherit (cfg.jellyfin) enable virtualHostName useACMEHost;};
    # 下载器
    modules.nixos.peerbanhelper.enable = true;
    modules.nixos.qbittorrent = {
      enable = true;

      group = "media";

      webuiPort = 8080;
      torrentingPort = 6881;

      webuiUsername = "admin";
      webuiPassword = "iPfQ/AXYT4cV0xfQZZmxLA==:MUsIAe6w/JahMgaiVS8iQ3YKxBEFQRgnkY26TthwSY9pLEzif7/U8TOth7/zKqBT6Fza04FHGd56uTiPEGNgvA==";

      interfaceAddress = "192.168.1.103";
    };
    # arr 家族
    modules.nixos.seerr.enable = true;
    modules.nixos.prowlarr.enable = true;
    modules.nixos.radarr.enable = true;
    modules.nixos.sonarr.enable = true;
    # arr 搜索增强
    modules.nixos.jproxy = {
      enable = true;
      image = "docker.1ms.run/luckypuppy514/jproxy:latest";
    };
  };
}
