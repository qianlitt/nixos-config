{
  flake.modules.generic.systemConstants = {lib, ...}: {
    options.systemConstants = lib.mkOption {
      type = lib.types.attrsOf lib.types.unspecified;
      default = {};
    };

    config.systemConstants = rec {
      admin = {
        userName = "elaina";
        email = "zvdiek@gmail.com";
        domain = "1806016.xyz";
        authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIql1DkkFW4n1tntQxVblT3+9Lv/d8hm7i7JWZEfzrbx bitwarden@nixos"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICqTv14u4PA/Vox3HYIthOutdu9u6wSOVTWPAUf+2Gd5 openpgp"
        ];
      };

      git = {
        user = {
          name = "qianlitt";
          inherit (admin) email;
        };
        signingKey = "C6D152AC471FA822";
      };

      gpg = {
        fingerprint = "0CB3CD14D0F1B7A9F6AD5C354E004C3156B7F62C";
        keygrip = "DCFEB7A1BE160772B4E535E3C8F28DD69507AA23";
      };

      host = {
        rin = {
          monitors = {
            "eDP-1" = {
              width = 2560;
              height = 1600;
              refreshRate = 60.002;
              scale = 1.6;
              position = {
                x = 0;
                y = 0;
              };
            };
            "eDP-2" = host.rin.monitors.eDP-1;
            "DP-1" = {
              primaryMonitor = true; # 设为主显示器
              width = 3840;
              height = 2560;
              refreshRate = 59.984;
              scale = 1.6;
              position = {
                x = 1600;
                y = -300;
              };
            };
            "DP-3" = host.rin.monitors.DP-1;
          };
        };
      };
    };
  };
}
