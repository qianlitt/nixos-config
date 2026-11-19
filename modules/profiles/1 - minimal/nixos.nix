# default settings needed for all nixosConfigurations
{inputs, ...}: {
  flake.modules.nixos.profile-minimal = {
    imports = with inputs.self.lib.modules.nixos; [
      disko
      grub
      kernel
      nix
      nur
      sops
      time
    ];

    system.stateVersion = "25.11";
  };
}
