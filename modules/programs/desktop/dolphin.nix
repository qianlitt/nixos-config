{
  flake.modules.nixos.dolphin = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.modules.desktop.dolphin;
  in {
    options.modules.desktop.dolphin = {
      enable = lib.mkEnableOption "安装 dolphin，KDE 桌面的文件管理器";
    };

    config = lib.mkIf cfg.enable {
      environment.systemPackages = with pkgs.kdePackages; [
        qtsvg
        kio
        kio-fuse
        kio-extras
        kde-cli-tools
        dolphin
      ];
    };
  };
}
