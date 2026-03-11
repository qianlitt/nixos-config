# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
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
    ++ [inputs.sops-nix.nixosModules.sops]
    ++ [(mylib.root "modules/nixos/core")];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # 网络设置
  networking.hostName = myvar.networking.host.server-frieren.hostName; # 设置主机名
  modules.nixos.networkd = {
    enable = true;

    wired = {
      enable = true;
      ip = "${myvar.networking.host.server-frieren.ip}/${toString myvar.networking.prefixLength}";
      gateway = "${myvar.networking.gateway}";
      dns = myvar.networking.dns;
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
