{
  flake.modules.nixos."services.openlist" = {config, ...}: let
    image = "docker.1ms.run/openlistteam/openlist:latest";
    dataDir = "/var/lib/openlist";
    port = 5244;
  in {
    # 创建用户和用户组
    users.users.openlist = {
      isSystemUser = true;
      group = "openlist";
      home = dataDir;
      createHome = true;
    };
    users.groups.openlist = {};

    systemd.tmpfiles.rules = [
      "d ${dataDir} 0755 openlist openlist -"
    ];

    virtualisation.quadlet.containers.openlist = {
      autoStart = true;
      containerConfig = {
        inherit image;
        publishPorts = ["${toString port}:5244"];
        user = "${toString config.users.users.openlist.uid}:${toString config.users.groups.openlist.gid}";
        volumes = [
          "${dataDir}:/opt/openlist/data:Z"
        ];
        environments = {
          "TZ" = config.time.timeZone;
          "UMASK" = "022";
        };
        # OpenList 管理员密码文件
        # 包含 OpenList 管理员密码的文件路径。文件内容应为 `OPENLIST_ADMIN_PASSWORD=<your_password>`。如果为 null，则需要在首次启动后手动配置管理员密码。
        environmentFiles = [];
      };
      serviceConfig = {
        Restart = "unless-stopped";
      };
    };
  };
}
