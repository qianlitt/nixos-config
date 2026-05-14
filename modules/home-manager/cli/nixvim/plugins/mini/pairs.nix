/**
* mini.pairs - 字符配对
*
* Home Page: https://github.com/nvim-mini/mini.pairs
*/
{
  programs.nixvim = {
    plugins.mini-pairs = {
      enable = true;

      lazyLoad.settings.event = "DeferredUIEnter";

      settings = {
        modes = {
          insert = true;
          command = true;
          terminal = false;
        };
      };
    };

    extraConfigLua = ''
      do
        local pairs = require("mini.pairs")
        local open = pairs.open

        -- 这里的 opts 对应 LazyVim 中的四个配置项
        local opts = {
          skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
          skip_ts = { "string" },
          skip_unbalanced = true,
          markdown = true,
        }

        pairs.open = function(pair, neigh_pattern)
          -- 命令行模式下不做拦截
          if vim.fn.getcmdline() ~= "" then
            return open(pair, neigh_pattern)
          end

          local o, c = pair:sub(1, 1), pair:sub(2, 2)
          local line = vim.api.nvim_get_current_line()
          local cursor = vim.api.nvim_win_get_cursor(0)
          local next = line:sub(cursor[2] + 1, cursor[2] + 1)
          local before = line:sub(1, cursor[2])

          -- 条件 1：markdown 代码块
          if opts.markdown and o == "`" and vim.bo.filetype == "markdown"
             and before:match("^%s*`") then
            return "`\n```" .. vim.api.nvim_replace_termcodes("", true, true, true)
          end

          -- 条件 2：skip_next
          if opts.skip_next and next ~= "" and next:match(opts.skip_next) then
            return o
          end

          -- 条件 3：skip_ts（Treesitter）
          if opts.skip_ts and #opts.skip_ts > 0 then
            local ok, captures = pcall(vim.treesitter.get_captures_at_pos,
              0, cursor[1] - 1, math.max(cursor[2] - 1, 0))
            for _, capture in ipairs(ok and captures or {}) do
              if vim.tbl_contains(opts.skip_ts, capture.capture) then
                return o
              end
            end
          end

          -- 条件 4：skip_unbalanced
          if opts.skip_unbalanced and next == c and c ~= o then
            local _, count_open = line:gsub(vim.pesc(o), "")
            local _, count_close = line:gsub(vim.pesc(c), "")
            if count_close > count_open then
              return o
            end
          end

          -- 都不满足，走原逻辑
          return open(pair, neigh_pattern)
        end
      end
    '';
  };
}
