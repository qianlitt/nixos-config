{
  self,
  lib,
  ...
}: let
  username = "elaina";
in {
  flake.modules = lib.mkMerge [
    (self.factory.user username true)
    {
      nixos.${username} = {
        imports = with self.modules.nixos; [
        ];
        users.users.${username} = {
        };
      };

      darwin.${username} = {
        imports = with self.modules.darwin; [
        ];
      };

      homeManager.${username} = {pkgs, ...}: {
        imports = with self.modules.homeManager; [
          profile-minimal
        ];
        home.packages = with pkgs; [
        ];
      };
    }
  ];
}
