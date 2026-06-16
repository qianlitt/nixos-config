{
  flake.modules.homeManager.nixvim = {
    config,
    lib,
    ...
  }: let
    inherit (config.modules.cli.nixvim) lsp;
  in
    lib.mkIf lsp.enable {
      programs.nixvim = {
        # nvim-lspconfig
        plugins.lspconfig = {
          enable = true;
          lazyLoad.settings.event = ["BufReadPre" "BufNewFile"];
        };

        lsp = {
          inlayHints.enable = true;
        };

        diagnostic.settings = {
          bufferline = true;
          float = true;
          jump = {
            float = false;
            wrap = true;
          };
          severity_sort = true;
          signs.text = {
            "ERROR" = config.nixvimIcons.diagnostics.Error;
            "WARN" = config.nixvimIcons.diagnostics.Warn;
            "HINT" = config.nixvimIcons.diagnostics.Hint;
            "INFO" = config.nixvimIcons.diagnostics.Info;
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
    };
}
