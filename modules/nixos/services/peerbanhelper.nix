{
  config,
  lib,
  ...
}: let
  cfg = config.modules.nixos.peerbanhelper;
in {
  options.modules.nixos.peerbanhelper = {
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

    # Nginx 虚拟主机配置
    virtualHostName = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "pbh.example.com";
      description = "PeerBanHelper WebUI 的 Nginx 虚拟主机域名";
    };

    # ACME 证书配置
    useACMEHost = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "使用的 ACME 主机证书配置";
    };
  };

  config = lib.mkIf cfg.enable {
    # 启用 podman 和 quadlet
    modules.nixos.podman.enable = true;
    modules.nixos.quadlet.enable = true;

    # 创建数据目录
    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0755 root root - -"
    ];

    # 配置 quadlet 容器
    virtualisation.quadlet.containers.peerbanhelper = {
      # 开机自启
      autoStart = true;
      containerConfig = {
        image = cfg.image;
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

    # Nginx 反代配置
    modules.nixos.nginx.virtualHosts.${cfg.virtualHostName} = lib.mkIf (cfg.virtualHostName != "") {
      forceSSL = cfg.useACMEHost != "";
      useACMEHost = lib.mkIf (cfg.useACMEHost != "") cfg.useACMEHost;

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.webuiPort}/";
        proxyWebsockets = true;
      };
    };
  };
}
