{mylib, ...}: {
  imports =
    mylib.scanModules ./.
    ++ (map mylib.root [
      "modules/home-manager/core"
    ]);

  home.stateVersion = "26.05";
}
