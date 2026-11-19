{inputs, ...}: {
  flake.modules.nixos.frieren = {
    imports = with inputs.self.lib.modules;
      [
        nixos.profile-cli

        nixos."services.ssh"
      ]
      ++ [
        (inputs.self.factory.i18n {lang = "en";})
      ];

    documentation.enable = false;
    services = {
      qemuGuest.enable = true;
      openssh.settings.AllowUsers = ["elaina"];
    };
  };
}
