{
  inputs,
  mylib,
  ...
}: {
  imports =
    mylib.scanModules ./.
    ++ [inputs.nixvim.homeModules.nixvim];

  programs.nixvim.enable = true;
}
