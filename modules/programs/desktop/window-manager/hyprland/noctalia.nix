{
  flake.modules.homeManager."hyprland<->noctalia" = {lib, ...}: let
    # noctalia IPC 快捷键
    kbLauncher = "SUPER + Space";
    kbControlCenter = "SUPER + ALT + X";
    kbSettings = "SUPER + ALT + Comma";
    kbLock = "SUPER + ALT + L";
  in {
    wayland.windowManager.hyprland = {
      settings = {
        # 自启动 noctalia
        on = [
          {
            _args = [
              "hyprland.start"
              (lib.generators.mkLuaInline ''
                function()
                  hl.exec_cmd("noctalia")
                end
              '')
            ];
          }
        ];

        # noctalia 面板：禁用 Hyprland 图层动画并启用模糊
        layer_rule = [
          {
            name = "noctalia";
            match.namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$";
            no_anim = true;
            ignore_alpha = 0.5;
            blur = true;
            blur_popups = true;
          }
        ];

        # noctalia 设置窗口：浮动 + 固定尺寸
        window_rule = [
          {
            match.class = "dev.noctalia.Noctalia";
            float = true;
            size = "monitor_w*0.5625 monitor_h*0.85";
          }
        ];
      };

      extraConfig = ''
        -- noctalia IPC
        local ipc = "noctalia msg"

        -- Shell
        hl.bind("${kbLauncher}", hl.dsp.exec_cmd(ipc .. " panel-toggle launcher"), { description = "Shell: Toggle launcher" })
        hl.bind("${kbControlCenter}", hl.dsp.exec_cmd(ipc .. " panel-toggle control-center"))
        hl.bind("${kbSettings}", hl.dsp.exec_cmd(ipc .. " settings-toggle"))
        hl.bind("${kbLock}", hl.dsp.exec_cmd(ipc .. " session lock"))

        -- 窗口切换器
        hl.bind("ALT + Tab", hl.dsp.exec_cmd(ipc .. " window-switcher hold"))
        hl.bind("ALT + SHIFT + Tab", hl.dsp.exec_cmd(ipc .. " window-switcher hold reverse"))

        -- Media
        hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. " volume-up"), { locked = true, repeating = true })
        hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. " volume-down"), { locked = true, repeating = true })
        hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. " volume-mute"), { locked = true })
        hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. " brightness-up"), { locked = true, repeating = true })
        hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. " brightness-down"), { locked = true, repeating = true })
      '';
    };
  };
}
