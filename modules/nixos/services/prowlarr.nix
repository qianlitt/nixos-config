{
  config,
  lib,
  ...
}: let
  cfg = config.modules.nixos.prowlarr;
in {
  options.modules.nixos.prowlarr = {
    enable = lib.mkEnableOption "启用 Prowlarr 电影管理服务";

    port = lib.mkOption {
      type = lib.types.port;
      default = 9696;
      description = "Prowlarr 服务端口";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/prowlarr";
      description = "Prowlarr 数据存储目录";
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = ''
        任意配置选项的属性集。请查阅[维基](https://wiki.servarr.com/useful-tools#using-environment-variables-for-config)上的文档

        警告：此配置存储在全球可读的 Nix 存储中！对于秘密，请使用 `services.prowlarr.environmentFiles`。
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.prowlarr = {
      enable = true;

      openFirewall = true;

      inherit (cfg) dataDir;

      settings =
        cfg.settings
        // {
          server = {
            port = cfg.port;
          };
        };
    };
  };
}
