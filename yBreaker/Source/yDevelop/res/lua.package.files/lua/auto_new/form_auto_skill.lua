require('util_gui')
require("util_move")
require('define\\gamehand_type')
require('const_define')
require('auto_new\\autocack')

local THIS_FORM = 'auto_new\\form_auto_skill'

function main_form_init(form)
	form.Fixed = false
	form.skillid = ""	
end
function on_main_form_open(form)
	local inifile = add_file_user('auto_skill')	
	if nx_number(readIni(inifile,"SettingSkill","follow","")) == 1 then
		form.cbtn_follow_target.Checked = true
	end
	if nx_number(readIni(inifile,"SettingSkill","nontarget","")) == 1 then
		form.cbtn_fight_non_target.Checked = true
	end
	updateBtnAutoSkill()
	loadGridAutoSkill(form)	
end 
function on_btn_close_click(form)   
  local form = nx_value("auto_new\\form_auto_skill")
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
function on_main_form_close(form)	
	nx_destroy(form)
end

function btn_add_start(btn)
	local form = btn.ParentForm
	local inifile = add_file_user('auto_skill')
	local skilltaolu = wstrToUtf8(readIni(inifile,'SettingSkill','Active',''))
	if skilltaolu == '' then
		showUtf8Text(CHECK_ZERO_SKILL,3)
		util_show_form('auto_new\\form_auto_skill',true)
		return
	end
	local follow = readIni(inifile,'SettingSkill','follow','')
	local nontarget = readIni(inifile,'SettingSkill','nontarget','')
	local check_range = false
	local check_follow = true
	if nx_int(follow) == nx_int(1) then
		check_follow = false
	end
	if nx_int(nontarget) == nx_int(1) then
		check_range = true
	end
	if nx_running(nx_current(), 'auto_skill') then
		nx_kill(nx_current(),'auto_skill')
		set_skill_start_stop(false)
	else	
		set_skill_start_stop(true)
		nx_execute(nx_current(),'auto_skill',check_follow,check_range)
	end
	updateBtnAutoSkill()
end
function updateBtnAutoSkill()
	local form = nx_value("auto_new\\form_auto_skill")
	if nx_running(nx_current(), 'auto_skill') then
		form.btn_add_start.Text = nx_widestr('Stop')
	else
		form.btn_add_start.Text = nx_widestr('Start')		
	end
end
function cbtn_fight_non_target(cbtn)
	local form = cbtn.ParentForm
	local inifile = add_file_user('auto_skill')
	local check = 0
	if cbtn.Checked == true then
		check = 1
	end
	show_notice('Nếu chọn auto sẽ sử dụng auto ở phương thức spam')
	writeIni(inifile,"SettingSkill",'nontarget',check)
end
function cbtn_follow_target(cbtn)
	local form = cbtn.ParentForm
	local inifile = add_file_user('auto_skill')
	local check = 0
	if cbtn.Checked == true then
		check = 1
	end
	writeIni(inifile,"SettingSkill",'follow',check)
end
function on_click_btn_del(btn)
	local form = btn.ParentForm
	local inifile = add_file_user('auto_skill')
	local skilltaolu = wstrToUtf8(readIni(inifile,'SettingSkill','Active',''))
	if skilltaolu == btn.func_ai then
		showUtf8Text(AUTO_LOG_ACTIVE_NOT_DEL)
		return
	end
	removeSection(inifile,btn.func_ai)
	loadGridAutoSkill(form)
end

function on_click_btn_setting(btn)
	local form = btn.ParentForm
	local inifile = add_file_user('auto_skill')
	local form_set = nx_execute("util_gui", "util_get_form", 'auto_new\\form_auto_set_skill', true)
	form_set.taolu = btn.func_ai
	util_show_form('auto_new\\form_auto_set_skill',true)
end
function on_click_btn_active(btn)
	local form = btn.ParentForm
	local inifile = add_file_user('auto_skill')
	writeIni(inifile,"SettingSkill",'Active',utf8ToWstr(btn.func_ai))	
	loadGridAutoSkill(form)
end
function loadGridAutoSkill(form)
	local gui = nx_value("gui")
	local grid = form.textgrid_pos	
	local funcname = ""
	local inifile = add_file_user('auto_skill')
	local btn_active
	local countini = nx_execute('auto_new\\autocack','sectionCount',inifile)
	local checkActive = wstrToUtf8(readIni(inifile,"SettingSkill","active",""))
	grid:ClearRow()
	grid:ClearSelect()
	if countini > 0 then
		for j = 1, countini do
			funcname = getSectionName(inifile,j)
			for i = 1, table.getn(funcname) do				
				if 	funcname[i] ~= 'SettingSkill' then	
					local btn_set = create_button(funcname[i],i,"Set",'on_click_btn_setting')
					local btn_del = create_button(funcname[i],i,"Del",'on_click_btn_del')
					local mTextName = create_multitext()	
					local keyhtml = AUTO_LOG_NAME_SET..' <br><a href="" style=\"HLStype2\"> ['..funcname[i]..'] </a>'					
					if checkActive == funcname[i] then						
						btn_active = create_button(funcname[i],i,"Active",'on_click_btn_active')
					else
						btn_active = create_button(funcname[i],i,"Disable",'on_click_btn_active')
					end
					mTextName.HtmlText =  utf8ToWstr(keyhtml)
					gridAndFunc(grid,mTextName,btn_active,btn_set,btn_del)
				end
			end
		end
	end		
end


function gridAndFunc(grid,mTextName,active,set,btn_del)
	local form = nx_value(THIS_FORM)
	local row = grid:InsertRow(-1)
	grid:SetGridControl(row, 0, mTextName)
	grid:SetGridControl(row, 1, active)
	grid:SetGridControl(row, 2, set)
	grid:SetGridControl(row, 3, btn_del)	
end

function btn_add_skill(btn)
	util_show_form('auto_new\\form_auto_set_skill',true)	
end
