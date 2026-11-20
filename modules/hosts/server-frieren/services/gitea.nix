{inputs, ...}: {
  flake.modules.nixos.frieren = {config, ...}: let
    gitdomain = "git.lan.${config.systemConstants.admin.domain}";
  in {
    imports = with inputs.self.lib.modules; [
      nixos."services.gitea"
    ];

    services = {
      gitea.settings = {
        server.ROOT_URL = "https://${gitdomain}/";
        session.COOKIE_SECURE = true;

        service.DISABLE_REGISTRATION = false;
      };

      openssh.settings.AllowUsers = [config.services.gitea.user];

      nginx.virtualHosts.${gitdomain} = {
        forceSSL = true;
        useACMEHost = "wildcard.lan";

        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.gitea.settings.server.HTTP_PORT}";
          proxyWebsockets = true;
          recommendedProxySettings = true;

          extraConfig = ''
            client_max_body_size 2048m;
          '';
        };
      };
    };
  };
}
