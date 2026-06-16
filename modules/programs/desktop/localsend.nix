{
  flake.modules.nixos.localsend = {
    config,
    lib,
    ...
  }: let
    cfg = config.modules.desktop.localsend;
  in {
    options.modules.desktop.localsend = {
      enable = lib.mkEnableOption "安装 LocalSend";
    };

    config = lib.mkIf cfg.enable {
      programs.localsend = {
        enable = true;
        openFirewall = true;
      };
    };
  };
}
