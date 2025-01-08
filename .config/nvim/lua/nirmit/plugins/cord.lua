return { --discord rich presence
	'vyfor/cord.nvim',
	build = './build || .\\build',
	event = 'VeryLazy',
	opts = {
		usercmds = true,
		log_level = 'error',
		timer = {
			interval = 1000,
			reset_on_idle = false,
			reset_on_change = false,
		},
		editor = {
			image = 'intentinally written',
			client = 'neovim',
			tooltip = 'weeeeeeeee',
		},
		display = {
			show_time = true,
			show_repository = true,
			show_cursor_position = false,
			swap_fields = false,
			swap_icons = false,
			workspace_blacklist = {},
		},
		lsp = {
			show_problem_count = false,
			severity = 1,
			scope = 'workspace',
		},
		idle = {
			enable = true,
			show_status = true,
			timeout = 300000,
			disable_on_focus = false,
			text = 'Idle',
			tooltip = '💤',
		},
		text = {
			viewing = 'Viewing {}',
			editing = 'Editing {}',
			file_browser = 'Browsing files in {}',
			plugin_manager = 'Managing plugins in {}',
			lsp_manager = 'Configuring LSP in {}',
			vcs = 'Committing changes in {}',
			workspace = 'In {}',
		},
		buttons = {
			{
				label = 'View Repository',
				url = 'git',
			},
		},
		assets = nil,
	}
}

--[[
    :CordConnect - Initialize presence client internally and connect to Discord
    :CordReconnect - Reconnect to Discord
    :CordDisconnect - Disconnect from Discord
    :CordTogglePresence - Toggle presence
    :CordShowPresence - Show presence
    :CordHidePresence - Hide presence
    :CordToggleIdle - Toggle idle status
    :CordIdle - Show idle status
    :CordUnidle - Hide idle status and reset the timeout
    :CordWorkspace <name> - Change the name of the workspace (visually)
]]
