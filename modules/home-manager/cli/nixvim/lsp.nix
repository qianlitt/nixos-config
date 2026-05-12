let
  utils = import ./utils;
in {
  programs.nixvim = {
    # nvim-lspconfig
    plugins.lspconfig = {
      enable = true;
      lazyLoad.settings.event = ["BufReadPre" "BufNewFile"];
    };

    lsp = {
      inlayHints.enable = true;
      servers = {
        lua_ls.enable = true; # Lua
        # Nix
        nixd = {
          enable = true;
          config = {
            cmd = ["nixd"];
            filetypes = ["nix"];
            root_markers = ["flake.nix" ".git"];
            settings = {
              nixd = {
                nixpkgs.expr = "import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs { }"; # 当前 flake 的 nixpkgs inputs
                formatting.command = ["alejandra"];
                options = {
                  nixos.expr = ''
                    let
                      hostname = builtins.replaceStrings ["\n"] [""] (builtins.readFile /etc/hostname);
                    in
                      (builtins.getFlake (builtins.toString ./.)).nixosConfigurations.''${hostname}.options
                  '';
                  home-manager.expr = ''
                    let
                      hostname = builtins.replaceStrings ["\n"] [""] (builtins.readFile /etc/hostname);
                    in
                      (builtins.getFlake (builtins.toString ./.)).nixosConfigurations.''${hostname}.options.home-manager.users.type.getSubOptions []
                  '';
                };
              };
            };
          };
        };

        clangd.enable = true; # C/C++
        pyright.enable = true; # Python
        rust_analyzer.enable = true; # Rust
      };
    };

    # 诊断
    diagnostic.settings = {
      bufferline = true;
      float = true;
      jump = {
        float = false;
        wrap = true;
      };
      severity_sort = true;
      signs.text = {
        "ERROR" = utils.icons.diagnostics.Error;
        "WARN" = utils.icons.diagnostics.Warn;
        "HINT" = utils.icons.diagnostics.Hint;
        "INFO" = utils.icons.diagnostics.Info;
      };
      underline = true;
      update_in_insert = false;
      vitrual_lines = false;
      virtual_text = {
        prefix = "●";
        source = "if_many";
        spacing = 4;
      };
    };
  };
}
