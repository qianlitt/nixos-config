{
  mylib,
  myvar,
  ...
}: {
  imports =
    mylib.scanModules ./.
    ++ [(mylib.root "modules/home-manager/core")];

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

  home.stateVersion = "25.11";
}
