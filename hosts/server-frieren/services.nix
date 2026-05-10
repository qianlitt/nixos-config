{
  config,
  pkgs,
  inputs,
  mylib,
  myvar,
  ...
}: {
  imports =
    [inputs.sops-nix.nixosModules.sops]
    ++ (map mylib.root [
      "modules/nixos/cli"
      "modules/nixos/services"
      "profiles/server/media.nix"
    ]);

  # ACME 证书管理
  modules.acme = {
    enable = true;

    email = myvar.user.email;
    certs = {
      "wildcard.lan" = {
        domain = "lan.luna-sama.xyz";
        extraDomainNames = ["*.lan.luna-sama.xyz"];
        group = "nginx";
      };
    };
  };

  # Nginx
  modules.nginx = {
    enable = true;

    virtualHosts."lan.luna-sama.xyz" = {
      forceSSL = true;
      useACMEHost = "wildcard.lan";

      # Nginx 测试页
      locations."/" = {
        return = "200 '<!DOCTYPE html><html><head><title>Welcome to Nginx!</title></head><body><h1>Welcome to Nginx!</h1><p>If you see this page, the nginx web server is successfully installed and working.</p></body></html>'";
        extraConfig = ''
          add_header Content-Type text/html;
        '';
      };
    };
  };

  # PostgreSQL
  modules.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
    authentication = ''
      # TYPE  DATABASE        USER            ADDRESS                 METHOD
      local   all             all                                     trust
      host    all             all             127.0.0.1/32            trust
      host    all             all             ::1/128                 trust
    '';

    backup.enable = true;
  };

  # Aria2
  modules.aria.enable = true;
  modules.ariang = {
    enable = true;

    virtualHostName = "aria.lan.luna-sama.xyz";
    useACMEHost = "wildcard.lan";
  };

  # cloudreve
  sops.secrets."postgresql/cloudreve" = {
    owner = "postgres";
    group = "postgres";
    mode = "0440";
  };
  modules.cloudreve = {
    enable = true;
    image = "docker.1ms.run/cloudreve/cloudreve:v4";
    database.passwordFile = config.sops.secrets."postgresql/cloudreve".path;

    virtualHostName = "cloud.lan.luna-sama.xyz";
    useACMEHost = "wildcard.lan";
  };

  # OpenList
  sops.secrets."services/openlist" = {
    owner = "openlist";
    group = "openlist";
    mode = "0400";
  };
  modules.openlist = {
    enable = true;
    image = "docker.1ms.run/openlistteam/openlist:latest";
    adminPasswordFile = config.sops.secrets."services/openlist".path;

    virtualHostName = "op.lan.luna-sama.xyz";
    useACMEHost = "wildcard.lan";
  };

  # Immich
  modules.immich = {
    enable = true;
    host = "0.0.0.0";
    port = 2283;

    environment = {
      TZ = config.time.timeZone;
      IMMICH_LOG_LEVEL = "log";
    };

    virtualHostName = "photo.lan.luna-sama.xyz";
    useACMEHost = "wildcard.lan";
  };

  # Vaultwarden
  modules.vaultwarden = {
    enable = true;

    virtualHostName = "vw.lan.luna-sama.xyz";
    useACMEHost = "wildcard.lan";
  };

  # Gitea
  modules.gitea = {
    enable = true;

    virtualHostName = "git.lan.luna-sama.xyz";
    useACMEHost = "wildcard.lan";
  };

  # qBittorrent
  modules.qbittorrent = {
    virtualHostName = "qb.lan.luna-sama.xyz";
    useACMEHost = "wildcard.lan";
  };

  # PeerBanHelper
  modules.peerbanhelper = {
    virtualHostName = "pbh.lan.luna-sama.xyz";
    useACMEHost = "wildcard.lan";
  };

  # ========== 媒体服务 ==========
  profiles.server.media = {
    enable = true;
    jellyfin = {
      enable = true;
      virtualHostName = "jellyfin.lan.luna-sama.xyz";
      useACMEHost = "wildcard.lan";
    };
  };
}
