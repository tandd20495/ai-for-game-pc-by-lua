require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")

local THIS_FORM = "admin_yBreaker\\yBreaker_form_setting"
function main_form_init(form)
  form.Fixed = false
end

function on_main_form_open(form)
	init_ui_content(form)
	form.Left = 100
	form.Top = 140
end

function init_ui_content(form)	
	--load_ai_ini()
end

function btn_start_save(btn)
	local form = btn.ParentForm	
	--saving_ai_ini()	
	util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_setting")
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

function show_hide_form_setting()
	util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_setting")
end

-- function load_ai_ini()
-- 	local form = nx_value("admin_yBreaker\\yBreaker_form_setting")
-- 	if not nx_is_valid(form) then return false end
-- 	local ini = nx_create("IniDocument")
-- 	if not nx_is_valid(ini) then
-- 		return 
-- 	end
-- 	ini.FileName = add_file_user("yBreaker_Setting")
-- 	--local inifile = add_file_user('setkey')	
-- 	if ini:LoadFromFile() then
-- 		if ini:FindSection("Setting") then
-- 			if nx_string(ini:ReadString(nx_string("Setting"), "noitu", "")) == nx_string("true") then				
-- 				form.cb_can_noitu.Checked = true
-- 			end			
-- 			if nx_string(ini:ReadString(nx_string("Setting"), "unlock_pass", "")) == nx_string("true") then				
-- 				form.cb_unlock.Checked = true
-- 			end			
-- 			if nx_string(ini:ReadString(nx_string("Setting"), "change_title", "")) == nx_string("true") then				
-- 				form.cb_set_title.Checked = true
-- 			end
-- 			if nx_string(ini:ReadString(nx_string("Setting"), "change_title_name", "")) == nx_string("true") then				
-- 				form.cb_set_title_name.Checked = true
-- 			end
-- 			if nx_string(ini:ReadString(nx_string("Setting"), "caiyao", "")) == nx_string("true") then
-- 				form.cb_use_caiyao.Checked = true
-- 			end	
-- 			local caiyao_num = nx_string(ini:ReadString(nx_string("Setting"), "caiyao_num", ""))
-- 			form.edt_num_caiyao.Text = nx_widestr(caiyao_num)			
-- 		end
-- 	end	

-- 	local game_config = nx_value('game_config')
-- 	local account = game_config.login_account
-- 	local dir = nx_function('ext_get_current_exe_path') .. account 
-- 	local all_char = wstrToUtf8(readIni(dir..'\\yBreaker_setting_all.ini',nx_string("Support"), "all_in_char", ""))	
-- 	if nx_string(all_char) == nx_string("true") then				
-- 		form.cb_change_save.Checked = true
-- 	end	
-- end	
-- function saving_ai_ini()
-- 	local form = nx_value("admin_yBreaker\\yBreaker_form_setting")
-- 	if not nx_is_valid(form) then return false end
-- 	local ini = nx_create("IniDocument")
	
-- 	if not nx_is_valid(ini) then
-- 		return 
-- 	end
-- 		local ini_file = add_file_user("yBreaker_Setting")	
-- 		writeIni(ini_file,nx_string("Setting"), "noitu", nx_string(form.cb_can_noitu.Checked))	
-- 		writeIni(ini_file,nx_string("Setting"), "suicide", nx_string(form.cb_suicide.Checked))
-- 		writeIni(ini_file,nx_string("Setting"), "movie", nx_string(form.cb_delete_combo.Checked))
-- 		writeIni(ini_file,nx_string("Setting"), "unlock_pass", nx_string(form.cb_unlock.Checked))	
-- 		writeIni(ini_file,nx_string("Setting"), "change_title", nx_string(form.cb_set_title.Checked))
-- 		writeIni(ini_file,nx_string("Setting"), "change_title_name", nx_string(form.cb_set_title_name.Checked)	
-- 		writeIni(ini_file,nx_string("Setting"), "caiyao", nx_string(form.cb_use_caiyao.Checked))
-- 		local caiyao_num = form.edt_num_caiyao.Text
-- 	if nx_int(caiyao_num) > nx_int(115) then 
-- 		yBreaker_show_Utf8Text('Vì dùng màn thàu độ no chỉ được sử dụng tối đa là 120 điểm auto sẽ đưa về 115 điểm')
-- 		caiyao_num = nx_widestr('115') 
-- 	end
-- 		writeIni(ini_file,nx_string("Setting"), "caiyao_num", nx_string(caiyao_num))
		
-- 		local game_config = nx_value('game_config')
-- 		local account = game_config.login_account
-- 		local dir = nx_function('ext_get_current_exe_path') .. account 
-- 		writeIni(dir..'\\yBreaker_setting_all.ini',nx_string("Setting"), "all_in_char", nx_string(form.cb_change_save.Checked))
-- 	end	
-- end

