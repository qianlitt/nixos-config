{
  mylib,
  myvar,
  ...
}: {
  imports =
    mylib.scanModules ./.
    ++ (map mylib.root [
      "modules/home-manager/core"
      "modules/home-manager/ai"
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

  home.stateVersion = "25.11";
}
