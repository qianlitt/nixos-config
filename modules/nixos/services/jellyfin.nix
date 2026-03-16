{
  config,
  lib,
  ...
}: let
  cfg = config.modules.nixos.jellyfin;

  port = 8096;
in {
  options.modules.nixos.jellyfin = {
    enable = lib.mkEnableOption "启用 Jellyfin 媒体服务器";

    # 用户和用户组选项
    user = lib.mkOption {
      type = lib.types.str;
      default = "jellyfin";
      description = "Jellyfin 服务用户";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "jellyfin";
      description = "Jellyfin 服务用户组";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/jellyfin";
      description = "Jellyfin 数据存储目录";
    };

    transcoding = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Jellyfin 转码配置";
    };

    hardwareAcceleration = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Jellyfin 硬件加速配置";
    };

    virtualHostName = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "jellyfin.example.com";
      description = "Jellyfin 虚拟主机域名";
    };

    useACMEHost = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "wildcard.example.com";
      description = "用于 ACME 证书的主机名";
    };
  };

  config = lib.mkIf cfg.enable {
    services.jellyfin = {
      enable = true;

      openFirewall = true;

      inherit (cfg) user group dataDir transcoding hardwareAcceleration;
    };

    # Nginx 反代配置
    modules.nixos.nginx.virtualHosts.${cfg.virtualHostName} = lib.mkIf (cfg.virtualHostName != "") {
      forceSSL = cfg.useACMEHost != "";
      useACMEHost = lib.mkIf (cfg.useACMEHost != "") cfg.useACMEHost;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString port}/";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 0;        # 不限大小
          proxy_buffering off;           # 禁用缓冲
        '';
      };
    };
  };
}
