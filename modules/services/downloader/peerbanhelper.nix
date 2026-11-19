{
  flake.modules.nixos."services.peerbanhelper" = let
    image = "registry.cn-hangzhou.aliyuncs.com/ghostchu/peerbanhelper:latest";
    dataDir = "/var/lib/peerbanhelper";
  in {
    # 创建数据目录
    systemd.tmpfiles.rules = [
      "d '${dataDir}' 0755 root root - -"
    ];

    # 配置 quadlet 容器
    virtualisation.quadlet.containers.peerbanhelper = {
      # 开机自启
      autoStart = true;
      containerConfig = {
        inherit image;
        # 必须使用 host 网络模式才能获取真实的 peer IP
        networks = ["host"];
        # 挂载数据目录
        volumes = ["${dataDir}:/app/data"];
      };
      serviceConfig = {
        # 自动重启
        Restart = "always";
      };
    };
  };
}
