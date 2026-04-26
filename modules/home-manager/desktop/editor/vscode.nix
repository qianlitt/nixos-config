{pkgs, ...}: {
  stylix.targets.vscode.enable = false; # VSCode 主题由插件提供

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };
}
