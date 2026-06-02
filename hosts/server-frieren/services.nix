{
  config,
  pkgs,
  inputs,
  mylib,
  myvar,
  ...
}: let
  domain = "lan.${myvar.user.domain}"; # 分配三级域名
in {
  imports =
    [inputs.sops-nix.nixosModules.sops]
    ++ (map mylib.root [
      "modules/nixos/cli"
      "modules/nixos/services"
      "profiles/server/media.nix"
    ]);

  # ACME 证书管理
  modules.services.acme = {
    enable = true;

    email = myvar.user.email;
    certs = {
      "wildcard.lan" = {
        inherit domain;
        extraDomainNames = ["*.${domain}"];
        group = "nginx";
      };
    };
  };

  # Nginx
  modules.services.nginx.enable = true;

  # ========== Nginx 子域名反代配置 ==========
  services.nginx.virtualHosts = {
    # Nginx 测试页
    "${domain}" = {
      forceSSL = true;
      useACMEHost = "wildcard.lan";

      locations."/" = {
        return = "200 '<!DOCTYPE html><html><head><title>Welcome to Nginx!</title></head><body><h1>Welcome to Nginx!</h1><p>If you see this page, the nginx web server is successfully installed and working.</p></body></html>'";
        extraConfig = ''
          add_header Content-Type text/html;
        '';
      };
    };

    # Cloudreve
    "pan.${domain}" = {
      forceSSL = true;
      useACMEHost = "wildcard.lan";

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.modules.services.cloudreve.webPort}/";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 0;
          tcp_nopush on;
          tcp_nodelay on;
          proxy_send_timeout 600s;
          proxy_read_timeout 600s;
          proxy_request_buffering off;
          proxy_buffering off;
          chunked_transfer_encoding on;
        '';
      };
    };

    # OpenList
    "op.${domain}" = {
      forceSSL = true;
      useACMEHost = "wildcard.lan";

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.modules.services.openlist.port}/";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 0;
          tcp_nopush on;
          tcp_nodelay on;
          proxy_send_timeout 600s;
          proxy_read_timeout 600s;
          proxy_request_buffering off;
          proxy_buffering off;
          chunked_transfer_encoding on;
        '';
      };
    };

    # Immich
    "photo.${domain}" = {
      forceSSL = true;
      useACMEHost = "wildcard.lan";

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.modules.services.immich.port}/";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 0;
          tcp_nopush on;
          tcp_nodelay on;
          proxy_send_timeout 600s;
          proxy_read_timeout 600s;
          proxy_request_buffering off;
          proxy_buffering off;
          chunked_transfer_encoding on;
        '';
      };
    };

    # Vaultwarden
    "vw.${domain}" = {
      forceSSL = true;
      useACMEHost = "wildcard.lan";

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.modules.services.vaultwarden.port}/";
        proxyWebsockets = true;
      };
    };

    # Gitea
    "git.${domain}" = {
      forceSSL = true;
      useACMEHost = "wildcard.lan";

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.modules.services.gitea.port}/";
        proxyWebsockets = true;
      };
    };

    # qBittorrent
    "qb.${domain}" = {
      forceSSL = true;
      useACMEHost = "wildcard.lan";

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.modules.services.qbittorrent.webuiPort}/";
        proxyWebsockets = true;
      };
    };

    # PeerBanHelper
    "pbh.${domain}" = {
      forceSSL = true;
      useACMEHost = "wildcard.lan";

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.modules.services.peerbanhelper.webuiPort}/";
        proxyWebsockets = true;
      };
    };

    # Jellyfin
    "jellyfin.${domain}" = {
      forceSSL = true;
      useACMEHost = "wildcard.lan";

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.modules.services.jellyfin.port}/";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 0;
          proxy_buffering off;
        '';
      };
    };
  };

  # PostgreSQL
  modules.services.postgresql = {
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
  modules.services.aria.enable = true;

  # cloudreve
  sops.secrets."postgresql/cloudreve" = {
    owner = "postgres";
    group = "postgres";
    mode = "0440";
  };
  modules.services.cloudreve = {
    enable = true;
    image = "docker.1ms.run/cloudreve/cloudreve:v4";
    database.passwordFile = config.sops.secrets."postgresql/cloudreve".path;
  };

  # OpenList
  sops.secrets."services/openlist" = {
    owner = "openlist";
    group = "openlist";
    mode = "0400";
  };
  modules.services.openlist = {
    enable = true;
    image = "docker.1ms.run/openlistteam/openlist:latest";
    adminPasswordFile = config.sops.secrets."services/openlist".path;
  };

  # Immich
  modules.services.immich = {
    enable = true;
    host = "0.0.0.0";
    port = 2283;

    environment = {
      TZ = config.time.timeZone;
      IMMICH_LOG_LEVEL = "log";
    };
  };

  # Vaultwarden
  modules.services.vaultwarden.enable = true;

  # Gitea
  modules.services.gitea.enable = true;

  # qBittorrent
  modules.services.qbittorrent.enable = true;

  # PeerBanHelper
  modules.services.peerbanhelper.enable = true;

  # ========== 媒体服务 ==========
  profiles.server.media = {
    enable = true;
    jellyfin.enable = true;
  };
}
