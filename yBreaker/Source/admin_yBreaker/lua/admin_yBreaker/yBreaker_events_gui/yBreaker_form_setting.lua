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
	
	-- Visible edit number caiyao
	form.edt_num_caiyao.Visible = false
	form.lbl_caiyao_title.Visible = false
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
	ini:WriteString("Setting", "Add_Del_Text", nx_string(form.cb_delete_text.Checked))
	ini:WriteString("Setting", "Skip_Story_Movie", nx_string(form.cb_skip_movie.Checked))
	ini:WriteString("Setting", "Title_Char_Name", nx_string(form.cb_set_title_name.Checked))
	ini:WriteString("Setting", "Title_ID", nx_string(form.cb_set_title.Checked))
	ini:WriteString("Setting", "Auto_Get_Miracle", nx_string(form.cb_get_miracle.Checked))
	ini:WriteString("Setting", "Auto_Use_Caiyao", nx_string(form.cb_use_caiyao.Checked))
	ini:WriteString("Setting", "Hidden_Expire_Bag", nx_string(form.cb_show_expire_bag.Checked))
	ini:WriteString("Setting", "Auto_Swap_Weapon", nx_string(form.cb_swap_weapon.Checked))
	
	local caiyao_num = form.edt_num_caiyao.Text
 	if nx_int(caiyao_num) > nx_int(115) then 
 		yBreaker_show_Utf8Text("Dùng màn thầu độ no chỉ được sử dụng tối đa là 120 điểm")
 		caiyao_num = nx_widestr("115") 
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
	
	if nx_string(ini:ReadString(nx_string("Setting"), "Unlock_Pass_2", "")) == nx_string("true") then				
 		form.cb_unlock.Checked = true
 	end	
	if nx_string(ini:ReadString(nx_string("Setting"), "Add_Del_Text", "")) == nx_string("true") then				
 		form.cb_delete_text.Checked = true
 	end	
	if nx_string(ini:ReadString(nx_string("Setting"), "Skip_Story_Movie", "")) == nx_string("true") then				
 		form.cb_skip_movie.Checked = true
 	end
	if nx_string(ini:ReadString(nx_string("Setting"), "Title_Char_Name", "")) == nx_string("true") then				
 		form.cb_set_title_name.Checked = true
 	end
	if nx_string(ini:ReadString(nx_string("Setting"), "Title_ID", "")) == nx_string("true") then				
 		form.cb_set_title.Checked = true
 	end
	if nx_string(ini:ReadString(nx_string("Setting"), "Auto_Get_Miracle", "")) == nx_string("true") then				
 		form.cb_get_miracle.Checked = true
 	end
	if nx_string(ini:ReadString(nx_string("Setting"), "Auto_Use_Caiyao", "")) == nx_string("true") then				
 		form.cb_use_caiyao.Checked = true
 	end
	if nx_string(ini:ReadString(nx_string("Setting"), "Hidden_Expire_Bag", "")) == nx_string("true") then				
 		form.cb_show_expire_bag.Checked = true
 	end
	if nx_string(ini:ReadString(nx_string("Setting"), "Auto_Swap_Weapon", "")) == nx_string("true") then				
 		form.cb_swap_weapon.Checked = true
 	end

end