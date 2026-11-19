{inputs, ...}: {
  flake.modules.nixos.frieren = {
    imports = with inputs.self.lib.modules; [
      nixos.profile-cli

      nixos."services.ssh"
    ];

    documentation.enable = false;
    services = {
      qemuGuest.enable = true;
      openssh.settings.AllowUsers = ["elaina"];
    };

    modules = {
      grub.enable = true;
      i18n.enable = true;
    };
  };
}
