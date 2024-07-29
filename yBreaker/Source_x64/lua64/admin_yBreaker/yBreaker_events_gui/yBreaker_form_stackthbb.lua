require("util_gui")
require("util_static_data")
require("util_functions")
require("share\\server_custom_define")
require("define\\sysinfo_define")
require("share\\chat_define")
require("define\\request_type")
require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")

local THIS_FORM = "admin_yBreaker\\yBreaker_form_stackthbb"
local isStartTHBB = false

function on_form_main_init(form)
    form.Fixed = false
    form.is_minimize = false
end

function on_main_form_open(form)
    change_form_size()
    form.is_minimize = false
	form.cbtn_lhq.Checked = true
	form.btn_control.Text = nx_function("ext_utf8_to_widestr", "Chạy")
	form.btn_control.ForeColor = "255,255,255,255"
	form.lbl_title.Text = ""
end

function on_main_form_close(form)
    isStartTHBB = false
    nx_destroy(form)
end

function change_form_size()
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return
    end
	
	local gui = nx_value("gui")
	form.Left = 1224
	form.Top = 881
	--form.Top = (gui.Height /2)
end

function on_btn_close_click(btn)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end

function on_btn_thbb_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
	
    if isStartTHBB then
		-- Stop status
		isStartTHBB = false
		
		--5. Chuyển về nội VV chính
		nx_execute("custom_sender", "custom_use_neigong", nx_string("ng_jh_201"))
		nx_pause(0.5)
		
		local fight = nx_value("fight")
		--Use skill Tọa Thiền Điều Tức,zs_default_01  để đứng dậy
		fight:TraceUseSkill("zs_default_01", false, false)
		
		btn.Text = nx_function("ext_utf8_to_widestr", "Chạy")
		btn.ForeColor = "255,255,255,255"

    else
		isStartTHBB = true
		btn.Text = nx_function("ext_utf8_to_widestr", "Dừng")
		btn.ForeColor = "255,220,20,60"
		stack_THBB()
    end
end

-- Show hide form stack thần hành bách biến
function show_hide_form_stackthbb()
	util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_stackthbb")
end

-- Show hide form gia viên
function show_hide_house_form()
	util_auto_show_hide_form("form_stage_main\\form_main\\form_main_shortcut")
end

-- Function để tích stack THBB
function stack_THBB()
	
	--1. Get buff trên người xem đang cưỡi ngựa hay không? Có thì xuống ngựa
	if yBreaker_get_buff_id_info("buf_riding_01") ~= nil then
		nx_execute("custom_sender", "custom_remove_buffer", "buf_riding_01")
		nx_pause(0.2)
	end				
	--2. Chuyển nội công 3 cái bang
	nx_execute("custom_sender", "custom_use_neigong", nx_string("ng_gb_003"))
	nx_pause(0.5)
	
	--3. Gọi PET (Hiện tại chưa gọi được npc_homepet_001=Chung Linh Điêu)
	
	while isStartTHBB == true do
		nx_pause(0)		
		local fight = nx_value("fight")
		--Use skill Thần Hành Bách Biến,CS_jh_lbwb02
		nx_pause(1)
		fight:TraceUseSkill("CS_jh_lbwb02", false, false)
		nx_pause(1)
		
		--Use skill Tọa Thiền Điều Tức,zs_default_01 ngồi xuống
		fight:TraceUseSkill("zs_default_01", false, false)
		nx_pause(6)		
		
		--Use skill Tọa Thiền Điều Tức,zs_default_01  để đứng dậy
		fight:TraceUseSkill("zs_default_01", false, false)
		nx_pause(1)
		
		local form1 = util_get_form("admin_yBreaker\\yBreaker_form_stackthbb", true, false)
		if form1.cbtn_lhq.Checked == true then
			--Use skill Như Lai Niêm Hoa,CS_sl_lhq05
			fight:TraceUseSkill("CS_sl_lhq05", false, false)
			nx_pause(1)
			
			--Use skill  Liên Hoàn Tam Khiêu, CS_sl_lhq01
			fight:TraceUseSkill("CS_sl_lhq01", false, false)
			nx_pause(1)
		else
			nx_pause(2)
		end
	end	
end