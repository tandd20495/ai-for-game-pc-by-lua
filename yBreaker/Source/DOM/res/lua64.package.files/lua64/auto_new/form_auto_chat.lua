require("const_define")
require("util_gui")
require("util_move") -- Xac dinh toa do distance3d
require("util_functions")
require("util_static_data")
require("share\\server_custom_define")
require("define\\sysinfo_define")
require("share\\chat_define")
require("define\\request_type")
require('auto_new\\autocack')
local FORM_MAIN_FACE_CHAT = "form_stage_main\\form_main\\form_main_face_chat"
local FORM_MAIN_FACE = "form_stage_main\\form_main\\form_main_face"
local data_config_checkbox = {
	[CHATTYPE_VISUALRANGE] = "cbtn_chat_visualrange",
	[CHATTYPE_SCENE] = "cbtn_chat_scene",
	[CHATTYPE_TEAM] = "cbtn_chat_team",
	[CHATTYPE_GUILD] = "cbtn_chat_guild",
	[CHATTYPE_SCHOOL] = "cbtn_chat_school",
	[CHATTYPE_WORLD] = "cbtn_chat_world",
	[CHATTYPE_FORCE] = "cbtn_chat_force",
	[CHATTYPE_NEW_SCHOOL] = "cbtn_chat_new_school",
	[CHATTYPE_NEW_TERRITORY] = "cbtn_chat_new_territory",
	[CHATTYPE_GUILD_LEAGUE] = "cbtn_chat_guild_league"
}
local data_config_time = {
	[CHATTYPE_VISUALRANGE] = "ipt_chat_visualrange",
	[CHATTYPE_SCENE] = "ipt_chat_scene",
	[CHATTYPE_TEAM] = "ipt_chat_team",
	[CHATTYPE_GUILD] = "ipt_chat_guild",
	[CHATTYPE_SCHOOL] = "ipt_chat_school",
	[CHATTYPE_WORLD] = "ipt_chat_world",
	[CHATTYPE_FORCE] = "ipt_chat_force",
	[CHATTYPE_NEW_SCHOOL] = "ipt_chat_new_school",
	[CHATTYPE_NEW_TERRITORY] = "ipt_chat_new_territory",
	[CHATTYPE_GUILD_LEAGUE] = "ipt_chat_guild_league"
}
local data_config_count = {
	[CHATTYPE_VISUALRANGE] = "lbl_chat_visualrange_count",
	[CHATTYPE_SCENE] = "lbl_chat_scene_count",
	[CHATTYPE_TEAM] = "lbl_chat_team_count",
	[CHATTYPE_GUILD] = "lbl_chat_guild_count",
	[CHATTYPE_SCHOOL] = "lbl_chat_school_count",
	[CHATTYPE_WORLD] = "lbl_chat_world_count",
	[CHATTYPE_FORCE] = "lbl_chat_force_count",
	[CHATTYPE_NEW_SCHOOL] = "lbl_chat_new_school_count",
	[CHATTYPE_NEW_TERRITORY] = "lbl_chat_new_territory_count",
	[CHATTYPE_GUILD_LEAGUE] = "lbl_chat_guild_league_count"
}
local array_type = {
	CHATTYPE_VISUALRANGE, CHATTYPE_SCENE, CHATTYPE_TEAM, CHATTYPE_GUILD, CHATTYPE_SCHOOL, CHATTYPE_WORLD, CHATTYPE_FORCE, CHATTYPE_NEW_SCHOOL, CHATTYPE_NEW_TERRITORY, CHATTYPE_GUILD_LEAGUE
}
local market_item_table = {}
local market_search_table = {}
local data_stat_count = {}
local data_last_chat = {}
local chat_step = 0
function Chatting(cbtn)
	local form = cbtn.ParentForm
	UpdateStatus()
	local path_ini = add_file('auto_ai')
	writeIni(path_ini,'Auto_Chat','content_chat',nx_widestr(form.txt_content.Text))	
	while form.auto_start and nx_is_valid(form) do
		nx_pause(0.1)
		local game_client = nx_value("game_client")
		local game_visual = nx_value("game_visual")
		if nx_is_valid(game_client) and nx_is_valid(game_visual) then
			local player_client = game_client:GetPlayer()
			local game_player = game_visual:GetPlayer()
			local game_scence = game_client:GetScene()
			local chat_content = form.txt_content.Text			
			if chat_content == nx_widestr("") then
				local textchat = nx_value("gui").TextManager:GetFormatText(nx_widestr(util_text("ui_stall_shuru_liuyan")))			
				nx_value("SystemCenterInfo"):ShowSystemCenterInfo(textchat, 3)
			else
				if chat_step <= 0 then
					chat_step = table.getn(array_type)
				end
				local chattype = array_type[chat_step]
				local chattimeout = nx_number(nx_int(form[data_config_time[chattype]].Text))
				if chattimeout <= 0 then
					chattimeout = 20
				end
				-- Kiểm tra
				if form[data_config_checkbox[chattype]].Checked == true and (data_last_chat[chattype] == 0 or os.difftime(os.time(), data_last_chat[chattype]) >= chattimeout) then
					data_last_chat[chattype] = os.time()
					data_stat_count[chattype] = data_stat_count[chattype] + 1
					chat_content = nx_function("ext_ws_replace", nx_widestr(chat_content), nx_widestr("<font face=\"font_title_tasktrace\" color=\"#ffffff\" >"), nx_widestr(""))
					chat_content = nx_function("ext_ws_replace", nx_widestr(chat_content), nx_widestr("</font>"), nx_widestr(""))
					nx_execute("custom_sender", "custom_chat", nx_int(chattype), nx_widestr(chat_content))
				end
				BuildStatCount()
				chat_step = chat_step - 1
			end
		end
	end
end
function on_btn_buy_item_click(self)
  local form = self.ParentForm
  if not nx_is_valid(form) then	
    return
  end 
  local item_config = form.combobox_itemname.config
  if item_config ~= false then
    local dialog = nx_execute("util_gui", "util_get_form", "form_common\\form_inputbox", true, false)
    dialog.info_label.Text = nx_function("ext_utf8_to_widestr", "Vị trí mua")
    dialog.name_edit.Text = nx_widestr("0")
    dialog:ShowModal()
    local res, text = nx_wait_event(100000000, dialog, "input_box_return")
    if res == "ok" then
        local form_stall_buy = nx_value("form_stage_main\\form_stall\\form_stall_buy")
        if nx_is_valid(form_stall_buy) then
            nx_execute("form_stage_main\\form_stall\\form_stall_buy", "pop_purchase_set_form", form_stall_buy.buy_grid, nx_number(text), nx_string(item_config))
        else
            showUtf8Text(AUTO_LOG_CHAT1, 3)
        end
    end
  end
end
---------------------------------------------------------------------------
function UpdateStatus()
	local form = util_get_form("auto_new\\form_auto_chat", false, false)
	if nx_is_valid(form) then
		chat_step = table.getn(array_type)
		ResetStart()
		BuildStatCount()
		if form.auto_start then
			form.btn_control.Text = util_text("ui_begin")
			form.btn_control.ForeColor = "255,0,255,0"
		    form.auto_start = false
		else
			form.btn_control.Text = util_text("ui_off_end")
			form.btn_control.ForeColor = "255,255,0,0"
		    form.auto_start = true
		end
	end
end
function ChatIni(form)
	form.Fixed = false
	form.auto_start = false
end
function ChatOpen(form)	
	local path_ini = add_file('auto_ai')
	if not form.auto_start then
		form.btn_control.Text = util_text("ui_begin")
		form.btn_control.ForeColor = "242,242,242,0"
	else
		form.btn_control.Text = util_text("ui_off_end")
		form.btn_control.ForeColor = "255,255,0,0"
	end
	form.ipt_search_key.Text = nx_widestr(nx_function("ext_utf8_to_widestr", "Tìm vật phẩm ở đây!"))
	local chat = wstrToUtf8(readIni(path_ini,'Auto_Chat','content_chat',''))
	form.txt_content.Text = utf8ToWstr(chat)
	form.ipt_search_key.ForeColor = "255,255,0,255"
	form.combobox_itemname.config = false
	form.check_box_1.Checked = false	
	load_auto_chat(form)
end
function ChatClose(form)
end
function Destroy(form)
	nx_destroy(form)
end
function MinimizeClick(btn)
	util_auto_show_hide_form("auto_new\\form_auto_chat")
end
function CloseClick(btn)
	local form = btn.ParentForm
	if not form.auto_start then
		local formab = nx_value("auto_new\\form_auto_chat")
		if not nx_is_valid(formab) then
			return
		end
		Destroy(form)
	else
		local textchat = nx_value("gui").TextManager:GetFormatText(nx_widestr(nx_function("ext_utf8_to_widestr","Vui lòng bấm ")), nx_widestr(nx_function("ext_utf8_to_widestr","Kết Thúc ")), nx_widestr(nx_function("ext_utf8_to_widestr","trước khi tắt Auto.......!")))
		nx_value("form_main_chat"):AddChatInfoEx(textchat, 17, false)
		nx_value("SystemCenterInfo"):ShowSystemCenterInfo(textchat, 3)
	end
end
-----------------------------------------------------------------------------------------
function on_combobox_itemname_selected(self)
  local form = self.ParentForm
  if not nx_is_valid(form) then
    return
  end
  local index = form.combobox_itemname.DropListBox.SelectIndex
  if index < table.getn(market_item_table) then
    form.combobox_itemname.config = market_item_table[index + 1]
    form.btn_search_key.Enabled = true
	form.btn_buy_item.Enabled = true
  end
  form.ipt_search_key.Text = form.combobox_itemname.Text
  form.combobox_itemname.Text = nx_widestr("")
end
function on_ipt_search_key_get_focus(self)
  local gui = nx_value("gui")
  gui.hyperfocused = self
  if nx_string(self.Text) == nx_string(nx_function("ext_utf8_to_widestr", "Tìm vật phẩm ở đây!")) then
    self.Text = ""
  end
end
function on_ipt_search_key_lost_focus(self)
  local form = self.ParentForm
  if not nx_is_valid(form) then
    return
  end
  if nx_string(self.Text) == nx_string("") then
    self.Text = nx_widestr(nx_function("ext_utf8_to_widestr", "Tìm vật phẩm ở đây!"))
  end
end
function on_ipt_search_key_changed(self)
  local form = self.ParentForm
  if not nx_is_valid(form) then
    return
  end
  if nx_string(self.Text) == nx_string("") then
    ShowSearchItem(form)
    return
  end
  if nx_string(self.Text) == nx_string(nx_function("ext_utf8_to_widestr", "Tìm vật phẩm ở đây!")) then
    return
  end
  local gui = nx_value("gui")
  local ItemQuery = nx_value("ItemQuery")
  if not nx_is_valid(ItemQuery) then
    return
  end
  form.combobox_itemname.DropListBox:ClearString()
  local search_table = ItemQuery:FindItemsByName(nx_widestr(self.Text))
  market_item_table = {}
  for i = 1, nx_number(table.getn(search_table)) do
    local item_config = search_table[i]
    local bExist = ItemQuery:FindItemByConfigID(nx_string(item_config))
    if bExist == true then
      local IsMarketItem = ItemQuery:GetItemPropByConfigID(nx_string(item_config), nx_string("IsMarketItem"))
      if nx_int(IsMarketItem) == nx_int(1) then
        local static_data = ItemQuery:GetItemPropByConfigID(nx_string(item_config), nx_string("LogicPack"))
        local bind_type = item_static_query(nx_int(static_data), "BindType", STATIC_DATA_ITEM_LOGIC)
        if nx_int(bind_type) ~= nx_int(1) and gui.TextManager:IsIDName(search_table[i]) then
          form.combobox_itemname.DropListBox:AddString(nx_widestr(util_text(search_table[i])))
          table.insert(market_item_table, search_table[i])
        end
      end
    end
  end
  if not form.combobox_itemname.DroppedDown then
    form.combobox_itemname.DroppedDown = true
  end
end
function on_btn_chat_face_click(btn)
  local gui = nx_value("gui")
  local form = btn.ParentForm
  gui.Focused = form.txt_content
  local face_form = nx_value(FORM_MAIN_FACE_CHAT)
  if nx_is_valid(face_form) then
    nx_gen_event(face_form, "selectface_return", "cancel", "")
  else
    local form_main_face = nx_execute("util_gui", "util_get_form", FORM_MAIN_FACE, true, false, "", true)
    nx_set_value(FORM_MAIN_FACE_CHAT, form_main_face)
    form_main_face.AbsLeft = btn.AbsLeft + btn.Width
    form_main_face.AbsTop = btn.AbsTop
    form_main_face.type = 1
    form_main_face.vip_face_type = 2
    form_main_face.Visible = true
    form_main_face:Show()
    local res, html = nx_wait_event(100000000, form_main_face, "selectface_return")
    local form_auto_chat = nx_value("auto_new\\form_auto_chat")
    if res == "ok" and nx_is_valid(form_auto_chat) then
      AddItemToChatEdit(form, html)
    end
    form_main_face:Close()
  end
  nx_set_value(FORM_MAIN_FACE_CHAT, nil)
end
function on_txt_content_get_focus(redit)
  local gui = nx_value("gui")
  gui.hyperfocused = redit
end
function on_txt_content_enter(redit)
  local form = redit.ParentForm
end
function on_btn_search_key_click(self)
  local form = self.ParentForm
  if not nx_is_valid(form) then
    return
  end
  local item_config = form.combobox_itemname.config
  if item_config ~= false then
    local html = nx_widestr("<a href=\"item,") .. nx_widestr(item_config) .. nx_widestr("\" style=\"HLChatItem\">") .. nx_widestr("<") .. util_text(item_config) .. nx_widestr(">") .. nx_widestr("</a>")
	AddItemToChatEdit(form, html)
  end
end
-----------------------------------------------------------------------------------------
function ResetStart()
	data_stat_count = {
		[CHATTYPE_VISUALRANGE] = 0,
		[CHATTYPE_SCENE] = 0,
		[CHATTYPE_TEAM] = 0,
		[CHATTYPE_GUILD] = 0,
		[CHATTYPE_SCHOOL] = 0,
		[CHATTYPE_WORLD] = 0,
		[CHATTYPE_FORCE] = 0,
		[CHATTYPE_NEW_SCHOOL] = 0,
		[CHATTYPE_NEW_TERRITORY] = 0,
		[CHATTYPE_GUILD_LEAGUE] = 0
	}
	data_last_chat = {
		[CHATTYPE_VISUALRANGE] = 0,
		[CHATTYPE_SCENE] = 0,
		[CHATTYPE_TEAM] = 0,
		[CHATTYPE_GUILD] = 0,
		[CHATTYPE_SCHOOL] = 0,
		[CHATTYPE_WORLD] = 0,
		[CHATTYPE_FORCE] = 0,
		[CHATTYPE_NEW_SCHOOL] = 0,
		[CHATTYPE_NEW_TERRITORY] = 0,
		[CHATTYPE_GUILD_LEAGUE] = 0
	}
end
function BuildStatCount()
	local form = nx_value("auto_new\\form_auto_chat")
	if not nx_is_valid(form) then
		return
	end
	for i = 1, table.getn(array_type) do	
		nx_pause(0)
		form[data_config_count[array_type[i]]].Text = nx_widestr(data_stat_count[array_type[i]])
	end
end
function ShowSearchItem(form)
  if not nx_is_valid(form) then
    return
  end
  if nx_int(table.getn(market_search_table)) <= nx_int(0) then
    return
  end
  form.combobox_itemname.DropListBox:ClearString()
  market_item_table = {}
  for i = table.getn(market_search_table), 1, -1 do
    form.combobox_itemname.DropListBox:AddString(nx_widestr(util_text(market_search_table[i])))
    table.insert(market_item_table, market_search_table[i])
  end
  if not form.combobox_itemname.DroppedDown then
    form.combobox_itemname.DroppedDown = true
  end
end
function AddItemToChatEdit(form, html)
  form.txt_content:Append(html, -1)
  local gui = nx_value("gui")
  gui.Focused = form.txt_content
end
function AddHyperlink(html)
  local form = nx_value("auto_new\\form_auto_chat")
  if not nx_is_valid(form) then
    return
	end
  AddItemToChatEdit(form, html)
end
function InviteTeam()
	local form = nx_value("auto_new\\form_auto_chat")
		if not nx_is_valid(form) then
		return
	end
	local game_client = nx_value("game_client")
	if nx_is_valid(game_client) then
		local player_client = game_client:GetPlayer()
		if nx_is_valid(game_client) then
			local html = nx_widestr("<a href=\"team,")..nx_widestr(player_client:QueryProp("Name"))..nx_widestr("\" style=\"HLChatItem\">")..nx_widestr(nx_function("ext_utf8_to_widestr","[Vào PT Nào]"))..nx_widestr("</a>")
			AddItemToChatEdit(form, html)
		end
	end
end
function on_check_box_1_changed(self)
	local form = self.ParentForm
	if not form.check_box_1.Checked then
		form.btn_invite.Enabled = false
	else
		form.btn_invite.Enabled = true
	end
end
load_auto_chat = function(form)
	local path_ini = add_file('auto_ai')
	local visualrange = wstrToUtf8(readIni(path_ini,'Auto_Chat','cbtn_chat_visualrange',''))
	local scene = wstrToUtf8(readIni(path_ini,'Auto_Chat','cbtn_chat_scene',''))
	local team = wstrToUtf8(readIni(path_ini,'Auto_Chat','cbtn_chat_team',''))
	local guild = wstrToUtf8(readIni(path_ini,'Auto_Chat','cbtn_chat_guild',''))
	local school = wstrToUtf8(readIni(path_ini,'Auto_Chat','cbtn_chat_school',''))
	local world = wstrToUtf8(readIni(path_ini,'Auto_Chat','cbtn_chat_world',''))
	local force = wstrToUtf8(readIni(path_ini,'Auto_Chat','cbtn_chat_force',''))
	local new_school = wstrToUtf8(readIni(path_ini,'Auto_Chat','cbtn_chat_new_school',''))
	local territory = wstrToUtf8(readIni(path_ini,'Auto_Chat','cbtn_chat_new_territory',''))
	local league = wstrToUtf8(readIni(path_ini,'Auto_Chat','cbtn_chat_guild_league',''))
	if visualrange == nx_string('true') then
		form.cbtn_chat_visualrange.Checked = true
	else
		form.cbtn_chat_visualrange.Checked = false		
	end
	if scene == nx_string('true') then
		form.cbtn_chat_scene.Checked = true
	else
		form.cbtn_chat_scene.Checked = false		
	end
	if team == nx_string('true') then
		form.cbtn_chat_team.Checked = true
	else
		form.cbtn_chat_team.Checked = false		
	end
	if guild == nx_string('true') then
		form.cbtn_chat_guild.Checked = true
	else
		form.cbtn_chat_guild.Checked = false		
	end
	if school == nx_string('true') then
		form.cbtn_chat_school.Checked = true
	else
		form.cbtn_chat_school.Checked = false	
	end
	if world == nx_string('true') then
		form.cbtn_chat_world.Checked = true
	else
		form.cbtn_chat_world.Checked = false		
	end
	if force == nx_string('true') then
		form.cbtn_chat_force.Checked = true
	else
		form.cbtn_chat_force.Checked = false		
	end
	if new_school == nx_string('true') then
		form.cbtn_chat_new_school.Checked = true
	else
		form.cbtn_chat_new_school.Checked = false
	end
	if territory == nx_string('true') then
		form.cbtn_chat_new_territory.Checked = true
	else
		form.cbtn_chat_new_territory.Checked = false
	end
	if league == nx_string('true') then
		form.cbtn_chat_guild_league.Checked = true
	else
		form.cbtn_chat_guild_league.Checked = false
	end
end
function cbtn_chat_visualrange(self)
	local form = self.ParentForm
	local path_ini = add_file('auto_ai')		
	writeIni(path_ini,'Auto_Chat','cbtn_chat_visualrange',nx_widestr(form.cbtn_chat_visualrange.Checked))
end
function cbtn_chat_scene(self)
	local form = self.ParentForm
	local path_ini = add_file('auto_ai')		
	writeIni(path_ini,'Auto_Chat','cbtn_chat_scene',nx_widestr(form.cbtn_chat_scene.Checked))
end
function cbtn_chat_team(self)
	local form = self.ParentForm
	local path_ini = add_file('auto_ai')		
	writeIni(path_ini,'Auto_Chat','cbtn_chat_team',nx_widestr(form.cbtn_chat_team.Checked))
end
function cbtn_chat_guild(self)
	local form = self.ParentForm
	local path_ini = add_file('auto_ai')		
	writeIni(path_ini,'Auto_Chat','cbtn_chat_guild',nx_widestr(form.cbtn_chat_guild.Checked))
end
function cbtn_chat_school(self)
	local form = self.ParentForm
	local path_ini = add_file('auto_ai')		
	writeIni(path_ini,'Auto_Chat','cbtn_chat_school',nx_widestr(form.cbtn_chat_school.Checked))
end
function cbtn_chat_world(self)
	local form = self.ParentForm
	local path_ini = add_file('auto_ai')		
	writeIni(path_ini,'Auto_Chat','cbtn_chat_world',nx_widestr(form.cbtn_chat_world.Checked))
end
function cbtn_chat_force(self)
	local form = self.ParentForm
	local path_ini = add_file('auto_ai')		
	writeIni(path_ini,'Auto_Chat','cbtn_chat_force',nx_widestr(form.cbtn_chat_force.Checked))
end
function cbtn_chat_new_school(self)
	local form = self.ParentForm
	local path_ini = add_file('auto_ai')		
	writeIni(path_ini,'Auto_Chat','cbtn_chat_new_school',nx_widestr(form.cbtn_chat_new_school.Checked))
end
function cbtn_chat_new_territory(self)
	local form = self.ParentForm
	local path_ini = add_file('auto_ai')		
	writeIni(path_ini,'Auto_Chat','cbtn_chat_new_territory',nx_widestr(form.cbtn_chat_new_territory.Checked))
end
function cbtn_chat_guild_league(self)
	local form = self.ParentForm
	local path_ini = add_file('auto_ai')		
	writeIni(path_ini,'Auto_Chat','cbtn_chat_guild_league',nx_widestr(form.cbtn_chat_guild_league.Checked))
end