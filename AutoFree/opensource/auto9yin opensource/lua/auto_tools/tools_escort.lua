require("define\\request_type")
require("util_functions")
require("auto_tools\\tool_libs")

local THIS_FORM = "auto_tools\\tools_escort"
local FORM_MAIN_REQUEST = "form_stage_main\\form_main\\form_main_request"
local auto_is_running = false
local direct_run = false

local auto_kick_offline = 1 -- bằng 0 thì không kick người offline
local auto_accept_party = 1 -- bằng 0 thì không tự chấp nhận xin tổ đội

-- Sửa ở form_stage_main\\form_main\\form_main_request (Thêm 3 hàm để lấy request)

function auto_run(map, friend, mode, data)
	local escort_step = 1
	direct_run = true

						nx_execute("custom_sender", "custom_leave_team")
						nx_pause(1)

	while auto_is_running == true do
		local is_vaild_data = true
		local game_client
		local game_visual
		local game_player
		local player_client
		local game_scence
		local form

		form = nx_value(THIS_FORM)
		if not nx_is_valid(form) then
			is_vaild_data = false
		end
		game_client = nx_value("game_client")
		if not nx_is_valid(game_client) then
			is_vaild_data = false
		end
		game_visual = nx_value("game_visual")
		if not nx_is_valid(game_visual) then
			is_vaild_data = false
		end
		if is_vaild_data == true then
			game_player = game_visual:GetPlayer()
			if not nx_is_valid(game_player) then
				is_vaild_data = false
			end
			player_client = game_client:GetPlayer()
			if not nx_is_valid(player_client) then
				is_vaild_data = false
			end
			game_scence = game_client:GetScene()
			if not nx_is_valid(game_scence) then
				is_vaild_data = false
			end
		end

		--if is_vaild_data == true then
			-- Chấp nhận lời mời tổ đội
			local num_request = nx_execute(FORM_MAIN_REQUEST, "get_num_request")
			if num_request > 0 then
				for i = 1, num_request do
					local request_type = nx_execute(FORM_MAIN_REQUEST, "get_request_type", i)
					local request_player = nx_execute(FORM_MAIN_REQUEST, "get_request_player", i)
					if request_type == REQUESTTYPE_INVITETEAM and request_player == friend then
						nx_execute("custom_sender", "custom_request_answer", request_type, request_player, 1)
						nx_execute(FORM_MAIN_REQUEST, "clear_request")
						nx_pause(1)
						break
					end
				end
			end
			-- check offline + rời map + chấp nhận gia nhập tổ đội
		
              CheckOffline()
                AutoAcceptParty()
		
			-- Nếu bị chết thì phải bắt đầu lại từ đầu
			local logicstate = player_client:QueryProp("LogicState")
			if logicstate == 120 then
				escort_step = 1
				nx_execute("custom_sender", "custom_relive", 2, 0)
				nx_pause(15)
			end
			

			
			-- Bước 1: Chạy đến điểm nhận tiêu (Cả hai người cùng chạy tới)
			if escort_step == 1 then
					local form_escort = util_get_form("form_stage_main\\form_school_war\\form_escortnpc_control_list", true)
					nx_destroy(form_escort)
				-- Người đứng yên thì không có bước 2 chỉ đứng chấp nhận lời mời tổ đội
				if mode ~= util_text("tool_escort_mode2") then
					if not tools_move_isArrived(data.npcpos.x, data.npcpos.y, data.npcpos.z, 5) then
						tools_move(map, data.npcpos.x, data.npcpos.y, data.npcpos.z, direct_run)
						direct_run = false
					else
						-- Đến chỗ nhận tiêu thì chuyển sang bước 2
						escort_step = 2
						direct_run = true
					end
				end
			-- Bước 2: Xử lý nhóm
			elseif escort_step == 2 then
				-- Kiểm tra lại chỗ đứng nếu sai thì chuyển về bước 1
				if not tools_move_isArrived(data.npcpos.x, data.npcpos.y, data.npcpos.z, 5) then
					escort_step = 1
				else
					if friend == util_text("tool_escort_one") and player_client:QueryProp("TeamID") == 0 then
						nx_execute("custom_sender", "custom_team_create")
						nx_pause(1)
						escort_step = 3
					else
						escort_step = 3
			-- Nếu vận tiêu với bạn
						-- Nếu không có nhóm thì tạo nhóm
						if player_client:QueryProp("TeamID") == 0 then
							nx_execute("custom_sender", "custom_team_create")
							nx_pause(1)
						end
						-- Có nhóm rồi thì mời bạn vận tiêu vào nhóm
						if player_client:QueryProp("TeamMemberCount") < 2 and friend ~= util_text("tool_escort_one") then
							nx_execute("custom_sender", "custom_team_invite", friend)
							nx_pause(2.5)
						end
						-- Là đội trưởng và đủ thành viên thì bắt đầu nhận tiêu
						if player_client:QueryProp("TeamMemberCount") >= 2 and player_client:QueryProp("Name") == player_client:QueryProp("TeamCaptain") then
							escort_step = 3
						end
					end
				end
			-- Bắt đầu nhận tiêu
			elseif escort_step == 3 then
				-- Kiểm tra lại địa điểm đang đứng
				if not tools_move_isArrived(data.npcpos.x, data.npcpos.y, data.npcpos.z, 5) then
					escort_step = 1
				else
					local form_escort = util_get_form("form_stage_main\\form_school_war\\form_escortnpc_control_list", true)
					-- Kiểm tra xem đã nhận tiêu chưa
					if form_escort.Visible == false then
						nx_execute("custom_sender", "custom_request_start_escort", data.npc.name, data.npc.id, 0)
						nx_pause(2)
					else
						-- Nếu đã nhận, di chuyển đến chỗ xe tiêu
						tools_move(map, data.escortpos.x, data.escortpos.y, data.escortpos.z, true)
						nx_pause(3)
						escort_step = 4
					end
				end
			elseif escort_step == 4 then
				-- Kiểm tra xem có đến chỗ xe tiêu chưa
				if not tools_move_isArrived(data.escortpos.x, data.escortpos.y, data.escortpos.z, 5) then
					tools_move(map, data.escortpos.x, data.escortpos.y, data.escortpos.z, direct_run)
					direct_run = false
				else
					local form_escort = util_get_form("form_stage_main\\form_school_war\\form_escortnpc_control_list", true)
					if not nx_is_valid(form_escort) then
						return 1
					end
					nx_execute("custom_sender", "custom_request_escort_control", form_escort.obj, 1) -- 1 Lên xe tiêu, 2
					nx_destroy(form_escort)
					escort_step = 5
					direct_run = true
				end
			elseif escort_step == 5 then
chectieu() -- phiên bản TQ sau này chống auto tiêu. khi nào gosu update thì chạy hàm này
				if tools_move_isArrived(data.endpos.x, data.endpos.y, data.endpos.z, 5) then
					local form_escort = util_get_form("form_stage_main\\form_school_war\\form_escortnpc_control_list", true)
					nx_destroy(form_escort)
					nx_pause(4)
					-- Chuyển giao đội trưởng cho bạn vận nếu luân phiên nhau
					if mode == util_text("tool_escort_mode3") then
						nx_execute("custom_sender", "custom_caption_change", friend)
						nx_pause(1)
					end
					escort_step = 1
				end
			end
	--	end
		nx_pause(1)
	end
end


	--2stusiosvn
function CheckOffline()
  if auto_run then
    local client = nx_value("game_client")
    if not nx_is_valid(client) then
      return 0
    end
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
      return 0
    end
    local scene = client:GetScene()
    if nx_is_valid(scene) then
      local game_player = game_visual:GetPlayer()
      local scene_obj_table = scene:GetSceneObjList()
      local form_main_chat_logic = nx_value("form_main_chat")
      for k = 1, table.getn(scene_obj_table) do
        local scene_obj = scene_obj_table[k]
        local id = scene_obj:QueryProp("Name")
        local name = nx_widestr(util_text(id))
        local typez = scene_obj:QueryProp("Type")
        if client:IsPlayer(scene_obj.Ident) then
          local record_table = scene_obj:GetRecordList()
          for k = 1, table.getn(record_table) do
            local record_name = record_table[k]
            if record_name == "team_rec" then
              local rows = scene_obj:GetRecordRows(record_name)
              for r = 0, rows - 1 do
                local team_name = scene_obj:QueryRecord(record_name, r, 0)
                local map = scene_obj:QueryRecord(record_name, r, 1)
                local offline = scene_obj:QueryRecord(record_name, r, 5)
                if string.find(nx_string(map), nx_string(get_current_map())) == nil then
                  form_main_chat_logic:AddChatInfoEx(nx_widestr(team_name) .. nx_widestr(" Khong o cung map - auto kick"), CHATTYPE_SYSTEM, false)
                  nx_execute("custom_sender", "custom_kickout_team", team_name)
                elseif offline ~= 0 and auto_kick_offline == 1 then
                  form_main_chat_logic:AddChatInfoEx(nx_widestr(team_name) .. nx_widestr(" Offline - auto kick"), CHATTYPE_SYSTEM, false)
                  nx_execute("custom_sender", "custom_kickout_team", team_name)
                end
              end
            end
          end
        end
      end
    end
  end
end

function AutoAcceptParty()
  local request, player = nx_execute(FORM_MAIN_REQUEST, "find_team_request", REQUESTTYPE_TEAMREQUEST)
  if player ~= nil and auto_accept_party == 1 then
    nx_execute("custom_sender", "custom_request_answer", request, player, 1)
    nx_execute(FORM_MAIN_REQUEST, "clear_special_request", request)
  end
end
----
function get_escort_data(city)
	-- Thành Đô
	if city == "city05" then
		return {
			npcpos = {
				x = 723.172,
				y = 23.786,
				z = 517.961
			},
			npc = {
				name = "EscortAcceptNpc001",
				id = 252
			},
			escortpos = {
				x = 723.975,
				y = 23.045,
				z = 522.935
			},
			endpos = {
				x = 253.065,
				y = 39.087,
				z = 500.925
			}
		}
	end
	-- Lạc Dương
	if city == "city04" then
		return {
			npcpos = {
				x = 915.173,
				y = -24.855,
				z = 801.451
			},
			npc = {
				name = "EscortAcceptNpc003",
				id = 232
			},
			escortpos = {
				x = 925.267,
				y = -24.852,
				z = 798.049
			},
			endpos = {
				x = 488.769,
				y = -4.397,
				z = 926.804
			}
		}
	end
	-- Yến Kinh
	if city == "city01" then
		return {
			npcpos = {
				x = 591.118,
				y = -105.567,
				z = 226.041
			},
			npc = {
				name = "EscortAcceptNpc004",
				id = 206
			},
			escortpos = {
				x = 591.382,
				y = -106.12,
				z = 218.543
			},
			endpos = {
				x = 1095.062,
				y = -60.122,
				z = 592.076
			}
		}
	end
	-- Kim Lăng
	if city == "city03" then
		return {
			npcpos = {
				x = 1428.08,
				y = 8.409,
				z = 712.372
			},
			npc = {
				name = "EscortAcceptNpc005",
				id = 242
			},
			escortpos = {
				x = 1427.985,
				y = 8.409,
				z = 722.392
			},
			endpos = {
				x = 2022.77,
				y = 23.272,
				z = 1573.254
			}
		}
	end
	-- Tô Châu
	if city == "city02" then
		return {
			npcpos = {
				x = 429.543,
				y = 0.63,
				z = 627.709
			},
			npc = {
				name = "EscortAcceptNpc002",
				id = 219
			},
			escortpos = {
				x = 432.439,
				y = 0.63,
				z = 630.891
			},
			endpos = {
				x = 1089.307,
				y = 12.861,
				z = 504.941
			}
		}
	end
	return false
end
function reset_this_form(form)
	form.combobox_friends.DropListBox:ClearString()
	form.combobox_friends.Text = nx_widestr("")
	form.combobox_mode.DropListBox:ClearString()
	form.combobox_mode.Text = nx_widestr("")
	form.btn_control.Visible = false
	form.btn_control.Text = util_text("tool_start")
end
function control_this_form(form)
	reset_this_form(form)
	local map = get_current_map()
	form.lbl_2.Text = util_text(map)
	local data = get_escort_data(map)
	if data == false then
		auto_is_running = false
		form.lbl_4.Text = util_text("tool_status_cant")
		return false
	end
	local game_client = nx_value("game_client")
	local player_client = game_client:GetPlayer()
	-- Xác định bang của người vận tiêu
	local self_guild = player_client:QueryProp("GuildName")
	if self_guild == "" or self_guild == nil or self_guild == 0 then
		tools_show_notice(util_text("tool_escort_noguild"))
		return false
	end
	-- Viết danh sách bạn bè
	local combobox_friends = form.combobox_friends
	if combobox_friends.DroppedDown then
		combobox_friends.DroppedDown = false
	end
	combobox_friends.DropListBox:AddString(util_text("tool_escort_one"))
	local rows = player_client:GetRecordRows("rec_buddy")
	for i = 0, rows - 1 do
	    local player_name = player_client:QueryRecord("rec_buddy", i, 1)
	    local player_guild = player_client:QueryRecord("rec_buddy", i, 6)
	    local player_status = player_client:QueryRecord("rec_buddy", i, 8)
		-- Chí hữu cùng bang và đang online
		if player_status == 0 and player_guild == self_guild then
			combobox_friends.DropListBox:AddString(player_name)
		end
	end
	combobox_friends.Text = util_text("tool_escort_one")
	-- Viết kiểu vận
	local combobox_mode = form.combobox_mode
	if combobox_mode.DroppedDown then
		combobox_mode.DroppedDown = false
	end
	local escort_mode = {
		"tool_escort_mode1",
		"tool_escort_mode2",
		"tool_escort_mode3"
	}
	for i = 1, table.getn(escort_mode) do
		combobox_mode.DropListBox:AddString(util_text(escort_mode[i]))
	end
	combobox_mode.Text = util_text(escort_mode[1])
	form.lbl_4.Text = util_text("tool_status_ok")
	form.btn_control.Text = util_text("tool_start")
	form.btn_control.Visible = true
end
function on_form_main_init(form)
	form.Fixed = false
	form.is_minimize = false
end
function on_main_form_open(form)
	change_form_size()
	form.is_minimize = false
	auto_is_running = false
	control_this_form(form)
end
function on_main_form_close(form)
	auto_is_running = false
	nx_destroy(form)
end
function on_btn_close_click(btn)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
function on_btn_control_click(btn)
	local form = btn.ParentForm
	if not nx_is_valid(form) then
		return
	end
	if auto_is_running then
		auto_is_running = false
		btn.Text = util_text("tool_start")
	else
		auto_is_running = true
		btn.Text = util_text("tool_stop")
		local map = get_current_map()
		auto_run(map, form.combobox_friends.Text, form.combobox_mode.Text, get_escort_data(map))
	end
end
function change_form_size()
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	local gui = nx_value("gui")
	form.Left = (gui.Width - form.Width) / 2
	--form.Top = (gui.Height - form.Height) / 2
	form.Top = 100
end
function on_combobox_mode_selected(combobox)
end
function on_combobox_friends_selected(combobox)
end
function get_current_map()
	return nx_value("form_stage_main\\form_map\\form_map_scene").current_map
end


--------------- bỏ qua check tiêu
function chectieu()

			local g=nx_value("game_client")
			local m=nx_value("game_visual")
			local n=g:GetPlayer()
			local o=m:GetPlayer()
			local h=g:GetScene()
			local D=n:QueryRecord("escort_record",0,0)
			local G=GetEscortObject(D)
			if G~=nil then 
				E=G.DestX
				F=G.DestZ 
				else 
						E=n:QueryRecord("escort_record",0,1)
						F=n:QueryRecord("escort_record",0,2)
			end
			if E~=0 and F~=0 and GetDistanceBetweenTwoPoint(o.PositionX,0,o.PositionZ,E,0,F)<=5 then 
			local game_check=util_get_form("form_stage_main\\form_school_war\\form_escortnpc_control_game",true)
			if nx_is_valid(game_check) and game_check.Visible then
				nx_execute("custom_sender","custom_escort_game_answer",398,nx_string(game_check.key_str))
				util_show_form("form_stage_main\\form_school_war\\form_escortnpc_control_game",false)
			end
			if nx_is_valid(G) then
				nx_execute("custom_sender","custom_select",G.Ident)
			end
			local form_escort=util_get_form("form_stage_main\\form_school_war\\form_escortnpc_control_list",true)
			if nx_is_valid(form_escort) and form_escort.Visible then
				nx_execute("custom_sender","custom_request_escort_control",form_escort.obj,1) -- 1 Lên xe tiêu, 2
			--	form_escort.Visible = false
			--	form_escort:Close()
			end
			end
end

function GetDistanceBetweenTwoPoint(e,f,g,h,i,j)
if h~=nil and e~=nil then 
	local k=e-h
	local l=f-i
	local m=g-j
return 
	math.sqrt(k*k+l*l+m*m)
else 
	return 10000 
end 
end

function GetEscortObject(n)
local b=nx_value("game_client")
local c=b:GetPlayer()
if nx_is_valid(c) then 
	local o=b:GetScene()
	local p=o:GetSceneObjList()
		if nx_is_valid(o) then 
			for q=1,table.getn(p) do 
				local r=p[q]
					if nx_is_valid(r) then 
						if not b:IsPlayer(r.Ident) and r:QueryProp("Type")==4 then 
							if r:FindProp("NpcType") and r:FindProp("TeamID") then 
								if r:QueryProp("NpcType")==213 and r:QueryProp("TeamID")==n then 
									return r
								end 
							end 
						end 
					end
				end 
			end 
		end
	return nil 
end
------------------