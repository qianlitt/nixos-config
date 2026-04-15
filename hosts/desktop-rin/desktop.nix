{
  mylib,
  myvar,
  ...
}: let
  user = myvar.user.name;
in {
  imports = map mylib.root [
    "modules/nixos/desktop"
  ];

  modules.nixos.windowManager.hyprland = {
    enable = true;
    inherit user;
  };

  modules.nixos.fcitx5 = {
    enable = true;
    inherit user;
  };
}
