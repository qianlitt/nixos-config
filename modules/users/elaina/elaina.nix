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
      nixos.${username} = {config, ...}: {
        imports = with self.modules.nixos; [
        ];

        sops.secrets = {
          "user/${username}/hashedPassword" = {neededForUsers = true;};
        };
        users.users.${username} = {
          description = "${username} - admin user";
          extraGroups = [
            "networkmanager"
            "docker"
            "podman"
            "i2c"
            "video"
            "render"
          ];
          openssh.authorizedKeys.keys = config.systemConstants.admin.authorizedKeys;
          hashedPasswordFile = config.sops.secrets."user/${username}/hashedPassword".path;
        };
      };

      darwin.${username} = {
        imports = with self.modules.darwin; [
        ];
      };

      homeManager.${username} = {pkgs, ...}: {
        imports = with self.modules.homeManager; [
          profile-cli
        ];

        # homeManagerModules 中的 sops 使用已有的 age 密钥
        sops.age.keyFile = "/home/${username}/.config/sops/age/keys.txt";

        home.packages = with pkgs; [
        ];
      };
    }
  ];
}
