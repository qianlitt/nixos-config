# zoxide - 智能目录跳转工具
{
  flake.modules.homeManager.zoxide = {
    programs.zoxide = {
      enable = true;

      enableBashIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
    };
  };
}
