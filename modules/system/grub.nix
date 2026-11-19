{
  flake = {
    modules.nixos.grub = {
      # UEFI
      boot.loader = {
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };
        timeout = 1;
        grub = {
          enable = true;
          device = "nodev";
          efiSupport = true;
          useOSProber = true;
          configurationLimit = 10;
          default = "saved";
        };
      };
    };

    factory."grub.legacy" = {device}: {
      boot.loader = {
        timeout = 1;
        grub = {
          enable = true;
          inherit device;
          useOSProber = true;
        };
      };
    };
  };
}
