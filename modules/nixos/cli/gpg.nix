{
  config,
  lib,
  ...
}: let
  cfg = config.modules.cli.gpg;
in {
  options.modules.cli.gpg = {
    enable = lib.mkEnableOption "安装并配置 gpg";
  };

  config = lib.mkIf cfg.enable {
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
