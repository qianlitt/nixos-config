let
  utils = import ../utils;
in {
  programs.nixvim = {
    # nvim-lspconfig
    plugins.lsp = {
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
