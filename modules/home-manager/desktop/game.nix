{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.game;
in {
  options.modules.desktop.game = {
    enable = lib.mkEnableOption "安装游戏";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # 帧率、温度、负载显示
      # https://github.com/flightlessmango/MangoHud
      mangohud

      # Proton 管理器
      protonplus
      # Wine 环境下快速安装各种 Windows 组件
      winetricks
      # Windows 游戏统一启动器
      # https://github.com/Open-Wine-Components/umu-launcher
      umu-launcher

      # 二进制文件编辑器
      bbe
    ];

    # Lutris
    programs.lutris = {
      enable = true;
      winePackages = with pkgs; [
        wineWow64Packages.full
      ];
      extraPackages = with pkgs; [
        winetricks
        gamescope
        gamemode
        mangohud
        umu-launcher
      ];
    };
  };
}
