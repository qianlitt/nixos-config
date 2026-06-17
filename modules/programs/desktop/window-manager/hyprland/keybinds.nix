{
  flake.modules.homeManager.hyprland = let
    terminal = {
      program = "kitty";
      key = "SUPER + Q";
    };
    browser = {
      program = "chromium";
      key = "SUPER + W";
    };
    editor = {
      program = "code";
      key = "SUPER + D";
    };
    music = {
      program = "spotify";
      key = "SUPER + A";
    };
    fileManager = {
      program = "dolphin";
      key = "SUPER + E";
    };
  in {
    wayland.windowManager.hyprland.extraConfig = ''
      -- Utils
      -- 发送通知
      local function send_notification(title, message)
        hl.dispatch(
          hl.dsp.exec_cmd(
            string.format(
              'notify-send -a "Hyprland" -i "preferences-desktop-display" -t 3000 "%s" "%s"',
              title,
              message
            )
          )
        )
      end

      -- 将 workspace 按每 10 个为一组进行管理
      local workspaceGroupSize = 10
      local function workspace_in_group(i)
        local curr = hl.get_active_workspace().id
        local newVal = math.floor((curr - 1) / workspaceGroupSize) * workspaceGroupSize + i
        return newVal
      end


      -- Apps
      hl.bind("${terminal.key}", hl.dsp.exec_cmd("${terminal.program}"), { description = "App: Terminal" })
      hl.bind("SUPER + Return", hl.dsp.exec_cmd("${terminal.program}"))
      hl.bind("SUPER + Z", hl.dsp.exec_cmd("kitten quick-access-terminal"))
      hl.bind("${browser.key}", hl.dsp.exec_cmd("${browser.program}"), { description = "App: Browser" })
      hl.bind("${editor.key}", hl.dsp.exec_cmd("${editor.program}"), { description = "App: Code editor" })
      hl.bind("${music.key}", hl.dsp.exec_cmd("${music.program}"), { description = "App: Music player" })
      hl.bind("${fileManager.key}", hl.dsp.exec_cmd("${fileManager.program}"), { description = "App: Code editor" })

      hl.bind("SUPER + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))


      -- Layout
      -- Cycle switch layout: SUPER + ALT + [/]
      local layouts = {
        "dwindle",
        "master",
        "scrolling",
      }
      local function cycle_layout(direction)
        direction = direction or 1
        local currentLayout = hl.get_active_workspace().tiled_layout
        local idx = 1

        for i, l in ipairs(layouts) do
          if l == currentLayout then
            idx = i
            break
          end
        end

        local next_idx = (idx - 1 + direction) % #layouts + 1
        local next_layout = layouts[next_idx]

        hl.config({
          general = { layout = next_layout },
        })

        send_notification("Layout switch", "当前布局为：" .. next_layout)
      end
      for i = 1, 2 do
        local keys = { "BracketLeft", "BracketRight" }
        local prefix = { "-1", "+1" }
        hl.bind("SUPER + ALT + " .. keys[i], function()
          cycle_layout(prefix[i])
        end)
      end

      -- Window split ratio (dwindle layout): SUPER + ;/'
      hl.bind("SUPER + Semicolon", hl.dsp.layout("splitratio -0.1"), { repeating = true })
      hl.bind("SUPER + Apostrophe", hl.dsp.layout("splitratio +0.1"), { repeating = true })

      -- Consume or expel left/right (scrolling layout): SUPER + [/]
      for i = 1, 2 do
        local keys = { "BracketLeft", "BracketRight" }
        local actions = { "prev", "next" }
        hl.bind("SUPER + " .. keys[i], hl.dsp.layout("consume_or_expel " .. actions[i]))
      end

      -- Cycle switch column width (scrolling layout): SUPER + R
      hl.bind("SUPER + R", hl.dsp.layout("colresize +conf"))

      -- Resize column width (scrolling layout): SUPER + ,/.
      hl.bind("SUPER + Comma", hl.dsp.layout("colresize -0.1"), { repeating = true })
      hl.bind("SUPER + Period", hl.dsp.layout("colresize +0.1"), { repeating = true })


      -- Workspace
      -- Move focuse: SUPER + Number
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

      -- Move focuse: SUPER + U/I
      for i = 1, 2 do
        local keys = { "U", "I" }
        local prefix = { "r-", "r+" }
        local descdir = { "left", "right" }
        hl.bind(
          "SUPER + " .. keys[i],
          hl.dsp.focus({ workspace = prefix[i] .. "1" }),
          { description = "Workspace: Focus " .. descdir[i] }
        )
      end

      -- Move focuse left/right: SUPER + Page_↑/↓
      for i = 1, 2 do
        local keys = { "Page_Down", "Page_Up" }
        local prefix = { "r+", "r-" }
        hl.bind("SUPER + " .. keys[i], hl.dsp.focus({ workspace = prefix[i] .. "1" }))
      end

      -- Move focuse left/right: SUPER + 鼠标滚轮
      for i = 1, 2 do
        local keys = { "mouse_up", "mouse_down" }
        local prefix = { "r-", "r+" }
        hl.bind("SUPER + " .. keys[i], hl.dsp.focus({ workspace = prefix[i] .. "1" }))
      end

      -- Send window to workspace (1, 2, 3, ...)(焦点不跟随): SUPER + ALT + Number
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

      -- Send window to workspace left/right (焦点跟随): SUPER + SHIFT + 鼠标滚轮
      for i = 1, 4 do
        local key = { "SUPER + SHIFT + mouse_", "SUPER + ALT + mouse_" }
        local keycombos = { key[1] .. "up", key[1] .. "down", key[2] .. "up", key[2] .. "down" }
        local prefix = { "r-", "r+", "r-", "r+" }
        hl.bind(keycombos[i], hl.dsp.window.move({ workspace = prefix[i] .. "1" }))
      end

      -- Send window to workspace left/right (焦点跟随): SUPER + SHIFT + Page_↑/↓
      for i = 1, 2 do
        local keydirs = { "Up", "Down" }
        local prefix = { "r-", "r+" }
        local descdir = { "left", "right" }
        hl.bind(
          "SUPER + SHIFT + Page_" .. keydirs[i],
          hl.dsp.window.move({ workspace = prefix[i] .. "1" }),
          { description = "Window: Send to workspace " .. descdir[i] }
        )
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
        hl.bind(
          "SUPER + " .. arrowkey[i],
          hl.dsp.focus({ direction = focusdir[i] }),
          { description = "Window: Focus " .. arrowkey[i] }
        )
      end

      -- Move focuse: SUPER + h/j/k/l
      for i = 1, 4 do
        local arrowkey = { "H", "J", "K", "L" }
        local focusdir = { "l", "d", "u", "r" }
        hl.bind(
          "SUPER + " .. arrowkey[i],
          hl.dsp.focus({ direction = focusdir[i] }),
          { description = "Window: Focus " .. arrowkey[i] }
        )
      end

      -- Move window: SUPER + SHIFT, ←/↑/→/↓
      for i = 1, 4 do
        local arrowkey = { "Left", "Right", "Up", "Down" }
        local focusdir = { "l", "r", "u", "d" }
        hl.bind(
          "SUPER + SHIFT + " .. arrowkey[i],
          hl.dsp.window.move({ direction = focusdir[i] }),
          { description = "Window: Move " .. arrowkey[i] }
        )
      end

      -- Move window: SUPER + SHIFT, h/j/k/l
      for i = 1, 4 do
        local arrowkey = { "H", "J", "K", "L" }
        local focusdir = { "l", "d", "u", "r" }
        hl.bind(
          "SUPER + SHIFT + " .. arrowkey[i],
          hl.dsp.window.move({ direction = focusdir[i] }),
          { description = "Window: Move " .. arrowkey[i] }
        )
      end

      -- Toggle fullscreen: SUPER + F
      hl.bind(
        "SUPER + F",
        hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }),
        { description = "Window: Fullscreen" }
      )

      -- Toggle float: SUPER + V
      hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }), { description = "Window: Float/Tile" })

      -- Toggle pin: SUPER + P
      hl.bind("SUPER + P", hl.dsp.window.pin({ action = "toggle" }), { description = "Window: Pin" })

      -- Close window
      hl.bind("SUPER + C", hl.dsp.window.close(), { description = "Window: Close" })
    '';
  };
}
