{
  flake.modules.nixos.keyboard = {
    config,
    lib,
    ...
  }: let
    cfg = config.modules.desktop.keyboard;
  in {
    options.modules.desktop.keyboard = {
      enable = lib.mkEnableOption "启用键盘配置";
    };

    config = lib.mkIf cfg.enable {
      services = {
        xserver.xkb = {
          layout = "us";
          variant = "";
        };

        keyd = {
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
    };
  };
}
