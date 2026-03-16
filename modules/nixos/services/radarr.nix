{
  config,
  lib,
  ...
}: let
  cfg = config.modules.nixos.radarr;
in {
  options.modules.nixos.radarr = {
    enable = lib.mkEnableOption "启用 Radarr 电影管理服务";

    port = lib.mkOption {
      type = lib.types.port;
      default = 7878;
      description = "Radarr 服务端口";
    };

    # 用户和用户组选项
    user = lib.mkOption {
      type = lib.types.str;
      default = "radarr";
      description = "Radarr 服务用户";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "radarr";
      description = "Radarr 服务用户组";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/radarr/.config/Radarr";
      description = "Radarr 数据存储目录";
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = ''
        任意配置选项的属性集。请查阅[维基](https://wiki.servarr.com/useful-tools#using-environment-variables-for-config)上的文档

        警告：此配置存储在全球可读的 Nix 存储中！对于秘密，请使用 `services.radarr.environmentFiles`。
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.radarr = {
      enable = true;

      openFirewall = true;

      inherit (cfg) user group dataDir;

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
