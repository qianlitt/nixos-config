/**
* nvim-treesitter
*
* Home Page: https://github.com/nvim-treesitter/nvim-treesitter
*
* note: 该项目已归档，未来不知如何
*/
{config, ...}: {
  programs.nixvim = {
    opts.foldlevelstart = 99; # 默认打开所有折叠

    plugins.treesitter = {
      enable = true;
      highlight.enable = true; # 启用高亮
      indent.enable = true; # 启用缩进
      folding.enable = true; # 启用折叠

      # 安装语法解析器
      grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
        bash
        c
        comment
        cpp
        diff
        html
        javascript
        jsdoc
        json
        latex
        lua
        luadoc
        luap
        make
        markdown
        markdown_inline
        nix
        printf
        python
        query
        regex
        rust
        toml
        tsx
        typescript
        typst
        vim
        vimdoc
        xml
        yaml
      ];
    };
  };
}
