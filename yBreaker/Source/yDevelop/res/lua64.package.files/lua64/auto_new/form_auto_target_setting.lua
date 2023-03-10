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
require("auto_new\\autocack")
if not load_spec_target_setting then
	auto_cack('0')
	auto_cack('2')
	auto_cack('6')
	auto_cack('14')
	load_spec_target_setting = true
end
local THIS_FORM = 'auto_new\\form_auto_target_setting'
local FORM_TARGET = 'auto_new\\form_auto_target'

function main_form_init(form)
  form.Fixed = false
  form.skillid = ""
  form.inifile = ""
end

function on_main_form_open(form)
	if nx_string(form.skillid) == "" or nx_string(form.skillid) == nil then
		form.cbx_skill_taolu.InputEdit.Text = ""
		form.cbx_skill.InputEdit.Text = ""
		form.picture_skill.Image = ""
		form.picture_skill_kc.Image = ""
		form.cbtn_only_def.Checked = false
	end	
	loadSettingAuto()
end
function on_main_form_close(form)
  form.Visible = false
end
function btn_save_setting(btn)
	local form = btn.ParentForm
	saveSettingAutoTarget()
	local form_target = nx_execute("util_gui", "util_get_form", FORM_TARGET, true)
	form_target.inifilename = form.inifile
	form_target.cbx_check_file.InputEdit.Text = nx_widestr(form.inifile)
	util_show_form(FORM_TARGET,true)
	util_show_form(THIS_FORM,false)
end
function getSkillIDForm()
	local form = nx_value(THIS_FORM) 
	local stringskilldef = nx_string(form.cbx_skill.InputEdit.Text)
	if stringskilldef ~= nil or stringskilldef ~= "" then
		local skilldef = util_split_string(nx_string(stringskilldef),',')
		return nx_string(skilldef[2])
	else
		return false
	end
end
function saveSettingAutoTarget()
	local form = nx_value(THIS_FORM) 
	local undef = form.cbtn_only_def.Checked
	local skillIni = getSkillIDForm()
	local action = loadSkillIdToAction(skillIni)
	local stringskilldef = wstrToUtf8(form.cbx_skill.InputEdit.Text)
	local skilltaolu = wstrToUtf8(form.cbx_skill_taolu.InputEdit.Text)
	if undef then
		saveIniSetting(form.inifile,skillIni,"String","undef","1")
		saveIniSetting(form.inifile,skillIni,"String","NameTaolu",skilltaolu)
		saveIniSetting(form.inifile,skillIni,"String","NameSkill",stringskilldef)
		saveIniSetting(form.inifile,skillIni,"String","Action",action)
	else
		local skilldef = util_split_string(nx_string(stringskilldef),',')
		saveIniSetting(form.inifile,skillIni,"String","SkillDef",skilldef[2])
		saveIniSetting(form.inifile,skillIni,"String","undef","0")
		saveIniSetting(form.inifile,skillIni,"String","NameTaolu",skilltaolu)
		saveIniSetting(form.inifile,skillIni,"String","NameSkill",stringskilldef)
		saveIniSetting(form.inifile,skillIni,"String","Action",action)
	end
end
function loadSkillIdToAction(skill_def_id)
	local IniManager = nx_value("IniManager")
	local ini = nx_execute("util_functions", "get_ini", "ini\\action\\zhaoshi_player.ini")
	local skillini = nx_execute("util_functions", "get_ini", "share\\Skill\\skill_new.ini")
	local action_id = ""
		if ini:FindSection(skill_def_id) then
			local sec_index = ini:FindSectionIndex(skill_def_id)
			local data = ini:ReadString(sec_index, "1", "")
			local action = util_split_string(data, ";")[1]
			action_id = action
		end
	return action_id
end
function loadSettingAuto()
	local form = util_get_form(THIS_FORM, false, false)
	
	local skill_id = form.skillid
	local inifile = form.inifile
	if skill_id == nil then
		skill_id = ""
	end
	if skill_id == "" then
		form.cbx_skill_taolu.InputEdit.Text = ""
		form.cbx_skill.InputEdit.Text = ""
		loadSkillTaolu()
	else
		local nameTaoLu = iniStringSelect(inifile,skill_id,"String","NameTaolu")
		local nameSkill = iniStringSelect(inifile,skill_id,"String","NameSkill")
		for j = 1 , table.getn(nameTaoLu) do
			form.cbx_skill_taolu.InputEdit.Text = utf8ToWstr(nameTaoLu[j])
			form.cbx_skill.InputEdit.Text = utf8ToWstr(nameSkill[j])
		end	
		local defCheck = getIniSetting(inifile,"Int",skill_id,"undef",0)
		local SkillPhoto = iniStringSelect(inifile,skill_id,"String","SkillPhotoUndef")
		local image = getFormElement("picture_skill",form)
		local SkillPhotoKC = iniStringSelect(inifile,skill_id,"String","SkillPhotoKC")
		local imageKC = getFormElement("picture_skill_kc",form)
		if defCheck == 1 then
			form.cbtn_only_def.Checked = true
		else
			form.cbtn_only_def.Checked = false
		end
		for i = 1 , table.getn(SkillPhotoKC) do
			if SkillPhotoKC ~= "" then
				imageKC[i].Image = SkillPhotoKC[i]
			end
			if SkillPhotoKC == "" then
				imageKC[i].Image = ""
			end
		end	
		for i = 1 , table.getn(SkillPhoto) do
			if SkillPhoto ~= "" then
				image[i].Image = SkillPhoto[i]
			end
			if SkillPhoto == "" then
				image[i].Image = ""
			end
		end	
	end
end
function get_skill_taolu()
	local game_client = nx_value("game_client")
	if not nx_is_valid(game_client) then
		return nil
	end
	local skill_pack = {}
	local wuxue_query = nx_value("WuXueQuery")
	if not nx_is_valid(wuxue_query) then
		return false
	end
	local fight = nx_value("fight")
	if not nx_is_valid(fight) then
		return false
	end
	local skill_taolu = {}
	local type_tab = wuxue_query:GetMainNames(2)
	for i = 1, table.getn(type_tab) do
		local type_name = type_tab[i]
		local item_tab = wuxue_query:GetSubNames(2, type_name)
		for j = 1, table.getn(item_tab) do
			local sub_type_name = item_tab[j]
			table.insert(skill_taolu,sub_type_name)
		end
	end
	return skill_taolu
end
function loadSkillTaolu(skillname)
	local form = util_get_form(THIS_FORM, false, false)
	form.cbx_skill_taolu.DropListBox:ClearString()
	local kungfu_pack = get_skill_taolu()
	local kungfu_id = nil
	for kp = 1, #kungfu_pack do
		if string.find(kungfu_pack[kp],'CS_') ~= nil then
			local kf_name = util_text(kungfu_pack[kp])
			form.cbx_skill_taolu.DropListBox:AddString(kf_name)
			if skillname ~= nil and kf_name == skillname then
				kungfu_id = kungfu_pack[kp]
				form.cbx_skill_taolu.InputEdit.Text = kf_name
			end
		end
	end
	if kungfu_id ~= nil then
		local skill_pack = get_skill_pack(kungfu_id)
		for k = 1, table.getn(skill_pack) do
			form.cbx_skill.DropListBox:ClearString()
			for h = 1, #skill_pack do
				local bx_txt = nx_function("ext_widestr_to_utf8",util_text(skill_pack[h]))
				bx_txt = nx_function("ext_utf8_to_widestr",bx_txt)
				form.cbx_skill.DropListBox:AddString(bx_txt)
			end
		end
	end
end

function on_cbx_skill_taolu_selected(cbx)
	local form = cbx.ParentForm
	local data = nx_function("ext_widestr_to_utf8",form.cbx_skill.InputEdit.Text)
	local set = nx_function("ext_widestr_to_utf8",form.cbx_skill_taolu.InputEdit.Text)
	addSkillcbx(GetKFIDByKFName(set))
	local skillname = form.cbx_skill_taolu.InputEdit.Text
	loadSkillTaolu(set)
end
function on_cbx_skill_selected(self)
	local form = self.ParentForm
	local data = nx_function("ext_widestr_to_utf8",form.cbx_skill.InputEdit.Text)
	local set = nx_function("ext_widestr_to_utf8",form.cbx_skill_taolu.InputEdit.Text)
	
end
function get_view_item(view_id, view_index)
  local game_client = nx_value("game_client")
  if not nx_is_valid(game_client) then
    return nx_null()
  end
  return game_client:GetViewObj(nx_string(view_id), nx_string(view_index))
end
function on_right_click_kc(image_grid)
    local form = nx_value(THIS_FORM) 
	local pictureForm = ""
	local namePic = image_grid.Name
	if nx_find_custom(form, namePic) then
		local image = nx_custom(form, namePic)
		pictureForm = image
	end	
	local skilldef = getSkillIDForm()
	saveIniSetting(form.inifile,skilldef,"String","SkillPhotoKC","nil")
	saveIniSetting(form.inifile,skilldef,"String","SkillIDKC","nil") 
	pictureForm.Image = ""  
	reload_form()	
end
function on_left_click_kc(image_grid)
  local form = nx_value(THIS_FORM)
  local gui = nx_value("gui")  
   local skilldef = getSkillIDForm()
  if skilldef == false then
	showUtf8Text('Hãy chọn skill để sử dụng',3)
	return
  end
  local game_hand = gui.GameHand
	  if game_hand:IsEmpty() then	
		return 0
	  end
		local pictureForm = ""
		local namePic = image_grid.Name
		if nx_find_custom(form, namePic) then
			local image = nx_custom(form, namePic)
			pictureForm = image
		end		
	  local view_id = nx_number(game_hand.Para1)
	  local view_ident = nx_number(game_hand.Para2)
	  local skill = get_view_item(view_id, view_ident)
	if nx_is_valid(skill) then
	  local skill_id = skill:QueryProp("ConfigID")
	  local photo = nx_execute("util_static_data", "skill_static_query_by_id", skill_id, "Photo")
	  pictureForm.Image = photo
	  saveIniSetting(form.inifile,skilldef,"String","SkillPhotoKC",photo)
	  saveIniSetting(form.inifile,skilldef,"String","SkillIDKC",skill_id) 
	  reload_form()
	end	
end
function on_right_click(image_grid)
    local form = nx_value(THIS_FORM) 
	local pictureForm = ""
	local namePic = image_grid.Name
	if nx_find_custom(form, namePic) then
		local image = nx_custom(form, namePic)
		pictureForm = image
	end	
	local skilldef = getSkillIDForm()
	saveIniSetting(form.inifile,skilldef,"String","SkillPhotoUndef","nil")
	saveIniSetting(form.inifile,skilldef,"String","SkillIDUndef","nil") 
	pictureForm.Image = ""  
	reload_form()	
end
function on_left_click(image_grid)
  local form = nx_value(THIS_FORM)
  local undef = form.cbtn_only_def.Checked
  if undef then
	showUtf8Text('Bạn đang chọn chỉ xài def',3)
	return
  end
  local skilldef = getSkillIDForm()
  if skilldef == false then
	showUtf8Text('Hãy chọn skill để sử dụng',3)
	return
  end
  local gui = nx_value("gui")  
  local game_hand = gui.GameHand
	  if game_hand:IsEmpty() then	
		return 0
	  end
		local pictureForm = ""
		local namePic = image_grid.Name
		if nx_find_custom(form, namePic) then
			local image = nx_custom(form, namePic)
			pictureForm = image
		end		
	  local view_id = nx_number(game_hand.Para1)
	  local view_ident = nx_number(game_hand.Para2)
	  local skill = get_view_item(view_id, view_ident)
	if nx_is_valid(skill) then
	  local skill_id = skill:QueryProp("ConfigID")
	  local photo = nx_execute("util_static_data", "skill_static_query_by_id", skill_id, "Photo")
	  pictureForm.Image = photo
	  saveIniSetting(form.inifile,skilldef,"String","SkillPhotoUndef",photo)
	  saveIniSetting(form.inifile,skilldef,"String","SkillIDUndef",skill_id) 
	  reload_form()
	end	
end
function reload_form()
	local form = nx_value(THIS_FORM)
	local skilldef = getSkillIDForm()
	local SkillSP = iniStringSelect(form.inifile,skilldef,"String","SkillIDUndef")
	local Sp = getSkillSp(SkillSP)			
	local image = getFormElement("picture_skill",form)
	if Sp ~= nil then
		image[i].LineColor = "255,255,0,255"
		image[i].ShadowColor = "255,255,0,255"
	end
end
function getSkillSp(configid)
	local game_client = nx_value("game_client")
	local view_table = game_client:GetViewList()
	for i = 1, table.getn(view_table) do
		local view = view_table[i]
		if view.Ident == nx_string("40") then
			local view_obj_table = view:GetViewObjList()
			for k = 1, table.getn(view_obj_table) do
				local view_obj = view_obj_table[k]				
				if view_obj:QueryProp("ConfigID") == configid then				
					if view_obj:FindProp("AConsumeSP") then
						return view_obj:QueryProp("ConfigID")
					end
				end
			end
		end
	end
	return nil
end
function getFormElement(elementName,form)
	local picture = elementName
	local getImage = {}

	local pic = picture
	if nx_find_custom(form, pic) then
	   local image = nx_custom(form, pic)
		table.insert(getImage,image)			
	end	
	if #getImage >= 1 then
		return getImage
	else
		return false
	end
end
function SectionCount(inifile)
	local form = nx_value(THIS_FORM)
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
function saveIniSetting(inifile,type,method,nameElement,value)
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
	ini.FileName = dir .. "\\autotarget\\"..nx_string(inifile)..'.ini'
	if not nx_function("ext_is_file_exist", ini.FileName) then
		local stringfile = nx_create("StringList")		
		stringfile:SaveToFile(ini.FileName)
	end
	if ini:LoadFromFile() then
		if not ini:FindSection(type) then			
			ini:AddSection(nx_string(type))	
			ini:SaveToFile()	
		end				
		if method == "String" then
			ini:WriteString(type,nx_string(nameElement),nx_string(value))
			ini:SaveToFile()
		end
		if method == "Int" then
			ini:WriteInteger(type,nx_string(nameElement),nx_string(value))
			ini:SaveToFile()
		end
	end
	
	nx_destroy(ini)
end
function on_btn_close_click(form)
local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
function on_ipt_search_key_changed(self)
  local form = self.ParentForm
  if not nx_is_valid(form) then
    return
  end
  if nx_string(self.Text) == nx_string(nx_function("ext_utf8_to_widestr", "Tìm bộ skill")) then
    return
  end
  local gui = nx_value("gui")
  local ItemQuery = nx_value("ItemQuery")
  if not nx_is_valid(ItemQuery) then
    return
  end
  local test = {}
  form.cbx_skill_taolu.DropListBox:ClearString()
  local kungfu_pack = get_skill_taolu()
	local kungfu_id = nil
	for kp = 1, #kungfu_pack do
		if string.find(kungfu_pack[kp],'CS_') ~= nil then
			local kf_name = util_text(kungfu_pack[kp])
			table.insert(test,kungfu_pack[kp])
		end
	end	
	for i =1, #test do
		local vip = wstrToUtf8(self.Text)
		if nx_string(vip) ~= "" then
			if string.find(wstrToUtf8(util_text(test[i])),vip) ~= nil then
				 form.cbx_skill_taolu.DropListBox:AddString(nx_widestr(util_text(test[i])))				 
			end
		end
	end
  if not form.cbx_skill_taolu.DroppedDown then
    form.cbx_skill_taolu.DroppedDown = true
  end
end
function on_ipt_search_key_get_focus(self)
  local form = self.ParentForm
  local gui = nx_value("gui")
  gui.hyperfocused = self
  
   if nx_string(self.Text) == nx_string(nx_function("ext_utf8_to_widestr", "Tìm Tên Bộ Skill")) then
		self.Text = ""
   end
end
function on_ipt_search_key_lost_focus(self)
  local form = self.ParentForm
  if not nx_is_valid(form) then
    return
  end
   if nx_string(self.Text) == nx_string("") then
    self.Text = nx_widestr(nx_function("ext_utf8_to_widestr", "Tìm Tên Bộ Skill"))
  end
end
function GetKFIDByKFName(kf_n)
	local kungfu_pack = get_kungfu_pack()
	for kp = 1, #kungfu_pack do
		local kf_name = util_text(kungfu_pack[kp])
		if kf_n ~= nil and nx_function("ext_widestr_to_utf8",kf_name) == kf_n then
			return kungfu_pack[kp]
		end
	end
end
function addSkillcbx(kungfu_id)
	local form = util_get_form(THIS_FORM, false, false)
	local skill_pack = get_skill_pack(kungfu_id)
	for k = 1, #skill_pack do
		form.cbx_skill.DropListBox:ClearString()
		for h = 1, #skill_pack do
			local bx_txt = nx_function("ext_widestr_to_utf8",util_text(skill_pack[h]))
			bx_txt = bx_txt .. "," .. nx_string(skill_pack[h])
			form.cbx_skill.DropListBox:AddString(nx_function("ext_utf8_to_widestr",bx_txt))
		end
		if k <= #skill_pack then
			local x_txt = nx_function("ext_widestr_to_utf8",util_text(skill_pack[k]))
			x_txt = x_txt .. "," .. nx_string(skill_pack[k])
			form.cbx_skill.InputEdit.Text =  nx_function("ext_utf8_to_widestr",x_txt)
			on_cbx_skill_selected(form.cbx_skill)
			form.cbx_skill.DropListBox.SelectIndex = k - 1
		end
		if k > #skill_pack then
			form.cbx_skill.InputEdit.Text = ""
			on_cbx_skill_selected(form.cbx_skill)
		end
		
	end
	
end


function get_skill_pack(kungfu_id)
	local game_client = nx_value("game_client")
	if not nx_is_valid(game_client) then
		return ""
	end
	local skill_pack = {}
	local wuxue_query = nx_value("WuXueQuery")
	if not nx_is_valid(wuxue_query) then
		return ""
	end
	local fight = nx_value("fight")
	if not nx_is_valid(fight) then
		return ""
	end
	local item_tab = wuxue_query:GetItemNames(2, nx_string(kungfu_id))
	for i = 1, table.getn(item_tab) do
		local item_name = item_tab[i]
		table.insert(skill_pack, item_name)	
	end
	if #skill_pack >= 1 then
		return skill_pack
	else
		return false
	end
end

function get_kungfu_pack()
	local kungfu_pack = {}
	local wuxue_query = nx_value("WuXueQuery")
	if not nx_is_valid(wuxue_query) then
		return false
	end
	local type_tab = wuxue_query:GetMainNames(2)
	for i = 1, table.getn(type_tab) do
		local type_name = type_tab[i]
		local sub_type_tab = wuxue_query:GetSubNames(2, type_name)
	    for j = 1, table.getn(sub_type_tab) do
	    	local sub_type_name = sub_type_tab[j]
			table.insert(kungfu_pack, sub_type_name)
		end
	end
	if #kungfu_pack >= 1 then
		return kungfu_pack
	else
		return false
	end
end
