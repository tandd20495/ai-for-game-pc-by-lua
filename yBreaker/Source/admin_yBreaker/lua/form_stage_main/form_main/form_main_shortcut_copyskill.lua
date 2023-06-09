--[[DO: Change weapon when click base on skill or pressing shortcut key for yBreaker (don't apply for Alt key) --]]
require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")
require("util_functions")
require("util_gui")
require("util_static_data")
require("define\\shortcut_key_define")

--[ADD: Variable for backup weapon is used
	local id_skill_copy = ""
--]

local array_name = "CopySkillArray"
local STATIC_DATA = "static_data"
local PAUSE_TIME = "pause_time"
local CAN_RUSH = "can_rush"
local RUSH_RANGE = "rush_range"
local TARGET_TYPE = "target_type"
local VAR_PROP = "var_prop"
local TARGET_SHAPE = "target_shape"
local HIT_SHAPE = "hit_shape"
local CONSUME = "consume"
local FLOW = "flow"
local COOL_TIME = "cool_time"
local skill_new_ini = "share\\Skill\\skill_new.ini"
local normal_varprop_ini = "share\\Skill\\skill_normal_varprop.ini"
local lock_varprop_ini = "share\\Skill\\skill_lock_varprop.ini"
local wuxue_base_ini = "share\\Faculty\\WuXueBaseInfo.ini"
SERVER_SUB_MSG_COPY_OPEN = 0
SERVER_SUB_MSG_COPY_CLOSE = 1
SERVER_SUB_MSG_COPY_CONTINUE = 2
skill_back_image = {
  [0] = "gui\\mainform\\icon_skill_move.png",
  [1] = "gui\\mainform\\icon_red_move.png",
  [2] = "gui\\mainform\\icon_blue_move.png",
  [3] = "gui\\mainform\\icon_green_move.png"
}
function on_main_form_init(self)
  self.Fixed = false
  self.type = 0
end
function init_base_data(form)
  form.base_skill = ""
  form.level = 1
  form.cool_type = 0
  form.cur_skill = ""
  form.static_data = 0
  form.pause_time = 0
  form.can_rush = 0
  form.rush_range = 0
  local common_array = nx_value("common_array")
  if not nx_is_valid(common_array) then
    form:Close()
  end
  if not common_array:FindArray(array_name) then
    common_array:AddArray(array_name, form, 3600, false)
  end
  common_array:ClearChild(array_name)
  form.tips_data = nil
end
function on_main_form_open(self)
  init_form_location(self)
end
function on_main_form_close(self)
  local common_array = nx_value("common_array")
  if nx_is_valid(common_array) then
    common_array:RemoveArray(array_name)
  end
  save_form_location(self)
  nx_destroy(self)
end
function init_form_location(form)
  local game_config = nx_value("game_config")
  local account = game_config.login_account
  local ini = nx_create("IniDocument")
  if not nx_is_valid(ini) then
    return
  end
  ini.FileName = account .. "\\form_location.ini"
  if not ini:LoadFromFile() or not ini:FindSection("copy_skill_shutcut") then
    nx_destroy(ini)
    return
  end
  form.Left = ini:ReadInteger("copy_skill_shutcut", "left", 0)
  form.Top = ini:ReadInteger("copy_skill_shutcut", "top", 0)
  nx_destroy(ini)
end
function save_form_location(form)
  local game_config = nx_value("game_config")
  local account = game_config.login_account
  local ini = nx_create("IniDocument")
  if not nx_is_valid(ini) then
    return
  end
  ini.FileName = account .. "\\form_location.ini"
  ini:LoadFromFile()
  if not ini:FindSection("copy_skill_shutcut") then
    ini:AddSection("copy_skill_shutcut")
  end
  ini:WriteInteger("copy_skill_shutcut", "left", form.Left)
  ini:WriteInteger("copy_skill_shutcut", "top", form.Top)
  ini:SaveToFile()
  nx_destroy(ini)
end
function on_imagegrid_skill_mousein_grid(grid, index)
  local form = grid.ParentForm
  local tips_manager = nx_value("tips_manager")
  if nx_is_valid(tips_manager) then
    tips_manager.InShortcut = true
  end
  if not nx_is_valid(form.tips_data) or form.tips_data.ConfigID ~= form.base_skill then
    init_tips_data(form)
  end
  nx_execute("tips_game", "show_goods_tip", form.tips_data, grid:GetMouseInItemLeft(), grid:GetMouseInItemTop(), 48, 48)
end
function on_imagegrid_skill_mouseout_grid(grid, index)
  nx_execute("tips_game", "hide_tip", grid.ParentForm)
end
function on_imagegrid_skill_select_changed(grid, index)
  local form = grid.ParentForm
  use_copy_skill(form, false)
  
  --[ADD: Change weapon when left click on imagegrid yBreaker
	on_change_weapon(id_skill_copy)
  --]
  
end
function on_imagegrid_skill_rightclick_grid(grid, index)
  local form = grid.ParentForm
  use_copy_skill(form, false)
  
  --[ADD: Change weapon when right click on imagegrid yBreaker
	on_change_weapon(id_skill_copy)
  --]
end
function use_copy_skill(form, whack)
  local fight = nx_value("fight")
  if not nx_is_valid(fight) then
    return
  end
  local static_data = nx_number(get_skill_info(form.base_skill, STATIC_DATA))
  local replace_id = fight:GetReplayeSkillID(static_data)
  if replace_id == nil or replace_id == "" then
    replace_id = form.base_skill
	
	--[ADD: Get skill ID yBreaker
	id_skill_copy = replace_id
	--]
	
  end
  if replace_id ~= form.cur_skill then
    change_cur_skill(form, replace_id)
  end
  local target_type = nx_number(get_skill_info(replace_id, TARGET_TYPE))
  local is_whack_skill = skill_static_query(static_data, "IsWhackSkill")
  if target_type == 1 then
    show_circle_select(form, replace_id)
  elseif is_whack_skill == 1 and whack then
    local fight = nx_value("fight")
    if not nx_is_valid(fight) then
      return
    end
    fight:CheckExtraSkillBeginWhack(replace_id, static_data)
  elseif form.cur_skill ~= "" and form.cur_skill ~= nil then
    nx_execute("custom_sender", "custom_copy_skill", form.cur_skill)
  end
end
function use_circle_select_skill()
  local form = util_get_form(nx_current(), false)
  if not nx_is_valid(form) then
    return
  end
  local decal = nx_value("ground_pick_decal")
  if not nx_is_valid(decal) then
    return
  end
  if form.cur_skill ~= "" and form.cur_skill ~= nil then
    nx_execute("custom_sender", "custom_copy_skill", form.cur_skill, decal.PosX, decal.PosY, decal.PosZ)
  end
end
function end_whack_and_use_skill()
  local form = util_get_form(nx_current(), false)
  if not nx_is_valid(form) then
    return
  end
  local fight = nx_value("fight")
  if not nx_is_valid(fight) then
    return
  end
  if form.cur_skill ~= "" and form.cur_skill ~= nil then
    fight:CheckExtraSkillEndWhack(form.cur_skill)
  end
end
function short_cut_use_skill(key_id)
  local form = util_get_form(nx_current(), false)
  if not nx_is_valid(form) then
    return
  end
  use_copy_skill(form, true)
end
function show_circle_select(form, skill_id)
  local gui = nx_value("gui")
  if not nx_is_valid(gui) then
    return
  end
  local is_cool = gui.CoolManager:IsCooling(nx_int(form.cool_type), nx_int(-1))
  if is_cool then
    local SystemCenterInfo = nx_value("SystemCenterInfo")
    if nx_is_valid(SystemCenterInfo) then
      SystemCenterInfo:ShowSystemCenterInfo(util_text("8029"), 2)
    end
    return
  end
  gui.GameHand.wait_copy_skill = 1
  local hit_shape = nx_number(get_skill_info(skill_id, HIT_SHAPE))
  local target_shape = nx_number(get_skill_info(skill_id, TARGET_SHAPE))
  nx_execute("game_effect", "add_ground_pick_effect", hit_shape * 2, target_shape)
end
function change_cur_skill(form, skill_id)
  form.cur_skill = skill_id
  form.static_data = nx_number(get_skill_info(skill_id, STATIC_DATA))
  form.pause_time = nx_number(get_skill_info(skill_id, PAUSE_TIME))
  form.can_rush = nx_number(get_skill_info(skill_id, CAN_RUSH))
  form.rush_range = nx_number(get_skill_info(skill_id, RUSH_RANGE))
end
function show_copy_skill(base_skill, level, ...)
  local form = util_get_form(nx_current(), true)
  if not nx_is_valid(form) then
    return
  end
  init_base_data(form)
  init_base_skill(form, base_skill, level)
  for i = 1, table.getn(arg) do
    add_skill_to_list(form, arg[i], i)
  end
  update_shortcut_key()
  change_cur_skill(form, base_skill)
  
end
function on_server_msg(sub_msg, skill_id, level, ...)
  if nx_number(sub_msg) == SERVER_SUB_MSG_COPY_OPEN then
    show_copy_skill(skill_id, level, unpack(arg))
    util_show_form(nx_current(), true)
  elseif nx_number(sub_msg) == SERVER_SUB_MSG_COPY_CLOSE then
    local form = nx_value(nx_current())
    if nx_is_valid(form) then
      form:Close()
    end
  elseif nx_number(sub_msg) == SERVER_SUB_MSG_COPY_CONTINUE then
    show_copy_skill(skill_id, level, unpack(arg))
  end
end
function open_copy_skill()
  local form = util_get_form(nx_current(), false)
  if nx_is_valid(form) then
    util_show_form(nx_current(), true)
  end
end
function update_shortcut_key()
  local form = util_get_form(nx_current(), false)
  if not nx_is_valid(form) then
    return
  end
  local shortcut_key = nx_value("ShortcutKey")
  if nx_is_valid(shortcut_key) then
    local key_text = shortcut_key:GetKeyNameByKeyID(Key_SubSkillShortcut_copy)
    if key_text ~= "" and key_text ~= nil then
      form.lbl_short_cut.Text = nx_widestr(key_text)
    end
  end
end
function init_base_skill(form, skill_id, level)
  form.base_skill = skill_id
  form.level = level
  local grid = form.imagegrid_skill
  grid:Clear()
  local static_data = nx_number(get_ini_value(skill_new_ini, skill_id, "StaticData", "0"))
  local photo = skill_static_query(static_data, "Photo")
  grid:AddItem(0, photo, util_text(skill_id), 1, -1)
  local cool_type = skill_static_query(static_data, "CoolDownCategory")
  grid:SetCoolType(0, nx_int(cool_type))
  form.cool_type = cool_type
  local effect_type = skill_static_query(static_data, "EffectType")
  if 0 <= effect_type and effect_type <= 3 then
    grid.DrawGridBack = skill_back_image[effect_type]
  end
  local use_limit = nx_number(get_ini_value(skill_new_ini, skill_id, "UseLimit", "0"))
  local skill_query = nx_value("SkillQuery")
  if nx_is_valid(skill_query) then
    local weapon_type = skill_query:GetSkillWeaponType(use_limit)
    form.lbl_weapon.Text = util_text("weapon_type_" .. nx_string(weapon_type))
  end
end
function add_skill_to_list(form, skill_id, index)
  local common_array = nx_value("common_array")
  if not nx_is_valid(common_array) then
    return
  end
  if not common_array:FindArray(array_name) then
    return
  end
  common_array:AddChild(array_name, skill_id, nx_string(index))
  local szIndex = "_" .. nx_string(index)
  local static_data = nx_number(get_ini_value(skill_new_ini, skill_id, "StaticData", "0"))
  common_array:AddChild(array_name, STATIC_DATA .. szIndex, nx_string(static_data))
  local pause_time = get_ini_value(skill_new_ini, skill_id, "PauseTime", "0")
  common_array:AddChild(array_name, PAUSE_TIME .. szIndex, pause_time)
  local can_rush = skill_static_query(static_data, "CanRush")
  common_array:AddChild(array_name, CAN_RUSH .. szIndex, nx_string(can_rush))
  local rush_range = skill_static_query(static_data, "RushRange")
  common_array:AddChild(array_name, RUSH_RANGE .. szIndex, nx_string(rush_range))
  local target_type = skill_static_query(static_data, "TargetType")
  common_array:AddChild(array_name, TARGET_TYPE .. szIndex, nx_string(target_type))
  local var_pkg = nx_number(skill_static_query(static_data, "MinVarPropNo")) + form.level - 1
  common_array:AddChild(array_name, VAR_PROP .. szIndex, nx_string(var_pkg))
  local skill_type = -1
  local skill_query = nx_value("SkillQuery")
  if nx_is_valid(skill_query) then
    skill_type = skill_query:GetSkillType(skill_id)
  end
  local varprop_paht = lock_varprop_ini
  if nx_number(skill_type) == 1 then
    varprop_paht = normal_varprop_ini
  end
  local consume_pkg = get_ini_value(varprop_paht, nx_string(var_pkg), "Consume", "0")
  common_array:AddChild(array_name, CONSUME .. szIndex, nx_string(consume_pkg))
  local flow_pkg = get_ini_value(varprop_paht, nx_string(var_pkg), "Flow", "0")
  common_array:AddChild(array_name, FLOW .. szIndex, nx_string(flow_pkg))
  local cool_time = get_ini_value(varprop_paht, nx_string(var_pkg), "CoolDownTime", "8000")
  common_array:AddChild(array_name, COOL_TIME .. szIndex, nx_string(cool_time))
  if nx_number(target_type) ~= 1 then
    return
  end
  local target_shape_pkg = get_ini_value(varprop_paht, nx_string(var_pkg), "TargetShapePkg", "-1")
  local hit_shape_pkg = get_ini_value(varprop_paht, nx_string(var_pkg), "HitShapePkg", "-1")
  local data_query = nx_value("data_query_manager")
  if not nx_is_valid(data_query) then
    return
  end
  local target_shape = data_query:Query(STATIC_DATA_SKILL_TARGETSHAPE, nx_number(target_shape_pkg), "TargetShapePara2")
  local hite_shape = data_query:Query(STATIC_DATA_SKILL_HITSHAPE, nx_number(hit_shape_pkg), "HitShapePara2")
  common_array:AddChild(array_name, TARGET_SHAPE .. szIndex, nx_string(target_shape))
  common_array:AddChild(array_name, HIT_SHAPE .. szIndex, nx_string(hite_shape))
end
function get_skill_info(skill_id, info_name)
  local common_array = nx_value("common_array")
  if nx_is_valid(common_array) and common_array:FindArray(array_name) then
    local index = common_array:FindChild(array_name, skill_id)
    if index ~= nil then
      local key = info_name .. "_" .. index
      local value = common_array:FindChild(array_name, key)
      if value ~= nil then
        return value
      end
    end
  end
  return "0"
end
function get_ini_value(ini_path, section, key, defaut)
  local ini = get_ini(ini_path)
  if not nx_is_valid(ini) then
    return
  end
  local index = ini:FindSectionIndex(section)
  if index < 0 then
    return
  end
  return ini:ReadString(index, key, defaut)
end
function init_tips_data(form)
  local tips_data = nx_execute("tips_game", "get_tips_ArrayList")
  tips_data.ConfigID = form.base_skill
  tips_data.ItemType = 1000
  tips_data.Level = form.level
  tips_data.MaxLevel = form.level
  tips_data.StaticData = nx_number(get_skill_info(form.base_skill, STATIC_DATA))
  tips_data.WuXing = nx_number(get_ini_value(wuxue_base_ini, form.base_skill, "nWuXing", "0"))
  tips_data.CoolDownTime = nx_number(get_skill_info(form.base_skill, COOL_TIME))
  local consume_pkg = nx_number(get_skill_info(form.base_skill, CONSUME))
  local flow_pkg = nx_number(get_skill_info(form.base_skill, FLOW))
  local data_query = nx_value("data_query_manager")
  if not nx_is_valid(data_query) then
    return
  end
  tips_data.PrepareTime = data_query:Query(STATIC_DATA_SKILL_FLOW, flow_pkg, "PrepareTime")
  tips_data.AConsumeHP = data_query:Query(STATIC_DATA_SKILL_CONSUME, consume_pkg, "AConsumeHP")
  tips_data.AConsumeMP = data_query:Query(STATIC_DATA_SKILL_CONSUME, consume_pkg, "AConsumeMP")
  tips_data.PConsumeHP = data_query:Query(STATIC_DATA_SKILL_CONSUME, consume_pkg, "PConsumeHP")
  tips_data.PConsumeMP = data_query:Query(STATIC_DATA_SKILL_CONSUME, consume_pkg, "PConsumeMP")
  tips_data.AConsumeSP = data_query:Query(STATIC_DATA_SKILL_CONSUME, consume_pkg, "AConsumeSP")
  tips_data.PConsumeSP = data_query:Query(STATIC_DATA_SKILL_CONSUME, consume_pkg, "PConsumeSP")
  tips_data.BaseConsumeMP = data_query:Query(STATIC_DATA_SKILL_CONSUME, consume_pkg, "BaseConsumeMP")
  tips_data.ConsumeFaculty = data_query:Query(STATIC_DATA_SKILL_CONSUME, consume_pkg, "ConsumeFaculty")
  form.tips_data = tips_data
end

--[ADD: Function to handle event key down for yBreaker
function game_key_down(gui, key, shift, ctrl)
	if shift or ctrl then
	return
	end
	if key == "SPACE" or key == "Space" then
	return
	end
	
	local shortcut_keys = nx_value("ShortcutKey")
	if not nx_is_valid(shortcut_keys) then
		return
	end

	if key == nx_string(shortcut_keys:GetKeyNameByKeyID(Key_SubSkillShortcut_copy)) then
		on_change_weapon(id_skill_copy)
	end
end

function on_change_weapon(skill_id)
	yBreaker_show_Utf8Text("on_change_weapon-skill_id: " .. nx_string(skill_id))
	local form_bag = util_get_form("form_stage_main\\form_bag")
	local skill_pack_ini = get_ini_safe("share\\ModifyPack\\SkillPack.ini")
	if nx_is_valid(form_bag) then
		if nx_is_valid(skill_pack_ini) then
			local item_quip = nx_null()
			local game_client = nx_value("game_client")
			local client_player = game_client:GetPlayer()
			
			local LimitIndex = nx_execute("tips_data", "get_ini_prop", "share\\Skill\\skill_new.ini", skill_id, "UseLimit", "")
			if LimitIndex == nil then
			return false
			end
			local skill_query = nx_value("SkillQuery")
			if not nx_is_valid(skill_query) then
			return false
			end
			local ItemType = skill_query:GetSkillWeaponType(nx_int(LimitIndex))
			if ItemType == nil or nx_int(ItemType) == nx_int(0) then
			return false
			end
			
			if nx_is_valid(client_player) then

				local view_table = game_client:GetViewList()
				for i = 1, table.getn(view_table) do
					local view = view_table[i]
					if view.Ident == nx_string("121") then
						local view_obj_table = view:GetViewObjList()
						for k = 1, table.getn(view_obj_table) do
							local view_obj = view_obj_table[k]

							if nx_number(view_obj:QueryProp("ItemType")) == nx_number(ItemType) then
								item_quip = view_obj
								yBreaker_show_Utf8Text("item_quip: " .. nx_string(item_quip))
								break
							end
						end
					end
				end

				-- Đổi vũ khí tương ứng
				if nx_is_valid(item_quip) then
					nx_execute("form_stage_main\\form_bag_func", "on_bag_right_click", form_bag.imagegrid_equip, nx_number(item_quip.Ident) - 1)	
				end
			end
		end
	end
end
--]
