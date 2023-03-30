require("util_gui")

local THIS_FORM = "admin_yBreaker\\yBreaker_form_spammail"
local sendmail = 0
function DoSendMail(cbtn)
	local form = cbtn.ParentForm
	local targetname = nx_function("ext_widestr_to_utf8", form.tab_1_input.Text)
	local lettername = nx_function("ext_widestr_to_utf8", form.tab_2_input.Text)
	local content = nx_function("ext_widestr_to_utf8", form.tab_3_input.Text)
	local trademoney = nx_number(form.tab_4_input.Text)
	local totalmail = nx_number(form.tab_5_input.Text)
	UpdateStatus()
	while form.auto_start do
		nx_pause(0.1)
		if sendmail < totalmail then
		nx_execute("custom_sender", "custom_send_letter", nx_function("ext_utf8_to_widestr",targetname), nx_function("ext_utf8_to_widestr",lettername), nx_function("ext_utf8_to_widestr",content), 0, silver, trademoney)
		sendmail = sendmail+1
		end
		nx_pause(9)
	end
end
function UpdateStatus()
	local form = util_get_form(THIS_FORM, false, false)
	if nx_is_valid(form) then
		if form.auto_start then 
			form.btn_control.Text = nx_function("ext_utf8_to_widestr", "Bắt đầu")
			--form.btn_control.ForeColor = "255,0,255,0"
		    form.auto_start = false	
		else
			form.btn_control.Text = nx_function("ext_utf8_to_widestr", "Kết thúc")
			--form.btn_control.ForeColor = "255,255,0,0"
			sendmail = 0
		    form.auto_start = true
		end
	end
end
function on_form_main_init(form)
	form.Fixed = false
	form.auto_start = false
end
function on_main_form_open(form)
	change_form_size()
	if form.auto_start then 
		form.btn_control.Text = nx_function("ext_utf8_to_widestr", "Bắt đầu")
		--form.btn_control.ForeColor = "255,0,255,0"
	end
end

function change_form_size()
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	local gui = nx_value("gui")
	form.Left = 100
	form.Top = (gui.Height - form.Height) / 2
end

function on_main_form_close(form)
	nx_destroy(form)
end
function show_hide_form_spammail()
	util_auto_show_hide_form(THIS_FORM)
end
function on_txt_targetname_get_focus(redit)
  local gui = nx_value("gui")
  gui.hyperfocused = redit
end
function on_txt_targetname_enter(redit)
  local form = redit.ParentForm
end
function on_txt_lettername_get_focus(redit)
  local gui = nx_value("gui")
  gui.hyperfocused = redit
end
function on_txt_lettername_enter(redit)
  local form = redit.ParentForm
end
function on_txt_content_get_focus(redit)
  local gui = nx_value("gui")
  gui.hyperfocused = redit
end
function on_txt_content_enter(redit)
  local form = redit.ParentForm
end