{
  config,
  inputs,
  myvar,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];

      trusted-users = [myvar.user.name];
      substituters = [
        # cache mirror located in China
        # status: https://mirrors.ustc.edu.cn/status/
        "https://mirrors.ustc.edu.cn/nix-channels/store/"
      ];
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
}
