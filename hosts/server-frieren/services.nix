{
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
      };
    };
  };
}
