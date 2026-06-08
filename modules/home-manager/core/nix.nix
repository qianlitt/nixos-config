{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

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
}
