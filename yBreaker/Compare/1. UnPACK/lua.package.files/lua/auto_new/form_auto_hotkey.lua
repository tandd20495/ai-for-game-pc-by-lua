require('util_gui')
require("util_move")
require('define\\gamehand_type')
require('const_define')
require('auto_new\\autocack')
require('form_stage_main\\form_taosha\\taosha_util')
local THIS_FORM = 'auto_new\\form_auto_hotkey'

function main_form_init(form)
	form.Fixed = false
	form.inifile = ""	
end
function on_main_form_open(form)
	updateState()		
	loadGridHotKey(form)
end 
function on_btn_close_click(form)   
  local form = nx_value("auto_new\\form_auto_hotkey")
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
	local form = nx_value('auto_new\\form_auto_hotkey')
	if nx_execute('form_stage_main\\form_taosha\\taosha_util','getStateHotKey') then
		form.btn_start_key_func.Text = nx_widestr('On')
	else
		form.btn_start_key_func.Text = nx_widestr('Off')
	end
end
function loadGridHotKey(form)
	local gui = nx_value("gui")
	local grid = form.textgrid_pos	
	local funcname = ""	
	local item1 = ""
	local item2 = ""
	local faculty = ""
	local shift = ""
	local ctrl = ""
	local keyhtml = ""
	local inifile = add_file_user('setkey')
	local countini = nx_execute('auto_new\\autocack','sectionCount',inifile)
	grid:ClearRow()
	grid:ClearSelect()
	if countini > 0 then
		for j = 1, countini do
			funcname = getSectionName(inifile,j)			
			for i = 1, table.getn(funcname) do
				if nx_int(readIni(inifile,funcname[i],'type','')) == nx_int(1) then
					local btn_del = create_button(funcname[i],i,"Del",'on_click_btn_del')
					local mTextName = create_multitext()
					shift = readIni(inifile,funcname[i],'shift','')
					ctrl = readIni(inifile,funcname[i],'ctrl','')
					local auto_name = readIni(inifile,funcname[i],'func_name','')
					if nx_string(shift) == nx_string('true') then
						shift = 'Yes'
					else
						shift = 'No'
					end
					if nx_string(ctrl) == nx_string('true') then
						ctrl = 'Yes'
					else
						ctrl = 'No'
					end
					keyhtml = 'Phím: <a href="" style=\"HLStype1\"> ['..nx_string(funcname[i])..']</a> Shift: <a href="" style=\"HLStypelargeteam\">'..shift..'</a> Ctrl: <a href="" style=\"HLStypelargeteam\"  > '..ctrl..'</a><br> Auto: <a href="" style=\"HLStypebuzz\"  > '..wstrToUtf8(auto_name)..'</a>'
					mTextName.HtmlText =  utf8ToWstr(keyhtml)
					gridAndFunc(grid,mTextName,btn_del)	
				end 
				if nx_int(readIni(inifile,funcname[i],'type','')) == nx_int(2) then
					local btn_del = create_button(funcname[i],i,"Del",'on_click_btn_del')
					local mTextName = create_multitext()						
					faculty = readIni(inifile,funcname[i],'faculty','')
					item1 = readIni(inifile,funcname[i],'item1','')
					item2 = readIni(inifile,funcname[i],'item2','')
					shift = readIni(inifile,funcname[i],'shift','')
					ctrl = readIni(inifile,funcname[i],'ctrl','')
					if nx_string(shift) == nx_string('true') then
						shift = 'Yes'
					else
						shift = 'No'
					end
					if nx_string(ctrl) == nx_string('true') then
						ctrl = 'Yes'
					else
						ctrl = 'No'
					end
					local item1data = util_split_string(nx_string(item1),',')
					local item2data = util_split_string(nx_string(item2),',')	
						
					if nx_string(faculty) ~= nx_string('false') then
						keyhtml = 'Phím: <a href="" style=\"HLStype1\"> ['..nx_string(funcname[i])..']</a> Shift: <a href="" style=\"HLStypelargeteam\">'..shift..'</a> Ctrl: <a href="" style=\"HLStypelargeteam\"  > '..ctrl..'</a><br> Nội Công: <a href="" style=\"HLStypebuzz\"  > '..wstrToUtf8(util_text(nx_string(faculty)))..'</a>'	
					end	
					if nx_string(faculty) == nx_string('false') and nx_string(item1data[1]) ~= '' then
						keyhtml = 'Phím: <a href="" style=\"HLStype1\"> ['..nx_string(funcname[i])..']</a> Shift: <a href="" style=\"HLStypelargeteam\">'..shift..'</a> Ctrl: <a href="" style=\"HLStypelargeteam\"  > '..ctrl..'</a><br> Item: <a href="" style=\"HLChatItem1\"  > '..wstrToUtf8(util_text(item1data[1]))..' , '..wstrToUtf8(util_text(item2data[1]))..'</a>'				
					end
					mTextName.HtmlText =  utf8ToWstr(keyhtml)
					gridAndFunc(grid,mTextName,btn_del)
				end				
			end
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