{
  config,
  lib,
  ...
}: let
  cfg = config.modules.nixos.nginx;
in {
  options.modules.nixos.nginx = {
    enable = lib.mkEnableOption "启用 Nginx 服务";

    virtualHosts = lib.mkOption {
      type = lib.types.attrsOf lib.types.unspecified;
      default = {};
      description = "Nginx 虚拟主机配置，透传给 services.nginx.virtualHosts";
    };
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

      virtualHosts = cfg.virtualHosts;
    };
  };
}
