{
  flake.modules.nixos."services.jproxy" = {
    config,
    lib,
    ...
  }: let
    cfg = config.modules.services.jproxy;
  in {
    options.modules.services.jproxy = {
      enable = lib.mkEnableOption ''
        启用 JProxy 服务

        介于 Sonarr / Radarr 和 Jackett / Prowlarr 之间的代理，主要用于优化查询和提升识别率。
      '';

      image = lib.mkOption {
        type = lib.types.str;
        default = "docker.io/luckypuppy514/jproxy:latest";
        description = "JProxy Docker 镜像";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8117;
        description = "JProxy 服务端口";
      };

      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/jproxy";
        description = "JProxy 服务数据目录";
      };
    };

    config = lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = config.modules.cli.podman.enable && config.modules.cli.podman.quadlet.enable;
          message = ''
            Openlist 服务依赖 Podman 和 Quadlet，请添加配置：
              modules.cli.podman = {
                enable = true;
                quadlet.enable = true;
              };
          '';
        }
      ];

      # 创建数据目录
      systemd.tmpfiles.rules = [
        "d '${toString cfg.dataDir}' 0755 root root - -"
      ];

      # 配置 quadlet 容器
      virtualisation.quadlet.containers.jproxy = {
        autoStart = true;
        containerConfig = {
          inherit (cfg) image;
          publishPorts = ["${toString cfg.port}:8117"];
          volumes = ["${toString cfg.dataDir}:/app/database"];
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
  };
}
