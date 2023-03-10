require("util_gui")
require("util_functions")
require("admin_zdn\\zdn_form_common")

local Logic = "admin_zdn\\zdn_logic_smart"

local MAX_SET = 6
local MAX_SKILL = 8
local Selected = 1

function onBtnSaveClick(btn)
	saveConfig(btn)
end

function onFormOpen()
	-- Form.cbx_set.DropListBox:ClearString()
	-- for i = 1, MAX_SET do
		-- Form.cbx_set.DropListBox:AddString(Utf8ToWstr("Bộ ") .. nx_widestr(i))
	-- end
	-- Form.cbx_set.DropListBox.SelectIndex = Selected - 1
	-- Form.cbx_set.Text = Utf8ToWstr("Bộ ") .. nx_widestr(Selected)
	--local cnt = Form.skill_grid.RowCount
	--if cnt > 1 then
		loadFormData()
	--end
	if nx_execute(Logic, "IsRunning") then
		nx_execute("admin_zdn\\zdn_event_manager", "Subscribe", Logic, "on-task-stop", nx_current(), "onTaskStop")
		updateBtnSubmitState(true)
	else
		updateBtnSubmitState(false)
	end
end

function onBtnSubmitClick()
	if not nx_execute(Logic, "IsRunning") then
		updateBtnSubmitState(true)
		nx_execute("admin_zdn\\zdn_event_manager", "Subscribe", Logic, "on-task-stop", nx_current(), "onTaskStop")
		nx_execute(Logic, "Start")
	else
		nx_execute(Logic, "Stop")
		updateBtnSubmitState(false)
	end
end

function onTaskStop()
	updateBtnSubmitState(false)
end

function onFormClose()
	nx_execute("admin_zdn\\zdn_event_manager", "Unsubscribe", Logic, "on-task-stop", nx_current())
end

function onSkillLeftClick(self)
	if not nx_find_custom(self, "SkillStyle") then
		nx_set_custom(self, "SkillStyle", "1")
	end
	if not nx_find_custom(self, "ConfigID") then
		nx_set_custom(self, "ConfigID", "null")
	end
	local hand_item = getHandItem()
	local pic_item = getPictureItem(self)
	setHandItem(pic_item)
	setPictureItem(self, hand_item)
	
end

function getHandItem()
	local item = {}
	local gui = nx_value("gui")
	local game_hand = gui.GameHand
	if game_hand:IsEmpty() then
		return nil
	elseif game_hand.Type == "viewitem" and game_hand.Para1 == "40" then
		local view_obj = getItem(game_hand.Para1, game_hand.Para2)
		item.ConfigID = view_obj:QueryProp("ConfigID")
		item.Image = game_hand.Image
		item.SkillStyle = "1"
	elseif game_hand.Type == "func" and game_hand.Para2 == "normal_anqi_attack" and getAnqiSkill() ~= nil then
		item.ConfigID = getAnqiSkill()
		item.Image = game_hand.Image
		item.SkillStyle = "1"
	elseif game_hand.Type == "auto_skill_set" then
		item.ConfigID = game_hand.Para1
		item.Image = game_hand.Image
		item.SkillStyle = game_hand.Para2
	else
		game_hand:ClearHand()
		return -1
	end
	return item
end

function getItem(view_ident, view_index)
	local game_client = nx_value("game_client")
	if not nx_is_valid(game_client) then
		return
	end
	local view = game_client:GetView(view_ident)
	if not nx_is_valid(view) then
		return
	end
	return view:GetViewObj(view_index)
end

function getAnqiSkill()
	local fight = nx_value("fight")
	if not nx_is_valid(fight) then
		return nil
	end
	return fight:GetNormalAnqiAttackSkillID(false)
end

function getPictureItem(pic)
	if pic.ConfigID == "null" then
		return nil
	end
	local item = {}
	item.ConfigID = pic.ConfigID
	item.SkillStyle = pic.SkillStyle
	item.Image = pic.Image
	return item
end

function setHandItem(item)
	local gui = nx_value("gui")
	local game_hand = gui.GameHand
	if item == nil then
		game_hand:ClearHand()
		return
	end
	game_hand:SetHand("auto_skill_set", item.Image, item.ConfigID, nx_string(item.SkillStyle), "", "")
end

function setPictureItem(pic, item)
	if item == -1 then
		return
	end
	if item == nil then
		pic.ConfigID = "null"
		pic.SkillStyle = "1"
		pic.Image = ""
	else
		pic.ConfigID = item.ConfigID
		pic.SkillStyle = item.SkillStyle
		pic.Image = item.Image
	end
	--updatePicture(pic)
	pic.HintText = util_text(pic.ConfigID)
end

function onSkillRightClick(self)

	self.Image = ""
	self.HintText = nx_function("ext_utf8_to_widestr", "Kéo kĩ năng vào đây")
	--updatePicture(self)
end

function updatePicture(self)
	local skillStyle = self.SkillStyle
	if skillStyle == "2" then
		self.LineColor = "255,0,255,0"
		self.HintText = nx_function("ext_utf8_to_widestr", "Nhảy lên để đánh")
	elseif skillStyle == "3" then
		self.LineColor = "255,255,0,0"
		self.HintText = nx_function("ext_utf8_to_widestr", "Đánh chiêu thức biến đổi")
	else
		self.LineColor = "255,128,101,74"
		self.HintText = nx_function("ext_utf8_to_widestr", "Chuột phải để đổi kiểu đánh")
	end
end

function onWeaponLeftClick(self)
	if not nx_find_custom(self, "UniqueID") then
		nx_set_custom(self, "UniqueID", "1")
	end
	if not nx_find_custom(self, "ConfigID") then
		nx_set_custom(self, "ConfigID", "null")
	end
	local gui = nx_value("gui")
	local game_hand = gui.GameHand
	if game_hand:IsEmpty() then
		return
	end
	if game_hand.Type == "viewitem" and game_hand.Para1 == "121" then
		if not isWeaponItem(game_hand.Para1, game_hand.Para2) then
			ShowText(nx_function("ext_utf8_to_widestr", "Yêu cầu đặt vào vũ khí"))
		else
			local item = nx_execute("goods_grid", "get_view_item", game_hand.Para1, game_hand.Para2)
			if nx_is_valid(item) then
				self.UniqueID = item:QueryProp("UniqueID")
				self.ConfigID = item:QueryProp("ConfigID")
				self.Image = game_hand.Image
				self.HintText = util_text(item:QueryProp("ConfigID"))
			end
		end
	end
	game_hand:ClearHand()
end

function isWeaponItem(view_id, pos)
	local item = nx_execute("goods_grid", "get_view_item", view_id, pos)
	if not nx_is_valid(item) then
		return false
	end
	local goods_grid = nx_value("GoodsGrid")
	local list = goods_grid:GetEquipPositionList(item)
	for _, value in pairs(list) do
		if nx_number(value) == 22 or nx_number(value) == 7 or nx_number(value) == 6 or nx_number(value) == 25 or nx_number(value) == 26 or nx_number(value) == 27 then
			return true
		end
	end
	return false
end

function onWeaponRightClick(self)
	if not nx_find_custom(self, "UniqueID") then
		nx_set_custom(self, "UniqueID", "1")
	end
	if not nx_find_custom(self, "ConfigID") then
		nx_set_custom(self, "ConfigID", "null")
	end
	self.UniqueID = "1"
	self.ConfigID = "null"
	self.Image = ""
	self.HintText = nx_function("ext_utf8_to_widestr", "Kéo vũ khí vào đây")
end

function saveConfig()
	--saveCheckConfig
	saveSkillConfig()
	saveWeaponConfig()
	saveBookConfig()
	
	ShowText(nx_function("ext_utf8_to_widestr", "Lưu thiết lập thành công"))
end

function loadFormData()
	-- loadMasterConfig()
	loadSkillConfig()
	loadWeaponConfig()
	loadBookConfig()
end

function onBookLeftClick(self)
	if not nx_find_custom(self, "UniqueID") then
		nx_set_custom(self, "UniqueID", "1")
	end
	if not nx_find_custom(self, "ConfigID") then
		nx_set_custom(self, "ConfigID", "null")
	end
	local gui = nx_value("gui")
	local game_hand = gui.GameHand
	if game_hand:IsEmpty() then
		return
	end
	if game_hand.Type == "viewitem" and game_hand.Para1 == "121" then
		if not isBookItem(game_hand.Para1, game_hand.Para2) then
			ShowText(nx_function("ext_utf8_to_widestr", "Yêu cầu đặt vào bình thư"))
		else
			local item = nx_execute("goods_grid", "get_view_item", game_hand.Para1, game_hand.Para2)
			if nx_is_valid(item) then
				self.UniqueID = item:QueryProp("UniqueID")
				self.ConfigID = item:QueryProp("ConfigID")
				self.Image = game_hand.Image
				self.HintText = util_text(item:QueryProp("ConfigID"))
			end
		end
	end
	game_hand:ClearHand()
end

function onBookRightClick(self)
	if not nx_find_custom(self, "UniqueID") then
		nx_set_custom(self, "UniqueID", "1")
	end
	if not nx_find_custom(self, "ConfigID") then
		nx_set_custom(self, "ConfigID", "null")
	end
	self.UniqueID = "1"
	self.ConfigID = "null"
	self.Image = ""
	self.HintText = nx_function("ext_utf8_to_widestr", "Kéo bình thư vào đây")
end

function isBookItem(viewId, pos)
	local item = nx_execute("goods_grid", "get_view_item", viewId, pos)
	if not nx_is_valid(item) then
		return false
	end
	local goods_grid = nx_value("GoodsGrid")
	local list = goods_grid:GetEquipPositionList(item)
	for _, value in pairs(list) do
		if nx_number(value) == 24 then
			return true
		end
	end
	return false
end

function saveCheckConfig()
	--Lưu checkbox
	local cnt = Form.skill_grid.RowCount - 1
	local itemStr = ""
	for i = 0, cnt do
		local cbtn = Form.skill_grid:GetGridControl(i, 0).btn
		if i > 0 then
			itemStr = itemStr .. ";"
		end
		itemStr =
			itemStr ..
			(cbtn.Checked and "1" or "0")
		IniWriteUserConfig("DoiTrangBi", "Num", itemStr)
	end
end
function saveSkillConfig()
	local str = ""
	--for i = 1, MAX_SKILL do
	local i = 1
		local t = Form["pic_skill_" .. nx_string(i)]
		local s = "null"
		if nx_find_custom(t, "ConfigID") and t.ConfigID ~= "null" then
			s = t.ConfigID
			--s = s .. "," .. t.SkillStyle
			s = s .. "," .. t.Image
		end
		str = str .. s
		--if i < 1 then
			--str = str .. ";"
		--end
	--end
	IniWriteUserConfig("DoiTrangBi", "S", str)
end

function saveWeaponConfig()
	local str = ""
	--for i = 1, MAX_SKILL do
	local i = 1
		--local t = Form.skill_grid:GetGridControl(i, 0)
		local t = Form["pic_weapon_" .. nx_string(i)]
		local s = "null"
		if nx_find_custom(t, "UniqueID") and t.UniqueID ~= "1" then
			s = t.UniqueID
			s = s .. "," .. t.ConfigID
			s = s .. "," .. t.Image
		end
		str = str .. s
		--if i < 1 then
			--str = str .. ";"
		--end
	--end
	IniWriteUserConfig("DoiTrangBi", "W", str)
end

function saveBookConfig()
	local str = ""
	local i = 1
	--for i = 1, MAX_SKILL do
		local t = Form["pic_book_" .. nx_string(i)]
		--local t = Form[Form.skill_grid:GetGridControl(i, 0)]
		local s = "null"
		if nx_find_custom(t, "UniqueID") and t.UniqueID ~= "1" then
			s = t.UniqueID
			s = s .. "," .. t.ConfigID
			s = s .. "," .. t.Image
		end
		str = str .. s
		--if i < 1 then
		--	str = str .. ";"
		--end
	--end
	IniWriteUserConfig("DoiTrangBi", "B", str)
end

function setPicWeaponFromStr(node, str)
	if str == "null" then
		node.UniqueID = "1"
		node.ConfigID = "null"
		node.Image = ""
		node.HintText = nx_function("ext_utf8_to_widestr", "Kéo vũ khí vào đây")
		return
	end
	local prop = util_split_string(str, ",")
	node.UniqueID = prop[1]
	node.ConfigID = prop[2]
	node.Image = prop[3]
	node.HintText = util_text(prop[2])
end

function setPicSkillFromStr(node, str)
	if str == "null" then
		node.ConfigID = "null"
		node.SkillStyle = "1"
		node.Image = ""
		node.HintText = nx_function("ext_utf8_to_widestr", "Chuột phải để đổi kiểu đánh")
		return
	end
	local prop = util_split_string(str, ",")
	node.ConfigID = prop[1]
	--node.SkillStyle = prop[2]
	node.Image = prop[2]
	node.HintText = util_text(prop[1])
end

function setPicBookFromStr(node, str)
	if str == "null" then
		node.UniqueID = "1"
		node.ConfigID = "null"
		node.Image = ""
		node.HintText = nx_function("ext_utf8_to_widestr", "Kéo bình thư vào đây")
		return
	end
	local prop = util_split_string(str, ",")
	node.UniqueID = prop[1]
	node.ConfigID = prop[2]
	node.Image = prop[3]
	node.HintText = util_text(prop[2])
end

function loadSkillConfig()
	local str =
		nx_string(IniReadUserConfig("DoiTrangBi", "S", "null;null;null;null;null;null;null;null;null"))
	local prop = util_split_string(str, ";")
	--for i = 1, MAX_SKILL do
	local i = 1
		--setPicSkillFromStr(Form.skill_grid:GetGridControl(i, 0), prop[i])
		setPicSkillFromStr(Form["pic_skill_" .. i], prop[i])
	--end
end

function loadWeaponConfig()
	local str =
		nx_string(IniReadUserConfig("DoiTrangBi", "W", "null;null;null;null;null;null;null;null;null"))
	local prop = util_split_string(str, ";")
	--for i = 1, MAX_SKILL do
	local i = 1
		--setPicWeaponFromStr( Form.skill_grid:GetGridControl(i, 0), prop[i])
		setPicWeaponFromStr(Form["pic_weapon_" .. i], prop[i])
	--end
end

function loadBookConfig()
	local str =
		nx_string(IniReadUserConfig("DoiTrangBi", "B", "null;null;null;null;null;null;null;null;null"))
	local prop = util_split_string(str, ";")
	--for i = 1, MAX_SKILL do
	local i = 1
		--setPicBookFromStr(Form.skill_grid:GetGridControl(i, 0), prop[i])
		setPicBookFromStr(Form["pic_book_" .. i], prop[i])
	--end
end

function onBtnAddRowClick()
	--local i = Form.cbx_task_list.DropListBox.SelectIndex + 1
	addRowToSwapGrid(true)
end

function addRowToSwapGrid(checked)
	--if taskExists(i) then
	--	ShowText("Kĩ năng này đã được cài đặt")
	--	return
	--end
	addRowToPositionGridByGridIndex(Form.skill_grid.RowCount, checked)
end

function addRowToPositionGridByGridIndex(gridIndex, checked)
	local cbtn = createCheckboxButton(checked)
	local picSkill = createImageCtrl("pic_skill_1", "Kéo kĩ năng vào đây", "onSkillLeftClick", "onSkillRightClick")
	local picWeapon = createImageCtrl("pic_weapon_1", "Kéo vũ khí vào đây", "onWeaponLeftClick", "onWeaponRightClick")
	local picBook = createImageCtrl("pic_book_1", "Kéo bình thư vào đây", "onBookLeftClick", "onBookRightClick")
	local delBtn = createDeleteButton()

	Form.skill_grid:BeginUpdate()
	Form.skill_grid:InsertRow(gridIndex)
	Form.skill_grid:SetGridControl(gridIndex, 0, cbtn)
	Form.skill_grid:SetGridControl(gridIndex, 1, picSkill)
	Form.skill_grid:SetGridControl(gridIndex, 2, picWeapon)
	Form.skill_grid:SetGridControl(gridIndex, 3, picBook)
	Form.skill_grid:SetGridControl(gridIndex, 4, delBtn)
	Form.skill_grid:EndUpdate()
end

function createCheckboxButton(checked)
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

	btn.Top = 15
	btn.Left = 0
	btn.Checked = checked
	btn.BoxSize = 12
	btn.NormalColor = "255,255,255,255"
	btn.FocusColor = "0,0,0,0"
	btn.PushColor = "0,0,0,0"
	btn.DisableColor = "0,0,0,0"
	btn.PushBlendColor = "255,255,255,255"
	btn.DisableBlendColor = "255,255,255,255"
	btn.Width = 16
	btn.Height = 16
	btn.BackColor = "255,192,192,192"
	btn.ForeColor = "255,255,255,255"
	btn.ShadowColor = "0,0,0,0"
	btn.TabStop = true
	btn.NoFrame = true
	btn.InSound = "MouseOn_20"
	btn.ClickSound = "ok_7"
	btn.NormalImage = "gui\\common\\checkbutton\\cbtn_2_out.png"
	btn.FocusImage = "gui\\common\\checkbutton\\cbtn_2_on.png"
	btn.CheckedImage = "gui\\common\\checkbutton\\cbtn_2_down.png"
	btn.DisableImage="gui\common\checkbutton\cbtn_2_forbid.png"
	btn.DrawMode = "ExpandH"
	btn.AutoSize="true"
	
	return groupbox
end

function createImageCtrl(nameImage, hintText, eventLeft, eventRight)
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
	
	pic.Name= nameImage
	pic.Image="" 
	pic.ZoomWidth="0.232420" 
	pic.ZoomHeight="0.193359" 
	pic.CenterX="-1" 
	pic.CenterY="-1"
	pic.Top = 7
	pic.Left = 20
	pic.Width = 40
	pic.Height = 40
	pic.LineColor="255,128,101,74" 
	pic.ShadowColor="0,0,0,0" 
	pic.HintText= hintText
	nx_bind_script(pic, nx_current())
	nx_callback(pic, "on_left_up", eventLeft)
	nx_callback(pic, "on_right_up", eventRight)
	return groupbox
end

function createDeleteButton()
	local gui = nx_value("gui")
	if not nx_is_valid(gui) then
		return
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
	btn.Left = 0
	btn.Top = 15
	btn.Width = 18
	btn.Height = 18
	btn.BackColor = "255,192,192,192"
	btn.ShadowColor = "0,0,0,0"
	btn.TabStop = "true"
	btn.AutoSize = "true"
	btn.DrawMode = "FitWindow"
	btn.HintText = Utf8ToWstr("Xóa")
	--btn.TaskListIndex = taskListIndex
	nx_bind_script(btn, nx_current())
	nx_callback(btn, "on_click", "onBtnDeleteRowClick")
	return groupbox
end

function onBtnDeleteRowClick(btn)
	local cnt = Form.skill_grid.RowCount - 1
	for i = 0, cnt do
		
		local deleteGroupBox = Form.skill_grid:GetGridControl(i, 4)
		local deleteBtn = deleteGroupBox.btn
		if nx_id_equal(deleteBtn, btn) then -- Delete cái đc chọn
			Form.skill_grid:BeginUpdate()
			Form.skill_grid:DeleteRow(i)
			Form.skill_grid:EndUpdate()
			break
		end
	end
end