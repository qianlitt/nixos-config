{
  flake.modules.nixos."services.jproxy" = {config, ...}: let
    image = "docker.1ms.run/luckypuppy514/jproxy:latest";
    port = 8117;
    dataDir = "/var/lib/jproxy";
  in {
    # 创建数据目录
    systemd.tmpfiles.rules = [
      "d '${toString dataDir}' 0755 root root - -"
    ];

    # 配置 quadlet 容器
    virtualisation.quadlet.containers.jproxy = {
      autoStart = true;
      containerConfig = {
        inherit image;
        publishPorts = ["${toString port}:8117"];
        volumes = ["${toString dataDir}:/app/database"];
        environments = {
          "TZ" = config.time.timeZone;
          "JAVA_OPTS" = "-Xms512m -Xmx512m";
        };
      };
      serviceConfig = {
        Restart = "always";
      };
    };
  };
}
