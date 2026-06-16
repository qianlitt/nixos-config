# default settings needed for all nixosConfigurations
{inputs, ...}: {
  flake.modules.nixos.profile-minimal = {
    imports = with inputs.self.modules.nixos; [
      disko
      grub
      i18n
      kernel
      nix
      sops
      time
    ];

    system.stateVersion = "25.11";
  };
}
