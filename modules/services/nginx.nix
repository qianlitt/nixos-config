# Nginx 服务器通用配置
{
  flake.modules.nixos."services.nginx" = {
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
}
