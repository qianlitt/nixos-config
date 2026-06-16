{
  inputs,
  self,
  ...
}: {
  flake-file.inputs = {
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    secrets = {
      url = "path:./secrets";
      flake = false;
    };
  };

  flake.modules.nixos.sops = {
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];

    sops = {
      defaultSopsFile = "${self.inputs.secrets}/secrets.yaml";

      # nixosModules 中的 sops 导入 SSH 密钥作为 age 密钥
      # 新主机运行 `nix-shell -p ssh-to-age --run 'cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age'` 命令更新 `.sops.yaml` 中的密钥
      age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    };
  };

  flake.modules.homeManager.sops = {
    imports = [
      inputs.sops-nix.homeManagerModules.sops
    ];

    sops.defaultSopsFile = "${self.inputs.secrets}/secrets.yaml";
  };
}
