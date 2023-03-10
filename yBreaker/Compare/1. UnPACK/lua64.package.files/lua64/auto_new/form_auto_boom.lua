require("util_gui")
require("define\\gamehand_type")
require("const_define")
require("auto_new\\autocack")
if not load_spec_war then
	auto_cack('0')
	auto_cack('2')
	auto_cack('6')
	auto_cack('14')
	load_spec_war = true
end
local THIS_FORM = "auto_new\\form_auto_boom"
function main_form_init(form)
  form.Fixed = false
end
function on_main_form_open(form)
  init_ui_content(form)
end
FORM_MAIN_REQUEST = "form_stage_main\\form_main\\form_main_request"
function btn_start_skill(btn)
  local form = btn.ParentForm
	if nx_running(nx_current(),'Startskill') then
		set_skill_boom(false)
		nx_kill(nx_current(),'Startskill')
		form.btn_start_skill.Text = nx_widestr('Start')
	else
		get_name_players()		
		set_skill_boom(true)
		form.btn_start_skill.Text = nx_widestr('Stop')
		nx_execute(nx_current(),'Startskill')
  end
  update_btn_start_skill()
end
function update_btn_start_skill()
	local form = util_get_form(THIS_FORM, true, false) 
	if nx_running(nx_current(),'Startskill') then
		form.btn_start_skill.Text = nx_widestr('Stop')
	else
		form.btn_start_skill.Text = nx_widestr('Start')
	end
end
function init_ui_content(form)
	local game_client = nx_value('game_client')
	local client_player = game_client:GetPlayer()
	local wuxue_query = nx_value('WuXueQuery')
	local type_tab = wuxue_query:GetMainNames(4)
	for i = 1, table.getn(type_tab) do
		local type_name = type_tab[i]
		local sub_type_tab = wuxue_query:GetSubNames(4, type_name)
		for j = 1, table.getn(sub_type_tab) do
			local sub_type_name = sub_type_tab[j] 
			local sub_type = wuxue_query:GetLearnID_ZhenFa(sub_type_name)
			if nx_is_valid(sub_type) then 	
				form.cbx_zhenfa_use.DropListBox:AddString(util_text(sub_type_name))
			end
		end
	end	
	update_btn_start_skill() 
end
function get_name_players()
	local form = nx_value(THIS_FORM)
	local player = getPlayersName()
    form.edt_name_player.Text = nx_widestr(player)
	if form.check_zhenfa.Checked == true then
		 form.edt_name_player2.Text = nx_widestr(player)
	end
end
function getPlayersName()
    local game_client = nx_value('game_client')
    if not nx_is_valid(game_client) then
      return false
    end
    local game_scence = game_client:GetScene()
    if not nx_is_valid(game_scence) then
      return false
    end
    local player_name
    local game_scence_objs = game_scence:GetSceneObjList()
    local selectobj = nx_value(GAME_SELECT_OBJECT)
    if nx_is_valid(selectobj) then
      player_name = selectobj:QueryProp('Name')
      return player_name
    end
    return nil
end
local max_find_distance = 25
local dn_obj = nil
function targetPlayer(name)
	local game_client = nx_value('game_client')
	local game_visual = nx_value('game_visual')
	local scene = game_client:GetScene()
	local scene_obj_table = scene:GetSceneObjList()
	local r = 1000
	local obj = nil
	local client_player = game_client:GetPlayer()
	local visual_player = game_visual:GetPlayer()
	local move = false
	local mapid = getCurrentScene_id()
	-- local form = util_get_form('auto_boom', true, false)
	local is_path_finding = nx_value('path_finding')
	for i = 1, table.getn(scene_obj_table) do
		local scene_obj = scene_obj_table[i]
		if nx_is_valid(scene_obj) then
			if scene_obj:QueryProp('Type') == 2 and not nx_id_equal(client_player, scene_obj)  and  not scene_obj:FindProp('Dead') and scene_obj:QueryProp('Name') == name and getDistance(scene_obj) <= max_find_distance then
				local tmp_r = getDistance(scene_obj)
					if tmp_r < r then
					r = tmp_r				
					obj = scene_obj
				end
			end
		end
	end
	if obj ~= nil and nx_is_valid(nx_value('game_visual')) and nx_is_valid(obj) then
		dn_obj = obj
		nx_execute('custom_sender', 'custom_select', dn_obj.Ident)
		nx_pause(0.5)
		nx_execute('custom_sender', 'custom_select', dn_obj.Ident)
		return true
	end
	return false
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
auto_hs_boom = false 
auto_zhenfa_boom = false
auto_check_boom = false
x,y,z = 0,0,0
name_target = ''
name_zhenfa_tg = ''
name_zhenfa = ''
auto_skill_boom = false
get_skill_boom = function()
	return auto_skill_boom
end
set_skill_boom = function(value)
	auto_skill_boom = value
end
function Startskill()
	local form = nx_value('auto_new\\form_auto_boom')
	auto_hs_boom = form.check_hs.Checked 
	auto_zhenfa_boom = form.check_zhenfa.Checked
	auto_check_boom = form.check_boom.Checked
	x,y,z = 0,0,0
	loading_time = 0
	name_target = form.edt_name_player.Text
	name_zhenfa_tg = form.edt_name_player2.Text
	name_zhenfa = form.cbx_zhenfa_use.Text
	while get_skill_boom() do
		nx_pause(1)
		local stage = nx_value('stage')
		local loading_flag = nx_value('loading')
		local sock = nx_value('game_sock')
		if loading_flag or not sock.Connected then
			loading_time = os.time()
		end            
		if tools_difftime(loading_time) > 6 and stage == 'main' then
			auto_boom_use()			
		end
	end
end
function auto_boom_use()
	local game_client = nx_value('game_client')
    local game_visual = nx_value('game_visual')
	local client_player = game_client:GetPlayer()
	local visual_player = game_visual:GetPlayer()	
	local logicstate = client_player:QueryProp('LogicState')	
	local mpRatio = client_player:QueryProp('MPRatio')
	local hpRatio = client_player:QueryProp('HPRatio')
	local cur_scene_id = getCurrentScene_id()
	local player = getPlayer()
	if not nx_is_valid(client_player) then return end
	if not nx_is_valid(visual_player) then return end
	if not nx_is_valid(player) then return end
	if nx_string(auto_hs_boom) == nx_string('true') then
		if client_player:FindProp('Dead') then
			if client_player:QueryProp('Dead') == 1 then
				nx_execute('custom_sender', 'custom_relive', 2, 0)				
			end	
		end	
	end
	if logicstate == 121 or logicstate == 120 then
		x, y, z = visual_player.PositionX, visual_player.PositionY, visual_player.PositionZ
		return 
	end	
	if x == 0 or z == 0 then
		x, y, z = visual_player.PositionX, visual_player.PositionY, visual_player.PositionZ
	end	
	if nx_number(getDistanceFromPosXZ(x,y,z)) > nx_number(50) then
		if nx_int(mpRatio) < nx_int(90) and logicstate ~= 1 then 
			if regenHpMp() then
				nx_pause(0.1)
			end			
		else
			autoMove(cur_scene_id,x,y,z,15)
		end		
		return
	end	
	if not is_skill_on_cooling('cs_tm_fgzyc05') and nx_int(mpRatio) > nx_int(10) then
		stop_sitcross()
	end
	if nx_int(mpRatio) < nx_int(90) and logicstate ~= 1 then 
		if is_skill_on_cooling('cs_tm_fgzyc05') then
			if regenHpMp() then
				nx_pause(0.1)
			end
			return
		end
	end		
	if nx_string(auto_zhenfa_boom) == nx_string('true') then
		fight_zhenfa()
	end
	if nx_string(auto_check_boom) == nx_string('true')  then		
		fight_skill()				
	else	
		local obj = get_pos_player_dis(name_target)
		if not nx_is_valid(obj) or not obj then return end
		local x1,y1,z1 = obj.DestX, obj.DestY, obj.DestZ
		if nx_number(getDistance(obj)) < nx_number(15) then
			fight_skill(obj)
			auto_stop_path_finding()
		else
			autoMove(cur_scene_id,x1,y1,z1,10)
		end		
	end	
end
function fight_zhenfa()
	local player = nx_value('game_client'):GetPlayer()	
	if player:QueryProp('ZhenFaEffect') ~= 'battleform_effect_1c' then						
		local nameplayer = targetPlayer(name_zhenfa_tg)	
		local obj = get_pos_player_dis(name_zhenfa_tg)
		if not nx_is_valid(obj) or not obj then return end
		local x1,y1,z1 = obj.DestX, obj.DestY, obj.DestZ
		if nx_number(getDistance(obj)) < nx_number(15) then
			auto_stop_moving()
			if name_zhenfa == utf8ToWstr('Địa Diệt Trận') then
				zhenfa = 'zhenfa_jiebai_01'
			elseif name_zhenfa == utf8ToWstr('Trích Tinh Trận') then
				zhenfa = 'zhenfa_jiebai_02'
			elseif name_zhenfa == utf8ToWstr('Tam Tuyệt Trận') then
				zhenfa = 'zhenfa_jiebai_03'				
			elseif name_zhenfa == utf8ToWstr('Đao Võng Trận') then
				zhenfa = 'zhenfa_jiebai_04'				
			elseif name_zhenfa == utf8ToWstr('Sưu Sát Trận') then
				zhenfa = 'zhenfa_jiebai_05'				
			elseif name_zhenfa == utf8ToWstr('Huyền Thủy Trận') then
				zhenfa = 'zhenfa_jiebai_07'				
			else
				showUtf8Text('Auto chỉ hổ trợ trận kim lan', 3)					
			end					
			nx_execute('custom_sender','custom_use_zhenfa',zhenfa)
			nx_pause(4)
			nx_execute('custom_sender','custom_select_cancel')				
		else
			local cur_scene_id = getCurrentScene_id()
			autoMove(cur_scene_id,x1,y1,z1,10)
		end		
		
	end
end
function fight_skill(obj)	
	if not obj then 
		obj = nx_value('game_client'):GetPlayer()
	end	
	if not nx_function('find_buffer', obj, 'buf_CS_tm_fgzyc05a_range') then
		nx_value('gui').GameHand:SetHand('groundpick', 'Default', 'map\\tex\\Target_area_G.dds', '' .. 4, 'xxx', nx_string(10))
		nx_execute('game_effect', 'hide_ground_pick_decal')
		local visual_target = nx_value('game_visual'):GetSceneObj(obj.Ident)
		nx_execute('game_effect', 'locate_ground_pick_decal', visual_target.PositionX + math.random() + math.random(-2, 2), visual_target.PositionY, visual_target.PositionZ + math.random() + math.random(-2, 2), 30)
		nx_value('fight'):TraceUseSkill('cs_tm_fgzyc05', true, false)
	end
end



