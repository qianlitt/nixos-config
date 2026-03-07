{inputs, ...}: {
  imports = [
    inputs.disko.nixosModules.disko
  ];

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "table";
          format = "msdos"; # MBR 分区
          partitions = [
            # 交换分区
            {
              name = "swap";
              part-type = "primary";
              start = "1M";
              end = "9G";
              content = {
                type = "swap";
              };
            }
            # 剩余分给 root 分区
            {
              name = "root";
              part-type = "primary";
              start = "9G";
              end = "100%";
              bootable = true;
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            }
          ];
        };
      };
    };
  };
}
