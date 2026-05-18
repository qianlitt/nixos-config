/**
* Markview.nvim - markdown, Typst, latex, html & Asciidoc 预览
*
* Home Page: https://github.com/OXY2DEV/markview.nvim
*/
{
  programs.nixvim = {
    plugins.markview = {
      enable = true;

      lazyLoad.settings.ft = ["markdown" "tex" "typst" "html"];

      settings = {
        preview = {
          # 光标进入节点时取消渲染，显示 Markdown 源码
          # 光标退出节点后恢复渲染
          hybrid_modes = [
            "n" # Normal
            "i" # Insert
          ];
          modes = [
            "n" # Normal
            "no" # Operator-pending
            "i" # Insert
            "c" # Command-line
          ];
          callbacks = {
            on_enable.__raw = ''
              function (_, win)
                  vim.wo[win].conceallevel = 2
                  vim.wo[win].concealcursor = "nc"
              end
            '';
          };
        };
        markdown = {
          markdown_inline = {
            tags = {
              enable = true;
              default = {
                hl = "MarkviewCodeInfo";
                padding_left = "";
                padding_left_hl = "MarkviewCodeFg";
                padding_right = "";
                padding_right_hl = "MarkviewCodeFg";
              };
            };
          };
        };
      };
    };
  };
}
