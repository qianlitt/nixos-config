{
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.extraConfig = builtins.readFile ./lua/keybinds.lua;
  };
}
