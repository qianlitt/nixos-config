/**
* blink.pairs - 自动括号配对，彩虹括号高亮
*
* Home Page: https://github.com/saghen/blink.pairs
*/
{
  programs.nixvim = {
    plugins.blink-pairs = {
      enable = true;

      lazyLoad.settings.event = "DeferredUIEnter";
    };
  };
}
