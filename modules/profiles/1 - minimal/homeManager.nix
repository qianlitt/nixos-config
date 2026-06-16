# default settings needed for all homeManagerConfigurations
{inputs, ...}: {
  flake.modules.homeManager.profile-minimal = {
    config,
    pkgs,
    lib,
    ...
  }: {
    imports = with inputs.self.modules.homeManager; [
      nix
      sops
    ];

    home.homeDirectory =
      if pkgs.stdenv.isDarwin
      then (lib.mkForce "/Users/${config.home.username}")
      else "/home/${config.home.username}";
    home.stateVersion = "26.05";
  };
}
