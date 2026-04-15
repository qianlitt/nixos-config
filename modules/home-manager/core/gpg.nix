{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.gpg;

  inherit (lib) getExe;
  gpgBin = getExe pkgs.gnupg;

  gpgPrivateKeyPath = "${config.home.homeDirectory}/.config/sops-nix/secrets/gpg";
in {
  options.modules.gpg = {
    enable = lib.mkEnableOption "自定义 GPG 配置模块";

    sshKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "暴露给 ssh-agent 的 GPG 密钥 grip 列表";
    };

    importKey = {
      enable = lib.mkEnableOption "启用 GPG 密钥导入";

      fingerprint = lib.mkOption {
        type = lib.types.str;
        description = "GPG 密钥指纹";
      };
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      programs.gpg.enable = true;

      # GPG 配置
      home.file.".gnupg/common.conf".text = ''
        use-keyboxd
      '';
      services.gpg-agent = {
        enable = true;

        enableSshSupport = true;
        inherit (cfg) sshKeys;

        defaultCacheTtl = 24 * 60 * 60; # 24 小时
        maxCacheTtl = 7 * 24 * 60 * 60; # 7 天
        defaultCacheTtlSsh = 24 * 60 * 60;
        maxCacheTtlSsh = 7 * 24 * 60 * 60;

        enableBashIntegration = true;
        enableFishIntegration = true;
        enableNushellIntegration = true;
        enableZshIntegration = true;
      };
    }

    # 导入 GPG 密钥
    (lib.mkIf cfg.importKey.enable {
      sops.secrets.gpg = {
        path = gpgPrivateKeyPath;
      };
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
            if ${gpgBin} --list-secret-keys --with-fingerprint --with-colons | grep -q "${cfg.importKey.fingerprint}"; then
              echo "GPG key already imported, skipping."
              exit 0
            fi

            # 导入密钥
            ${gpgBin} --batch --import ${gpgPrivateKeyPath}
            echo "${cfg.importKey.fingerprint}:6:" | ${gpgBin} --batch --import-ownertrust
          '';
        };
        Install.WantedBy = ["default.target"];
      };
    })
  ]);
}
