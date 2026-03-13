{
  config,
  lib,
  pkgs,
  myvar,
  ...
}: let
  cfg = config.modules.nixos.podman;
in {
  options.modules.nixos.podman = {
    enable = lib.mkEnableOption "启用 Podman 容器引擎";
  };

  config = lib.mkIf cfg.enable {
    # 启用 Podman 服务
    virtualisation.podman = {
      enable = true;

      dockerCompat = true;
      dockerSocket.enable = true; # 替换 docker socket，便于使用 docker 工具
      defaultNetwork.settings.dns_enabled = true; # podman-compose 内部容器互通

      # 自动清理
      autoPrune = {
        enable = true;
        flags = [
          "--all" # 未使用的镜像
        ];
        dates = "0 3 * * 0"; # 每周日凌晨3点
      };
    };

    environment.systemPackages = with pkgs; [
      podman
      podman-compose
      dive # 镜像分析工具
      podlet # 生成 Podman Quadlet 配置
      lazydocker # TUI
    ];

    users.users."${myvar.user.name}".extraGroups = ["podman"];

    # 开启 Podman 自动更新定时器（用户级 systemd）
    systemd.user.services.podman-auto-update = {
      description = "Podman auto-update service";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.podman}/bin/podman auto-update";
        Restart = "on-failure";
        RestartSec = 10;
        TimeoutStartSec = 300;
        LogsDirectory = "podman";
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };

    systemd.user.timers.podman-auto-update = {
      description = "Podman auto-update timer";
      wantedBy = ["default.target"];
      timerConfig = {
        OnCalendar = "02:00:00"; # 每日凌晨2点
        Persistent = true;
        RandomizedDelaySec = 3600; # 添加随机延迟，避免同时更新
      };
    };
  };
}
