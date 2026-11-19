{inputs, ...}: {
  flake.modules.nixos.frieren = {
    config,
    pkgs,
    ...
  }: let
    domain = "lan.${config.systemConstants.admin.domain}"; # 分配三级域名
    sopsFile = "${inputs.self.inputs.secrets}/hosts/frieren.yaml";

    # 各证书共享的默认配置
    certDefaultConfig = {
      email = config.systemConstants.admin.email;
      group = "nginx";
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1";
      environmentFile = config.sops.secrets."cloudflare/api_token".path;
    };

    acmeDns = extra: inputs.self.factory.acmeDns (certDefaultConfig // extra);
  in {
    imports =
      (with inputs.self.lib.modules; [
        nixos."services.ssh"

        nixos."services.nginx"
        nixos."services.postgresql"

        nixos."services.alist"
        nixos."services.immich"
        nixos."services.vaultwarden"
        nixos."services.anki-sync"
      ])
      ++ [
        (inputs.self.factory.acme [
          (acmeDns {
            name = "wildcard.lan";
            inherit domain;
            extraDomainNames = ["*.${domain}"];
          })
          (acmeDns {
            name = "wildcard.pages";
            domain = "pages.${domain}";
            extraDomainNames = ["*.pages.${domain}"];
          })
        ])
      ];

    sops = {
      secrets = {
        "services/anki-sync/lean" = {inherit sopsFile;};
        "cloudflare/api_token" = {mode = "0400";};
      };
    };

    modules = {
      services = {
        ssh = {
          enable = true;
          allowPassword = false;
        };

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

        vaultwarden.enable = true;
      };
    };

    services = {
      anki-sync-server.users = [
        {
          username = "lean";
          passwordFile = config.sops.secrets."services/anki-sync/lean".path;
        }
      ];
      immich = {
        machine-learning.enable = false;
        environment = {
          TZ = config.time.timeZone;
          IMMICH_LOG_LEVEL = "log";
        };
      };
    };

    # ========== Nginx 子域名反代配置 ==========
    services.nginx.virtualHosts = {
      # AList
      "pan.${domain}" = {
        forceSSL = true;
        useACMEHost = "wildcard.lan";

        locations."/" = {
          proxyPass = "http://127.0.0.1:5244/";
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
          proxyPass = "http://127.0.0.1:${toString config.services.immich.port}/";
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

      # Anki sync server
      "anki.${domain}" = {
        forceSSL = true;
        useACMEHost = "wildcard.lan";

        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.anki-sync-server.port}/";
          proxyWebsockets = true;
        };
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
  };
}
