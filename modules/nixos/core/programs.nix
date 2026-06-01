# 只包含维护 NixOS 系统所必需的软件
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

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;

    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };
}
