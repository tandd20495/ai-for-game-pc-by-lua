require('auto_new\\autocack')

local item = {}
function main_form_init(form)
  form.Fixed = false
  form.select_index = 0
  form.select_item = ""
  form.num_repeated = 0
  form.auto_start = false
end
function on_main_form_open(form)
  init_ui_content(form)
end
function on_bug_auto()
nx_execute(nx_current(), 'jumpdan')
end
function init_ui_content(form)	
  if nx_execute("form_stage_main\\form_life\\form_job_main_new", "find_life_job", "sh_ss") then
    form.btn_start_stop.Enabled = true   
  	form.cbx_music_load.InputEdit.Text = "not"
	form.cbx_music_load.DropListBox:ClearString()
	if auto_music_id_list == nil then
		auto_music_id_list = {}
	end
	loadMusic()
	loadMusicConfig(form.cbx_music_load)
  else
    form.btn_start_stop.Enabled = false
  end
	if not form.auto_start then
		form.btn_start_stop.Text = util_text("ui_begin")
	else
		form.btn_start_stop.Text = util_text("ui_off_end")
	end
end
function loadMusicConfig(cbx)
  cbx.DropListBox:ClearString()
  cbx.InputEdit.Text = ""
  if auto_music_id_list == nil or table.getn(auto_music_id_list) == 0 then
    return
  end
    item = {}
  	getitem()
  for i = 1, table.getn(auto_music_id_list) do
    cbx.DropListBox:AddString(auto_music_id_list[i].name)	
  end
  cbx.DropListBox.SelectIndex = 0
  cbx.InputEdit.Text = cbx.DropListBox:GetString(0)
end
function loadMusic()
	local gui = nx_value("gui")	
	local job_info_ini = nx_execute('util_functions', 'get_ini', 'share\\Life\\job_info.ini') 
	local sec_index = job_info_ini:FindSectionIndex('sh_ss')
	local composite_ini = nx_execute("util_functions", "get_ini", "ini\\ui\\life\\job_composite_prop.ini")
	local life_ini = nx_execute("util_functions", "get_ini", "share\\Item\\life_formula.ini")
	if not nx_is_valid(life_ini) then return end
	local compositestr = job_info_ini:ReadString(sec_index, "composite", "")	
	local str_lst = util_split_string(compositestr, ",")
	for i = 1, table.getn(str_lst) do
		local str = str_lst[i]
		local sec_index = composite_ini:FindSectionIndex(nx_string(str))
		if sec_index >= 0 then
			local item_count = composite_ini:GetSectionItemCount(sec_index)
			local composite_typeid = str
			local composite_txt = gui.TextManager:GetFormatText(nx_string(composite_typeid))
			 for j = item_count ,1, -1  do
				local temp_str = composite_ini:GetSectionItemValue(sec_index, nx_string(j))
				local node_info = util_split_string(temp_str, "/")
				if table.getn(node_info) == 1 then
					local compositeNum = 0
					local str_lst = util_split_string(node_info[1], ",")
					for i = 1, table.getn(str_lst) do
						local formula_id = str_lst[i]
						if is_Learned_formula(formula_id) then
							local m_index = life_ini:FindSectionIndex(formula_id)
							local m_info = life_ini:ReadString(m_index, "ComposeResult", "")
							local item_split = life_ini:ReadString(m_index, "Material", "")							
							name = nx_value("gui").TextManager:GetText(m_info)	
							table.insert(auto_music_id_list, {id = formula_id, name = name,item = item_split})
						end
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

function itemBuyFromShop(shop,item,slot,check)
	local game_client=nx_value('game_client')
	if nx_is_valid(game_client)then
		local form_shop = nx_value('form_stage_main\\form_shop\\form_shop')
		if check then
			nx_execute('custom_sender', 'custom_open_mount_shop', 1)					
		end
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
					nx_execute('custom_sender', 'custom_buy_item', shop, 0,nx_number(view_obj.Ident),slot)
				else
					nx_execute('custom_sender', 'custom_buy_item', shop, 1,(nx_number(view_obj.Ident)-500),slot)
				end
			  end
			end
		  end
		end
		if check then
			nx_execute('custom_sender', 'custom_open_mount_shop', 0)
		end
	end
end
function autoBuyItemJob(shop,itemShop,slot,check)
	local goods_grid = nx_value('GoodsGrid')
	if goods_grid:GetItemCount(itemShop) < slot then
		itemBuyFromShop(shop,itemShop,slot,check)
	end
end
local FORM_WRITING = "form_stage_main\\form_small_game\\form_game_handwriting"
function btn_start_music(cbtn)
	local form = cbtn.ParentForm
	local goods_grid = nx_value("GoodsGrid")	
	if goods_grid:GetItemCount("tool_ss_06") == 0 then
		if not is_password_locked() then
			showUtf8Text(AUTO_LOG_PLEASE_BUY_TOOL, 3)
			return
		end
	end		
	update_btn_start_stop()
	while form.auto_start do
		nx_pause(1)
		local game_client=nx_value("game_client")
		local game_visual=nx_value("game_visual")
		if nx_is_valid(game_client)and nx_is_valid(game_visual)then
			local player_client=game_client:GetPlayer()
			local logicstate = player_client:QueryProp("LogicState")			
			if num_repeated == 0 or os.difftime(os.time(), num_repeated) >= 50 then
				num_repeated = os.time()
			end
			autoBuyItemJob('Shop_zahuo_00102','tool_ss_06',1,true)
			if logicstate ~= 10 and logicstate ~= 102 and logicstate ~= 121 and logicstate ~= 120 and player_client:QueryProp("GameState") ~= "QinGameModule" then
				if auto_music_id_list ~= nil and table.getn(auto_music_id_list) > 0 then
					local form_game_handwriting = nx_value("form_stage_main\\form_small_game\\form_game_handwriting")
					if not nx_is_valid(form_game_handwriting) then
						local get_item = auto_split_string(nx_string(auto_music_id_list[nx_number(form.cbx_music_load.DropListBox.SelectIndex) + 1].item),';')
						local set_item = nil
						for i = 1 , table.getn(get_item) do
							set_item = auto_split_string(get_item[i],',')
							local item_pos, view, name, amount =  find_item_pos(set_item[1])
							local amount_get = set_item[2]
							if nx_number(amount) < nx_number(amount_get) then 
								autoBuyItemJob(nx_string('Shop_ss_05001'),nx_string(set_item[1]),nx_number(amount_get),false)
							end
						end	
						nx_pause(5)
						nx_execute("custom_sender", "custom_send_compose", auto_music_id_list[nx_number(form.cbx_music_load.DropListBox.SelectIndex) + 1].id, 1, 0)
					else
						nx_pause(2)
						local HandwritingGame = nx_value("HandwritingGame")
						if nx_is_valid(HandwritingGame) then
							if nx_is_valid(form_game_handwriting) and form_game_handwriting.btn_start.Visible then								
								on_btn_start_click()							
							end
						end	
					end				 	
									
				  nx_execute("form_stage_main\\form_helper\\form_main_helper_manager", "next_helper_form")
				end				
			end
		end
	end
end

function on_btn_start_click(form)
  local form = nx_value(FORM_WRITING)
  if not nx_is_valid(form) then
    return
  end
  on_reset_ball(form)
  local HandwritingGame = nx_value("HandwritingGame")
  if not nx_is_valid(HandwritingGame) then
    return
  end
  HandwritingGame:InitGame()
  HandwritingGame:SetIsInGame(true)
  form.btn_start.Visible = false
  local timer = nx_value("timer_game")
  timer:Register(100, -1, "form_stage_main\\form_small_game\\form_game_handwriting", "on_update_ball", form, -1, -1)
end
function on_reset_ball(form)
  local form = nx_value(FORM_WRITING)
  if not nx_is_valid(form) then
    return
  end
  form.lbl_ball.Left = form.groupbox_sbg.Width / 2 - form.lbl_ball.Width / 2
  form.lbl_pen.Visible = false
end
function showHideForm()
	util_show_form('auto_new\\tools\\form_auto_scholar', true)
end
function on_main_form_close(btn)

end
function on_btn_close_click(btn)
	local form = btn.ParentForm
			if not form.auto_start then
				if not nx_is_valid(form) then
					return
				end
			nx_destroy(form)
			else
			showUtf8Text("Tắt auto Trước Khi tắt Form", 3)
		end
end
function on_combobox_mode_selected(boxitem)
	local form = boxitem.ParentForm
	form.select_index = form.cbx_music_load.DropListBox.SelectIndex + 1
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
	local form = util_get_form("auto_new\\tools\\form_auto_scholar", false, false)
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
			if check == "sh_ss" then
				item[#item+1] = qinid
			end
		end
	end
end
