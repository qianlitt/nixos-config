{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.nixos.ariang;

  rpcPort = config.modules.nixos.aria.rpcListenPort;
in {
  options.modules.nixos.ariang = {
    enable = lib.mkEnableOption "启用 AriaNg 服务";

    # Nginx 虚拟主机配置
    virtualHostName = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "example.com";
      description = "AriaNg 服务的 Nginx 虚拟主机域名";
    };

    # ACME 证书配置
    useACMEHost = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "使用的 ACME 主机证书配置";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ariang];

    modules.nixos.nginx.virtualHosts.${cfg.virtualHostName} = lib.mkIf (cfg.virtualHostName != "") {
      forceSSL = cfg.useACMEHost != "";
      useACMEHost = lib.mkIf (cfg.useACMEHost != "") cfg.useACMEHost;

      root = "${pkgs.ariang}/share/ariang";

      locations = {
        "/" = {
          index = "index.html";
        };
        "/jsonrpc" = {
          proxyPass = "http://127.0.0.1:${toString rpcPort}/jsonrpc";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
          '';
        };
      };
    };
  };
}
