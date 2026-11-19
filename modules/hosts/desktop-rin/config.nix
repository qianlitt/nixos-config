{inputs, ...}: {
  flake.modules.nixos.rin = {
    imports = with inputs.self.lib.modules.nixos;
      [
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
      ]
      ++ [
        (inputs.self.factory.i18n {lang = "zh";})
      ];

    boot.kernelParams = [
      "acpi_backlight=native" # 笔记本屏幕背光
    ];
  };
}
