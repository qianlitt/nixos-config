{
  flake.modules.homeManager.shell = {
    programs = {
      bash.enable = true;
      fish.enable = true;
    };
  };
}
