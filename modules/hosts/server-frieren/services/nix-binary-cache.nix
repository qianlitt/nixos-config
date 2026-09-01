{inputs, ...}: {
  flake.modules.nixos.frieren = {config, ...}: let
    domain = "lan.${config.systemConstants.admin.domain}";
  in {
    imports = with inputs.self.modules; [
      nixos."services.rustfs"
      nixos."services.niks3"
    ];

    users = {
      groups.s3-credentials = {};
      users.niks3.extraGroups = ["s3-credentials"];
      users.rustfs.extraGroups = ["s3-credentials"];
    };

    sops.secrets = {
      "services/rustfs/accessKey" = {
        owner = config.services.rustfs.user;
        group = "s3-credentials";
        mode = "0440";
      };
      "services/rustfs/secretKey" = {
        owner = config.services.rustfs.user;
        group = "s3-credentials";
        mode = "0440";
      };
      "services/niks3/apiToken" = {
        owner = config.services.niks3.user;
      };
      "services/niks3/signingKey" = {
        owner = config.services.niks3.user;
      };
    };

    services = {
      nginx.virtualHosts = {
        "s3.${domain}" = {
          forceSSL = true;
          useACMEHost = "wildcard.lan";

          extraConfig = ''
            client_max_body_size 0;
            ignore_invalid_headers off;
          '';

          locations."/" = {
            proxyPass = "http://127.0.0.1:9000";
            recommendedProxySettings = false;
            extraConfig = ''
              proxy_http_version 1.1;
              proxy_set_header Host s3.${domain};
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header Connection "";
              proxy_cache_convert_head off;
              proxy_connect_timeout 300s;
              chunked_transfer_encoding off;
            '';
          };
        };
        "rustfs.${domain}" = {
          forceSSL = true;
          useACMEHost = "wildcard.lan";

          extraConfig = ''
            client_max_body_size 0;
            ignore_invalid_headers off;
          '';

          locations."/" = {
            proxyPass = "http://127.0.0.1:9001";
            recommendedProxySettings = false;
            extraConfig = ''
              proxy_http_version 1.1;
              proxy_set_header Host rustfs.${domain};
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header Connection "";
              proxy_cache_convert_head off;
              proxy_connect_timeout 300s;
              chunked_transfer_encoding off;
            '';
          };
        };
        "niks3.${domain}" = {
          forceSSL = true;
          useACMEHost = "wildcard.lan";

          locations."/" = {
            proxyPass = "http://${config.services.niks3.httpAddr}";
          };
        };
        "cache.${domain}" = {
          forceSSL = true;
          useACMEHost = "wildcard.lan";

          locations."= /" = {
            proxyPass = "http://127.0.0.1:9000/nix-cache/index.html";
            recommendedProxySettings = false;
            extraConfig = ''
              proxy_http_version 1.1;
              proxy_set_header Host s3.${domain};
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header Connection "";
              proxy_cache_convert_head off;
              chunked_transfer_encoding off;
            '';
          };
          locations."/" = {
            # 必须带尾斜杠：否则 location / 前缀替换后路径粘连
            proxyPass = "http://127.0.0.1:9000/nix-cache/";
            recommendedProxySettings = false;
            extraConfig = ''
              proxy_http_version 1.1;
              proxy_set_header Host s3.${domain};
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header Connection "";
              proxy_cache_convert_head off;
              chunked_transfer_encoding off;
            '';
          };
        };
      };

      # s3 storage
      rustfs = {
        address = "127.0.0.1:9000";
        accessKeyFile = config.sops.secrets."services/rustfs/accessKey".path;
        secretKeyFile = config.sops.secrets."services/rustfs/secretKey".path;
      };

      # niks3
      niks3 = {
        serverUrl = "https://niks3.${domain}";
        cacheUrl = "https://cache.${domain}";

        s3 = {
          # 需要手动创建存储桶并开放下载
          endpoint = "s3.${domain}";
          bucket = "nix-cache";
          bucketLookup = "path";
          useSSL = true;
          accessKeyFile = config.sops.secrets."services/rustfs/accessKey".path;
          secretKeyFile = config.sops.secrets."services/rustfs/secretKey".path;
        };

        # niks3 API token
        apiTokenFile = config.sops.secrets."services/niks3/apiToken".path;

        # Nix binary cache signing key
        signKeyFiles = [
          config.sops.secrets."services/niks3/signingKey".path
        ];

        # CI 通过 OIDC 免密钥推送(GitHub Actions / GitLab CI)
        oidc.providers = {
          github = {
            issuer = "https://token.actions.githubusercontent.com";
            audience = "https://niks3.${domain}";
          };
          gitlab = {
            issuer = "https://git.${domain}";
            audience = "https://niks3.${domain}";
          };
        };
      };
      postgresql = {
        ensureDatabases = ["niks3"];
        ensureUsers = [
          {
            name = "niks3";
            ensureDBOwnership = true;
          }
        ];
      };
    };
  };
}
