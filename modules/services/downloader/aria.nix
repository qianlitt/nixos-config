{inputs, ...}: {
  flake.modules.nixos."services.aria" = {pkgs, ...}: let
    homeDir = "/var/lib/aria2";
    downloadDir = "${homeDir}/Downloads";

    # 本仓库自打包的派生，见 modules/pkgs/
    ps = inputs.self.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    # 配置 nixpkgs 的 Aria2 服务
    services.aria2 = {
      enable = true;
      openPorts = true;
      downloadDirPermission = "0770";
      serviceUMask = "0002";

      # 参考: https://github.com/P3TERX/aria2.conf
      settings = {
        conf-path = "${homeDir}/aria2.conf";

        # === 文件保存设置 ===
        "dir" = downloadDir;
        "disk-cache" = "64M";
        "file-allocation" = "none";
        "no-file-allocation-limit" = "64M";
        "continue" = true;
        "always-resume" = false;
        "max-resume-failure-tries" = 0;
        "remote-time" = true;

        # === 进度保存设置 ===
        "input-file" = "${homeDir}/aria2.session";
        "save-session" = "${homeDir}/aria2.session";
        "save-session-interval" = 1;
        "auto-save-interval" = 20;
        "force-save" = false;

        # === 下载连接设置 ===
        "max-file-not-found" = 10;
        "max-tries" = 0;
        "retry-wait" = 10;
        "connect-timeout" = 10;
        "timeout" = 10;
        "max-concurrent-downloads" = 5;
        "max-connection-per-server" = 16;
        "split" = 64;
        "min-split-size" = "4M";
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
        "listen-port" = [
          {
            from = 6881;
            to = 6999;
          }
        ];
        "dht-listen-port" = 6999;
        "enable-dht" = true;
        "enable-dht6" = false;
        "dht-file-path" = "${homeDir}/dht.dat";
        "dht-file-path6" = "${homeDir}/dht6.dat";
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
        "rpc-listen-port" = 6800;
        "rpc-max-request-size" = "10M";

        # === 高级选项 ===
        "console-log-level" = "notice";
        "quiet" = false;
        "summary-interval" = 0;
        "show-console-readout" = false;
      };
    };

    systemd = {
      # 复制和链接 aria-conf 中的文件
      tmpfiles.rules = let
        home = homeDir;
        src = ps.aria-conf;
      in [
        # 复制 dht.dat / dht6.dat
        "C ${home}/dht.dat  0644 aria2 aria2 - ${src}/dht.dat"
        "C ${home}/dht6.dat 0644 aria2 aria2 - ${src}/dht6.dat"
        # 链接脚本
        "L+ ${home}/tracker.sh - - - - ${src}/tracker.sh"
      ];

      # Tracker 更新服务
      services.aria2-tracker-update = {
        description = "Aria2 BT Tracker Updater";
        wantedBy = ["aria2.service"];
        after = ["aria2.service"];
        bindsTo = ["aria2.service"];

        serviceConfig = {
          Type = "oneshot";
          User = "aria2";
          Group = "aria2";
          # 直接使用 bash 的完整路径
          ExecStart = "${pkgs.bash}/bin/bash ${homeDir}/tracker.sh ${homeDir}/aria2.conf";
          Restart = "on-failure";
          RestartSec = "10s";
          # 确保系统 PATH 可用
          Environment = "PATH=/run/current-system/sw/bin:/bin:/usr/bin";
        };
      };

      # Tracker 定期更新定时器（每7天）
      timers.aria2-tracker-update = {
        description = "定期更新 Aria2 BT Tracker";
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = "weekly";
          Persistent = true;
        };
      };
    };
  };
}
