{mylib, ...}: {
  imports =
    mylib.scanModules ./.
    ++ [./git];
}
