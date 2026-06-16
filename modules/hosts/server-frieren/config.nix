{inputs, ...}: {
  flake.modules.nixos.frieren = {
    imports = [
      inputs.self.modules.nixos.profile-cli
    ];

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
