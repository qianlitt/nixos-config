{
  config,
  pkgs,
  inputs,
  mylib,
  myvar,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    (mylib.root "modules/nixos/services")
  ];

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

  # PostgreSQL
  modules.nixos.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
    authentication = ''
      # TYPE  DATABASE        USER            ADDRESS                 METHOD
      local   all             all                                     trust
      host    all             all             127.0.0.1/32            trust
      host    all             all             ::1/128                 trust
    '';

    backup.enable = true;
  };

  # Aria2
  modules.nixos.aria.enable = true;
  modules.nixos.ariang = {
    enable = true;

    virtualHostName = "aria.lan.luna-sama.xyz";
    useACMEHost = "wildcard.lan";
  };

  # qBittorrent
  modules.nixos.qbittorrent = {
    enable = true;

    webuiPort = 8080;
    torrentingPort = 6881;

    webuiUsername = "admin";
    webuiPassword = "iPfQ/AXYT4cV0xfQZZmxLA==:MUsIAe6w/JahMgaiVS8iQ3YKxBEFQRgnkY26TthwSY9pLEzif7/U8TOth7/zKqBT6Fza04FHGd56uTiPEGNgvA==";

    virtualHostName = "qb.lan.luna-sama.xyz";
    useACMEHost = "wildcard.lan";
  };

  # PeerBanHelper
  modules.nixos.peerbanhelper = {
    enable = true;

    virtualHostName = "pbh.lan.luna-sama.xyz";
    useACMEHost = "wildcard.lan";
  };

  # cloudreve
  sops.secrets."postgresql/cloudreve" = {
    owner = "postgres";
    group = "postgres";
    mode = "0440";
  };
  modules.nixos.cloudreve = {
    enable = true;
    database.passwordFile = config.sops.secrets."postgresql/cloudreve".path;

    virtualHostName = "cloud.lan.luna-sama.xyz";
    useACMEHost = "wildcard.lan";
  };

  # Immich
  modules.nixos.immich = {
    enable = true;
    host = "0.0.0.0";
    port = 2283;

    environment = {
      TZ = config.time.timeZone;
      IMMICH_LOG_LEVEL = "log";
    };

    virtualHostName = "photo.lan.luna-sama.xyz";
    useACMEHost = "wildcard.lan";
  };
}
