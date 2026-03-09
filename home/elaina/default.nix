{mylib, ...}: {
  imports =
    mylib.scanModules ./.;

  home.stateVersion = "25.11";
}
