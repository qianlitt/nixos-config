{
  flake.modules.nixos.frieren = {
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                priority = 1;
                type = "EF00";
                start = "1M";
                end = "128M";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = ["umask=0077"];
                };
              };
              root = {
                size = "100%";
                content = {
                  type = "btrfs";
                  extraArgs = ["-f"];

                  subvolumes = {
                    # 根目录
                    "@root" = {
                      mountpoint = "/";
                      mountOptions = [
                        "compress=zstd:3" # 压缩等级3
                        "noatime" # 减少写放大
                        "nodiratime"
                      ];
                    };

                    # Nix store
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "compress=zstd:3"
                        "noatime"
                      ];
                    };

                    # 用户数据
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "compress=zstd:3"
                      ];
                    };

                    # 日志目录
                    "@var-log" = {
                      mountpoint = "/var/log";
                      mountOptions = [
                        "compress=none"
                        "noatime"
                      ];
                    };

                    # 媒体库：视频/音乐本身已压缩，不再 zstd
                    "@media" = {
                      mountpoint = "/mnt/media";
                      mountOptions = [
                        "compress=no"
                        "noatime"
                        "nodiratime"
                        "nofail"
                      ];
                    };

                    # 家庭共享：文档为主，轻量压缩
                    "@shares" = {
                      mountpoint = "/srv/shares";
                      mountOptions = [
                        "compress=zstd:1"
                        "noatime"
                        "nodiratime"
                        "nofail"
                      ];
                    };

                    # 其他设备的备份接收目录
                    "@backups" = {
                      mountpoint = "/mnt/backups";
                      mountOptions = [
                        "compress=no"
                        "noatime"
                        "nodiratime"
                        "nofail"
                      ];
                    };

                    # Immich 媒体
                    "@immich" = {
                      mountpoint = "/mnt/immich";
                      mountOptions = [
                        "compress=zstd:1"
                        "noatime"
                        "nofail"
                      ];
                    };

                    # RustFS / Niks3 对象数据
                    "@s3" = {
                      mountpoint = "/mnt/s3";
                      mountOptions = [
                        "compress=no"
                        "noatime"
                        "nodiratime"
                        "nofail"
                      ];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };

    # btrfs scrub
    services.btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
    };

    # zram
    zramSwap = {
      enable = true;
      # 压缩算法
      # 检查设备支持的算法: `cat /sys/class/block/zram*/comp_algorithm`
      algorithm = "zstd";
      memoryPercent = 75;
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
