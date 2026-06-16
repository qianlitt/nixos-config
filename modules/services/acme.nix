{
  flake.modules.nixos."services.acme" = {
    config,
    lib,
    ...
  }: let
    cfg = config.modules.services.acme;
  in {
    options.modules.services.acme = {
      enable = lib.mkEnableOption "启用 ACME 证书管理";

      email = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "ACME 注册邮箱";
      };

      staging = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "是否使用 Let's Encrypt staging 服务器（测试用）";
      };

      certs = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            domain = lib.mkOption {
              type = lib.types.str;
              description = "主域名";
            };
            extraDomainNames = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [];
              description = "附加域名（包括通配符域名）";
            };
            dnsProvider = lib.mkOption {
              type = lib.types.enum ["cloudflare"];
              default = "cloudflare";
              description = "DNS 提供商";
            };
            group = lib.mkOption {
              type = lib.types.str;
              default = config.security.acme.defaults.group;
              description = "证书文件所属组";
            };
          };
        });
        default = {};
        description = "ACME 证书配置";
      };
    };

    config = lib.mkIf cfg.enable {
      # 确保 secrets 目录存在
      sops.secrets."cloudflare/api_token" = {mode = "0400";};

      # ACME 配置
      security.acme = {
        acceptTerms = true;
        defaults = {
          inherit (cfg) email;
          server =
            if cfg.staging
            then "https://acme-staging-v02.api.letsencrypt.org/directory"
            else "https://acme-v02.api.letsencrypt.org/directory";
        };

        certs =
          lib.mapAttrs (_name: certCfg: {
            inherit (certCfg) group domain extraDomainNames dnsProvider;
            environmentFile = config.sops.secrets."cloudflare/api_token".path;
          })
          cfg.certs;
      };
    };
  };
}
