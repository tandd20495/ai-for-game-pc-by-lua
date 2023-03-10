require("util_gui")
require("define\\gamehand_type")
require("const_define")
require('auto_new\\autocack')

function main_form_init(form)

    form.Fixed = false	
end
function on_main_form_open(form)	
  init_ui_content(form)
end
function show_hide_form()
  util_auto_show_hide_form("auto_new\\form_auto_all")
end
function init_ui_content(form)
	load_running_auto_all()
end

function on_btn_close_click(form)
local form = nx_value("auto_new\\form_auto_all")
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
function on_main_form_close(form)	
	nx_destroy(form)
end
function btn_start_1(btn)
	local form = btn.ParentForm	
	nx_execute('auto_new\\autocack','util__auto_show_form',"auto_new\\form_auto_ai_new")
end
function btn_start_2(btn)
	local form = btn.ParentForm
	nx_execute('auto_new\\autocack','util__auto_show_form',"auto_new\\form_auto_khd")
end
function btn_start_3(btn)
	local form = btn.ParentForm
	nx_execute('auto_new\\autocack','util__auto_show_form',"auto_new\\form_auto_homepoint")
	
end
function btn_start_4(btn)
	nx_execute('auto_new\\autocack','util__auto_show_form',"auto_new\\form_auto_use_item")
		
end
function btn_start_5(btn)
	local form = btn.ParentForm
	nx_execute('auto_new\\autocack','util__auto_show_form',"auto_new\\form_auto_encrypt")
	
end
function btn_start_6(btn)
	local form = btn.ParentForm
	nx_execute('auto_new\\autocack','util__auto_show_form',"auto_new\\form_auto_ab")	
end
function btn_start_7(btn)
	local form = btn.ParentForm
	nx_execute('auto_new\\autocack','util__auto_show_form',"auto_new\\form_auto_dmqt")

end
function btn_start_8(btn)
	local form = btn.ParentForm	
	nx_execute('auto_new\\autocack','util__auto_show_form','auto_new\\form_auto_chat')
end
function btn_start_9(btn)
	local form = btn.ParentForm
	nx_execute('auto_new\\autocack','util__auto_show_form','auto_new\\form_auto_skill')
	
end
function btn_start_10(btn)
	local form = btn.ParentForm
	nx_execute('auto_new\\autocack','util__auto_show_form','auto_new\\form_auto_ltt')
end
function btn_start_11(btn)
	local form = btn.ParentForm
	nx_execute('auto_new\\autocack','util__auto_show_form','auto_new\\form_auto_train')
end

function btn_start_12(btn)
	local form = btn.ParentForm
	nx_execute('auto_new\\autocack','util__auto_show_form','auto_new\\form_auto_tdc')
end
function btn_start_13(btn)
	nx_execute('auto_new\\autocack','util__auto_show_form','auto_new\\form_auto_stall')
end
function btn_start_14(btn)
	nx_execute('auto_new\\autocack','util__auto_show_form',"auto_new\\form_auto_qt")	

end
function btn_start_15(btn)
	nx_execute('auto_new\\autocack','util__auto_show_form',"auto_new\\form_auto_nc6")	
end
func_open_exe =
{
	{'Auto Nuôi Tằm','exe_auto_sw_statey','AI','auto_new\\form_auto_ai'},
	{'Auto Trồng cây','exe_auto_pl_state','AI','auto_new\\form_auto_ai'},
	{'Auto Thợ Săn','exe_auto_hu_state','AI','auto_new\\form_auto_ai_new'},
	{'Auto Tung Hoành','exe_auto_ti_statey','AI','auto_new\\form_auto_ai'},	
	{'Auto Ẩn Thế','exe_auto_qn_state','AI','auto_new\\form_auto_ai'},	
	{'Thích Quán','exe_auto_ti_today_state','AI','auto_new\\form_auto_ai'},
	{'Auto Thu Thập','exe_auto_ga_state','AI','auto_new\\form_auto_ai'},
	{'Auto Hào Kiệt','exe_auto_ji_state','AI','auto_new\\form_auto_ai'},
	{'Auto Do Thám','exe_auto_sp_state','AI','auto_new\\form_auto_ai'},
	{'Auto Chiến Trường','exe_auto_bf_state','AI','auto_new\\form_auto_ai'},	
	{'Auto Vận Tiêu','exe_auto_es_state','AI','auto_new\\form_auto_ai'},	
	{'Auto Thiên Thê','exe_auto_mr_state','AI','auto_new\\form_auto_ai'},
	{'Auto Ôn Tuyền','exe_auto_ot_state','AI','auto_new\\form_auto_ai'},
	{'Auto Thụ Nghiệp','exe_auto_sd_state','AI','auto_new\\form_auto_ai'},	
	{'Auto Luyện Công','exe_auto_fa_state','AI','auto_new\\form_auto_ai'},	
	{AUTO_LOG_CHAT_CMD18,'auto_skill','AI','auto_new\\form_auto_ai'},
	{'Auto Cóc','exe_auto_ab_state','AI','auto_new\\form_auto_ai'},
	
	{'Auto Nuôi Tằm','exe_auto_sw_statey','AI','auto_new\\form_auto_ai_new'},
	{'Auto Trồng cây','exe_auto_pl_state','AI','auto_new\\form_auto_ai_new'},
	{'Auto Thợ Săn','exe_auto_hu_state','AI','auto_new\\form_auto_ai_new'},
	{'Auto Tung Hoành','exe_auto_ti_statey','AI','auto_new\\form_auto_ai_new'},	
	{'Auto Ẩn Thế','exe_auto_qn_state','AI','auto_new\\form_auto_ai_new'},	
	{'Thích Quán','exe_auto_ti_today_state','AI','auto_new\\form_auto_ai_new'},
	{'Auto Thu Thập','exe_auto_ga_state','AI','auto_new\\form_auto_ai_new'},
	{'Auto Hào Kiệt','exe_auto_ji_state','AI','auto_new\\form_auto_ai_new'},
	{'Auto Do Thám','exe_auto_sp_state','AI','auto_new\\form_auto_ai_new'},
	{'Auto Chiến Trường','exe_auto_bf_state','AI','auto_new\\form_auto_ai_new'},	
	{'Auto Vận Tiêu','exe_auto_es_state','AI','auto_new\\form_auto_ai_new'},	
	{'Auto Thiên Thê','exe_auto_mr_state','AI','auto_new\\form_auto_ai_new'},
	{'Auto Ôn Tuyền','exe_auto_ot_state','AI','auto_new\\form_auto_ai_new'},
	{'Auto Thụ Nghiệp','exe_auto_sd_state','AI','auto_new\\form_auto_ai_new'},	
	{'Auto Luyện Công','exe_auto_fa_state','AI','auto_new\\form_auto_ai_new'},	
	{AUTO_LOG_CHAT_CMD18,'auto_skill','AI','auto_new\\form_auto_ai_new'},
	
	{'Auto Giảm Cấu Hình','set_win_size_auto','Only','auto_new\\form_auto_ab'},
	{'Auto Cóc','exe_auto_ab_state','Only','auto_new\\form_auto_ab'},	
	{'Auto Pause Kỳ Ngộ ','drive_escort_trans_tool','only','auto_new\\autocack'},
	{'Auto Kỳ Ngộ ','exe_auto_run_qt','only','custom_handler'},
	{'Auto Thông Báo PK ','attack_waiting_notice','only','auto_new\\auto_script'},
	{'Auto Lăng Tiêu Thành ','autoLangTieu','only','auto_new\\form_auto_ltt'},
	{'Auto Xài Vật Phẩm ','auto_start_use_item','only','auto_new\\form_auto_use_item'},
	{'Auto Item /u ','auto_start_use_item_in_chat','only','auto_new\\form_auto_use_item'},
	{'Auto Treo Shop Pro ','auto_stall','only','auto_new\\form_auto_stall'},
	{'Auto Khoái Hoạt Đảo ','auto_clone_khd','only','auto_new\\form_auto_khd'},
	{'Auto Tình Dao Cung ','auto_tdc_don','only','auto_new\\form_auto_tdc'},
	{'Auto Đại Mạt ','auto_daimat','only','auto_new\\form_auto_dmqt'},
	{'Auto Dao Đài - Nc6','DaoDai','only','auto_new\\form_auto_nc6'},
	{'Auto Vụ Phong - Nc6','VuPhong','only','auto_new\\form_auto_nc6'},
	{'Auto Nhanh Tay - Nc6','NhanhTay','only','auto_new\\form_auto_nc6'},
	{'Auto Hoang Gia - Nc6','HoangGia','only','auto_new\\form_auto_nc6'},
	{'Auto Nội Công 6','act_Idle_func','only','auto_new\\form_auto_nc6'},
	{'Auto Train','auto_start_train','only','auto_new\\form_auto_train'},
	{'Auto Nuôi Tằm','exe_auto_sw_state_only','only','auto_new\\form_auto_ai_new'},
	{'Auto Trồng cây','exe_auto_pl_state_only','only','auto_new\\form_auto_ai_new'},
	{'Auto Thợ Săn','exe_auto_hu_state_only','only','auto_new\\form_auto_ai_new'},
	{'Auto Tung Hoành','exe_auto_ti_state_only','only','auto_new\\form_auto_ai_new'},	
	{'Auto Ẩn Thế','exe_auto_qn_state_only','only','auto_new\\form_auto_ai_new'},	
	{'Thích Quán','exe_auto_ti_today_state_only','only','auto_new\\form_auto_ai_new'},
	{'Auto Thu Thập','exe_auto_ga_state_only','only','auto_new\\form_auto_ai_new'},
	{'Auto Hào Kiệt','exe_auto_ji_state_only','only','auto_new\\form_auto_ai_new'},
	{'Auto Do Thám','exe_auto_sp_state_only','only','auto_new\\form_auto_ai_new'},
	{'Auto Chiến Trường','exe_auto_bf_state_only','only','auto_new\\form_auto_ai_new'},	
	{'Auto Vận Tiêu','exe_auto_es_state_only','only','auto_new\\form_auto_ai_new'},	
	{'Auto Thiên Thê','exe_auto_mr_state_only','only','auto_new\\form_auto_ai_new'},
	{'Auto Ôn Tuyền','exe_auto_ot_state_only','only','auto_new\\form_auto_ai_new'},
	{'Auto Thụ Nghiệp','exe_auto_sd_state_only','only','auto_new\\form_auto_ai_new'},	
	{'Auto Luyện Công','exe_auto_fa_state_only','only','auto_new\\form_auto_ai_new'},	
	{'Tạo Trận Kim Lan','autoCreateZhiHua','only','auto_new\\auto_script'},
	{'Kỳ Sỹ','exe_auto_qis_farm','only','auto_new\\auto_script'},
	{'Theo Thanh Skill','autoSkill_free','only','auto_new\\autocack'},
	{'Tự Sát Nhanh','suicide_auto','only','auto_new\\autocack'},	
	{'Sữa Đồ','autoFixItem','only','auto_new\\auto_script'},	
	{'Farm Tửu','auto_drink','only','auto_new\\auto_script'},
	{'Bổ khoái','auto_show_bokhoai','only','auto_new\\auto_script'},	
	{'Hải Bố','auto_show_haibo','only','auto_new\\auto_script'},
	{'Tele Di Hoa','auto_tele_dhc','only','auto_new\\auto_script'},
	{'Tele Thanh Hải','auto_tele_thanhhai','only','auto_new\\auto_script'},
	{'AUTO Bắt Thỏ - Key','auto_catch_rab_key','only','auto_new\\auto_script'},
	{'AUTO Bắt Thỏ','auto_catch_rab','only','auto_new\\auto_script'},
	{'Xa Phu Nhanh','auto_xaphu','only','auto_new\\auto_script'},
	{'Tìm Sách Đoạt Thư','searchBook','only','auto_new\\auto_script'},
	{'Auto Ôn Tuyền','autoRunSpa','only','auto_new\\auto_script'},
	{'Auto Swap','swapauto','only','auto_new\\auto_script'},
	{'Auto Blink','blinkMapAuto','only','auto_new\\auto_script'},
	{AUTO_LOG_CHAT_CMD18,'auto_skill','only','auto_new\\form_auto_skill'},
	{'Auto Tìm Cây','startFindTree','only','auto_new\\auto_script'},	
	{AUTO_LOG_CHAT_CMD48,'startAbduct','only','auto_new\\auto_script'},	
	{AUTO_LOG_CHAT_CMD49,'startFindMusician','only','auto_new\\auto_script'},	
	{AUTO_LOG_CHAT_CMD50,'startFindOmCoc','only','auto_new\\auto_script'},	
	{AUTO_LOG_CHAT_CMD51,'startFindBoxKHD','only','auto_new\\auto_script'},
	{AUTO_LOG_CHAT_CMD52,'auto_findbox','only','auto_new\\auto_script'},
	{AUTO_LOG_CHAT_CMD53,'autoFindtreeLocation','only','auto_new\\auto_script'},
	{AUTO_LOG_CHAT_CMD54,'startFindBoss','only','auto_new\\auto_script'},
	{AUTO_LOG_CHAT_CMD55,'auto_oakhau','only','auto_new\\auto_script'},
	{AUTO_LOG_CHAT_CMD56,'delete_key_auto','only','auto_new\\auto_script'},	
	
}
load_running_auto_all = function()	
	local game_client = nx_value('game_client')
	if not nx_is_valid(game_client) then return end
	local client_player = game_client:GetPlayer()
	if not nx_is_valid(client_player) then return end
	local form = nx_value('auto_new\\form_auto_all')
	local gui = nx_value('gui')
	local mltbox = form.mltbox_content
	local title =  nx_function("ext_utf8_to_widestr", "<font color=\"#fc03e3\">Auto Đang Chạy</font>")
	mltbox:AddHtmlText(title, -1)
	while nx_is_valid(form) and form.Visible do
		local scene = game_client:GetScene()
		if nx_string(nx_value('loading')) == nx_string('false') and nx_string(nx_value('stage_main')) == nx_string('success') and nx_is_valid(scene) then
			mltbox:Clear()	
			for i = 1, table.getn(func_open_exe) do
				if auto_running_all(func_open_exe[i][4],func_open_exe[i][2]) then
					local info_exe = ''
					if nx_string(func_open_exe[i][3]) == nx_string('only') then
						info_exe = nx_widestr("- ") .. nx_function("ext_utf8_to_widestr", "<font color=\"#ff0000\">"..func_open_exe[i][1].." </font>") .. nx_function("ext_utf8_to_widestr", "<font color=\"#258ef7\"> - Đơn</font>")
					elseif 	nx_string(func_open_exe[i][3]) == nx_string('only') and get_start_ai_status() then
						info_exe = nx_widestr("- ") .. nx_function("ext_utf8_to_widestr", "<font color=\"#ff0000\">"..func_open_exe[i][1].." </font>") .. nx_function("ext_utf8_to_widestr", "<font color=\"#a833d6\"> - AI</font>")
					else
						info_exe = nx_widestr("- ") .. nx_function("ext_utf8_to_widestr", "<font color=\"#ff0000\">"..func_open_exe[i][1].." </font>") .. nx_function("ext_utf8_to_widestr", "<font color=\"#a833d6\"> - AI</font>")
					end
					
					form.mltbox_content:AddHtmlText(info_exe, -1)
				end
			end		
		end
		nx_pause(1)
	end
end
auto_running_all = function(func_script,funcName)
	if not funcName or not func_script then return end
	return nx_running(func_script,funcName)
end
----------------------
function btn_start_21(btn)
	local form = btn.ParentForm	
	nx_execute('auto_new\\autocack','nx_autoexecute',"auto_new\\auto_script","exe_auto_qis_farm")
end
function btn_start_22(btn)
	local form = btn.ParentForm
	nx_execute('auto_new\\autocack','nx_autoexecute',"auto_new\\auto_script","auto_drink")
end
function btn_start_23(btn)
	local form = btn.ParentForm
	nx_execute('auto_new\\autocack','nx_autoexecute',"auto_new\\auto_script","auto_catch_rab_key")
	
end
function btn_start_24(btn)
	nx_execute('auto_new\\autocack','nx_autoexecute',"auto_new\\auto_script","auto_xaphu")
		
end
function btn_start_25(btn)
	local form = btn.ParentForm
	nx_execute('auto_new\\autocack','nx_autoexecute',"auto_new\\auto_script","searchBook")
	
end
function btn_start_26(btn)
	local form = btn.ParentForm
	nx_execute('auto_new\\autocack','nx_autoexecute',"auto_new\\auto_script","FindTree_start")	
end
function btn_start_27(btn)
	local form = btn.ParentForm
	nx_execute('auto_new\\autocack','nx_autoexecute',"auto_new\\auto_script","blinkMapAuto")

end
function btn_start_28(btn)
	local form = btn.ParentForm	
	nx_execute('auto_new\\autocack','nx_autoexecute','auto_new\\auto_script',"auto_swap_add")
end
function btn_start_29(btn)
	local form = btn.ParentForm
	nx_execute('auto_new\\autocack','nx_autoexecute','auto_new\\auto_script',"autoFixItem")
	
end
function btn_start_30(btn)
	local form = btn.ParentForm
	nx_execute('auto_new\\autocack','nx_autoexecute','auto_new\\auto_script',"suicide_auto")
end
function btn_start_31(btn)
	local form = btn.ParentForm
	nx_execute('auto_new\\autocack','nx_autoexecute','auto_new\\auto_script',"Auto_Skill")
end

function btn_start_32(btn)
	local form = btn.ParentForm
	nx_execute('auto_new\\autocack','nx_autoexecute','auto_new\\auto_script',"auto_show_bokhoai")
end
function btn_start_33(btn)
	nx_execute('auto_new\\autocack','nx_autoexecute','auto_new\\auto_script',"auto_show_haibo")
end
function btn_start_34(btn)
	nx_execute('auto_new\\autocack','nx_autoexecute','auto_new\\auto_script',"auto_tele_dhc")

end
function btn_start_35(btn)
	nx_execute('auto_new\\autocack','nx_autoexecute','auto_new\\auto_script',"auto_tele_thanhhai")
end








