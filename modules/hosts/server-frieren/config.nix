{inputs, ...}: {
  flake.modules.nixos.frieren = {
    imports = [
      inputs.self.modules.nixos.profile-cli
    ];

    documentation.enable = false;
    services.qemuGuest.enable = true;

    modules = {
      grub.enable = true;
      i18n.enable = true;
    };
  };
}
