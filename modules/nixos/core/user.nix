{
  config,
  pkgs,
  inputs,
  myvar,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops.secrets = {
    "user/${myvar.user.name}/hashedPassword" = {neededForUsers = true;};
  };

  users.users."${myvar.user.name}" = {
    isNormalUser = true;
    description = "${myvar.user.name} - main user";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = myvar.user.authorizedKeys;
    hashedPasswordFile = config.sops.secrets."user/${myvar.user.name}/hashedPassword".path;
  };
}
