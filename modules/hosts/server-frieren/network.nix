{
  flake.modules.nixos.frieren = {config, ...}: {
    # 禁用 NetworkManager
    networking = {
      networkmanager.enable = false;
      useNetworkd = true;
    };

    # systemd-networkd 配置
    systemd.network = {
      enable = true;
      netdevs."10-bond0" = {
        netdevConfig = {
          Kind = "bond";
          Name = "bond0";
        };
        bondConfig = {
          Mode = "active-backup";
          MIIMonitorSec = "1000ms";
        };
      };
      networks = {
        "30-eth0" = {
          matchConfig.Name = "en*";
          networkConfig.Bond = "bond0";
        };
        "30-wlan0" = {
          matchConfig.Name = "wl*";
          networkConfig.Bond = "bond0";
          linkConfig.RequiredForOnline = "no";
        };
        "40-bond0" = {
          matchConfig.Name = "bond0";
          DHCP = "no";
          address = [
            "192.168.1.102/24"
          ];
          gateway = [
            "192.168.1.200"
          ];
          dns = [
            "192.168.1.200"
          ];
          linkConfig.RequiredForOnline = "carrier";
        };
      };
    };

    # Wi-Fi 配置
    # 禁用 wpa_supplicant，使用 iwd
    networking.wireless = {
      enable = false;
      iwd = {
        enable = true;
        settings = {
          General = {
            EnableNetworkConfiguration = false;
          };
        };
      };
    };

    sops.secrets."wifi/home/psk" = {};
    sops.templates."GONGNIU-7490.psk" = {
      content = ''
        [Security]
        Passphrase=${config.sops.placeholder."wifi/home/psk"}

        [Settings]
        AutoConnect=true
      '';
    };
    systemd = {
      tmpfiles.rules = [
        "d /var/lib/iwd 0700 root root -"
      ];
      # 在 iwd 启动前创建链接
      services.iwd = {
        preStart = ''
          ln -sf ${config.sops.templates."GONGNIU-7490.psk".path} /var/lib/iwd/GONGNIU-7490.psk
        '';
        restartTriggers = [config.sops.secrets."wifi/home/psk".path];
      };
    };
  };
}
