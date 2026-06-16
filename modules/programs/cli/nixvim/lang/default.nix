{
  flake.modules.homeManager.nixvim = {
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (config.modules.cli.nixvim) lsp format lint treesitter;
    inherit (config.programs.nixvim.plugins.treesitter.package) builtGrammars;

    allConfigs =
      builtins.filter (x: x != null)
      (lib.mapAttrsToList (
        name: type:
          if type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix"
          then import (./. + "/${name}") {inherit lib pkgs;}
          else null
      ) (builtins.readDir ./.));

    mergeField = name:
      lib.foldl' (acc: cfg: lib.recursiveUpdate acc (cfg.${name} or {})) {} allConfigs;

    allConform = mergeField "conform";
    allLint = mergeField "lint";
    allTreesitter = lib.flatten (map (cfg: cfg.treesitter or []) allConfigs);
    allExtraPackages = lib.flatten (map (cfg: cfg.extraPackages or []) allConfigs);
  in {
    programs.nixvim = {
      lsp.servers = lib.mkIf lsp.enable (
        lib.mkMerge (map (
            cfg:
              lib.mapAttrs (_name: svr: {enable = true;} // svr) (cfg.lsp or {})
          )
          allConfigs)
      );

      plugins = {
        conform-nvim.settings = lib.mkIf format.enable {
          formatters_by_ft = allConform.formatters_by_ft or {};
          formatters = lib.mapAttrs (_: cmd: {command = cmd;}) (allConform.commands or {});
        };
        lint.lintersByFt = lib.mkIf lint.enable allLint;
        treesitter.grammarPackages = lib.mkIf treesitter.enable (
          lib.mkAfter (map (g: builtGrammars.${g}) allTreesitter)
        );
      };

      extraPackages = lib.mkIf (lsp.enable || format.enable || lint.enable) allExtraPackages;
    };
  };
}
