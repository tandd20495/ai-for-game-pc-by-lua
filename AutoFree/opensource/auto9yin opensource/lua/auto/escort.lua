require("util_gui")
require("util_functions")
require("share\\server_custom_define")
require("define\\sysinfo_define")
require("share\\chat_define")
require("define\\request_type")
require("util_functions")
require("util_gui")
require("auto\\lib")
local escort_point = {
	city05 = {
		accept_point = {722.631,23.046,519.550,3.082},
		accept_npc = "EscortAcceptNpc001",
		accept_type = {251,252,254}
		
	},
	city04 = {
		accept_point = {915.173,-24.855,801.451,-1.001},
		accept_npc = "EscortAcceptNpc003",
		accept_type= {228,230,232}
	},
	city03 = {
		accept_point = {1428.080,8.409,712.372,3.138},
		accept_npc = "EscortAcceptNpc005",
		accept_type= {240,242,243}
	},
	city02 = {
		accept_point = {429.543,0.630,627.709,-1.843},
		accept_npc = "EscortAcceptNpc002",
		accept_type= {212,213,219}
	},
	city01 = {
		accept_point = {591.118,-105.567,226.041,0.101},
		accept_npc = "EscortAcceptNpc004",
		accept_type= {206,208,207}
	}
}


local THIS_FORM = "auto\\escort"
local FORM_MAIN_REQUEST = "form_stage_main\\form_main\\form_main_request"

function on_escort_init(form)
  form.Fixed = false
  form.auto_start = false
  form.choose_type = 2
  form.auto_accept = true
  form.auto_kick = true
  form.auto_sit = true
  form.auto_switchparty = true
  form.last_map = nil
  form.cur_round = 0
  form.limit_round = 0
end

function on_escort_open(form)
	
	RefreshEscort(form)
end

function on_cbtn_accept(cbtn)
	local form = cbtn.ParentForm
	form.auto_accept = cbtn.Checked
end


function EscortClose(form)
  util_auto_show_hide_form(THIS_FORM)
  EscortStatus1()
end

function on_combobox_targetname_selected(boxitem)
  local form = boxitem.ParentForm
  form.choose_type = form.combobox_targetname.DropListBox.SelectIndex + 1
end


function on_btn_ok_click(btn)
  local form = btn.ParentForm
  StartEscort(form)
end

function on_cbtn_accept(cbtn)
	local form = cbtn.ParentForm
	form.auto_accept = cbtn.Checked
end

function on_cbtn_kick(cbtn)
	local form = cbtn.ParentForm
	form.auto_kick = cbtn.Checked
end
function on_cbtn_sit(cbtn)
	local form = cbtn.ParentForm
	form.auto_sit = cbtn.Checked
end
function on_cbtn_switchparty(cbtn)
	local form = cbtn.ParentForm
	form.auto_switchparty = cbtn.Checked
end



function RefreshEscort(form)
	local game_client = nx_value("game_client")
	if nx_is_valid(game_client) then 
		local scene = game_client:GetScene()
		if nx_is_valid(scene) then
			local cur_map = scene:QueryProp("Resource")
			if escort_point[cur_map] ~= nil then
				if form.last_map ~= cur_map then
					form.last_map = cur_map
				 	form.choose_type = 0
					form.combobox_targetname.DropListBox:ClearString()
				end
				form.combobox_targetname.DropListBox:ClearString()
				for r = 1, table.getn(escort_point[cur_map]["accept_type"]) do
					local location = "desc_escortendarea_0"..escort_point[cur_map]["accept_type"][r]
			    	form.combobox_targetname.DropListBox:AddString(util_text(location))
			    end
			    form.combobox_targetname.OnlySelect = true
			    if form.choose_type == 0 then 
			    	form.combobox_targetname.DropListBox.SelectIndex = 0
			    else 
					local gui = nx_value("gui")
					if gui ~= nil then
				    	form.combobox_targetname.InputEdit.Text = gui.TextManager:GetFormatText("desc_escortendarea_0"..escort_point[cur_map]["accept_type"][form.choose_type])
				    end
	    			form.combobox_targetname.DropListBox.SelectIndex = form.choose_type - 1
			    end
			else
				AutoSendMessage("Hiện tại không hỗ trợ map này")
				return 1
			end
		end
	end
end

function EscortStatus1()
local rbtn = nx_value(THIS_FORM)
local form = util_get_form(THIS_FORM, false, false)
if nx_is_valid(form) then
rbtn.rbtn_send.Checked = form.auto_accept
rbtn.rbtn_send_1.Checked = form.auto_kick
rbtn.rbtn_send_3.Checked = form.auto_switchparty
end
end
function UpdateEscortStatus()
	local form = util_get_form(THIS_FORM, false, false)
	
	if nx_is_valid(form) then

		if form.auto_start then 
			form.btn_ok.Text = nx_function("ext_utf8_to_widestr", "Bắt đầu")
		    form.auto_start = false
		    return
		else
			form.btn_ok.Text = nx_function("ext_utf8_to_widestr", "Kết thúc")
		    form.auto_start = true
		    form.cur_round = 0
		    form.limit_round = nx_number(form.ipt_limit_turn.Text)
		    form.lbl_limit_number.Text = nx_widestr(form.limit_round) -- số lượt còn lại
		    form.lbl_turn_number.Text = nx_widestr(form.cur_round) -- số lượt đã vận

		end
	end
end

function StartEscort(form)
	UpdateEscortStatus()
	while form.auto_start do
		nx_pause(1)
		local game_client = nx_value("game_client")
		local game_visual = nx_value("game_visual")
		if nx_is_valid(game_client) and nx_is_valid(game_visual) then

			local client_player = game_client:GetPlayer()
			local visual_player = game_visual:GetPlayer()
			local scene = game_client:GetScene()

			if nx_is_valid(visual_player) and nx_is_valid(client_player) and nx_is_valid(scene) then
				if nx_number(form.ipt_limit_turn.Text) <= 0 then
					AutoSendMessage("Vui lòng thiết lập số lần vận tiêu")
					UpdateEscortStatus()
					return
				end

				if nx_number(form.choose_type) <= 0 then
					AutoSendMessage("Vui lòng chọn địa điểm chuyến tiêu")
					UpdateEscortStatus()
					return
				end
				-- Check xem có phải là đội trưởng không ?
				if client_player:QueryProp("TeamCaptain") ~= client_player:QueryProp("Name") then
					nx_execute("custom_sender", "custom_leave_team")
					nx_pause(1)
					nx_execute("custom_sender", "custom_team_create")
					nx_pause(1)
					if form.auto_switchparty then nx_execute("custom_sender", "custom_change_team_type", nx_int(1)) end 
					
				end

				-- Phải mở password rương mới được auto
				if not client_player:FindProp("IsCheckPass") or client_player:QueryProp("IsCheckPass") ~= 1 then
					AutoSendMessage("Vui lòng mở khóa mật khẩu rương trước khi sử dụng")
					UpdateEscortStatus()
					return 
				end

				-- Check xem có ai offline không ?

				if form.auto_kick then
			        local party = client_player:GetRecordRows("team_rec")
					for r = 0, party - 1 do
						local team_name = client_player:QueryRecord("team_rec", r, 0)
						local map = client_player:QueryRecord("team_rec", r, 1)
						local offline = client_player:QueryRecord("team_rec", r, 5)
							if string.find(nx_string(map), nx_string(scene:QueryProp("Resource"))) == nil then
							AutoSendMessage(nx_string(team_name) .. " không ở cùng map, tự động kick")
							nx_execute("custom_sender", "custom_kickout_team", team_name)
						elseif offline ~= 0 then
							AutoSendMessage(nx_string(team_name) .. " đã offline, tự động kick")
							nx_execute("custom_sender", "custom_kickout_team", team_name)
							-------------
						elseif	not check_status(nx_widestr(team_name)) then 
						AutoSendMessage(nx_string(team_name) .. " đang bắt cóc ( or cướp tiêu ), tự động kick")
						nx_execute("custom_sender", "custom_kickout_team", team_name)
						------------
						end
					end
			    end

			    -- Auto accept
				if form.auto_accept then
					AutoAcceptParty()
				end

			    -- Check xem nhận tiêu hay chưa
				if not IsPlayerHaveBuff("buff_yunbiao_escortbuff") then
					local current_scene = scene:QueryProp("Resource")

					local start_x = nil
					local start_z = nil
					local npcname = 0
					local Escort_id = 0
					local nCarriageType = 0

					if nx_is_valid(form) then
						start_x = escort_point[form.last_map]["accept_point"][1]
						start_z = escort_point[form.last_map]["accept_point"][3]
						npcname = escort_point[current_scene]["accept_npc"]
						Escort_id = escort_point[form.last_map]["accept_type"][2]
						nCarriageType = 0
					else
						if escort_point[current_scene] ~= nil then
							start_x = escort_point[current_scene]["accept_point"][1]
							start_z = escort_point[current_scene]["accept_point"][3]
							npcname = escort_point[current_scene]["accept_npc"]
							Escort_id = escort_point[current_scene]["accept_type"][2]
							nCarriageType = 0
						else 
							AutoSendMessage("Hiện tại không hỗ trợ map này")
							UpdateEscortStatus()
							return 1
						end
					end

					if start_x ~= nil and start_z ~= nil then
						if GetDistanceBetweenTwoPoint(visual_player.PositionX, 0, visual_player.PositionZ, start_x, 0, start_z) <= 1 then
							nx_execute("custom_sender", "custom_request_start_escort", npcname, Escort_id, nCarriageType)
							nx_pause(2)
						else 
							if not nx_execute("util_move", "is_path_finding", visual_player) then
								nx_execute("hyperlink_manager", "find_path_npc_item", "findpath," .. current_scene .. "," .. start_x .. "," .. start_z)
							end
						end
					end
				else
					
				-- Check xem đã ngồi trên xe hay chưa ?
					if nx_find_custom(client_player, "vislink") and nx_is_valid(client_player.vislink) then
						local vis_link = client_player.vislink

						if vis_link ~= "0-0" then
							local form_escort_control = util_get_form("form_stage_main\\form_school_war\\form_escortnpc_control_list", true)
			 				if nx_is_valid(form_escort_control) and form_escort_control.Visible then
			 					form_escort_control.Visible = false
								form_escort_control:Close()
			 				end
							
						end
					else
						local row = client_player:GetRecordRows("escort_record")
						if nx_int(row) < nx_int(0) then
						    
						else
							
							local found_escort = false
							local teamid = client_player:QueryRecord("escort_record", 0, 0)
							local x = 0
							local z = 0
							local escort_object = GetEscortObject(teamid)

							if escort_object ~= nil then
								x = escort_object.DestX
								z = escort_object.DestZ
							else
								x = client_player:QueryRecord("escort_record", 0, 1)
								z = client_player:QueryRecord("escort_record", 0, 2) 
							end

							-- Khoảng cách gần 
							if x ~= 0 and z ~= 0 and GetDistanceBetweenTwoPoint(visual_player.PositionX, 0, visual_player.PositionZ, x, 0, z) <= 5 then

								-- Nếu form play game xuất hiện
							--	local form_escort_game = util_get_form("form_stage_main\\form_school_war\\form_escortnpc_control_game", true)
							--	if nx_is_valid(form_escort_game) and form_escort_game.Visible then
			  				--		nx_execute("custom_sender", "custom_escort_game_answer", 398, nx_string(form_escort_game.key_str))
						    --      util_show_form("form_stage_main\\form_school_war\\form_escortnpc_control_game", false)
							--	end
								-- Form quản lý lên xuống xe
								local form_escort_control = util_get_form("form_stage_main\\form_school_war\\form_escortnpc_control_list", true)
			 					if nx_is_valid(form_escort_control) and form_escort_control.Visible then
			 						nx_execute("custom_sender", "custom_request_escort_control", form_escort_control.obj, 1)
									form_escort_control.Visible = false
									form_escort_control:Close()
			 					end
			 					if nx_is_valid(escort_object) then
			 						nx_execute("custom_sender", "custom_select", escort_object.Ident) 
			 					end


							else
								if x ~= nil and z ~= nil and x ~= 0 and z ~= 0 and not nx_execute("util_move", "is_path_finding", visual_player) then
									nx_execute("hyperlink_manager", "find_path_npc_item", "findpath," .. scene:QueryProp("Resource") .. "," .. x .. "," .. z)
								end
							end
						end
					end

				end

			end
		end
	end
end
function backhoa()
  local game_client = nx_value("game_client")
  local client_player = game_client:GetPlayer()
  if not nx_is_valid(client_player) then
    return
  end
  local backhoa = client_player:QueryProp("TodayCapitalLeave1")
  return backhoa / 1000
end
function check_status(player_name)
  local team_manager = nx_value("team_manager")
  local record_table = team_manager:GetPlayerData(nx_widestr(player_name))
  if table.getn(record_table) > 0 then
    local buffers = record_table[7]
    str = tostring(nx_string(buffers))
    if string.find(str, "buf_abductor_0") ~= nil then -- bắt cóc
      return false
    elseif string.find(str, "buff_yunbiao_heistbuff_0") ~= nil then -- cướp phỉ
      return false
    else
      return true
    end
  end
  return false
end
function AutoAcceptParty()
  local request, player = nx_execute(FORM_MAIN_REQUEST, "find_team_request", REQUESTTYPE_TEAMREQUEST)
  if player ~= nil then
    nx_execute("custom_sender", "custom_request_answer", request, player, 1)
    nx_execute(FORM_MAIN_REQUEST, "clear_special_request", request)
  end
end
