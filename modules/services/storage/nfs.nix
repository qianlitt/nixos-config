{
  flake.modules.nixos."services.nfs" = {
    config,
    lib,
    ...
  }: let
    cfg = config.modules.services.nfs;
  in {
    options.modules.services.nfs = {
      enable = lib.mkEnableOption "启用 NFS 服务器（推荐 NFSv4）";

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "是否开放 TCP 2049（NFSv4）";
      };

      exports = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = "写入 /etc/exports 的导出配置，格式见 exports(5)";
      };

      nproc = lib.mkOption {
        type = lib.types.int;
        default = 4;
        description = "NFS 服务线程数";
      };

      hostName = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "NFS 监听地址；null 表示所有地址";
      };
    };

    config = lib.mkIf cfg.enable {
      services.nfs.server = {
        enable = true;
        inherit (cfg) exports nproc hostName;
        createMountPoints = true;
      };

      networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [2049];
    };
  };
}
