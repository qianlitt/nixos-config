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
        imports = with self.lib.modules.nixos; [
        ];
        users.users.${username} = {
        };
      };

      darwin.${username} = {
        imports = with self.lib.modules.darwin; [
        ];
      };

      homeManager.${username} = {pkgs, ...}: {
        imports = with self.lib.modules.homeManager; [
          profile-minimal
        ];
        home.packages = with pkgs; [
        ];
      };
    }
  ];
}
