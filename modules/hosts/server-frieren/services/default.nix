{inputs, ...}: {
  flake.modules.nixos.frieren = {
    config,
    pkgs,
    ...
  }: let
    domain = "lan.${config.systemConstants.admin.domain}"; # 分配三级域名
  in {
    imports = with inputs.self.modules; [
      nixos."services.ssh"

      nixos."services.acme"
      nixos."services.nginx"
      nixos."services.postgresql"

      nixos."services.aria"
      nixos."services.cloudreve"
      nixos."services.immich"
      nixos."services.openlist"
      nixos."services.vaultwarden"
    ];

    modules = {
      cli.podman = {
        enable = true;
        quadlet.enable = true;
      };

      services = {
        ssh = {
          enable = true;
          allowPassword = false;
        };

        acme = {
          enable = true;
          email = config.systemConstants.admin.email;
          certs = {
            "wildcard.lan" = {
              inherit domain;
              extraDomainNames = ["*.${domain}"];
              group = "nginx";
            };
          };
        };
        nginx.enable = true;
        postgresql = {
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

        aria.enable = true;
        cloudreve = {
          enable = true;
          image = "docker.1ms.run/cloudreve/cloudreve:v4";
          database.passwordFile = config.sops.secrets."postgresql/cloudreve".path;
        };
        openlist = {
          enable = true;
          image = "docker.1ms.run/openlistteam/openlist:latest";
          adminPasswordFile = config.sops.secrets."services/openlist".path;
        };
        immich = {
          enable = true;
          host = "0.0.0.0";
          port = 2283;

          environment = {
            TZ = config.time.timeZone;
            IMMICH_LOG_LEVEL = "log";
          };
        };
        vaultwarden.enable = true;
      };
    };

    sops = {
      secrets."postgresql/cloudreve" = {
        owner = "postgres";
        group = "postgres";
        mode = "0440";
      };
      secrets."services/openlist" = {
        owner = "openlist";
        group = "openlist";
        mode = "0400";
      };
    };

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
  };
}
