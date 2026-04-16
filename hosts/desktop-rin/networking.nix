{
  config,
  inputs,
  ...
}: {
  imports = [inputs.sops-nix.nixosModules.sops];

  sops.secrets = {
    "wifi/home/ssid" = {};
    "wifi/home/psk" = {};
  };
  sops.templates."wifi-home.env" = {
    content = ''
      WIFI_SSID=${config.sops.placeholder."wifi/home/ssid"}
      WIFI_PSK=${config.sops.placeholder."wifi/home/psk"}
    '';
  };

  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";

    ensureProfiles = {
      environmentFiles = [config.sops.templates."wifi-home.env".path];
      profiles = {
        wireless = {
          connection = {
            id = "wireless";
            interface-name = "wlp108s0";
            timestamp = "1776342650";
            type = "wifi";
            uuid = "a4578a17-f214-4a5f-a544-cd2de88dc7a3";
          };
          ipv4 = {
            address1 = "192.168.1.101/24";
            dns = "192.168.1.200;223.5.5.5;";
            gateway = "192.168.1.200";
            method = "manual";
          };
          ipv6 = {
            addr-gen-mode = "default";
            method = "auto";
          };
          proxy = {};
          wifi = {
            mode = "infrastructure";
            ssid = "$WIFI_SSID";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$WIFI_PSK";
          };
        };
        wired = {
          connection = {
            autoconnect-priority = "-999";
            id = "wired";
            interface-name = "enp109s0";
            timestamp = "1776313697";
            type = "ethernet";
            uuid = "0ad5bddf-e55a-3db7-ba89-f580d2f00614";
          };
          ethernet = {};
          ipv4 = {
            address1 = "192.168.1.100/24";
            dns = "192.168.1.200;223.5.5.5;";
            gateway = "192.168.1.200";
            method = "manual";
          };
          ipv6 = {
            addr-gen-mode = "default";
            method = "auto";
          };
          proxy = {};
        };
      };
    };
  };
}
