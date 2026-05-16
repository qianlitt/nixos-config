{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.programs.nixvim.plugins.treesitter.package) builtGrammars;
in {
  home.packages = with pkgs; [shellcheck shellharden shfmt];

  programs.nixvim = {
    plugins.conform-nvim.settings = {
      formatters_by_ft = {
        bash = ["shellcheck" "shellharden" "shfmt"];
      };

      formatters = {
        shellcheck.command = lib.getExe pkgs.shellcheck;
        shellharden.command = lib.getExe pkgs.shellharden;
        shfmt.command = lib.getExe pkgs.shfmt;
      };
    };

    plugins.treesitter.grammarPackages = lib.mkAfter [
      builtGrammars.bash
    ];
  };
}
