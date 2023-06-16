require("util_gui")
require("util_functions")
require("form_stage_main\\form_homepoint\\home_point_data")
require("admin_zdn\\zdn_form_common")
require("admin_zdn\\zdn_lib_moving")

local TimerTele = 0

function onFormOpen(form)
	local gui = nx_value("gui")
	Form.Left = (gui.Width - Form.Width) / 2
	Form.Top = (gui.Height - Form.Height) / 2
	local file = nx_resource_path() .. "yBreaker\\data\\maplist.ini"
	local MapList = {}
	local MapSection = IniReadSection(file, "MapList", false)
	local cnt = 0
	for _, __ in pairs(MapSection) do
		cnt = cnt + 1
	end
	for i = 1, cnt do
		addMapRow(form, MapSection[nx_string(i)])
	end
	loadConfig()
	-- for debug
	-- dofile("D:\\auto\\debug.lua")
	-- for debug
end

function onBtnCloseClick()
	nx_execute("form_stage_main\\form_homepoint\\form_home_point", "auto_show_hide_point_form")
end

function addMapRow(form, map)
	local map_grid = form.mapgrid
	local control = createMapHyperlink(form)
	if not nx_is_valid(control) then
		return
	end
	control.html.HtmlText = nx_widestr('<a href="">') .. getMapName(map) .. nx_widestr("</a>")
	control.Map = map
	local index = map_grid.RowCount
	map_grid:InsertRow(-1)
	map_grid:SetGridControl(index, 0, control)
end

function createMapHyperlink(form)
	local gui = nx_value("gui")
	if not nx_is_valid(gui) then
		return 0
	end
	local groupbox = gui:Create("GroupBox")
	groupbox.BackColor = "0,0,0,0"
	groupbox.NoFrame = true
	local html = gui:Create("MultiTextBox")
	groupbox:Add(html)
	groupbox.html = html
	html.Top = 7
	html.Left = 0
	html.TextColor = "255,255,255,255"
	html.SelectBarColor = "0,0,0,255"
	html.MouseInBarColor = "0,255,255,0"
	html.ViewRect = "0,0,150,30"
	html.LineHeight = 15
	html.ScrollSize = 17
	html.Width = 150
	html.ShadowColor = "0,0,0,0"
	html.Font = "font_text"
	html.NoFrame = true
	nx_bind_script(html, nx_current())
	nx_callback(html, "on_click_hyperlink", "onMapHyperlinkClick")
	return groupbox
end

function createTeleHyperLink()
	local gui = nx_value("gui")
	if not nx_is_valid(gui) then
		return 0
	end
	local groupbox = gui:Create("GroupBox")
	groupbox.BackColor = "0,0,0,0"
	groupbox.NoFrame = true
	local html = gui:Create("MultiTextBox")
	groupbox:Add(html)
	groupbox.html = html
	html.Top = 7
	html.Left = 5
	html.TextColor = "255,0,180,50"
	html.SelectBarColor = "0,0,0,255"
	html.MouseInBarColor = "0,255,255,0"
	html.ViewRect = "5,0,270,30"
	html.LineHeight = 12
	html.ScrollSize = 17
	html.Width = 275
	html.ShadowColor = "0,0,0,0"
	html.Font = "font_text"
	html.NoFrame = true
	nx_bind_script(html, nx_current())
	nx_callback(html, "on_click_hyperlink", "onTeleHyperlinkClick")
	return groupbox
end

function onMapHyperlinkClick(self, index, data)
	local map = self.Parent.Map
	local form = self.ParentForm
	local list = getHomePointList(map)
	local row_count = form.homegrid.RowCount
	for i = 0, row_count - 1 do
		form.homegrid:DeleteRow(0)
	end
	for i = 1, #list do
		addHomeRow(form, list[i])
	end
end

function onTeleHyperlinkClick(self, index, data)
	if TimerDiff(TimerTele) < 1 then
		return
	end
	TimerTele = TimerInit()
	local homePoint = self.Parent.HomePointId
	TeleToHomePoint(homePoint)
end

function addHomeRow(form, info)
	local home_grid = form.homegrid
	local control = createTeleHyperLink()
	local toBookMarkCtl = createToBookMark(info)
	if not nx_is_valid(control) then
		return
	end
	control.HomePointId = info.ID
	control.Name = info.Name
	control.html.HtmlText = nx_widestr('<a href="">') .. util_text(info.Name) .. nx_widestr("</a>")
	local row = home_grid.RowCount
	home_grid:InsertRow(-1)
	home_grid:SetGridControl(row, 0, control)
	home_grid:SetGridControl(row, 1, toBookMarkCtl)
end

function createToBookMark(info)
	local gui = nx_value("gui")
	if not nx_is_valid(gui) then
		return 0
	end
	local groupbox = gui:Create("GroupBox")
	groupbox.BackColor = "0,0,0,0"
	groupbox.NoFrame = true
	local btn = gui:Create("Button")
	groupbox:Add(btn)
	groupbox.btn = btn

	btn.NormalImage = "gui\\common\\button\\btn_right\\btn_right3_out.png"
	btn.FocusImage = "gui\\common\\button\\btn_right\\btn_right3_on.png"
	btn.PushImage = "gui\\common\\button\\btn_right\\btn_right3_down.png"
	btn.FocusBlendColor = "255,255,255,255"
	btn.PushBlendColor = "255,255,255,255"
	btn.DisableBlendColor = "255,255,255,255"
	btn.NormalColor = "0,0,0,0"
	btn.FocusColor = "0,0,0,0"
	btn.PushColor = "0,0,0,0"
	btn.DisableColor = "0,0,0,0"
	btn.Left = 0
	btn.Top = 5
	btn.Width = 18
	btn.Height = 18
	btn.BackColor = "255,192,192,192"
	btn.ShadowColor = "0,0,0,0"
	btn.TabStop = "true"
	btn.AutoSize = "true"
	btn.DrawMode = "FitWindow"
	btn.HintText = Utf8ToWstr("Thêm vào Thường dùng")
	nx_bind_script(btn, nx_current())
	nx_callback(btn, "on_click", "onBtnToBookMarkClick")
	return groupbox
end

function getHomePointList(map)
	local list = {}
	local nCount = GetSceneHomePointCount()
	if nCount <= 0 then
		return list
	end
	for i = 0, nCount - 1 do
		local bRet, hp_info = GetHomePointFromIndexNo(i)
		local sceneID = get_scene_name(nx_int(hp_info[HP_SCENE_NO]))
		if sceneID == map then
			local info = {}
			info.Name = hp_info[HP_NAME]
			info.ID = hp_info[HP_ID]
			table.insert(list, info)
		end
	end
	return list
end

function onBtnOpenOriginFormClick(btn)
	local form = nx_value("form_stage_main\\form_homepoint\\form_home_point")
	if not nx_is_valid(form) then
		return
	end
	form.Width = 670
	form.Height = 508
	nx_execute("form_stage_main\\form_homepoint\\form_home_point", "center_for_screen", form)
end

function onBtnSchoolHomePointClick()
	TeleToSchoolHomePoint()
end

function onBtnToBookMarkClick(btn)
	local gridIndex = getGridIndex(1, btn)
	local info = Form.homegrid:GetGridControl(gridIndex, 0)
	if isExists(info) then
		return
	end
	addRowToBookMark(info.HomePointId, info.Name)
	saveConfig()
end

function createDeleteButton()
	local gui = nx_value("gui")
	if not nx_is_valid(gui) then
		return 0
	end
	local groupbox = gui:Create("GroupBox")
	groupbox.BackColor = "0,0,0,0"
	groupbox.NoFrame = true
	local btn = gui:Create("Button")
	groupbox:Add(btn)
	groupbox.btn = btn

	btn.NormalImage = "gui\\common\\button\\btn_del_out.png"
	btn.FocusImage = "gui\\common\\button\\btn_del_on.png"
	btn.PushImage = "gui\\common\\button\\btn_del_down.png"
	btn.FocusBlendColor = "255,255,255,255"
	btn.PushBlendColor = "255,255,255,255"
	btn.DisableBlendColor = "255,255,255,255"
	btn.NormalColor = "0,0,0,0"
	btn.FocusColor = "0,0,0,0"
	btn.PushColor = "0,0,0,0"
	btn.DisableColor = "0,0,0,0"
	btn.Top = 6
	btn.Width = 18
	btn.Height = 18
	btn.BackColor = "255,192,192,192"
	btn.ShadowColor = "0,0,0,0"
	btn.TabStop = "true"
	btn.AutoSize = "true"
	btn.DrawMode = "FitWindow"
	btn.HintText = Utf8ToWstr("Xóa")
	nx_bind_script(btn, nx_current())
	nx_callback(btn, "on_click", "onBtnDeleteRowClick")
	return groupbox
end

function getGridIndex(columnIndex, btn)
	local g = Form.homegrid
	local cnt = g.RowCount - 1
	for i = 0, cnt do
		local ctl = g:GetGridControl(i, columnIndex)
		local b = ctl.btn
		if nx_id_equal(btn, b) then
			return i
		end
	end
end

function onBtnDeleteRowClick(btn)
	local g = Form.bookmark_grid
	local cnt = g.RowCount - 1
	for i = 0, cnt do
		local deleteGroupBox = g:GetGridControl(i, 1)
		local deleteBtn = deleteGroupBox.btn
		if nx_id_equal(deleteBtn, btn) then
			g:BeginUpdate()
			g:DeleteRow(i)
			g:EndUpdate()
			saveConfig()
			return
		end
	end
end

function saveConfig()
	local str = ""
	local g = Form.bookmark_grid
	local cnt = g.RowCount - 1
	for i = 0, cnt do
		local ctl = g:GetGridControl(i, 0)
		if str ~= "" then
			str = str .. ";"
		end
		str = str .. ctl.HomePointId .. "," .. ctl.Name
	end
	IniWriteUserConfig("Tele", "BookMark", str)
end

function isExists(info)
	local g = Form.bookmark_grid
	local cnt = g.RowCount - 1
	for i = 0, cnt do
		local ctl = g:GetGridControl(i, 0)
		if info.HomePointId == ctl.HomePointId then
			return true
		end
	end
	return false
end

function loadConfig()
	local str = nx_string(IniReadUserConfig("Tele", "BookMark", ""))
	if str ~= "" then
		local lst = util_split_string(str, ";")
		for i = 1, #lst do
			local record = util_split_string(lst[i], ",")
			addRowToBookMark(record[1], record[2])
		end
	end
end

function addRowToBookMark(homePointId, name)
	local g = Form.bookmark_grid
	local teleLink = createTeleHyperLink()
	teleLink.HomePointId = homePointId
	teleLink.Name = name
	teleLink.html.HtmlText = nx_widestr('<a href="">') .. util_text(name) .. nx_widestr("</a>")
	local delBtn = createDeleteButton()
	g:InsertRow(-1)
	g:SetGridControl(g.RowCount - 1, 0, teleLink)
	g:SetGridControl(g.RowCount - 1, 1, delBtn)
end

function onBtnMyHouseClick()
	local c = nx_value("game_client")
	if not nx_is_valid(c) then
		return
	end
	local p = c:GetPlayer()
	if not nx_is_valid(p) then
		return
	end
	local homeid = p:QueryRecord("self_home_rec", 0)
	if nx_string(homeid) ~= "0" then
		local CLIENT_SUB_ENTRY = 2
		nx_execute(
			"form_stage_main\\form_home\\form_home_msg",
			"client_to_server_msg",
			CLIENT_SUB_ENTRY,
			nx_string(homeid),
			nx_int(1)
		)
		return
	end
	ShowText("Có nhà đâu mà đòi về!")
end

function getMapName(map)
	local r = util_text(map)
	if nx_widestr(map) ~= nx_widestr(r) then
		return r
	end
	if string.find(map, "school") == 1 then
		r = util_text("scene_" .. map)
	end
	return r
end
