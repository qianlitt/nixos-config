{
  config,
  mylib,
  myvar,
  ...
}: {
  imports = [(mylib.root "modules/nixos/services")];

  # ACME 证书管理
  modules.nixos.acme = {
    enable = true;

    email = myvar.user.email;
    certs = {
      "wildcard.lan" = {
        domain = "lan.luna-sama.xyz";
        extraDomainNames = ["*.lan.luna-sama.xyz"];
        group = "nginx";
      };
    };
  };

  # Nginx
  modules.nixos.nginx = {
    enable = true;

    virtualHosts."lan.luna-sama.xyz" = {
      forceSSL = true;
      useACMEHost = "wildcard.lan";

      # Nginx 测试页
      locations."/" = {
        return = "200 '<!DOCTYPE html><html><head><title>Welcome to Nginx!</title></head><body><h1>Welcome to Nginx!</h1><p>If you see this page, the nginx web server is successfully installed and working.</p></body></html>'";
        extraConfig = ''
          add_header Content-Type text/html;
        '';
      };
    };
  };
}
