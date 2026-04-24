{
  config,
  lib,
  ...
}: let
  cfg = config.modules.windowManager.hyprland;
in {
  config = lib.mkIf cfg.enable {
    home-manager.users.${cfg.user}.wayland.windowManager.hyprland.settings = {
      windowrule = [
        # Floating
        "match:title ^(Open File)(.*)$, center on"
        "match:title ^(Open File)(.*)$, float on"
        "match:title ^(Select a File)(.*)$, center on"
        "match:title ^(Select a File)(.*)$, float on"
        "match:title ^(Choose wallpaper)(.*)$, center on"
        "match:title ^(Choose wallpaper)(.*)$, float on"
        "match:title ^(Choose wallpaper)(.*)$, size (monitor_w*.60) (monitor_h*.65)"
        "match:title ^(Open Folder)(.*)$, center on"
        "match:title ^(Open Folder)(.*)$, float on"
        "match:title ^(Save As)(.*)$, center on"
        "match:title ^(Save As)(.*)$, float on"
        "match:title ^(Library)(.*)$, center on"
        "match:title ^(Library)(.*)$, float on"
        "match:title ^(File Upload)(.*)$, center on"
        "match:title ^(File Upload)(.*)$, float on"
        "match:title ^(.*)(wants to save)$, center on"
        "match:title ^(.*)(wants to save)$, float on"
        "match:title ^(.*)(wants to open)$, center on"
        "match:title ^(.*)(wants to open)$, float on"
        "match:class ^(blueberry\.py)$, float on"
        "match:class ^(guifetch)$  , float on" # FlafyDev/guifetch
        "match:class ^(pavucontrol)$, float on"
        "match:class ^(pavucontrol)$, size (monitor_w*.45) (monitor_h*.45)"
        "match:class ^(pavucontrol)$, center on"
        "match:class ^(org.pulseaudio.pavucontrol)$, float on"
        "match:class ^(org.pulseaudio.pavucontrol)$, size (monitor_w*.45) (monitor_h*.45)"
        "match:class ^(org.pulseaudio.pavucontrol)$, center on"
        "match:class ^(nm-connection-editor)$, float on"
        "match:class ^(nm-connection-editor)$, size (monitor_w*.45) (monitor_h*.45)"
        "match:class ^(nm-connection-editor)$, center on"
        "match:class .*plasmawindowed.*, float on"
        "match:class kcm_.*, float on"
        "match:class .*bluedevilwizard, float on"
        "match:title .*Welcome, float on"
        "match:title ^(illogical-impulse Settings)$, float on"
        "match:title .*Shell conflicts.*, float on"
        "match:class org.freedesktop.impl.portal.desktop.kde, float on"
        "match:class org.freedesktop.impl.portal.desktop.kde, size (monitor_w*.60) (monitor_h*.65)"
        "match:class ^(Zotero)$, float on"
        "match:class ^(Zotero)$, size (monitor_w*.45) (monitor_h*.45)"
        "match:class gcr-prompter, center on" # GNOME 下的安全组件
        "match:class gcr-prompter, float on"

        # Move
        # kde-material-you-colors 在切换主题时会打开一个窗口
        "match:class ^(plasma-changeicons)$, float on"
        "match:class ^(plasma-changeicons)$, no_initial_focus on"
        "match:class ^(plasma-changeicons)$, move 999999 999999"
        "match:title ^(Copying — Dolphin)$, move 40 80"

        # Tiling
        "match:class ^dev\.warp\.Warp$, tile on"

        # Picture-in-Picture
        "match:title ^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$, float on"
        "match:title ^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$, keep_aspect_ratio on"
        "match:title ^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$, move (monitor_w*.73) (monitor_h*.72)"
        "match:title ^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$, size (monitor_w*.25) (monitor_h*.25)"
        "match:title ^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$, float on"
        "match:title ^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$, pin on"

        # Screen sharing
        "match:title .*is sharing (a window|your screen).*, float on"
        "match:title .*is sharing (a window|your screen).*, pin on"
        "match:title .*is sharing (a window|your screen).*, move (monitor_w*.5-window_w*.5) (monitor_h-window_h-12)"

        # --- Tearing ---
        "match:title .*\.exe, immediate on"
        "match:title .*minecraft.*, immediate on"
        "match:class ^(steam_app).*, immediate on"

        # Fix Jetbrain IDEs focus/rerendering problem
        "match:class ^jetbrains-.*$, match:float 1, match:title ^$|^\s$|^win\d+$, no_initial_focus on"

        # No shadow for tiled windows (matches windows that are not floating).
        "match:float 0, no_shadow on"
      ];
    };
  };
}
