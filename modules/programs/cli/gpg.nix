{
  flake = {
    modules.nixos.gpg = {
      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };

    modules.homeManager.gpg = {lib, ...}: {
      programs.gpg.enable = true;

      # GPG 配置
      home.file.".gnupg/common.conf".text = ''
        use-keyboxd
      '';
      services.gpg-agent = {
        enable = true;
        enableSshSupport = true;

        defaultCacheTtl = lib.mkDefault (24 * 60 * 60); # 24 小时
        maxCacheTtl = lib.mkDefault (7 * 24 * 60 * 60); # 7 天
        defaultCacheTtlSsh = lib.mkDefault (24 * 60 * 60);
        maxCacheTtlSsh = lib.mkDefault (7 * 24 * 60 * 60);

        enableBashIntegration = true;
        enableFishIntegration = true;
        enableNushellIntegration = true;
        enableZshIntegration = true;
      };
    };

    factory.gpgImportKey = {fingerprint}: {
      config,
      lib,
      pkgs,
      ...
    }: let
      inherit (lib) getExe;
      gpgBin = getExe pkgs.gnupg;

      gpgPrivateKeyPath = "${config.home.homeDirectory}/.config/sops-nix/secrets/gpg";
    in {
      # 导入 GPG 密钥
      sops.secrets.gpg.path = gpgPrivateKeyPath;

      systemd.user.services.import-gpg-key = {
        Unit = {
          Description = "Import GPG key after sops-nix decrypts it";
          After = ["sops-nix.service"];
          Requires = ["sops-nix.service"];
        };
        Service = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "import-gpg" ''
            set -eu

            # 检查密钥文件是否存在
            if [ ! -f ${gpgPrivateKeyPath} ]; then
              echo "GPG secret file not found, skipping import." >&2
              exit 0
            fi

            # 检查密钥是否已经导入
            if ${gpgBin} --list-secret-keys --with-fingerprint --with-colons | grep -q "${fingerprint}"; then
              echo "GPG key already imported, skipping."
              exit 0
            fi

            # 导入密钥
            ${gpgBin} --batch --import ${gpgPrivateKeyPath}
            echo "${fingerprint}:6:" | ${gpgBin} --batch --import-ownertrust
          '';
        };
        Install.WantedBy = ["default.target"];
      };
    };
  };
}
