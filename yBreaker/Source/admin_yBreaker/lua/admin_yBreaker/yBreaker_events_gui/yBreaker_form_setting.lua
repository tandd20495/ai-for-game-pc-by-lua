require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")

local THIS_FORM = "admin_yBreaker\\yBreaker_form_setting"
function main_form_init(form)
  form.Fixed = false
end

function on_main_form_open(form)
	init_ui_content(form)
	local gui = nx_value("gui")
	form.Left = (gui.Width - form.Width) / 2
	form.Top = 370
end

function init_ui_content(form)	
	load_setting_ini(form)
end

function btn_start_save(btn)
	local form = btn.ParentForm	
	save_setting_ini(form)
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

function save_setting_ini(form)
	local ini = nx_create("IniDocument")
	local file = Get_Config_Dir_Ini("Setting")
  	ini.FileName = file
	
	ini:WriteString("Setting", "Unlock_Pass_2", nx_string(form.cb_unlock.Checked))
	ini:WriteString("Setting", "Noi_Tu_Char", nx_string(form.cb_can_noitu.Checked))
	ini:WriteString("Setting", "Add_Del_Text", nx_string(form.cb_delete_text.Checked))
	ini:WriteString("Setting", "Title_ID", nx_string(form.cb_set_title.Checked))
	ini:WriteString("Setting", "Title_Char_Name", nx_string(form.cb_set_title_name.Checked))
	ini:WriteString("Setting", "Auto_Weapon_Swap", nx_string(form.cb_wp_swap.Checked))
	ini:WriteString("Setting", "Auto_Use_Caiyao", nx_string(form.cb_use_caiyao.Checked))
	
	local caiyao_num = form.edt_num_caiyao.Text
 	if nx_int(caiyao_num) > nx_int(115) then 
 		yBreaker_show_Utf8Text('Vì dùng màn thàu độ no chỉ được sử dụng tối đa là 120 điểm auto sẽ đưa về 115 điểm')
 		caiyao_num = nx_widestr('115') 
 	end
	ini:WriteString("Setting", "Caiyao_Number", nx_string(caiyao_num))
	
	ini:SaveToFile()
	nx_destroy(ini)
end
function load_setting_ini(form)
	local ini = nx_create("IniDocument")
	local file = Get_Config_Dir_Ini("Setting")
  	ini.FileName = file
  	if not ini:LoadFromFile() then
  		return
  	end
	
	form.cb_unlock.Checked = nx_widestr(ini:ReadString("Setting", "Unlock_Pass_2", ""))
	form.cb_can_noitu.Checked = nx_widestr(ini:ReadString("Setting", "Noi_Tu_Char", ""))
	form.cb_delete_text.Checked = nx_widestr(ini:ReadString("Setting", "Add_Del_Text", ""))
	form.cb_set_title.Checked = nx_widestr(ini:ReadString("Setting", "Title_ID", ""))
	form.cb_set_title_name.Checked = nx_widestr(ini:ReadString("Setting", "Title_Char_Name", ""))
	form.cb_wp_swap.Checked = nx_widestr(ini:ReadString("Setting", "Auto_Weapon_Swap", ""))
	form.cb_use_caiyao.Checked = nx_widestr(ini:ReadString("Setting", "Auto_Use_Caiyao", ""))
	form.edt_num_caiyao.Text = nx_widestr(ini:ReadString("Setting", "Caiyao_Number", ""))
	
	if nx_string(ini:ReadString(nx_string("Setting"), "Unlock_Pass_2", "")) == nx_string("true") then				
 		form.cb_unlock.Checked = true
 	end	
	if nx_string(ini:ReadString(nx_string("Setting"), "Noi_Tu_Char", "")) == nx_string("true") then				
 		form.cb_can_noitu.Checked = true
 	end	
	if nx_string(ini:ReadString(nx_string("Setting"), "Add_Del_Text", "")) == nx_string("true") then				
 		form.cb_delete_text.Checked = true
 	end	
	if nx_string(ini:ReadString(nx_string("Setting"), "Title_ID", "")) == nx_string("true") then				
 		form.cb_set_title.Checked = true
 	end
	if nx_string(ini:ReadString(nx_string("Setting"), "Title_Char_Name", "")) == nx_string("true") then				
 		form.cb_set_title_name.Checked = true
 	end
	if nx_string(ini:ReadString(nx_string("Setting"), "Auto_Weapon_Swap", "")) == nx_string("true") then				
 		form.cb_wp_swap.Checked = true
 	end
	if nx_string(ini:ReadString(nx_string("Setting"), "Auto_Use_Caiyao", "")) == nx_string("true") then				
 		form.cb_use_caiyao.Checked = true
 	end

end