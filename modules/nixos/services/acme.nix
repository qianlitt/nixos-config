{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.nixos.acme;
in {
  options.modules.nixos.acme = {
    enable = mkEnableOption "启用 ACME 证书管理";

    email = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "ACME 注册邮箱";
    };

    staging = mkOption {
      type = types.bool;
      default = false;
      description = "是否使用 Let's Encrypt staging 服务器（测试用）";
    };

    certs = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          domain = mkOption {
            type = types.str;
            description = "主域名";
          };
          extraDomainNames = mkOption {
            type = types.listOf types.str;
            default = [];
            description = "附加域名（包括通配符域名）";
          };
          dnsProvider = mkOption {
            type = types.enum ["cloudflare"];
            default = "cloudflare";
            description = "DNS 提供商";
          };
          group = mkOption {
            type = types.str;
            default = config.security.acme.defaults.group;
            description = "证书文件所属组";
          };
        };
      });
      default = {};
      description = "ACME 证书配置";
    };
  };

  config = mkIf cfg.enable {
    # 确保 secrets 目录存在
    sops.secrets."cloudflare/api_token" = {mode = "0400";};

    # ACME 配置
    security.acme = {
      acceptTerms = true;
      defaults = {
        email = cfg.email;
        server =
          if cfg.staging
          then "https://acme-staging-v02.api.letsencrypt.org/directory"
          else "https://acme-v02.api.letsencrypt.org/directory";
      };

      certs =
        mapAttrs (name: certCfg: {
          group = certCfg.group;
          domain = certCfg.domain;
          extraDomainNames = certCfg.extraDomainNames;
          dnsProvider = certCfg.dnsProvider;
          environmentFile = config.sops.secrets."cloudflare/api_token".path;
        })
        cfg.certs;
    };
  };
}
