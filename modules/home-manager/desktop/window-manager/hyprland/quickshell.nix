{
  config,
  lib,
  ...
}: let
  quickshell = config.modules.desktop.windowManager.hyprland.quickshell;

  # quickshell 快捷键
  kbControlCenter = "Super, S";
  kbSettings = "Super, Comma";
  kbLock = "Super, L";
in {
  wayland.windowManager.hyprland = lib.mkIf (quickshell != null) (
    # noctalia-shell
    lib.optionalAttrs (quickshell == "noctalia") {
      settings.exec-once = ["noctalia-shell"];
      extraConfig = ''
        # quickshell
        bind = SUPER, Super_L, exec, noctalia-shell ipc call launcher toggle
        bind = SUPER, Super_R, exec, noctalia-shell ipc call launcher toggle
        bind = ${kbControlCenter}, exec, noctalia-shell ipc call controlCenter toggle
        bind = ${kbSettings}, exec, noctalia-shell ipc call settings toggle
        bind = ${kbLock}, exec, noctalia-shell ipc call lockScreen lock

        # Media
        bindel = , XF86AudioRaiseVolume, exec, noctalia-shell ipc call volume increase
        bindel = , XF86AudioLowerVolume, exec, noctalia-shell ipc call volume decrease
        bindl = , XF86AudioMute, exec, noctalia-shell ipc call volume muteOutput
        bindel = , XF86MonBrightnessUp, exec, noctalia-shell ipc call brightness increase
        bindel = , XF86MonBrightnessDown, exec, noctalia-shell ipc call brightness decrease
      '';
    }
  );
}
