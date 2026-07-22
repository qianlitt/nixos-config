{
  flake.modules.nixos.nix = {
    config,
    lib,
    ...
  }: {
    nixpkgs.config.allowUnfree = true;
    nix = {
      settings = {
        experimental-features = ["nix-command" "flakes"];

        trusted-users = [
          "@wheel" # wheel 用户组的所有用户
        ];
        substituters = lib.mkBefore [
          # cache mirror located in China
          # status: https://mirror.nju.edu.cn/
          "https://mirror.nju.edu.cn/nix-channels/store"

          # status: https://mirrors.ustc.edu.cn/status/
          # "https://mirrors.ustc.edu.cn/nix-channels/store/"
        ];
        warn-dirty = false; # 禁用 git dirty 警告

        # 并行
        max-substitution-jobs = 128; # 最大并行替换作业数
        http-connections = 128; # 最大并行 TCP 连接数
      };

      # 每周自动垃圾回收
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
      # 定时优化存储
      optimise = {
        automatic = true;
        dates = ["03:45"];
      };
    };

    # 设置 Nix access-tokens
    # Docs: https://nix.dev/manual/nix/latest/command-ref/conf-file#conf-access-tokens
    sops = {
      # 声明 token
      # secrets.yaml 格式: github-token: ghp_xxx
      secrets."github-token" = {
        mode = "0400";
      };

      # 使用 sops-template 生成 access-tokens.conf 文件
      templates."nix-access-tokens" = {
        content = ''
          access-tokens = github.com=${config.sops.placeholder."github-token"}
        '';
        path = "/etc/nix/access-tokens.conf";
      };
    };
    nix.extraOptions = ''
      !include /etc/nix/access-tokens.conf
    '';
  };

  flake.modules.homeManager.nix = {config, ...}: {
    sops = {
      # 声明 token
      # secrets.yaml 格式: github-token: ghp_xxx
      secrets."github-token" = {};

      # 使用 sops-template 生成配置文件
      # access-tokens 文档: https://nix.dev/manual/nix/latest/command-ref/conf-file#conf-access-tokens
      templates."nix-access-tokens" = {
        content = ''
          access-tokens = github.com=${config.sops.placeholder."github-token"}
        '';
        path = "${config.home.homeDirectory}/.config/nix/nix.conf";
      };
    };
  };
}
