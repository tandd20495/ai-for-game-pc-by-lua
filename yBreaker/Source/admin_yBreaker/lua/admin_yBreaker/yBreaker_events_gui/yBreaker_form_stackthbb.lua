require("util_gui")
require("util_static_data")
require("util_functions")
require("share\\server_custom_define")
require("define\\sysinfo_define")
require("share\\chat_define")
require("define\\request_type")
require("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs")

local THIS_FORM = "admin_yBreaker\\yBreaker_form_stackthbb"

function on_form_main_init(form)
    form.Fixed = false
    form.is_minimize = false
end

function on_main_form_open(form)
    change_form_size()
    form.is_minimize = false
    local isStartTHBB = false

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
    form.Left = 100
    form.Top = (gui.Height / 2)
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
		btn.Text = nx_function("ext_utf8_to_widestr", "Start")
        isStartTHBB = false   

    else
		btn.Text = nx_function("ext_utf8_to_widestr", "Stop")
		
    end
end

-- Show hide form stack thần hành bách biến
function show_hide_form_stackthbb()
	util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_stackthbb")
end

-- Function để tích stack THBB
function stack_THBB()
	-- Get buff trên người xem đang cưỡi ngựa hay không? Có thì xuống ngựa
	-- Chuyển nội công 3 cái bang
	-- Gọi PET
	-- Check buff THBB nếu chưa full 10 thì vòng lặp
		-- Xài skill THBB tích stack
		-- Xài skill ngồi thiền 
		-- Delay tầm vài giây 
		-- Quay lại vòng lặp trên
	-- Nếu full 10 stack thì chuyển nội VV
	-- Ngồi thiền vài giây
	
	-- Check buff LHQ nếu chưa full 10 thì vòng lặp
		-- Check xem có buff niêm hoa k? Nếu k thì xài niêm hoa
			-- Xài skill Liên hoàn nếu đã có buff niêm hoa
		
	-- Check nếu 10stack THBB + 10stack buff LHQ thì dừng lại
	
-- Nếu buff THBB + LHQ còn 10s thì lặp lại các bước trên
	
end