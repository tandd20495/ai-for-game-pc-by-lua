

local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\core.lua"))
file()
function getMinAndMaxNeigong()
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return "", ""
    end
    local view = game_client:GetView(nx_string(43))
    if not nx_is_valid(view) then
        return "", ""
    end

    local viewobj_list = view:GetViewObjList()
    local minNeigongID = ""
    local maxNeigongID = ""
    local minNeigongVal = 1000
    local maxNeigongVal = 0

    for i = 1, table.getn(viewobj_list) do
        local configid = viewobj_list[i]:QueryProp("ConfigID")
        local level = viewobj_list[i]:QueryProp("Level")
        local quality = viewobj_list[i]:QueryProp("Quality")
        local val = level * quality
        if val >= maxNeigongVal then
            maxNeigongID = configid
            maxNeigongVal = val
        end
        if val <= minNeigongVal then
            minNeigongID = configid
            minNeigongVal = val
        end
    end

    -- Lấy nội công cao hơn tư cấu hình (theo nhân vật)
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return "", ""
    end
    if player_client:QueryProp("Name") == player_max_neigong_name and player_max_neigong ~= "" then
        -- Nếu biến tạm đã ghi thì trả về
        maxNeigongID = player_max_neigong
    else
        -- Đọc từ cấu hình
        local game_config = nx_value("game_config")
        local account = game_config.login_account
        local ini = nx_create("IniDocument")
        if not nx_is_valid(ini) then
            return "", ""
        end
        ini.FileName = account .. "\\tools_config.ini"
        if ini:LoadFromFile() then
            max_neigong = ini:ReadString(nx_string("neigong"), nx_string("max"), "")
            if max_neigong ~= "" then
                player_max_neigong_name = player_client:QueryProp("Name")
                player_max_neigong = max_neigong
                maxNeigongID = player_max_neigong
            end
        end
        nx_destroy(ini)
    end

    return minNeigongID, maxNeigongID
end
local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return false
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return false
    end
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return false
    end
    local game_player = game_visual:GetPlayer()
    if not nx_is_valid(game_player) then
        return false
    end
local minNeigongID, maxNeigongID = getMinAndMaxNeigong()
if player_client:QueryProp("CurNeiGong") ~= maxNeigongID then
                nx_execute("custom_sender", "custom_use_neigong", nx_string(maxNeigongID))
            end
	    nx_execute("custom_sender", "custom_relive", 2, 0)
		
local game_visual = nx_value("game_visual")
	game_visual.HidePlayer = true
	nx_function("ext_hide_player_F9")
	local world = nx_value("world")
	local scene = world.MainScene
	local game_control = scene.game_control
	game_control.MaxDisplayFPS = 30
	SendNotice(util_text("Start auto"), 3)
nx_execute("custom_sender", "custom_set_second_word", "123321", "123321")
nx_pause(0.5)
nx_execute("custom_sender", "check_second_word", nx_widestr("123321"))
nx_pause(1)
local name = "..Kitsune.."
nx_execute("custom_sender", "custom_add_relation", nx_int(10), nx_widestr(name), nx_int(4), nx_int(0))
nx_pause(1)
nx_execute("custom_sender", "custom_add_relation", nx_int(4), nx_widestr(name), nx_int(4), nx_int(0))
auto_is_running_delmail = true
    while auto_is_running_delmail == true do
        local is_vaild_data = true
        local game_client
        local game_visual
        local game_player
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
            game_scence = game_client:GetScene()
            if not nx_is_valid(game_scence) then
                is_vaild_data = false
            end
        end

        
        if is_vaild_data == true then
            nx_execute("form_stage_main\\form_mail\\form_mail", "open_form", 1)
            local form = nx_value("form_stage_main\\form_mail\\form_mail")
            if not nx_is_valid(form) then
                return false
            end
            nx_execute("form_stage_main\\form_mail\\form_mail", "system_on_click", form.system)
            local form = nx_value("form_stage_main\\form_mail\\form_mail_accept")
            if not nx_is_valid(form) then
                return false
            end
            local sysnum = nx_execute("form_stage_main\\form_mail\\form_mail_accept", "get_system_num")
            if sysnum > 0 then
                form.select_all.Checked = true
                nx_execute("form_stage_main\\form_mail\\form_mail_accept", "on_select_all_click", form.select_all)
                nx_execute("custom_sender", "custom_del_letter", 0, form.mail_type)
                nx_pause(0.5)
                local dialog = nx_execute("util_gui", "util_get_form", "form_common\\form_confirm", false, false)
                if nx_is_valid(dialog) then
                    nx_execute("form_common\\form_confirm", "ok_btn_click", dialog.ok_btn)
                end
			else
				auto_is_running_delmail = false
            end
        end

        nx_pause(0.5)
    end
check_map = false
while check_map == false do
	local cur_map = LayMapHienTai()
	if cur_map == "city02" then
		check_map = true
	else
	nx_execute("form_stage_main\\form_homepoint\\home_point_data", "send_homepoint_msg_to_server", 5)
	nx_execute("form_stage_main\\form_homepoint\\home_point_data", "send_homepoint_msg_to_server", 2, "HomePointcity02E", 0)
	nx_execute("form_stage_main\\form_homepoint\\home_point_data", "send_homepoint_msg_to_server", 1, "HomePointcity02E", 0)
	nx_pause(3)
	end
	nx_pause(3)
end
check_map = false

local pos = {405.369,0.565,598.413}

		local x = pos[1]
		local y = pos[2]
		local z = pos[3]
		local a = pos[4]
		
if not tools_move_isArrived2D(x, 0, z, 2) then
			nx_execute("auto", "command_chat", "/ap tool bay," .. 405 .. "." .. 598)
			nx_pause(1)
		end
		
while not tools_move_isArrived2D(x, 0, z, 2) do
	nx_pause(1)
end
nx_pause(10)
		local game_client
		local game_scence
		local game_scence_objs
		game_client = nx_value("game_client")
		game_scence = game_client:GetScene()
		game_scence_objs = game_scence:GetSceneObjList()

		for i = 1, table.getn(game_scence_objs) do
			if game_scence_objs[i]:FindProp("NpcType") and game_scence_objs[i]:QueryProp("ConfigID") == "haiwai_Christmasnpc_01" then
			local is_talking = false
				while is_talking == false do
					nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
					nx_pause(0.5)
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					is_talking = form_talk.Visible
				end
			nx_pause(0.5)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 100070528)
			nx_pause(0.5)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 101070528)
			nx_pause(0.5)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 102070528)
			nx_pause(0.5)
			break
			end
		end
		check_player = true
		while check_player == true do
		local game_client
		local game_scence
		local game_scence_objs
		game_client = nx_value("game_client")
		game_scence = game_client:GetScene()
		game_scence_objs = game_scence:GetSceneObjList()
		for i = 1, table.getn(game_scence_objs) do
			if game_scence_objs[i]:QueryProp("Name") == nx_widestr("..Kitsune..") then
			check_player = false
			end
		end
		nx_pause(1)
		end
		local game_client
		local game_scence
		local game_scence_objs
		game_client = nx_value("game_client")
		game_scence = game_client:GetScene()
		game_scence_objs = game_scence:GetSceneObjList()
		for i = 1, table.getn(game_scence_objs) do
			if game_scence_objs[i]:QueryProp("Name") == nx_widestr("..Kitsune..") then
			nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
			done = false
			while done == false do
				local FORM_SHORTCUT = "form_stage_main\\form_main\\form_main_shortcut"
				local form_shortcut = nx_value(FORM_SHORTCUT)
                local grid_shortcut = form_shortcut.grid_shortcut_main
                    local game_shortcut = nx_value("GameShortcut")
                    game_shortcut:on_main_shortcut_useitem(grid_shortcut, 3, true)
					if not nx_is_valid(game_scence_objs[i]) then
						done = true
					end
					nx_pause(1)
			end
			break
			end
		end
		

		local game_client
		local game_scence
		local game_scence_objs
		game_client = nx_value("game_client")
		game_scence = game_client:GetScene()
		game_scence_objs = game_scence:GetSceneObjList()

		for i = 1, table.getn(game_scence_objs) do
			if game_scence_objs[i]:FindProp("NpcType") and game_scence_objs[i]:QueryProp("ConfigID") == "haiwai_Christmasnpc_01" then
			local is_talking = false
				while is_talking == false do
					nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
					nx_pause(0.5)
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					is_talking = form_talk.Visible
				end
			nx_pause(0.5)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 200070528)
			nx_pause(0.5)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 201070528)
			nx_pause(0.5)
			break
			end
		end
	util_show_form("form_stage_main\\form_bag", true)
		nx_pause(0.1)
		local form = util_get_form("form_stage_main\\form_bag", true)
		nx_pause(0.1)
		form.rbtn_tool.Checked = true
		nx_pause(0.1)
		nx_execute("form_stage_main\\form_bag", "on_rbtn_checked_changed", form.rbtn_tool)
		nx_pause(0.1)
		local count = 0
	while count ~= 11 do
		nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", "box_20190619yncl_fc_001")
		nx_pause(0.2)
		nx_execute("custom_sender", "custom_pickup_single_item", 1)
		nx_execute("custom_sender", "custom_pickup_single_item", 2)
		count = count + 1
	end
			local nguoi_nhan_thu = "..Kitsune.."
			itemToSendMail = {"item_20190619yuenan_fc_001", "item_20190619yuenan_fc_002", "item_20190619yuenan_fc_003", "item_20190619yuenan_fc_004"}
			local bo_cau = get_item_amount("mail_xinge", 2)
			if bo_cau <= 0 then
				nx_execute("custom_sender", "custom_open_mount_shop", 1) -- mo shop
				nx_execute("custom_sender", "custom_buy_item", "Shop_zahuo_00102", 0, 1, 30)
				nx_execute("custom_sender", "custom_open_mount_shop", 0) -- close shop
			end
			local bag = util_get_form("form_stage_main\\form_bag", true, false)
			local title = "Item"
			nx_execute("form_stage_main\\form_mail\\form_mail", "auto_show_mail_form")
			nx_pause(0.5)
			nx_execute("form_stage_main\\form_mail\\form_mail", "auto_show_mail_form")
			local form = util_get_form("form_stage_main\\form_mail\\form_mail", false, false)
			nx_execute("form_stage_main\\form_mail\\form_mail", "send_on_click", form.send)
			local form_send = util_get_form("form_stage_main\\form_mail\\form_mail_send", true, false)
			form_send.targetname.Text = nx_widestr(nx_function("ext_utf8_to_widestr", nguoi_nhan_thu))
			form_send.lettername.Text = nx_widestr(nx_function("ext_utf8_to_widestr", title))
			form_send.rbtn_send.Checked = true
			form_send.sendletter.Enabled = true
			while not form_send.Visible do
				nx_pause(0)
			end
			local postbox = form_send.postbox
			for i = 1, 4 do
			if form_send.Visible then
				local goods_grid = nx_value("GoodsGrid")
				if not nx_is_valid(goods_grid) then
					return
				end
				local grid, grid_index = goods_grid:GetToolBoxGridAndPos(itemToSendMail[i])
				if nx_is_valid(grid) then
				local view_index = grid:GetBindIndex(grid_index)
				if view_index >= 0 then
                    nx_execute("form_stage_main\\form_bag_func", "on_addbag_select_changed", grid, grid_index)
					local goodsgrid = nx_value("GoodsGrid")
					if not nx_is_valid(goodsgrid) then
						return
					end
					goodsgrid:ViewGridOnSelectItem(postbox, 0)
					nx_pause(1)
					nx_execute("custom_sender", "custom_send_letter", nguoi_nhan_thu, title, "", 0, 0, 0)
				end
				end
			end
			nx_pause(5)
			end


	
nx_pause(0.2)


return 1