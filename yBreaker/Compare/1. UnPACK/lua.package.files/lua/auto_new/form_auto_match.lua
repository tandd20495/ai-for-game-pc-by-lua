require("util_gui")
require("util_move")
require("util_functions")
require("util_static_data")
require("define\\sysinfo_define")
require("share\\chat_define")
require("const_define")
require("player_state\\state_const")
require("player_state\\logic_const")
require("player_state\\state_input")
require("tips_data")
require('auto_new\\autocack')
local THIS_FORM = 'auto_new\\form_auto_match'
function main_form_init(form)
  form.Fixed = false  
  form.selectskill1 = 0
  form.selectskill2 = 0
  ban_skill1 = ''
  ban_skill2 = ''  
end
local taolu_selection, taolu_selection2
function on_main_form_open(form)
	updateBtnAuto()
	if not nx_is_valid(form) then return false end	
	local path_ini = add_file_user('auto_ai')
	local ini = nx_create("IniDocument")
	if not nx_is_valid(ini) then
		return 
	end
	ini.FileName = path_ini
	if ini:LoadFromFile() then			
		if ini:FindSection(AUTO_TT) then	
			local index1 = ini:ReadString(nx_string(AUTO_TT), "selectskillban1_index", "")
			local index2 = ini:ReadString(nx_string(AUTO_TT), "selectskillban2_index", "")
			local ban1 = ini:ReadString(nx_string(AUTO_TT), "selectskillban1", "")
			local ban2 = ini:ReadString(nx_string(AUTO_TT), "selectskillban2", "")
			local check_ban = ini:ReadString(nx_string(AUTO_TT), "enable_ban", "")
			if nx_string(check_ban) == nx_string('true') then
				form.check_box_1.Checked = true
			else	
				form.check_box_1.Checked = false
			end
			if index1 and index1 ~= "" then
				form.cbx_ban_skill_1.DropListBox.SelectIndex = index1 - 1
				form.cbx_ban_skill_1.InputEdit.Text = form.cbx_ban_skill_1.DropListBox:GetString(index1 - 1)
				ban_skill1 = util_text(ban1)
				load_auto_ban1(nx_int(index1))
			end
			if index2 and index2 ~= "" then
				form.cbx_ban_skill_2.DropListBox.SelectIndex = index2 - 1
				form.cbx_ban_skill_2.InputEdit.Text = form.cbx_ban_skill_2.DropListBox:GetString(index2 - 1)
				ban_skill2 = util_text(ban2)
				load_auto_ban2(nx_int(index2))
			end			
		end	
	end			
	load_ban_skill_1(form)
	load_ban_skill_2(form)
end
function on_cbtn_auto_box(cbtn)
	local form = cbtn.ParentForm
	local inifile = add_file_user('auto_ai')
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then
        return
    end
	if form.check_box_1.Checked then
		writeIni(inifile,AUTO_TT, "enable_ban", 'true')
	else
		writeIni(inifile,AUTO_TT, "enable_ban", 'false')
	end
end
function load_auto_ban1(num)
  local load_ban_skill = load_ban_skill_data()
  taolu_selection = load_ban_skill[num]
end
function load_auto_ban2(num)
  local load_ban = load_data_taolu(taolu_selection2)
  taolu_selection2 = load_ban[num]
end
function btn_save_setting(btn)
	local form = btn.ParentForm	
	nx_destroy(form)
end
load_ban_skill_data = function(form)
  local load_ban_skill = {}
  table.remove(load_ban_skill)
  local ini = nx_execute("util_functions", "get_ini", "share\\War\\Match\\Match_BanSkill.ini")
  if not nx_is_valid(ini) then
    return
  end
  local SectionCount = ini:GetSectionCount()
  for i = 0, SectionCount - 1 do
    local SectionItemCount = ini:GetSectionItemCount(i)
    for num = 0, SectionItemCount - 1 do
      local banxuan_taolu = ini:ReadString(i, nx_string(num), "")
      local table_date = util_split_string(banxuan_taolu, ",")
      table.insert(load_ban_skill, table_date[1])
    end
  end
  return load_ban_skill
end
load_data_taolu = function(form)
  local load_ban = load_ban_skill_data()
  local load_ban2 = {}
  table.remove(load_ban2)
  for k = 1, #load_ban do
    if load_ban[k] ~= form then
      table.insert(load_ban2, load_ban[k])
    end
  end
  return load_ban2
end
load_ban_skill_1 = function(form)
  local load_ban_skill = load_ban_skill_data()
  form.cbx_ban_skill_1.Text = ban_skill1
  form.cbx_ban_skill_1.DropListBox:ClearString() 
  for k = 1, #load_ban_skill do
    form.cbx_ban_skill_1.DropListBox:AddString(util_text(load_ban_skill[k]))
  end
  form.cbx_ban_skill_1.OnlySelect = true
  form.cbx_ban_skill_1.DropListBox.SelectIndex = form.selectskill1 - 1
  if load_ban_skill[form.selectskill1] ~= nil then
    if form.selectskill1 == 0 then
      form.cbx_ban_skill_1.DropListBox.SelectIndex = 0
    else
      form.cbx_ban_skill_1.InputEdit.Text = util_text(load_ban_skill[form.selectskill1])
      form.cbx_ban_skill_1.DropListBox.SelectIndex = form.selectskill1 - 1
    end
  end
end
load_ban_skill_2 = function(form)
	local load_ban = load_data_taolu(taolu_selection2)
	form.cbx_ban_skill_2.Text = ban_skill2
	form.cbx_ban_skill_2.DropListBox:ClearString()
	for i = 1, #load_ban do
		form.cbx_ban_skill_2.DropListBox:AddString(util_text(load_ban[i]))
	end
	form.cbx_ban_skill_2.OnlySelect = true
	form.cbx_ban_skill_2.DropListBox.SelectIndex = form.selectskill2 - 1
	if load_ban[form.selectskill2] ~= nil then
		if form.selectskill2 == 0 then
			form.cbx_ban_skill_2.DropListBox.SelectIndex = 0
		else
			form.cbx_ban_skill_2.InputEdit.Text = util_text(load_ban[form.selectskill2])
			form.cbx_ban_skill_2.DropListBox.SelectIndex = form.selectskill2 - 1
		end
	end
end
on_cbx_ban_skill_1_selected = function(self)
	local form = self.ParentForm
	form.selectskill1 = self.DropListBox.SelectIndex + 1	
	local loadskillban = load_ban_skill_data()
	taolu_selection = loadskillban[form.selectskill1]
	form.selectskill2 = 0
	local path_ini = add_file_user('auto_ai')		
	writeIni(path_ini,nx_string(AUTO_TT), "selectskillban1", nx_string(taolu_selection))
	writeIni(path_ini,nx_string(AUTO_TT), "selectskillban1_index", nx_string(form.selectskill1))
end
on_cbx_ban_skill_2_selected = function(self)
	local form = self.ParentForm
	form.selectskill2 = self.DropListBox.SelectIndex + 1	
	local loadskill2 = load_data_taolu(taolu_selection)
	taolu_selection2 = loadskill2[form.selectskill2]
	local path_ini = add_file_user('auto_ai')		
	writeIni(path_ini,nx_string(AUTO_TT), "selectskillban2", nx_string(taolu_selection2))
	writeIni(path_ini,nx_string(AUTO_TT), "selectskillban2_index", nx_string(form.selectskill2))
end
function btn_auto_start(btn)
	local form = btn.ParentForm	
	if auto_ai_status or nx_running('auto_new\\autocack','auto_start_ai') or nx_running('auto_new\\form_auto_ai_new','auto_start_ai') or nx_running('auto_new\\form_auto_ai','auto_start_ai2') then
		showUtf8Text(auto_ai_running_wait_stop)
		return
	end
	if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_mr_state_only') then		
		showUtf8Text(auto_please_wait_stop)
		auto_execute_full('auto_new\\form_auto_ai_new','turn_off_auto_mr',false)
		-- auto_execute_full('auto_new\\form_auto_ai_new','turn_off_auto_mr_only')
		-- nx_kill('auto_new\\form_auto_ai_new','exe_auto_fa_state_only')
		-- if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_mr_state_only') then			
			-- nx_kill('auto_new\\form_auto_ai_new','exe_auto_mr_state_only')
		-- end
	else
		auto_execute_full('auto_new\\form_auto_ai_new','exe_auto_mr_only')		
	end	
	updateBtnAuto()
end
function updateBtnStop()
	local form = nx_value("auto_new\\form_auto_match")
	if not nx_is_valid(form) then return end			
	form.btn_auto_start.Text = nx_widestr('Start')	
end
function updateBtnStart()
	local form = nx_value("auto_new\\form_auto_match")
	if not nx_is_valid(form) then return end			
	form.btn_auto_start.Text = nx_widestr('Stop')	
end
function updateBtnAuto()
	local form = nx_value("auto_new\\form_auto_match")
	if not nx_is_valid(form) then return end
	if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_mr_state_only') then
		form.btn_auto_start.Text = nx_widestr('Stop')
	else
		form.btn_auto_start.Text = nx_widestr('Start')		
	end
end
function on_main_form_close(form)
  nx_destroy(form)
end
function on_btn_close_click(form)
local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
