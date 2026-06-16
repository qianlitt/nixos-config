{
  flake.modules.nixos.frieren = {
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/disk/by-id/ata-Samsung_SSD_870_EVO_1TB_S75DNX0Y111182B";
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

    # zram
    zramSwap = {
      enable = true;
      # 压缩算法
      # 检查设备支持的算法: `cat /sys/class/block/zram*/comp_algorithm`
      algorithm = "zstd";
      memoryPercent = 100;
      priority = 100;
    };
    # zram optimization
    # see: https://wiki.archlinux.org/title/Zram#Optimizing_swap_on_zram
    boot.kernel.sysctl = {
      "vm.swappiness" = 180;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;
    };
  };
}
