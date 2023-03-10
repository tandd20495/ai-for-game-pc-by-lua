require('util_gui')
require("util_move")
require('define\\gamehand_type')
require('const_define')
require('auto_new\\autocack')
require('form_stage_main\\form_taosha\\taosha_util')
local THIS_FORM = 'auto_new\\form_auto_chat_func'
	
function main_form_init(form)
	form.Fixed = false
	form.inifile = ""	
end
function on_main_form_open(form)		
	loadGridChat(form)
	loadGridChat_2(form)
end 
function on_btn_close_click(form)   
  local form = nx_value("auto_new\\form_auto_chat_func")
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
	local inifile = add_file_user('auto_func')
	removeSection(inifile,btn.func_ai)
	loadGridChat(form)
	loadGridChat_2(form)
end
func_open_form =
{	
	
	{'Auto Ném Boom','form_auto_boom','bom','open'},
	{'Auto Chúc Phúc','form_auto_wish','cp','open'},
	{AUTO_LOG_CHAT_CMD59,'form_auto_contact','lienhe','open'},
	{'Auto AI','form_auto_ai','ai','open'},
	{AUTO_LOG_CHAT_CMD60,'form_auto_lc','lc','open'},
	{AUTO_LOG_CHAT_CMD61,'form_auto_vt','vt','open'},
	{AUTO_LOG_CHAT_CMD62,'form_auto_tn','tn','open'},
	{AUTO_LOG_CHAT_CMD63,'form_auto_spy','spy','open'},
	{AUTO_LOG_CHAT_CMD64,'form_auto_ct','ct','open'},
	{AUTO_LOG_CHAT_CMD65,'form_auto_match','thienthe','open'},
	{AUTO_LOG_CHAT_CMD66,'form_auto_ot','ot','open'},
	{AUTO_LOG_CHAT_CMD67,'form_auto_job_ss','thusinh','open'},
	{AUTO_LOG_CHAT_CMD68,'form_auto_job_hs','hoasu','open'},
	{AUTO_LOG_CHAT_CMD69,'form_auto_all','auto','open'},
	{AUTO_LOG_CHAT_CMD70,'form_auto_khd','khdao','open'},	
	{AUTO_LOG_CHAT_CMD58,'form_auto_ab','coc','open'},
	{AUTO_LOG_CHAT_CMD71,'form_auto_train','tr','open'},
	{AUTO_LOG_CHAT_CMD1,'form_auto_qn','anthe','open'},
	{AUTO_LOG_CHAT_CMD2,'form_auto_use_item','use','open'},
	{AUTO_LOG_CHAT_CMD3,'form_auto_homepoint','tele','open'},
	{AUTO_LOG_CHAT_CMD4,'form_auto_chat','chat','open'},
	{AUTO_LOG_CHAT_CMD5,'form_auto_item','item','open'},
	{AUTO_LOG_CHAT_CMD6,'form_auto_music','dan','open'},
	{AUTO_LOG_CHAT_CMD7,'form_auto_lookup','tool','open'},
	{AUTO_LOG_CHAT_CMD8,'form_auto_b','b','open'},
	{AUTO_LOG_CHAT_CMD9,'form_auto_info','info','open'},
	{AUTO_LOG_CHAT_CMD10,'form_auto_buymarket','mua','open'},
	{AUTO_LOG_CHAT_CMD11,'form_auto_spendmoney','xabac','open'},
	{AUTO_LOG_CHAT_CMD12,'form_auto_qvcd','vcd','open'},
	{AUTO_LOG_CHAT_CMD13,'form_auto_blink_set','bs','open'},
	{AUTO_LOG_CHAT_CMD14,'form_auto_tdc','tdc','open'},
	{AUTO_LOG_CHAT_CMD15,'form_auto_dmqt','dmqt','open'},
	{AUTO_LOG_CHAT_CMD16,'form_auto_stall','stall','open'},
	{AUTO_LOG_CHAT_CMD17,'form_auto_nc6','nc','open'},
	{AUTO_LOG_CHAT_CMD18,'form_auto_skill','skill','open'},
	{AUTO_LOG_CHAT_CMD19,'form_auto_join','vaophai','open'},
	{AUTO_LOG_CHAT_CMD20,'form_auto_hotkey','setkey','open'},	
	{AUTO_LOG_CHAT_CMD21,'form_auto_ltt','ltt','open'},	
	{AUTO_LOG_CHAT_CMD22,'form_auto_qt','kn','open'},	
	{AUTO_LOG_CHAT_CMD23,'form_auto_run_func','run','open'},	
	{AUTO_LOG_CHAT_CMD24,'form_auto_swap_old','s','open'},	
	{AUTO_LOG_CHAT_CMD25,'form_auto_farm','tt','open'},
	{AUTO_LOG_CHAT_CMD26,'form_auto_hk','hk','open'},
	{AUTO_LOG_CHAT_CMD27,'form_auto_hunter','ts','open'},
	{AUTO_LOG_CHAT_CMD28,'form_auto_sw','nuoitam','open'},
	{AUTO_LOG_CHAT_CMD29,'form_auto_tt','thuthap','open'},
	{AUTO_LOG_CHAT_CMD30,'form_auto_ti','thth','open'},
	{AUTO_LOG_CHAT_CMD31,'form_auto_tq','tq','open'},
	{AUTO_LOG_CHAT_CMD32,'form_auto_encrypt','mahoa','open'},
	{AUTO_LOG_CHAT_CMD33,'form_auto_nmq','nmq','open'},
	{AUTO_LOG_CHAT_CMD34,'form_auto_shopping','pvc','open'},
	{'Key Special','form_auto_active_special','spec','open'},		
	{'AutoPVP','form_auto_pvp','pvp','open'},
	{'Auto Tìm Nhân Vật','auto_searchnv','snv','open'},	
}
func_open_exe =
{	
	{'Auto Farm Tâm Ma','auto_start_stop_tmkn','tm','exe'},		
	{'Tìm Dân Trên Map','Find_stomsave_start','quetdan','exe'},		
	{'Hiển thị dân trên map','auto_findstorm','sdan','exe'},		
	{'Quét Theo Bang','auto_search_guild','timbang','exe'},		
	{'Hiện Blink','auto_show_check_blink','blink','exe'},	
	{'Auto Đào Bảo','start_auto_xiui','db','exe'},	
	{'Auto Diễn Võ','start_auto_act','dv','exe'},	
	{'Hạn Dùng','show_date_time_expire','hd','exe'},
	{'Bug Quạt','auto_bug_quat','bugquat','exe'},
	{'Bug full hpmp','auto_bug_full_hpmp','bughp','exe'},
	{'Auto Nhả Def','break_parry_auto','undef','exe'},
	{AUTO_LOG_CHAT_CMD72,'skill_not_follow','spam','exe'},
	{AUTO_LOG_CHAT_CMD73,'auto_use_neixiu','nt','exe'},
	{AUTO_LOG_CHAT_CMD74,'auto_catch_rab_tuzi_key','thorung','exe'},
	{AUTO_LOG_CHAT_CMD75,'attack_waiting_notice','tb','exe'},
	{AUTO_LOG_CHAT_CMD76,'autoCreateZhiHua','tran','exe'},
	{AUTO_LOG_CHAT_CMD77,'exe_auto_qis_farm','kysi','exe'},
	{AUTO_LOG_CHAT_CMD78,'auto_drink','dr','exe'},
	{AUTO_LOG_CHAT_CMD79,'use_item_for_chat','u','exe'},	
	{AUTO_LOG_CHAT_CMD80,'auto_catch_rab_key','bth','exe'},
	{AUTO_LOG_CHAT_CMD81,'auto_catch_rab','btho','exe'},
	{AUTO_LOG_CHAT_CMD57,'auto_training_music','ldan','exe'},
	{AUTO_LOG_CHAT_CMD35,'auto_xaphu','xaphu','exe'},
	{AUTO_LOG_CHAT_CMD36,'autoShowHideHpRatioBar','hp','exe'},
	{AUTO_LOG_CHAT_CMD37,'set_auto_movie','movie','exe'},
	{AUTO_LOG_CHAT_CMD38,'auto_shop_ghlt','shop','exe'},
	{AUTO_LOG_CHAT_CMD39,'autoAddHC','themhc','exe'},
	{AUTO_LOG_CHAT_CMD40,'autoRemoveHC','xoahc','exe'},
	{AUTO_LOG_CHAT_CMD41,'autoAddFriend','themhh','exe'},
	{AUTO_LOG_CHAT_CMD42,'autoUpdateFriend','themch','exe'},
	{AUTO_LOG_CHAT_CMD43,'searchBook','timsach','exe'},
	{AUTO_LOG_CHAT_CMD44,'autoRunSpa','spa','exe'},
	{AUTO_LOG_CHAT_CMD45,'blinkMapAuto','fly','exe'},
	{AUTO_LOG_CHAT_CMD46,'set_fps','fps','exe'},
	{AUTO_LOG_CHAT_CMD47,'FindTree_start','timcay','exe'},	
	{AUTO_LOG_CHAT_CMD48,'abduct_start','timcoc','exe'},	
	{AUTO_LOG_CHAT_CMD49,'Musician_start','timdan','exe'},	
	{AUTO_LOG_CHAT_CMD50,'FindOmCoc_start','omcoc','exe'},	
	{AUTO_LOG_CHAT_CMD51,'BoxKHD_start','khd','exe'},
	{AUTO_LOG_CHAT_CMD52,'auto_findbox','timruong'},
	{AUTO_LOG_CHAT_CMD53,'autoFindtreeLocation','cayngay','exe'},
	{AUTO_LOG_CHAT_CMD54,'Boss_start','timboss','exe'},
	{AUTO_LOG_CHAT_CMD55,'auto_oakhau','oakhau','exe'},
	{AUTO_LOG_CHAT_CMD56,'start_stop_auto_change_mode','pkm','exe'},
	{AUTO_LOG_CHAT_CMD56,'start_stop_auto_port_jump','jp','exe'},
	{AUTO_LOG_CHAT_CMD56,'start_stop_auto_port_tele','jt','exe'},
	{AUTO_LOG_CHAT_CMD56,'delete_key_auto','xoakey','exe'},
	
}
function btn_start_key_func(btn)
	local form = btn.ParentForm
	local ini_file = add_file_user('auto_func')
	for i =1,table.getn(func_open_form) do
		if func_open_form[i][3] ~= nil then
			writeIni(ini_file,func_open_form[i][3],'func_hand',utf8ToWstr(func_open_form[i][1]))
			writeIni(ini_file,func_open_form[i][3],'func_name',func_open_form[i][2])
			writeIni(ini_file,func_open_form[i][3],'func_type',1)
			writeIni(ini_file,func_open_form[i][3],'func_exe',1)
		end
	end
	for j =1,table.getn(func_open_exe) do
		if func_open_exe[j][3] ~= nil then
			writeIni(ini_file,func_open_exe[j][3],'func_hand',utf8ToWstr(func_open_exe[j][1]))
			writeIni(ini_file,func_open_exe[j][3],'func_name',func_open_exe[j][2])
			writeIni(ini_file,func_open_exe[j][3],'func_type',2)
			writeIni(ini_file,func_open_exe[j][3],'func_exe',2)
		end
	end	
	loadGridChat(form)
	loadGridChat_2(form)
end
function btn_remove_key(btn)
	local form = btn.ParentForm
	local ini_file = add_file_user('auto_func')
	os.remove(ini_file)
	loadGridChat(form)
	loadGridChat_2(form)
end
function loadGridChat(form)
	local gui = nx_value("gui")
	local grid = form.textgrid_pos	
	local funcname = ""	
	local func_name = ""
	local func_hand = ""
	local func_exe = ""
	local keyhtml = ""
	local inifile = add_file_user('auto_func')
	local countini = nx_execute('auto_new\\autocack','sectionCount',inifile)
	grid:ClearRow()
	grid:ClearSelect()
	if countini > 0 then
		for j = 1, countini do
			funcname = getSectionName(inifile,j)			
			for i = 1, table.getn(funcname) do							
				func_name = readIni(inifile,funcname[i],'func_hand','')			
				func_exe = readIni(inifile,funcname[i],'func_exe','')	
				if nx_string(func_exe) == nx_string('1') then	
					local btn_del = create_button(funcname[i],i,"Del",'on_click_btn_del')
					local mTextName = create_multitext()			
					if nx_string(faculty) ~= nx_string('false') then
						keyhtml = 'Key: <a href="" style=\"HLStype1\"> ['..'/'..nx_string(funcname[i])..']</a> <br> Auto: <a href="" style=\"HLStypebuzz\"  > '..wstrToUtf8(func_name)..'</a>'	
					end	
					mTextName.HtmlText =  utf8ToWstr(keyhtml)
					gridAndFunc(grid,mTextName,btn_del)	
				end					
			end
		end		
	end
end
function loadGridChat_2(form)
	local gui = nx_value("gui")
	local grid = form.textgrid_pos_2	
	local funcname = ""	
	local func_name = ""
	local func_hand = ""
	local func_exe = ""
	local keyhtml = ""
	local inifile = add_file_user('auto_func')
	local countini = nx_execute('auto_new\\autocack','sectionCount',inifile)
	grid:ClearRow()
	grid:ClearSelect()
	if countini > 0 then
		for j = 1, countini do
			funcname = getSectionName(inifile,j)			
			for i = 1, table.getn(funcname) do									
				func_name = readIni(inifile,funcname[i],'func_hand','')	
				func_exe = readIni(inifile,funcname[i],'func_exe','')	
				if nx_string(func_exe) == nx_string('2') then	
					local btn_del = create_button(funcname[i],i,"Del",'on_click_btn_del')
					local mTextName = create_multitext()	
					if nx_string(faculty) ~= nx_string('false') then
						keyhtml = 'Key: <a href="" style=\"HLStype1\"> ['..'/'..nx_string(funcname[i])..']</a> <br> Auto: <a href="" style=\"HLStypebuzz\"  > '..wstrToUtf8(func_name)..'</a>'	
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
	util_auto_show_hide_form('auto_new\\form_auto_set_func')	
end