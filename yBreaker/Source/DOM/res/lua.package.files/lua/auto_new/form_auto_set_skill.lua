require('auto_new\\autocack')

local THIS_FORM = "auto_new\\form_auto_set_skill"
function main_form_init(form)
    form.Fixed = false
	form.taolu = ""
end
function on_main_form_open(form)
	init_ui_content(form)	
end
function SaveSetting(type,method,nameElement,value)	
	local inifile = add_file_user('auto_skill')
    local ini = nx_create("IniDocument")
    if not nx_is_valid(ini) then
        return
    end
    ini.FileName = inifile	
	if ini:LoadFromFile() then
		if not ini:FindSection(type) then			
			ini:AddSection(nx_string(type))
			ini:SaveToFile()			
		end				
		if method == "String" then
			ini:WriteString(type,nx_string(nameElement),nx_string(value))
		end
		if method == "Int" then
			ini:WriteInteger(type,nx_string(nameElement),nx_string(value))
		end
	end
	ini:SaveToFile()
	nx_destroy(ini)
end

function iniStringSelect(type,method,name)
	local inifile = add_file_user('auto_skill')
    local ini = nx_create("IniDocument")
    if not nx_is_valid(ini) then
        return
    end
    ini.FileName = inifile	
    local skill = {}
	local skillini = ""
	if ini:LoadFromFile() then	
		for i = 1, 9 do
			if method == "String"then
				skillini = ini:ReadString(nx_string(type), nx_string(name .. i), "")
			end
			if method == "Int" then
				skillini = nx_number(ini:ReadInteger(nx_string(type), nx_string(name .. i), ""))
			end
			if skillini ~= "" then
				table.insert(skill, skillini)					
			end
		end
	end
	return skill
end

function on_cbtn_change_1(cbtn)
	local form = cbtn.ParentForm	
	local nameCheck = cbtn.Name
	local check = 0
	local section = wstrToUtf8(form.edt_name_taolu.Text) 
	if nx_string(section) == "" then
		showUtf8Text(AUTO_LOG_ADD_NAME_SKILL_AUTO,3)
		cbtn.Checked = false
		return
	end
	if cbtn.Checked == true then
		check = 1
	end	
	local Skill_Id = iniStringSelect(section,"String","config_picture_skill_")	
	local subname = string.gsub(nameCheck,'cbtn_jump_skill_','')
	local int = nx_number(subname)
	SaveSetting(section,"String",nx_string(Skill_Id[int])..'_jump',check)
end
function on_cbtn_change(cbtn)
	local form = cbtn.ParentForm	
	local nameCheck = cbtn.Name
	local check = 0
	local section = wstrToUtf8(form.edt_name_taolu.Text) 
	if nx_string(section) == "" then
		showUtf8Text(AUTO_LOG_ADD_NAME_SKILL_AUTO,3)	
		cbtn.Checked = false	
		return
	end
	if cbtn.Checked == true then
		check = 1
	end
	
	local Skill_Id = iniStringSelect(section,"String","config_picture_skill_")
	local subname = string.gsub(nameCheck,'cbtn_dacbiet_skill_','')
	local int = nx_number(subname)
	SaveSetting(section,"String",nx_string(Skill_Id[int])..'_hide',check)
end

function get_view_item(view_id, view_index)
  local game_client = nx_value("game_client")
  if not nx_is_valid(game_client) then
    return nx_null()
  end
  return game_client:GetViewObj(nx_string(view_id), nx_string(view_index))
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
function on_btn_save_click(btn)
	local form = btn.ParentForm
	local inifile = add_file_user('auto_skill')
	writeIni(inifile,'SettingSkill','Active',form.edt_name_taolu.Text)
    util_show_form(THIS_FORM,false)		
	local form_skill = nx_value('auto_new\\form_auto_skill')
	nx_execute('auto_new\\form_auto_skill','loadGridAutoSkill',form_skill)
end
function init_ui_content(form)	
	if form.taolu == ""  then
		form.edt_name_taolu.Text = utf8ToWstr("Nhập Tên Bộ Skill")			
	end	
	local section = form.taolu
	local Skill_Id = iniStringSelect(section,"String","config_picture_skill_")
	local SkillPhoto = iniStringSelect(section,"String","photo_picture_skill_")
	local image = getFormElement("picture_skill_",form,9)
	local Jump = getFormElement("cbtn_jump_skill_",form,9)
	local Hide = getFormElement("cbtn_dacbiet_skill_",form,9)
	local inifile = add_file_user('auto_skill')	
	local itemphoto = nx_string(readIni(inifile,section,"item_photo",""))	
	for i = 1 , table.getn(SkillPhoto) do
		if SkillPhoto ~= "" then
			image[i].Image = SkillPhoto[i]
		end
		if SkillPhoto == "" then
			image[i].Image = ""
		end
	end	
	for k = 1 ,table.getn(Skill_Id) do
		local Sp = getSkillSp(Skill_Id[k])
		local SkillJump = wstrToUtf8(readIni(inifile,section,Skill_Id[k]..'_jump',""))		
		local SkillHide= wstrToUtf8(readIni(inifile,section,Skill_Id[k]..'_hide',""))		
		if nx_number(SkillHide) == 1 then
			Hide[k].Checked = true
		else
			Hide[k].Checked = false
		end		
		if nx_number(SkillJump) == 1 then
			Jump[k].Checked = true
		else
			Jump[k].Checked = false
		end		
		if Sp ~= nil then
			image[k].LineColor = "255,255,0,255"
			image[k].ShadowColor = "255,255,0,255"
		end
	end	
	form.picture_item.Image = itemphoto
	form.edt_name_taolu.Text = utf8ToWstr(form.taolu)
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
        if view_obj:QueryProp("ConfigID") == configid and view_obj:FindProp("AConsumeSP") then
          return view_obj:QueryProp("ConfigID")
        end
      end
    end
  end
  return nil
end
function reload_form()
	local form = nx_value(THIS_FORM)
	local section = wstrToUtf8(form.edt_name_taolu.Text)
	local SkillSP = iniStringSelect(section,"String","config_picture_skill_")
	local inifile = add_file_user('auto_skill')
	local itemphoto = nx_string(readIni(inifile,section,"item_photo",""))	
	for i = 1 ,table.getn(SkillSP) do
		local Sp = getSkillSp(SkillSP[i])			
		local image = getFormElement("picture_skill_",form,9)
		if Sp ~= nil then
			image[i].LineColor = "255,255,0,255"
			image[i].ShadowColor = "255,255,0,255"
		end
	end	
	form.picture_item.Image = itemphoto
end
function on_left_click(image_grid)
  local form = nx_value(THIS_FORM)	
  local gui = nx_value("gui")
  local section = wstrToUtf8(form.edt_name_taolu.Text) 
  if nx_string(section) == "" then
	showUtf8Text(AUTO_LOG_ADD_NAME_SKILL_AUTO,3)
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
	  SaveSetting(section,"String",'photo_'..namePic,photo)
	  SaveSetting(section,"String",'config_'..namePic,skill_id) 
	  reload_form()
	end	
	game_hand:ClearHand()
end

function on_right_click(image_grid)
    local form = nx_value(THIS_FORM) 
	local pictureForm = ""
	local section = wstrToUtf8(form.edt_name_taolu.Text) 
	local namePic = image_grid.Name
	if nx_find_custom(form, namePic) then
		local image = nx_custom(form, namePic)
		pictureForm = image
	end	
	SaveSetting(section,"String",'photo_'..namePic,"nil")
	SaveSetting(section,"String",'config_'..namePic,"nil") 
	pictureForm.Image = ""  
	reload_form()	
end

function on_left_item_click( self )
  local form = self.ParentForm
  local section = wstrToUtf8(form.edt_name_taolu.Text) 
  if nx_string(section) == "" then
	showUtf8Text(AUTO_LOG_ADD_NAME_SKILL_AUTO,3)
	return
  end
  if not nx_find_custom(self,'UniqueID') then nx_set_custom(self,'UniqueID','1') end
  if not nx_find_custom(self,'ConfigID') then nx_set_custom(self,'ConfigID','null') end
  local gui = nx_value('gui')
  local game_hand = gui.GameHand
  if game_hand:IsEmpty() then return end
  if game_hand.Type == 'viewitem' and game_hand.Para1 == '121' then
    if not checkWeaponItem(game_hand.Para1, game_hand.Para2) then
      showUtf8Text(AUTO_LOG_ADD_NAME_SKILL_AUTO1,3)
    else
      local item = nx_execute('goods_grid', 'get_view_item', game_hand.Para1, game_hand.Para2)
      if nx_is_valid(item) then        
		SaveSetting(section,"String",'item_uid',item:QueryProp('UniqueID'))
		SaveSetting(section,"String",'item_config',item:QueryProp('ConfigID')) 
		SaveSetting(section,"String",'item_photo',game_hand.Image)	
		reload_form()
      end
    end
  end
  game_hand:ClearHand()
end


function checkWeaponItem(view_id,pos)
  local item = nx_execute('goods_grid', 'get_view_item', view_id, pos)
  if not nx_is_valid(item) then
    return false
  end
  local goods_grid = nx_value('GoodsGrid')
  local list = goods_grid:GetEquipPositionList(item)
  for _,value in pairs(list) do
    if nx_number(value) == 22 then return true end
  end
  return false
end


function on_right_item_click( self )
  local form = self.ParentForm
  local section = wstrToUtf8(form.edt_name_taolu.Text) 
  if not nx_find_custom(self,'UniqueID') then nx_set_custom(self,'UniqueID','1') end
  if not nx_find_custom(self,'ConfigID') then nx_set_custom(self,'ConfigID','nil') end
    SaveSetting(section,"String",'item_uid','0')
	SaveSetting(section,"String",'item_config','nil') 
	SaveSetting(section,"String",'item_photo','')
	form.picture_item.Image = "" 
end

function SectionCount()
	local form = nx_value(THIS_FORM)
	local inifile = add_file_user('auto_skill')
    local ini = nx_create("IniDocument")
    if not nx_is_valid(ini) then
        return
    end
    ini.FileName = inifile	
	ini:LoadFromFile()
	if ini:LoadFromFile() then
		local count = ini:GetSectionCount()		
		nx_destroy(ini)
		return count
	else
		nx_destroy(ini)
		return 0
	end
end
function getFormElement(elementName,form,loopRound)
	local picture = elementName
	local getImage = {}
	for i = 1, loopRound do	
		local pic = picture..nx_string(i)
		if nx_find_custom(form, pic) then
		   local image = nx_custom(form, pic)
			table.insert(getImage,image)			
		end		
	end
	if #getImage >= 1 then
		return getImage
	else
		return false
	end
end

function getIni(inifile,method,tree_1,tree_2,tree_3)
	local inifile = add_file_user('auto_skill')
    local ini = nx_create("IniDocument")
    if not nx_is_valid(ini) then
        return
    end
    ini.FileName = inifile
	if not ini:LoadFromFile() then
		return false
	end
	local data = nil
	if method == "String" then
		data = ini:ReadString(tree_1, tree_2, tree_3)
	end
	if method == "Int" then
		data = nx_number(ini:ReadInteger(tree_1, tree_2, tree_3))
	end
	nx_destroy(ini)
	return data
end



