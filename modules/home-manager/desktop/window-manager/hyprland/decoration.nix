{
  wayland.windowManager.hyprland.settings.decoration = {
    rounding_power = "2";
    rounding = "10";

    blur = {
      enabled = true;
      xray = true;
      special = false;
      new_optimizations = true;
      size = "10";
      passes = "3";
      brightness = "1";
      noise = "0.05";
      contrast = "0.89";
      vibrancy = "0.5";
      vibrancy_darkness = "0.5";
      popups = false;
      popups_ignorealpha = "0.6";
      input_methods = true;
      input_methods_ignorealpha = "0.8";
    };

    shadow = {
      enabled = true;
      ignore_window = true;
      range = "20";
      offset = "0 2";
      render_power = "10";
      color = "rgba(00000020)";
    };

    dim_inactive = true;
    dim_strength = "0.05";
    dim_special = "0.2";
  };
}
