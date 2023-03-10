require('auto_new\\autocack')

local THIS_FORM = 'auto_new\\form_auto_setting_ai'
function main_form_init(form)
  form.Fixed = false
end

function on_main_form_open(form)
  init_ui_content(form)
end
function init_ui_content(form)	
	load_ai_ini()
end
function btn_start_save(btn)
	local form = btn.ParentForm	
	saving_ai_ini()	
	util_auto_show_hide_form('auto_new\\form_auto_setting_ai')
end
function load_ai_ini()
	local form = nx_value("auto_new\\form_auto_setting_ai")
	if not nx_is_valid(form) then return false end
	local ini = nx_create("IniDocument")
	if not nx_is_valid(ini) then
		return 
	end
	ini.FileName = add_file_user('auto_ai')
	local inifile = add_file_user('setkey')	
	if ini:LoadFromFile() then
		if ini:FindSection(AUTO_AI) then
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "noitu", "")) == nx_string("true") then				
				form.cb_can_noitu.Checked = true
			end			
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "suicide", "")) == nx_string("true") then				
				form.cb_suicide.Checked = true
			end
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "movie", "")) == nx_string("true") then				
				form.cb_delete_combo.Checked = true
			end
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "pick_gift", "")) == nx_string("true") then				
				form.cb_lam_cong.Checked = true
			end
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "unlock_pass", "")) == nx_string("true") then				
				form.cb_unlock.Checked = true
			end			
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "check_ver", "")) == nx_string("true") then				
				form.cb_check_ver.Checked = true
			end
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "log_auto", "")) == nx_string("true") then				
				form.cb_log_auto.Checked = true
			end
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "change_title", "")) == nx_string("true") then				
				form.cb_set_title.Checked = true
			end
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "change_title_name", "")) == nx_string("true") then				
				form.cb_set_title_name.Checked = true
			end
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "skill_form", "")) == nx_string("true") then
				form.cb_skill_auto_1.Checked = true
			end	
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "expire", "")) == nx_string("true") then
				form.cb_auto_expire.Checked = true
			end	
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "caiyao", "")) == nx_string("true") then
				form.cb_use_caiyao.Checked = true
			end	
			local caiyao_num = nx_string(ini:ReadString(nx_string(AUTO_AI), "caiyao_num", ""))
			form.edt_num_caiyao.Text = nx_widestr(caiyao_num)			
		end
	end	
	if nx_string(readIni(inifile,'Setting','auto_swap','')) == nx_string("true") then
		form.cb_wp_swap.Checked = true
	end	
	local game_config = nx_value('game_config')
	local account = game_config.login_account
	local dir = nx_function('ext_get_current_exe_path') .. 'nockasdd_'.. account 
	local all_char = wstrToUtf8(readIni(dir..'\\Setting_all.ini',nx_string(AUTO_AI), "all_in_char", ""))	
	if nx_string(all_char) == nx_string("true") then				
		form.cb_change_save.Checked = true
	end	
end	
function saving_ai_ini()
	local form = nx_value("auto_new\\form_auto_setting_ai")
	if not nx_is_valid(form) then return false end
	local ini = nx_create("IniDocument")
	if not nx_is_valid(ini) then
		return 
	end
	local ini_file = add_file_user('auto_ai')	
	local inifile = add_file_user('setkey')	
	writeIni(ini_file,nx_string(AUTO_AI), "noitu", nx_string(form.cb_can_noitu.Checked))	
	writeIni(ini_file,nx_string(AUTO_AI), "suicide", nx_string(form.cb_suicide.Checked))
	writeIni(ini_file,nx_string(AUTO_AI), "movie", nx_string(form.cb_delete_combo.Checked))
	writeIni(ini_file,nx_string(AUTO_AI), "pick_gift", nx_string(form.cb_lam_cong.Checked))
	writeIni(ini_file,nx_string(AUTO_AI), "unlock_pass", nx_string(form.cb_unlock.Checked))	
	writeIni(ini_file,nx_string(AUTO_AI), "check_ver", nx_string(form.cb_check_ver.Checked))
	writeIni(ini_file,nx_string(AUTO_AI), "log_auto", nx_string(form.cb_log_auto.Checked))
	writeIni(ini_file,nx_string(AUTO_AI), "change_title", nx_string(form.cb_set_title.Checked))
	writeIni(ini_file,nx_string(AUTO_AI), "change_title_name", nx_string(form.cb_set_title_name.Checked))
	writeIni(ini_file,nx_string(AUTO_AI), "skill_form", nx_string(form.cb_skill_auto_1.Checked))
	writeIni(ini_file,nx_string(AUTO_AI), "expire", nx_string(form.cb_auto_expire.Checked))
	writeIni(ini_file,nx_string(AUTO_AI), "caiyao", nx_string(form.cb_use_caiyao.Checked))
	local caiyao_num = form.edt_num_caiyao.Text
	if nx_int(caiyao_num) > nx_int(115) then 
		showUtf8Text('Vì dùng màn thàu độ no chỉ được sử dụng tối đa là 120 điểm auto sẽ đưa về 115 điểm')
		caiyao_num = nx_widestr('115') 
	end
	writeIni(ini_file,nx_string(AUTO_AI), "caiyao_num", nx_string(caiyao_num))
	
	writeIni(inifile,nx_string('Setting'), "auto_swap", nx_string(form.cb_wp_swap.Checked))
	local game_config = nx_value('game_config')
	local account = game_config.login_account
	local dir = nx_function('ext_get_current_exe_path') .. 'nockasdd_'.. account 
	writeIni(dir..'\\Setting_all.ini',nx_string(AUTO_AI), "all_in_char", nx_string(form.cb_change_save.Checked))
end	

function on_btn_close_click(form)
local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end	
	on_main_form_close(form)
end
function on_main_form_close(form)	
	nx_destroy(form)
end