{
  config,
  lib,
  ...
}: let
  cfg = config.modules.nixos.windowManager.hyprland;
in {
  config = lib.mkIf cfg.enable {
    home-manager.users.${cfg.user}.wayland.windowManager.hyprland.settings.exec-once = ["fcitx5 -d"];
  };
}
