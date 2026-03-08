# 只包含维护 NixOS 系统所必需的软件
{pkgs, ...}:
with pkgs; let
  editor = [neovim];
  dev-tools = [
    git
    wget
    curl
  ];
  dev-nix = [
    nil # nix lsp
    alejandra # nix 格式化工具
  ];
in {
  environment.variables.EDITOR = "nvim";
  environment.systemPackages =
    editor
    ++ dev-tools
    ++ dev-nix;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.nix-ld.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;

    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };
}
