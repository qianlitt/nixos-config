/**
* Markview.nvim - markdown, Typst, latex, html & Asciidoc 预览
*
* Home Page: https://github.com/OXY2DEV/markview.nvim
*/
{
  programs.nixvim = {
    plugins.markview = {
      enable = true;

      lazyLoad.settings.ft = "markdown";

      settings = {
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
