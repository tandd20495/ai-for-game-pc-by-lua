require('util_gui')
require("util_move")
require('define\\gamehand_type')
require('const_define')
require('auto_new\\autocack')
--require('auto_nc_clone')
if not load_auto_dmqt then
	auto_cack('0')
	auto_cack('8')
	auto_cack('9')	
	load_auto_dmqt = true
end
local THIS_FORM = 'auto_new\\form_auto_dmqt'
function main_form_init(form)
  form.Fixed = false
  form.pick_str = ""
  form.itemString = ""
  form.string_list = nx_create("StringList")
end
list_pickup = {}
market_item_table = {}
function on_main_form_open(form)
  init_ui_content(form)	
end
CLONE_SAVE_REC = 'clone_rec_save'
SCENE_CFG_FILE = 'ini\\scenes.ini'
HOMEPOINT_INI_FILE = 'share\\Rule\\HomePoint.ini'
SCENE_INI = 'share\\Rule\\scenes.ini'

function isProgressClone(clone_id)
    local game_client = nx_value('game_client')
    if not nx_is_valid(game_client) then
        return false
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return false
    end
    if not player_client:FindRecord(CLONE_SAVE_REC) then
        return false
    end
    local rownum = player_client:GetRecordRows(CLONE_SAVE_REC)
    for i = 0, rownum - 1 do
        local propID = player_client:QueryRecord(CLONE_SAVE_REC, i, 0)
        if nx_int(propID) == nx_int(clone_id) then
            return true
        end
    end
    return false
end
function getCloneConfigID(clone_id)
    local clone_ini = nx_execute('util_functions', 'get_ini', SCENE_CFG_FILE)
    if not nx_is_valid(clone_ini) then
        return ''
    end
    local index = clone_ini:FindSectionIndex(nx_string(clone_id))
    local pCloneConfig = ''
    if 0 < nx_number(index) then
        pCloneConfig = clone_ini:ReadString(nx_int(index), 'Config', '')
    end
    return pCloneConfig
end

function isPickListReturn(ini_name, content, key)
  local file = add_file(ini_name)
  local ini = nx_create('IniDocument')
  ini.FileName = file
  if ini:LoadFromFile() then
    local data = ini:ReadString(nx_string(key), 'listnhat', '')
    local list_pickup = util_split_string(data, ',')
    for k = 1, table.getn(list_pickup) do
      if list_pickup[k] ~= '' and list_pickup[k] == content then
        return true
      end
    end
  end
  return false
end
function isPickList(ini_name, key)
	nx_pause(0.1)
	local file = add_file(nx_string(ini_name))
	local ini = nx_create('IniDocument')
	ini.FileName = file
	if ini:LoadFromFile() then
		local data = ini:ReadString(nx_string(key), 'listnhat', '')
		local list_pickup = auto_split_string(data, ',')
		if table.getn(list_pickup) == 0 then return end
		return list_pickup		
	else
		return nil
	end
  return nil
end
-- function collectItem_TDC(file_name,key)	
	-- nx_pause(0.5)
	-- local game_client = nx_value('game_client')
	-- local client_player = game_client:GetPlayer()	
	-- if nx_is_valid(client_player) then
		-- local scene = game_client:GetScene()
		-- local view_table = game_client:GetViewList()
		-- for i = 1, table.getn(view_table) do
			-- local view = view_table[i]
			-- if view.Ident == nx_string('80') then
				-- local view_obj_table = view:GetViewObjList()
				-- for k = 1, table.getn(view_obj_table) do
					-- local view_obj = view_obj_table[k]	
					-- local list = isPickList(file_name,key)	
					-- if list ~= nil then
						-- local name = nx_function('ext_widestr_to_utf8', util_text(view_obj:QueryProp('ConfigID')))						
						-- for n = 1, table.getn(list) do
							-- if nx_widestr(list[n]) == nx_widestr(name) then
								-- nx_execute('custom_sender', 'custom_pickup_single_item', view_obj.Ident)
							-- end
						-- end						
					-- else
						-- nx_execute('custom_sender', 'custom_pickup_single_item', view_obj.Ident)
					-- end
				-- end
			-- end
		-- end
	-- end
-- end
function collectItem_TDC(file_name,key)	
	nx_pause(1)
   local game_client = nx_value('game_client')
	local client_player = game_client:GetPlayer()	
	if nx_is_valid(client_player) then
		local scene = game_client:GetScene()
		local view_table = game_client:GetViewList()
		for i = 1, table.getn(view_table) do
			local view = view_table[i]
			if view.Ident == nx_string('80') then
				local view_obj_table = view:GetViewObjList()
				for k = 1, table.getn(view_obj_table) do
					local view_obj = view_obj_table[k]	
					local list = isPickList(file_name,key)	
					if list ~= nil then
						local name = nx_function('ext_widestr_to_utf8', util_text(view_obj:QueryProp('ConfigID')))
						if table.getn(list) > 0 then
							for n = 1, table.getn(list) do
								if nx_widestr(list[n]) == nx_widestr(name) then
									nx_execute('custom_sender', 'custom_pickup_single_item', view_obj.Ident)
								end
							end
						end
					else
						nx_execute('custom_sender', 'custom_pickup_single_item', view_obj.Ident)
					end
				end
			end
		end
	end
end
function collectItemCol_TDC(file_name,key)
	nx_pause(1)
	local client = nx_value('game_client')
	local view = client:GetView(nx_string(80))
	local form = nx_value('form_stage_main\\form_clone_col_awards')	
	if not nx_is_valid(view) then
		nx_execute('custom_sender', 'custom_clone_request_open_col_award')
		nx_pause(2)
	else
		local viewobj_list = view:GetViewObjList()
		local numberItems = table.getn(viewobj_list)
		if numberItems > 0 then
			for k = 1, numberItems do
				local item = viewobj_list[k]
				local itemID = getUtf8Text(item:QueryProp('ConfigID'))
				local ColorLevel = item:QueryProp('ColorLevel')
				if isPickListReturn(file_name,itemID,key) then
					nx_execute('custom_sender', 'custom_pickup_single_item', nx_int(item.Ident))
				end
			end
			nx_pause(2)	
			nx_execute('custom_sender', 'custom_close_drop_box')	
			nx_pause(3)			
			local form = nx_value('form_stage_main\\form_clone_col_awards')
			if nx_is_valid(form) then
				nx_execute('form_stage_main\\form_clone_col_awards', 'on_main_form_close', form)
			end	
				
		end
	end	
end
function collectItemEnd_TDC(file_name,key)
	nx_pause(1)
	local client = nx_value('game_client')
	local view = client:GetView(nx_string('127'))
	local form = nx_value('form_stage_main\\form_clone_awards')
	local viewobj_list = view:GetViewObjList()
	local numberItems = table.getn(viewobj_list)
	if nx_is_valid(view) then
		if numberItems > 0 then
			for k = 1, numberItems do
				local item = viewobj_list[k]
				local itemID = getUtf8Text(item:QueryProp('ConfigID'))
				if isPickListReturn(file_name,itemID,key) then
					nx_execute('custom_sender', 'custom_pickup_cloneitem', nx_int(item.Ident))
				end
			end
			nx_pause(3)	
			local form = nx_value('form_stage_main\\form_clone_awards')
			if nx_is_valid(form) then
				nx_execute('form_stage_main\\form_clone_awards', 'on_main_form_close', form)
				nx_pause(1)
			end	
		end
	end	
end

function auto_skill_clc_clone(obj, vobj,lam, allowedTargetSkill, allowedAQ)	
    local gui = nx_value('gui')
    if not nx_is_valid(gui) then
        return false
    end
    if not nx_is_valid(obj) then
        return false
    end
    if not nx_is_valid(vobj) then
        return false
    end
    local fight = nx_value('fight')
    if not nx_is_valid(fight) then
        return false
    end
    local skillPhaDef = {'cs_jl_shuangci06', 5583, 50108} 
    local skill1 = {'cs_jl_shuangci02', 5410, 50108} 
    local skill2 = {'cs_jl_shuangci05', 5662, 50108} 
    local skillNo = {'cs_jl_shuangci07', 5530, 50108} 
	local skillVoKy = {'cs_jl_shuangci03', 5419, 50108} 
    local skillTarget = {'cs_jl_shuangci04', 5527, 50108}
    local readyDestroyParry = false
    if not gui.CoolManager:IsCooling(nx_int(skillPhaDef[2]), nx_int(skillPhaDef[3])) then
        readyDestroyParry = true
    end
	local game_client = nx_value('game_client')
	local game_visual = nx_value('game_visual')
	local game_scence = game_client:GetScene()
	local player_client = game_client:GetPlayer()
	local game_player = game_visual:GetSceneObj(player_client.Ident)	
	local skill_id = 'CS_wd_tjq07'
	local skill = fight:FindSkill(skill_id)
	local buffskill = true
	if (player_client:QueryProp('HPRatio') < 20 or player_client:QueryProp('MPRatio') < 5) and lam == nx_string('true') then			
		if nx_is_valid(skill) then
			buffskill = false
			game_visual:EmitPlayerInput(player, 21, 12)
			game_visual:SwitchPlayerState(util_get_role_model(), 'be_swim', nx_int(38))
			game_visual:SwitchPlayerState(util_get_role_model(), 'static', nx_int(1))
			buff_full_hpmp()
		end
	end	
	if player_client:QueryProp('HPRatio') > 20 then
		buffskill = true
	end
	if buffskill then
		if obj:QueryProp('InParry') ~= 0 and readyDestroyParry then
			fight:TraceUseSkill(skillPhaDef[1], false, false)
		else
			local StopSkill = false 
			local skillVK = false
			if not StopSkill then
				if not gui.CoolManager:IsCooling(nx_int(skill1[2]), nx_int(skill1[3])) then
					StopSkill = true
					fight:TraceUseSkill(skill1[1], false, false)
				end
			end	
			if not StopSkill then
				if not gui.CoolManager:IsCooling(nx_int(skill2[2]), nx_int(skill2[3])) then
					StopSkill = true
					fight:TraceUseSkill(skill2[1], false, false)
				end
			end
			local buffNC = get_buff_info('buf_CS_jl_shuangci07')
			if getPlayerPropInt('SP') > nx_int(25) and (buffNC == nil or buffNC < 3) and get_buff_info('buff_tg_pobati', obj) == nil then
				StopSkill = true
				skillVK = true
				fight:TraceUseSkill(skillNo[1], false, false)				
			end						
			-- if StopSkill then					
				-- if allowedAQ ~= nil and get_buff_info('buf_CS_jl_shuangci03') == nil and nx_number(buffNC) > nx_number(18) and not gui.CoolManager:IsCooling(nx_int(skillVoKy[2]), nx_int(skillVoKy[3])) then	
					-- StopSkill = true
					-- fight:TraceUseSkill(skillVoKy[1], false, false)
				-- end
			-- end	
			if not StopSkill and allowedTargetSkill ~= nil then
				if not gui.CoolManager:IsCooling(nx_int(skillTarget[2]), nx_int(skillTarget[3])) then
					StopSkill = true
					fight:TraceUseSkill(skillTarget[1], false, false)
				end
			end			
		end
	end    
end
function find_npc_to_kill(configID, noCanAttack, distance, dismissDead)
    local game_visual = nx_value('game_visual')
    if not nx_is_valid(game_visual) then
        return nil
    end
    local game_client = nx_value('game_client')
    if not nx_is_valid(game_client) then
        return nil
    end
    local game_scence = game_client:GetScene()
    if not nx_is_valid(game_scence) then
        return nil
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return nil
    end
    local gui = nx_value('gui')
    if not nx_is_valid(gui) then
        return nil
    end
    local fight = nx_value('fight')
    if not nx_is_valid(fight) then
        return nil
    end
    local minDistance = 9999
    local curObj = nil
    local curVObj = nil
    local game_scence_objs = game_scence:GetSceneObjList()
    curObj = nx_null()
    curVObj = nx_null()

    for i = 1, table.getn(game_scence_objs) do
        local obj = game_scence_objs[i]
        local vobj = game_visual:GetSceneObj(nx_string(obj.Ident))
        if nx_is_valid(obj) and nx_is_valid(vobj) then
            local currDistance = getCompetitorDistance(vobj)           
            if in_array(nx_string(obj:QueryProp('ConfigID')), configID) and (
                dismissDead ~= nil or (obj:QueryProp('Dead') ~= 1 and obj:QueryProp('Dead') ~= 2)
            ) and (noCanAttack ~= nil or fight:CanAttackNpc(player_client, obj)) and (
                distance == nil or tools_move_isArrived(vobj.PositionX, vobj.PositionY, vobj.PositionZ, distance)
            ) and (
                currDistance < minDistance
            ) then
                minDistance = currDistance
                curObj = obj
                curVObj = vobj
            end
        end
    end
    if nx_is_valid(curObj) and nx_is_valid(curVObj) then
        return curObj, curVObj
    end
    return nil
end
function skill_check_range()
	local fight = nx_value('fight')
	local skill_normal = fight:GetNormalAnqiAttackSkillID('')
	local skill = fight:FindSkill(skill_normal) 
	if nx_is_valid(skill) then
		local cool_type = skill_static_query_by_id(skill_normal, "CoolDownCategory")
		local cool_team = skill_static_query_by_id(skill_normal, "CoolDownTeam")
		if cool_type < 0 or not nx_value("gui").CoolManager:IsCooling(nx_int(cool_type), nx_int(cool_team)) then
		  nx_value("fight"):TraceUseSkill(skill_normal, false, false)
		end  
	end
end
function killMod(cenPos,armod,songthich)
	if not tools_move_isArrived(cenPos[1], cenPos[2], cenPos[3], 4) then
		jump_direct_to_pos_2(cenPos,90,3)
		nx_pause(2)
	else
		local mod, vmod = find_npc_to_kill(armod, nil, 20)
		if nx_is_valid(mod) and nx_is_valid(vmod) then
			if not tools_move_isArrived(vmod.PositionX, vmod.PositionY,vmod.PositionZ, 15) then
				skill_check_range()
			end
			if setTargetCompetitor(mod) then
				if songthich == nx_string('true') then
					auto_skill_clc_clone(mod, vmod)
				else
					if mod:QueryProp('InParry') == 1 then
						auto_skill_all_auto('phadef', mod,0,0)
					else
						auto_skill_all_auto(nil, mod,0,0)
					end
				end
			end
		else
			return true
		end
		return false
	end
end
function useItemFirstClone(isDicot,casot,lagbdh,isUseKN,isUseLN)
	local fight = nx_value('fight')
	local GoodsGrid = nx_value('GoodsGrid')	
	local numLagCS = GoodsGrid:GetItemCount('caiyao10197')
	local bufLagCS = get_buff_info('buff_csxingfen4')	
	local form_bag = util_get_form('form_stage_main\\form_bag', true, true)	
	if not nx_is_valid(form_bag) then
		util_auto_show_hide_form('form_stage_main\\form_bag')
		nx_pause(2)
	end
	if casot == nx_string('true') and (bufLagCS == nil or bufLagCS < 300) and numLagCS > 0   then	
		if nx_is_valid(form_bag) then
			form_bag.rbtn_tool.Checked = true
		end
		nx_execute('form_stage_main\\form_bag_func', 'use_item_by_configid', 'caiyao10197')		
		nx_pause(7)
	end	
	local buffDC = get_buff_info('buf_CS_change_2')	
	if isDicot == nx_string('true') and (buffDC == nil or buffDC < 300) and nx_is_valid(fight:FindSkill('CS_change_2')) then		
		fight:TraceUseSkill('CS_change_2', false, false)		
		nx_pause(3)
	end
	local numLagBDH = GoodsGrid:GetItemCount('item_sweetemploy_102')
	local bufLagBDH = get_buff_info('buf_employers_102')
	if (bufLagBDH == nil or bufLagBDH < 300) and numLagBDH > 0 and lagbdh == nx_string('true') then		
		if nx_is_valid(form_bag) then
			form_bag.rbtn_tool.Checked = true
		end
		nx_execute('form_stage_main\\form_bag_func', 'use_item_by_configid', 'item_sweetemploy_102')		
		nx_pause(5.5)
	end
	local numLagKN = GoodsGrid:GetItemCount('item_clone_damage0_h')
	local bufLagKN = get_buff_info('buff_clone_damage')
	if (bufLagKN == nil or bufLagKN < 300) and numLagKN > 0 and isUseKN == nx_string('true') then		
		if nx_is_valid(form_bag) then
			form_bag.rbtn_tool.Checked = true
		end
		nx_execute('form_stage_main\\form_bag_func', 'use_item_by_configid', 'item_clone_damage0_h')		
		nx_pause(5.5)
	end
	local numLagLN = GoodsGrid:GetItemCount('item_clone_damageact2')
	local bufLagLN = get_buff_info('buff_clone_damage2')
	local bufLagKN = get_buff_info('buff_clone_damage')
	if (bufLagLN == nil or bufLagLN < 300) and numLagLN > 0 and isUseLN == nx_string('true') and bufLagKN == nil then		
		if nx_is_valid(form_bag) then
			form_bag.rbtn_tool.Checked = true
		end
		nx_execute('form_stage_main\\form_bag_func', 'use_item_by_configid', 'item_clone_damageact2')	
		nx_pause(5.5)
	end	
end
checkSkill = {
	'skill_clone038_hme_02', -- hư trảm
	'skill_clone038_hme_01', -- huyết nhẫn	
	'skill_clone038_wdgr_01',
	'skill_clone038_lg_06',
	'skill_clone038_lg_04',
	'skill_clone038_lg_05',
	'skill_clone038_lxk_01',
	'skill_clone038_lxk_02',
	'skill_clone038_wdgr_02',
	'skill_clone038_lg_02',
	'skill_clone038_tcdr_02',
	'skill_clone038_wdgr_03',
	'skill_clone038_wdgr_08',
	'skill_clone038_wdgr_04',
	'skill_clone038_lg_03',
	'skill_clone038_lxk_04',
	'skill_clone038_lxk_03',	
	'skill_clone038_wdgr_05',
	'skill_clone038_tcdr_04',	
	'skill_clone038_hme_03', -- mặc vẫn
	'skill_clone038_tcdr_01',	
	'skill_clone038_tcdr_03',
	'skill_clone038_lg_01',

}

skill_jump_behind = {
	'skill_clone038_hme_02', -- hư trảm
	'skill_clone038_hme_01', -- huyết nhẫn		
	'skill_clone038_lg_06',	
	'skill_clone038_tcdr_02',	
	'skill_clone038_lxk_02',
	'skill_clone038_wdgr_02',
	'skill_clone038_lg_02',	
	'skill_clone038_wdgr_03',
	'skill_clone038_wdgr_08',
	'skill_clone038_lxk_01',	
}

skill_def = {		
	'skill_clone038_lg_03',		
	'skill_clone038_lxk_06',
}
skill_jump_after = {	
	'skill_clone038_wdgr_01',
	'skill_clone038_wdgr_04'
	
}
skill_jump_high = {
	'skill_clone038_lxk_04',		
	'skill_clone038_lg_04',	
	'skill_clone038_wdgr_05',	
	'skill_clone038_tcdr_04',
	'skill_clone038_hme_03', -- mặc vẫn
	'skill_clone038_tcdr_01',
	'skill_clone038_lxk_03',	
	'skill_clone038_tcdr_03',
	'skill_clone038_lg_01',
}
function get_check_skill()
	return checkSkill
end
function get_skill_jump_behind()
	return skill_jump_behind
end
function get_skill_def()
	return skill_def
end
function get_skill_jump_after()
	return skill_jump_after
end
function get_skill_jump_high()
	return skill_jump_high
end
function init_ui_content(form)	
	local gui = nx_value("gui")	
	form.combobox_itemname.config = ""
	form.AbsLeft = (gui.Desktop.Width - form.Width) / 2
	form.AbsTop = (gui.Desktop.Height - form.Height) / 2
	form.btn_start_add.Enabled = false
	loadItemList(form)	
	updateBtnAuto(form)
	updateCheckedAuto(form)
	updateBtnAutoPause(form)
end
function btn_pause_auto(btn)
	local form = btn.ParentForm
	if nx_execute(nx_current(),'getStagePausePlay') then
		nx_execute(nx_current(),'setStagePausePlay',false) 
	else
		nx_execute(nx_current(),'setStagePausePlay',true) 
	end
	updateBtnAutoPause(form)
end
updateBtnAutoPause = function(form)
	if not nx_execute(nx_current(),'getStagePausePlay') then
		form.btn_pause_auto.Text = nx_widestr('Continue')
	else
		form.btn_pause_auto.Text = nx_widestr('Pause')
	end
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
function btn_start_tdc(btn)
	local form = btn.ParentForm
	if nx_running(nx_current(),'auto_daimat') then
		nx_execute(nx_current(),'setAutoDMState',false)
		nx_kill(nx_current(),'auto_daimat')
	else		
		nx_execute(nx_current(),'setAutoDMState',true)
		nx_execute(nx_current(),'setStagePausePlay',true)
		nx_execute(nx_current(),'auto_daimat')
	end
	updateBtnAutoPause(form)
	updateBtnAuto(form)
end
function on_right_grid(self)
  local form = self.ParentForm
  if not nx_find_custom(self,'UniqueID') then nx_set_custom(self,'UniqueID','1') end
  local gui = nx_value('gui')
  local game_hand = gui.GameHand
  local para1 = game_hand.Para1
  local para2 = game_hand.Para2
  local ini = nx_create('IniDocument')
  if not nx_is_valid(ini) then
	return 
  end 
  local no_item = game_hand:IsEmpty() or game_hand.Type ~= "viewitem" or (para1 ~= "121" and para1 ~= "2" and para1 ~= "123" and para1 ~= "125")	
	if no_item then return nil end	
    local item = nx_execute('goods_grid', 'get_view_item', game_hand.Para1, game_hand.Para2)
	if nx_is_valid(item) then 
		local item_config = item:QueryProp('ConfigID')
		add_item_cbx_auto(form,item_config)			
	end 
	loadItemList(form)	
	game_hand:ClearHand()
end
function add_item_cbx_auto(form,item_config_id)
	local ItemQuery = nx_value('ItemQuery')
	local gui = nx_value('gui')
	if not nx_is_valid(ItemQuery) or not nx_is_valid(gui) then
		return
	end		
	
	if item_config_id == nil or nx_string(item_config_id) == '' then
		return
	end		
	local item_name = nx_function('ext_widestr_to_utf8', util_text(item_config_id))
	if is_list_add('auto_dmqt.ini', item_name) then
		showUtf8Text(AUTO_LOG_ITEM.."<font color=\"#ffff73\">" .. item_name .. "</font>"..AUTO_LOG_ITEM_INV,3)
	else
		table.insert(list_pickup, item_name)
		form.cbx_input_item_skip_auto.DropListBox:ClearString()
		form.itemString = ''
		for k = 1, table.getn(list_pickup) do
			if list_pickup[k] ~= '' then
				form.itemString = form.itemString .. list_pickup[k] .. ','
				form.cbx_input_item_skip_auto.DropListBox:AddString(list_pickup[k])
			end
		end		
		local file = add_file_dm('auto_dmqt.ini')
		if not nx_function('ext_is_file_exist', file) then 
			create_config()
		end
		local ini = nx_create('IniDocument')
		ini.FileName = file
		if ini:LoadFromFile() then
		ini:WriteString(nx_string('Setting_DM'), 'listnhat', nx_string(form.itemString))
		ini:SaveToFile()
		 showUtf8Text(AUTO_LOG_ITEM.."<font color=\"#ffff26\">" .. item_name .. "</font>"..AUTO_LOG_ADD_SUCCESS,3)
		end
	end	
end
updateCheckedAuto = function(form)
	local songthich = getIni_Nc6('auto_dmqt.ini','String','Setting_DM','songthich', '')
	local isDicot = getIni_Nc6('auto_dmqt.ini','String','Setting_DM','ntlt', '')
	local casot = getIni_Nc6('auto_dmqt.ini','String','Setting_DM','casot', '')
	local lagbdh = getIni_Nc6('auto_dmqt.ini','String','Setting_DM','lagbdh', '')
	local isUseKN =  getIni_Nc6('auto_dmqt.ini','String','Setting_DM','linhnguyen', '')
	local isUseLN = getIni_Nc6('auto_dmqt.ini','String','Setting_DM','kimnguyen', '')
	local lam = getIni_Nc6('auto_dmqt.ini','String','Setting_DM','lam', '')
	if nx_string(songthich) == 'true' then
		form.check_box_7.Checked = true
	end
	if nx_string(isDicot) == 'true' then
		form.check_box_1.Checked = true
	end
	if nx_string(casot) == 'true' then
		form.check_box_2.Checked = true
	end
	if nx_string(lagbdh) == 'true' then
		form.check_box_3.Checked = true
	end
	if nx_string(isUseKN) == 'true' then
		form.check_box_4.Checked = true
	end
	if nx_string(isUseLN) == 'true' then
		form.check_box_5.Checked = true
	end
	if nx_string(lam) == 'true' then
		form.check_box_6.Checked = true
	end
end



updateBtnAuto = function(form)
	if nx_running(nx_current(),'auto_daimat') then
		form.btn_start_tdc.Text = nx_widestr('Stop')
	else
		form.btn_start_tdc.Text = nx_widestr('Start')
	end
end
function on_cbtn_auto_box_7(cbtn)	
	if cbtn.Checked then
		SaveSetting_nc6("auto_dmqt.ini","Setting_DM","String","songthich","true")		
	else
		SaveSetting_nc6("auto_dmqt.ini","Setting_DM","String","songthich","false")
	end
end
function on_cbtn_auto_box_1(cbtn)	
	if cbtn.Checked then
		SaveSetting_nc6("auto_dmqt.ini","Setting_DM","String","ntlt","true")		
	else
		SaveSetting_nc6("auto_dmqt.ini","Setting_DM","String","ntlt","false")
	end
end
function on_cbtn_auto_box_2(cbtn)	
	if cbtn.Checked then
		SaveSetting_nc6("auto_dmqt.ini","Setting_DM","String","casot","true")		
	else
		SaveSetting_nc6("auto_dmqt.ini","Setting_DM","String","casot","false")
	end
end
function on_cbtn_auto_box_3(cbtn)	
	if cbtn.Checked then
		SaveSetting_nc6("auto_dmqt.ini","Setting_DM","String","lagbdh","true")		
	else
		SaveSetting_nc6("auto_dmqt.ini","Setting_DM","String","lagbdh","false")
	end
end
function on_cbtn_auto_box_4(cbtn)	
	if cbtn.Checked then
		SaveSetting_nc6("auto_dmqt.ini","Setting_DM","String","linhnguyen","true")		
	else
		SaveSetting_nc6("auto_dmqt.ini","Setting_DM","String","linhnguyen","false")
	end
end
function on_cbtn_auto_box_5(cbtn)	
	if cbtn.Checked then
		SaveSetting_nc6("auto_dmqt.ini","Setting_DM","String","kimnguyen","true")		
	else
		SaveSetting_nc6("auto_dmqt.ini","Setting_DM","String","kimnguyen","false")
	end
end
function on_cbtn_auto_box_6(cbtn)	
	if cbtn.Checked then
		SaveSetting_nc6("auto_dmqt.ini","Setting_DM","String","lam","true")		
	else
		SaveSetting_nc6("auto_dmqt.ini","Setting_DM","String","lam","false")
	end
end
function add_file_dm(inifile)
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
	ini.FileName = dir .. "\\"..nx_string(inifile)
	return ini.FileName
end
function is_list_add(inifile, content)
	local form = nx_value(THIS_FORM)
	for k = 1, table.getn(list_pickup) do
		if list_pickup[k] ~= "" and list_pickup[k] == content then		
			return true		
		end
	end	
	return false
end
function is_list_del(inifile, content)
	local form = nx_value(THIS_FORM)
	for k = 1, table.getn(list_pickup) do
		if list_pickup[k] ~= "" and list_pickup[k] == content then
			table.remove(list_pickup, k)				
			form.cbx_input_item_skip_auto.Text = ""
			form.itemString = ""			
			for k = 1, table.getn(list_pickup) do
					if list_pickup[k] ~= "" then
						form.itemString = form.itemString .. list_pickup[k] .. ","						
					end
				end
			local file = add_file_dm(inifile)
			if not nx_function("ext_is_file_exist", file) then 
				create_config()
			end			
			local ini = nx_create("IniDocument")
			ini.FileName = file
			if ini:LoadFromFile() then
				ini:WriteString(nx_string("Setting_DM"), "listnhat", nx_string(form.itemString))				
				ini:SaveToFile()
			end
			return true		
		end
	end	
	return false
end

function btn_start_del(btn)
	local form = btn.ParentForm	
	local file1 = add_file_dm('auto_dmqt.ini')
	if not nx_function("ext_is_file_exist", file1) then	
		local file_save = nx_create("StringList")
		file_save:SaveToFile(file1)
	end
	 if string.len(nx_string(form.cbx_input_item_skip_auto.Text)) > 0 and form.cbx_input_item_skip_auto.Text ~= "" and form.cbx_input_item_skip_auto.Text ~= nil then
        local x = nx_function("ext_widestr_to_utf8",  form.cbx_input_item_skip_auto.Text)
        if is_list_del('auto_dmqt.ini', x) then  
            showUtf8Text(AUTO_LOG_DELETE_ITEM.."<font color=\"#ffff4c\">" .. x .. "</font> "..AUTO_LOG_DELETE_ITEM1,3)
        else
            showUtf8Text(AUTO_LOG_ITEM.."<font color=\"#ffff4c\">" .. x .. "</font>"..AUTO_LOG_NOT_LIST,3)
        end
    else
        showUtf8Text(AUTO_LOG_SELECT_ITEM_DEL,3)
    end
	loadItemList(form)
end
function on_combobox_itemname_selected(self)
	local form = self.ParentForm
	if not nx_is_valid(form) then
		return
	end
	nx_pause(0)
	form.edt_item_add.Text = form.combobox_itemname.Text
	form.combobox_itemname.Text = nx_widestr("")
	local index = form.combobox_itemname.DropListBox.SelectIndex	
	if index < table.getn(market_item_table) then
		form.combobox_itemname.config = market_item_table[index + 1]
		form.btn_start_add.Enabled = true
	end
end

function on_ipt_search_key_changed(self)
	local form = self.ParentForm
	if not nx_is_valid(form) then
		return
	end
	if nx_ws_length(self.Text) < 3 then
		form.combobox_itemname.DropListBox:ClearString()
		return
	end	
	if nx_ws_equal(self.Text, util_text("ui_trade_search_key")) then
		return
	end
	local gui = nx_value("gui")
	if not nx_is_valid(gui) then
		return
	end
	local ItemQuery = nx_value("ItemQuery")
	if not nx_is_valid(ItemQuery) then
		return
	end
	
	form.combobox_itemname.DropListBox:ClearString()
	local search_table = ItemQuery:FindItemsByName(self.Text)
	market_item_table = {}
	for _, item_config in pairs(search_table) do
		local bExist = ItemQuery:FindItemByConfigID(item_config)
		if bExist then
			if gui.TextManager:IsIDName(item_config) then
				form.combobox_itemname.DropListBox:AddString(util_text(item_config))
				table.insert(market_item_table, item_config)
			end
		end
	end
	if not form.combobox_itemname.DroppedDown then
		form.combobox_itemname.DroppedDown = true
	end
end
function btn_start_add(btn)
	local form = btn.ParentForm
	if nx_is_valid(form) then
		local ItemQuery = nx_value("ItemQuery")
		local gui = nx_value("gui")
		if not nx_is_valid(ItemQuery) or not nx_is_valid(gui) then
			return
		end
		
		local form = btn.ParentForm
		local item_config_id = form.combobox_itemname.config
		if item_config_id == nil or nx_string(item_config_id) == "" then
			return
		end		
		local item_name = nx_function("ext_widestr_to_utf8", util_text(item_config_id))
		if is_list_add('auto_daimat.ini', item_name) then
            showUtf8Text(AUTO_LOG_ITEM.."<font color=\"#ffff73\">" .. item_name .. "</font>"..AUTO_LOG_ITEM_INV,3)
		else
			form.edt_item_add.Text = ""
			form.btn_start_add.Enabled = false
			form.combobox_itemname.DroppedDown = false
			table.insert(list_pickup, item_name)
			form.cbx_input_item_skip_auto.DropListBox:ClearString()
			form.itemString = ""
			for k = 1, table.getn(list_pickup) do
				if list_pickup[k] ~= "" then
					form.itemString = form.itemString .. list_pickup[k] .. ","
					form.cbx_input_item_skip_auto.DropListBox:AddString(list_pickup[k])
				end
			end		
			local file = add_file_dm('auto_dmqt.ini')
			if not nx_function("ext_is_file_exist", file) then 
				create_config()
			end
			local ini = nx_create("IniDocument")
			ini.FileName = file
			if ini:LoadFromFile() then
				ini:WriteString(nx_string("Setting_DM"), "listnhat", nx_string(form.itemString))
				ini:SaveToFile()
			 showUtf8Text(AUTO_LOG_ITEM.."<font color=\"#ffff26\">" .. item_name .. "</font>"..AUTO_LOG_ADD_SUCCESS,3)	
			end
		end			
	end
	loadItemList(form)
end
function create_config()
	local game_config = nx_value("game_config")
	local account = game_config.login_account
	local file = add_file_dm('auto_dmqt.ini')
	if not nx_function("ext_is_file_exist", file) then
		local stringList = nx_create("StringList")
		stringList:AddString("[Setting_DM]")	
		stringList:AddString('listnhat=Hoang Thú Thạch,Ma Môn Lệnh,Long Văn Cẩm Hạp,Mặc Tử Bi Ti [Gian],Mặc Tử Bi Ti [Vĩ],Dương Xuân [Gian],Giai Binh Song Phủ Ký,Tinh Kim Song Phủ Thiên,Giai Binh Trường Thương  Ký,Tinh Kim Trường Thương Biên,Giai Binh Thánh Hỏa Lệnh Ký,Tinh Kim Thánh Hỏa Lệnh Thiên,Xích Thược,Giả Bồng,[Hoang Thú Thạch] Cẩm Hạp (1),[Hoang Thú Thạch] Cẩm Hạp (2),[Hoang Thú Thạch] Cẩm Hạp (3),[Hoang Thú Thạch] Cẩm Hạp (4),[Hoang Thú Thạch] Cẩm Hạp (5),[Hoang Thú Thạch] Cẩm Hạp (6),[Hoang Thú Thạch] Cẩm Hạp (7),[Hoang Thú Thạch] Cẩm Hạp (8),[Hoang Thú Thạch] Cẩm Hạp (9),[Hoang Thú Thạch] Cẩm Hạp (10),[Ma Môn Lệnh] Cẩm Hạp (1),[Ma Môn Lệnh] Cẩm Hạp (2),[Ma Môn Lệnh] Cẩm Hạp (3),[Ma Môn Lệnh] Cẩm Hạp (4),[Ma Môn Lệnh] Cẩm Hạp (5),[Ma Môn Lệnh] Cẩm Hạp (6),[Ma Môn Lệnh] Cẩm Hạp (7),[Ma Môn Lệnh] Cẩm Hạp (8),[Ma Môn Lệnh] Cẩm Hạp (9),[Ma Môn Lệnh] Cẩm Hạp (10),box_xmp_fc_01,')
		stringList:SaveToFile(file)
	end
end
function isPickList(ini_name, key)
  local file = add_file(ini_name)
  local ini = nx_create('IniDocument')
  ini.FileName = file
	if ini:LoadFromFile() then
		local data = ini:ReadString(nx_string(key), 'listnhat', '')
		local list_pickup = auto_split_string(data, ',')
		if table.getn(list_pickup) > 0 then
			return list_pickup
		end
	end
  return nil
end
-- function isPickList(ini_name, content) 
  	-- local file = add_file(ini_name)	
	-- local ini = nx_create("IniDocument")
	-- ini.FileName = file
	-- if ini:LoadFromFile() then		
		-- local data = ini:ReadString(nx_string("Setting_DM"), "listnhat", "")
		-- local list_pickup = util_split_string(data, ",")		
		-- for k = 1, table.getn(list_pickup) do
			-- if list_pickup[k] ~= "" and list_pickup[k] == content then
			  -- return true
			-- end	 
		-- end
	-- end
	-- return false
-- end

function loadItemList(form)
	form.cbx_input_item_skip_auto.DropListBox:ClearString()
	local file = add_file_dm('auto_dmqt.ini')	
	if not nx_function("ext_is_file_exist", file) then 
		create_config()
	end
	local ini = nx_create("IniDocument")
	ini.FileName = file
	if ini:LoadFromFile() then		
		form.itemString = ini:ReadString(nx_string("Setting_DM"), "listnhat", "")
		list_pickup = util_split_string(form.itemString, ",")		
		for k = 1, table.getn(list_pickup) do
			if list_pickup[k] ~= "" then
				 form.cbx_input_item_skip_auto.DropListBox:AddString(utf8ToWstr(list_pickup[k]))
			end
		end
	end
end
