{mylib, ...}: {
  imports = mylib.scanModules ./.;

  programs.fish = {
    enable = true;
  };
}
