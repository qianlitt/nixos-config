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

  programs.fish.enable = true;

  users.users."${myvar.user.name}" = {
    isNormalUser = true;
    description = "${myvar.user.name} - main user";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = myvar.user.authorizedKeys;
    hashedPasswordFile = config.sops.secrets."user/${myvar.user.name}/hashedPassword".path;
  };
}
