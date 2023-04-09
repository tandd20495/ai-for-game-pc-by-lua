require("utils")
require("util_gui")
require("util_move")
require("util_functions")
require("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs")

local THIS_FORM = "admin_yBreaker\\yBreaker_form_hunter_set"

local tab_now = "tuiVP"
local list_item = {}

function on_form_main_init(form)
	form.Fixed = false
	form.is_minimize = false
	form.auto_start = false
	form.buy_item = false
	form.use_item = false
	form.move_to_back = false
	form.pick_up_item = false
	form.delete_item = false
	
	form.Left = 115
	form.Top = 470
end

function on_setting_open(form)
  LoadListDelete(form.combobox_tab_tuiVP_2, 2)
	-- LoadHidePoint(form)
	--LoadBlackList(form)
	LoadSetting(form)
	form.check_btn1.Checked = form.buy_item
	form.check_btn2.Checked = form.use_item
	form.check_btn3.Checked = form.move_to_back
	form.check_btn4.Checked = form.pick_up_item
	form.check_btn5.Checked = form.delete_item
	set_form_tuiVP(form)
	-- local file = assert(loadfile(nx_work_path().."autodata\\data_hunter.lua"))
	-- file()
end
function on_setting_close(form)
end

function show_hide_form_hunter_set(form)
	util_auto_show_hide_form(THIS_FORM)
end

function on_cbtn_buy_item(cbtn)
	local form = cbtn.ParentForm
	form.buy_item = cbtn.Checked
end
function on_cbtn_use_item(cbtn)
	local form = cbtn.ParentForm
	form.use_item = cbtn.Checked
end
function on_cbtn_move_to_back(cbtn)
	local form = cbtn.ParentForm
	form.move_to_back = cbtn.Checked
end
function on_cbtn_pick_up_item(cbtn)
	local form = cbtn.ParentForm
	form.pick_up_item = cbtn.Checked
end
function on_cbtn_delete_item(cbtn)
	local form = cbtn.ParentForm
	form.delete_item = cbtn.Checked
end

function UpdateStatus()
	local form = util_get_form(THIS_FORM, false, false)
	if nx_is_valid(form) then
		SaveSetting(form)
		if form.auto_start then
			form.btn_control.Text = nx_function("ext_utf8_to_widestr", "Bắt Đầu")
			form.btn_control.ForeColor = "255,0,255,0"
      form.auto_start = false
		else
			form.btn_control.Text = nx_function("ext_utf8_to_widestr", "Kết Thúc")
			form.btn_control.ForeColor = "255,255,0,0"
      form.auto_start = true
		end
	end
end

function main(cbtn)
	local form = cbtn.ParentForm
	local truonghop_nhatdo = 1
  UpdateStatus()
  while form.auto_start do
    local game_client = nx_value("game_client")
		local game_visual = nx_value("game_visual")
		if nx_is_valid(game_client) and nx_is_valid(game_visual) then
			local client_player = game_client:GetPlayer()
			local visual_player = game_visual:GetPlayer()
			-- Kiểm tra pass rương
			if not client_player:FindProp("IsCheckPass") or client_player:QueryProp("IsCheckPass") ~= 1 then
				tools_show_notice(nx_function("ext_utf8_to_widestr", "Mở khóa mật khẩu rương trước khi sử dụng"))
				UpdateStatus()
			else
				-- Nhặt item
				if form.pick_up_item then
					if nx_is_valid((nx_value("form_stage_main\\form_pick\\form_droppick"))) and nx_value("form_stage_main\\form_pick\\form_droppick").Visible then
						if truonghop_nhatdo == 1 then
							truonghop_nhatdo = 2
							form.truonghop_nhatdo.Text = nx_function("ext_utf8_to_widestr", "Nhặt NL")
							form.truonghop_nhatdo.ForeColor = "255,255,0,0"
							nx_pause(0.1)
						elseif truonghop_nhatdo == 2 then
							truonghop_nhatdo = 1
							form.truonghop_nhatdo.Text = nx_function("ext_utf8_to_widestr", "Nhặt VP")
							form.truonghop_nhatdo.ForeColor = "255,0,255,0"
							nx_pause(nx_int(form.check_input4.Text))
						end
						if nx_is_valid((nx_value("form_stage_main\\form_pick\\form_droppick"))) and nx_value("form_stage_main\\form_pick\\form_droppick").Visible then
							nx_execute("form_stage_main\\form_pick\\form_droppick", "on_btn_pick_click", nx_value("form_stage_main\\form_pick\\form_droppick").btn_pick)
							nx_pause(0.1)
						else
							nx_pause(0.2)
						end
					end
				end

				if form.buy_item then
					-- kiểm tra có công cụ thợ săn không
					local item_nghe = nx_execute("tips_data", "get_item_in_view", nx_int(2), "tool_lh_06")
					if item_nghe == nil then -- nếu không có item trong túi thì mở shop lên mua
						local form_shop = nx_value("form_stage_main\\form_shop\\form_shop")
						if nx_is_valid(form_shop) then
							nx_execute("custom_sender", "custom_buy_item", "Shop_zahuo_00102", 1, 1, 1) -- tab shop, vi tri, so luong
							nx_pause(0.25)
							nx_execute("custom_sender", "custom_open_mount_shop", 0) -- tắt shop
							nx_pause(1)
						else
							nx_execute("custom_sender", "custom_open_mount_shop", 1) -- mở shop
						end
					end
				end
				if form.use_item then
					-- cắn viên thể lực
					if client_player:QueryProp("Ene") <= 15 then
						local item_theluc = nx_execute("tips_data", "get_item_in_view", nx_int(2), "item_mp_001_a")
						if item_theluc ~= nil then
							UseItemById("item_mp_001_a", 2)
						else
							UseItemById("tili10001", 2)
						end
					end
					nx_pause(1)
				end

				-- trở về điểm cũ
				-- if form.move_to_back then

				-- end

				-- Xóa item
				--  view_id:
					--  2: túi vật phẩm;
					--  121: túi trang bị
					--  123: túi nguyên liệu
					--  125: túi nhiệm vụ
				if form.delete_item then
					-- for ... item_id
					for k = 1, table.getn(list_item) do
						if list_item[k] ~= "" then
							local item = util_split_string(nx_string(list_item[k]), ",")
							local GoodsGrid = nx_value("GoodsGrid")
							local num = GoodsGrid:GetItemCount(item[1])
							if num ~= 0 then
								local grid, grid_index = GoodsGrid:GetToolBoxGridAndPos(item[1])
								if grid_index ~= nil then
									local view_index = grid:GetBindIndex(grid_index)
									nx_execute("custom_sender", "custom_delete_item", item[2], view_index, num)
								end
							end
						end
					end
				end

			end
		end
		nx_pause(0.25)
  end
end

-----------------------------------------------------------------------------------------
function SaveSetting(form)
	local ini = nx_create("IniDocument")
	local file = GetSetting()
	if not ini:LoadFromFile() then
	end
  ini.FileName = file
	ini:WriteString("Setting", "buy_item", nx_string(form.check_btn1.Checked))
	ini:WriteString("Setting", "use_item", nx_string(form.check_btn2.Checked))
	ini:WriteString("Setting", "move_to_back", nx_string(form.check_btn3.Checked))
	ini:WriteString("Setting", "pick_up_item", nx_string(form.check_btn4.Checked))
	ini:WriteInteger("Setting", "time_pick_up_item", nx_number(form.check_input4.Text))
	ini:WriteString("Setting", "delete_item", nx_string(form.check_btn5.Checked))
	ini:SaveToFile()
	nx_destroy(ini)
end
function LoadSetting(form)
	local ini = nx_create("IniDocument")
	local file = GetSetting()
	ini.FileName = file
	if not ini:LoadFromFile() then
		return
	end
	form.buy_item = nx_boolean(ini:ReadString("Setting", "buy_item", ""))
	form.use_item = nx_boolean(ini:ReadString("Setting", "use_item", ""))
	form.move_to_back = nx_boolean(ini:ReadString("Setting", "move_to_back", ""))
	form.pick_up_item = nx_boolean(ini:ReadString("Setting", "pick_up_item", ""))
	form.check_input4.Text = nx_widestr(ini:ReadString("Setting", "time_pick_up_item", 1))
	form.delete_item = nx_boolean(ini:ReadString("Setting", "delete_item", ""))
end
function GetSetting()
  local game_config = nx_value("game_config")
  local account = game_config.login_account
  local dir = nx_function("ext_get_current_exe_path") .. "yBreaker_" .. account
  local file = ""
  if not nx_function("ext_is_exist_directory", nx_string(dir)) then
    nx_function("ext_create_directory", nx_string(dir))
  end
	file = dir .. nx_string("\\JobsData_Hunter.ini")
  if not nx_function("ext_is_file_exist", file) then
		local set = nx_create("StringList")
		set:AddString("[Setting]")
		set:AddString("buy_item=true")
		set:AddString("use_item=false")
		set:AddString("move_to_back=true")
		set:AddString("pick_up_item=false")
		set:AddString("time_pick_up_item=2.5")
		set:AddString("delete_item=false")
		set:SaveToFile(file)
	end
  return file
end
-----------------------------------------------------------------------------------------
function on_btn_tab_tuiVP_1(btn)
	local form = btn.ParentForm
	if string.len(nx_string(form.tab_TuiVP_1_input.Text)) > 0 and form.tab_TuiVP_1_input.Text ~= "" and form.tab_TuiVP_1_input.Text ~= nil then -- độ dài chuỗi nhập vào > 0 và ô input không bỏ trống và khác nil
		local item_id = nx_function("ext_widestr_to_utf8", nx_widestr(form.tab_TuiVP_1_input.Text))
		local name_item = nx_function("ext_widestr_to_utf8", util_text(item_id))
		if is_in_pick_list(name_item .. ",2") then
			tools_show_notice(nx_function("ext_utf8_to_widestr", "<font color=\"#fa0000\">" .. name_item .. "</font> đã tồn tại trong danh sách sẽ xóa"))
		else
			if addItemFile(item_id, 2, form.combobox_tab_tuiVP_2) then
				tools_show_notice(nx_function("ext_utf8_to_widestr", "<font color=\"#fa0000\">" .. name_item .. "</font> thêm vào danh sách xóa thành công!"))
			else
				tools_show_notice(nx_function("ext_utf8_to_widestr", "<font color=\"#fa0000\">" .. name_item .. "</font> thêm vào danh sách xóa không thành công!"))
			end
		end
	else
    local textchat = nx_value("gui").TextManager:GetFormatText(nx_string('<img src=\"skin\\admin_yBreaker\\yBreaker_sign_dt.png\" valign=\"bottom\" /><font color=\"#f8a5c2\">{@1:text}</font> {@0:text}'), nx_widestr(nx_function("ext_utf8_to_widestr","Vui lòng điền vật phẩm bạn muốn xóa")), nx_widestr(nx_function("ext_utf8_to_widestr","[yBreaker]:")))
    nx_value("form_main_chat"):AddChatInfoEx(textchat, 17, false)
    nx_value("SystemCenterInfo"):ShowSystemCenterInfo(textchat, 3)
	end
end

function on_btn_tab_tuiVP_2(btn)
	local form = btn.ParentForm
	if string.len(nx_string(form.combobox_tab_tuiVP_2.Text)) > 0 and form.combobox_tab_tuiVP_2.Text ~= "" and form.combobox_tab_tuiVP_2.Text ~= nil then
		local name_item = nx_function("ext_widestr_to_utf8", form.combobox_tab_tuiVP_2.Text)
		if is_in_pick_list(name_item .. ",2") then
			removeItemFile(form.combobox_tab_tuiVP_2, 2)
			-- đã xóa vật phẩm x ra khỏi danh sách thành công
			tools_show_notice(nx_function("ext_utf8_to_widestr", "Đã xóa vật phẩm <font color=\"#fa0000\">" .. name_item .. "</font> ra khỏi danh sách thành công"))
		else
			-- Vật phẩm x k có trong danh sách
			tools_show_notice(nx_function("ext_utf8_to_widestr", "Vật phẩm <font color=\"#fa0000\">" .. name_item .. "</font> không có trong danh sách"))
		end
	else
		-- vui lòng chọn vật phẩm bạn muốn xóa
		tools_show_notice(nx_function("ext_utf8_to_widestr", "Vui lòng chọn vật phẩm bạn muốn xóa"))
	end
end

-----------------------------------------------------------------------------------------
function on_btn_tab_tuiNL_1(btn)
	local form = btn.ParentForm
	if string.len(nx_string(form.tab_TuiNL_1_input.Text)) > 0 and form.tab_TuiNL_1_input.Text ~= "" and form.tab_TuiNL_1_input.Text ~= nil then -- độ dài chuỗi nhập vào > 0 và ô input không bỏ trống và khác nil
		local item_id = nx_function("ext_widestr_to_utf8", nx_widestr(form.tab_TuiNL_1_input.Text))
		local name_item = nx_function("ext_widestr_to_utf8", util_text(item_id))
		if is_in_pick_list(name_item .. ",123") then
			tools_show_notice(nx_function("ext_utf8_to_widestr", "<font color=\"#fa0000\">" .. name_item .. "</font> đã tồn tại trong danh sách sẽ xóa"))
		else
			if addItemFile(item_id, 123, form.combobox_tab_tuiNL_2) then
				tools_show_notice(nx_function("ext_utf8_to_widestr", "<font color=\"#fa0000\">" .. name_item .. "</font> thêm vào danh sách xóa thành công!"))
			else
				tools_show_notice(nx_function("ext_utf8_to_widestr", "<font color=\"#fa0000\">" .. name_item .. "</font> thêm vào danh sách xóa không thành công!"))
			end
		end
	else
    local textchat = nx_value("gui").TextManager:GetFormatText(nx_string('<img src=\"skin\\admin_yBreaker\\yBreaker_sign_dt.png\" valign=\"bottom\" /><font color=\"#f8a5c2\">{@1:text}</font> {@0:text}'), nx_widestr(nx_function("ext_utf8_to_widestr","Vui lòng điền vật phẩm bạn muốn xóa")), nx_widestr(nx_function("ext_utf8_to_widestr","[Angel Auto]:")))
    nx_value("form_main_chat"):AddChatInfoEx(textchat, 17, false)
    nx_value("SystemCenterInfo"):ShowSystemCenterInfo(textchat, 3)
	end
end

function on_btn_tab_tuiNL_2(btn)
	local form = btn.ParentForm
	if string.len(nx_string(form.combobox_tab_tuiNL_2.Text)) > 0 and form.combobox_tab_tuiNL_2.Text ~= "" and form.combobox_tab_tuiNL_2.Text ~= nil then
		local name_item = nx_function("ext_widestr_to_utf8", form.combobox_tab_tuiNL_2.Text)
		if is_in_pick_list(name_item .. ",123") then
			removeItemFile(form.combobox_tab_tuiNL_2, 123)
			-- đã xóa vật phẩm x ra khỏi danh sách thành công
			tools_show_notice(nx_function("ext_utf8_to_widestr", "Đã xóa vật phẩm <font color=\"#fa0000\">" .. name_item .. "</font> ra khỏi danh sách thành công"))
		else
			-- Vật phẩm x k có trong danh sách
			tools_show_notice(nx_function("ext_utf8_to_widestr", "Vật phẩm <font color=\"#fa0000\">" .. name_item .. "</font> không có trong danh sách"))
		end
	else
		-- vui lòng chọn vật phẩm bạn muốn xóa
		tools_show_notice(nx_function("ext_utf8_to_widestr", "Vui lòng chọn vật phẩm bạn muốn xóa"))
	end
end
-------------------------------------------------------

function is_in_pick_list(content)
	local game_config = nx_value("game_config")
  local account = game_config.login_account
	local dir = nx_function("ext_get_current_exe_path") .. "yBreaker_" .. account
	local file = dir .. nx_string("\\JobsData_Hunter_DeleteItemsList.ini")
	local gm_list = nx_create("StringList")
	if not gm_list:LoadFromFile(file) then
		nx_destroy(gm_list)
		return false
	end
	local gm_num = gm_list:GetStringCount()
	for i = 0, gm_num - 1 do
		local gm = gm_list:GetStringByIndex(i)
		local item = util_split_string(nx_string(gm), ",")
		local str = nx_function("ext_widestr_to_utf8", util_text(item[1])) .. "," .. item[2]
		if gm ~= "" and str == content then
			return true
		end
	end
	return false
end

function GetListDeleteDir(type)

end

function addItemFile(item_id, view_id, form_combobox)
	local game_config = nx_value("game_config")
	local account = game_config.login_account
	local dir = nx_function("ext_get_current_exe_path") .. "yBreaker_" .. account 
	local file = dir .. nx_string("\\JobsData_Hunter_DeleteItemsList.ini")
	local gm_list = nx_create("StringList")
	if not nx_function("ext_is_file_exist", file) then
		local thth = nx_create("StringList")
		thth:SaveToFile(file)
	end
	if not gm_list:LoadFromFile(file) then
		nx_destroy(gm_list)
		return false
	end
	local string = item_id .. "," .. view_id
	gm_list:AddString(string)
	gm_list:SaveToFile(file)
	LoadListDelete(form_combobox, view_id)
	return true
end

function removeItemFile(form_combobox, view_id)
	local form = util_get_form(THIS_FORM, false, false)
	local game_config = nx_value("game_config")
	local account = game_config.login_account
	local dir = nx_function("ext_get_current_exe_path") .. "yBreaker_" .. account
	local file = dir .. nx_string("\\JobsData_Hunter_DeleteItemsList.ini")
	local gm_list = nx_create("StringList")

	for k = 1, table.getn(list_item) do
		local item = util_split_string(nx_string(list_item[k]), ",")
		if item[1] ~= "" and nx_function("ext_widestr_to_utf8", util_text(item[1])) ~= nx_function("ext_widestr_to_utf8", nx_widestr(form_combobox.Text)) then
			gm_list:AddString(list_item[k])
		end
	end
	gm_list:SaveToFile(file)
	LoadListDelete(form_combobox, view_id)
end

function LoadListDelete(form_combobox, view_id)
	local game_config = nx_value("game_config")
	local account = game_config.login_account
	local dir = nx_function("ext_get_current_exe_path") .. "yBreaker_" .. account 
	local file = dir .. nx_string("\\JobsData_Hunter_DeleteItemsList.ini")
	local gm_list = nx_create("StringList")
	if not gm_list:LoadFromFile(file) then
		nx_destroy(gm_list)
		return 0
	end
	list_item = {}
	form_combobox.InputEdit.Text = ""
	form_combobox.DropListBox.SelectIndex = 0
	form_combobox.DropListBox:ClearString()
	local gm_num = gm_list:GetStringCount()
	for i = 0, gm_num - 1 do
		local gm = gm_list:GetStringByIndex(i)
		if gm ~= "" then
			local gui = nx_value("gui")
			if nx_is_valid(gui) then
				local item = util_split_string(nx_string(gm), ",")
				if nx_number(item[2]) == view_id then
					form_combobox.DropListBox:AddString(util_text(item[1]))
				end
			end
			list_item[i+1] = gm
			form_combobox.OnlySelect = true
		end
	end
end

--------------------------------------------------------------------------------
function on_tabtuiVP_click(cbtn)
	local form = cbtn.ParentForm
	if not nx_is_valid(form) then
		return
	end
	if tab_now == "tuiVP" then
		return
	end
	set_form_tuiVP(form)
	LoadListDelete(form.combobox_tab_tuiVP_2, 2)
end
function on_tabtuiNL_click(cbtn)
	local form = cbtn.ParentForm
	if not nx_is_valid(form) then
		return
	end
	if tab_now == "tuiNL" then
		return
	end
	set_form_tuiNL(form)
	LoadListDelete(form.combobox_tab_tuiNL_2, 123)
end

function set_form_tuiVP(form)
	tab_now = "tuiVP"
	if not nx_is_valid(form) then
		return 0
	end
	form.tabVP.Checked = true
	form.GroupTuiVP.Visible = true
	form.tabNL.Checked = false
	form.GroupTuiNL.Visible = false
end
function set_form_tuiNL(form)
	tab_now = "tuiNL"
	if not nx_is_valid(form) then
		return 0
	end
	form.tabVP.Checked = false
	form.GroupTuiVP.Visible = false
	form.tabNL.Checked = true
	form.GroupTuiNL.Visible = true
end