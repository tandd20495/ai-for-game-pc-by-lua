require("util_gui")
require("util_functions")
require("admin_zdn\\zdn_form_common")

local PRESET_PICK_ITEM = {
	"growitem_1", -- hàn nha thảo
	"TG_item_01", -- tình báo
	"TG_item_02", -- tình báo 2
	"qizhen_0101",
	"qizhen_0102",
	"qizhen_0103",
	"qizhen_0104",
	"qizhen_0105",
	"qizhen_0106",
	"qizhen_0107",
	"qizhen_0108",
	"qizhen_0109",
	"qizhen_0110",
	"qizhen_0111",
	"qizhen_0112",
	"qizhen_0113",
	"qizhen_0114",
	"qizhen_0115",
	"box_fc_mml_001", -- Ma môn lệnh x1
	"box_fc_mml_002", 
	"box_fc_mml_003", 
	"box_fc_mml_004", 
	"box_fc_mml_005", 
	"box_fc_mml_006", 
	"box_fc_mml_007", 
	"box_fc_mml_008", 
	"box_fc_mml_009", 
	"box_fc_mml_010", -- Ma môn lệnh x10
	"box_fc_hss_001", -- Hoang thú thạch x1
	"box_fc_hss_002", 
	"box_fc_hss_003",
	"box_fc_hss_004",
	"box_fc_hss_005",
	"box_fc_hss_006",
	"box_fc_hss_007",
	"box_fc_hss_008",
	"box_fc_hss_009",
	"box_fc_hss_010", -- Hoang thú thạch x10
	"box_xmp_fc_01", -- long van cam thach
	"drug_1005",	-- Xích thược
	"toxicant_1005", -- Giả Bồng
	"item_yirong_05", -- Băng Tằm Ti
	"item_yirong_07", -- Ngọc Tủy
	"item_yirong_08", -- Tử Băng Ngân Châm
	"item_yirong_09", -- Truyền Thiên Châu
	"item_yirong_10", -- Linh Cốt Thảo
	"item_yirong_12", -- Ma Phí Tán
	"buliao_1008", -- Bạch Kim Trù
	"jm_hcitem_tj_saxe_03", -- Giai Binh Song Phủ Ký
	"jm_hcitem_tj_saxe_04", -- Tinh Kim Song Phủ Thiên
	"hcitem_tj_gun_03", -- Giai Binh Trường Thương  Ký
	"hcitem_tj_gun_04", -- Tinh Kim Trường Thương Biên
	"jm_hcitem_tj_token_03", -- Giai Binh Thánh Hỏa Lệnh Ký
	"jm_hcitem_tj_token_04", -- Tinh Kim Thánh Hỏa Lệnh Thiên
	"ui_exchange_wuxue" -- Tự define trong idres Trang sách võ học
	
}

local Mode = 0 -- nhat theo list

function onFormOpen()
	local gui = nx_value("gui")
	Form.Left = (gui.Width - Form.Width) / 2
	Form.Top = (gui.Height - Form.Height) / 2
	local cnt = #PRESET_PICK_ITEM
	Form.cbx_preset.DropListBox:ClearString()
	for i = 1, cnt do
		Form.cbx_preset.DropListBox:AddString(util_text(PRESET_PICK_ITEM[i]))
	end
	Form.cbx_preset.DropListBox.SelectIndex = 0
	Form.cbx_preset.Text = util_text(PRESET_PICK_ITEM[1])
	Mode = nx_number(IniReadUserConfig("VatPham", "Mode", 0))
	Form.rbtn_pick_list.Checked = Mode ~= 1
	Form.rbtn_pick_all.Checked = Mode == 1
	updateMode()
end

function loadConfig(key)
	local itemStr = IniReadUserConfig("VatPham", key, "")
	if itemStr ~= "" then
		local itemList = util_split_string(nx_string(itemStr), ";")
		for _, item in pairs(itemList) do
			local prop = util_split_string(item, ",")
			local item = {}
			item.checked = nx_string(prop[1]) == "1" and true or false
			item.itemId = prop[2]
			item.name = util_text(prop[2])
			addRowToItemGrid(item)
		end
	end
end

function onBtnAddItemClick()
	local itemId, viewPort = getHandItem()
	if itemId == nil then
		return
	end
	doAddItem(itemId)
end

function doAddItem(itemId)
	if isItemExists(itemId) then
		ShowText("Vật phẩm này đã được thêm từ trước")
		return
	end
	local item = {}
	item.itemId = itemId
	item.name = util_text(itemId)
	item.checked = true
	addRowToItemGrid(item)
	saveConfig()
end

function addRowToItemGrid(item)
	local target = Form.item_grid
	local gridIndex = target.RowCount
	local cbtn = createCheckboxButton(item)
	local itemPhoto = createImageControl(item.name, getItemPhoto(item.itemId))
	Console(getItemPhoto(item.itemId))
	local delBtn = createDeleteButton()

	target:BeginUpdate()
	target:InsertRow(gridIndex)
	target:SetGridControl(gridIndex, 0, cbtn)
	target:SetGridControl(gridIndex, 1, itemPhoto)
	target:SetGridText(gridIndex, 2, item.name)
	target:SetGridControl(gridIndex, 3, delBtn)
	target:EndUpdate()
end

function createImageControl(name, photo)
	local gui = nx_value("gui")
	if not nx_is_valid(gui) then
		return 0
	end
	local groupbox = gui:Create("GroupBox")
	groupbox.BackColor = "0,0,0,0"
	groupbox.NoFrame = true
	local pic = gui:Create("Picture")
	groupbox:Add(pic)
	groupbox.pic = pic

	pic.NoFrame = true
	pic.Left = 0
	pic.Top = 3
	pic.Image = nx_string(photo)
	pic.Width = 40
	pic.Height = 40
	pic.CenterX = -1
	pic.CenterY = -1
	pic.ZoomWidth = 0.232420
	pic.ZoomHeight = 0.193359
	pic.LineColor = "255,128,101,74"
	pic.ShadowColor = "0,0,0,0"
	pic.HintText = name
	return groupbox
end

function createCheckboxButton(item)
	local gui = nx_value("gui")
	if not nx_is_valid(gui) then
		return 0
	end
	local groupbox = gui:Create("GroupBox")
	groupbox.BackColor = "0,0,0,0"
	groupbox.NoFrame = true
	local btn = gui:Create("CheckButton")
	groupbox:Add(btn)
	groupbox.btn = btn

	btn.Top = 14
	btn.Left = 0
	btn.Checked = item.checked
	btn.BoxSize = 12
	btn.NormalImage = "gui\\common\\checkbutton\\cbtn_2_out.png"
	btn.FocusImage = "gui\\common\\checkbutton\\cbtn_2_on.png"
	btn.CheckedImage = "gui\\common\\checkbutton\\cbtn_2_down.png"
	btn.DisableImage = "gui\\common\\checkbutton\\cbtn_2_forbid.png"
	btn.NormalColor = "255,255,255,255"
	btn.FocusColor = "255,255,255,255"
	btn.PushColor = "255,255,255,255"
	btn.DisableColor = "0,0,0,0"
	btn.PushBlendColor = "255,255,255,255"
	btn.DisableBlendColor = "255,255,255,255"
	btn.Width = 18
	btn.Height = 18
	btn.BackColor = "255,192,192,192"
	btn.ShadowColor = "0,0,0,0"
	btn.TabStop = true
	btn.AutoSize = true
	btn.InSound = "MouseOn_20"
	btn.ClickSound = "ok_7"

	btn.ZdnItemName = item.name
	btn.ZdnItemId = item.itemId
	nx_bind_script(btn, nx_current())
	nx_callback(btn, "on_checked_changed", "onCheckedChange")
	return groupbox
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
	btn.Left = 5
	btn.Top = 15
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

function getHandItem()
	local gui = nx_value("gui")
	local gameHand = gui.GameHand
	if gameHand:IsEmpty() or gameHand.Type ~= "viewitem" then
		return nil, 0
	end
	local viewPort = gameHand.Para1
	local itemIndex = gameHand.Para2
	local gameClient = nx_value("game_client")
	gameHand:ClearHand()
	if not nx_is_valid(gameClient) then
		return
	end
	local view = gameClient:GetView(viewPort)
	if not nx_is_valid(view) then
		return
	end
	local item = view:GetViewObj(itemIndex)
	if not nx_is_valid(item) then
		return nil, 0
	end
	return nx_string(item:QueryProp("ConfigID")), viewPort
end

function getItemPhoto(itemId)
	if itemId == "ui_exchange_wuxue" then
		return "icon\\wx_book\\jh_zs\\book_cs_jh_lybj01_rm.png"
	end
	local toolItemIni = nx_execute("util_functions", "get_ini", "share\\item\\tool_item.ini")
	if not nx_is_valid(toolItemIni) then
		return ""
	end
	local sectionIndexNumber = toolItemIni:FindSectionIndex(itemId)
	if sectionIndexNumber < 0 then
		return ""
	end
	return toolItemIni:ReadString(sectionIndexNumber, "Photo", "")
end

function onBtnDeleteRowClick(btn)
	local cnt = Form.item_grid.RowCount - 1
	for i = 0, cnt do
		local gb = Form.item_grid:GetGridControl(i, 3)
		local cbtn = gb.btn
		if nx_id_equal(cbtn, btn) then
			Form.item_grid:BeginUpdate()
			Form.item_grid:DeleteRow(i)
			Form.item_grid:EndUpdate()
			break
		end
	end
	saveConfig()
end

function saveConfig()
	local cnt = Form.item_grid.RowCount - 1
	local itemStr = ""
	for i = 0, cnt do
		local cbtn = Form.item_grid:GetGridControl(i, 0).btn
		if i > 0 then
			itemStr = itemStr .. ";"
		end
		itemStr = itemStr .. (cbtn.Checked and "1" or "0") .. "," .. cbtn.ZdnItemId
	end
	if Mode == 0 then
		IniWriteUserConfig("VatPham", "Pick", itemStr)
	else
		IniWriteUserConfig("VatPham", "Exclude", itemStr)
	end
end

function onCheckedChange()
	saveConfig()
end

function isItemExists(itemId)
	local cnt = Form.item_grid.RowCount - 1
	for i = 0, cnt do
		local gb = Form.item_grid:GetGridControl(i, 0)
		local btn = gb.btn
		if util_text(itemId) == util_text(btn.ZdnItemId) then
			return true
		end
	end
	return false
end

function onBtnAddFromPresetClick()
	local i = Form.cbx_preset.DropListBox.SelectIndex + 1
	doAddItem(PRESET_PICK_ITEM[i])
end

function onRbtnPickChanged(btn)
	Mode = btn.Checked and 0 or 1
	IniWriteUserConfig("VatPham", "Mode", Mode)
	updateMode()
end

function updateMode()
	Form.item_grid:BeginUpdate()
	for i = 0, Form.item_grid.RowCount - 1 do
		Form.item_grid:DeleteRow(0)
	end
	Form.item_grid:EndUpdate()

	if Mode == 0 then
		Form.cbx_preset.Visible = true
		Form.btn_add_from_preset.Visible = true
		Form.lbl_list.Text = Utf8ToWstr("Danh sách nhặt")
		Form.lbl_list.ForeColor = "255,255,255,255"
		loadConfig("Pick")
	else
		Form.cbx_preset.Visible = false
		Form.btn_add_from_preset.Visible = false
		Form.lbl_list.Text = Utf8ToWstr("Danh sách bỏ qua")
		Form.lbl_list.ForeColor = "255,210,43,43"
		loadConfig("Exclude")
	end
end
