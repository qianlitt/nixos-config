{
  pkgs,
  myvar,
  ...
}: {
  services.xserver.videoDrivers = ["modesetting" "nvidia"];
  hardware.nvidia = {
    open = true;

    modesetting.enable = true;

    powerManagement = {
      enable = true;
      finegrained = true;
    };

    prime = {
      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:1@0:0:0";
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };
  hardware.graphics = {
    enable = true;

    extraPackages = with pkgs; [
      intel-media-driver
      nvidia-vaapi-driver
      libvdpau-va-gl
    ];
  };

  users.users."${myvar.user.name}".extraGroups = ["video" "render"];
}
