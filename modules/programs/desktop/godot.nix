{
  flake.modules.homeManager.godot = {pkgs, ...}: {
    home.packages = with pkgs; [
      godot
    ];
  };
}
