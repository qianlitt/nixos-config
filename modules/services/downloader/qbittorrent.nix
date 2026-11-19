{
  flake.modules.nixos."services.qbittorrent" = {pkgs, ...}: {
    services.qbittorrent = {
      enable = true;

      package = pkgs.qbittorrent-enhanced-nox;

      openFirewall = true;

      serverConfig = {
        BitTorrent.Session = {
          DisableAutoTMMByDefault = false; # 新添加的种子默认启用自动管理模式
          TorrentContentLayout = "Subfolder"; # 设置 torrent 内容布局：创建子文件夹

          AddTrackersFromURLEnabled = true; # 自动添加 trackers
          AdditionalTrackersURL = "https://cf.trackerslist.com/all.txt";

          GlobalDLSpeedLimit = 0; # 全局下载速度限制
          GlobalUPSpeedLimit = 1000; # 全局上传速度限制

          GlobalMaxInactiveSeedingMinutes = 1440; # 不活跃做种时间
          GlobalMaxRatio = 10; # 最大分享率
          ShareLimitAction = "Stop"; # 达到条件时停止做种

          MaxActiveDownloads = 10; # 最大活跃下载数
          MaxActiveUploads = 10; # 最大活跃上传数
          MaxActiveTorrents = 20; # 最大活跃 torrent 数
          IgnoreSlowTorrentsForQueueing = true; # 忽略慢速 torrent
        };

        LegalNotice.Accepted = true;

        Preferences = {
          General.Locale = "zh_CN";

          WebUI = {
            # Username = "";

            # WebUI 密码，默认为 `password`。
            # 可用[该工具](https://codeberg.org/feathecutie/qbittorrent_password)生成，或运行该命令：`nix run git+https://codeberg.org/feathecutie/qbittorrent_password -- -p <your_password>`
            # Password_PBKDF2 = "";
            LocalHostAuth = false; # 对本地主机上的客户端跳过身份验证
          };
        };

        RSS = {
          Session = {
            EnableProcessing = true; # 获取 RSS 订阅
            RefreshInterval = 60; # RSS 源更新时间（分钟）
          };
        };
      };
    };
  };
}
