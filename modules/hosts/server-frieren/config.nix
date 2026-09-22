{inputs, ...}: {
  flake.modules.nixos.frieren = {
    imports = [
      inputs.self.modules.nixos.profile-cli
    ];

    documentation.enable = false;

    modules = {
      grub = {
        enable = true;
        type = "legacy";
        device = "/dev/sda";
      };

      i18n.enable = true;
    };

    # 每周一更新 flake.lock，然后通过 `nixos-rebuild boot` 部署到该主机
    # 每周二自动重启以更新系统
    #
    # 本机硬件时钟在开机时读出的是 2009-01-01 08:00（Unix 1230768000），NTP 同步
    # 完成时系统时间会一次性向前跳变十几年。systemd 的日历定时器是按"启动时那个错误
    # 的时间"算出下一个周二并挂起的，时钟一跳变，这个触发点就被当作"早已错过的触发
    # 点"立刻执行 → 重启 → 时间又回到 2009 → 再次触发，于是无限重启。
    #
    # 在 services 中判断是否重启。
    systemd = {
      services.auto-reboot = {
        description = "每周二自动重启，应用 nixos-rebuild boot 部署的新系统";

        # 时间尚未经 NTP 同步时不执行（该文件由 systemd-timesyncd 在首次同步成功后创建）
        unitConfig.ConditionPathExists = "/run/systemd/timesync/synchronized";

        script = ''
          # 开机不足 30 分钟就触发，必定是上面说的"时钟跳变把用错误时间算出的触发点
          # 追认成过期"。这条同时让死循环在结构上不可能成立：每轮循环都要先重启
          # （开机时长随之归零），紧接着的触发都会被这里挡掉。
          if [ "$(cut -d. -f1 /proc/uptime)" -lt 1800 ]; then
            echo "系统启动不足 30 分钟，跳过本次重启"
            exit 0
          fi

          # 距上次真正重启不足 6 小时也不再重启（第二道保险；正常每周二重启时不会触发）
          state=/var/lib/auto-reboot-last-reboot
          now=$(date +%s)
          if [ -s "$state" ]; then
            last=$(cat "$state")
            if [ $((now - last)) -lt 21600 ]; then
              echo "距上次重启仅 $(( (now - last) / 60 )) 分钟，跳过本次重启"
              exit 0
            fi
          fi

          echo "$now" > "$state"
          systemctl reboot
        '';

        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
      };

      timers.auto-reboot = {
        wantedBy = ["timers.target"];
        timerConfig = {
          # 每周二 00:00 触发
          OnCalendar = "Tue 00:00:00";
          Persistent = false;
          RandomizedDelaySec = "0";
        };
      };
    };
  };
}
