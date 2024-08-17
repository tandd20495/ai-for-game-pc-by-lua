require("util_gui")
require("util_move")
require("util_functions")
require("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs")
require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")
require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_util")

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
	form.chk_other.Checked = false
	form.chk_zither.Checked = false
	form.chk_fil_self.Checked = false
	form.lbl_title.Text = ""
	form.btn_refresh.Text = nx_function("ext_utf8_to_widestr", "Chạy")
end

--
function on_main_form_close(form)
	is_running_scan_player = false
	nx_destroy(form)
	
	-- Close form other
	local form_other = nx_value("admin_yBreaker\\yBreaker_form_scan_other")
	if not nx_is_valid(form_other) then
		return
	end
	nx_destroy(form_other)
	
	util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_boombuff")
end

--
function change_form_size()
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	local gui = nx_value("gui")
	--form.Left = (gui.Width - form.Width) / 2
	--form.Top = (gui.Height - form.Height) / 2
	form.Left = 1574
	form.Top = 542
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
	form.info_grid_details:SetGridText(row, 0, nx_widestr(player_name))
	form.info_grid_details:SetGridText(row, 1, nx_widestr(player_party))
	form.info_grid_details:SetGridText(row, 2, nx_widestr(player_member))
	form.info_grid_details:SetGridText(row, 3, nx_widestr(player_targeted))
	form.info_grid_details:EndUpdate()
end

function on_info_grid_details_select_grid(grid, row)
  local form = grid.ParentForm
  form.cur_selected_index = row
  target_show_trace_on_map(row)
end

-- Handle button Tìm Người
function on_click_btn_refresh(btn)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	
    if is_running_scan_player then
        is_running_scan_player = false
        form.btn_refresh.Text = nx_function("ext_utf8_to_widestr", "Chạy")
		form.btn_refresh.ForeColor = "255,255,255,255"
		--form.info_grid_details:ClearRow()
    else
        is_running_scan_player = true
        form.btn_refresh.Text = nx_function("ext_utf8_to_widestr", "Dừng")
		form.btn_refresh.ForeColor = "255,220,20,60"
		
		-- Option scan
		if form.chk_other.Checked then 
			-- Function main of scan custom
			scan_custom()
		else
			-- Function main of scan player
			scan_player_around()
		end
    end
end

-- Handle event for checkbox
function on_chk_zither_changed(chkbtn)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	
	-- Set status for checkbox
	if form.chk_zither.Checked then
		form.chk_fil_self.Visible = false
		form.lbl_fil_self.Visible = false
		
		form.chk_other.Visible = false
		form.lbl_other.Visible = false
	else
		form.chk_fil_self.Visible = true
		form.lbl_fil_self.Visible = true
		
		form.chk_other.Visible = true
		form.lbl_other.Visible = true
	end
end

-- Handle event for checkbox
function on_chk_self_changed(chkbtn)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	
	-- Set status for checkbox
	if form.chk_fil_self.Checked then
		form.chk_zither.Visible = false
		form.lbl_zither.Visible = false
		
		form.chk_other.Visible = false
		form.lbl_other.Visible = false
	else
		form.chk_zither.Visible = true
		form.lbl_zither.Visible = true
		
		form.chk_other.Visible = true
		form.lbl_other.Visible = true
	end
end

-- Handle event for checkbox
function on_chk_other_changed(chkbtn)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	
	util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_scan_other")
	util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_boombuff")
	
	-- Set status for checkbox
	if form.chk_other.Checked then
		form.chk_zither.Visible = false
		form.lbl_zither.Visible = false
		
		form.chk_fil_self.Visible = false
		form.lbl_fil_self.Visible = false
		
		-- Function main of scan custom -- Vẫn còn giật do vào hàm này lại- Có thể xử lý cho dừng chạy để khởi động lại
		scan_custom()
		
	else
		form.chk_zither.Visible = true
		form.lbl_zither.Visible = true
		
		form.chk_fil_self.Visible = true
		form.lbl_fil_self.Visible = true
		
		-- Function main for scan player
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
				
				-- Mode tìm ĐÀN
				if form.chk_zither.Checked then
					-- Tìm người chơi và không offline
					if obj_type == 2 and game_scence_objs[i]:FindProp("GameState") and game_scence_objs[i]:QueryProp("GameState") == "QinGameModule" then
						local name_player = game_scence_objs[i]:QueryProp("Name")
						--local guild_player = game_scence_objs[i]:QueryProp("GuildName")
						local party_player = game_scence_objs[i]:QueryProp("TeamCaptain")
						local cnt_member = game_scence_objs[i]:QueryProp("TeamMemberCount")
						local select_target_ident = game_scence_objs[i]:QueryProp("LastObject")
						
						-- Get tọa độ X/Z
						local zither_posX = string.format("%.0f", game_scence_objs[i].PosiX)
						local zither_posZ = string.format("%.0f", game_scence_objs[i].PosiZ)
						
						-- Set empty
						local name_target_this_player = nx_function("ext_utf8_to_widestr", "Đàn")
						
						-- Set chuỗi rỗng cho bang hội/ tổ đội
						--if 	guild_player == 0 then
						--	guild_player = nx_function("ext_utf8_to_widestr", "-")
						--end
						if  party_player == 0 then
							party_player = nx_function("ext_utf8_to_widestr", "-")
						end
						-- Đang ở mode đàn set mặc định mục tiêu là Đàn
						if 	select_target_ident == 0 or nx_widestr(select_target_ident) == nx_widestr("0-0") then
							name_target_this_player = nx_function("ext_utf8_to_widestr", "Đàn")
						end
						
						--local txt_chat = nx_value("gui").TextManager:GetFormatText(nx_string('(<a href="findpath,{@0:scene},{@3:x},{@4:y},{@5:z},{@6:ident}" style="HLStype1">{@1:x},{@2:z}</a>)'), nx_widestr(zither_posX), nx_widestr(zither_posZ), nx_widestr(yBreaker_get_current_map()), nx_widestr(pathX), nx_widestr(pathY), nx_widestr(pathZ), nx_widestr(zither_ident))
						local txt_chat = nx_string(" (" .. nx_string(zither_posX) .. "," .. nx_string(zither_posZ) .. ")")
						
						name_target_this_player = nx_string(name_target_this_player) .. nx_string(txt_chat)

						-- Không add bản thân vào
						if nx_widestr(game_scence_objs[i]:QueryProp("Name")) ~= nx_widestr(player_client:QueryProp("Name")) then

							-- Add object
							add_row_info_grid(name_player, party_player, cnt_member, name_target_this_player)
						end
					end
				end
				
				-- Mode tìm NGƯỜI
				if form.chk_other.Checked == false and form.chk_zither.Checked == false then 
				
					-- Tìm người chơi và không offline
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
			
        end
        nx_pause(1)
    end
end

-- Target object / show trace on map when select on grid
function target_show_trace_on_map(row)
	local is_vaild_data = true
	local game_client
	local game_visual
	local game_player
	local player_client
	local game_scence
	
	if row < 0 then
		return
	end

	game_client = nx_value("game_client")
	if not nx_is_valid(game_client) then
		is_vaild_data = false
	end
	
	game_visual = nx_value("game_visual")
	if not nx_is_valid(game_visual) then
		is_vaild_data = false
	end
	
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

	if is_vaild_data == true then
		local game_scence_objs = game_scence:GetSceneObjList()
		local num_objs = table.getn(game_scence_objs)
		
		for i = 1, num_objs do
			local obj_type = 0
			if game_scence_objs[i]:FindProp("Type") then
				obj_type = game_scence_objs[i]:QueryProp("Type")
			end
			if obj_type == 2 and game_scence_objs[i]:QueryProp("OffLineState") == 0 then
				local name_player = game_scence_objs[i]:QueryProp("Name")
				local form_grid = nx_value(THIS_FORM)
				
				if nx_is_valid(form_grid) then
					local object_name_on_grid = form_grid.info_grid_details:GetGridText(row, 0) -- Get name on grid
				
					-- Đúng đối tượng thì select
					if  nx_widestr(name_player) ~= "" and nx_widestr(object_name_on_grid) ~= "" and  
						nx_widestr(object_name_on_grid) == nx_widestr(name_player) then
						
						-- Select đối tượng nếu đối tượng tồn tại
						nx_execute('custom_sender', 'custom_select', game_scence_objs[i].Ident)
						
						-- Lấy vị trí đối tượng
						--local object_posX = string.format("%.0f", game_scence_objs[i].PosiX)
						--local object_posY = string.format("%.0f", game_scence_objs[i].PosiY)
						--local object_posZ = string.format("%.0f", game_scence_objs[i].PosiZ) -- Lấy tọa độ chẵn
						--
						--local pathX = game_scence_objs[i].DestX
						--local pathY = game_scence_objs[i].DestY
						--local pathZ = game_scence_objs[i].DestZ -- Lấy tọa độ lẽ
						--yBreaker_show_Utf8Text("object_posX: " .. nx_string(object_posX) .. "pathX:" .. nx_string(pathX))
						-- Vẽ trace trên map khi form tồn tại
						--local FORM_MAP_SCENE = nx_value("form_stage_main\\form_map\\form_map_scene")
						--if nx_is_valid(FORM_MAP_SCENE) then
						--	if FORM_MAP_SCENE.Visible then
						--		yBreaker_show_Utf8Text("chưa vẽ trace: ")
						--		FORM_MAP_SCENE.btn_trace.x = object_posX
						--		FORM_MAP_SCENE.btn_trace.y = object_posY
						--		FORM_MAP_SCENE.btn_trace.z = object_posZ
						--	else
						--		yBreaker_show_Utf8Text("Bật MAP lên để thấy vị trí đối tượng đã chọn!")
						--	end
						--end 	
					end
				end
			end
		end
		
	end
end

-- Get name myself
function getName_myself()
    local player = nx_value("game_client"):GetPlayer()
    if not nx_is_valid(player) then
        return 0
    end
    local name_myself = player:QueryProp("Name")
    return name_myself
end

local TablePlayerList = {}
local nPlayer = 1

-- Load player list from ini file
function load_player_list()
    TablePlayerList = {}

    local playerStr = IniReadUserConfig("Scan_Player", "PlayerList", "")
	
    if playerStr ~= "" then
        local pLst = util_split_string(nx_string(playerStr), ";")
        for i = 1, #pLst do
			table.insert(TablePlayerList, pLst[i])
        end
    end
end

local TableGuildList = {}
local nGuild = 1
-- Load player list from ini file
function load_guild_list()
    TableGuildList = {}

    local playerStr = IniReadUserConfig("Scan_Guild", "GuildList", "")
	
    if playerStr ~= "" then
        local pLst = util_split_string(nx_string(playerStr), ";")
        for i = 1, #pLst do
			table.insert(TableGuildList, pLst[i])
        end
    end
end

local TableBuffList = {}
local nBuff = 1
-- Load player list from ini file
function load_buff_list()
    TableBuffList = {}

    local playerStr = IniReadUserConfig("Scan_Buff", "BuffList", "")
	
    if playerStr ~= "" then
        local pLst = util_split_string(nx_string(playerStr), ";")
        for i = 1, #pLst do
			table.insert(TableBuffList, pLst[i])
        end
    end
end

-- Scan for player/guild/buff
function scan_custom()
	-- Load config player/ guild/ buff list
	load_player_list()
	load_guild_list()
	load_buff_list()
	
	--yBreaker_show_Utf8Text("scan_custom")
	
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
        local form_other = nx_value("admin_yBreaker\\yBreaker_form_scan_other")
        if not nx_is_valid(form_other) then
            is_vaild_data = false
        end
		
		local form_main = nx_value(THIS_FORM)
        if not nx_is_valid(form_main) then
            is_vaild_data = false
        end

        if is_vaild_data == true then
            local game_scence_objs = game_scence:GetSceneObjList()
            local num_objs = table.getn(game_scence_objs)

			-- Clear data
			form_main.info_grid_details:ClearRow()
			--yBreaker_show_Utf8Text("ClearRow()")
			
			for i = 1, num_objs do
				local obj_type = 0
				if game_scence_objs[i]:FindProp("Type") then
					obj_type = game_scence_objs[i]:QueryProp("Type")
				end
				
				-- Mode tìm danh sách tên
				if nx_is_valid(form_other) and form_other.chk_player.Checked then
					-- Tìm người chơi và không offline
					if obj_type == 2 and game_scence_objs[i]:QueryProp("OffLineState") == 0 then
						local name_player = game_scence_objs[i]:QueryProp("Name")
						--local guild_player = game_scence_objs[i]:QueryProp("GuildName")
						local party_player = game_scence_objs[i]:QueryProp("TeamCaptain")
						local cnt_member = game_scence_objs[i]:QueryProp("TeamMemberCount")
						local select_target_ident = game_scence_objs[i]:QueryProp("LastObject")
						
						-- Get tọa độ X/Z
						local zither_posX = string.format("%.0f", game_scence_objs[i].PosiX)
						local zither_posZ = string.format("%.0f", game_scence_objs[i].PosiZ)
						
						-- Set empty
						local name_target_this_player = nx_function("ext_utf8_to_widestr", "-")
						
						-- Set chuỗi rỗng cho bang hội/ tổ đội
						--if 	guild_player == 0 then
						--	guild_player = nx_function("ext_utf8_to_widestr", "-")
						--end
						if  party_player == 0 then
							party_player = nx_function("ext_utf8_to_widestr", "-")
						end
						-- Đang ở mode đàn set mặc định mục tiêu là 
						if 	select_target_ident == 0 or nx_widestr(select_target_ident) == nx_widestr("0-0") then
							name_target_this_player = nx_function("ext_utf8_to_widestr", "-")
						end
						
						-- Duyệt danh sách tên người chơi
						for iplayer = nPlayer , #TablePlayerList do
							
							if nx_string(name_player) == nx_string(TablePlayerList[iplayer]) then
								local select_target = game_client:GetSceneObj(nx_string(select_target_ident))
								if nx_is_valid(select_target) then
									-- Không add text NPC mà đối tượng đang target
									if select_target:QueryProp("Name") ~= 0 then
										name_target_this_player = select_target:QueryProp("Name")
									end
								end
								
								-- Đối tượng target bạn
								local name_myself = getName_myself()
								if nx_widestr(name_myself) == nx_widestr(name_target_this_player) then
									name_target_this_player = nx_function("ext_utf8_to_widestr", "Chọn bạn")
								end
								
								--Lấy khoảng cách từ nhân vật tới mục tiêu đang chọn
								local visualObj = game_visual:GetSceneObj(game_scence_objs[i].Ident)
								local dist_player = getDistanceWithObj({game_player.PositionX, game_player.PositionY, game_player.PositionZ}, visualObj)
								
								-- Set position between player
								local dist_p = nx_string(nx_int(dist_player)) .. "m"
							
								-- Không add bản thân vào
								if nx_widestr(game_scence_objs[i]:QueryProp("Name")) ~= nx_widestr(player_client:QueryProp("Name")) then

									-- Add object
									add_row_info_grid(name_player, party_player, dist_p, name_target_this_player)
								end
							end
						end
					end
				end
				-- Mode tìm theo Bang
				if nx_is_valid(form_other) and form_other.chk_guild.Checked then
				
					-- Tìm người chơi và không offline
					if obj_type == 2 and game_scence_objs[i]:QueryProp("OffLineState") == 0 then
						local name_player = game_scence_objs[i]:QueryProp("Name")
						local guild_player = game_scence_objs[i]:QueryProp("GuildName")
						local party_player = game_scence_objs[i]:QueryProp("TeamCaptain")
						local cnt_member = game_scence_objs[i]:QueryProp("TeamMemberCount")
						local select_target_ident = game_scence_objs[i]:QueryProp("LastObject")
						
						-- Set empty
						local name_target_this_player = nx_function("ext_utf8_to_widestr", "-")
						
						-- Set chuỗi rỗng cho bang hội/ tổ đội
						if 	guild_player == 0 then
							guild_player = nx_function("ext_utf8_to_widestr", "-")
						end
						--if  party_player == 0 then
						--	party_player = nx_function("ext_utf8_to_widestr", "-")
						--end
						if 	select_target_ident == 0 or nx_widestr(select_target_ident) == nx_widestr("0-0") then
							name_target_this_player = nx_function("ext_utf8_to_widestr", "-")
						end
						
						-- Duyệt danh sách tên người chơi
						for iguild = nGuild , #TableGuildList do
							-- Check guild
							if nx_string(guild_player) == nx_string(TableGuildList[iguild]) then
								local select_target = game_client:GetSceneObj(nx_string(select_target_ident))
								if nx_is_valid(select_target) then
									-- Không add text NPC mà đối tượng đang target
									if select_target:QueryProp("Name") ~= 0 then
										name_target_this_player = select_target:QueryProp("Name")
									end
								end
								
								-- Đối tượng target bạn
								local name_myself = getName_myself()
								if nx_widestr(name_myself) == nx_widestr(name_target_this_player) then
									name_target_this_player = nx_function("ext_utf8_to_widestr", "Chọn bạn")
								end
								
								--Lấy khoảng cách từ nhân vật tới mục tiêu đang chọn
								local visualObj = game_visual:GetSceneObj(game_scence_objs[i].Ident)
								local dist_player = getDistanceWithObj({game_player.PositionX, game_player.PositionY, game_player.PositionZ}, visualObj)
								
								-- Set position between player
								local dist_p = nx_string(nx_int(dist_player)) .. "m"
							
								-- Không add bản thân vào
								if nx_widestr(game_scence_objs[i]:QueryProp("Name")) ~= nx_widestr(player_client:QueryProp("Name")) then

									-- Add object
									add_row_info_grid(name_player, guild_player, dist_p, name_target_this_player)
								end
							end
						end
					end
				end
				
				-- Mode tìm theo Buff
				if nx_is_valid(form_other) and form_other.chk_buff.Checked then
					-- Tìm người chơi và không offline
					if obj_type == 2 and game_scence_objs[i]:QueryProp("OffLineState") == 0 then
						local name_player = game_scence_objs[i]:QueryProp("Name")
						local guild_player = game_scence_objs[i]:QueryProp("GuildName")
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
						
						-- Duyệt danh sách buff của đối tượng
						for ibuff = nBuff , #TableBuffList do
							-- Check BUFF
							if nx_function("find_buffer", game_scence_objs[i], nx_string(TableBuffList[ibuff])) then
								--local select_target = game_client:GetSceneObj(nx_string(select_target_ident))
								--if nx_is_valid(select_target) then
								--	-- Không add text NPC mà đối tượng đang target
								--	if select_target:QueryProp("Name") ~= 0 then
								--		name_target_this_player = select_target:QueryProp("Name")
								--	end
								--end
								--
								---- Đối tượng target bạn
								--local name_myself = getName_myself()
								--if nx_widestr(name_myself) == nx_widestr(name_target_this_player) then
								--	name_target_this_player = nx_function("ext_utf8_to_widestr", "Chọn bạn")
								--end
								
								--Lấy khoảng cách từ nhân vật tới mục tiêu đang chọn
								local visualObj = game_visual:GetSceneObj(game_scence_objs[i].Ident)
								local dist_player = getDistanceWithObj({game_player.PositionX, game_player.PositionY, game_player.PositionZ}, visualObj)
								
								-- Set position between player
								local dist_p = nx_string(nx_int(dist_player)) .. "m"
							
								-- Không add bản thân vào
								if nx_widestr(game_scence_objs[i]:QueryProp("Name")) ~= nx_widestr(player_client:QueryProp("Name")) then

									-- Add object
									add_row_info_grid(name_player, util_text(TableBuffList[ibuff]), dist_p, name_target_this_player)
								end
							end
						end
					end
				end
			end
        end
        nx_pause(1)
    end
end
