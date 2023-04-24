require("util_functions")
require("admin_zdn\\zdn_util")
require("admin_zdn\\zdn_form_common")

local MAX_SET = 6
local TASK_LIST = {
	{
		"Mặc Định",
		"admin_zdn\\zdn_skill_default"
	},
	{
		"Vận Tiêu",
		"admin_zdn\\zdn_logic_escort"
	},
	{
		"Chiến Trường",
		"admin_zdn\\zdn_logic_chien_truong"
	},
	{
		"Hào Kiệt",
		"admin_zdn\\zdn_logic_hao_kiet"
	},
	{
		"Thiên Thê",
		"admin_zdn\\zdn_logic_thien_the"
	},
	{
		"Tung Hoành Tứ Hải",
		"admin_zdn\\zdn_logic_thth"
	},
	{
		"Thích quán",
		"admin_zdn\\zdn_logic_thich_quan"
	},
	{
		"Tinh Dao Cung",
		"admin_zdn\\zdn_logic_tdc"
	},
	{
		"Tinh Dao Biệt Viện",
		"admin_zdn\\zdn_logic_noi6_tdbv"
	},
	{
		"Lăng Tiêu Thành",
		"admin_zdn\\zdn_logic_ltt"
	}
}
local ByTask = {}

function onFormOpen()
	loadConfig()
end

function loadConfig()
	ByTask = {}
	local cnt = #TASK_LIST
	local str = nx_string(IniReadUserConfig("KyNang", "ByTask", ""))
	for i = 1, cnt do
		ByTask[i] = 1
	end
	if str ~= "" then
		local p = util_split_string(str, ";")
		for i = 1, cnt do
			local v = util_split_string(p[i], ",")
			local t = v[1]
			for j = 1, cnt do
				if t == TASK_LIST[j][2] then
					ByTask[j] = nx_number(v[2])
					break
				end
			end
		end
	end

	local cnt = #TASK_LIST
	for i = 1, cnt do
		addRow(TASK_LIST[i], ByTask[i])
	end
end

function addRow(task, set)
	local target = Form.set_grid
	local gridIndex = target.RowCount
	local ipt = createInput(task, set)

	target:BeginUpdate()
	target:InsertRow(gridIndex)
	target:SetGridText(gridIndex, 0, Utf8ToWstr(task[1]))
	target:SetGridControl(gridIndex, 1, ipt)
	target:EndUpdate()
end

function createInput(task, set)
	local gui = nx_value("gui")
	if not nx_is_valid(gui) then
		return
	end
	local groupbox = gui:Create("GroupBox")
	groupbox.BackColor = "0,0,0,0"
	groupbox.NoFrame = true
	local inputSet = gui:Create("Edit")
	groupbox:Add(inputSet)
	groupbox.input_set = inputSet
	inputSet.Left = 20
	inputSet.Top = 4
	inputSet.Width = 35
	inputSet.Height = 22
	inputSet.DragStep = "1.000000"
	inputSet.OnlyDigit = true
	inputSet.ChangedEvent = true
	inputSet.MaxLength = 1
	inputSet.MaxDigit = 9
	inputSet.TextOffsetX = "2"
	inputSet.Align = "Center"
	inputSet.SelectBackColor = "190,190,190,190"
	inputSet.Caret = "Default"
	inputSet.ForeColor = "255,255,255,255"
	inputSet.ShadowColor = "0,0,0,0"
	inputSet.Font = "font_main"
	inputSet.Cursor = "WIN_IBEAM"
	inputSet.TabStop = "true"
	inputSet.DrawMode = "ExpandH"
	inputSet.BackImage = "gui\\common\\form_line\\ibox_1.png"
	inputSet.Text = nx_widestr(set)
	inputSet.ZdnLogic = task[2]
	return groupbox
end

function onBtnSaveClick()
	local cnt = Form.set_grid.RowCount - 1
	local str = ""
	for i = 0, cnt do
		local infoNode = Form.set_grid:GetGridControl(i, 1).input_set
		if i > 0 then
			str = str .. ";"
		end
		local set = nx_number(infoNode.Text)
		if set < 1 then
			set = 1
		elseif set > MAX_SET then
			set = MAX_SET
		end
		str = str .. infoNode.ZdnLogic .. "," .. set
	end
	IniWriteUserConfig("KyNang", "ByTask", str)
end
