{
  flake.modules.nixos.grub = {
    config,
    lib,
    ...
  }: let
    cfg = config.modules.grub;
  in {
    options.modules.grub = {
      enable = lib.mkEnableOption "启用 GRUB Bootloader";

      type = lib.mkOption {
        type = lib.types.enum ["uefi" "legacy"];
        default = "uefi";
        example = "legacy";
        description = "GRUB 启动模式";
      };

      device = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "当 GRUB 以 Legacy 模式启动时，指定 GRUB 安装的设备";
      };
    };

    config = lib.mkIf cfg.enable (lib.mkMerge [
      # UEFI
      (lib.mkIf (cfg.type == "uefi") {
        boot.loader = {
          efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot";
          };
          grub = {
            enable = true;
            device = "nodev";
            efiSupport = true;
            useOSProber = true;
            configurationLimit = 10;
            default = "saved";
          };
        };
      })

      # Legacy
      (lib.mkIf (cfg.type == "legacy") {
        boot.loader.grub = {
          enable = true;
          inherit (cfg) device;
          useOSProber = true;
        };
      })
    ]);
  };
}
