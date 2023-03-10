require('auto_new\\autocack')
if not load_auto_ai then
	auto_cack('3')
	auto_cack('6')
	auto_cack('8')
	auto_cack('1')
	auto_cack('0')
	load_auto_ai = true
end
path_ini = nil
local path_form = 'auto_new\\form_auto_ai'
function main_form_init(form)
  form.Fixed = false
  form.choose_type_escort = 0
  form.map_ot = ''
end
local record_list = nil
local record_list_array = nil
function on_main_form_open(form)	
	path_ini = add_file_user('auto_ai')		
	load_auto_grid(form)	
	updateBtn()	
	for i = 1, table.getn(AUTO_AI_ARRAY) do
		if nx_running('auto_new\\form_auto_ai',nx_string(AUTO_AI_ARRAY[i].RUN))  then			
			print_auto_ai_func(AUTO_AI_ARRAY[i].NAME)	
		end		
	end
	on_load_around_resource()
end
auto_title_array =
{
	'Auto Ổn định nhất khi sử dụng với các Auto AI ',
	'Khi chạy Riêng vui lòng tắt AI trước rồi mới bắt đầu chạy ',
	'Lưu Ý: Hãy cài đặt đầy đủ các Auto đã thêm trước khi bắt đầu AI',	
	'Các hướng dẫn thường ở góc trái dấu ? trên bản Auto ',
	'Nếu có lỗi hãy liên hệ fanpage chụp hình lỗi và gửi AD nhé ',
	'Link Fanpage: https://www.facebook.com/autocacknew/ ',
	'Link Website: https://autocack.net ',
	
}
on_load_around_resource = function()
	local game_client = nx_value('game_client')
	if not nx_is_valid(game_client) then return end
	local client_player = game_client:GetPlayer()
	if not nx_is_valid(client_player) then return end
	local form = nx_value('auto_new\\form_auto_ai')
	local gui = nx_value('gui')	
	local title = form.lbl_highest_priority_title.Text
	local time_next = timerStart()
	local count = 1
	while nx_is_valid(form) and form.Visible do
		local scene = game_client:GetScene()
		if nx_string(nx_value('loading')) == nx_string('false') and nx_string(nx_value('stage_main')) == nx_string('success') and nx_is_valid(scene) then	
			if count > #auto_title_array then count = 1 end
			if timerDiff(time_next) > 7 then
				form.lbl_highest_priority_title.Text = utf8ToWstr(auto_title_array[count])
				time_next = timerStart()
				count = count + 1
			end				
		end
		nx_pause(1)
	end
	if nx_is_valid(form) and form.Visible then form:Close() end
end

on_click_open_auto = function(btn)
	local form = btn.ParentForm
	local index = nx_number(btn.DataSource)
	local file = add_file_user('auto_ai')
	local list_new = ''
	local string_ini = wstrToUtf8(readIni(file,nx_string('Setting'),'list',''))
	local string_list = auto_split_string(string_ini,';')	
	local split_auto = auto_split_string(string_list[index],',')
	local run_off
	if nx_string(split_auto[5]) == '1' then
		run_off = '0'
	else
		run_off = '1'
	end
	local string_new = nx_string(split_auto[1])..','..nx_string(split_auto[2])..','..nx_string(split_auto[3])..','..nx_string(split_auto[4])..','..nx_string(run_off)		
	for i = 1 , table.getn(string_list) do		
		string_list[index] = string_new	
		list_new = list_new..';'..string_list[i]
	end	
	writeIniString(file,nx_string('Setting'), "list",list_new)	
	load_auto_grid(form)
end
load_setting_auto_ai = function(btn)
	local form = btn.ParentForm
	local index = nx_number(btn.DataSource)	
	local form_set = util_get_form('auto_new\\form_auto_ai_set',true,false)	
	form_set.index = index
	util_show_form('auto_new\\form_auto_ai_set',true)		
end
ai_show_setting_auto = function(btn)
	local form = btn.ParentForm
	local index = nx_number(btn.DataSource)
	local list_get_ai = AUTO_AI_ARRAY[index]	
	if nx_int(list_get_ai.EDIT) == nx_int(1) then
		util_auto_show_hide_form(list_get_ai.SCRIPT)
	else
		showUtf8Text(auto_not_setting)
	end
end
function load_auto_grid(form)
	if not nx_is_valid(form) then
		return
	end
	local gui = nx_value("gui")
	local grid = form.textgrid_pos	
	grid:SetColTitle(0, utf8ToWstr("Tên Auto"))
	grid:SetColTitle(1, utf8ToWstr("Bắt Đầu"))
	grid:SetColTitle(2, utf8ToWstr("Kết Thúc"))
	grid:SetColTitle(3, utf8ToWstr("Lên"))
	grid:SetColTitle(4, utf8ToWstr("Xuống"))
	grid:SetColTitle(5, utf8ToWstr("Xóa"))
	grid:SetColTitle(6, utf8ToWstr("Chạy Riêng"))
	grid:SetColTitle(7, utf8ToWstr("Mở"))
	grid:ClearRow()
	grid:ClearSelect()
	local ini = nx_create("IniDocument")
	if not nx_is_valid(ini) then
        return
    end	
	local running = 'Đã Tắt'
	local auto_run 
	local inifile = add_file_user('auto_ai')		
	ini.FileName = inifile	
	if ini:LoadFromFile() then	
		 if ini:FindSection('Setting') then		
			local string_list = wstrToUtf8(readIni(inifile,nx_string('Setting'),'list',''))	
			record_list = string_list
			local list_auto = auto_split_string(string_list,';')
			record_list_array = list_auto
			if nx_number(table.getn(list_auto)) > 0 then
				for i = 1, table.getn(list_auto) do
					local auto_list = auto_split_string(list_auto[i],',')
					local index = auto_list[1]
					local time_start = auto_list[2]
					local time_end = auto_list[3]
					local run = auto_list[5]
					if not run or run == nil then run = '1' end
					if nx_string(run) == '1' then
						auto_run = 'Bật'
					else
						auto_run = 'Tắt'
					end
					local list_get_ai = AUTO_AI_ARRAY[nx_number(index)]	
					local btn_del = create_multitextbox(path_form, 'on_click_btn_del',auto_del,list_auto[i], 'HLStypebargaining')
					local btn_up = create_multitextbox(path_form, 'on_click_up',auto_up,nx_string(i), 'HLChatItem1')	
					local btn_down = create_multitextbox(path_form, 'on_click_down',auto_down,nx_string(i), 'HLChatItem1')
					local multitextbox = create_multitextbox(path_form, 'ai_show_setting_auto', list_get_ai.NAME,index, 'HLChatItem1')		
					local multitextbox1 = create_multitextbox(path_form, 'load_setting_auto_ai', time_start,i, 'HLStypebargaining')		
					local multitextbox2 = create_multitextbox(path_form, 'load_setting_auto_ai', time_end,i, 'HLStypebargaining')
					if nx_running('auto_new\\form_auto_ai_new',nx_string(list_get_ai.RUN..'_only')) then
						running = 'Đang Chạy'
					end	
					local multitextbox3 = create_multitextbox(path_form, 'on_click_run_auto', running,index, 'HLStypelaba')
					local multitextbox4 = create_multitextbox(path_form, 'on_click_open_auto', auto_run,i, 'HLStypegudian')
					gridAndFunc(grid,multitextbox,multitextbox1,multitextbox2,btn_up,btn_down,btn_del,multitextbox3,multitextbox4)
				end
			end		
		end		
	end
end
AUTO_AI_ARRAY ={
	[1] = {
		INDEX = AI_SD,
		EXE =  'exe_auto_sd',
		NAME = AUTO_TN,
		RUN = 'exe_auto_sd_state',
		EDIT = 1,
		SCRIPT = 'auto_new\\form_auto_tn',
		AI_UPDATE = 'ai_update_sd_info',
		ONLY_TURN_ON = 'turn_on_auto_sd_only',
		ONLY_TURN_OFF = 'turn_off_auto_sd_only',
	},
	[2] = {
		INDEX = AI_AB,
		EXE = 'exe_auto_ab',
		NAME = AUTO_AB,
		EDIT = 1,
		RUN = 'exe_auto_ab_state',
		SCRIPT = 'auto_new\\form_auto_ab',
		AI_UPDATE = 'ai_update_ab_info',
		ONLY_TURN_ON = 'turn_on_auto_ab',
		ONLY_TURN_OFF = 'turn_off_auto_ab',
	},
	[3] = {
		INDEX = AI_ES,
		EXE = 'exe_auto_es',
		NAME = AUTO_ESCORT,
		RUN = 'exe_auto_es_state',
		EDIT = 1,
		SCRIPT = 'auto_new\\form_auto_vt',	
		AI_UPDATE = 'ai_update_es_info',	
		ONLY_TURN_ON = 'turn_on_auto_es_only',
		ONLY_TURN_OFF = 'turn_off_auto_es_only',
	},
	[4] = {
		INDEX = AI_BF,
		EXE = 'exe_auto_bf',
		NAME = AUTO_CT,
		RUN = 'exe_auto_bf_state',
		EDIT = 1,
		SCRIPT = 'auto_new\\form_auto_ct',	
		AI_UPDATE = 'ai_update_bf_info',
		ONLY_TURN_ON = 'turn_on_auto_bf_only',
		ONLY_TURN_OFF = 'turn_off_auto_bf_only',	
	},
	[5] = {
		INDEX = AI_FA,
		EXE = 'exe_auto_fa',
		NAME = AUTO_LC,
		RUN = 'exe_auto_fa_state',
		EDIT = 1,
		SCRIPT = 'auto_new\\form_auto_lc',
		AI_UPDATE = 'ai_update_fa_info',
		ONLY_TURN_ON = 'turn_on_auto_fa_only',
		ONLY_TURN_OFF = 'turn_off_auto_fa_only',	
	},
	[6] = {
		INDEX = AI_SP,
		EXE = 'exe_auto_sp',
		NAME = AUTO_SPY,
		RUN = 'exe_auto_sp_state',
		EDIT = 0,
		SCRIPT = 'auto_new\\form_auto_spy',
		AI_UPDATE = 'ai_update_sp_info',
		ONLY_TURN_ON = 'turn_on_auto_sp_only',
		ONLY_TURN_OFF = 'turn_off_auto_sp_only',	
	},
	[7] = {
		INDEX = AI_SW,		
		EXE = 'exe_auto_sw',
		NAME = AUTO_NT,
		RUN = 'exe_auto_sw_state',	
		EDIT = 1,
		SCRIPT = 'auto_new\\form_auto_sw',
		AI_UPDATE = 'ai_update_sw_info',
		ONLY_TURN_ON = 'turn_on_auto_sw_only',
		ONLY_TURN_OFF = 'turn_off_auto_sw_only',	
	},
	[8] = {
		INDEX = AI_GA,
		EXE = 'exe_auto_ga',
		NAME = AUTO_CROP,
		RUN = 'exe_auto_ga_state',
		EDIT = 1,
		SCRIPT = 'auto_new\\form_auto_tt',
		AI_UPDATE = 'ai_update_ga_info',
		ONLY_TURN_ON = 'turn_on_auto_ga_only',
		ONLY_TURN_OFF = 'turn_off_auto_ga_only',	
	},
	[9] = {
		INDEX = AI_PL,
		EXE = 'exe_auto_pl',
		NAME = AUTO_TC,
		RUN = 'exe_auto_pl_state',
		EDIT = 1,
		SCRIPT = 'auto_new\\form_auto_farm',
		AI_UPDATE = 'ai_update_pl_info',
		ONLY_TURN_ON = 'turn_on_auto_pl_only',
		ONLY_TURN_OFF = 'turn_off_auto_pl_only',	
	},
	[10] = {
		INDEX = AI_HU,
		EXE = 'exe_auto_hu',
		NAME = AUTO_TS,
		RUN = 'exe_auto_hu_state',
		EDIT = 1,
		SCRIPT = 'auto_new\\form_auto_hunter',
		AI_UPDATE = 'ai_update_hu_info',
		ONLY_TURN_ON = 'turn_on_auto_hu_only',
		ONLY_TURN_OFF = 'turn_off_auto_hu_only',	
	},
	[11] = {
		INDEX = AI_TI,
		EXE = 'exe_auto_ti',
		NAME = AUTO_TG,
		RUN = 'exe_auto_ti_state',
		EDIT = 1,
		SCRIPT = 'auto_new\\form_auto_ti',
		AI_UPDATE = 'ai_update_ti_info',
		ONLY_TURN_ON = 'turn_on_auto_ti_only',
		ONLY_TURN_OFF = 'turn_off_auto_ti_only',	
	},	
	[12] = {
		INDEX = AI_OT,
		EXE = 'exe_auto_ot',
		NAME = AUTO_OT,
		RUN = 'exe_auto_ot_state',
		EDIT = 1,
		SCRIPT = 'auto_new\\form_auto_ot',
		AI_UPDATE = 'ai_update_ot_info',
		ONLY_TURN_ON = 'turn_on_auto_ot_only',
		ONLY_TURN_OFF = 'turn_off_auto_ot_only',		
	},
	[13] = {
		INDEX = AI_TI_TD,
		EXE = 'exe_auto_ti_today',
		NAME = AUTO_TG_ONE,
		RUN = 'exe_auto_ti_today_state',	
		EDIT = 1,
		SCRIPT = 'auto_new\\form_auto_tq',
		AI_UPDATE = 'ai_update_ti_td_info',	
		ONLY_TURN_ON = 'turn_on_auto_ti_today_only',
		ONLY_TURN_OFF = 'turn_off_auto_ti_today_only',	
	},
	[14] = {
		INDEX = AI_JI,
		EXE = 'exe_auto_ji',
		NAME = AUTO_HK,
		RUN = 'exe_auto_ji_state',	
		EDIT = 1,
		SCRIPT = 'auto_new\\form_auto_hk',
		AI_UPDATE = 'ai_update_ji_info',
		ONLY_TURN_ON = 'turn_on_auto_ji_only',
		ONLY_TURN_OFF = 'turn_off_auto_ji_only',	
	},
	[15] = {
		INDEX = AI_MR,
		EXE = 'exe_auto_mr',
		NAME = AUTO_TT,
		RUN = 'exe_auto_mr_state',
		EDIT = 1,
		SCRIPT = 'auto_new\\form_auto_match',
		AI_UPDATE = 'ai_update_mr_info',	
		ONLY_TURN_ON = 'turn_on_auto_mr_only',
		ONLY_TURN_OFF = 'turn_off_auto_mr_only',	
	},	
	[16] = {
		INDEX = AI_QUEST_NEW,
		EXE = 'exe_auto_quest_newschool',
		NAME = AUTO_QN,
		RUN = 'exe_auto_qn_state',
		EDIT = 1,	
		SCRIPT = 'auto_new\\form_auto_qn',
		AI_UPDATE = 'ai_update_qn_info',
		ONLY_TURN_ON = 'turn_on_auto_qn_only',
		ONLY_TURN_OFF = 'turn_off_auto_qn_only',	
	},
}
on_click_run_auto = function(btn)
	local index = btn.DataSource
	if nx_string(AUTO_AI_ARRAY[nx_number(index)].RUN) == nx_string('exe_auto_ab_state') then
		if nx_running('auto_new\\form_auto_ai_new',nx_string(AUTO_AI_ARRAY[nx_number(index)].RUN)) then
			nx_kill('auto_new\\form_auto_ai_new',nx_string(AUTO_AI_ARRAY[nx_number(index)].RUN))
			nx_execute('auto_new\\form_auto_ai_new',nx_string(AUTO_AI_ARRAY[nx_number(index)].ONLY_TURN_OFF))		
			if nx_running('auto_new\\form_auto_ai_new',nx_string(AUTO_AI_ARRAY[nx_number(index)].RUN)) then
				nx_execute('auto_new\\form_auto_ai_new',nx_string(AUTO_AI_ARRAY[nx_number(index)].ONLY_TURN_OFF))
				nx_kill('auto_new\\form_auto_ai_new',nx_string(AUTO_AI_ARRAY[nx_number(index)].RUN))
			end
		else		
			nx_execute('auto_new\\form_auto_ai_new',nx_string(AUTO_AI_ARRAY[nx_number(index)].EXE))		
		end
	else
		if nx_running('auto_new\\form_auto_ai_new',nx_string(AUTO_AI_ARRAY[nx_number(index)].RUN..'_only')) then
			nx_kill('auto_new\\form_auto_ai_new',nx_string(AUTO_AI_ARRAY[nx_number(index)].RUN..'_only'))
			nx_execute('auto_new\\form_auto_ai_new',nx_string(AUTO_AI_ARRAY[nx_number(index)].ONLY_TURN_OFF))		
			if nx_running('auto_new\\form_auto_ai_new',nx_string(AUTO_AI_ARRAY[nx_number(index)].RUN..'_only')) then
				nx_execute('auto_new\\form_auto_ai_new',nx_string(AUTO_AI_ARRAY[nx_number(index)].ONLY_TURN_OFF))
				nx_kill('auto_new\\form_auto_ai_new',nx_string(AUTO_AI_ARRAY[nx_number(index)].RUN..'_only'))
			end
		else
			nx_execute('auto_new\\form_auto_ai_new',nx_string(AUTO_AI_ARRAY[nx_number(index)].EXE..'_only'))
		end
	end		
	if nx_running('auto_new\\form_auto_ai_new',nx_string(AUTO_AI_ARRAY[nx_number(index)].RUN..'_only')) or nx_running('auto_new\\form_auto_ai_new',nx_string(AUTO_AI_ARRAY[nx_number(index)].RUN))  then
		btn.HtmlText = utf8ToWstr('<a style="'..nx_string('HLStypelaba')..'"> ' .. 'Đang Chạy' .. '</a>')
	else
		btn.HtmlText = utf8ToWstr('<a style="'..nx_string('HLStypelaba')..'"> ' .. 'Đã Tắt' .. '</a>')
	end
end

function gridAndFuncA(mTextName3)
	local grid = form.textgrid_pos	
	local form = nx_value(path_form)
	local row = grid:InsertRow(-1)			
	grid:SetGridControl(row, 6, mTextName3)		
end
function on_click_btn_del(btn)
	local form = btn.ParentForm	
	local cur_scene_id = nx_value(FORM_MAP_SCENE).current_map		
	local ini = nx_create("IniDocument")
	if not nx_is_valid(ini) then
        return
    end
	local ini_file = add_file_user('auto_ai')
	ini.FileName = ini_file	
	local str = wstrToUtf8((readIni(ini_file,nx_string('Setting'), 'list', '')))
	local list =  auto_split_string(str,';')	
	if nx_int(table.getn(record_list_array)) == nx_int(1) then		
		if ini:LoadFromFile() then	
			if ini:FindSection('Setting') then
				ini:DeleteSection('Setting')
				ini:SaveToFile()
				load_auto_grid(form)
				return
			end
		end
	end		
	local data = btn.DataSource		
	local data_item = ''
	for i =1, table.getn(list) do	
		if list[i] == data then			
			table.remove(list, i)
		end
	end
	for j = 1, table.getn(list) do		
		data_item = data_item..';'..list[j]
	end
	writeIniString(ini_file,nx_string('Setting'), "list", data_item)	
	load_auto_grid(form)
end
function on_click_up(btn)
	local form = btn.ParentForm
	local index = nx_number(btn.DataSource)
	local ini_file = add_file_user('auto_ai')	
	if index == 1 then return end	
	local record_arr = auto_split_string(nx_string(record_list),';')
	local tmp = record_arr[index]		
	record_arr[index] = record_arr[index - 1]
	record_arr[index - 1] = tmp	
	local tmp_str = ""
	for i = 1, table.getn(record_arr) do
		tmp_str = tmp_str .. ";" .. record_arr[i]
	end
	record_list = tmp_str
	writeIniString(ini_file,nx_string('Setting'), "list",record_list)
	load_auto_grid(form)	
end
function on_click_down(btn)
	local form = btn.ParentForm
	local ini_file = add_file_user('auto_ai')		
	local index = nx_number(btn.DataSource)
	local record_arr = auto_split_string(nx_string(record_list),';')
	if index == table.getn(record_arr) then return end
	local tmp = record_arr[index]
	record_arr[index] = record_arr[index + 1]
	record_arr[index + 1] = tmp
	local tmp_str = ""
	for i = 1, table.getn(record_arr) do
		tmp_str = tmp_str ..  ";" .. record_arr[i]
	end
	record_list = tmp_str
	writeIniString(ini_file,nx_string('Setting'), "list",record_list)
	load_auto_grid(form)	
end
auto_running_ai = function(func_script,funcName)	
	if not funcName or not func_script then return end
	return nx_running(func_script,funcName)
end

function gridAndFunc(grid,mTextName,mTextName1,mTextName2,btn_up,btn_down,btn_del,mTextName3,mTextName4)
	local form = nx_value(path_form)
	local row = grid:InsertRow(-1)
	grid:SetGridControl(row, 0, mTextName)		
	grid:SetGridControl(row, 1, mTextName1)		
	grid:SetGridControl(row, 2, mTextName2)		
	grid:SetGridControl(row, 3, btn_up)		
	grid:SetGridControl(row, 4, btn_down)		
	grid:SetGridControl(row, 5, btn_del)		
	grid:SetGridControl(row, 6, mTextName3)			
	grid:SetGridControl(row, 7, mTextName4)			
end
create_multitextbox = function(script_name, call_back_func_name, text, data_source, style)
	local multitextbox = nx_value('gui'):Create('MultiTextBox')
	multitextbox.DrawMode = 'Expand'
	multitextbox.LineColor = '0,0,0,0'
	multitextbox.Solid = false
	multitextbox.AutoSize = false
	multitextbox.Font = 'font_text_title1'
	multitextbox.LineTextAlign = 'Top'	
	multitextbox.SelectBarColor = '0,0,0,0'
	multitextbox.MouseInBarColor = '0,0,0,0'
	multitextbox.BackColor = '0,255,255,255'
	multitextbox.ViewRect = '12,12,180,150'
	multitextbox.Width = 180	
	multitextbox.HtmlText = utf8ToWstr('<a style="'..nx_string(style)..'"> ' .. nx_string(text) .. '</a>') -- 
	multitextbox.Height = multitextbox:GetContentHeight() + 5
	multitextbox.Left = 10
	multitextbox.Top = 0		
	multitextbox.DataSource = nx_string(data_source)
	nx_bind_script(multitextbox, nx_string(script_name))
	nx_callback(multitextbox, 'on_click_hyperlink', nx_string(call_back_func_name))
	return multitextbox
end

function check_dir_and_file(file)	
	if not nx_function('ext_is_file_exist', file) then
		return true
	end
	return false
end
check_function_auto_qt = function()
	for i = 1, table.getn(AUTO_AI_ARRAY) do
		if nx_running('auto_new\\form_auto_ai_new',nx_string(AUTO_AI_ARRAY[i].RUN..'_only'))  then
			showUtf8Text('Auto '..AUTO_AI_ARRAY[i].NAME..auto_running_pri_stop)
			nx_execute('auto_new\\form_auto_ai_new',nx_string(AUTO_AI_ARRAY[i].ONLY_TURN_OFF))
			nx_kill('auto_new\\form_auto_ai_new',nx_string(AUTO_AI_ARRAY[i].RUN..'_only'))		
		end		
	end
end
check_all_condition = function()
	if nx_execute('auto_new\\autocack','is_password_locked') then
		nx_execute('auto_new\\autocack','unlock_pass_auto_2')	
		nx_pause(0.5)
	end	
	if nx_execute('auto_new\\autocack','is_password_locked') then
		showUtf8Text(AUTO_LOG_UNLOCK_PASS_2)
		return true
	end	
	if not nx_running(nx_current(), 'auto_start_ai2') then
		if nx_execute('auto_new\\autocack','get_bag_free_slot',2) <= 2 or nx_execute('auto_new\\autocack','get_bag_free_slot',125) <= 2 then
			showUtf8Text(AUTO_LOG_ERROR_SLOT_BAG,2)	
		end
	end	
	for i = 1, table.getn(AUTO_AI_ARRAY) do
		if nx_running('auto_new\\form_auto_ai_new',nx_string(AUTO_AI_ARRAY[i].RUN..'_only'))  then
			showUtf8Text('Auto '..AUTO_AI_ARRAY[i].NAME..auto_running_pri_stop)
			nx_execute('auto_new\\form_auto_ai_new',nx_string(AUTO_AI_ARRAY[i].ONLY_TURN_OFF))
			nx_kill('auto_new\\form_auto_ai_new',nx_string(AUTO_AI_ARRAY[i].RUN..'_only'))					
		end		
	end
	return false
end
function btn_start_auto_ai(btn)
	local form = btn.ParentForm
	if check_all_condition() then
		return
	end	
	if nx_running('auto_new\\autocack','exe_auto_ab_state') or nx_running('auto_new\\form_auto_ab','exe_auto_ab_state') then
		showUtf8Text(AUTO_LOG_STOP_AI_AB)
		return 
	end
	if nx_running('auto_new\\auto_script','auto_start_use_item_neixiu')  then
		showUtf8Text(auto_stop_auto_nixui)
		return 
	end
	nx_execute(nx_current(),'ai_start2')
end
btn_start_add_ai = function(btn)
	util_auto_show_form('auto_new\\form_auto_ai_set')
end
btn_start_setting_ai = function(btn)
	util_auto_show_form('auto_new\\form_auto_setting_ai')
end
function update_btn_ai()
	local form = nx_value('auto_new\\form_auto_ai')
	if nx_running(nx_current(), 'auto_start_ai2') then
		form.btn_start_auto_ai.Text = nx_widestr('Stop')
	else
		form.btn_start_auto_ai.Text = nx_widestr('Start')
	end
	load_auto_grid(self)
end
updatePlay = function(task_value)
	local self = nx_value('auto_new\\form_auto_ai')
	if not nx_is_valid(self) then
		return
	end
	if not task_value then
		self.btn_start_auto_ai.Text = nx_widestr('Stop')
	else
		self.lbl_running_auto.Text = utf8ToWstr(task_value)
	end
	load_auto_grid(self)
end
updateStop = function(task_value)
	local self = nx_value('auto_new\\form_auto_ai')
	if not nx_is_valid(self) then
		return
	end
	if not task_value then
		self.btn_start_auto_ai.Text = nx_widestr('Start')
	else	
		self.lbl_running_auto.Text = utf8ToWstr(NO_EXE)
	end
	load_auto_grid(self)
end
updateBtn = function()
	if not nx_running(nx_current(), 'auto_start_ai2') then
		updateStop()
	else
		updatePlay()
	end
end
function on_main_form_close(form) 
	 nx_destroy(form)	
end
function on_btn_close_click(form)   
  local form = nx_value(path_form)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
utf8ToWstr_load = function(str)
	if not str then return nx_wstr("")
	else 
		return utf8ToWstr(str)
	end
end



function load_jianghu_ini_info(active)
	local record_info_list = {}
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then return end	
	local file = add_file('auto_jh')
	local ini_file = add_file_user('auto_ai')
	if nx_number(readIni(ini_file,AUTO_HK,'data_change','')) == 1 then
		file = add_file_res('auto_jh')	
	end
	ini.FileName = file
	if not ini:LoadFromFile()then nx_destroy(ini) return end
	local cur_scene_id = nx_value(FORM_MAP_SCENE).current_map
	if ini:FindSection(active) then
		record_info_list[active] = {}
		record_info_list[active].info = nx_string(ini:ReadString(nx_string(active), nx_string('pos'), ''))
	end
	nx_destroy(ini)
	return record_info_list
end
get_nearest_target_npc_battle = function()
	local scene = auto_game_client:GetScene()
	local scene_obj_table = scene:GetSceneObjList()
	local r = 1000
	local obj = nil
	local game_client = nx_value('game_client')
	local client_player = game_client:GetPlayer()
	for i = 1, table.getn(scene_obj_table) do
		local scene_obj = scene_obj_table[i]
		if nx_is_valid(scene_obj) then
			local can_attack = nx_value('fight'):CanAttackNpc(client_player, scene_obj)
			if can_attack and not scene_obj:FindProp('Dead') and (string.find(nx_string(scene_obj:QueryProp('ConfigID')),'battle_gmphong') ~= nil or string.find(nx_string(scene_obj:QueryProp('ConfigID')),'battle_gmplan') ~= nil) then
				local tmp_r = getDistance(scene_obj)
				if tmp_r and tmp_r <= 35 and tmp_r < r then
					local vis_target = auto_game_visual:GetSceneObj(nx_string(scene_obj.Ident))					
					r = tmp_r
					obj = scene_obj
				end
			end
		end
	end
	if obj ~= nil then
		local id = obj.Ident
		autoSelectObj(id)		
		nx_pause(1)
		return obj
	end
	return nil
end
check_enter_count_tg = function(form,name_id)
	if not nx_is_valid(form) then return end
	local guan_node = form.tree_guan.RootNode:FindNode(util_text(name_id))
	if nx_is_valid(guan_node) then
		if nx_number(guan_node.entercount) < nx_number(guan_node.limitcount) then
			return true
		end
	end
	return false
end
check_enter_count_today_tg = function(form,name_id)
	if not nx_is_valid(form) then return end
	local guan_node = form.tree_guan.RootNode:FindNode(util_text(name_id))
	if nx_is_valid(guan_node) then
		if nx_number(guan_node.todaysucceed) < nx_number(guan_node.limitsucceed) then
			return true
		end
	end	
	return false
end