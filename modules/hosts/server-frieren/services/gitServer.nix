{inputs, ...}: {
  flake.modules.nixos.frieren = {config, ...}: let
    domain = "lan.${config.systemConstants.admin.domain}";
  in {
    imports = with inputs.self.modules; [
      nixos."services.gitlab"
      nixos."services.gitlab-runner"
    ];

    sops.secrets = {
      "services/gitlab/initialRootPassword" = {
        owner = "gitlab";
        group = "gitlab";
        mode = "0440";
      };
      "services/gitlab/databasePassword" = {
        owner = "gitlab";
        group = "gitlab";
        mode = "0440";
      };
      "services/gitlab/secret" = {
        owner = "gitlab";
        group = "gitlab";
        mode = "0440";
      };
      "services/gitlab/db" = {
        owner = "gitlab";
        group = "gitlab";
        mode = "0440";
      };
      "services/gitlab/otp" = {
        owner = "gitlab";
        group = "gitlab";
        mode = "0440";
      };
      "services/gitlab/jws" = {
        owner = "gitlab";
        group = "gitlab";
        mode = "0440";
      };
      "services/gitlab/activeRecordPrimaryKey" = {
        owner = "gitlab";
        group = "gitlab";
        mode = "0440";
      };
      "services/gitlab/activeRecordDeterministicKey" = {
        owner = "gitlab";
        group = "gitlab";
        mode = "0440";
      };
      "services/gitlab/activeRecordSaltFile" = {
        owner = "gitlab";
        group = "gitlab";
        mode = "0440";
      };
      "services/gitlab-runner/default" = {};
    };

    services = {
      nginx.virtualHosts = {
        "git.${domain}" = {
          forceSSL = true;
          useACMEHost = "wildcard.lan";

          locations."/" = {
            proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
            proxyWebsockets = true;
          };
        };
        "${config.services.gitlab.registry.externalAddress}" = {
          forceSSL = true;
          useACMEHost = "wildcard.lan";

          locations."/" = {
            proxyPass = "http://${config.services.gitlab.registry.host}:${toString config.services.gitlab.registry.port}";
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

      # Runner 定义
      gitlab-runner.services = {
        default = {
          authenticationTokenConfigFile = config.sops.secrets."services/gitlab-runner/default".path;

          executor = "docker";
          dockerImage = "alpine:latest";
          description = "podman runner";

          dockerVolumes = [
            "/run/podman/podman.sock:/var/run/docker.sock"
          ];

          dockerPullPolicy = "if-not-present";
        };
      };
    };
  };
}
