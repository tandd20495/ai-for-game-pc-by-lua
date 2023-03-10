require("util_gui")
require("define\\gamehand_type")
require("const_define")

local tools_btns_data = {
	{
		"1", -- Auto bày shops online
		"gui\\special\\btn_main40rh\\btn_stall_on.png",
		"tools_stallonline",
		"auto_tools\\tools_stall",
		"",
		1
	},
	{
		"2", -- Auto đàn
		"gui\\special\\btn_main40rh\\btn_drama_on.png",
		"tool_auto_qingame_label",
		"auto_tools\\tools_qingame",
		"auto_init",
		0
	},
	{
		"3", -- Mở tạp hóa
		"gui\\special\\btn_main40rh\\btn_shop_on.png",
		"tool_grocery_label",
		"auto_tools\\tools_grocery",
		"auto_init",
		0
	},
	{
		"4", -- Auto vận tiêu
		"gui\\special\\btn_main40rh\\btn_enchou_on.png",
		"tool_auto_escort_label",
		"auto\\escort",
		"",
		1
	},
	{
		"5", -- Nút để test các chức năng
		"gui\\special\\btn_main40rh\\btn_role_on.png",
		"tool_auto_test",
		"auto_tools\\tools_test",
		"auto_init",
		0
	},
	{
		"6", -- Auto trồng trọt
		"gui\\special\\btn_main40rh\\btn_life_on.png",
		"tool_crop",
		"auto_tools\\tools_crop",
		"tools_show_form",
		1
	},
	{
		"7", -- Auto đông hải
		"gui\\special\\btn_main40rh\\boss_on.png",
		"tool_auto_donghai_label",
		"auto\\donghai",
		"",
		1
	},
	{
		"8", -- Auto đào khoáng, hái thuốc
		"gui\\special\\btn_main40rh\\btn_lxc_on.png",
		"tool_auto_minemedi_label",
		"auto_tools\\tools_hailuom",
		"tools_show_form",
		1
	},
	{
		"9", -- Auto thích quán today
		"gui\\mainform\\smallgame\\fishing_fish.png",
		"tool_auto_tiguan_label_today",
		"auto\\auto_tiguan_today",
		"",
		1
	},
	{
		"10", -- Auto Thần hành
		"gui\\special\\btn_main40rh\\btn_higherpk_on.png",
		"tool_auto_thanhanh_label",
		"auto_tools\\tools_homepoint",
		"",
		1
	},
	{
		"11", -- Auto phát hiện rương khoái hoạt đảo
		"gui\\special\\btn_main40rh\\btn_bangpaizhan_on.png",
		"tool_auto_khddetect_label",
		"auto_tools\\tools_khddetect",
		"auto_init",
		0
	},
	{
		"12", -- Auto tung hoành tứ hải
		"gui\\special\\btn_main40rh\\btn_cdsh_on.png",
		"tool_auto_tiguan_label",
		"auto\\auto_tiguan",
		"",
		1
	},
		{
		"13", -- Auto check thời gian reset cóc
		"gui\\special\\btn_main40rh\\btn_webexchange_on.png",
		"tool_auto_lookupabduct_label",
		"auto_tools\\tools_lookupabduct",
		"",
		1
	},
	{
		"14", -- Auto nhận kỳ ngộ
		"gui\\special\\btn_main40rh\\btn_adventure_on.png",
		"tool_auto_captureqt_label",
		"auto_tools\\tools_captureqt",
		"auto_init",
		0
	},
	{
		"15", -- Auto cóc
		"gui\\special\\btn_main40rh\\btn_trade_on.png",
		"tool_about",
		"auto\\about",
		"",
		1
	},
{
		"16", -- Auto Luyện công
		"gui\\special\\btn_main40rh\\btn_menpai_on.png",
		"tool_auto_luyencong_label",
		"auto_tools\\tools_luyencong",
		"auto_init",
		0
	},
	{
		"17", -- Auto skill
		"gui\\special\\btn_main40rh\\btn_xinfa_on.png",
		"tool_auto_skill_label",
		"auto_tools\\tools_skill",
		"auto_init",
		0
	},
	{
		"18", -- Auto thụ nghiệp 
		"gui\\special\\btn_main40rh\\btn_gmcc_out.png",
		"tool_auto_thunghiep_label",
		"auto_tools\\tools_thunghiep",
		"auto_init",
		0
	},
	{
		"19", -- Auto rao
		"gui\\special\\btn_main40rh\\btn_gmcc_out.png",
		"tool_auto_chat_label",
		"auto_tools\\tools_chat",
		"",
		1
	},

	{
		"20", -- Nút để test các chức năng
		"gui\\special\\btn_main40rh\\szg_on.png",
		"tool_test_luastring",
		"auto_tools\\tools_dofile",
		"auto_init",
		0
	}
}

-- Max BTN current = 19

function on_form_main_init(self)
  self.start_timer = false
end
function on_main_form_open(self)
  local form_main = nx_value("form_stage_main\\form_main\\form_main")
  if not nx_is_valid(form_main) then
    on_main_form_close(self)
    return
  end

  local main_btn = form_main.clicked_btn
  local btn_count = table.getn(tools_btns_data)
  local groupscrollbox_height = round(btn_count / 2, 0)

  if btn_count <= 0 or not nx_is_valid(main_btn) then
    on_main_form_close(self)
    return
  end

  local gui = nx_value("gui")
  self.Width = 520
  self.Height = groupscrollbox_height * 35
  self.AbsLeft = main_btn.AbsLeft + main_btn.Width - 7
  self.AbsTop = main_btn.AbsTop + main_btn.Height - self.Height

  self.groupscrollbox_1.Width = 260
  self.groupscrollbox_1.Height = groupscrollbox_height * 35
  self.groupscrollbox_1.Left = 0
  self.groupscrollbox_1.Top = 0

  self.groupscrollbox_2.Width = 260
  self.groupscrollbox_2.Height = groupscrollbox_height * 35
  self.groupscrollbox_2.Left = 260
  self.groupscrollbox_2.Top = 0

  self.imagegrid_sel.Visible = false
  self.imagegrid_sel2.Visible = false

  for i = 1, btn_count do
    local btn_name = tools_btns_data[i][1]
    local btn_pic = tools_btns_data[i][2]
    if btn_name ~= "" and btn_pic ~= "" then
      local btn_tip = tools_btns_data[i][3]
      local text = nx_widestr("")
      text = gui.TextManager:GetText(btn_tip)
      local x = 0
      local y = (round(i / 2, 0) - 1) * 35
	  if i % 2 == 0 then
		  on_create_groupbox(self.groupscrollbox_2, x, y, btn_pic, text, btn_name, 2)
	  else
		  on_create_groupbox(self.groupscrollbox_1, x, y, btn_pic, text, btn_name, 1)
	  end
    end
  end
  self.start_timer = false
end
function check_form_show(form)
  if not nx_is_valid(form) then
    return
  end
  local left = form.AbsLeft
  local top = form.AbsTop
  local right = left + form.Width
  local bottom = top + form.Height - 5
  local gui = nx_value("gui")
  local cursor_x, cursor_y = gui:GetCursorPosition()
  if cursor_x > left - 2 and cursor_x < right - 2 and cursor_y > top - 5 and bottom > cursor_y then
    return
  else
    close_form()
  end
end
function on_groupscrollbox_1_get_capture(self)
  local form_main = nx_value("form_stage_main\\form_main\\form_main")
  if not nx_is_valid(form_main) then
    return
  end
  nx_execute("form_stage_main\\form_main\\form_main", "on_del_hide_func_timer", form_main)
  nx_execute("form_stage_main\\form_main\\form_main", "on_del_hide_tools_func_timer", form_main)
end
function on_groupscrollbox_2_get_capture(self)
  local form_main = nx_value("form_stage_main\\form_main\\form_main")
  if not nx_is_valid(form_main) then
    return
  end
  nx_execute("form_stage_main\\form_main\\form_main", "on_del_hide_func_timer", form_main)
  nx_execute("form_stage_main\\form_main\\form_main", "on_del_hide_tools_func_timer", form_main)
end
function on_main_form_close(self)
  local timer = nx_value(GAME_TIMER)
  if nx_is_valid(timer) then
    timer:UnRegister(nx_current(), "check_form_show", self)
  end
  nx_destroy(self)
end
function on_imagegrid_sel_lost_capture(grid)
  local form = grid.ParentForm
  local left = form.AbsLeft
  local top = form.AbsTop
  local right = left + form.Width
  local bottom = top + form.Height - 5
  local gui = nx_value("gui")
  local cursor_x, cursor_y = gui:GetCursorPosition()
  if cursor_x > left - 2 and cursor_x < right - 2 and cursor_y > top - 5 and bottom > cursor_y then
    return
  else
    close_form()
  end
end
function on_imagegrid_sel2_lost_capture(grid)
  local form = grid.ParentForm
  local left = form.AbsLeft
  local top = form.AbsTop
  local right = left + form.Width
  local bottom = top + form.Height - 5
  local gui = nx_value("gui")
  local cursor_x, cursor_y = gui:GetCursorPosition()
  if cursor_x > left - 2 and cursor_x < right - 2 and cursor_y > top - 5 and bottom > cursor_y then
    return
  else
    close_form()
  end
end
function on_imagegrid_sel_get_capture(grid)
  local form_main = nx_value("form_stage_main\\form_main\\form_main")
  nx_execute("form_stage_main\\form_main\\form_main", "on_del_hide_func_timer", form_main)
  local timer = nx_value(GAME_TIMER)
  if nx_is_valid(timer) then
    timer:UnRegister(nx_current(), "check_form_show", form_main)
  end
  on_groupscrollbox_1_get_capture(grid)
end
function on_imagegrid_sel2_get_capture(grid)
  local form_main = nx_value("form_stage_main\\form_main\\form_main")
  nx_execute("form_stage_main\\form_main\\form_main", "on_del_hide_func_timer", form_main)
  local timer = nx_value(GAME_TIMER)
  if nx_is_valid(timer) then
    timer:UnRegister(nx_current(), "check_form_show", form_main)
  end
  on_groupscrollbox_2_get_capture(grid)
end
function on_imagegrid_sel_select_changed(grid, index)
  local selnumber = tonumber(grid.sel_name)
  local btnsnum = table.getn(tools_btns_data)
  for i = 1, btnsnum do
    local data = tools_btns_data[i]
	local datanumber = tonumber(data[1])
	if datanumber == selnumber then
	  local form_path = data[4]
	  local form_func = data[5]
	  if form_path == "" then
		return
	  end
	  if data[6] ~= 0 then
		util_auto_show_hide_form(form_path)
	  elseif form_func ~= "" then
		nx_execute(form_path, form_func)
	  end
	  break
	end
  end
end
function on_imagegrid_sel2_select_changed(grid, index)
  local selnumber = tonumber(grid.sel_name)
  local btnsnum = table.getn(tools_btns_data)
  for i = 1, btnsnum do
    local data = tools_btns_data[i]
	local datanumber = tonumber(data[1])
	if datanumber == selnumber then
	  local form_path = data[4]
	  local form_func = data[5]
	  if form_path == "" then
		return
	  end
	  if data[6] ~= 0 then
		util_auto_show_hide_form(form_path)
	  elseif form_func ~= "" then
		nx_execute(form_path, form_func)
	  end
	  break
	end
  end
end
function on_create_groupbox(form, x, y, image, text, name, sel_index)
  if not nx_is_valid(form) then
    return
  end
  local gui = nx_value("gui")
  local groupbox = gui:Create("GroupBox")
  if not nx_is_valid(groupbox) then
    return
  end
  local lbl_img = gui:Create("Label")
  local lbl_text = gui:Create("Label")
  if not nx_is_valid(lbl_img) or not nx_is_valid(lbl_text) then
    gui:Delete(groupbox)
    return
  end
  form:Add(groupbox)
  groupbox.Width = 260
  groupbox.Height = 35
  groupbox.Left = x
  groupbox.Top = y
  groupbox.Name = name
  groupbox.NoFrame = true
  groupbox.BackColor = "0,255,255,255"
  nx_bind_script(groupbox, nx_current())
  if sel_index == 1 then
	nx_callback(groupbox, "on_get_capture", "on_groupbox_get_capture")
  else
	nx_callback(groupbox, "on_get_capture", "on_groupbox2_get_capture")
  end
  groupbox:Add(lbl_img)
  lbl_img.Width = 36
  lbl_img.Height = 36
  lbl_img.Left = 4
  lbl_img.Top = 0
  lbl_img.BackImage = image
  lbl_img.DrawMode = FitWindow
  lbl_img.BlendColor = "255,255,255,255"
  groupbox:Add(lbl_text)
  lbl_text.Width = 260
  lbl_text.Height = 31
  lbl_text.Left = 46
  lbl_text.Top = 2
  lbl_text.Text = text
  lbl_text.ForeColor = "255,255,255,255"
  lbl_text.Font = "font_main"
end
function on_groupbox_get_capture(groupbox)
  if not nx_is_valid(groupbox) then
    return
  end
  nx_execute("tips_game", "hide_tip")
  local form = groupbox.ParentForm
  local helper_form = nx_value("helper_form")
  if not helper_form and form.start_timer ~= true then
    local timer = nx_value(GAME_TIMER)
    if nx_is_valid(timer) then
      timer:Register(1000, -1, nx_current(), "check_form_show", form, -1, -1)
      form.start_timer = true
    end
  end
  imggrid = form.imagegrid_sel
  imggrid:Clear()
  imggrid:SetSelectItemIndex(-1)
  imggrid.Width = groupbox.Width - 9
  imggrid.Height = groupbox.Height - 2
  imggrid.AbsLeft = groupbox.AbsLeft + 2
  imggrid.AbsTop = groupbox.AbsTop + 1
  imggrid.Visible = true
  imggrid.sel_name = groupbox.Name
  imggrid.GridPos = "0,0;"
  imggrid.GridWidth = groupbox.Width
  imggrid.GridHeight = groupbox.Height
  imggrid:AddItem(0, "", nx_widestr(""), 1, 1)
end
function on_groupbox2_get_capture(groupbox)
  if not nx_is_valid(groupbox) then
    return
  end
  nx_execute("tips_game", "hide_tip")
  local form = groupbox.ParentForm
  local helper_form = nx_value("helper_form")
  if not helper_form and form.start_timer ~= true then
    local timer = nx_value(GAME_TIMER)
    if nx_is_valid(timer) then
      timer:Register(1000, -1, nx_current(), "check_form_show", form, -1, -1)
      form.start_timer = true
    end
  end
  imggrid = form.imagegrid_sel2
  imggrid:Clear()
  imggrid:SetSelectItemIndex(-1)
  imggrid.Width = groupbox.Width - 9
  imggrid.Height = groupbox.Height - 2
  imggrid.AbsLeft = groupbox.AbsLeft + 2
  imggrid.AbsTop = groupbox.AbsTop + 1
  imggrid.Visible = true
  imggrid.sel_name = groupbox.Name
  imggrid.GridPos = "0,0;"
  imggrid.GridWidth = groupbox.Width
  imggrid.GridHeight = groupbox.Height
  imggrid:AddItem(0, "", nx_widestr(""), 1, 1)
end
function close_form()
  local form = nx_value("auto_tools\\form_func_btns_tools")
  if nx_is_valid(form) then
    form.Visible = false
    form:Close()
  end
end
function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end
