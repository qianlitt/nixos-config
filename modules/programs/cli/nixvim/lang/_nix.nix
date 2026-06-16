{
  lib,
  pkgs,
}: {
  lsp.nixd = {
    config = {
      cmd = ["nixd"];
      filetypes = ["nix"];
      root_markers = ["flake.nix" ".git"];
      settings = {
        nixd = {
          nixpkgs.expr = "import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs { }";
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
  conform = {
    formatters_by_ft.nix = ["alejandra"];
    commands.alejandra = lib.getExe pkgs.alejandra;
  };
  treesitter = ["nix"];
}
