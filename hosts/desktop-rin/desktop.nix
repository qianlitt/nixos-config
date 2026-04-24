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

  modules.windowManager.hyprland = {
    enable = true;
    inherit user;
    quickshell = "noctalia";
  };

  modules.fcitx5 = {
    enable = true;
    inherit user;
  };
}
