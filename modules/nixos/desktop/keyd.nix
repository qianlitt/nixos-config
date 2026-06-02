{
  config,
  lib,
  ...
}: let
  cfg = config.modules.desktop.keyd;
in {
  options.modules.desktop.keyd = {
    enable = lib.mkEnableOption "启用 keyd 键盘映射";
  };

  config = lib.mkIf cfg.enable {
    services.keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = ["*"];
          settings = {
            main = {
              capslock = "overload(control, esc)";
              esc = "capslock";
            };
          };
        };
      };
    };
  };
}
