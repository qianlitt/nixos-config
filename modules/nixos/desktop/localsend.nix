{
  config,
  lib,
  ...
}: let
  cfg = config.modules.desktop.programs.localsend;
in {
  options.modules.desktop.programs.localsend = {
    enable = lib.mkEnableOption "安装 LocalSend";
  };

  config = lib.mkIf cfg.enable {
    programs.localsend = {
      enable = true;
      openFirewall = true;
    };
  };
}
