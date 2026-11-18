{inputs, ...}: {
  flake.modules.nixos.frieren = {
    config,
    lib,
    pkgs,
    ...
  }: let
    domain = "lan.${config.systemConstants.admin.domain}";
    sopsFile = "${inputs.self.inputs.secrets}/hosts/frieren.yaml";

    bucket = config.services.niks3.s3.bucket;
    bucketPolicy = builtins.toJSON {
      Version = "2012-10-17";
      Statement = [
        {
          Sid = "PublicNixCacheRead";
          Effect = "Allow";
          Principal = "*";
          Action = ["s3:GetObject"];
          Resource = ["arn:aws:s3:::${bucket}/*"];
        }
      ];
    };
  in {
    imports = with inputs.self.lib.modules; [
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
        inherit sopsFile;
        owner = config.services.rustfs.user;
        group = "s3-credentials";
        mode = "0440";
      };
      "services/rustfs/secretKey" = {
        inherit sopsFile;
        owner = config.services.rustfs.user;
        group = "s3-credentials";
        mode = "0440";
      };
      "services/niks3/apiToken" = {
        inherit sopsFile;
        owner = config.services.niks3.user;
      };
      "services/niks3/signingKey" = {
        inherit sopsFile;
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

          extraConfig = ''
            client_max_body_size 0;
            ignore_invalid_headers off;
          '';

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
          # 由 rustfs-bucket-init.service 自动创建并设置匿名下载
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

    # RustFS 不会自动建桶，Niks3 也不会创建；开机时幂等初始化
    systemd.services = {
      rustfs-bucket-init = {
        description = "Create RustFS bucket for Niks3 and allow anonymous downloads";
        after = ["rustfs.service"];
        requires = ["rustfs.service"];
        before = ["niks3.service"];
        partOf = ["rustfs.service"];
        wantedBy = ["multi-user.target"];

        path = [pkgs.awscli2];
        environment = {
          HOME = "/run/rustfs-bucket-init";
          AWS_CONFIG_FILE = "/run/rustfs-bucket-init/aws-config";
          AWS_DEFAULT_REGION = "us-east-1";
          AWS_PAGER = "";
          AWS_EC2_METADATA_DISABLED = "true";
        };

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          User = config.services.rustfs.user;
          Group = config.services.rustfs.group;
          RuntimeDirectory = "rustfs-bucket-init";
          RuntimeDirectoryMode = "0700";
          UMask = "0077";
          Restart = "on-failure";
          RestartSec = "10s";

          # 与 RustFS 模块一致：由 systemd 读取 secret，避免脚本直接访问 /run/secrets
          LoadCredential = [
            "access-key:${config.services.rustfs.accessKeyFile}"
            "secret-key:${config.services.rustfs.secretKeyFile}"
          ];
        };

        script = ''
          set -euo pipefail
          trap 'rm -f "$AWS_CONFIG_FILE"' EXIT

          {
            echo "[default]"
            echo "s3 ="
            echo "    addressing_style = path"
          } > "$AWS_CONFIG_FILE"

          export AWS_ACCESS_KEY_ID="$(cat "$CREDENTIALS_DIRECTORY/access-key")"
          export AWS_SECRET_ACCESS_KEY="$(cat "$CREDENTIALS_DIRECTORY/secret-key")"

          endpoint="http://${config.services.rustfs.address}"
          for i in $(seq 1 60); do
            if aws --endpoint-url "$endpoint" s3api list-buckets >/dev/null 2>&1; then
              break
            fi
            sleep 2
          done
          aws --endpoint-url "$endpoint" s3api list-buckets >/dev/null

          if ! aws --endpoint-url "$endpoint" s3api head-bucket --bucket "${bucket}" >/dev/null 2>&1; then
            aws --endpoint-url "$endpoint" s3api create-bucket --bucket "${bucket}"
          fi

          aws --endpoint-url "$endpoint" s3api put-bucket-policy \
            --bucket "${bucket}" \
            --policy ${lib.escapeShellArg bucketPolicy}
        '';
      };

      niks3.after = lib.mkAfter ["rustfs-bucket-init.service"];
      niks3.requires = lib.mkAfter ["rustfs-bucket-init.service"];
    };
  };
}
