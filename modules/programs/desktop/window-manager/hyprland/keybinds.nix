{
  flake.modules.homeManager.hyprland = let
    # Apps
    kbTerminal = "SUPER + Q";
    kbBrowser = "SUPER + W";
    kbEditor = "SUPER + D";
    # kbFileExplorer = "SUPER + E";
    # kbMusicApp = "SUPER + A";
  in {
    wayland.windowManager.hyprland.extraConfig = ''
      -- Workspace
      -- Move focuse: SUPER + Number
      workspaceGroupSize = 10
      function workspace_in_group(i)
        local curr = hl.get_active_workspace().id
        local newVal = math.floor((curr - 1) / workspaceGroupSize) * workspaceGroupSize + i
        -- hl.notification.create({ text = "curr " .. curr .. " floor " .. math.floor(curr / 10) .. " new " .. newVal, duration = 5000 })
        return newVal
      end
      for i = 1, 10 do
        hl.bind("SUPER + " .. (i % 10), function()
          hl.dispatch(hl.dsp.focus({ workspace = workspace_in_group(i) }))
        end, { description = "Workspace: Focus " .. i })
      end
      -- 数字键盘区
      for i = 1, 10 do
        local numpadkey = { 87, 88, 89, 83, 84, 85, 79, 80, 81, 90 }
        hl.bind("SUPER + code:" .. numpadkey[i], function()
          hl.dispatch(hl.dsp.focus({ workspace = workspace_in_group(i) }))
        end)
      end

      -- Move focuse left/right: SUPER + CTRL + ←/→
      for i = 1, 2 do
        local keys = { "Left", "Right" }
        local prefix = { "r-", "r+" }
        local descdir = { "left", "right" }
        hl.bind("CTRL + SUPER + " .. keys[i], hl.dsp.focus({ workspace = prefix[i] .. "1" }), {description = "Workspace: Focus " .. descdir[i]})
      end
      -- Move focuse left/right: SUPER + CTRL + h/l
      for i = 1, 2 do
        local keys = { "H", "L" }
        local prefix = { "r-", "r+" }
        local descdir = { "left", "right" }
        hl.bind("CTRL + SUPER + " .. keys[i], hl.dsp.focus({ workspace = prefix[i] .. "1" }), {description = "Workspace: Focus " .. descdir[i]})
      end
      -- Move focuse left/right: SUPER + CTRL + Page_↑/↓
      for i = 1, 4 do
        local key = { "SUPER + Page_Down", "SUPER + Page_Up" }
        local keycombos = { key[1], key[2], "CTRL + " .. key[1], "CTRL + " .. key[2] }
        local prefix = { "r+", "r-", "r+", "r-" }
        hl.bind(keycombos[i], hl.dsp.focus({ workspace = prefix[i] .. "1" }))
      end
      -- Move focuse left/right: SUPER + 鼠标滚轮
      for i = 1, 4 do
        local key = { "SUPER + mouse_up", "SUPER + mouse_down" }
        local keycombos = { key[1], key[2], "CTRL + " .. key[1], "CTRL + " .. key[2] }
        local prefix = { "+", "-", "r+", "r-" }
        hl.bind(keycombos[i], hl.dsp.focus({ workspace = prefix[i] .. "1" }))
      end


      -- Window
      -- Drag window: SUPER + 鼠标左键
      hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Window: Move" })
      -- Drag window: SUPER + 鼠标中键
      hl.bind("SUPER + mouse:274", hl.dsp.window.drag(), { mouse = true })
      -- Resize window: SUPER + 鼠标右键
      hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Window: Resize" })

      -- Move focuse: SUPER + ←/↑/→/↓
      for i = 1, 4 do
        local arrowkey = { "Left", "Right", "Up", "Down" }
        local focusdir = { "l", "r", "u", "d" }
        hl.bind("SUPER + " .. arrowkey[i], hl.dsp.focus({ direction = focusdir[i] }),
          { description = "Window: Focus " .. arrowkey[i] })
      end
      -- Move focuse: SUPER + h/j/k/l
      for i = 1, 4 do
        local arrowkey = { "H", "J", "K", "L" }
        local focusdir = { "l", "d", "u", "r" }
        hl.bind("SUPER + " .. arrowkey[i], hl.dsp.focus({ direction = focusdir[i] }),
          { description = "Window: Focus " .. arrowkey[i] })
      end

      -- Move focuse: SUPER + [/]
      for i = 1, 2 do
        local arrowkey = { "BracketLeft", "BracketRight" }
        local focusdir = { "l", "r" }
        hl.bind("SUPER + " .. arrowkey[i], hl.dsp.focus({ direction = focusdir[i] }))
      end

      -- Move window: SUPER + SHIFT, ←/↑/→/↓
      for i = 1, 4 do
        local arrowkey = { "Left", "Right", "Up", "Down" }
        local focusdir = { "l", "r", "u", "d" }
        hl.bind("SUPER + SHIFT + " .. arrowkey[i], hl.dsp.window.move({ direction = focusdir[i] }),
          { description = "Window: Move " .. arrowkey[i] })
      end
      -- Move window: SUPER + SHIFT, h/j/k/l
      for i = 1, 4 do
        local arrowkey = { "H", "J", "K", "L" }
        local focusdir = { "l", "d", "u", "r" }
        hl.bind("SUPER + SHIFT + " .. arrowkey[i], hl.dsp.window.move({ direction = focusdir[i] }),
          { description = "Window: Move " .. arrowkey[i] })
      end

      -- Window split ratio: SUPER + ;/'
      hl.bind("SUPER + Semicolon", hl.dsp.layout("splitratio -0.1"), { repeating = true })
      hl.bind("SUPER + Apostrophe", hl.dsp.layout("splitratio +0.1"), { repeating = true })

      -- Positioning mode
      hl.bind("SUPER + F",  hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }),
        { description = "Window: Fullscreen" })
      hl.bind("SUPER + ALT + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 3, action = "toggle" }),
        { description = "Window: Fullscreen spoof" })
      hl.bind("SUPER + ALT + Space", hl.dsp.window.float({ action = "toggle" }),
        { description = "Window: Float/Tile" })
      hl.bind("SUPER + P", hl.dsp.window.pin(), { description = "Window: Pin" })

      -- Send window to workspace (1, 2, 3, ...): SUPER + ALT + Number
      for i = 1, 10 do
        hl.bind("SUPER + ALT + " .. (i % 10), function()
          hl.dispatch(hl.dsp.window.move({ workspace = workspace_in_group(i), follow = false }))
        end, { description = "Window: Send to workspace " .. i })
      end
      -- 数字键盘区
      for i = 1, 10 do
        local numpadkey = { 87, 88, 89, 83, 84, 85, 79, 80, 81, 90 }
        hl.bind("SUPER + ALT + code:" .. numpadkey[i], function()
          hl.dispatch(hl.dsp.window.move({ workspace = workspace_in_group(i), follow = false }))
        end)
      end

      -- Send window to workspace left/right: SUPER + SHIFT + Scroll ↑/↓
      for i = 1, 4 do
        local key = { "SUPER + SHIFT + mouse_", "SUPER + ALT + mouse_" }
        local keycombos = { key[1] .. "down", key[1] .. "up", key[2] .. "down", key[2] .. "up" }
        local prefix = { "r-", "r+", "r-", "r+" }
        hl.bind(keycombos[i], hl.dsp.window.move({ workspace = prefix[i] .. "1" }))
      end
      -- Send window to workspace left/right: SUPER + SHIFT + Page_↑/↓
      for i = 1, 2 do
        local keydirs = { "Up", "Down" }
        local prefix = { "r-", "r+" }
        local descdir = { "left", "right" }
        hl.bind("SUPER + SHIFT + Page_" .. keydirs[i], hl.dsp.window.move({ workspace = prefix[i] .. "1" }), {description = "Window: Send to workspace " .. descdir[i]})
      end
      for i = 1, 4 do
        local key = { "SUPER + ALT + Page_", "CTRL + SUPER + SHIFT + " }
        local keycombos = { key[1] .. "down", key[1] .. "up", key[2] .. "Right", key[2] .. "Left" }
        local prefix = { "r+", "r-", "r+", "r-" }
        hl.bind(keycombos[i], hl.dsp.window.move({ workspace = prefix[i] .. "1" })) -- # [hidden]
      end


      -- Apps
      hl.bind("${kbTerminal}", hl.dsp.exec_cmd("kitty"), { description = "App: Terminal" })
      hl.bind("SUPER + Return", hl.dsp.exec_cmd("kitty"))
      hl.bind("SUPER + Z", hl.dsp.exec_cmd("kitten quick-access-terminal"))
      hl.bind("${kbEditor}", hl.dsp.exec_cmd("code"), { description = "App: Code editor" })
      hl.bind("${kbBrowser}", hl.dsp.exec_cmd("chromium"), { description = "App: Browser" })
      hl.bind("SUPER + C", hl.dsp.window.close(), { description = "Window: Close" })
      hl.bind("SUPER + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
    '';
  };
}
