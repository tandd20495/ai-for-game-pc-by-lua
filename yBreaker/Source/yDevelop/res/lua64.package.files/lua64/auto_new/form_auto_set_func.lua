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

local THIS_FORM = 'auto_new\\form_auto_set_func'
local FORM_TARGET = 'auto_new\\form_auto_chat_func'
function main_form_init(form)
  form.Fixed = false
  form.skillid = ""
  form.inifile = ""
  form.select_index = 0  
  form.func_exe = ""
  form.func_open = ""
  form.func_type = 0
  form.func_name = ""
end

function on_main_form_open(form)
	loadItemAutoDrop(form)
end
func_open_form =
{
	{'Support','form_auto_contact','lienhe'},
	{'Luyện Công','form_auto_lc','lc'},
	{'Auto Tìm Nhân Vật','form_auto_searchnv','snv'},
	{'Vận Tiêu','form_auto_vt','vt'},
	{'Thụ Nghiệp','form_auto_tn','tn'},
	{'Do Thám','form_auto_spy','spy'},
	{'Chiến Trường','form_auto_ct','ct'},
	{'Thiên Thê','form_auto_match','thienthe'},
	{'Ôn Tuyền','form_auto_ot','ot'},
	{'Thư Sinh','form_auto_job_ss','thusinh'},
	{'Họa Sư','form_auto_job_hs','hoasu'},
	{'AUTO ALL','form_auto_all','auto'},	
	{'AUTO Cấm Địa KHD','form_auto_khd','khdao'},
	{AUTO_LOG_CHAT_CMD58,'form_auto_ab','coc'},
	{'Auto Train','form_auto_train','tr'},
	{AUTO_LOG_CHAT_CMD1,'form_auto_task_round','anthe'},
	{AUTO_LOG_CHAT_CMD2,'form_auto_use_item','use'},
	{AUTO_LOG_CHAT_CMD3,'form_auto_homepoint','tele'},
	{AUTO_LOG_CHAT_CMD4,'form_auto_chat','chat'},
	{AUTO_LOG_CHAT_CMD5,'form_auto_item','item'},
	{AUTO_LOG_CHAT_CMD6,'form_auto_music','dan'},
	{AUTO_LOG_CHAT_CMD7,'form_auto_lookup','tool'},
	{AUTO_LOG_CHAT_CMD8,'form_auto_b','b'},
	{AUTO_LOG_CHAT_CMD9,'form_auto_info','info'},
	{AUTO_LOG_CHAT_CMD10,'form_auto_buymarket','mua'},
	{AUTO_LOG_CHAT_CMD11,'form_auto_spendmoney','xabac'},
	{AUTO_LOG_CHAT_CMD12,'form_auto_qvcd','vcd'},
	{AUTO_LOG_CHAT_CMD13,'form_auto_blink_set','bs'},
	{AUTO_LOG_CHAT_CMD14,'form_auto_tdc','tdc'},
	{AUTO_LOG_CHAT_CMD15,'form_auto_dmqt','dmqt'},
	{AUTO_LOG_CHAT_CMD16,'form_auto_stall','stall'},
	{AUTO_LOG_CHAT_CMD17,'form_auto_nc6','nc'},
	{AUTO_LOG_CHAT_CMD18,'form_auto_skill','skill'},
	{AUTO_LOG_CHAT_CMD19,'form_auto_join','vaophai'},
	{AUTO_LOG_CHAT_CMD20,'form_auto_hotkey','setkey'},	
	{AUTO_LOG_CHAT_CMD21,'form_auto_ltt','ltt'},	
	{AUTO_LOG_CHAT_CMD22,'form_auto_qt','kn'},	
	{AUTO_LOG_CHAT_CMD23,'form_auto_run_func','run'},	
	{AUTO_LOG_CHAT_CMD24,'form_auto_swap_old','s'},	
	{AUTO_LOG_CHAT_CMD25,'form_auto_farm','tt'},
	{AUTO_LOG_CHAT_CMD26,'form_auto_hk','hk'},
	{AUTO_LOG_CHAT_CMD27,'form_auto_hunter','ts'},
	{AUTO_LOG_CHAT_CMD28,'form_auto_sw','nuoitam'},
	{AUTO_LOG_CHAT_CMD29,'form_auto_tt','thuthap'},
	{AUTO_LOG_CHAT_CMD30,'form_auto_ti','thth'},
	{AUTO_LOG_CHAT_CMD31,'form_auto_tq','tq'},
	{AUTO_LOG_CHAT_CMD32,'form_auto_encrypt','mahoa'},
	{AUTO_LOG_CHAT_CMD33,'form_auto_nmq','nmq'},
	{AUTO_LOG_CHAT_CMD34,'form_auto_shopping','pvc'},
	
	
}
func_open_exe =
{	
	
	{'Bug Quạt','auto_bug_quat','bugquat'},
	{'Bug full hpmp','auto_bug_full_hpmp','bughp'},
	{'Auto Nhả Def','break_parry_auto','undef'},
	{'Auto Skill Nontarget','skill_not_follow','spam'},
	{'Auto Nội Tu','auto_use_neixiu','noitu'},
	{'AUTO Bắt Thỏ Rừng - Key','auto_catch_rab_tuzi_key','thorung'},
	{'Thông Báo Bị Đánh','attack_waiting_notice','tb'},
	{'Tạo Trận Kim Lan','autoCreateZhiHua','tran'},
	{'Kỳ Sỹ','exe_auto_qis_farm','kysi'},
	{'Auto Farm Rượu','auto_drink','dr'},
	{'AUTO Bắt Thỏ - Key','auto_catch_rab_key','bth'},
	{'AUTO Bắt Thỏ','auto_catch_rab','btho'},
	{AUTO_LOG_CHAT_CMD57,'auto_training_music','ldan'},
	{AUTO_LOG_CHAT_CMD35,'auto_xaphu','xaphu'},
	{AUTO_LOG_CHAT_CMD36,'autoShowHideHpRatioBar','hp'},
	{AUTO_LOG_CHAT_CMD37,'set_auto_movie','movie'},
	{AUTO_LOG_CHAT_CMD38,'auto_shop_ghlt','shop'},
	{AUTO_LOG_CHAT_CMD39,'autoAddHC','themhc'},
	{AUTO_LOG_CHAT_CMD40,'autoRemoveHC','xoahc'},
	{AUTO_LOG_CHAT_CMD41,'autoAddFriend','themhh'},
	{AUTO_LOG_CHAT_CMD42,'autoUpdateFriend','themch'},
	{AUTO_LOG_CHAT_CMD43,'searchBook','timsach'},
	{AUTO_LOG_CHAT_CMD44,'autoRunSpa','spa'},
	{AUTO_LOG_CHAT_CMD45,'blinkMapAuto','fly'},
	{AUTO_LOG_CHAT_CMD46,'set_fps','fps'},
	{AUTO_LOG_CHAT_CMD47,'FindTree_start','timcay'},	
	{AUTO_LOG_CHAT_CMD48,'abduct_start','timcoc'},	
	{AUTO_LOG_CHAT_CMD49,'Musician_start','timdan'},	
	{AUTO_LOG_CHAT_CMD50,'FindOmCoc_start','omcoc'},	
	{AUTO_LOG_CHAT_CMD51,'BoxKHD_start','khd'},
	{AUTO_LOG_CHAT_CMD52,'auto_findbox','timruong'},
	{AUTO_LOG_CHAT_CMD53,'autoFindtreeLocation','cayngay'},
	{AUTO_LOG_CHAT_CMD54,'Boss_start','timboss'},
	{AUTO_LOG_CHAT_CMD55,'auto_oakhau','oakhau'},
	{AUTO_LOG_CHAT_CMD56,'delete_key_auto','xoakey'},	
}
function loadItemAutoDrop(form)
	local gui = nx_value("gui")	
	form.cbx_open_form.DropListBox:ClearString()	
	form.cbx_open_exe.DropListBox:ClearString()	
	for i = 1, table.getn(func_open_form) do
		form.cbx_open_form.DropListBox:AddString(utf8ToWstr(func_open_form[i][1]))		
	end
	for i = 1, table.getn(func_open_exe) do
		form.cbx_open_exe.DropListBox:AddString(utf8ToWstr(func_open_exe[i][1]))
	end		

end
function on_main_form_close(form)
  form.Visible = false
end
function btn_save_setting(btn)
	local form = btn.ParentForm
	local form_main = nx_value(FORM_TARGET)
	saveHotKeyIni()
	nx_execute('auto_new\\autocack','util__auto_show_form',THIS_FORM)	
	if nx_is_valid(form_main) then
		nx_execute('auto_new\\autocack','nx_autoexecute',FORM_TARGET,'loadGridChat',form_main)
	end	
end


function saveHotKeyIni()
	local form = nx_value('auto_new\\form_auto_set_func')
	local ini = add_file_user('auto_func')
	local key = form.edit_key.Text
	if form.func_open ~= '' then		
		writeIni(ini,nx_string(key),'func_name',utf8ToWstr(form.func_name))
		writeIni(ini,nx_string(key),'func_hand',form.func_open)
	else
		writeIni(ini,nx_string(key),'func_hand',utf8ToWstr(form.func_name))
		writeIni(ini,nx_string(key),'func_name',form.func_exe)
	end	
	writeIni(ini,nx_string(key),'func_type',form.func_type)
end

function on_cbx_open_exe_selected(cbx)
	local form = cbx.ParentForm
	local select_index = form.cbx_open_exe.DropListBox.SelectIndex + 1	
	if form.cbx_open_exe.InputEdit.Text ~= ''  then
		form.cbx_open_form.InputEdit.Text = ''
		form.func_open = ""
		form.func_name = func_open_exe[select_index][1]
		form.func_exe = func_open_exe[select_index][2]
		form.func_type = 2	
	end	
end
function on_cbx_open_form_selected(cbx)
	local form = cbx.ParentForm
	local select_index = form.cbx_open_form.DropListBox.SelectIndex + 1
	if form.cbx_open_form.InputEdit.Text ~= '' or form.faculty ~= '' then
		form.cbx_open_exe.InputEdit.Text = ''
		form.func_open = ""
		form.func_name = func_open_form[select_index][1]
		form.func_exe = func_open_form[select_index][2]
		form.func_type = 1		
	end	
end
function on_btn_close_click(form)
local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
