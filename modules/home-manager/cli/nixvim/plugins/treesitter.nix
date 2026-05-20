/**
* nvim-treesitter
*
* Home Page: https://github.com/nvim-treesitter/nvim-treesitter
*
* note: 该项目已归档，未来不知如何
*/
{
  config,
  lib,
  ...
}: let
  inherit (config.modules.cli.nixvim) treesitter;
in
  lib.mkIf treesitter.enable {
    programs.nixvim = {
      opts.foldlevelstart = 99; # 默认打开所有折叠

      plugins.treesitter = {
        enable = true;
        highlight.enable = true; # 启用高亮
        indent.enable = true; # 启用缩进
        folding.enable = true; # 启用折叠

        # 非语言特定的语法解析器，语言相关 grammar 分散在各 lang/*.nix 中
        grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
          comment
          diff
          make
          printf
          query
          regex
          vim
          vimdoc
        ];
      };
    };
  }
