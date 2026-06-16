# Nginx 服务器通用配置
{
  flake.modules.nixos."services.nginx" = {
    config,
    lib,
    ...
  }: let
    cfg = config.modules.services.nginx;
  in {
    options.modules.services.nginx = {
      enable = lib.mkEnableOption "启用 Nginx 服务";
    };

    config = lib.mkIf cfg.enable {
      # 防火墙开放 80/443 端口
      networking.firewall.allowedTCPPorts = [80 443];

      services.nginx = {
        enable = true;

        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
      };
    };
  };
}
