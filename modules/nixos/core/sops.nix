{
  inputs,
  pkgs,
  mylib,
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
    defaultSopsFile = mylib.root "secrets/secrets.yaml";

    # nixosModules 中的 sops 导入 SSH 密钥作为 age 密钥
    # 新主机运行 `nix-shell -p ssh-to-age --run 'cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age'` 命令更新 `.sops.yaml` 中的密钥
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  };
}
