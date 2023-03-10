require("util_gui")
require("util_move")
require("util_functions")
require("util_static_data")
require("define\\sysinfo_define")
require("share\\chat_define")
require("const_define")
require("player_state\\state_const")
require("player_state\\logic_const")
require("player_state\\state_input")
require("tips_data")
require('auto_new\\autocack')

local THIS_FORM = 'auto_new\\form_auto_set_key_func'
local FORM_TARGET = 'auto_new\\form_auto_hotkey'
local item = {}
local uid = {}
local faculty = {}
function main_form_init(form)
  form.Fixed = false
  form.skillid = ""
  form.inifile = ""
  form.select_index = 0
  form.faculty = ""
end

func_open_exe =
{			
	{AUTO_LOG_CHAT_CMD73,'auto_use_neixiu','noitu'},	
	{AUTO_LOG_CHAT_CMD76,'autoCreateZhiHua','tran','auto_new\\auto_script'},
	{AUTO_LOG_CHAT_CMD77,'exe_auto_qis_farm','kysi','auto_new\\auto_script'},
	{AUTO_LOG_CHAT_CMD82,'Auto_Skill','skillfree','auto_new\\auto_script'},
	{AUTO_LOG_CHAT_CMD83,'suicide_auto','tusat','auto_new\\auto_script'},	
	{AUTO_LOG_CHAT_CMD84,'autoFixItem','fix','auto_new\\auto_script'},	
	{AUTO_LOG_CHAT_CMD85,'auto_show_bokhoai','bokhoai','auto_new\\auto_script'},	
	{AUTO_LOG_CHAT_CMD86,'auto_show_haibo','haibo','auto_new\\auto_script'},
	{AUTO_LOG_CHAT_CMD87,'auto_tele_dhc','dhc','auto_new\\auto_script'},
	{AUTO_LOG_CHAT_CMD88,'auto_tele_thanhhai','th','auto_new\\auto_script'},
	{AUTO_LOG_CHAT_CMD80,'auto_catch_rab_key','bth','auto_new\\auto_script'},
	{AUTO_LOG_CHAT_CMD81,'auto_catch_rab','btho','auto_new\\auto_script'},
	{AUTO_LOG_CHAT_CMD35,'auto_xaphu','xaphu','auto_new\\auto_script'},
	{AUTO_LOG_CHAT_CMD36,'autoShowHideHpRatioBar','hp','auto_new\\auto_script'},
	{AUTO_LOG_CHAT_CMD37,'set_auto_movie','movie','auto_new\\auto_script'},
	{AUTO_LOG_CHAT_CMD38,'auto_shop_ghlt','shop','auto_new\\auto_script'},
	{AUTO_LOG_CHAT_CMD39,'autoAddHC','themhc','auto_new\\auto_script'},
	{AUTO_LOG_CHAT_CMD40,'autoRemoveHC','xoahc','auto_new\\auto_script'},
	{AUTO_LOG_CHAT_CMD41,'autoAddFriend','themhh','auto_new\\auto_script'},
	{AUTO_LOG_CHAT_CMD42,'autoUpdateFriend','themch','auto_new\\auto_script'},
	{AUTO_LOG_CHAT_CMD43,'searchBook','timsach','auto_new\\auto_script'},
	{AUTO_LOG_CHAT_CMD44,'autoRunSpa','spa','auto_new\\auto_script'},
	{AUTO_LOG_CHAT_CMD24,'auto_swap_add','swap','auto_new\\auto_script'},
	{AUTO_LOG_CHAT_CMD45,'blinkMapAuto','fly','auto_new\\auto_script'},
	{AUTO_LOG_CHAT_CMD18,'auto_skill','skill','auto_new\\form_auto_skill'},
	{AUTO_LOG_CHAT_CMD47,'FindTree_start','timcay','auto_new\\auto_script'},	
	{AUTO_LOG_CHAT_CMD48,'abduct_start','timcoc','auto_new\\auto_script'},	
	{AUTO_LOG_CHAT_CMD49,'Musician_start','timdan','auto_new\\auto_script'},	
	{AUTO_LOG_CHAT_CMD50,'FindOmCoc_start','omcoc','auto_new\\auto_script'},	
	{AUTO_LOG_CHAT_CMD51,'BoxKHD_start','khd','auto_new\\auto_script'},
	{AUTO_LOG_CHAT_CMD52,'auto_findbox','timruong','auto_new\\auto_script'},
	{AUTO_LOG_CHAT_CMD53,'autoFindtreeLocation','cayngay','auto_new\\auto_script'},
	{AUTO_LOG_CHAT_CMD54,'Boss_start','timboss','auto_new\\auto_script'},
	{AUTO_LOG_CHAT_CMD55,'auto_oakhau','oakhau','auto_new\\auto_script'},
	{AUTO_LOG_CHAT_CMD56,'delete_key_auto','xoakey','auto_new\\auto_script'},
	{'Auto Speed','start_stop_auto_speed','speed','auto_new\\auto_script'},
	{'Auto Ping Pro','start_stop_auto_ping_pro','ping','auto_new\\auto_script'},
	{'Auto Ping Classic','start_stop_auto_ping_classic','ping','auto_new\\auto_script'},
		--{'Auto SwapNC','start_stop_auto_swap_nc','swap','auto_new\\auto_script'},
	{'Auto Target','autoRunDefTarget','tg','auto_new\\auto_script'},
	{'Auto Def','start_stop_auto_def','def','auto_new\\auto_script'},
	{'Auto Swap','start_stop_auto_swap','def','auto_new\\auto_script'},	
	{'Auto THBB','start_stop_auto_thbb','thbb','auto_new\\auto_script'},	
	{AUTO_LOG_CHAT_CMD89,'break_parry_auto','nhadef','auto_new\\form_auto_active_special'},
	{AUTO_LOG_CHAT_CMD90,'auto_bug_quat','bugquat','auto_new\\form_auto_active_special'},
	{AUTO_LOG_CHAT_CMD91,'auto_bug_full_hpmp','buff','auto_new\\auto_script'},
	{'Auto Exit','start_stop_auto_exit','buff','auto_new\\auto_script'},
	{'Auto End Exit','start_stop_auto_exit_end','buff','auto_new\\auto_script'},
	{'Auto Change PK','start_stop_auto_change_mode','buff','auto_new\\auto_script'},
	{'Auto Jump Port','start_stop_auto_port_jump','buff','auto_new\\auto_script'},
	{'Auto TelePort','start_stop_auto_port_tele','buff','auto_new\\auto_script'},
	{'Auto Invite Bug(not VN)','start_stop_auto_invite','buff','auto_new\\auto_script'},
}
function on_main_form_open(form)		
	loadItemAutoDrop(form)
end

function loadItemAutoDrop(form)
	local gui = nx_value("gui")	
	form.cbx_load_auto.DropListBox:ClearString()
	for i = 1, table.getn(func_open_exe) do
		form.cbx_load_auto.DropListBox:AddString(utf8ToWstr(func_open_exe[i][1]))
	end	
end

function on_main_form_close(form)
  form.Visible = false
end
function btn_save_setting(btn)
	local form = btn.ParentForm
	local form_main = nx_value('auto_new\\form_auto_hotkey')
	saveHotKeyIni()
	nx_execute('auto_new\\autocack','util__auto_show_form','auto_new\\form_auto_set_key_func')	
	if nx_is_valid(form_main) then
		nx_execute('auto_new\\autocack','nx_autoexecute','auto_new\\form_auto_hotkey','loadGridHotKey',form_main)
	end
end

function saveHotKeyIni()
	local form = nx_value('auto_new\\form_auto_set_key_func')
	local ini = add_file_user('setkey')
	local key = ''
	if string.find(nx_string(form.edit_key.Text),'Num') ~= nil then
		key = nx_string(form.edit_key.Text)
	else
		key = nx_ws_upper(form.edit_key.Text)
	end	
	local select_index = form.cbx_load_auto.DropListBox.SelectIndex + 1	
	writeIni(ini,nx_string(key),'type',1)
	writeIni(ini,nx_string(key),'func_name',utf8ToWstr(func_open_exe[select_index][1]))
	writeIni(ini,nx_string(key),'func_hand',func_open_exe[select_index][2])
	if func_open_exe[select_index][3] ~= nil then
		writeIni(ini,nx_string(key),'param_1',func_open_exe[select_index][3])
	end
	if func_open_exe[select_index][4] ~= nil then
		writeIni(ini,nx_string(key),'param_2',func_open_exe[select_index][4])
	end
	if form.cbtn_on_shift.Checked  then
		writeIni(ini,nx_string(key),'shift','true')
	else
		writeIni(ini,nx_string(key),'shift','false')
	end
	if form.cbtn_on_ctrl.Checked  then
		writeIni(ini,nx_string(key),'ctrl','true')
	else
		writeIni(ini,nx_string(key),'ctrl','false')
	end
end
function on_cbtn_ctrl_changed(cbtn)
	local form = cbtn.ParentForm
	if form.cbtn_on_shift.Checked then
		form.cbtn_on_shift.Checked = false
	end
end
function on_cbtn_shift_changed(cbtn)
	local form = cbtn.ParentForm
	if form.cbtn_on_ctrl.Checked then
		form.cbtn_on_ctrl.Checked = false
	end
end

function on_btn_close_click(form)
local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
