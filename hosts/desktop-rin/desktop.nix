{
  mylib,
  myvar,
  ...
}: {
  imports = map mylib.root [
    "modules/nixos/desktop"
  ];

  modules.nixos.windowManager.hyprland = {
    enable = true;
    user = myvar.user.name;
  };
}
