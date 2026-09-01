# RustFS - object storage system
# S3 兼容，替代 MinIO
{inputs, ...}: {
  flake-file.inputs = {
    rustfs.url = "github:rustfs/rustfs-flake";
    rustfs.inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos."services.rustfs" = {
    lib,
    pkgs,
    ...
  }: {
    # 禁用 nixpkgs 的 rustfs 模块
    disabledModules = ["services/web-servers/rustfs.nix"];
    imports = [inputs.rustfs.nixosModules.rustfs];

    services = {
      rustfs = {
        enable = true;
        package = lib.mkDefault inputs.rustfs.packages.${pkgs.stdenv.hostPlatform.system}.default;

        user = lib.mkDefault "rustfs";
        group = lib.mkDefault "rustfs";

        volumes = lib.mkDefault "/var/lib/rustfs";

        logDirectory = lib.mkDefault "/var/log/rustfs";
        logLevel = lib.mkDefault "info";

        address = lib.mkDefault ":9000";

        consoleEnable = lib.mkDefault true;
        # 需要 SSH 转发: `ssh -L 9001:localhost:9001 server`
        consoleAddress = lib.mkDefault "127.0.0.1:9001";
      };
      logrotate = {
        enable = true;
        settings.rustfs = {
          files = "/var/log/rustfs/*.log";
          frequency = "daily";
          rotate = 7;
          compress = true;
          delaycompress = true;
          missingok = true;
          notifempty = true;
          create = "0640 rustfs rustfs";
        };
      };
    };
  };
}
