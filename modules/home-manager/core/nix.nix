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

    # 使用 sops-template 生成 access-tokens.conf 文件
    # access-tokens 文档: https://nix.dev/manual/nix/latest/command-ref/conf-file#conf-access-tokens
    templates."nix-access-tokens" = {
      content = ''
        access-tokens = github.com=${config.sops.placeholder."github-token"}
      '';
      path = "${config.home.homeDirectory}/.config/nix/access-tokens.conf";
    };
  };

  # nix.conf 导入配置使用相对路径（相对于 nix.conf 所在目录）
  home.file.".config/nix/nix.conf" = {
    text = ''
      !include access-tokens.conf
    '';
  };
}
