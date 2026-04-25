{
  config,
  lib,
  ...
}: let
  quickshell = config.modules.desktop.windowManager.niri.quickshell;

  # quickshell 快捷键
  kbLauncher = "Mod+Space";
  kbControlCenter = "Mod+Alt+S";
  kbSettings = "Mod+Alt+Comma";
  kbLock = "Mod+Alt+L";

  noctaliaIPC = cmd:
    [
      "noctalia-shell"
      "ipc"
      "call"
    ]
    ++ (lib.splitString " " cmd);
in {
  programs.niri.settings = lib.mkIf (quickshell != null) (
    # noctalia-shell
    lib.optionalAttrs (quickshell == "noctalia") {
      spawn-at-startup = [
        {argv = ["noctalia-shell"];}
      ];

      binds = {
        # quickshell
        "${kbLauncher}".action.spawn = noctaliaIPC "launcher toggle";
        "${kbControlCenter}".action.spawn = noctaliaIPC "controlCenter toggle";
        "${kbSettings}".action.spawn = noctaliaIPC "settings toggle";
        "${kbLock}".action.spawn = noctaliaIPC "lockScreen lock";

        # Media
        "XF86AudioRaiseVolume".action.spawn = noctaliaIPC "volume increase";
        "XF86AudioLowerVolume".action.spawn = noctaliaIPC "volume decrease";
        "XF86AudioMute".action.spawn = noctaliaIPC "volume muteOutput";
        "XF86MonBrightnessUp".action.spawn = noctaliaIPC "brightness increase";
        "XF86MonBrightnessDown".action.spawn = noctaliaIPC "brightness decrease";
      };

      # 模糊概览壁纸
      layer-rules = [
        {
          matches = [
            {namespace = "^noctalia-overview*";}
          ];
          place-within-backdrop = true;
        }
      ];
    }
  );
}
