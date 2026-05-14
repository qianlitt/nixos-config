/**
* mini.ai - 扩展 `a`/`i`
*
* Home Page: https://github.com/nvim-mini/mini.ai
*/
{
  programs.nixvim.plugins.mini-ai = {
    enable = true;

    lazyLoad.settings.event = "DeferredUIEnter";

    settings = {
      n_line = 500;
      custom_textobjects = {
        # o: code block (treesitter)
        o.__raw = ''
          require('mini.ai').gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          })
        '';

        # f: function (treesitter)
        f.__raw = ''
          require('mini.ai').gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" })
        '';

        # c: class (treesitter)
        c.__raw = ''
          require('mini.ai').gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" })
        '';

        # t: tags (正则)
        t.__raw = ''
          { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<<.->().*()</[^/]->$" }
        '';

        # d: digits (正则)
        d.__raw = ''
          { "%f[%d]%d+" }
        '';

        # e: Word with case (正则列表)
        e.__raw = ''
          {
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          }
        '';

        # g: buffer (整个文件) — 替代 LazyVim.mini.ai_buffer
        g.__raw = ''
          function()
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line('$'),
              col = math.max(vim.fn.getline('$'):len(), 1)
            }
            return { from = from, to = to }
          end
        '';

        # u: function call (Usage)
        u.__raw = ''
          require('mini.ai').gen_spec.function_call()
        '';

        # U: function call without dot
        U.__raw = ''
          require('mini.ai').gen_spec.function_call({ name_pattern = "[%w_]" })
        '';
      };
    };
  };
}
