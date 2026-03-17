{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.nixos.qbittorrent;
in {
  options.modules.nixos.qbittorrent = {
    enable = lib.mkEnableOption "启用 qBittorrent 下载服务";

    # 端口配置
    webuiPort = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "WebUI 监听端口";
    };

    torrentingPort = lib.mkOption {
      type = lib.types.port;
      default = 6881;
      description = "BT 下载监听端口";
    };

    # WebUI 帐号密码
    webuiUsername = lib.mkOption {
      type = lib.types.str;
      default = "admin";
      description = "WebUI 用户名";
    };

    webuiPassword = lib.mkOption {
      type = lib.types.str;
      default = "Z0v9T1+A5E43hLa7Df03Qw==:wJ8rx1mACpr3EVmNjuqqcz6qw0aa4wFdE2gXAdqJ7W/CJNhmRTxVKqLLhga5rurb25eCGpwla3wfkbmPs+QNfw==";
      description = ''
        WebUI 密码，默认为 `password`。

        可用[该工具](https://codeberg.org/feathecutie/qbittorrent_password)生成，或运行该命令：`nix run git+https://codeberg.org/feathecutie/qbittorrent_password -- -p <your_password>`
      '';
    };

    # 数据目录配置
    profileDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/qBittorrent/";
      description = "qBittorrent 配置文件目录";
    };

    # Nginx 虚拟主机配置
    virtualHostName = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "example.com";
      description = "qBittorrent WebUI 的 Nginx 虚拟主机域名";
    };

    # ACME 证书配置
    useACMEHost = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "使用的 ACME 主机证书配置";
    };
  };

  config = lib.mkIf cfg.enable {
    services.qbittorrent = {
      enable = true;

      package = pkgs.qbittorrent-enhanced-nox;

      openFirewall = true;
      webuiPort = cfg.webuiPort;
      torrentingPort = cfg.torrentingPort;

      profileDir = cfg.profileDir;

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
            Username = cfg.webuiUsername;
            Password_PBKDF2 = cfg.webuiPassword;
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

    modules.nixos.nginx.virtualHosts.${cfg.virtualHostName} = lib.mkIf (cfg.virtualHostName != "") {
      forceSSL = cfg.useACMEHost != "";
      useACMEHost = lib.mkIf (cfg.useACMEHost != "") cfg.useACMEHost;

      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.webuiPort}/";
          proxyWebsockets = true;
        };
      };
    };
  };
}
