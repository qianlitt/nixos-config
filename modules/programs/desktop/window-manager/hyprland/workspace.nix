{
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.extraConfig = ''
      -- 为显示器分配 workspace
      local function setup_dynamic_workspaces()
      	local monitors = hl.get_monitors()
      	table.sort(monitors, function(a, b)
      		return a.id < b.id
      	end)

      	local ws_per_monitor = 10

      	for idx, mon in ipairs(monitors) do
      		local start_ws = (idx - 1) * ws_per_monitor + 1
      		local end_ws = start_ws + ws_per_monitor - 1

      		for i = start_ws, end_ws do
      			hl.workspace_rule({
      				workspace = tostring(i),
      				monitor = mon.name,
      			})
      		end
      	end
      end
      hl.on("hyprland.start", function()
      	setup_dynamic_workspaces()
      end)
    '';
  };
}
