{
  flake.modules.nixos.dolphin = {pkgs, ...}: {
    environment.systemPackages = with pkgs.kdePackages; [
      qtsvg
      kio
      kio-fuse
      kio-extras
      kde-cli-tools
      dolphin
    ];
  };
}
