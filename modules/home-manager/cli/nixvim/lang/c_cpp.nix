{
  programs.nixvim = {
    lsp.servers = {
      clangd.enable = true;
    };
  };
}
