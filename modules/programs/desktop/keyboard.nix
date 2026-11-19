{
  flake.modules.nixos.keyboard = {
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
}
