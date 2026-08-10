{inputs, ...}: {
  flake.modules.nixos.frieren = {
    imports = [
      inputs.self.modules.nixos.profile-cli
    ];

    documentation.enable = false;

    modules = {
      grub = {
        enable = true;
        type = "legacy";
        device = "/dev/sda";
      };

      i18n.enable = true;
    };
  };
}
