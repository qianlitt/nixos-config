{mylib, ...}: {
  imports = map mylib.root [
    "modules/nixos/cli"
  ];

  modules.cli = {
    ai.enable = true;
    gpg.enable = true;
    direnv.enable = true;
  };
}
