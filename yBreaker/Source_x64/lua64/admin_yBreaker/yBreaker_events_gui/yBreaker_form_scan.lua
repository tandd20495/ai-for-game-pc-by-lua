require("util_gui")
require("util_move")
require("util_functions")
require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")

-- Initialize skin path for form
local THIS_FORM = "admin_yBreaker\\yBreaker_form_scan"
local is_running_scan_player = false -- Quét người chơi

-- Set value default
function on_form_main_init(form)
	form.Fixed = false
	form.is_minimize = false
end

-- Handle event main form of yBreaker
function on_main_form_open(form)
	init_grid(form)
	change_form_size()
	form.is_minimize = false
	form.chk_fil_self.Checked = true
end

--
function on_main_form_close(form)
	is_running_scan_player = false
	nx_destroy(form)
end

--
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

function init_grid(form)
  form.info_grid_details.ColCount = 4
  form.info_grid_details:SetColAlign(0, "left")
  form.info_grid_details:SetColAlign(1, "center")
  form.info_grid_details:SetColAlign(2, "center")
  form.info_grid_details:SetColAlign(3, "center")
  --form.info_grid_details:SetColAlign(4, "center")
  form.info_grid_details:SetColWidth(0, form.btn_name.Width)
  --form.info_grid_details:SetColWidth(1, form.btn_guild.Width)
  form.info_grid_details:SetColWidth(1, form.btn_party.Width)
  form.info_grid_details:SetColWidth(2, form.btn_member.Width)
  form.info_grid_details:SetColWidth(3, form.btn_targeted.Width)
end

--
function on_btn_close_click(btn)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end

-- Show/hide main form scan
function show_hide_form_scan()
	util_auto_show_hide_form(THIS_FORM)
end

-- Add information of player on grid
function add_row_info_grid(player_name, player_party, player_member, player_targeted)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	
	local row = form.info_grid_details:InsertRow(-1)
	form.info_grid_details:BeginUpdate()
	-- form.info_grid_details:InsertRow(row)
	form.info_grid_details:SetGridText(row, 0, nx_widestr(player_name))
	form.info_grid_details:SetGridText(row, 1, nx_widestr(player_party))
	form.info_grid_details:SetGridText(row, 2, nx_widestr(player_member))
	form.info_grid_details:SetGridText(row, 3, nx_widestr(player_targeted))
	form.info_grid_details:EndUpdate()
end

-- Handle button Tìm Người
function on_click_btn_refresh(btn)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	
    if is_running_scan_player then
        is_running_scan_player = false
        form.btn_refresh.Text = nx_function("ext_utf8_to_widestr", "Tìm Người")
		form.btn_refresh.ForeColor = "255,255,255,255"
		--form.info_grid_details:ClearRow()
    else
        is_running_scan_player = true
        form.btn_refresh.Text = nx_function("ext_utf8_to_widestr", "Dừng Lại")
		form.btn_refresh.ForeColor = "255,220,20,60"
		
		-- Function main of scan
        scan_player_around()
    end
end

-- Function main for scan player
function scan_player_around()
    while is_running_scan_player == true do
        local is_vaild_data = true
        local game_client
        local game_visual
        local game_player
        local player_client
        local game_scence

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
        local form = nx_value(THIS_FORM)
        if not nx_is_valid(form) then
            is_vaild_data = false
        end

        if is_vaild_data == true then
            local game_scence_objs = game_scence:GetSceneObjList()
            local num_objs = table.getn(game_scence_objs)

			-- Clear data
			form.info_grid_details:ClearRow()
			
			for i = 1, num_objs do
				local obj_type = 0
				if game_scence_objs[i]:FindProp("Type") then
					obj_type = game_scence_objs[i]:QueryProp("Type")
				end
				if obj_type == 2 and game_scence_objs[i]:QueryProp("OffLineState") == 0 then
					local name_player = game_scence_objs[i]:QueryProp("Name")
					--local guild_player = game_scence_objs[i]:QueryProp("GuildName")
					local party_player = game_scence_objs[i]:QueryProp("TeamCaptain")
					local cnt_member = game_scence_objs[i]:QueryProp("TeamMemberCount")
					local select_target_ident = game_scence_objs[i]:QueryProp("LastObject")
					
					-- Set empty
					local name_target_this_player = nx_function("ext_utf8_to_widestr", "-")
					
					-- Set chuỗi rỗng cho bang hội/ tổ đội
					--if 	guild_player == 0 then
					--	guild_player = nx_function("ext_utf8_to_widestr", "-")
					--end
					if  party_player == 0 then
						party_player = nx_function("ext_utf8_to_widestr", "-")
					end
					if 	select_target_ident == 0 or nx_widestr(select_target_ident) == nx_widestr("0-0") then
						name_target_this_player = nx_function("ext_utf8_to_widestr", "-")
					end
					
					-- Mode: Chọn bạn (chỉ add tối tượng đang chọn bạn)
					if form.chk_fil_self.Checked then
					
						--// Get target của đối tượng
						-- Get lastobject của đối tượng (a) target
						-- Dùng lastobject này để get name người chơi (b) đó
						-- Dùng name người chơi b để add vào grid
						local select_target = game_client:GetSceneObj(nx_string(select_target_ident))
						if nx_is_valid(select_target) then
						
							-- Đối tượng target bạn
							if nx_widestr(player_client:QueryProp("Name")) == nx_widestr(select_target:QueryProp("Name")) then
								name_target_this_player = nx_function("ext_utf8_to_widestr", "Chọn bạn")
								
								-- Không add bản thân vào
								if nx_widestr(game_scence_objs[i]:QueryProp("Name")) ~= nx_widestr(player_client:QueryProp("Name")) then
									-- Add object
									add_row_info_grid(name_player, party_player, cnt_member, name_target_this_player)
								end
							end
						end
					else -- Mode: Add all
						--// Get target của đối tượng
						-- Get lastobject của đối tượng (a) target
						-- Dùng lastobject này để get name người chơi (b) đó
						-- Dùng name người chơi b để add vào grid
						local select_target = game_client:GetSceneObj(nx_string(select_target_ident))
						if nx_is_valid(select_target) then
							-- Không add text NPC mà đối tượng đang target
							if select_target:QueryProp("Name") ~= 0 then
								name_target_this_player = select_target:QueryProp("Name")
							end
						end
						
						-- Đối tượng target bạn
						if nx_widestr(player_client:QueryProp("Name")) == nx_widestr(name_target_this_player) then
							name_target_this_player = nx_function("ext_utf8_to_widestr", "Chọn bạn")
						end

						-- Không add bản thân vào
						if nx_widestr(game_scence_objs[i]:QueryProp("Name")) ~= nx_widestr(player_client:QueryProp("Name")) then

							-- Add object
							add_row_info_grid(name_player, party_player, cnt_member, name_target_this_player)
						end
					end
				end
			end
			
        end
        nx_pause(1)
    end
end