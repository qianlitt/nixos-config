{
  flake.modules.nixos.displayManager = {
    config,
    lib,
    ...
  }: let
    cfg = config.modules.desktop.displayManager;
  in {
    options.modules.desktop.displayManager = {
      enable = lib.mkEnableOption "启用 display manager";
    };

    config = lib.mkIf cfg.enable {
      services.displayManager.ly.enable = true;
    };
  };
}
