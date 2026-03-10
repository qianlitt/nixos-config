{
  inputs,
  mylib,
  myvar,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  # sops 配置
  sops = {
    defaultSopsFile = mylib.root "secrets/secrets.yaml";

    # 导入 SSH 密钥作为 age 密钥
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    # 使用已有的 age 密钥
    age.keyFile = "/home/${myvar.user.name}/.config/sops/age/keys.txt";
  };
}
