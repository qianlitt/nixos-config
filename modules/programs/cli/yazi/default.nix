{
  flake.modules.homeManager.yazi = {
    lib,
    pkgs,
    ...
  }: {
    programs.yazi = {
      enable = true;

      enableBashIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;

      plugins = {
        "bookmarks" = pkgs.yaziPlugins.bookmarks;
        "clipboard" = pkgs.yaziPlugins.clipboard;
        "git" = pkgs.yaziPlugins.git;
        "lazygit" = pkgs.yaziPlugins.lazygit;
        "mediainfo" = pkgs.yaziPlugins.mediainfo;
      };

      initLua = ''
        -- 显示文件大小和修改时间
        function Linemode:size_and_mtime()
          local time = math.floor(self._file.cha.mtime or 0)
          local time_str = time == 0 and "                " or os.date("%Y-%m-%d %H:%M", time)  -- 16个空格

          local size = self._file:size()
          local size_str = size and ya.readable_size(size) or "-"
          return string.format("%8s  %s", size_str, time_str)
        end

        -- bookmarks.yazi
        require("bookmarks"):setup({
        	last_directory = { enable = false, persist = false, mode="dir" },
        	persist = "none",
        	desc_format = "full",
        	file_pick_mode = "hover",
        	custom_desc_input = false,
        	show_keys = false,
        	notify = {
        		enable = false,
        		timeout = 1,
        		message = {
        			new = "New bookmark '<key>' -> '<folder>'",
        			delete = "Deleted bookmark in '<key>'",
        			delete_all = "Deleted all bookmarks",
        		},
        	},
        })

        -- git.yazi
        require("git"):setup()
      '';

      settings = lib.importTOML ./yazi.toml;
      keymap = lib.importTOML ./keymap.toml;
    };

    home.packages = with pkgs; [
      mediainfo
    ];
  };
}
