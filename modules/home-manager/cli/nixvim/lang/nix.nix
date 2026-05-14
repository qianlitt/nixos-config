{
  programs.nixvim = {
    lsp.servers = {
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
    };
  };
}
