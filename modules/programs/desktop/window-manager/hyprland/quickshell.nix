{
  flake.modules.homeManager.hyprland = {
    config,
    lib,
    ...
  }: let
    quickshell = config.modules.desktop.windowManager.hyprland.quickshell;

    # quickshell 快捷键
    kbControlCenter = "SUPER + S";
    kbSettings = "SUPER + Comma";
    kbLock = "SUPER + L";
  in {
    wayland.windowManager.hyprland = lib.mkIf (quickshell != null) (
      # noctalia-shell
      lib.optionalAttrs (quickshell == "noctalia") {
        settings.on = [
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
        extraConfig = ''
          -- quickshell
          local ipc = "noctalia msg"
          hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd(ipc .. " panel-toggle launcher"), { description = "Shell: Toggle launcher" })
          hl.bind("SUPER + SUPER_R", hl.dsp.exec_cmd(ipc .. " panel-toggle launcher"))
          hl.bind("${kbControlCenter}", hl.dsp.exec_cmd(ipc .. " panel-toggle control-center"))
          hl.bind("${kbSettings}", hl.dsp.exec_cmd(ipc .. " settings-toggle"))
          hl.bind("${kbLock}", hl.dsp.exec_cmd(ipc .. " session lock"))

          -- Media
          hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. " volume-up"), { locked = true, repeating = true })
          hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. " volume-down"), { locked = true, repeating = true })
          hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. " volume-mute"), { locked = true })
          hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. " brightness-up"), { locked = true, repeating = true })
          hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. " brightness-down"), { locked = true, repeating = true })
        '';
      }
    );
  };
}
