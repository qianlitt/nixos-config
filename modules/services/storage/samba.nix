{
  flake.modules.nixos."services.samba" = {
    config,
    lib,
    ...
  }: let
    cfg = config.modules.services.samba;
  in {
    options.modules.services.samba = {
      enable = lib.mkEnableOption "启用 Samba 文件共享";

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "是否开放 Samba 默认端口（139/445 TCP，137/138 UDP）";
      };

      users = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options.passwordFile = lib.mkOption {
            type = lib.types.path;
            description = "包含该用户 SMB 明文密码的文件";
          };
        });
        default = {};
        description = "需要通过 smbpasswd 设置密码的 Unix 用户";
      };

      settings = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = "写入 smb.conf 的 global/share 配置，会递归覆盖默认 global";
      };
    };

    config = lib.mkIf cfg.enable {
      services.samba = {
        enable = true;
        inherit (cfg) openFirewall;

        # 现代 SMB2+ 客户端不需要 NetBIOS/winbind，少两个常驻进程
        nmbd.enable = false;
        winbindd.enable = false;

        settings =
          lib.recursiveUpdate {
            global = {
              workgroup = "WORKGROUP";
              "server string" = config.networking.hostName;
              security = "user";
              "passdb backend" = "tdbsam";
              "hosts allow" = "192.168.1.0/24 127.0.0.1";
              "hosts deny" = "0.0.0.0/0";
              "map to guest" = "never";
            };
          }
          cfg.settings;
      };

      # NixOS 的 Samba 模块不管理 passdb；用 oneshot 从 sops 读取密码
      systemd.services.samba-passdb = lib.mkIf (cfg.users != {}) {
        description = "Set Samba passwords from secret files";
        after = ["samba-smbd.service"];
        requires = ["samba-smbd.service"];
        partOf = ["samba-smbd.service"];
        wantedBy = ["multi-user.target"];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };

        script = ''
          set -euo pipefail
          ${lib.concatStringsSep "\n" (
            lib.mapAttrsToList (name: user: ''
              password="$(cat ${user.passwordFile})"
              printf '%s\n%s\n' "$password" "$password" \
                | ${config.services.samba.package}/bin/smbpasswd -s -a ${lib.escapeShellArg name}
            '')
            cfg.users
          )}
        '';
      };
    };
  };
}
