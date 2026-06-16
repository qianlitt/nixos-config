{
  flake.modules.homeManager.niri = {
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
        "noctalia"
        "msg"
      ]
      ++ (lib.splitString " " cmd);
  in {
    programs.niri.settings = lib.mkIf (quickshell != null) (
      # noctalia
      lib.optionalAttrs (quickshell == "noctalia") {
        spawn-at-startup = [
          {argv = ["noctalia"];}
        ];

        binds = {
          # quickshell
          "${kbLauncher}".action.spawn = noctaliaIPC "panel-toggle launcher";
          "${kbControlCenter}".action.spawn = noctaliaIPC "panel-toggle control-center";
          "${kbSettings}".action.spawn = noctaliaIPC "settings-toggle";
          "${kbLock}".action.spawn = noctaliaIPC "session lock";

          # Media
          "XF86AudioRaiseVolume".action.spawn = noctaliaIPC "volume-up";
          "XF86AudioLowerVolume".action.spawn = noctaliaIPC "volume-down";
          "XF86AudioMute".action.spawn = noctaliaIPC "volume-mute";
          "XF86MonBrightnessUp".action.spawn = noctaliaIPC "brightness-up";
          "XF86MonBrightnessDown".action.spawn = noctaliaIPC "brightness-down";
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
  };
}
