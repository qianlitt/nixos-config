{inputs, ...}: {
  flake.modules.nixos.frieren = {config, ...}: let
    domain = "lan.${config.systemConstants.admin.domain}";
  in {
    imports = with inputs.self.modules; [
      nixos."services.rustfs"
    ];

    sops.secrets = {
      "services/rustfs/accessKey" = {
        owner = config.services.rustfs.user;
        group = config.services.rustfs.group;
        mode = "0400";
      };
      "services/rustfs/secretKey" = {
        owner = config.services.rustfs.user;
        group = config.services.rustfs.group;
        mode = "0400";
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
      };

      # s3 storage
      rustfs = {
        address = "127.0.0.1:9000";
        accessKeyFile = config.sops.secrets."services/rustfs/accessKey".path;
        secretKeyFile = config.sops.secrets."services/rustfs/secretKey".path;
      };
    };
  };
}
