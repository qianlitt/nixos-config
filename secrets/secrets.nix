{
  inputs,
  pkgs,
  myvar,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  environment.systemPackages = with pkgs; [
    age # 加密工具
    sops # 秘密管理
  ];

  # sops 配置
  sops = {
    defaultSopsFile = ./secrets.yaml;

    # 导入 SSH 密钥作为 age 密钥
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    #
    age.keyFile = "/home/${myvar.user.name}/.config/sops/age/keys.txt";
  };

  # secret 配置
  sops.secrets = {
    "user/${myvar.user.name}/hashedPassword" = {neededForUsers = true;};
  };
}
