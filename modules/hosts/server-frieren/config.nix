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
    systemd.services.auto-reboot = {
      description = "每周二自动重启";
      script = ''
        systemctl reboot
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };

    systemd.timers.auto-reboot = {
      wantedBy = ["timers.target"];
      timerConfig = {
        # 每周二 00:00 触发
        OnCalendar = "Tue 00:00:00";
        Persistent = false;
        RandomizedDelaySec = "5m";
      };
    };
  };
}
