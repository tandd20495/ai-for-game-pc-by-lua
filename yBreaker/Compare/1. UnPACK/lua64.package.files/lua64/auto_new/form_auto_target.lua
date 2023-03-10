require("auto_new\\autocack")
require('util_gui')
require("util_move")
require('define\\gamehand_type')
require('const_define')
require("auto_new\\auto_special_lib")
if not load_spec_target then
	auto_cack('0')
	auto_cack('2')
	auto_cack('6')
	auto_cack('14')
	load_spec_target = true
end
local THIS_FORM = 'auto_new\\form_auto_target'
local FORM_SETTING = 'auto_new\\form_auto_target_setting'
local last_action
function main_form_init(form)
  form.Fixed = false
  form.inifilename = ""
end
function on_main_form_open(form)
	updateButton(form)	
	form.inifilename = form.cbx_check_file.InputEdit.Text
	if nx_string(form.inifilename) == "" then
		form.cbx_check_file.InputEdit.Text = nx_widestr("SettingTarget")
	else
		form.inifilename = form.cbx_check_file.InputEdit.Text
	end
	local checkkc = getIni('auto_target','Int','Setting','cbtn_undef',0)	
	local checknhadef = getIni('auto_target','Int','Setting','cbtn_targetkc',0)
	local checkping = getIni('auto_target','Int','Setting','cbtn_ping',0)
	if checkkc == 1 then
		form.cbtn_undef.Checked = true	
	end
	if checknhadef == 1 then
		form.cbtn_targetkc.Checked = true	
	end
	if checkping == 1 then
		form.cbtn_ping.Checked = true	
	end
	loadFile()
	loadGridSkillTarget(form,form.inifilename)
end 
function on_cbx_check_file_selected(cbx)
	local form = cbx.ParentForm
	form.inifilename = form.cbx_check_file.InputEdit.Text
	save_setting_acc("IniFile",nx_string(form.inifilename))
	loadGridSkillTarget(form,form.inifilename)
end
function cbtn_ping(cbtn)
	local nameCheck = cbtn.Name
	local check = 0
	if cbtn.Checked == true then
		check = 1
	end
	save_setting_acc(nameCheck,check)
end
function on_cbtn_undef(cbtn)
	local nameCheck = cbtn.Name
	local check = 0
	if cbtn.Checked == true then
		check = 1
	end
	save_setting_acc(nameCheck,check)
end
function cbtn_targetkc(cbtn)
	local nameCheck = cbtn.Name
	local check = 0
	if cbtn.Checked == true then
		check = 1
	end
	save_setting_acc(nameCheck,check)
end
function getSectionNameByIndex(inifile,index)
	local game_config = nx_value("game_config")
    local account = game_config.login_account
	local game_client = nx_value('game_client')	
	local client_player = game_client:GetPlayer()	
	local game_config = nx_value('game_config')
	local account = game_config.login_account
	local server_ID = game_config.server_id
	local dir = nx_function('ext_get_current_exe_path') .. 'nockasdd_'.. account..'_'..nx_string(server_ID) 
    local ini = nx_create("IniDocument")
	if not nx_is_valid(ini) then
        return
    end
	local set = {}
	ini.FileName = dir .. "\\autotarget\\"..nx_string(inifile)..'.ini'
	if ini:LoadFromFile() then
		local sect_list = ini:GetSectionList()
		if #sect_list >= 1 then
			for k, v in pairs(sect_list) do
				if nx_number(k) == nx_number(index) then
					table.insert(set,v)
					return set
				end
			end
		end
	end
end
function getStringNameByIndex(inifile,index)
	local game_config = nx_value("game_config")
    local account = game_config.login_account
	local game_client = nx_value('game_client')	
	local client_player = game_client:GetPlayer()	
	local game_config = nx_value('game_config')
	local account = game_config.login_account
	local server_ID = game_config.server_id
	local dir = nx_function('ext_get_current_exe_path') .. 'nockasdd_'.. account..'_'..nx_string(server_ID) 
    local ini = nx_create("IniDocument")
	if not nx_is_valid(ini) then
        return
    end
	local set = {}
	ini.FileName = dir .. "\\autotarget\\"..nx_string(inifile)..'.ini'
	if ini:LoadFromFile() then
		local sect_list = ini:GetSectionList()
		if #sect_list >= 1 then
			for k, v in pairs(sect_list) do
				if nx_number(k) == nx_number(index) then
					return v
				end
			end
		end
	end
end
function getIni(inifile,method,tree_1,tree_2,tree_3)
	local game_config = nx_value('game_config')
    local account = game_config.login_account
    local ini = nx_create('IniDocument')
    if not nx_is_valid(ini) then
        return
    end
    ini.FileName = account .. '\\'..nx_string(inifile)..'.ini'
	if not ini:LoadFromFile() then
		return false
	end
	local data = nil
	if method == 'String' then
		data = ini:ReadString(tree_1, tree_2, tree_3)
	end
	if method == 'Int' then
		data = nx_number(ini:ReadInteger(tree_1, tree_2, tree_3))
	end
	nx_destroy(ini)
	return data
end
function save_setting_acc(nameElement,value)
	local game_config = nx_value('game_config')
    local account = game_config.login_account
    local ini = nx_create('IniDocument')
    if not nx_is_valid(ini) then
        return
    end
    ini.FileName = account .. nx_string("\\auto_target.ini")	
	if not nx_function("ext_is_file_exist", ini.FileName) then
		local stringList = nx_create("StringList")
		stringList:SaveToFile(ini.FileName)
	end
	if ini:LoadFromFile() then
		if not ini:FindSection('Setting') then			
			ini:AddSection(nx_string('Setting'))
			ini:SaveToFile()			
		end	
		ini:WriteString('Setting',nx_string(nameElement),nx_string(value))		
	end
	ini:SaveToFile()
	nx_destroy(ini)
end

function iniReadText(inifile, section, key, default)
	key = nx_string(key)
	local game_config = nx_value("game_config")
    local account = game_config.login_account
	local game_client = nx_value('game_client')	
	local client_player = game_client:GetPlayer()	
	local game_config = nx_value('game_config')
	local account = game_config.login_account
	local server_ID = game_config.server_id
	local dir = nx_function('ext_get_current_exe_path') .. 'nockasdd_'.. account..'_'..nx_string(server_ID) 
    local ini = nx_create("IniDocument")
	if not nx_is_valid(ini) then
        return
    end
	ini.FileName = dir .. "\\autotarget\\"..nx_string(inifile)..'.ini' 
  if not ini:LoadFromFile() then
    nx_destroy(ini)
    return nx_widestr(default)
  end
  local text = ini:ReadString(section, key, default)
  if text == nil or text == "" then
    return nx_widestr(default)
  end
  nx_destroy(ini)
  return utf8ToWstr(text)
end

function get_buff_info(buff_id, obj)
  local objGetBuff
  if obj == nil then
    local game_client = game_client
    if not nx_is_valid(game_client) then
      return nil
    end
    objGetBuff = game_client:GetPlayer()
  else
    objGetBuff = obj
  end
  if not nx_is_valid(objGetBuff) then
    return nil
  end
  for i = 1, 25 do
    local buff = objGetBuff:QueryProp('BufferInfo' .. tostring(i))
    if buff ~= 0 and buff ~= '' then
      local buff_info = util_split_string(buff, ',')
      local buff_name = nx_string(buff_info[1])
      if nx_string(buff_id) == nx_string(buff_name) then
        local buff_time = buff_info[4]
        if nx_int(buff_time) == nx_int(0) then
          return 0
        end
        local MessageDelay = nx_value('MessageDelay')
        if not nx_is_valid(MessageDelay) then
          return nil
        end
        local server_now_time = MessageDelay:GetServerNowTime()
        local buff_diff_time = tonumber((buff_time - server_now_time) / 1000)
        return buff_diff_time
      end
    end
  end
  return nil
end
function getAction25M(target)
	if getActionPlayer('xfz_07', target) or getActionPlayer('hsqs_03', target) or getActionPlayer('chz_07', target) or getActionPlayer('CS_jh_xlsbz05', target) or getActionPlayer('yyd07_a', target) then
		return true
	end
	return false
end
function getActionPlayer(action, target)
	local game_client = nx_value('game_client')
	local game_visual = nx_value('game_visual')
	local client_player = game_client:GetPlayer()
	local role = nil
		if target == nil then 
			role = util_get_role_model()
		else
			role = game_visual:GetSceneObj(target.Ident)
		end
		local actor_role = role:GetLinkObject('actor_role')
			if nx_is_valid(actor_role) then				
			else 
			actor_role = role
			end	
		local action_set = game_visual:QueryRoleActionSet(actor_role)
		local mount_action_list = actor_role:GetActionBlendList()
		local floor_count = table.maxn(mount_action_list)			
		local action_name = ''
		for i = 0, floor_count - 1 do
			action_name = mount_action_list[i + 1]
			if nx_string(action_name) == action then
				return true
			end
		end
	return false
end
function on_btn_add_ini_click(btn)
	local dialog1 = nx_execute("util_gui", "util_get_form", "form_common\\form_input_name", true, false)
	dialog1.lbl_title.Text = nx_function("ext_utf8_to_widestr", "Nhập Tên File")
	dialog1.info_label.Text = utf8ToWstr("Tên") 		
	dialog1:ShowModal()
	local res, new_name = nx_wait_event(100000000, dialog1, "input_name_return")
	if res == "cancel" then
		_name = ""
		return 0
	else
		_name = new_name
		local game_config = nx_value("game_config")
		local account = game_config.login_account
		local game_client = nx_value('game_client')	
		local client_player = game_client:GetPlayer()	
		local game_config = nx_value('game_config')
		local account = game_config.login_account
		local server_ID = game_config.server_id
		local dir = nx_function('ext_get_current_exe_path') .. 'nockasdd_'.. account..'_'..nx_string(server_ID) 
		if not nx_function("ext_is_exist_directory", nx_string(dir)) then
		  nx_function("ext_create_directory", nx_string(dir))	 
		end
		local ini = nx_create("IniDocument")
		if not nx_is_valid(ini) then
			return
		end
		local form = nx_value(THIS_FORM)
		ini.FileName = dir .. "\\autotarget\\"..nx_string(_name)..'.ini'
		if not nx_function("ext_is_file_exist", ini.FileName) then
			local stringfile = nx_create("StringList")		
			stringfile:SaveToFile(ini.FileName)
			form.cbx_check_file.DropListBox:AddString(nx_widestr(nx_string(new_name)))	
			nx_destroy(stringfile)
			nx_destroy(ini)
		end
		
	end	
end
function loadFile()
	local form = nx_value(THIS_FORM)
	local fs = nx_create("FileSearch")
	local game_config = nx_value("game_config")
    local account = game_config.login_account
	local game_client = nx_value('game_client')	
	local client_player = game_client:GetPlayer()	
	local game_config = nx_value('game_config')
	local account = game_config.login_account
	local server_ID = game_config.server_id
	local dir = nx_function('ext_get_current_exe_path') .. 'nockasdd_'.. account..'_'..nx_string(server_ID)..'\\autotarget'
	if not nx_function("ext_is_exist_directory", nx_string(dir)) then
	  nx_function("ext_create_directory", nx_string(dir))	 
	end
	fs:SearchFile(dir .. "\\", "*")
	local file_table = fs:GetFileList()
	local countFile = table.getn(file_table)
	if countFile <= 0 then
		local ini = nx_create("IniDocument")
		if not nx_is_valid(ini) then
			return
		end
		ini.FileName = dir .. "\\"..nx_string('SettingTarget')..'.ini'
		if not nx_function("ext_is_file_exist", ini.FileName) then
			local stringfile = nx_create("StringList")		
			stringfile:SaveToFile(ini.FileName)
			nx_destroy(stringfile)
		end
		nx_destroy(ini)
	end
	form.cbx_check_file.DropListBox:ClearString()
	for i = 1, countFile do
		local test = string.gsub(file_table[i],'.ini',"")
		form.cbx_check_file.DropListBox:AddString(nx_widestr(test))
	end
	form.inifilename = form.cbx_check_file.InputEdit.Text
end
function loadGridSkillTarget(form,inifilename)
	local gui = nx_value("gui")
	local grid = form.textgrid_pos
	inifilename = 	form.inifilename
	local skill_def_id = ""
	local targetType = ""
	local countini = SectionCount(inifilename)
	grid:ClearRow()
	grid:ClearSelect()
	if countini > 0 then
		for j = 1, countini do
			skill_def_id = getSectionNameByIndex(inifilename,j)
			for i = 1, table.getn(skill_def_id) do
				local skillUndef = iniStringSelect(inifilename,skill_def_id[i],"String","SkillIDUndef")
				local skilldef = iniStringSelect(inifilename,skill_def_id[i],"String","SkillDef")
				local typeTarget = getIniSetting(inifilename,"Int",skill_def_id[i],"undef",0)
				if typeTarget == 1 then
					targetType = "Only Def"
				else
					targetType = "Skill"
				end
				local photo = nx_execute("util_static_data", "skill_static_query_by_id", skill_def_id[i], "Photo")
				local btn_del = create_button(skill_def_id[i],row,"Del",'on_click_btn_del')
				local mTextName = create_multitext()
				local btn = create_button(skill_def_id[i],row,"Setting",'on_click_btn')
				local targetSkill = wstrToUtf8(util_text(nx_string(skillUndef[i])))
				if skillUndef[i] == nil then
					targetSkill = "Use Auto Def"
				end
				local nameSkill = '<a href="" style=\"HLStype1\">'..wstrToUtf8(util_text(skill_def_id[i]))..'</a><br><a href="" >'..targetType..'</a><br>Skill: <a href="" style=\"HLStype2\"  > '..targetSkill..'</a>' 				
				mTextName.HtmlText =  utf8ToWstr(nameSkill)
				gridAndFunc(grid,mTextName,btn,btn_del)
			end
		end		
	end
end
function gridAndFunc(grid,mTextName,btn,btn_del)
	local form = nx_value(THIS_FORM)
	local row = grid:InsertRow(-1)
	grid:SetGridControl(row, 0, mTextName)
	grid:SetGridControl(row, 1, btn)
	grid:SetGridControl(row, 2, btn_del)
end
function iniStringSelect(inifile,type,method,name)
	local game_config = nx_value("game_config")
    local account = game_config.login_account
	local game_client = nx_value('game_client')	
	local client_player = game_client:GetPlayer()	
	local game_config = nx_value('game_config')
	local account = game_config.login_account
	local server_ID = game_config.server_id
	local dir = nx_function('ext_get_current_exe_path') .. 'nockasdd_'.. account..'_'..nx_string(server_ID) 
    local ini = nx_create("IniDocument")
	if not nx_is_valid(ini) then
        return
    end
	ini.FileName = dir .. "\\autotarget\\"..nx_string(inifile)..'.ini' 	
    local skill = {}
	local skillini = ""
	if ini:LoadFromFile() then	
		if method == "String"then
			skillini = ini:ReadString(nx_string(type), nx_string(name), "")
		end
		if method == "Int" then
			skillini = nx_number(ini:ReadInteger(nx_string(type), nx_string(name), ""))
		end
		if skillini ~= "" then
			table.insert(skill, skillini)					
		end
	end
	return skill
end
function SectionCount(inifile)
	local game_config = nx_value("game_config")
    local account = game_config.login_account
	local game_client = nx_value('game_client')	
	local client_player = game_client:GetPlayer()	
	local game_config = nx_value('game_config')
	local account = game_config.login_account
	local server_ID = game_config.server_id
	local dir = nx_function('ext_get_current_exe_path') .. 'nockasdd_'.. account..'_'..nx_string(server_ID) 
    local ini = nx_create("IniDocument")
	if not nx_is_valid(ini) then
        return
    end
	ini.FileName = dir .. "\\autotarget\\"..nx_string(inifile)..'.ini'
	if ini:LoadFromFile() then
		local count = ini:GetSectionCount()		
		nx_destroy(ini)
		return count
	else
		nx_destroy(ini)
		return 0
	end
end
function removeSection_PC(inifile, section)
	local game_config = nx_value("game_config")
    local account = game_config.login_account
	local game_client = nx_value('game_client')	
	local client_player = game_client:GetPlayer()	
	local game_config = nx_value('game_config')
	local account = game_config.login_account
	local server_ID = game_config.server_id
	local dir = nx_function('ext_get_current_exe_path') .. 'nockasdd_'.. account..'_'..nx_string(server_ID) 
    local ini = nx_create("IniDocument")
	if not nx_is_valid(ini) then
        return
    end
	ini.FileName = dir .. "\\autotarget\\"..nx_string(inifile)..'.ini'  
	if ini:LoadFromFile() then
		if ini:FindSection(section) then
			ini:DeleteSection(section)
			ini:SaveToFile()
			nx_destroy(ini)
		end
	end
end

function getIniSetting(inifile,method,tree_1,tree_2,tree_3)
	local game_config = nx_value("game_config")
    local account = game_config.login_account
	local game_client = nx_value('game_client')	
	local client_player = game_client:GetPlayer()	
	local game_config = nx_value('game_config')
	local account = game_config.login_account
	local server_ID = game_config.server_id
	local dir = nx_function('ext_get_current_exe_path') .. 'nockasdd_'.. account..'_'..nx_string(server_ID) 
    local ini = nx_create("IniDocument")
	if not nx_is_valid(ini) then
        return
    end
	ini.FileName = dir .. "\\autotarget\\"..nx_string(inifile)..'.ini'   
	if not ini:LoadFromFile() then
		return false
	end
	local data = nil
	if method == 'String' then
		data = ini:ReadString(tree_1, tree_2, tree_3)
	end
	if method == 'Int' then
		data = nx_number(ini:ReadInteger(tree_1, tree_2, tree_3))
	end
	nx_destroy(ini)
	return data
end
function checkBossIdForm(inifilename,skillid)
	local form_setting = nx_execute("util_gui", "util_get_form", FORM_SETTING, true)
	if skillid == nil then
		skillid = ""
	end
	form_setting.skillid = nx_string(skillid)
	form_setting.inifile = nx_string(inifilename)
end
function checkCDSkill(skill_id)	
	if skill_id ~= nil and skill_id ~= "" then	
		if nx_is_valid(nx_value('fight')) and nx_is_valid(nx_value('fight'):FindSkill(skill_id)) then		
			local cooltype = SkillStaticQueryById(skill_id, "CoolDownCategory")
			local coolteam = SkillStaticQueryById(skill_id, "CoolDownTeam")			
			if nx_value("gui").CoolManager:IsCooling(cooltype, coolteam) then
				return true
			end		
		end
	end
	return false
end

function create_multitext()
  local gui = nx_value("gui")
  if not nx_is_valid(gui) then
    return
  end
  local multitextbox = gui:Create("MultiTextBox")
  if not nx_is_valid(multitextbox) then
    return
  end
  multitextbox.HAlign = "Right"
  multitextbox.LineTextAlign = "Center"
  multitextbox.Width = "45" 
  multitextbox.Height = "45"
  multitextbox.AutoSize = false
  multitextbox.Transparent = true
  multitextbox.Name = "MultiTextBox_path_" .. nx_string(i)
  multitextbox.TextColor = "255,128,101,74"
  multitextbox.SelectBarColor = "0,0,0,0"
  multitextbox.MouseInBarColor = "0,0,0,0"
  multitextbox.Font = "font_text"
  multitextbox.LineColor = "0,0,0,0"
  multitextbox.ShadowColor = "0,0,0,0"
  multitextbox.ViewRect = "0,0,310,80"
  return multitextbox
end

function create_button(skill_id, row,title,func)
  local gui = nx_value("gui")
  local grp = gui:Create("GroupBox")
  grp.BackColor = "0,0,0,0"
  grp.LineColor = "0,0,0,0"
  local button = gui:Create("Button")
  if not nx_is_valid(button) then
    return
  end
  button.Top = 15
  button.ForeColor = "255,255,255,255"
  button.AutoSize = false
  button.NormalImage = "gui\\common\\button\\btn_normal2_out.png"
  button.FocusImage = "gui\\common\\button\\btn_normal2_on.png"
  button.PushImage = "gui\\common\\button\\btn_normal2_down.png"
  button.DrawMode = "ExpandH"
  button.Hight = 26
  button.row_index = row
  button.skillid = skill_id
  button.Text = utf8ToWstr(title)
  nx_bind_script(button, nx_current())
  nx_callback(button, "on_click",nx_string(func)) 
  grp:Add(button)
  return grp
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
function getTextTask(current,textForm)		
	if nx_running('auto_new\\auto_special_lib',current) then		
		textForm = "Hoạt Động"
	else
		textForm = ""
	end
	return textForm
end
function updateBtnText_fix_item(form,text)	
	form.lbl_cur_task_1.Text = nx_function('ext_utf8_to_widestr',text)
end
function on_btn_add_click(btn)
	local form = btn.ParentForm
	checkBossIdForm(form.inifilename)
	util_auto_show_hide_form(FORM_SETTING)
end
function on_click_btn(btn)
	local form = btn.ParentForm
	checkBossIdForm(form.inifilename,btn.skillid)
	util_auto_show_hide_form(FORM_SETTING)
end

function on_click_btn_del(btn)
	local form = btn.ParentForm
	removeSection_PC(form.inifilename,btn.skillid)
	loadGridSkillTarget(form,form.inifilename)
end
function updateBtnText_fix_item(form,text)
	form.lbl_cur_task_1.Text = nx_function('ext_utf8_to_widestr',text)
end
function on_btn_start_click(btn)
	local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
	if nx_running('auto_new\\auto_special_lib', "auto_start_def") then		
		nx_kill('auto_new\\auto_special_lib', "auto_start_def")		
	else
		nx_execute('auto_new\\auto_special_lib', "auto_start_def")	
	end
	updateButton(form)	
end
function updateButton(form)	
	if nx_running('auto_new\\auto_special_lib', "auto_start_def") then		
		form.btn_start.Text = nx_widestr("Stop")		
	else		
		form.btn_start.Text = nx_widestr("Start")		
	end
end