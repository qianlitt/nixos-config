{
  config,
  pkgs,
  inputs,
  mylib,
  myvar,
  ...
}: {
  imports =
    mylib.scanModules ./.
    ++ (map mylib.root [
      "modules/nixos/core"
    ]);

  # bootloader
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      configurationLimit = 10;
      default = "saved";
    };
  };

  # kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    # disable watchdog
    "nowatchdog"
    "modprobe.blacklist=iTCO_wdt"

    "acpi_backlight=native"
  ];

  # 网络设置
  networking.hostName = "rin"; # 设置主机名
  modules.nixos.networkd = {
    enable = true;
    wired = {
      enable = true;
      ip = "192.168.1.100/24";
      gateway = "192.168.1.200";
      dns = [
        "192.168.1.200"
        "223.5.5.5"
        "1.1.1.1"
      ];
    };
  };

  # 国际化设置
  modules.nixos.i18n = {
    enable = true;
    profile = "zh";
  };

  # SSH 设置
  modules.nixos.ssh = {
    enable = true;
    allowPassword = false;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
