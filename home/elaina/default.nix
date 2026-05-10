{
  lib,
  mylib,
  hostConfig,
  ...
}: let
  isType = t: (hostConfig.type or "") == t;
in {
  imports =
    (map mylib.root [
      "modules/home-manager/core"
    ])
    ++ lib.optionals (isType "server") [
      ./cli.nix
    ]
    ++ lib.optionals (isType "desktop") [
      ./cli.nix
      ./desktop.nix
    ];

  home.stateVersion = "26.05";
}
