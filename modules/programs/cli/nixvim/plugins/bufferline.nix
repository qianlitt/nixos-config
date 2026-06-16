# bufferline.nvim
#
# Home Page: https://github.com/akinsho/bufferline.nvim
{
  flake.modules.homeManager.nixvim = {config, ...}: {
    programs.nixvim = {
      plugins.bufferline = {
        enable = true;

        lazyLoad.settings.event = "DeferredUIEnter";

        settings = {
          options = {
            always_show_bufferline = false;
            diagnostics = "nvim_lsp";
            diagnostics_indicator = ''
              function(_, _, diag)
                local error = (diag.error and "${config.nixvimIcons.diagnostics.Error}" .. diag.error .. " " or "")
                local warn  = (diag.warning and "${config.nixvimIcons.diagnostics.Warn}" .. diag.warning or "")
                return vim.trim(error .. warn)
              end
            '';
            offsets = [
              {
                filetype = "neo-tree";
                highlight = "Directory";
                text = "Neo-tree";
                text_align = "left";
              }
              {
                filetype = "snacks_layout_box";
              }
            ];
          };
        };
      };

      keymaps = [
        {
          key = "<leader>bd";
          action.__raw = ''
            function()
              Snacks.bufdelete()
            end'';
          options.desc = "Delete Other Buffers";
        }
        {
          key = "<leader>bD";
          action = "<cmd>:bd<CR>";
          options.desc = "Toggle Pin";
        }
        {
          key = "<leader>bp";
          action = "<cmd>BufferLineTogglePin<CR>";
          options.desc = "Delete Buffer and Window";
        }
        {
          key = "<leader>bP";
          action = "<cmd>BufferLineGroupClose ungrouped<CR>";
          options.desc = "Delete Non-Pinned Buffers";
        }
        {
          key = "<leader>br";
          action = "<cmd>BufferLineCloseRight<CR>";
          options.desc = "Delete Buffers to the Right";
        }
        {
          key = "<leader>bl";
          action = "<cmd>BufferLineCloseLeft<CR>";
          options.desc = "Delete Buffers to the Left";
        }
        {
          key = "<S-h>";
          action = "<cmd>BufferLineCyclePrev<cr>";
          options.desc = "Prev Buffer";
        }
        {
          key = "<S-l>";
          action = "<cmd>BufferLineCycleNext<cr>";
          options.desc = "Next Buffer";
        }
        {
          key = "[b";
          action = "<cmd>BufferLineCyclePrev<cr>";
          options.desc = "Prev Buffer";
        }
        {
          key = "]b";
          action = "<cmd>BufferLineCycleNext<cr>";
          options.desc = "Next Buffer";
        }
        {
          key = "[B";
          action = "<cmd>BufferLineMovePrev<cr>";
          options.desc = "Move buffer prev";
        }
        {
          key = "]B";
          action = "<cmd>BufferLineMoveNext<cr>";
          options.desc = "Move buffer next";
        }
        {
          key = "<leader>bj";
          action = "<cmd>BufferLinePick<cr>";
          options.desc = "Pick Buffer";
        }
      ];
    };
  };
}
