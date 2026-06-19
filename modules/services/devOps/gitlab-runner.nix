{
  flake.modules.nixos."services.gitlab-runner" = {lib, ...}: {
    services.gitlab-runner = {
      enable = true;

      settings = lib.mkDefault {
        concurrent = 2; # 全局并发作业数
        check_interval = 30; # 轮询间隔（秒）
        log_level = "info";
      };
    };

    # 避免 gitlab-runner 服务在 podman 之前启动
    systemd.services.gitlab-runner = {
      after = ["podman.socket"];
      requires = ["podman.socket"];
      bindsTo = ["podman.socket"];
    };
  };
}
