require("auto_new\\autocack")
if not load_spec_def then
	auto_cack('0')
	auto_cack('2')
	auto_cack('6')
	auto_cack('14')
	load_spec_def = true
end
local THIS_FORM = "auto_new\\autoDef"
function main_form_init(form)
  form.Fixed = false
end
function on_main_form_open(form)
  init_ui_content(form)
  updateButton(form)
end
function getFormElement(elementName, form, loopRound)
  local picture = elementName
  local getImage = {}
  for i = 1, loopRound do
    local pic = picture .. nx_string(i)
    if nx_find_custom(form, pic) then
      local image = nx_custom(form, pic)
      table.insert(getImage, image)
    end
  end
  if #getImage >= 1 then
    return getImage
  else
    return false
  end
end
function init_ui_content(form)	
	local moveCheck = getIni('AutoTarget','Int','Jump','cbtn_skill_move',0)	
	local Skill_Id = iniStringSelect('SkillId','String','picture_skill_')
	local SkillPhoto = iniStringSelect('SkillPhoto','String','picture_skill_')
	local SkillSpecial = iniStringSelect('Special','Int','cbtn_dacbiet_skill_')
	local SkillJump = iniStringSelect('Jump','Int','cbtn_jump_skill_')
	local image = getFormElement('picture_skill_',form,9)	
	if moveCheck == 1 then
		form.cbtn_skill_move.Checked = true
	end
	for i = 1 , table.getn(SkillPhoto) do
		if SkillPhoto ~= '' then
			image[i].Image = SkillPhoto[i]
		end
		if SkillPhoto == '' then
			image[i].Image = ''
		end
	end	
	for i = 1 ,table.getn(Skill_Id) do
		local Sp = getSkillSp(Skill_Id[i])
		if Sp ~= nil then
			image[i].LineColor = '255,255,0,255'
			image[i].ShadowColor = '255,255,0,255'
		end
	end
end
function on_cbtn_change(cbtn)
  local form = cbtn.ParentForm
  local nameCheck = cbtn.Name
  local check = 0
  if cbtn.Checked == true then
    check = 1
  end
  SaveSetting("Special", "String", nameCheck, check)
end
function on_cbtn_change_1(cbtn)
  local form = cbtn.ParentForm
  local nameCheck = cbtn.Name
  local check = 0
  if cbtn.Checked == true then
    check = 1
  end
  SaveSetting("Jump", "String", nameCheck, check)
end
function on_cbtn_change_move(cbtn)
  local form = cbtn.ParentForm
  local nameCheck = cbtn.Name
  local check = 0
  if cbtn.Checked == true then
    check = 1
  end
  SaveSetting("Jump", "String", nameCheck, check)
end
function on_left_click(img)
  left_click_img(img)
end
function on_right_click(img)
  right_click_img(img)
end
local autoDefSkill = false
local autoRunDef = false
function updateButton(form)
  if nx_running('auto_new\\auto_special_lib', "autoDefSkillCustom") then
    form.btn_Start_OnOf.Text = nx_widestr("Stop")
  else
    form.btn_Start_OnOf.Text = nx_widestr("Start")
  end
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
function on_btn_start_click(btn)
  local form = btn.ParentForm
  if not nx_is_valid(form) then
    return
  end
  if nx_running('auto_new\\auto_special_lib', "autoDefSkillCustom") then
    autoRunDef = false
    nx_kill('auto_new\\auto_special_lib', "autoDefSkillCustom")
  else
    autoRunDef = true
    nx_execute('auto_new\\auto_special_lib', "autoDefSkillCustom", true)
  end
  updateButton(form)
end

function getIni(inifile, method, tree_1, tree_2, tree_3)
  local game_config = nx_value("game_config")
  local account = game_config.login_account
  local ini = nx_create("IniDocument")
  if not nx_is_valid(ini) then
    return
  end
  ini.FileName = account .. "\\" .. inifile .. ".ini"
  if not ini:LoadFromFile() then
    return false
  end
  local data
  if method == "String" then
    data = ini:ReadString(tree_1, tree_2, tree_3)
  end
  if method == "Int" then
    data = nx_number(ini:ReadInteger(tree_1, tree_2, tree_3))
  end
  nx_destroy(ini)
  return data
end
function saveNewSetting()
  SaveSetting("SkillPhoto", "String", "picture_skill_1", "nil")
  SaveSetting("SkillId", "String", "picture_skill_1", "nil")
  SaveSetting("Special", "Int", "cbtn_dacbiet_skill_1", 0)
  SaveSetting("Jump", "Int", "cbtn_jump_skill_1", 0)
end

function reload_form()
	local form = nx_value(THIS_FORM)
	local SkillSP = iniStringSelect('SkillId','String','picture_skill_')
	for i = 1 ,table.getn(SkillSP) do
		local Sp = getSkillSp(SkillSP[i])			
		local image = getFormElement('picture_skill_',form,9)
		if Sp ~= nil then
			image[i].LineColor = '255,255,0,255'
			image[i].ShadowColor = '255,255,0,255'
		end
	end
end
function left_click_img(image_grid)
  local form = nx_value(THIS_FORM)	
  local gui = nx_value('gui')  
  local game_hand = gui.GameHand
	  if game_hand:IsEmpty() then	
		return 0
	  end
		local pictureForm = ''
		local namePic = image_grid.Name
		if nx_find_custom(form, namePic) then
			local image = nx_custom(form, namePic)
			pictureForm = image
		end		
	  local view_id = nx_number(game_hand.Para1)
	  local view_ident = nx_number(game_hand.Para2)
	  local skill = get_view_item(view_id, view_ident)
	if nx_is_valid(skill) then
	  local skill_id = skill:QueryProp('ConfigID')
	  local photo = nx_execute('util_static_data', 'skill_static_query_by_id', skill_id, 'Photo')
	  pictureForm.Image = photo
	  SaveSetting('SkillPhoto','String',namePic,photo)
	  SaveSetting('SkillId','String',namePic,skill_id) 
	  reload_form()
	end	
end

function right_click_img(image_grid)
    local form = nx_value(THIS_FORM) 
	local pictureForm = ''
	local namePic = image_grid.Name
	if nx_find_custom(form, namePic) then
		local image = nx_custom(form, namePic)
		pictureForm = image
	end	
	SaveSetting('SkillPhoto','String',namePic,'nil')
	SaveSetting('SkillId','String',namePic,'nil') 
	pictureForm.Image = ''  
	reload_form()	
end
