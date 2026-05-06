{
  config,
  lib,
  mylib,
  ...
}: let
  cfg = config.modules.desktop.game;
in {
  imports = [inputs.aagl.nixosModules.default];

  options.modules.desktop.game = {
    enable = lib.mkEnableOption "安装游戏";
  };

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      protontricks.enable = true;
    };

    # 启用 gamemode 以提升性能
    programs.gamemode.enable = true;

    # 解决 Steam 无法启动的问题
    # https://wiki.nixos.org/wiki/Steam#Steam_fails_to_start._What_do_I_do?
    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;

    # 解决 Lutris 安装过程中 openldap 编译失败的问题
    nixpkgs.overlays = [(import (mylib.root "overlays/openldap.nix"))];
  };
}
