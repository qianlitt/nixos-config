{inputs, ...}: {
  flake-file.inputs = {
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
  };

  flake.modules.nixos.podman = {
    lib,
    pkgs,
    ...
  }: {
    imports = [inputs.quadlet-nix.nixosModules.quadlet];

    # 启用 Podman 服务
    virtualisation = {
      podman = {
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
          dates = "weekly";
        };
      };

      docker.enable = lib.mkForce false;

      quadlet = {
        enable = true;

        autoUpdate = {
          enable = true;
        };
      };
    };

    environment.systemPackages = with pkgs; [
      podman
      podman-compose
      dive # 镜像分析工具，podman 下需要 `--source podman` 参数
      podlet # 生成 Podman Quadlet 配置
      lazydocker # TUI
    ];
  };
}
