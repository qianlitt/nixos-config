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

    # homeManagerModules 中的 sops 使用已有的 age 密钥
    age.keyFile = "/home/${myvar.user.name}/.config/sops/age/keys.txt";
  };
}
