{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.services.ariang;
in {
  options.modules.services.ariang = {
    enable = lib.mkEnableOption "启用 AriaNg 服务";

  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ariang];

  };
}
