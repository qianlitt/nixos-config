{
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.settings = {
      window_rule = [
        # Floating
        {
          match.title = "^(Open File)(.*)$";
          center = true;
        }
        {
          match.title = "^(Open File)(.*)$";
          float = true;
        }
        {
          match.title = "^(Select a File)(.*)$";
          center = true;
        }
        {
          match.title = "^(Select a File)(.*)$";
          float = true;
        }
        {
          match.title = "^(Choose wallpaper)(.*)$";
          center = true;
        }
        {
          match.title = "^(Choose wallpaper)(.*)$";
          float = true;
        }
        {
          match.title = "^(Choose wallpaper)(.*)$";
          size = ''{"(monitor_w*.60)", "(monitor_h*.65)"}'';
        }
        {
          match.title = "^(Open Folder)(.*)$";
          center = true;
        }
        {
          match.title = "^(Open Folder)(.*)$";
          float = true;
        }
        {
          match.title = "^(Save As)(.*)$";
          center = true;
        }
        {
          match.title = "^(Save As)(.*)$";
          float = true;
        }
        {
          match.title = "^(Library)(.*)$";
          center = true;
        }
        {
          match.title = "^(Library)(.*)$";
          float = true;
        }
        {
          match.title = "^(File Upload)(.*)$";
          center = true;
        }
        {
          match.title = "^(File Upload)(.*)$";
          float = true;
        }
        {
          match.title = "^(.*)(wants to save)$";
          center = true;
        }
        {
          match.title = "^(.*)(wants to save)$";
          float = true;
        }
        {
          match.title = "^(.*)(wants to open)$";
          center = true;
        }
        {
          match.title = "^(.*)(wants to open)$";
          float = true;
        }
        {
          match.class = "^(blueberry\.py)$";
          float = true;
        }
        {
          match.class = "^(guifetch)$  ";
          float = true;
        } # FlafyDev/guifetch
        {
          match.class = "^(pavucontrol)$";
          float = true;
        }
        {
          match.class = "^(pavucontrol)$";
          size = ''{"(monitor_w*.45)", "(monitor_h*.45)"}'';
        }
        {
          match.class = "^(pavucontrol)$";
          center = true;
        }
        {
          match.class = "^(org.pulseaudio.pavucontrol)$";
          float = true;
        }
        {
          match.class = "^(org.pulseaudio.pavucontrol)$";
          size = ''{"(monitor_w*.45)", "(monitor_h*.45)"}'';
        }
        {
          match.class = "^(org.pulseaudio.pavucontrol)$";
          center = true;
        }
        {
          match.class = "^(nm-connection-editor)$";
          float = true;
        }
        {
          match.class = "^(nm-connection-editor)$";
          size = ''{"(monitor_w*.45)", "(monitor_h*.45)"}'';
        }
        {
          match.class = "^(nm-connection-editor)$";
          center = true;
        }
        {
          match.class = ".*plasmawindowed.*";
          float = true;
        }
        {
          match.class = "kcm_.*";
          float = true;
        }
        {
          match.class = ".*bluedevilwizard";
          float = true;
        }
        {
          match.title = ".*Welcome";
          float = true;
        }
        {
          match.title = "^(illogical-impulse Settings)$";
          float = true;
        }
        {
          match.title = ".*Shell conflicts.*";
          float = true;
        }
        {
          match.class = "org.freedesktop.impl.portal.desktop.kde";
          float = true;
        }
        {
          match.class = "org.freedesktop.impl.portal.desktop.kde";
          size = ''{"(monitor_w*.60)", "(monitor_h*.65)"}'';
        }
        {
          match.class = "^(Zotero)$";
          float = true;
        }
        {
          match.class = "^(Zotero)$";
          size = ''{"(monitor_w*.45)", "(monitor_h*.45)"'';
        }
        {
          match.class = "gcr-prompter";
          center = true;
        } # GNOME 下的安全组件
        {
          match.class = "gcr-prompter";
          float = true;
        }

        # Move
        # kde-material-you-colors 在切换主题时会打开一个窗口
        {
          match.class = "^(plasma-changeicons)$";
          float = true;
        }
        {
          match.class = "^(plasma-changeicons)$";
          no_initial_focus = true;
        }
        {
          match.class = "^(plasma-changeicons)$";
          move = "{999999, 999999}";
        }
        {
          match.title = "^(Copying — Dolphin)$";
          move = "{40, 80}";
        }

        # Tiling
        {
          match.class = "^dev\.warp\.Warp$";
          tile = true;
        }

        # Picture-in-Picture
        {
          match.title = "^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$";
          float = true;
        }
        {
          match.title = "^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$";
          keep_aspect_ratio = true;
        }
        {
          match.title = "^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$";
          move = ''{"(monitor_w*.73)", "(monitor_h*.72)"}'';
        }
        {
          match.title = "^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$";
          size = ''{"(monitor_w*.25)", "(monitor_h*.25)"}'';
        }
        {
          match.title = "^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$";
          float = true;
        }
        {
          match.title = "^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$";
          pin = true;
        }

        # Screen sharing
        {
          match.title = ".*is sharing (a window|your screen).*";
          float = true;
        }
        {
          match.title = ".*is sharing (a window|your screen).*";
          pin = true;
        }
        {
          match.title = ".*is sharing (a window|your screen).*";
          move = ''{"(monitor_w*.5-window_w*.5)", "(monitor_h-window_h-12)"}'';
        }

        # --- Tearing ---
        {
          match.title = ".*\.exe";
          immediate = true;
        }
        {
          match.title = ".*minecraft.*";
          immediate = true;
        }
        {
          match.class = "^(steam_app).*";
          immediate = true;
        }

        # Fix Jetbrain IDEs focus/rerendering problem
        {
          match = {
            class = "^jetbrains-.*$";
            float = "1";
            title = "^$|^\s$|^win\d+$";
          };
          no_initial_focus = true;
        }

        # No shadow for tiled windows (matches windows that are not floating).
        {
          match.float = "0";
          no_shadow = true;
        }

        # Game
        {
          match = {
            class = "^(steam_app).*";
            title = "^鸣潮%s*$";
          };
          immediate = true;
          float = true;
        }
      ];
    };
  };
}
