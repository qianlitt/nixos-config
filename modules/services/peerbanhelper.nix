{
  flake.modules.nixos."services.peerbanhelper" = {
    config,
    lib,
    ...
  }: let
    cfg = config.modules.services.peerbanhelper;
  in {
    options.modules.services.peerbanhelper = {
      enable = lib.mkEnableOption "启用 PeerBanHelper 反吸血辅助工具";

      # 数据目录配置
      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/peerbanhelper";
        description = "PeerBanHelper 数据目录";
      };

      # WebUI 端口
      webuiPort = lib.mkOption {
        type = lib.types.port;
        default = 9898;
        description = "WebUI 监听端口";
      };

      # 镜像配置
      image = lib.mkOption {
        type = lib.types.str;
        default = "registry.cn-hangzhou.aliyuncs.com/ghostchu/peerbanhelper:latest";
        description = "PeerBanHelper Docker 镜像";
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
        "d '${cfg.dataDir}' 0755 root root - -"
      ];

      # 配置 quadlet 容器
      virtualisation.quadlet.containers.peerbanhelper = {
        # 开机自启
        autoStart = true;
        containerConfig = {
          inherit (cfg) image;
          # 必须使用 host 网络模式才能获取真实的 peer IP
          networks = ["host"];
          # 挂载数据目录
          volumes = ["${cfg.dataDir}:/app/data"];
        };
        serviceConfig = {
          # 自动重启
          Restart = "always";
        };
      };
    };
  };
}
