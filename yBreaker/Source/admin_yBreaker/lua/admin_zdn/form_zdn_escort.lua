require("admin_zdn\\zdn_form_common")
require("util_functions")
require("util_gui")
require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")

local Logic = "admin_zdn\\zdn_logic_escort"
local THIS_FORM = "admin_zdn\\form_zdn_escort"

local escortName = {
	["zdn_escort_name_1"]= "Thành Đô - Kim Châm",
	["zdn_escort_name_2"]= "Thành Đô - Nam Cung",
	["zdn_escort_name_3"]= "Thành Đô - Cái Bang trú địa",
	["zdn_escort_name_4"]= "Tô Châu - Ưng Thúy sơn trang",
	["zdn_escort_name_5"]= "Tô Châu - Ngô Vương Mộ",
	["zdn_escort_name_6"]= "Tô Châu - Thái Thạch Trường",
	["zdn_escort_name_7"]= "Kim Lăng - Mai Hoa Môn",
	["zdn_escort_name_8"]= "Kim Lăng - Hoàng Gia Lạp Trường",
	["zdn_escort_name_9"]= "Kim Lăng - Mạc Sầu Hồ Hoành Doanh",
	["zdn_escort_name_10"]="Lạc Dương - Tần Vương phủ",
	["zdn_escort_name_11"]="Lạc Dương - Yến Môn thế gia",
	["zdn_escort_name_12"]="Lạc Dương - Bão Độc trại",
	["zdn_escort_name_13"]="Yến Kinh - Quân Mã Trường",
	["zdn_escort_name_14"]="Yến Kinh - Sát nhân trang",
	["zdn_escort_name_15"]="Yến Kinh - Đông Phương thế gia"
}

function onFormOpen()
	Form.cbx_biao_type.DropListBox:ClearString()
	for i = 1, 15 do
		Form.cbx_biao_type.DropListBox:AddString(nx_function("ext_utf8_to_widestr", escortName["zdn_escort_name_".. nx_string(i)]))
	end
	local xeTieuIdx = nx_number(IniReadUserConfig("Escort", "type", 1))
	if nx_int(xeTieuIdx) <= nx_int(0) then
		xeTieuIdx = 1
	end
	Form.cbx_biao_type.DropListBox.SelectIndex = xeTieuIdx - 1
	Form.cbx_biao_type.Text = nx_function("ext_utf8_to_widestr", escortName["zdn_escort_name_".. nx_string(xeTieuIdx)]) 
	
	local maxTurn = nx_number(IniReadUserConfig("Escort", "max_turn", 5))
	if 150 < maxTurn or maxTurn < 1 then
		maxTurn = 5
	end
	Form.max_turn.Text = nx_widestr(maxTurn)
	updateView()
end

function onBtnSubmitClick()
	--local form = nx_value(THIS_FORM)
    --if not nx_is_valid(form) then
    --    return
    --end
	
	if not nx_execute(Logic, "IsRunning") then
		saveFormData()
		if nx_execute(Logic, "GetCompleteTimes") >= nx_number(IniReadUserConfig("Escort", "max_turn", 5)) then
			return
		end
		nx_execute(Logic, "Start")
		nx_execute("admin_zdn\\zdn_listener", "addListen", nx_current(), "19561", "updateView", -1)
		
		-- Check checkbox is checked
		if Form.chk_delmail.Checked then
			isDelRunning = true
		else 
			isDelRunning = false
		end
		
		-- Update view
		--updateView()
		-- Perform delete email
		--while isDelRunning do
		--	nx_pause(1)
			-- Xóa thư Minh Linh Đan
		--	xoathu("faculty_yanwu_jhdw06")
			-- Xóa thư Đơn hàng thô
			--xoathu("pingzheng_escort_001")
		--end
	else	
		isDelRunning = false
		nx_execute(Logic, "Stop")
		nx_execute("admin_zdn\\zdn_listener", "removeListen", nx_current(), "19561", "updateView")
	end
	updateView()
end

function saveFormData()
	IniWriteUserConfig("Escort", "type", Form.cbx_biao_type.DropListBox.SelectIndex + 1)
	IniWriteUserConfig("Escort", "max_turn", Form.max_turn.Text)
end

function updateView()
	if not nx_is_valid(Form) or not Form.Visible then
		return
	end
	local times = nx_execute(Logic, "GetCompleteTimes")
	Form.lbl_times.Text = nx_widestr(times)
	if nx_execute(Logic, "IsRunning") and times < nx_number(Form.max_turn.Text) then
		Form.btn_submit.Text = Utf8ToWstr("Dừng")
		Form.btn_submit.ForeColor = "255,220,20,60"
	else
		Form.btn_submit.Text = Utf8ToWstr("Chạy")
		Form.btn_submit.ForeColor = "255,255,255,255"
	end
end

function onTaskStop()
	updateView()
end

function show_hide_form_vt()
	util_auto_show_hide_form("admin_zdn\\form_zdn_escort")
end

function is_delete_mail()
	local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return
    end
	return form.chk_delmail.Checked
end

function is_auto_accept_pt()
	local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return
    end
	return form.chk_party.Checked
end