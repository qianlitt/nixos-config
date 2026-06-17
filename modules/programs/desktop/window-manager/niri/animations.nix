{
  flake.modules.homeManager.niri = {
    programs.niri.settings.animations = {
      window-open = {
        kind.easing = {
          curve = "cubic-bezier";
          duration-ms = 300;
          curve-args = [0.05 0.70 0.10 1.00];
        };
      };

      window-close = {
        kind.easing = {
          curve = "cubic-bezier";
          duration-ms = 300;
          curve-args = [0.05 0.70 0.10 1.00];
        };
      };

      window-resize = {
        kind.spring = {
          damping-ratio = 0.7;
          stiffness = 800;
          epsilon = 0.0001;
        };
      };

      window-movement = {
        kind.easing = {
          curve = "cubic-bezier";
          duration-ms = 300;
          curve-args = [0.05 0.70 0.10 1.00];
        };
      };

      workspace-switch = {
        kind.spring = {
          damping-ratio = 0.7;
          stiffness = 600;
          epsilon = 0.0001;
        };
      };

      horizontal-view-movement = {
        kind.spring = {
          damping-ratio = 1.0;
          stiffness = 600;
          epsilon = 0.00001;
        };
      };
    };
  };
}
