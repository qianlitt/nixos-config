{
  flake.modules.nixos.kernel = {pkgs, ...}: {
    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.kernelParams = [
      # disable watchdog
      "nowatchdog"
      "modprobe.blacklist=iTCO_wdt"
    ];
  };
}
