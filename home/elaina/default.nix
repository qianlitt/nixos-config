{
  mylib,
  myvar,
  ...
}: {
  imports =
    mylib.scanModules ./.
    ++ (map mylib.root [
      "modules/home-manager/core"
      "modules/home-manager/cli"
      "modules/home-manager/desktop"
    ]);

  # git
  modules.git = {
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

  # gpg
  modules.gpg = {
    enable = true;
    sshKeys = [myvar.gpg.keygrip];
    importKey = {
      enable = true;
      fingerprint = myvar.gpg.fingerprint;
    };
  };

  modules.cli.ai.enable = true;

  home.stateVersion = "26.05";
}
