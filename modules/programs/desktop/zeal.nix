# zeal - 离线文档工具
{
  flake.modules.homeManager.zeal = {pkgs, ...}: {
    home.packages = with pkgs; [
      zeal
    ];
  };
}
