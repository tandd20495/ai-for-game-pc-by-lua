require('util_gui')
require("util_move")
require('define\\gamehand_type')
require('const_define')
require('auto_new\\autocack')
require('form_stage_main\\form_taosha\\taosha_util')
local THIS_FORM = 'auto_new\\form_auto_world_boss'

function main_form_init(form)
	form.Fixed = false
	form.inifile = ""	
end
function on_main_form_open(form)
	updateState()		
	loadGridHotKey(form)
end 
function on_btn_close_click(form)   
  local form = nx_value("auto_new\\form_auto_world_boss")
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
function on_main_form_close(form)	
	nx_destroy(form)
end

function on_click_btn_del(btn)
	local form = btn.ParentForm
	local inifile = add_file_user('setkey')
	removeSection(inifile,btn.func_ai)
	loadGridHotKey(form)
end
function btn_start_key_func(btn)
	if nx_execute('form_stage_main\\form_taosha\\taosha_util','getStateHotKey') then
		nx_execute('form_stage_main\\form_taosha\\taosha_util','setStateHotkey',false)
	else
		nx_execute('form_stage_main\\form_taosha\\taosha_util','setStateHotkey',true)
	end
	updateState()
end
function updateState()
	local form = nx_value('auto_new\\form_auto_world_boss')
	if nx_execute('form_stage_main\\form_taosha\\taosha_util','getStateHotKey') then
		form.btn_start_key_func.Text = nx_widestr('On')
	else
		form.btn_start_key_func.Text = nx_widestr('Off')
	end
end
function loadGridHotKey(form)
	gsp_auction_add(form,'1','helmet_60704','1','1','50000','2',1300045400)
end
local color = {
  [1] = {
    "255,201,88,81",
    "ui_auction_1"
  },
  [2] = {
    "255,152,160,205",
    "ui_auction_2"
  },
  [3] = {
    "255,186,151,114",
    "ui_auction_3"
  },
  [4] = {
    "255,153,153,153",
    "ui_auction_4"
  },
  [5] = {
    "255,233,192,80",
    "ui_auction_5"
  },
  [6] = {
    "255,163,202,68",
    "ui_auction_6"
  }
}
local fore_color_you = "255,10,255,0"
local fore_color_other = "255,255,255,255"
function set_sl_auction(form, auction_uid)
  form.sl_auction = nx_string(auction_uid)
  if form.sl_auction == "" then
    form.gb_info_2.Visible = false
  else
    form.gb_info_2.Visible = true
    local gb = form.gsb_auction:Find("gb_1_" .. form.sl_auction)
    if nx_is_valid(gb) then
      local ig = gb:Find("ig_1_item_" .. nx_string(auction_uid))
      local lbl_price = gb:Find("lbl_1_price_" .. nx_string(auction_uid))
      local lbl_competer = gb:Find("lbl_1_competer_" .. nx_string(auction_uid))
      local item_config = ig.config
      local item_amount = ig.count
      local bind = ig.bind
      local color_level = nx_number(get_prop_in_ItemQuery(item_config, nx_string("ColorLevel")))
      local photo = get_prop_in_ItemQuery(item_config, nx_string("Photo"))
      form.ig_info_1:AddItem(0, nx_string(photo), nx_widestr(item_config), nx_int(item_amount), 0)
      form.ig_info_1.config = item_config
      form.ig_info_1.count = item_amount
      form.ig_info_1.bind = bind
      form.lbl_info_1_name.Text = util_text(item_config)
      form.lbl_info_1_name.ForeColor = color[color_level][1]
      form.lbl_info_1_amount.Text = nx_widestr(item_amount)
      form.mltbox_info_1_price.HtmlText = lbl_price.HtmlText
      local price_min = lbl_price.price
      price_min = price_min + get_price_add(item_config)
      form.gb_info_1.price_min = price_min
      form.gb_info_1.price_add = get_price_add(item_config)
      set_ipt_money(form, 0)
      set_ipt_money(form, lbl_price.price)
    end
  end
end
function gsp_auction_add(form, auction_uid, item_config, item_amount, bind, price, competer, end_time)
  local game_client = nx_value("game_client")
  local client_player = game_client:GetPlayer()
  local self_name = client_player:QueryProp("Name")
  local gb = create_ctrl("GroupBox", "gb_1_" .. nx_string(auction_uid), form.gb_mod_1, form.gsb_auction)
  if nx_is_valid(gb) then
    gb.auction_uid = nx_string(auction_uid)
    local cbtn = create_ctrl("CheckButton", "cbtn_1_bg_" .. nx_string(auction_uid), form.cbtn_1_bg, gb)
    cbtn.auction_uid = nx_string(auction_uid)
    nx_bind_script(cbtn, nx_current())
    nx_callback(cbtn, "on_checked_changed", "on_cbtn_1_bg_checked_changed")
    local ig = create_ctrl("ImageGrid", "ig_1_item_" .. nx_string(auction_uid), form.ig_1_item, gb)
    ig.config = item_config
    ig.count = item_amount
    ig.bind = bind
    nx_bind_script(ig, nx_current())
    nx_callback(ig, "on_mousein_grid", "on_ig_mousein_grid")
    nx_callback(ig, "on_mouseout_grid", "on_ig_mouseout_grid")
    local lbl_bind = create_ctrl("Label", "lbl_1_bind_" .. nx_string(auction_uid), form.lbl_1_bind, gb)
    if nx_int(bind) == nx_int(bind) then
      lbl_bind.Visible = true
    else
      lbl_bind.Visible = false
    end
    local cbtn_attation = create_ctrl("CheckButton", "cbtn_1_attation_" .. nx_string(auction_uid), form.cbtn_1_attation, gb)
    cbtn_attation.auction_uid = nx_string(auction_uid)
    cbtn_attation.ClickEvent = true
    nx_bind_script(cbtn_attation, nx_current())
    nx_callback(cbtn_attation, "on_click", "on_cbtn_1_attation_click")
    local lbl_name = create_ctrl("Label", "lbl_1_name_" .. nx_string(auction_uid), form.lbl_1_name, gb)
    local lbl_competer = create_ctrl("Label", "lbl_1_competer_" .. nx_string(auction_uid), form.lbl_1_competer, gb)
    local lbl_price = create_ctrl("MultiTextBox", "lbl_1_price_" .. nx_string(auction_uid), form.lbl_1_price, gb)
    local lbl_time = create_ctrl("Label", "lbl_1_time_" .. nx_string(auction_uid), form.lbl_1_time, gb)
    local mltbox_price = create_ctrl("MultiTextBox", "mltbox_1_price_" .. nx_string(auction_uid), form.mltbox_1_price, gb)
    create_ctrl("Label", "lbl_1_playername_" .. nx_string(auction_uid), form.lbl_1_playername, gb)
    local color_level = nx_number(get_prop_in_ItemQuery(item_config, nx_string("ColorLevel")))
    local photo = get_prop_in_ItemQuery(item_config, nx_string("Photo"))
    ig:AddItem(0, nx_string(photo), nx_widestr(item_config), nx_int(count), 0)
    lbl_name.Text = util_text(item_config)
    lbl_name.ForeColor = color[color_level][1]
    lbl_competer.Text = nx_widestr(competer)
    if nx_widestr(competer) == nx_widestr(self_name) then
      lbl_competer.ForeColor = fore_color_you
    else
      lbl_competer.ForeColor = fore_color_other
    end
    lbl_price.HtmlText = nx_widestr(get_money_text(price))
    lbl_price.price = price
    lbl_time.Text = get_time_text(get_remain_time(end_time))
    lbl_time.end_time = end_time
    if nx_widestr(competer) == nx_widestr("") then
      lbl_competer.Text = nx_widestr(util_text("world_auction_none"))
    end
  end
end
function gridAndFunc(grid,mTextName,btn_del)
	local form = nx_value(THIS_FORM)
	local row = grid:InsertRow(-1)
	grid:SetGridControl(row, 0, mTextName)
	grid:SetGridControl(row, 1, btn_del)	
end

function btn_add_key(btn)	
	nx_auto_execute('auto_new\\autocack','util__auto_show_form','auto_new\\form_auto_set_key')	
end
function btn_add_key_func(btn)
	nx_execute('auto_new\\autocack','util__auto_show_form','auto_new\\form_auto_set_key_func')	
end
function decode_time(d_time)
  local year, month, day, hour, min, sec = nx_function("ext_decode_date", d_time)
  local min_str = ""
  if nx_number(min) < 10 then
    min_str = "0" .. nx_string(min)
  else
    min_str = nx_string(min)
  end
  local sec_str = ""
  if nx_number(sec) < 10 then
    sec_str = "0" .. nx_string(sec)
  else
    sec_str = nx_string(sec)
  end
  return nx_string(month) .. "/" .. nx_string(day) .. " " .. nx_string(hour) .. ":" .. min_str
end
function get_money_text(price)
  local ding = math.floor(nx_number(price) / 1000000)
  local liang = math.floor(nx_number(price) % 1000000 / 1000)
  local wen = math.floor(nx_number(price) % 1000)
  local gui = nx_value("gui")
  local htmlTextYinKa = nx_widestr("")
  if ding > 0 then
    local text = gui.TextManager:GetText("ui_ding")
    local htmlText = nx_widestr("<font color=\"#B1B1B1\">") .. nx_widestr(text) .. nx_widestr("</font>")
    htmlTextYinKa = htmlTextYinKa .. nx_widestr(ding) .. nx_widestr(htmlText)
  end
  if liang > 0 then
    local text = gui.TextManager:GetText("ui_liang")
    local htmlText = nx_widestr("<font color=\"#B1B1B1\">") .. nx_widestr(text) .. nx_widestr("</font>")
    htmlTextYinKa = htmlTextYinKa .. nx_widestr(" ") .. nx_widestr(liang) .. nx_widestr(htmlText)
  end
  if wen > 0 then
    local text = gui.TextManager:GetText("ui_wen")
    local htmlText = nx_widestr("<font color=\"#B1B1B1\">") .. nx_widestr(text) .. nx_widestr("</font>")
    htmlTextYinKa = htmlTextYinKa .. nx_widestr(" ") .. nx_widestr(wen) .. nx_widestr(htmlText)
  end
  if nx_number(price) == 0 then
    local text = gui.TextManager:GetText("ui_wen")
    local htmlText = nx_widestr("<font color=\"#B1B1B1\">") .. nx_widestr(text) .. nx_widestr("</font>")
    htmlTextYinKa = htmlTextYinKa .. nx_widestr("0") .. nx_widestr(htmlText)
  end
  return htmlTextYinKa
end
function get_time_text(time)
  local hour = math.floor(nx_number(time) / 3600)
  local minute = math.floor(nx_number(time) % 3600 / 60)
  local second = math.floor(nx_number(time) % 60)
  local text = nx_widestr("")
  local min_str = ""
  if nx_number(minute) < 10 then
    min_str = "0" .. nx_string(minute)
  else
    min_str = nx_string(minute)
  end
  local sec_str = ""
  if nx_number(second) < 10 then
    sec_str = "0" .. nx_string(second)
  else
    sec_str = nx_string(second)
  end
  if hour > 0 then
    text = text .. nx_widestr(hour) .. nx_widestr(":") .. nx_widestr(min_str) .. nx_widestr(":") .. nx_widestr(sec_str)
  else
    text = nx_widestr(min_str) .. nx_widestr(":") .. nx_widestr(sec_str)
  end
  return text
end
function get_remain_time(end_time)
  local now = get_sys_time()
  return nx_int((end_time - now) * 24 * 3600)
end
function on_rec_wa_attation_change(form, recordname, optype, row, clomn)
  local game_client = nx_value("game_client")
  local client_player = game_client:GetPlayer()
  if not client_player:FindRecord(recordname) then
    return 0
  end
  if optype == "add" or optype == "update" or optype == "del" or optype == "clear" then
    show_info(form)
  end
end
function on_captial2_changed(form)
  local game_client = nx_value("game_client")
  local client_player = game_client:GetPlayer()
  local capital1 = client_player:QueryProp("CapitalType2")
  local ding1 = math.floor(capital1 / 1000000)
  local liang1 = math.floor(capital1 % 1000000 / 1000)
  local wen1 = math.floor(capital1 % 1000)
  local gui = nx_value("gui")
  local htmlTextYinKa = nx_widestr("")
  if ding1 > 0 then
    local text = gui.TextManager:GetText("ui_ding")
    local htmlText = nx_widestr("<font color=\"#B1B1B1\">") .. nx_widestr(text) .. nx_widestr("</font>")
    htmlTextYinKa = htmlTextYinKa .. nx_widestr(ding1) .. nx_widestr(htmlText)
  end
  if liang1 > 0 then
    local text = gui.TextManager:GetText("ui_liang")
    local htmlText = nx_widestr("<font color=\"#B1B1B1\">") .. nx_widestr(text) .. nx_widestr("</font>")
    htmlTextYinKa = htmlTextYinKa .. nx_widestr(" ") .. nx_widestr(liang1) .. nx_widestr(htmlText)
  end
  if wen1 > 0 then
    local text = gui.TextManager:GetText("ui_wen")
    local htmlText = nx_widestr("<font color=\"#B1B1B1\">") .. nx_widestr(text) .. nx_widestr("</font>")
    htmlTextYinKa = htmlTextYinKa .. nx_widestr(" ") .. nx_widestr(wen1) .. nx_widestr(htmlText)
  end
  if capital1 == 0 then
    local text = gui.TextManager:GetText("ui_wen")
    local htmlText = nx_widestr("<font color=\"#B1B1B1\">") .. nx_widestr(text) .. nx_widestr("</font>")
    htmlTextYinKa = htmlTextYinKa .. nx_widestr("0") .. nx_widestr(htmlText)
  end
  form.mltbox_1.HtmlText = util_text("ui_auction_price_own") .. htmlTextYinKa
end
function get_sys_time()
  local msg_delay = nx_value("MessageDelay")
  if not nx_is_valid(msg_delay) then
    return
  end
  return nx_double(msg_delay:GetServerDateTime())
end
function a(info)
  nx_msgbox(nx_string(info))
end
function create_ctrl(ctrl_name, name, refer_ctrl, parent_ctrl)
  local gui = nx_value("gui")
  if not nx_is_valid(refer_ctrl) then
    return nx_null()
  end
  local ctrl = gui:Create(ctrl_name)
  if not nx_is_valid(ctrl) then
    return nx_null()
  end
  local prop_tab = nx_property_list(refer_ctrl)
  for i = 1, table.getn(prop_tab) do
    nx_set_property(ctrl, prop_tab[i], nx_property(refer_ctrl, prop_tab[i]))
  end
  nx_set_custom(parent_ctrl.ParentForm, name, ctrl)
  if nx_is_valid(parent_ctrl) then
    parent_ctrl:Add(ctrl)
  end
  ctrl.Name = name
  return ctrl
end