{inputs, ...}: let
  dir = "/mnt/media";
in {
  flake.modules.nixos.frieren = {
    imports = with inputs.self.modules; [
      nixos."services.qbittorrent"
      nixos."services.peerbanhelper"

      nixos."services.jellyfin"
      nixos."services.jproxy"
      nixos."services.prowlarr"
      nixos."services.radarr"
      nixos."services.seerr"
      nixos."services.sonarr"
    ];

    # 媒体服务器
    modules.services = {
      jellyfin.enable = true;
      # 下载器
      peerbanhelper.enable = true;
      qbittorrent = {
        enable = true;

        group = "media";

        webuiPort = 8080;
        torrentingPort = 6881;

        webuiUsername = "admin";
        webuiPassword = "iPfQ/AXYT4cV0xfQZZmxLA==:MUsIAe6w/JahMgaiVS8iQ3YKxBEFQRgnkY26TthwSY9pLEzif7/U8TOth7/zKqBT6Fza04FHGd56uTiPEGNgvA==";

        interfaceAddress = "192.168.1.103";
      };
      # arr 家族
      seerr.enable = true;
      prowlarr.enable = true;
      radarr.enable = true;
      sonarr.enable = true;
      # arr 搜索增强
      jproxy = {
        enable = true;
        image = "docker.1ms.run/luckypuppy514/jproxy:latest";
      };
    };

    users = {
      groups.media = {};
      users = {
        jellyfin.extraGroups = ["media"];
        radarr.extraGroups = ["media"];
        sonarr.extraGroups = ["media"];
      };
    };

    # 创建存储目录
    systemd.tmpfiles.rules =
      [
        "d '${toString dir}' 0775 root media - -"
        "d '${toString dir}/movie' 0775 root media - -"
        "d '${toString dir}/tv' 0775 root media - -"
        "d '${toString dir}/anime' 0775 root media - -"
      ]
      ++ [
        # Radarr/Sonarr 分类下载路径
        "d '${toString dir}/downloads/movie' 2775 qbittorrent media - -"
        "d '${toString dir}/downloads/tv' 2775 qbittorrent media - -"
      ];
  };
}
