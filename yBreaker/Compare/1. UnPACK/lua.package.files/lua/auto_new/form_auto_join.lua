require('util_gui')
require("util_move")
require('define\\gamehand_type')
require('const_define')
require('auto_new\\autocack')

local THIS_FORM = 'auto_new\\form_auto_join'
function main_form_init(form)
  form.Fixed = false
  form.pick_str = ""
  form.string_list = nx_create("StringList")
end

function on_main_form_open(form)
  init_ui_content(form)
end
function init_ui_content(form)
	local load_School = {
	  "Cẩm Y Vệ",
	  "Cái Bang",
	  "Quân Tử Đường",
	  "Cực Lạc Cốc",
	  "Đường Môn",
	  "Nga Mi",
	  "Võ Đang",
	  "Thiếu Lâm",
	  --"Minh Giáo"
	}	
	local comboboxSchool = form.cbx_load_school	
	if comboboxSchool.DroppedDown then
		comboboxSchool.DroppedDown = false
	end
	for i = 1, table.getn(load_School)do
  		form.cbx_load_school.DropListBox:AddString(utf8ToWstr(load_School[i]))
	end  
  comboboxSchool.Text = utf8ToWstr(load_School[1])  
  updateBtnAuto(form)
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
	if auto_tdc then
		auto_tdc = false
		nx_kill(nx_current(),'autoStartSchool')
	else
		auto_tdc = true
		nx_execute(nx_current(),'autoStartSchool')
	end
	updateBtnAuto(form)
end

updateBtnAuto = function(form)
	if auto_tdc then
		form.btn_start_tdc.Text = nx_widestr('Stop')
	else
		form.btn_start_tdc.Text = nx_widestr('Start')
	end
end
FORM_LOADING = 'form_common\\\\form_loading'
FORM_GOTO_COVER = 'form_stage_main\\\\form_goto_cover'
function WaitLoading()
	local count = 0
	local max_time = 30
	while count < max_time and (not nx_is_valid(nx_value(FORM_LOADING)) and not nx_is_valid(nx_value(FORM_GOTO_COVER)))
	do
		nx_pause(0.5)
		count = count + 1
	end
	if count >= max_time then
		return false
	end
	while nx_is_valid(nx_value(FORM_LOADING)) or nx_is_valid(nx_value(FORM_GOTO_COVER)) or not nx_is_valid(nx_value('game_visual'):GetPlayer())
	do
		nx_pause(1)
	end
	nx_pause(3)
	return true
end
function autoStartSchool()
	--if getAutoByNockasdd_CackFree() then
		local form = nx_value(THIS_FORM)
		local name, mapschool, id_npc_invite, id_school_master, school_id, job_npc,job_id,questFirstID,questID,mapsdienvo,npclearn,faculty,faculty_6,npc_buy_6,shop_buy_nc6,homepoint = nx_execute(nx_current(),"autoLoadSchool",form.cbx_load_school.Text)
		startFirst = false
		startJoin = false
		while auto_tdc do	
			nx_pause(1)
			local game_client = nx_value("game_client")
			local player = game_client:GetPlayer()
			local client_player = game_client:GetPlayer()
			local map_query = nx_value('MapQuery')
			if map_query:GetCurrentScene() ~= mapschool and client_player:FindProp("School") == false and map_query:GetCurrentScene() == 'city05' then
				startFirst = true				
				if map_query:GetCurrentScene() == mapschool  then					
					startFirst = false
				end
				questFirstAccount(job_npc,name,job_id)
				WaitLoading()
			elseif map_query:GetCurrentScene() == mapschool then		
				startJoin = true					
				joinSchool(mapschool,name,id_npc_invite,id_school_master,school_id,questFirstID,questID,mapsdienvo,npclearn,faculty,faculty_6,npc_buy_6,shop_buy_nc6,homepoint)
				local game_client = nx_value('game_client')
				local client_player = game_client:GetPlayer()
				if client_player:FindProp("School") then
					nx_pause(2)
					startJoin = false
					auto_tdc = false
					updateBtnAuto(form)
				end
			end
		end
	--end
end

function autoLoadSchool(mapName)
		if mapName == utf8ToWstr("Cẩm Y Vệ") then				
				name = "cyv"
				maps = "school01"
				id_npc_invite = "FuncNpc01505"
				id_school_master = "worldnpc04101"
				school_id = "school_jinyiwei"
				job_npc = ""
				job_id = ""
				questFirstID = "title_58"
				questID = "58"
				mapsdienvo = 'groupscene017'
				npclearn = 'Npc_yd_wg_jx_jy01'
				faculty = 'ng_jy_001'
				faculty_6 = 'ng_jy_006'
				npc_buy_nc6 = 'npc_6nei_jy_shop01'
				shop_buy_nc6 = 'shop_6nei_jy_01'
				homepoint = 'HomePointschool01A'
			elseif mapName == utf8ToWstr("Cái Bang") then
				name = "cb"
				maps = "school02"
				id_npc_invite = "FuncNpc01203"
				id_school_master = "WorldNpc03003"
				school_id = "school_gaibang"
				job_npc = "JobChengD017"
				job_id = "sh_qg"
				questFirstID = "title_54"
				questID = "54"	
				mapsdienvo = 'groupscene014'
				npclearn = 'Npc_yd_wg_jx_gb01'
				faculty = 'ng_gb_001'
				faculty_6 = 'ng_gb_006'
				npc_buy_nc6 = 'npc_6nei_gb_shop01'
				shop_buy_nc6 = 'shop_6nei_gb_01'
				homepoint = 'HomePointschool02B'
			elseif mapName == utf8ToWstr("Quân Tử Đường") then
				name = "qtd"
				maps = "school03"
				id_npc_invite = "FuncNpc01307"
				id_school_master = "WorldNpc03305"
				school_id = "school_junzitang"
				job_npc = "JobChengD012"
				job_id = "sh_qs"
				questFirstID = "title_55"
				questID = "55"
				mapsdienvo = 'groupscene016'
				npclearn = 'Npc_yd_wg_jx_jz01'
				faculty = 'ng_jz_001'
				faculty_6 = 'ng_jz_006'
				npc_buy_nc6 = 'npc_6nei_jz_shop01'
				shop_buy_nc6 = 'shop_6nei_jz_01'
				homepoint = 'HomePointschool03A'
			elseif mapName == utf8ToWstr("Cực Lạc Cốc") then
				name = "clc"
				maps = "school04"
				id_npc_invite = "FuncNpc01404"
				id_school_master = "WorldNpc03816"
				school_id = "school_jilegu"
				job_npc = ""
				job_id = ""
				questFirstID = "title_57"
				questID = "57"
				mapsdienvo = 'groupscene018'
				npclearn = 'Npc_yd_wg_jx_jl01'
				faculty = 'ng_jl_001'
				faculty_6 = 'ng_jl_006'
				npc_buy_nc6 = 'npc_6nei_jl_shop01'
				shop_buy_nc6 = 'shop_6nei_jl_01'
				homepoint = 'HomePointschool04A'
			elseif mapName == utf8ToWstr("Đường Môn") then
				name = "dm"
				maps = "school05"
				id_npc_invite = "FuncNpc01020"
				id_school_master = "WorldNpc02201"
				school_id = "school_tangmen"
				job_npc = ""
				job_id = ""				
				questFirstID = "title_56"	
				questID = "56"
				mapsdienvo = 'groupscene015'
				npclearn = 'Npc_yd_wg_jx_tm01'
				faculty = 'ng_tm_001'
				faculty_6 = 'ng_tm_006'
				npc_buy_nc6 = 'npc_6nei_tm_shop01'
				shop_buy_nc6 = 'shop_6nei_tm_01'
				homepoint = 'HomePointschool05A'
			elseif mapName == utf8ToWstr("Nga Mi") then
				name = "nm"
				maps = "school06"
				id_npc_invite = "FuncNpc01114"
				id_school_master = "WorldNpc02604"
				school_id = "school_emei"
				job_npc = ""
				job_id = ""
				questFirstID = "title_53"
				questID = "53"
				mapsdienvo = 'groupscene013'
				npclearn = 'Npc_yd_wg_jx_em01'
				faculty = 'ng_em_001'
				faculty_6 = 'ng_em_006'
				npc_buy_nc6 = 'npc_6nei_em_shop01'
				shop_buy_nc6 = 'shop_6nei_em_01'
				homepoint = 'HomePointschool06C'
			elseif mapName == utf8ToWstr("Võ Đang") then
				name = "vd"
				maps = "school07"
				id_npc_invite = "FuncNpc01608"
				id_school_master = "WorldNpc04401"
				school_id = "school_wudang"
				job_npc = ""
				job_id = ""
				questFirstID = "title_52"
				questID = "52"
				mapsdienvo = 'groupscene011'
				npclearn = 'Npc_yd_wg_jx_wd01'
				faculty = 'ng_wd_001'
				faculty_6 = 'ng_wd_006'
				npc_buy_nc6 = 'npc_6nei_wd_shop01'
				shop_buy_nc6 = 'shop_6nei_wd_01'
				homepoint = 'HomePointschool07E'
			elseif mapName == utf8ToWstr("Thiếu Lâm") then
				name = "tl"
				maps = "school08"
				id_npc_invite = "FuncNpc00728"
				id_school_master = "WorldNpc00212"
				school_id = "school_shaolin"
				job_npc = ""
				job_id = ""
				questFirstID = "title_51"
				questID = "51"
				mapsdienvo = 'groupscene012'
				npclearn = 'Npc_yd_wg_jx_sl01'
				faculty = 'ng_sl_001'
				faculty_6 = 'ng_sl_006'
				npc_buy_nc6 = 'npc_6nei_sl_shop01'
				shop_buy_nc6 = 'shop_6nei_sl_01'
				homepoint = 'HomePointschool08D'
			elseif mapName == utf8ToWstr("Minh Giáo") then
				name = "mg"
				maps = "school20"
				id_npc_invite = "newmp_mjzyb_001"
				id_school_master = "newmp_mj_001"
				school_id = "school_mingjiao"
				job_npc = ""
				job_id = ""
				questFirstID = "title_72701"
				questID = "72701"
				mapsdienvo = ''
				npclearn = ''
				faculty = ''	
				faculty_6 = ''
				npc_buy_nc6 = ''
				shop_buy_nc6 = ''
				homepoint = 'HomePointschool20A'
		end
    return name, maps, id_npc_invite, id_school_master, school_id, job_npc, job_id,questFirstID,questID,mapsdienvo,npclearn,faculty,faculty_6,npc_buy_nc6,shop_buy_nc6,homepoint
end

function joinSchool(maps,nameSchool,id_npc_invite,id_school_master,school_id,questFirstID,questID,mapsdienvo,npclearn,faculty,faculty_6,npc_buy_6,shop_buy_nc6,homepoint)
	local step = 1
	while startJoin do
		nx_pause(0.1)
		local game_client = nx_value("game_client")
		local player = game_client:GetPlayer()
		local client_player = game_client:GetPlayer()
		
		local mapid = get_current_map()
		nx_execute("form_stage_main\\form_helper\\form_main_helper_manager" , "close_helper_form")
		local loading_flag = nx_value("loading")				
		local curseloading = nx_value("form_stage_main\\form_main\\form_main_curseloading")
		if not loading_flag and not nx_is_valid(form_load) then
			local npc_first = id_npc_invite
			local cm = id_school_master
			local schoolid = school_id
			local npcFirstObj = FindObject(npc_first)
			local npcMaster = FindObject(cm)
			local x,y,z = getPosNpc(maps,cm)
			local x1,y1,z1 = getPosNpc(maps,npc_first)	
			local map_query = nx_value("MapQuery")	
			if get_current_map() == maps or get_current_map() == mapsdienvo then		
				local game_client = nx_value("game_client")
				local player = game_client:GetPlayer()
				local client_player = game_client:GetPlayer()
				if client_player:FindProp('School') then
					return true
				else
					if nameSchool == "clc" then
						if getQuestID("title_47") then
							step = 2
						end	
						if step == 1 then	
							if returnMasterSchoolDis(maps,questFirstID,client_player,x1,y1,z1,npcFirstObj,questID) then
								if npcMaster then				
									if getDistance(npcMaster) > 5 then
										autoMove(maps,x,y,z)
									else
										nx_execute('custom_sender','custom_select', npcMaster.Ident)
										nx_pause(0.2)	
										AutoExecMenu(nil,nil,0)
										nx_pause(0.2)
										AutoExecMenu(nil,nil,0)
										nx_pause(0.2)
										AutoExecMenu(nil,nil,0)	
										nx_pause(0.2)
										AutoExecMenu(nil,nil,0)	
										step = 2
									end
								else									
									if 	get_distance_pos(x,y,z,client_player) > 2 then					
										autoMove(maps,x,y,z)
									end
								end						
							end
						elseif step == 2 then			
							if not getQuestID("title_47") then
								talkNpcQuest(npcMaster,maps,x,y,z,client_player)
							elseif getQuestID("title_47") and get_task_round_state("47") == 1 then
								talkNpcQuest(npcMaster,maps,x,y,z,client_player)	
							elseif getQuestID("title_47") and get_task_round_state("47") == 2 then	
								talkNpcQuest(npcMaster,maps,x,y,z,client_player)
							 elseif getQuestID("title_47") and get_task_round_state("47") == 3 and get_task_complete_state("47") == 0 then				
								local item = nx_execute('tips_data', 'get_item_in_view', nx_int(125), 'useitem_bs003')
								if item ~= nil then
									nx_execute('custom_sender', 'custom_use_item', 125, item.Ident)
									nx_pause(4)	
								end	
							 elseif getQuestID("title_47") and get_task_round_state("47") == 3 and get_task_complete_state("47") == 2 then				
								talkNpcQuest(npcMaster,maps,x,y,z,client_player)
							end
						end				
					elseif nameSchool == "cb" then
						if getQuestID("title_44") then
							step = 2
						end
						if step == 1 then
							if returnMasterSchoolDis(maps,questFirstID,player,x1,y1,z1,npcFirstObj,questID) then
								if npcMaster then
									if getDistance(npcMaster) > 5 then
										autoMove(maps,x,y,z)
									else
										nx_execute('custom_sender','custom_select', npcMaster.Ident)
										nx_pause(0.2)	
										AutoExecMenu(nil,nil,0)
										nx_pause(0.2)
										AutoExecMenu(nil,nil,0)
										nx_pause(0.2)
										AutoExecMenu(nil,nil,0)	
										nx_pause(0.2)
										AutoExecMenu(nil,nil,0)	
										step = 2
									end
								else									
									if 	get_distance_pos(x,y,z,player) > 2 then
										autoMove(maps,x,y,z)
									end
								end						
							end
						elseif step == 2 then
							if not getQuestID("title_44") then
								talkNpcQuest(npcMaster,maps,x,y,z,client_player)
							elseif getQuestID("title_44") and get_task_round_state("44") == 1 then
								talkNpcQuest(npcMaster,maps,x,y,z,client_player)
							elseif getQuestID("title_44") and get_task_round_state("44") == 2 then
								local tamtuu = FindObject("Gather_bs001")
								local game_visual = nx_value("game_visual")								
								local x1,y1,z1 = 636.018,17.835,379.253
								if tamtuu then									
									if getDistance(tamtuu) > 3 then
										autoMove(maps,x1,y1,z1)
									else									
										local item = nx_execute('tips_data', 'get_item_in_view', nx_int(125), 'useitem_bs002')
										if item == nil then
											nx_execute('custom_sender','custom_select', tamtuu.Ident)
											nx_pause(0.5)
											nx_execute('custom_sender','custom_select', tamtuu.Ident)
											nx_pause(7)
										end	
									end
								else
									if 	get_distance_pos(x1,y1,z1,player) > 2 then
										autoMove(maps,x1,y1,z1)
									end
								end
							elseif getQuestID("title_44") and get_task_round_state("44") == 3 then
								if npcMaster then
									if getDistance(npcMaster) > 2 then
										autoMove(maps,x,y,z)
									else
										nx_execute('custom_sender','custom_select', npcMaster.Ident)
										nx_pause(1)	
										AutoExecMenu(nil,nil,0)
										nx_pause(0.2)										
										local item = nx_execute('tips_data', 'get_item_in_view', nx_int(125), 'useitem_bs002')
										if item ~= nil then
											nx_execute('custom_sender', 'custom_use_item', 125, item.Ident)
											nx_pause(4)											
										else
											AutoExecMenu(nil,nil,0)
											nx_pause(0.2)
											AutoExecMenu(nil,nil,0)
											nx_pause(0.2)
											AutoExecMenu(nil,nil,0)
											nx_pause(0.2)
										end
									end	
								else
									if 	get_distance_pos(x,y,z,player) > 2 then
											autoMove(maps,x,y,z)
									end
								end
							end
						end	
						elseif nameSchool == "tl" then
							if getQuestID("title_41") then
								step = 2
							end
							if step == 1 then
								if returnMasterSchoolDis(maps,questFirstID,client_player,x1,y1,z1,npcFirstObj,questID) then
									if npcMaster then				
										if getDistance(npcMaster) > 5 then
											autoMove(maps,x,y,z)
										else
											nx_execute('custom_sender','custom_select', npcMaster.Ident)
											nx_pause(0.2)	
											AutoExecMenu(nil,nil,0)
											nx_pause(0.2)
											AutoExecMenu(nil,nil,0)
											nx_pause(0.2)
											AutoExecMenu(nil,nil,0)	
											nx_pause(0.2)
											AutoExecMenu(nil,nil,0)	
											step = 2
										end
									else									
										if 	get_distance_pos(x,y,z,client_player) > 2 then					
											autoMove(maps,x,y,z)
										end
									end						
								end
							elseif step == 2 then			
								if not getQuestID("title_41") then
									talkNpcQuest(npcMaster,maps,x,y,z,client_player)
								elseif getQuestID("title_41") and get_task_round_state("41") == 1 and get_task_complete_state("41") == 0 then
									if npcMaster then				
										if getDistance(npcMaster) > 5 then
											autoMove(maps,x,y,z)
										else
											nx_execute('custom_sender','custom_select', npcMaster.Ident)
											nx_pause(1)	
											talkNpc(1)
											nx_pause(1)						
											talkNpc(2)
											nx_pause(1)						
											talkNpc(1)	
										end
									else									
										if 	get_distance_pos(x,y,z,client_player) > 2 then					
											autoMove(maps,x,y,z)
										end
									end	
								elseif getQuestID("title_41") and get_task_round_state("41") == 1 and get_task_complete_state("41") == 2 then
									talkNpcQuest(npcMaster,maps,x,y,z,client_player)
								end
							end	
						elseif nameSchool == "nm" then
							if getQuestID("title_43") then
								step = 2
							end	
							if step == 1 then	
								if returnMasterSchoolDis(maps,questFirstID,client_player,x1,y1,z1,npcFirstObj,questID) then
									if npcMaster then				
										if getDistance(npcMaster) > 5 then
											autoMove(maps,x,y,z)
										else
											nx_execute('custom_sender','custom_select', npcMaster.Ident)
											nx_pause(0.2)	
											AutoExecMenu(nil,nil,0)
											nx_pause(0.2)
											AutoExecMenu(nil,nil,0)
											nx_pause(0.2)
											AutoExecMenu(nil,nil,0)	
											nx_pause(0.2)
											AutoExecMenu(nil,nil,0)	
											step = 2
										end
									else									
										if 	get_distance_pos(x,y,z,client_player) > 2 then					
											autoMove(maps,x,y,z)
										end
									end						
								end
							elseif step == 2 then			
								if not getQuestID("title_43") then
									talkNpcQuest(npcMaster,maps,x,y,z,client_player)
								elseif getQuestID("title_43") and get_task_round_state("43") == 1 then
									local npcQuest2 = FindObject("WorldNpc02686")
									local xx,yy,zz = getPosNpc(maps,"WorldNpc02686")
									talkNpcQuest(npcQuest2,maps,xx,yy,zz,client_player)		
								elseif getQuestID("title_43") and get_task_round_state("43") == 2 then	
									local item = nx_execute('tips_data', 'get_item_in_view', nx_int(125), 'useitem_bs008')
									if item ~= nil then
										nx_execute('custom_sender', 'custom_use_item', 125, item.Ident)
										nx_pause(7)	
									end	
								elseif getQuestID("title_43") and get_task_round_state("43") == 3 and get_task_complete_state("43") == 0 then
									local npcQuest2 = FindObject("WorldNpc02686")
									local xx,yy,zz = getPosNpc(maps,"WorldNpc02686")
									talkNpcQuest(npcQuest2,maps,xx,yy,zz,client_player)	
								elseif getQuestID("title_43") and get_task_round_state("43") == 3 and get_task_complete_state("43") == 2 then
									talkNpcQuest(npcMaster,maps,x,y,z,client_player)
								end
							end	
						elseif nameSchool == "dm" then
							if getQuestID("title_46") then
								step = 2
							end	
						if step == 1 then	
							if returnMasterSchoolDis(maps,questFirstID,client_player,x1,y1,z1,npcFirstObj,questID) then
								if npcMaster then				
									if getDistance(npcMaster) > 5 then
										autoMove(maps,x,y,z)
									else
										nx_execute('custom_sender','custom_select', npcMaster.Ident)
										nx_pause(0.2)	
										AutoExecMenu(nil,nil,0)
										nx_pause(0.2)
										AutoExecMenu(nil,nil,0)
										nx_pause(0.2)
										AutoExecMenu(nil,nil,0)	
										nx_pause(0.2)
										AutoExecMenu(nil,nil,0)	
										step = 2
									end
								else									
									if 	get_distance_pos(x,y,z,client_player) > 2 then					
										autoMove(maps,x,y,z)
									end
								end						
							end
						elseif step == 2 then			
							if not getQuestID("title_46") then
								talkNpcQuest(npcMaster,maps,x,y,z,client_player)
							elseif getQuestID("title_46") and get_task_round_state("46") == 1 then
								talkNpcQuest(npcMaster,maps,x,y,z,client_player)	
							elseif getQuestID("title_46") and get_task_round_state("46") == 2 then	
								local npcQuest2 = FindObject("WorldNpc02205")
								local xx,yy,zz = getPosNpc(maps,"WorldNpc02205")
								talkNpcQuest(npcQuest2,maps,xx,yy,zz,client_player)
							 elseif getQuestID("title_46") and get_task_round_state("46") == 3 then				
								local npcQuest2 = FindObject("monrm062800")
								local xx,yy,zz = 821.392,35.365,-26.900
								if npcQuest2 then
									if getDistance(npcQuest2) > 2 then
										local game_visual = nx_value("game_visual")
										local target = game_visual:GetSceneObj(npcQuest2.Ident)
										autoMove(maps, target.PositionX, target.PositionY, target.PositionZ, 1)
									else
										nx_execute('custom_sender','custom_select', npcQuest2.Ident)
										nx_execute('custom_sender','custom_select', npcQuest2.Ident)
										local item = nx_execute('tips_data', 'get_item_in_view', nx_int(125), 'useitem_20f')
										if item ~= nil then
											nx_execute('custom_sender', 'custom_use_item', 125, item.Ident)
											nx_pause(7)	
										end	
									end	
								else
									if 	get_distance_pos(xx,yy,zz,client_player) > 2 then					
										autoMove(maps,xx,yy,zz)
									end
								end
							 elseif getQuestID("title_46") and get_task_round_state("46") == 4 and get_task_complete_state("46") == 0 then				
								local npcQuest2 = FindObject("WorldNpc02205")
								local xx,yy,zz = getPosNpc(maps,"WorldNpc02205")
								talkNpcQuest(npcQuest2,maps,xx,yy,zz,client_player)
							 elseif getQuestID("title_46") and get_task_round_state("46") == 4 and get_task_complete_state("46") == 2 then				
							  talkNpcQuest(npcMaster,maps,x,y,z,client_player)
							end
						end
						elseif nameSchool == "vd" then
							if getQuestID("title_42") then
								step = 2
							end	
						if step == 1 then		
							if returnMasterSchoolDis(maps,questFirstID,client_player,x1,y1,z1,npcFirstObj,questID) then
								if npcMaster then				
									if getDistance(npcMaster) > 5 then
										autoMove(maps,x,y,z)
									else
										nx_execute('custom_sender','custom_select', npcMaster.Ident)
										nx_pause(0.2)	
										AutoExecMenu(nil,nil,0)
										nx_pause(0.2)
										AutoExecMenu(nil,nil,0)
										nx_pause(0.2)
										AutoExecMenu(nil,nil,0)	
										nx_pause(0.2)
										AutoExecMenu(nil,nil,0)	
										step = 2
									end
								else									
									if 	get_distance_pos(x,y,z,client_player) > 2 then					
										autoMove(maps,x,y,z)
									end
								end						
							end
						elseif step == 2 then			
								if not getQuestID("title_42") then
									talkNpcQuest(npcMaster,maps,x,y,z,client_player)
								elseif getQuestID("title_42") and get_task_round_state("42") == 1 then
									if npcMaster then				
									if getDistance(npcMaster) > 5 then
										autoMove(maps,x,y,z)
									else
										nx_execute('custom_sender','custom_select', npcMaster.Ident)
										nx_pause(1)	
										talkNpc(1)
										nx_pause(1)
										talkNpc(1)
										nx_pause(1)
										talkNpc(2)					
									end
								else									
									if 	get_distance_pos(x,y,z,client_player) > 2 then					
										autoMove(maps,x,y,z)
									end
								end			
								elseif getQuestID("title_42") and get_task_round_state("42") == 1 and get_task_complete_state("42") == 2 then	
									talkNpcQuest(npcMaster,maps,x,y,z,client_player)			
								end
							end	
						elseif nameSchool == "cyv" then	
											
								if getQuestID("title_48") then
									step = 2
								end	
							if step == 1 then
								if returnMasterSchoolDis(maps,questFirstID,client_player,x1,y1,z1,npcFirstObj,questID) then
									if npcMaster then				
										if getDistance(npcMaster) > 5 then
											autoMove(maps,x,y,z)
										else
											nx_execute('custom_sender','custom_select', npcMaster.Ident)
											nx_pause(0.2)	
											AutoExecMenu(nil,nil,0)
											nx_pause(0.2)
											AutoExecMenu(nil,nil,0)
											nx_pause(0.2)
											AutoExecMenu(nil,nil,0)	
											nx_pause(0.2)
											AutoExecMenu(nil,nil,0)	
											step = 2
										end
									else		
									
										if 	get_distance_pos(x,y,z,client_player) > 2 then
											autoMove(maps,x,y,z)
										end
									end						
								end
							elseif step == 2 then			
								if not getQuestID("title_48") then
									talkNpcQuest(npcMaster,maps,x,y,z,client_player)
								elseif getQuestID("title_48") and get_task_round_state("48") == 1 then
									talkNpcQuest(npcMaster,maps,x,y,z,client_player)	
								elseif getQuestID("title_48") and get_task_round_state("48") == 2 then	
									local npc = FindNearObject("monrm013901")				
									local x2,y2,z2 = 354.555,65.518,-63.229,0.539
									local game_visual = nx_value("game_visual")
									local form_shortcut = nx_value("form_stage_main\\form_main\\form_main_shortcut")
									local game_shortcut = nx_value("GameShortcut")
									local grid = form_shortcut.grid_shortcut_main			
									local fight = nx_value("fight")
									if npc ~= nil then
									  if get_distance_obj(client_player, npc) > 3 then					
										local target = game_visual:GetSceneObj(npc.Ident)					
										autoMove(maps, target.PositionX, target.PositionY, target.PositionZ,1)
									  else				 
										nx_execute("custom_sender", "custom_select", npc.Ident)
										nx_execute("custom_sender", "custom_select", npc.Ident)
										for i=0,9 do
										  game_shortcut:on_main_shortcut_useitem(grid, i, true)
										end
									  end
									 else									
										if 	get_distance_pos(x2,y2,z2,client_player) > 2 then
											autoMove(maps,x2,y2,z2)
										end
									end
								 elseif getQuestID("title_48") and get_task_round_state("48") == 3 then
									if npcMaster then
										if getDistance(npcMaster) > 2 then
											autoMove(maps,x,y,z)
										else
											nx_execute('custom_sender','custom_select', npcMaster.Ident)
											nx_pause(0.2)	
											AutoExecMenu(nil,nil,0)
											nx_pause(0.2)
											AutoExecMenu(nil,nil,0)
											nx_pause(0.2)
											AutoExecMenu(nil,nil,0)	
											nx_pause(0.2)
											AutoExecMenu(nil,nil,0)
										end
									else									
										if 	get_distance_pos(x,y,z,client_player) > 2 then
											autoMove(maps,x,y,z)
										end
									end	
								end
							end		
						elseif nameSchool == "qtd" then
							if getQuestID("title_45") then
								step = 2
							end	
							if step == 1 then
								if returnMasterSchoolDis(maps,questFirstID,client_player,x1,y1,z1,npcFirstObj,questID) then
									if npcMaster then
										if getDistance(npcMaster) > 5 then
											autoMove(maps,x,y,z)
										else
											nx_execute('custom_sender','custom_select', npcMaster.Ident)
											nx_pause(0.1)	
											AutoExecMenu(nil,nil,0)
											nx_pause(0.1)
											AutoExecMenu(nil,nil,0)
											nx_pause(0.1)
											AutoExecMenu(nil,nil,0)	
											nx_pause(0.1)
											AutoExecMenu(nil,nil,0)												
											step = 2
										end
									else									
										if 	get_distance_pos(x,y,z,client_player) > 2 then
											autoMove(maps,x,y,z)
										end
									end						
								end	
							elseif step == 2 then
								if not getQuestID("title_45") then
									talkNpcQuest(npcMaster,maps,x,y,z,client_player)
								elseif getQuestID("title_45") and get_task_round_state("45") == 1 then
									talkNpcQuest(npcMaster,maps,x,y,z,client_player)
								elseif getQuestID("title_45") and get_task_round_state("45") == 2 then
								talkNpcQuest(npcMaster,maps,x,y,z,client_player)		
								 elseif getQuestID("title_45") and get_task_round_state("45") == 3 then
								  local item = nx_execute('tips_data', 'get_item_in_view', nx_int(125), 'useitem_bs001')
									if item ~= nil then
										nx_execute('custom_sender', 'custom_use_item', 125, item.Ident)
										nx_pause(4)	
									end			
								elseif getQuestID("title_45") and get_task_round_state("45") == 4 then	
									talkNpcQuest(npcMaster,maps,x,y,z,client_player)
								end
						end
					elseif nameSchool == "mg" then
							if getQuestID("title_72702") then
								step = 2
							end
							if step == 1 then
								if returnMasterSchoolDis(maps,questFirstID,client_player,x1,y1,z1,npcFirstObj,questID) then
									if npcMaster then				
										if getDistance(npcMaster) > 5 then
											autoMove(maps,x,y,z)
										else
											nx_execute('custom_sender','custom_select', npcMaster.Ident)
											nx_pause(0.2)	
											AutoExecMenu(nil,nil,0)
											nx_pause(0.2)
											AutoExecMenu(nil,nil,0)
											nx_pause(0.2)
											AutoExecMenu(nil,nil,0)	
											nx_pause(0.2)
											AutoExecMenu(nil,nil,0)nx_pause(0.2)
											AutoExecMenu(nil,nil,0)nx_pause(0.2)
											AutoExecMenu(nil,nil,0)nx_pause(0.2)
											AutoExecMenu(nil,nil,0)
											step = 2					
										end
									else									
										if 	get_distance_pos(x,y,z,client_player) > 2 then					
											autoMove(maps,x,y,z)
										end
									end						
								end	
							elseif step == 2 then
								if not getQuestID("title_72702") then
									talkNpcQuest(npcMaster,maps,x,y,z,client_player)
								elseif getQuestID("title_72702") and get_task_round_state("72702") == 1 then
									talkNpcQuest(npcMaster,maps,x,y,z,client_player)
								elseif getQuestID("title_72702") and get_task_round_state("72702") == 2 then
								talkNpcQuest(npcMaster,maps,x,y,z,client_player)
								elseif getQuestID("title_72702") and get_task_round_state("72702") == 4 then	
									talkNpcQuest(npcMaster,maps,x,y,z,client_player)
								end	
							end		
					end
				end
			end
		end
	end	
end
function returnMasterSchoolDis(mapid,questFirstID,player,x,y,z,npcFirstObj,questID)
	if getQuestID(questFirstID) and get_task_complete_state(questID) == 0 then				
			if npcFirstObj then
				if getDistance(npcFirstObj) > 5 then
					autoMove(mapid,x,y,z)
				else
					nx_execute('custom_sender','custom_select', npcFirstObj.Ident)
					nx_pause(1)	
					AutoExecMenu(nil,nil,0)
					nx_pause(0.2)
					AutoExecMenu(nil,nil,0)
					nx_pause(2)
					local FORM_CONFIRM = "form_common\\form_confirm"
					local form_c = nx_value("form_common\\form_confirm")
					if nx_is_valid(form_c) then
						local btn = form_c.ok_btn
						nx_execute(FORM_CONFIRM, "ok_btn_click", btn)
					end
				end
			else	
				if 	get_distance_pos(x,y,z,player) > 3 then				
					autoMove(mapid,x,y,z)	
				end
			end		
		end	
	if getQuestID(questFirstID) and get_task_complete_state(questID) == 2 then	 return true	
	end	
	return false
end
getQuestID = function(ID)                                                                                                            
	local player = nx_value('game_client'):GetPlayer()                                                                                 
	if not player:FindRecord('Task_Accepted') then                                                                                      
		return nil                                                                                                                        
	end                                                                                                                                  
	local row_num = player:GetRecordRows('Task_Accepted')                                                                                
	for i = 0, row_num - 1 do                                                                                                         
		local id = player:QueryRecord('Task_Accepted', i, 0)                                                                           
		if id ~= nil then                                                                                                               
			local idtask = player:QueryRecord('Task_Accepted', i, 5)                                  
			if idtask == ID then                                               
				return id                                                                                                               
			end                                                                                                                          
		end                                                                                                                             
	end                                                                                                                              
	return nil                                                                                                                         
end  

function questFirstAccount(job_npc,schoolName,job_id)	
	local game_client = nx_value("game_client")
	if not nx_is_valid(game_client) then
		return
	end
	local client_player = game_client:GetPlayer()
	if not nx_is_valid(client_player) then
		return
	end
	local stepQuestFirstAccount = 1 
	while startFirst do
		nx_pause(0.1)
		local mapid = get_current_map()
		nx_execute("form_stage_main\\form_helper\\form_main_helper_manager" , "close_helper_form")
		local loading_flag = nx_value("loading")
		local player = getPlayer()
		local curseloading = nx_value("form_stage_main\\form_main\\form_main_curseloading")
		if not loading_flag and not nx_is_valid(form_load) then	
		if stepQuestFirstAccount == 1 then			
				if getQuestID("title_27509") then
					stepQuestFirstAccount = 2
				end	
				if getQuestID("title_27510") then
					stepQuestFirstAccount = 3
				end	
				if getQuestID("title_50") and ( stepQuestFirstAccount ~= 5 or stepQuestFirstAccount ~= 6) then				
					stepQuestFirstAccount = 4
				end	
				if nx_execute("form_stage_main\\form_life\\form_job_main_new", "find_life_job", job_id)   then
					stepQuestFirstAccount = 6
				end	
				if getQuestID("title_1648") then --Sơ nhập giang hồ					
					local xp = FindObject("Transcity05D")
					local x,y,z = getPosNpc("city05","Transcity05D")					
					if xp then
						if getDistance(xp) > 5 then
							autoMove(mapid,x,y,z)
						else
							nx_execute('custom_sender','custom_select', xp.Ident)
							nx_pause(1)	
							AutoExecMenu(nil,nil,0)
							nx_pause(0.2)
							AutoExecMenu(nil,nil,0)
							nx_pause(0.2)
							AutoExecMenu(nil,nil,0)	
							nx_pause(0.2)
							AutoExecMenu(nil,nil,0)	
							if getQuestID("title_27509") then
								stepQuestFirstAccount = 2
							end
						end
					else				
						if get_distance_pos(x,y,z,player) > 3 then												
							autoMove(mapid,x,y,z)						
						end	
					end
				end	
		elseif stepQuestFirstAccount == 2 then
				if getQuestID("title_27509") then 			
					local xp = FindObject("Transcity05D")
					local x,y,z = getPosNpc("city05","Transcity05D")
					if xp then
						if getDistance(xp) > 5 then
							autoMove(mapid,x,y,z)
						else
							nx_execute('custom_sender','custom_select', xp.Ident)	
							nx_pause(1)	
							AutoExecMenu(nil,nil,0)	
							nx_pause(0.5)
							AutoExecMenu(nil,nil,0)
							nx_pause(0.5)
							AutoExecMenu(nil,nil,0)
							nx_pause(2)
							if getQuestID("title_27510") then
								stepQuestFirstAccount = 3
							end
						end
					else				
						if get_distance_pos(x,y,z,player) > 3 then												
							autoMove(mapid,x,y,z)						
						end	
					end
				end	
					
		elseif stepQuestFirstAccount == 3 then			
				if getQuestID("title_27510") then					
					local xp = FindObject("Transcity05D")
					local x,y,z = getPosNpc("city05","Transcity05D")					
					local npc2 = FindObject("Npc_yd_sh_cd_01")
					if	(get_task_round_state("27510") == 2  or get_task_round_state("27510") == 1 ) and get_task_complete_state("27510") == 0 then
						if xp then
							if getDistance(xp) > 5 then
								autoMove(mapid,x,y,z)
							else
								nx_execute('custom_sender','custom_select', xp.Ident)
								nx_pause(1)		
								AutoExecMenu(nil,nil,0)
								nx_pause(0.5)
								AutoExecMenu(nil,nil,0)	
								nx_pause(0.5)
								AutoExecMenu(nil,nil,0)																	
							end
						else				
							if get_distance_pos(x,y,z,player) > 3 then												
								autoMove(mapid,x,y,z)						
							end		
						end							
				elseif get_task_complete_state("27510") == 2 and get_task_round_state("27510") == 2 then
						local x,y,z = getPosNpc("city05","Npc_yd_sh_cd_01")					
						if npc2 then							
							if getDistance(npc2) > 5 then
								autoMove(mapid,x,y,z)
							else
								nx_execute('custom_sender','custom_select', npc2.Ident)
								nx_pause(1)		
								AutoExecMenu(nil,nil,0)
								nx_pause(0.5)
								AutoExecMenu(nil,nil,0)								
								nx_pause(0.5)
								AutoExecMenu(nil,nil,0)								
								nx_pause(0.2)
							end
						else				
							if get_distance_pos(x,y,z,player) > 3 then												
								autoMove(mapid,x,y,z)						
							end		
						end						
					end
					if getQuestID("title_50") then
						stepQuestFirstAccount = 4
					end
				end			
			elseif stepQuestFirstAccount == 4 then
				if job_npc ~= "" then
					stepQuestFirstAccount = 5
				else
					stepQuestFirstAccount = 6
				end			
			elseif stepQuestFirstAccount == 5 then
				nx_pause(2)
				if nx_is_valid(client_player) then
					local rownum = client_player:GetRecordRows('RecvLetterRec')
					for row = 0, rownum - 1 do
					 local title = client_player:QueryRecord('RecvLetterRec', row, 3)
					 local prize = client_player:QueryRecord('RecvLetterRec', row, 7)
					 local serial_no = client_player:QueryRecord('RecvLetterRec', row, 10)
					 if nx_string(prize) == '' then
					   nx_execute('custom_sender', 'custom_select_letter', 1, serial_no, 1)
					 else
					   if string.find(nx_string(prize), 'item_skipsp_001') ~= nil then
						 nx_execute('custom_sender', 'custom_get_appendix', serial_no)
					   end
					 end 
					 nx_execute('custom_sender', 'custom_del_letter', 0, 2)
					end
				end	
				nx_pause(1)
				
				local item = nx_execute('tips_data', 'get_item_in_view', nx_int(2), 'item_skipsp_001')
				if item ~= nil then
					nx_execute('custom_sender', 'custom_use_item', 2, item.Ident)
					nx_pause(4)
					auto_pickup()
					nx_pause(1)
				end
				local npc = FindObject(job_npc)	
				local npcx,npcy,npcz = getPosNpc("city05",job_npc)	
				if npc then
					local x,y,z = npc.PosiX,npc.PosiY,npc.PosiZ
					if getDistance(npc) > 5 then
						autoMove(mapid,x,y,z)
					else	
						if nx_execute("form_stage_main\\form_life\\form_job_main_new", "find_life_job", job_id)   then
							stepQuestFirstAccount = 6
						else
							nx_execute('custom_sender','custom_select', npc.Ident)
							nx_pause(0.5)	
							AutoExecMenu(nil,nil,0)
							nx_pause(0.5)
							AutoExecMenu(nil,nil,0)
							nx_pause(0.2)	
							AutoExecMenu(nil,nil,0)	
							nx_pause(2)					
						local FORM_CONFIRM = "form_common\\form_confirm"
						local form_c = nx_value("form_common\\form_confirm")
						if nx_is_valid(form_c) then
							local btn = form_c.ok_btn
								nx_execute(FORM_CONFIRM, "ok_btn_click", btn)
							end
						end
					end
				else				
					if get_distance_pos(npcx,npcy,npcz,player) > 3 then												
						autoMove(mapid,npcx,npcy,npcz)						
					end	
				end
			local form_school_introduce = nx_value("form_stage_main\\form_main\\form_school_introduce")
			elseif stepQuestFirstAccount == 6 then
				local xp = FindObject("Transcity05D")
				local x,y,z = getPosNpc("city05","Transcity05D")
				
				if xp then
					if get_distance_pos(x,y,z,player) > 1 then
						autoMove(mapid,x,y,z)
					else
						if get_distance_pos(x,y,z,player) <= 2 then
							nx_execute('custom_sender','custom_select', xp.Ident)
							nx_pause(1)
						end	
						AutoExecMenu(nil,nil,0)	
						nx_pause(0.2)
						AutoExecMenu(nil,nil,0)	
						nx_pause(0.2)
						AutoExecMenu(nil,nil,0)				
						nx_pause(2)
						stepQuestFirstAccount = 7						
					end
				else				
					if get_distance_pos(x,y,z,player) > 1 then												
						autoMove(mapid,x,y,z)						
					end
				end
			
			elseif stepQuestFirstAccount == 7 then
				local form = util_get_form("form_stage_main\\form_main\\form_school_introduce", true)
				if nx_is_valid(form) and form.Visible then				
					nx_pause(0.5)
					check_school(form, schoolName)
					nx_pause(2)
					nx_execute("form_stage_main\\form_main\\form_school_introduce", "on_btn_school_click", form.btn_school)
					nx_pause(1)						
				end
			stepQuestFirstAccount = 8	
		end
			if stepQuestFirstAccount == 8 then
				break
			end
		end
	end	
end
function talkNpcQuest(npcMaster,maps,x,y,z,client_player)
	if npcMaster then				
		if getDistance(npcMaster) > 5 then
			autoMove(maps,x,y,z)
		else
			nx_execute('custom_sender','custom_select', npcMaster.Ident)
			nx_pause(0.2)	
			AutoExecMenu(nil,nil,0)
			nx_pause(0.2)
			AutoExecMenu(nil,nil,0)
			nx_pause(0.2)
			AutoExecMenu(nil,nil,0)	
			nx_pause(0.2)
			AutoExecMenu(nil,nil,0)	
			step = 2
		end
	else									
		if 	get_distance_pos(x,y,z,client_player) > 2 then					
			autoMove(maps,x,y,z)
		end
	end
end
function FindNearObject(configid)
 local dis = 1000
 local obj = nil
 local game_client = nx_value("game_client")
 local client_player = game_client:GetPlayer()
 if nx_is_valid(client_player) then
   local scene = game_client:GetScene()
   local visual_objlist = scene:GetSceneObjList()
   if nx_is_valid(scene) then
     for k = 1, table.getn(visual_objlist) do
       local object = visual_objlist[k]
       if nx_is_valid(object) then
         if not game_client:IsPlayer(object.Ident) then
           if object:FindProp("ConfigID") and nx_string(object:QueryProp("ConfigID")) == nx_string(configid) then
             local distance = get_distance_obj(client_player, object)
             if distance < dis then
               dis = distance
               obj = object
             end
           end
         end
       end
     end
   end
 end
 return obj
end

function AutoExecMenu(title, name, pos)
  local form = util_get_form(FORM_TALK)
    if not nx_is_valid(form) or not form.Visible then
        return 0
    end
    local form_main_chat_logic = nx_value('form_main_chat')
    if not nx_is_valid(form_main_chat_logic) then
      return 0
    end
    local form_title = nx_ws_lower(form_main_chat_logic:DeleteHtml(form.mltbox_title.HtmlText))
    local check_title = nx_ws_lower(nx_widestr(util_text('menu_title_sale_faild_job_error')))
    if nx_function('ext_ws_find', form_title, check_title) ~= -1 then
      local game_visual = nx_value('game_visual')
      if not nx_is_valid(game_visual) then        
        return false
      end
      local visual_player = game_visual:GetPlayer()
      local player_pos_x = visual_player.PositionX
      local player_pos_y = visual_player.PositionY
      local player_pos_z = visual_player.PositionZ
      local point, dist = nx_execute(nx_current(), 'FindNearPoint', player_pos_x, player_pos_y, player_pos_z)
      local data = nx_execute(nx_current(), 'AutoAbductData', nx_value('form_stage_main\\form_map\\form_map_scene').current_map)
      current_point, dist = nx_execute(nx_current(), 'FindNearPoint', player_pos_x, player_pos_y, player_pos_z, point)
      nx_execute(nx_current(), 'AutoSetCurrent', current_point)
      AutoMove(data.pos[current_point].x,data.pos[current_point].y,data.pos[current_point].z,data.pos[current_point].o)
      nx_execute(FORM_TALK, 'menu_select', form.mltbox_menu:GetItemKeyByIndex(0))
      return 
    else
      check_title = nx_ws_lower(nx_widestr(util_text('menu_title_sale_faild_cd_error')))
      if nx_function('ext_ws_find', form_title, check_title) ~= -1 then
        nx_execute(FORM_TALK, 'menu_select', form.mltbox_menu:GetItemKeyByIndex(0))
        return 
      end
    end

    if title ~= nil then
        title = nx_ws_lower(nx_widestr(util_text(title)))
        if nx_function('ext_ws_find', form_title, title) == -1 then
            return
        end
    end
    if pos ~= nil then
      nx_execute(FORM_TALK, 'menu_select', form.mltbox_menu:GetItemKeyByIndex(pos))
    else
      local found_menu = false
      local menu_table = util_split_wstring(nx_widestr(form.menus), nx_widestr('|'))
      local menu_num1 = table.getn(menu_table)
      if menu_num1 > 4 and not found_menu then
          menu_num1 = round((menu_num1 - 0.1) / 4)
          for k = 0, menu_num1 do
              local menu = form.mltbox_menu
              local temp_menu = {}
              local menu_num = menu.ItemCount
              if nx_int(menu_num) > nx_int(0) and menu.Visible then
                  for i = 0, menu_num - 1 do
                      if found_menu then break end
                      local htmltext = menu:GetItemTextNoHtml(i)
                      htmltext = nx_ws_lower(form_main_chat_logic:DeleteHtml(htmltext))
                      htmltext2 = nx_ws_lower(nx_widestr(util_text(name)))
                      if nx_function('ext_ws_find', htmltext, htmltext2) ~= -1 then
                        found_menu = true
                          nx_execute(FORM_TALK, 'menu_select', form.mltbox_menu:GetItemKeyByIndex(i))
                          break
                      end
                  end
              end
              if not found_menu then
                  form.menu_page = k + 1
                  nx_execute(FORM_TALK, 'update_menu_control', form, form.menus)
              else
                  break
              end
          end
      else
          local menu = form.mltbox_menu
          local temp_menu = {}
          local menu_num = menu.ItemCount
          if nx_int(menu_num) > nx_int(0) and menu.Visible then
              for i = 0, menu_num - 1 do
                  if found_menu then break end
                  local htmltext = menu:GetItemTextNoHtml(i)
                  htmltext = form_main_chat_logic:DeleteHtml(htmltext)
                  if nx_function('ext_ws_find', htmltext, nx_widestr(util_text(name))) ~= -1 then
                    found_menu = true
                      nx_execute(FORM_TALK, 'menu_select', form.mltbox_menu:GetItemKeyByIndex(i))
                      break
                  end
              end
          end
      end
  end
end
function get_distance_obj(obj1, obj2)
  if not nx_is_valid(obj1) or not nx_is_valid(obj2) then
    return 100000000
  end
  local game_visual = nx_value('game_visual')
  local obj1_visual = game_visual:GetSceneObj(obj1.Ident)
  local obj2_visual = game_visual:GetSceneObj(obj2.Ident)
  if not nx_is_valid(obj1_visual) or not nx_is_valid(obj2_visual) then
    return 100000000
  end
  local offX = obj1_visual.PositionX - obj2_visual.PositionX
  local offY = obj1_visual.PositionY - obj2_visual.PositionY
  local offZ = obj1_visual.PositionZ - obj2_visual.PositionZ
  return math.sqrt(offX * offX + offY * offY + offZ * offZ)
end
function getPosNpc(scene, configId)
	local mgr = nx_value("SceneCreator")
	if nx_is_valid(mgr) then
		local res = mgr:GetNpcPosition(scene, configId)
		if 3 <= table.getn(res) then
			return res[1], res[2], res[3]
		end
	end
	return nil
end
function get_current_map(showtext)
  local game_client = nx_value('game_client')
  if not nx_is_valid(game_client) then
    return nx_string('')
  end
  local game_scence = game_client:GetScene()
  if not nx_is_valid(game_scence) then
    return nx_string('')
  end
  if showtext == nil then
    return game_scence:QueryProp('Resource')
  else
    return game_scence:QueryProp('ConfigID')
  end
end
local oldPos = {}
local stuck = 0
local skill_list = {}
local autoMoveBreak = 1
function autoMove(mapid, x, y, z, breakroute, npc) 
  local world = nx_value('world')
  local scene = world.MainScene
  if not nx_is_valid(scene) then
    return false
  end
  local terrain = scene.terrain
  if not nx_is_valid(terrain) then
    terrain = nx_value('terrain')
  end
  local game_visual = nx_value('game_visual')
  if nx_is_valid(game_visual) then
    local player = getPlayer()
    if nx_is_valid(player) then
      local role = game_visual:GetSceneObj(player.Ident)
      if nx_is_valid(role) then
        if breakroute ~= nil then
          autoMoveBreak = autoMoveBreak + 1
          if autoMoveBreak >= 30 then
            local path_finding = nx_value('path_finding')
            path_finding:FindPathScene(mapid, x, y, z, 0)
            autoMoveBreak = 1
          end
        end
        if nx_find_custom(role, 'path_finding') then
          if not is_path_finding(role) then
            local path_finding = nx_value('path_finding')
            path_finding:FindPathScene(mapid, x, y, z, 0)
          end
        else
          local path_finding = nx_value('path_finding')
          path_finding:FindPathScene(mapid, x, y, z, 0)
        end
        if oldPos[1] ~= nil then
          local distance = get_distance_pos(oldPos[1], oldPos[2], oldPos[3], player)
          if distance == 0 then
            stuck = stuck + 1
            if stuck >= 50 then
              if nx_function('find_buffer', player, 'buf_riding_01') then
                nx_execute('custom_sender', 'custom_remove_buffer', 'buf_riding_01')
              end
              nx_pause(1)
              nx_execute('custom_sender', 'custom_active_parry', 1, 2)
              nx_pause(1)
              nx_execute('custom_sender', 'custom_active_parry', 0, 2)
              nx_pause(1)
              local distance = 6
              local x = role.PositionX + distance * math.cos(role.AngleZ) * math.sin(role.AngleY)
              local y = role.PositionY + role.height * 0.5
              local z = role.PositionZ + distance * math.cos(role.AngleZ) * math.cos(role.AngleY)
              if npc ~= nil and nx_is_valid(npc) and 6 >= get_distance_obj(player, npc) then
                local target = game_visual:GetSceneObj(npc.Ident)
                x, y, z = target.PositionX, target.PositionY, target.PositionZ
              end
              emit_player_input(role, PLAYER_INPUT_HIT_SPACE, true)
              nx_pause(0.5)
              emit_player_input(role, PLAYER_INPUT_HIT_SPACE, true)
              nx_pause(0.5)
              emit_player_input(role, PLAYER_INPUT_HIT_SPACE, true)
              nx_pause(0.5)
              local higher_floor, higher_floor_y = get_pos_floor_index(role.scene.terrain, x, y, z)
              emit_player_input(role, PLAYER_INPUT_LOGIC, LOGIC_SERVER_JUMP_POS, x, higher_floor_y, z, 1, 1)
              stuck = 0
            end
          end
        end
        oldPos[1], oldPos[2], oldPos[3] = role.PositionX, role.PositionY, role.PositionZ
      end
    end
  end
end
function getPlayer()
  local game_client = nx_value('game_client')
  if nx_is_valid(game_client) then
    local client_player = game_client:GetPlayer()
    if nx_is_valid(client_player) then
      return client_player
    end
  end
  return nx_null()
end
function rangeobj(obj)
  if not nx_is_valid(obj) then
    return nil
  end
  return dist(nx_value('game_visual'):GetPlayer().PositionX, nx_value('game_visual'):GetPlayer().PositionY, nx_value('game_visual'):GetPlayer().PositionZ, obj.PosiX, obj.PosiY, obj.PosiZ)
end
function dist(l_21_0, l_21_1, l_21_2, l_21_3, l_21_4, l_21_5, l_21_6)
  local pxd = l_21_3 - l_21_0
  local pyd = l_21_4 - l_21_1
  local pzd = l_21_5 - l_21_2
  return nx_number(math.sqrt(pxd * pxd + pyd * pyd + pzd * pzd))
end
function get_distance_pos(x, y, z, player)
  if not nx_is_valid(player) then
    return -1
  end
  local game_visual = nx_value('game_visual')
  local visual_scene_obj = game_visual:GetSceneObj(player.Ident)
  if not nx_is_valid(visual_scene_obj) then
    return
  end
  local player_x = visual_scene_obj.PositionX
  local player_y = visual_scene_obj.PositionY
  local player_z = visual_scene_obj.PositionZ
  local sx = x - player_x
  local sy = y - player_y
  local sz = z - player_z
  return math.sqrt(sx * sx + sy * sy + sz * sz)
end
function distance2d(bx, bz, dx, dz)
  return math.sqrt((dx - bx) * (dx - bx) + (dz - bz) * (dz - bz))
end
function distance3d(bx, by, bz, dx, dy, dz)
  return math.sqrt((dx - bx) * (dx - bx) + (dy - by) * (dy - by) + (dz - bz) * (dz - bz))
end



function get_task_round_state(task_id)
  local gui = nx_value("gui")
  local game_client = nx_value("game_client")
  local client_player = game_client:GetPlayer()
  if not nx_is_valid(client_player) then
    return -1
  end
  local row = client_player:FindRecordRow("Task_Accepted", 0, nx_int(task_id), 0)
  if row < 0 then
    return -1
  end
  local flag = client_player:QueryRecord("Task_Accepted", row, 8)
  return flag
end
function get_task_complete_state(task_id)
  local gui = nx_value("gui")
  local game_client = nx_value("game_client")
  local client_player = game_client:GetPlayer()
  if not nx_is_valid(client_player) then
    return -1
  end
  local row = client_player:FindRecordRow("Task_Accepted", 0, nx_int(task_id), 0)
  if row < 0 then
    return -1
  end
  local flag = client_player:QueryRecord("Task_Accepted", row, 6)
  return flag
end

function check_school(form, schoolName)
	if schoolName == "qtd" then
		form.rbtn_jzt.Checked = true
	elseif schoolName == "mg" then
		form.rbtn_mj.Checked = true	
	elseif schoolName == "tl" then
		form.rbtn_sl.Checked = true
	elseif schoolName == "cb" then
		form.rbtn_gb.Checked = true
	elseif schoolName == "nm" then
		form.rbtn_em.Checked = true
	elseif schoolName == "vd" then
		form.rbtn_wd.Checked = true
	elseif schoolName == "dm" then
		form.rbtn_tm.Checked = true
	elseif schoolName == "clc" then
		form.rbtn_jlg.Checked = true
	elseif schoolName == "cyv" then
		form.rbtn_jyw.Checked = true
		
	end
end

function getDistance(obj)
	if not nx_is_valid(obj) then
		return -1
	end
	local game_client = nx_value('game_client')
	local game_visual = nx_value('game_visual')
  if nx_is_valid(game_client) and not nx_is_valid(game_visual) then
    return 999999
  end
	local visual_player = game_visual:GetPlayer()
	local client_player = game_client:GetPlayer()
  if not nx_is_valid(client_player) and not nx_is_valid(visual_player)  then
    return 999999
  end
	local sence = game_visual:GetSceneObj(obj.Ident)
  if not nx_is_valid(sence) then
    return 999999
  end
  return math.sqrt((visual_player.PositionX - sence.PositionX) * (visual_player.PositionX - sence.PositionX) + (visual_player.PositionY - sence.PositionY) * (visual_player.PositionY - sence.PositionY) + (visual_player.PositionZ - sence.PositionZ) * (visual_player.PositionZ - sence.PositionZ))
end
function FindItem(itemid, bag)
	local game_client = nx_value("game_client")
	local client_player = game_client:GetPlayer()
	if nx_is_valid(client_player) then

		local scene = game_client:GetScene()
		local view_table = game_client:GetViewList()
		for i = 1, table.getn(view_table) do
			local view = view_table[i]
			if view.Ident == nx_string(bag) then
				local view_obj_table = view:GetViewObjList()
				for k = 1, table.getn(view_obj_table) do
					local view_obj = view_obj_table[k]
					if view_obj:QueryProp("ConfigID") == itemid then
						return view_obj
					end
				end
			end
		end
	end
end
function FindObject(configid)
	local game_client = nx_value("game_client")
	local client_player = game_client:GetPlayer()
	if nx_is_valid(client_player) then
		local scene = game_client:GetScene()
		local visual_objlist = scene:GetSceneObjList()
		if nx_is_valid(scene) then
			for k = 1, table.getn(visual_objlist) do
				local object = visual_objlist[k]
				if nx_is_valid(object) then
					if not game_client:IsPlayer(object.Ident) then
						if object:FindProp("ConfigID") and nx_string(object:QueryProp("ConfigID")) == nx_string(configid) then
							return object
						end
					end
				end
			end
		end
	end
	return nil
end
function AutoExecMenu(title, name, pos)
  local form = util_get_form("form_stage_main\\form_talk_movie")
    if not nx_is_valid(form) or not form.Visible then
        return 0
    end
    local form_main_chat_logic = nx_value("form_main_chat")
    if not nx_is_valid(form_main_chat_logic) then
      return 0
    end
    local form_title = nx_ws_lower(form_main_chat_logic:DeleteHtml(form.mltbox_title.HtmlText))
    local check_title = nx_ws_lower(nx_widestr(util_text("menu_title_sale_faild_job_error")))
    if nx_function("ext_ws_find", form_title, check_title) ~= -1 then
      local game_visual = nx_value("game_visual")
      if not nx_is_valid(game_visual) then        
        return false
      end
      local visual_player = game_visual:GetPlayer()
      local player_pos_x = visual_player.PositionX
      local player_pos_y = visual_player.PositionY
      local player_pos_z = visual_player.PositionZ
      local point, dist = nx_execute(nx_current(), "FindNearPoint", player_pos_x, player_pos_y, player_pos_z)
      local data = nx_execute(nx_current(), "AutoAbductData", nx_value("form_stage_main\\form_map\\form_map_scene").current_map)
      current_point, dist = nx_execute(nx_current(), "FindNearPoint", player_pos_x, player_pos_y, player_pos_z, point)
      nx_execute(nx_current(), "AutoSetCurrent", current_point)
      AutoMove(data.pos[current_point].x,data.pos[current_point].y,data.pos[current_point].z,data.pos[current_point].o)
      nx_execute("form_stage_main\\form_talk_movie", "menu_select", form.mltbox_menu:GetItemKeyByIndex(0))
      return 
    else
      check_title = nx_ws_lower(nx_widestr(util_text("menu_title_sale_faild_cd_error")))
      if nx_function("ext_ws_find", form_title, check_title) ~= -1 then
        nx_execute("form_stage_main\\form_talk_movie", "menu_select", form.mltbox_menu:GetItemKeyByIndex(0))
        return 
      end
    end

    if title ~= nil then
        title = nx_ws_lower(nx_widestr(util_text(title)))
        if nx_function("ext_ws_find", form_title, title) == -1 then
            return
        end
    end
    if pos ~= nil then
      nx_execute("form_stage_main\\form_talk_movie", "menu_select", form.mltbox_menu:GetItemKeyByIndex(pos))
    else
      local found_menu = false
      local menu_table = util_split_wstring(nx_widestr(form.menus), nx_widestr("|"))
      local menu_num1 = table.getn(menu_table)
      if menu_num1 > 4 and not found_menu then
          menu_num1 = round((menu_num1 - 0.1) / 4)
          for k = 0, menu_num1 do
              local menu = form.mltbox_menu
              local temp_menu = {}
              local menu_num = menu.ItemCount
              if nx_int(menu_num) > nx_int(0) and menu.Visible then
                  for i = 0, menu_num - 1 do
                      if found_menu then break end
                      local htmltext = menu:GetItemTextNoHtml(i)
                      htmltext = nx_ws_lower(form_main_chat_logic:DeleteHtml(htmltext))
                      htmltext2 = nx_ws_lower(nx_widestr(util_text(name)))
                      if nx_function("ext_ws_find", htmltext, htmltext2) ~= -1 then
                        found_menu = true
                          nx_execute("form_stage_main\\form_talk_movie", "menu_select", form.mltbox_menu:GetItemKeyByIndex(i))
                          break
                      end
                  end
              end
              if not found_menu then
                  form.menu_page = k + 1
                  nx_execute("form_stage_main\\form_talk_movie", "update_menu_control", form, form.menus)
              else
                  break
              end
          end
      else
          local menu = form.mltbox_menu
          local temp_menu = {}
          local menu_num = menu.ItemCount
          if nx_int(menu_num) > nx_int(0) and menu.Visible then
              for i = 0, menu_num - 1 do
                  if found_menu then break end
                  local htmltext = menu:GetItemTextNoHtml(i)
                  htmltext = form_main_chat_logic:DeleteHtml(htmltext)
                  if nx_function("ext_ws_find", htmltext, nx_widestr(util_text(name))) ~= -1 then
                    found_menu = true
                      nx_execute("form_stage_main\\form_talk_movie", "menu_select", form.mltbox_menu:GetItemKeyByIndex(i))
                      break
                  end
              end
          end
      end
  end
end
getQuestID = function(ID)                                                                                                            
	local player = nx_value('game_client'):GetPlayer()                                                                                 
	if not player:FindRecord('Task_Accepted') then                                                                                      
		return nil                                                                                                                        
	end                                                                                                                                  
	local row_num = player:GetRecordRows('Task_Accepted')                                                                                
	for i = 0, row_num - 1 do                                                                                                         
		local id = player:QueryRecord('Task_Accepted', i, 0)                                                                           
		if id ~= nil then                                                                                                               
			local idtask = player:QueryRecord('Task_Accepted', i, 5)                                  
			if idtask == ID then                                               
				return id                                                                                                               
			end                                                                                                                          
		end                                                                                                                             
	end                                                                                                                              
	return nil                                                                                                                         
end  
