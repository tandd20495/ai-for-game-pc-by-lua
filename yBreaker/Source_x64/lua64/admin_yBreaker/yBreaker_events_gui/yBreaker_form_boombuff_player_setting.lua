require("util_gui")

local THIS_FORM = "admin_yBreaker\\yBreaker_form_boombuff_player_setting"

function on_form_main_init(form)
	form.Fixed = false
	form.is_minimize = false
end
function on_main_form_open(form)
	change_form_size()
	
	-- Setting default for checkbox
	form.chk_player_1.Checked = true
	form.chk_player_2.Checked = true
	form.chk_player_3.Checked = true
	form.chk_player_4.Checked = true
	form.chk_player_5.Checked = true
end
function on_main_form_close(form)
	nx_destroy(form)
end

function on_btn_close_click(btn)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end

function change_form_size()
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	local gui = nx_value("gui")
	form.Left = 330
	form.Top = (gui.Height - form.Height) / 2
end

function show_hide_form_player_setting()
	util_auto_show_hide_form(THIS_FORM)
end
