{inputs, ...}: {
  flake.modules.nixos.frieren = {config, ...}: let
    domain = "lan.${config.systemConstants.admin.domain}";
    sopsFile = "${inputs.self.inputs.secrets}/hosts/frieren.yaml";
  in {
    imports = with inputs.self.modules; [
      nixos."services.gitlab"
    ];

    sops.secrets = {
      "services/gitlab/initialRootPassword" = {
        inherit sopsFile;
        owner = "gitlab";
        group = "gitlab";
        mode = "0440";
      };
      "services/gitlab/databasePassword" = {
        inherit sopsFile;
        owner = "gitlab";
        group = "gitlab";
        mode = "0440";
      };
      "services/gitlab/secret" = {
        inherit sopsFile;
        owner = "gitlab";
        group = "gitlab";
        mode = "0440";
      };
      "services/gitlab/db" = {
        inherit sopsFile;
        owner = "gitlab";
        group = "gitlab";
        mode = "0440";
      };
      "services/gitlab/otp" = {
        inherit sopsFile;
        owner = "gitlab";
        group = "gitlab";
        mode = "0440";
      };
      "services/gitlab/jws" = {
        inherit sopsFile;
        owner = "gitlab";
        group = "gitlab";
        mode = "0440";
      };
      "services/gitlab/activeRecordPrimaryKey" = {
        inherit sopsFile;
        owner = "gitlab";
        group = "gitlab";
        mode = "0440";
      };
      "services/gitlab/activeRecordDeterministicKey" = {
        inherit sopsFile;
        owner = "gitlab";
        group = "gitlab";
        mode = "0440";
      };
      "services/gitlab/activeRecordSaltFile" = {
        inherit sopsFile;
        owner = "gitlab";
        group = "gitlab";
        mode = "0440";
      };
    };

    services = {
      nginx.virtualHosts = {
        "git.${domain}" = {
          forceSSL = true;
          useACMEHost = "wildcard.lan";

          extraConfig = ''
            client_max_body_size 2048m;
            proxy_request_buffering off;
            proxy_buffering off;
          '';

          locations."/" = {
            proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
            proxyWebsockets = true;
          };
        };
        "${config.services.gitlab.registry.externalAddress}" = {
          forceSSL = true;
          useACMEHost = "wildcard.lan";

          locations."/" = {
            proxyPass = "http://${config.services.gitlab.registry.settings.http.addr}";
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_buffering off;
              proxy_request_buffering off;
            '';
          };
        };
        "${config.services.gitlab.pages.settings.pages-domain}" = {
          forceSSL = true;
          useACMEHost = "wildcard.pages";

          serverAliases = ["*.${config.services.gitlab.pages.settings.pages-domain}"];
          locations."/" = {
            proxyPass = "http://127.0.0.1:8090";
            proxyWebsockets = true;
            recommendedProxySettings = true;
          };
        };
      };

      gitlab = {
        host = "git.${domain}";
        port = 443;

        initialRootPasswordFile = config.sops.secrets."services/gitlab/initialRootPassword".path;
        databasePasswordFile = config.sops.secrets."services/gitlab/databasePassword".path;
        secrets = {
          secretFile = config.sops.secrets."services/gitlab/secret".path;
          dbFile = config.sops.secrets."services/gitlab/db".path;
          otpFile = config.sops.secrets."services/gitlab/otp".path;
          jwsFile = config.sops.secrets."services/gitlab/jws".path;
          activeRecordPrimaryKeyFile = config.sops.secrets."services/gitlab/activeRecordPrimaryKey".path;
          activeRecordDeterministicKeyFile = config.sops.secrets."services/gitlab/activeRecordDeterministicKey".path;
          activeRecordSaltFile = config.sops.secrets."services/gitlab/activeRecordSaltFile".path;
        };

        registry = {
          externalAddress = "registry.${domain}";
          externalPort = 443;
        };

        pages = {
          settings = {
            pages-domain = "pages.${domain}";
            listen-proxy = ["127.0.0.1:8090"];
          };
        };

        extraConfig = {
          pages = {
            # 控制 pages 生成的链接
            port = 443; # 去除生端口号
            https = true; # 使用 HTTPS scheme
          };
        };
      };
    };
  };
}
