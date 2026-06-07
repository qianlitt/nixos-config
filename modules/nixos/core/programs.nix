# 只包含通用程序
{pkgs, ...}:
with pkgs; let
  editor = [neovim];
  dev-tools = [
    git
    wget
    curl

    # Nix
    nil # lsp
    nixd # lsp
    alejandra # formatter
    nurl # Generate Nix fetcher calls from repository URLs
  ];
in {
  environment.systemPackages =
    editor
    ++ dev-tools;
}
