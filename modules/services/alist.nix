{
  flake.modules.nixos."services.alist" = {config, ...}: let
    image = "docker.1ms.run/xhofe/alist:latest-aio";
    dataDir = "/var/lib/alist";
    port = 5244;
  in {
    # 创建用户和用户组
    users.users.alist = {
      isSystemUser = true;
      group = "alist";
      home = dataDir;
      createHome = true;
    };
    users.groups.alist = {};

    systemd.tmpfiles.rules = [
      "d ${dataDir} 0755 alist alist -"
    ];

    virtualisation.quadlet.containers.alist = {
      autoStart = true;
      containerConfig = {
        inherit image;
        publishPorts = ["${toString port}:5244"];
        user = "${toString config.users.users.alist.uid}:${toString config.users.groups.alist.gid}";
        volumes = [
          "${dataDir}:/opt/alist/data:Z"
        ];
        environments = {
          "TZ" = config.time.timeZone;
          "UMASK" = "022";
        };
      };
      serviceConfig = {
        Restart = "unless-stopped";
      };
    };
  };
}
