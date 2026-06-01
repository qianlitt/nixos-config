# 只包含通用程序
{pkgs, ...}:
with pkgs; let
  editor = [neovim];
  dev-tools = [
    git
    wget
    curl
  ];
in {
  environment.systemPackages =
    editor
    ++ dev-tools;
}
