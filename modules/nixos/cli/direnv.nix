{
  config,
  lib,
  ...
}: let
  cfg = config.modules.cli.direnv;
in {
  options.modules.cli.direnv = {
    enable = lib.mkEnableOption "安装并配置 direnv";
  };

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;

      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
  };
}
