{
  flake.modules.nixos.frieren = {
    # 禁用 NetworkManager
    networking = {
      networkmanager.enable = false;
      useNetworkd = true;
      enableIPv6 = false;
    };

    # systemd-networkd 配置
    systemd.network = {
      enable = true;
      networks = {
        "10-eth0" = {
          matchConfig.Name = "en*";
          DHCP = "no";
          address = [
            "192.168.1.101/24"
          ];
          gateway = [
            "192.168.1.1"
          ];
          dns = [
            "192.168.1.1"
            "1.1.1.1"
          ];
          linkConfig.RequiredForOnline = "routable";
        };
      };
    };
  };
}
