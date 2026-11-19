{inputs, ...}: {
  flake.modules.nixos.frieren = {
    config,
    lib,
    ...
  }: let
    sopsFile = "${inputs.self.inputs.secrets}/hosts/frieren.yaml";
  in {
    imports = with inputs.self.lib.modules; [
      nixos."services.samba"
      nixos."services.nfs"
    ];

    sops.secrets."services/samba/elaina" = {
      inherit sopsFile;
      mode = "0400";
      restartUnits = ["samba-passdb.service"];
    };

    users = {
      groups = {
        media = {};
        shares = {};
        smbusers = {};
      };
      users.elaina.extraGroups = ["media" "shares" "smbusers"];
    };

    modules.services = {
      samba = {
        enable = true;
        users.elaina.passwordFile = config.sops.secrets."services/samba/elaina".path;

        settings = {
          global = {
            "server min protocol" = "SMB2_10";
            "server smb encrypt" = "desired";
            "interfaces" = "192.168.1.101/24";
            "bind interfaces only" = "yes";
            "socket options" = "TCP_NODELAY IPTOS_LOWDELAY";
            "use sendfile" = "yes";
          };

          # 媒体：所有 SMB 用户只读，elaina 可写
          media = {
            path = "/mnt/media";
            "valid users" = ["@smbusers"];
            "read only" = "yes";
            "write list" = ["elaina"];
            "force group" = "media";
            "browseable" = "yes";
            "create mask" = "0664";
            "directory mask" = "2775";
          };

          # 每个用户通过 %U 映射到自己的私有目录
          private = {
            path = "/srv/shares/private/%U";
            "valid users" = ["@smbusers"];
            "read only" = "no";
            "browseable" = "yes";
            "create mask" = "0600";
            "directory mask" = "0700";
            "follow symlinks" = "no";
          };

          # 家庭共享：所有 SMB 用户读写
          family = {
            path = "/srv/shares/family";
            "valid users" = ["@smbusers"];
            "read only" = "no";
            "force group" = "shares";
            "create mask" = "0664";
            "directory mask" = "2775";
          };

          # 公共目录：所有 SMB 用户只读，elaina 可写
          public = {
            path = "/srv/shares/public";
            "valid users" = ["@smbusers"];
            "read only" = "yes";
            "write list" = ["elaina"];
            "force group" = "shares";
          };

          # 其他设备的备份落点：仅 elaina
          backups = {
            path = "/mnt/backups";
            "valid users" = ["elaina"];
            "read only" = "no";
            "create mask" = "0600";
            "directory mask" = "0700";
          };
        };
      };

      nfs = {
        enable = true;
        hostName = "192.168.1.101";
        exports = {
          "/mnt/media" = {
            "192.168.1.0/24" = ["ro" "sync" "no_subtree_check" "root_squash"];
          };
          "/mnt/backups" = {
            "192.168.1.0/24" = ["rw" "sync" "no_subtree_check" "all_squash" "anonuid=1000" "anongid=100"];
          };
        };
      };

      # Immich / RustFS 的数据目录改到数据盘
    };
    services = {
      rustfs.volumes = "/mnt/s3";
      immich.mediaLocation = "/mnt/immich";
    };

    systemd.tmpfiles.rules = [
      "d /mnt/media 2775 root media -"
      "d /mnt/media/movie 2775 root media -"
      "d /mnt/media/tv 2775 root media -"
      "d /mnt/media/anime 2775 root media -"
      "d /mnt/media/music 2775 root media -"
      "d /mnt/media/downloads 2775 root media -"
      "d /mnt/media/downloads/movie 2775 root media -"
      "d /mnt/media/downloads/tv 2775 root media -"
      "d /srv/shares 2775 root shares -"
      "d /srv/shares/private 0711 root shares -"
      "d /srv/shares/private/elaina 0700 elaina users -"
      "d /srv/shares/family 2775 root shares -"
      "d /srv/shares/public 2775 root shares -"
      "d /mnt/backups 0770 elaina users -"
    ];

    # 挂载失败时服务失败，而不是静默写根盘
    systemd.services = {
      "samba-smbd".unitConfig.RequiresMountsFor = [
        "/mnt/media"
        "/srv/shares"
        "/mnt/backups"
      ];
      "nfs-server".unitConfig.RequiresMountsFor = [
        "/mnt/media"
        "/mnt/backups"
      ];
      "nfs-mountd".unitConfig.RequiresMountsFor = [
        "/mnt/media"
        "/mnt/backups"
      ];
      "immich-server".unitConfig.RequiresMountsFor = ["/mnt/immich"];
      rustfs.unitConfig.RequiresMountsFor = ["/mnt/s3"];
    };

    # AList 只读浏览媒体和公共目录
    virtualisation.quadlet.containers.alist.containerConfig.volumes = lib.mkAfter [
      "/mnt/media:/mnt/media:ro"
      "/srv/shares/public:/srv/shares/public:ro"
    ];
  };
}
