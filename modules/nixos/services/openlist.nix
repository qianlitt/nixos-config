{
  config,
  lib,
  ...
}: let
  cfg = config.modules.services.openlist;
in {
  options.modules.services.openlist = {
    enable = lib.mkEnableOption "启用 OpenList 服务";

    image = lib.mkOption {
      type = lib.types.str;
      default = "docker.io/openlistteam/openlist:latest";
      description = "OpenList Docker 镜像";
    };

    adminPasswordFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/openlist-admin-password";
      description = ''
        OpenList 管理员密码文件

        包含 OpenList 管理员密码的文件路径。文件内容应为 `OPENLIST_ADMIN_PASSWORD=<your_password>`。如果为 null，则需要在首次启动后手动配置管理员密码。
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/openlist";
      description = "OpenList 数据存储目录";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 5244;
      description = "OpenList 监听端口";
    };

  };

  config = lib.mkIf cfg.enable {
    # 确保所需子系统启用
    modules.cli.podman.enable = true;
    modules.cli.quadlet.enable = true;

    # 创建用户和用户组
    users.users.openlist = {
      isSystemUser = true;
      group = "openlist";
      home = cfg.dataDir;
      createHome = true;
    };
    users.groups.openlist = {};

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0755 openlist openlist -"
    ];

    virtualisation.quadlet.containers.openlist = {
      autoStart = true;
      containerConfig = {
        image = cfg.image;
        publishPorts = ["${toString cfg.port}:${toString cfg.port}"];
        user = "${toString config.users.users.openlist.uid}:${toString config.users.groups.openlist.gid}";
        volumes = [
          "${cfg.dataDir}:/opt/openlist/data:Z"
        ];
        environments = {
          "TZ" = config.time.timeZone;
          "UMASK" = "022";
        };
        environmentFiles = [cfg.adminPasswordFile];
      };
      serviceConfig = {
        Restart = "unless-stopped";
      };
    };

    networking.firewall.allowedTCPPorts = [cfg.port];
  };
}
