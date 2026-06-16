{inputs, ...}: {
  flake-file.inputs = {
    nixvim = {
      url = "github:nix-community/nixvim";
    };
  };

  flake.modules.homeManager.nixvim = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.modules.cli.nixvim;
  in {
    imports = [
      inputs.nixvim.homeModules.nixvim
      inputs.self.modules.generic.nixvimIcons
    ];

    options.modules.cli.nixvim = {
      enable = lib.mkEnableOption "nixvim";

      # TODO: preset -> enum ["minimal" "full"]

      completion = {enable = lib.mkEnableOption "code completion";};
      lsp = {enable = lib.mkEnableOption "LSP support";};
      format = {enable = lib.mkEnableOption "code formatting";};
      lint = {enable = lib.mkEnableOption "linting";};
      treesitter = {enable = lib.mkEnableOption "syntax highlighting";};
    };

    config = lib.mkIf cfg.enable {
      programs.nixvim = {
        # BUG: "linux-kernel has been removed" 的临时解决方案
        # https://github.com/nix-community/nixvim/issues/4426
        nixpkgs.useGlobalPackages = true;

        enable = true;

        # 设置主题
        colorschemes.tokyonight.enable = true;

        # 设置 $EDITOR 和 $VISUAL 为 nvim
        defaultEditor = true;

        # 设置 'vi', 'vim' 的别名
        viAlias = true;
        vimAlias = true;

        # 设置剪贴板支持
        clipboard = {
          # 使用 wl-copy
          providers.wl-copy.enable = true;

          # 系统剪贴板
          # unnamed: 在别处可以直接中键粘贴，但不会进入 Ctrl+V 的剪贴板
          # unnamedplus: 在别处可以直接 Ctrl+V 粘贴
          register = "unnamedplus";
        };

        # 性能优化
        performance.byteCompileLua.enable = true; # 预编译 lua
      };
    };
  };
}
