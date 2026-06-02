{
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
                hl.exec_cmd("noctalia-shell")
              end
            '')
          ];
        }
      ];
      extraConfig = ''
        -- quickshell
        hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd("noctalia-shell ipc call launcher toggle"), { description = "Shell: Toggle launcher" })
        hl.bind("SUPER + SUPER_R", hl.dsp.exec_cmd("noctalia-shell ipc call launcher toggle"))
        hl.bind("${kbControlCenter}", hl.dsp.exec_cmd("noctalia-shell ipc call controlCenter toggle"))
        hl.bind("${kbSettings}", hl.dsp.exec_cmd("noctalia-shell ipc call settings toggle"))
        hl.bind("${kbLock}", hl.dsp.exec_cmd("noctalia-shell ipc call lockScreen lock"))

        -- Media
        hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("noctalia-shell ipc call volume increase"), { locked = true, repeating = true })
        hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("noctalia-shell ipc call volume decrease"), { locked = true, repeating = true })
        hl.bind("XF86AudioMute", hl.dsp.exec_cmd("noctalia-shell ipc call volume muteOutput"), { locked = true })
        hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("noctalia-shell ipc call brightness increase"), { locked = true, repeating = true })
        hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia-shell ipc call brightness decrease"), { locked = true, repeating = true })
      '';
    }
  );
}
