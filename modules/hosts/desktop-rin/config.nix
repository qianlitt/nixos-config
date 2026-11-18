{inputs, ...}: {
  flake.modules.nixos.rin = {
    imports = with inputs.self.lib.modules.nixos; [
      profile-cli

      audio
      displayManager
      dolphin
      fcitx5
      fonts
      keyboard
      localsend

      hyprland
      # niri
      noctalia
      game
      stylix
    ];

    boot.kernelParams = [
      "acpi_backlight=native" # 笔记本屏幕背光
    ];

    modules = {
      grub.enable = true;
      i18n.enable = true;

      desktop = {
        quickshell.noctalia.enable = true;
        windowManager = {
          hyprland.enable = true;
        };

        localsend.enable = true;
        stylix.enable = true;
      };
    };
  };
}
