{
  flake.modules.nixos."services.samba" = {
    config,
    lib,
    ...
  }: {
    services.samba = {
      enable = true;
      openFirewall = true;

      # 仅使用 SMB2+，不需要 NetBIOS 名称服务
      nmbd.enable = false;

      # 不使用 AD / 域控制器，不需要 Winbind
      winbindd.enable = false;

      settings.global = {
        workgroup = lib.mkDefault "WORKGROUP";
        "server string" = lib.mkDefault config.networking.hostName;
        security = lib.mkDefault "user";
        "passdb backend" = lib.mkDefault "tdbsam";
        "map to guest" = lib.mkDefault "never";
      };
    };
  };
}
