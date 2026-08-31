{
  flake.modules.homeManager.aseprite = {pkgs, ...}: {
    home.packages = with pkgs; [
      aseprite
    ];
  };
}
