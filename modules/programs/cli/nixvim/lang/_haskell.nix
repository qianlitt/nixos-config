{
  lib,
  pkgs,
}: {
  lsp.hls = {
    # HLS/GHC 放在 PATH 末尾，项目 devShell 里的同名工具优先。
    packageFallback = true;

    ghc = {
      enable = true;
      packageFallback = true;
      package = pkgs.haskellPackages.ghc;
    };

    config.settings.haskell = {
      formattingProvider = "fourmolu";
      # hlint 交给 nvim-lint，避免 HLS 内置 hlint 诊断重复
      plugin.hlint.globalOn = false;
    };
  };

  conform = {
    formatters_by_ft.haskell = ["fourmolu"];
    commands.fourmolu = lib.getExe pkgs.fourmolu;
  };

  lint.haskell = ["hlint"];
  treesitter = ["haskell"];

  extraPackages = with pkgs; [
    fourmolu
    hlint
  ];
}
