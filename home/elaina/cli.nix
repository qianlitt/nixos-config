{
  mylib,
  myvar,
  ...
}: {
  imports = map mylib.root [
    "modules/home-manager/cli"
  ];

  modules.cli = {
    git = {
      enable = true;
      user = {
        name = myvar.git.user.name;
        email = myvar.git.user.email;
      };
      signing = {
        enable = true;
        key = myvar.git.signingKey;
      };
      gh.enable = true;
      tui.enable = true;
    };

    gpg = {
      enable = true;
      sshKeys = [myvar.gpg.keygrip];
      importKey = {
        enable = true;
        fingerprint = myvar.gpg.fingerprint;
      };
    };

    ai.enable = true;
  };
}
