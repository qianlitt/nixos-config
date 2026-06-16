{
  lib,
  pkgs,
}: {
  lsp = {
    basedpyright = {
      config = {
        settings = {
          basedpyright = {disableOrganizeImports = true;};
          python = {analysis = {typeCheckingMode = "recommended";};};
        };
      };
    };
    ruff = {};
  };
  conform = {
    formatters_by_ft.python = ["ruff"];
    commands.ruff = lib.getExe pkgs.ruff;
  };
  treesitter = ["python"];
}
