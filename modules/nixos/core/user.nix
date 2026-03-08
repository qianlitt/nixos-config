{
  pkgs,
  myvar,
  ...
}: {
  users.users."${myvar.user.name}" = {
    isNormalUser = true;
    description = "${myvar.user.name} - main user";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = myvar.user.authorizedKeys;
  };
}
