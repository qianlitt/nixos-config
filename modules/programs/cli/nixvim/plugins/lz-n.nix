# lz.n - lazy loader
{
  flake.modules.homeManager.nixvim = {
    programs.nixvim.plugins.lz-n.enable = true;
  };
}
