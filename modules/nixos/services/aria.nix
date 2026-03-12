{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.nixos.aria;

  aria-conf = pkgs.fetchFromGitHub {
    owner = "P3TERX";
    repo = "aria2.conf";
    rev = "02b9d95ea155e66f7e3c4340cd22717f8bc7401c";
    hash = "sha256-O7g/oGgANgoChKACAKzLIOOUbacWpHCEsH533eJwePo=";
    postFetch = ''
      chmod +x "$out"/*.sh || true
    '';
  };
in {
  options.modules.nixos.aria = {
    enable = lib.mkEnableOption "启用 Aria2 下载服务";

    # 数据目录配置
    homeDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/aria2";
      description = "Aria2 家目录";
    };

    downloadDir = lib.mkOption {
      type = lib.types.str;
      default = "${cfg.homeDir}/Downloads";
      description = "下载目录";
    };

    # RPC 配置
    rpcListenPort = lib.mkOption {
      type = lib.types.port;
      default = 6800;
      description = "RPC 监听端口";
    };

    # 下载配置
    maxConcurrentDownloads = lib.mkOption {
      type = lib.types.int;
      default = 5;
      description = "最大同时下载任务数";
    };

    maxConnectionPerServer = lib.mkOption {
      type = lib.types.int;
      default = 16;
      description = "单服务器最大连接数";
    };

    split = lib.mkOption {
      type = lib.types.int;
      default = 64;
      description = "每个文件的最大分块数";
    };

    minSplitSize = lib.mkOption {
      type = lib.types.str;
      default = "4M";
      description = "文件分块下载的最小大小";
    };

    listenPort = lib.mkOption {
      type = with lib.types; listOf (attrsOf port);
      default = [
        {
          from = 6881;
          to = 6999;
        }
      ];
      description = "设置 DHT(IPv4, IPv6) 和 UDP tracker 监听端口范围";
    };

    # BT/PT 配置
    btListenPort = lib.mkOption {
      type = lib.types.int;
      default = 6999;
      description = "BT 监听端口";
    };

    # 额外的自定义配置
    extraSettings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "额外的 Aria2 配置项";
    };
  };

  config = lib.mkIf cfg.enable {
    # Sops 密钥配置
    sops.secrets."aria/rpc_secret" = {
      mode = "0400";
    };

    # 配置 nixpkgs 的 Aria2 服务
    services.aria2 = {
      enable = true;
      openPorts = true;
      downloadDirPermission = "0770";
      serviceUMask = "0002";
      rpcSecretFile = config.sops.secrets."aria/rpc_secret".path;

      # 参考：https://github.com/P3TERX/aria2.conf
      settings =
        {
          conf-path = "${cfg.homeDir}/aria2.conf";

          # === 文件保存设置 ===
          "dir" = cfg.downloadDir;
          "disk-cache" = "64M";
          "file-allocation" = "none";
          "no-file-allocation-limit" = "64M";
          "continue" = true;
          "always-resume" = false;
          "max-resume-failure-tries" = 0;
          "remote-time" = true;

          # === 进度保存设置 ===
          "input-file" = "${cfg.homeDir}/aria2.session";
          "save-session" = "${cfg.homeDir}/aria2.session";
          "save-session-interval" = 1;
          "auto-save-interval" = 20;
          "force-save" = false;

          # === 下载连接设置 ===
          "max-file-not-found" = 10;
          "max-tries" = 0;
          "retry-wait" = 10;
          "connect-timeout" = 10;
          "timeout" = 10;
          "max-concurrent-downloads" = cfg.maxConcurrentDownloads;
          "max-connection-per-server" = cfg.maxConnectionPerServer;
          "split" = cfg.split;
          "min-split-size" = cfg.minSplitSize;
          "piece-length" = "1M";
          "allow-piece-length-change" = true;
          "lowest-speed-limit" = 0;
          "max-overall-download-limit" = 0;
          "max-download-limit" = 0;
          "disable-ipv6" = true;
          "http-accept-gzip" = true;
          "reuse-uri" = false;
          "no-netrc" = true;
          "allow-overwrite" = false;
          "auto-file-renaming" = true;
          "content-disposition-default-utf8" = true;

          # === BT/PT 下载设置 ===
          "listen-port" = cfg.listenPort;
          "dht-listen-port" = cfg.btListenPort;
          "enable-dht" = true;
          "enable-dht6" = false;
          "dht-file-path" = "${cfg.homeDir}/dht.dat";
          "dht-file-path6" = "${cfg.homeDir}/dht6.dat";
          "dht-entry-point" = "dht.transmissionbt.com:6881";
          "dht-entry-point6" = "dht.transmissionbt.com:6881";
          "bt-enable-lpd" = true;
          "enable-peer-exchange" = true;
          "bt-max-peers" = 128;
          "bt-request-peer-speed-limit" = "10M";
          "max-overall-upload-limit" = "2M";
          "max-upload-limit" = 0;
          "seed-ratio" = 1.0;
          "seed-time" = 0;
          "bt-hash-check-seed" = true;
          "bt-seed-unverified" = false;
          "bt-tracker-connect-timeout" = 10;
          "bt-tracker-timeout" = 10;
          "bt-prioritize-piece" = "head=32M,tail=32M";
          "rpc-save-upload-metadata" = true;
          "follow-torrent" = true;
          "pause-metadata" = false;
          "bt-save-metadata" = true;
          "bt-load-saved-metadata" = true;
          "bt-remove-unselected-file" = true;
          "bt-force-encryption" = true;
          "bt-detach-seed-only" = true;

          # === 客户端伪装 ===
          "user-agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0";

          # === 执行额外命令 ===
          # TODO: aria2 清理脚本
          # "on-download-stop" = "${deleteScript}/bin/delete.sh";
          # "on-download-complete" = "${cleanScript}/bin/clean.sh";

          # === RPC 设置 ===
          "enable-rpc" = true;
          "rpc-allow-origin-all" = true;
          "rpc-listen-all" = true;
          "rpc-listen-port" = cfg.rpcListenPort;
          "rpc-max-request-size" = "10M";

          # === 高级选项 ===
          "console-log-level" = "notice";
          "quiet" = false;
          "summary-interval" = 0;
          "show-console-readout" = false;
        }
        // cfg.extraSettings;
    };

    # 复制和链接 aria-conf 中的文件
    systemd.tmpfiles.rules = let
      home = cfg.homeDir;
      src = aria-conf;
    in [
      # 复制 dht.dat / dht6.dat
      "C ${home}/dht.dat  0644 aria2 aria2 - ${src}/dht.dat"
      "C ${home}/dht6.dat 0644 aria2 aria2 - ${src}/dht6.dat"
    ];

    # Tracker 更新服务
    systemd.services.aria2-tracker-update = {
      description = "Aria2 BT Tracker Updater";
      wantedBy = ["aria2.service"];
      after = ["aria2.service"];
      bindsTo = ["aria2.service"];

      serviceConfig = {
        Type = "oneshot";
        User = "aria2";
        Group = "aria2";
        # 直接使用 bash 的完整路径
        ExecStart = "${pkgs.bash}/bin/bash ${cfg.homeDir}/tracker.sh ${cfg.homeDir}/aria2.conf";
        Restart = "on-failure";
        RestartSec = "10s";
        # 确保系统 PATH 可用
        Environment = "PATH=/run/current-system/sw/bin:/bin:/usr/bin";
      };
    };

    # Tracker 定期更新定时器（每7天）
    systemd.timers.aria2-tracker-update = {
      description = "定期更新 Aria2 BT Tracker";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "weekly";
        Persistent = true;
      };
    };
  };
}
