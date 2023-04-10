require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")
require("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs")
local item = {}
local is_running_zither = false	

function main_form_init(form)
  form.Fixed = false
  form.select_index = 0
  form.select_item = ""
  form.num_repeated = 0
  form.auto_start = false
  
  local gui = nx_value("gui")
  form.Left = 100
  form.Top = (gui.Height / 2)
end
function on_main_form_open(form)
  init_ui_content(form)
end

function init_ui_content(form)	
  if nx_execute("form_stage_main\\form_life\\form_job_main_new", "find_life_job", "sh_qs") then
    form.btn_start_stop.Enabled = true   
  	form.cbx_zither_load.InputEdit.Text = "not"
	form.cbx_zither_load.DropListBox:ClearString()
	if auto_zither_id_list == nil then
		auto_zither_id_list = {}
	end
	loadzither()
	loadzitherConfig(form.cbx_zither_load)
  else
	form.lbl_notice.Visible = true
	form.lbl_notice.Text = nx_function("ext_utf8_to_widestr", "Không phải Cầm Sư!")
	form.lbl_notice.ForeColor = "255,255,0,0"
	
	form.cbx_zither_load.Visible = false
    form.btn_start_stop.Visible = false
  end
	if not form.auto_start then
		form.btn_start_stop.Text = util_text("ui_begin")
	else
		form.btn_start_stop.Text = util_text("ui_off_end")
	end
	-- Default training is disable
	form.cb_train.Checked = false
end

function loadzitherConfig(cbx)
  cbx.DropListBox:ClearString()
  cbx.InputEdit.Text = ""
  if auto_zither_id_list == nil or table.getn(auto_zither_id_list) == 0 then
    return
  end
    item = {}
  	getitem()
  for i = 1, table.getn(auto_zither_id_list) do
    cbx.DropListBox:AddString(auto_zither_id_list[i].name)	
  end
  cbx.DropListBox.SelectIndex = 0
  cbx.InputEdit.Text = cbx.DropListBox:GetString(0)
end
function loadzither()
	local job_info_ini = nx_execute("util_functions", "get_ini", "share\\Life\\job_info.ini")
	if not nx_is_valid(job_info_ini) then return end
	local gather_ini = nx_execute("util_functions", "get_ini", "ini\\ui\\life\\job_gather_prop.ini")
	if not nx_is_valid(gather_ini) then return end
	local life_ini = nx_execute("util_functions", "get_ini", "share\\Item\\life_formula.ini")
	if not nx_is_valid(life_ini) then return end
	local sec_index = job_info_ini:FindSectionIndex("sh_qs")
	local gather_info = job_info_ini:ReadString(sec_index, "gather", "")
	local gather_lst = util_split_string(gather_info, ",")
	for i = table.getn(gather_lst), 1, -1 do
		local gather_sec_index = gather_ini:FindSectionIndex(nx_string(gather_lst[i]))
		local item_count = gather_ini:GetSectionItemCount(gather_sec_index)
		for j = item_count, 1, -1 do
			local qipu_str = gather_ini:ReadString(gather_sec_index, nx_string(j), "")
			local node_info = util_split_string(qipu_str, "/")
			local node_item_str = nx_string(node_info[3])
			local formula_list = util_split_string(nx_string(node_item_str), ",")
			for k = table.getn(formula_list), 1, -1 do
				local formula_id = formula_list[k]
				if is_Learned_formula(formula_id) then
					local m_index = life_ini:FindSectionIndex(formula_id)
					local m_info = life_ini:ReadString(m_index, "ComposeResult", "")
					name = nx_value("gui").TextManager:GetText(m_info)
					if m_info == "musician_10053" or m_info == "musician_10061" or m_info == "musician_10054" then
						table.insert(auto_zither_id_list, 1, {id = formula_id, name = name})
					else
						table.insert(auto_zither_id_list, {id = formula_id, name = name})
					end
				end
			end
		end
	end
end
function is_Learned_formula(formulaid)
	local game_client = nx_value('game_client') 
	local client_player = game_client:GetPlayer() 
	local rows = client_player:FindRecordRow('FormulaRec', 1, nx_string(formulaid), 0)
	if rows >= 0 then 
		return true 
	else
		return false
	end 
end 
function itemBuyFromShop(item)
	local game_client=nx_value('game_client')
	if nx_is_valid(game_client)then
		local form_shop = nx_value('form_stage_main\\form_shop\\form_shop')
		nx_execute('custom_sender', 'custom_open_mount_shop', 1)
		nx_pause(0.1)
		local view_table = game_client:GetViewList()
		for i = 1, table.getn(view_table) do
		  local view = view_table[i]
		  if view.Ident == nx_string(61) then
			local view_obj_table = view:GetViewObjList()
			for k = 1, table.getn(view_obj_table) do
			  local view_obj = view_obj_table[k]
			  if nx_string(view_obj:QueryProp('ConfigID')) == item then
				if nx_number(view_obj.Ident) < 501 then
					nx_execute('custom_sender', 'custom_buy_item', 'Shop_zahuo_00102', 0,nx_number(view_obj.Ident),1)
				else
					nx_execute('custom_sender', 'custom_buy_item', 'Shop_zahuo_00102', 1,(nx_number(view_obj.Ident)-500),1)
				end
			  end
			end
		  end
		end
		nx_execute('custom_sender', 'custom_open_mount_shop', 0)
	end
end
function autoBuyItemJob(itemShop)
	local goods_grid = nx_value('GoodsGrid')
	if goods_grid:GetItemCount(itemShop) == 0 then
		itemBuyFromShop(itemShop)
	end
end

function btn_start_zither(cbtn)
	local form = cbtn.ParentForm
	num_repeated = 0
	local goods_grid = nx_value("GoodsGrid")	
	if goods_grid:GetItemCount("tool_qs_06") == 0 then
		-- Check pass rương và tự mua đàn
		local game_client=nx_value("game_client")
		local player_client=game_client:GetPlayer()
		if not player_client:FindProp("IsCheckPass") or player_client:QueryProp("IsCheckPass") ~= 1 then
			yBreaker_show_Utf8Text("Mở khóa rương để tự mua đàn", 3)
			return 
		else 		
			-- Mua Đàn trong Tạp Hóa ------------- Shop Giang hồ ---- 1: Công Cụ, 11: số thứ tự Đàn, 1: Mua (Tương tự vậy thì 1,1,1: Tab Công Cụ, Mua Liệp Thú Đoản Kiếm)
			nx_execute("custom_sender", "custom_open_mount_shop", 1)
			nx_execute("custom_sender", "custom_buy_item", "Shop_zahuo_00102", 1,11,1)
			nx_execute("custom_sender", "custom_open_mount_shop", 0)
		end 
	end		
	
	update_btn_start_stop()	

	while form.auto_start do
		-- Chạy đàn
		if form.cb_auto_run.Checked then	
			--yBreaker_show_Utf8Text("Chạy")
			-- Set auto running
			is_running_zither = true
			
			-- Get X/Z current
			local game_visual = nx_value("game_visual")
			local visual_player = game_visual:GetPlayer()
			local pos_X_save = visual_player.PositionX
			local pos_Y_save = visual_player.PositionY
			local pos_Z_save = visual_player.PositionZ
				
			-- Run auto when checked
			while is_running_zither == true do
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

				local map_query = nx_value("MapQuery")
				if not nx_is_valid(map_query) then
					is_vaild_data = false
				end

				if is_vaild_data == true then
					local city = map_query:GetCurrentScene()
					local posX = pos_X_save
					local posY = pos_Y_save
					local posZ = pos_Z_save

					-- Nếu bị chết thì trị thương lân cận
					local logicstate = player_client:QueryProp("LogicState")
					if logicstate == 120 then
						nx_execute("custom_sender", "custom_relive", 2, 0)
						nx_pause(7)
					-- Chưa tới điểm đứng đó thì di chuyển đến
					elseif not tools_move_isArrived(posX, posY, posZ) then
						tools_move(city, posX, posY, posZ, direct_run)
						direct_run = false
					else
						-- Đúng vị trí cần tới thì xuống ngựa -> Chuyển qua đàn
						is_running_zither = false
						yBreaker_get_down_the_horse()
						break
					end
				end
				nx_pause(0.2)
			end
		end		
		
		-- Luyện đàn nếu checkbox này true
		if form.cb_train.Checked then
			startTrainingMusic(1)
			nx_pause(3)
		else
			
			nx_pause(0.1)
			local game_client=nx_value("game_client")
			local game_visual=nx_value("game_visual")
			if nx_is_valid(game_client)and nx_is_valid(game_visual)then
				local player_client=game_client:GetPlayer()
				local logicstate = player_client:QueryProp("LogicState")
				autoBuyItemJob("tool_qs_06")
				if num_repeated == 0 or os.difftime(os.time(), num_repeated) >= 50 then
					num_repeated = os.time()
				end		
				local form_zither = nx_value("form_stage_main\\form_small_game\\form_mini_qingame")	
				if nx_is_valid(form_zither) then
					form_zither.t_speed = 0.01
				end
				if logicstate ~= 10 and logicstate ~= 102 and logicstate ~= 121 and logicstate ~= 120 and player_client:QueryProp("GameState") ~= "QinGameModule" then
					if auto_zither_id_list ~= nil and table.getn(auto_zither_id_list) > 0 then					
					  nx_execute("custom_sender", "custom_doqin", auto_zither_id_list[nx_number(form.cbx_zither_load.DropListBox.SelectIndex) + 1].id)
					  nx_execute("form_stage_main\\form_helper\\form_main_helper_manager", "next_helper_form")
					end				
				end
			end
		end
		
	end
end

function show_hide_form_zither()
	util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_zither")
end

function on_btn_close_click(btn)
	local form = btn.ParentForm
			if not form.auto_start then
				if not nx_is_valid(form) then
					return
				end
			nx_destroy(form)
			else
			yBreaker_show_Utf8Text("Tắt đàn trước khi đóng", 3)
		end
	is_running_zither = false	
end

function on_combobox_mode_selected(boxitem)
	local form = boxitem.ParentForm
	form.select_index = form.cbx_zither_load.DropListBox.SelectIndex + 1
	form.select_item = item[form.select_index]
	if form.select_index > 0 then
		form.btn_start_stop.Enabled = true
	end
end
function CloseGame()
  local QinGame = nx_value("QinGame")
  if not nx_is_valid(QinGame) then
    return
  end
  QinGame:Close()
end
function update_btn_start_stop()
	local form = util_get_form("admin_yBreaker\\yBreaker_form_zither", false, false)
	if nx_is_valid(form) then
		if form.auto_start then
			CloseGame()
			form.btn_start_stop.Text = util_text("ui_begin")
		  form.auto_start = false
		else
			form.btn_start_stop.Text = util_text("ui_off_end")
		  form.auto_start = true
		end
	end
end
function getitem()
	local game_client = nx_value("game_client")
	local player_client = game_client:GetPlayer()
	if nx_is_valid(player_client) then
		local scene = game_client:GetScene()
		local view_table = game_client:GetViewList()
		local rows = player_client:GetRecordRows("FormulaRec")
		for i = 0, rows - 1 do
			local check = player_client:QueryRecord("FormulaRec", i, 0)
			local qinid = player_client:QueryRecord("FormulaRec", i, 1)
			if check == "sh_qs" then
				item[#item+1] = qinid
			end
		end
	end
end

-- Trainning music
function is_Learned_formula(formulaid)
	local game_client = nx_value('game_client')
	local client_player = game_client:GetPlayer()
	local rows = client_player:FindRecordRow('FormulaRec', 1, nx_string(formulaid), 0)
	if rows >= 0 then
		return true
	else
		return false
	end
end
startTrainingMusic = function(num)
	local count = 0
	local job_info_ini = nx_execute('util_functions', 'get_ini', 'share\\Life\\job_info.ini')
	local gather_ini = nx_execute('util_functions', 'get_ini', 'ini\\ui\\life\\job_gather_prop.ini')
	local sec_index = job_info_ini:FindSectionIndex('sh_qs')
	local gather_info = job_info_ini:ReadString(sec_index, 'gather', '')
	local gather_lst = util_split_string(gather_info, ',')
	for i = table.getn(gather_lst), 1, -1 do
		local sec_index1 = gather_ini:FindSectionIndex(nx_string(gather_lst[i]))
		local item_count = gather_ini:GetSectionItemCount(sec_index1)
		for j = item_count, 1, -1 do
			local qipu_str = gather_ini:ReadString(sec_index1, nx_string(j), '')
			local node_info = util_split_string(qipu_str, '/')
			local node_item_str = nx_string(node_info[3])
			local formula_list = util_split_string(nx_string(node_item_str), ',')
			for k = table.getn(formula_list), 1, -1 do
				local formula_id = formula_list[k]
				if is_Learned_formula(formula_id) then
					playTrainingMusic(formula_id, num)
					return
				end
			end
		end
	end
end
fMus = 'form_stage_main\\form_small_game\\form_qingame'
playTrainingMusic = function(music_id, num)
	local count = 0
	while 1
	do
		local display_time = 0
		nx_value('game_visual'):CustomSend(nx_int(600), nx_string(music_id), 1, 0)
		while not nx_is_valid(nx_value(fMus)) and display_time < 10
		do
			nx_pause(0.5)
			display_time = display_time + 1
		end
		if display_time == 10 then
			return
		end
		count = count + 1
		nx_execute(fMus, 'on_btn_start_game_click', nx_value(fMus).btn_start_game)
		while nx_is_valid(nx_value(fMus))
		do
			nx_pause(1)
		end
		if num and nx_number(count) >= nx_number(num) then
			return
		end
		nx_pause(15)
	end
end

-- Chạy đàn
