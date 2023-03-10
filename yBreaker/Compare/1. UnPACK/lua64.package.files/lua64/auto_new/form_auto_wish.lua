--[[ **form_auto_wish.lua**
	@Author: Nockasdd (nockasdd@gmail.com)
	@Package: Auto AOW Pri
	@Version: 1.0
--]]
require('auto_new\\autocack')

--Define

local path_form = 'auto_new\\form_auto_wish'
--	Auto Wish --
local run_auto_wish = false
local total_current = 0
local total_count = 0
auto_zero_edit 	= 'Số lượng không thể bằng không'
auto_not_pass 		= 'Bạn chưa mở mật khẩu rương hãy mở rương để sử dụng'

get_state_auto_wish = function()
	return run_auto_wish
end
set_state_auto_wish = function(value)
	run_auto_wish = value		
end
set_total_use = function(value,path_form)
	local form = nx_value(path_form)
	if nx_is_valid(form) and form.Visible then
		form.lbl_auto_total.Text = nx_widestr(nx_string(value))
	end	
end
set_current_use = function(value,path_form)
	local form = nx_value(path_form)
	if nx_is_valid(form) and form.Visible then
		form.lbl_auto_current.Text = nx_widestr(nx_string(value))
	end	
end
get_total_buy = function(path_form)
	local form = nx_value(path_form)
	if nx_is_valid(form) and form.Visible then
		return nx_number(form.edit_number.Text)
	end
	return nx_number(0)
end
show_auto_not_pass = function()
	local textchat = 'Bạn chưa mở mật khẩu rương hãy mở rương để sử dụng'
	nx_value("form_main_chat"):AddChatInfoEx(utf8ToWstr(textchat), 17, false)
	nx_value("SystemCenterInfo"):ShowSystemCenterInfo(utf8ToWstr(textchat), 3)
end
auto_finish	= 'Đã hoàn thành auto '
auto_start_wish = function()
	if get_total_buy(path_form) == 0 then
		showUtf8Text('Số lượng không thể bằng không')
		return
	end
	if is_password_locked() then
		show_auto_not_pass()
		return
	end
	if total_count > 0 then	total_count = 0 end	
	local loading_time = 0
	total_current = 0	
	total_count = get_total_buy(path_form)
	while get_state_auto_wish() do
		nx_pause(0.1)
		local stage = nx_value('stage')
		local loading_flag = nx_value('loading')
		local sock = nx_value('game_sock')
		if loading_flag or not sock.Connected then
			loading_time = os.time()
		end            
		if tools_difftime(loading_time) > 6 and stage == 'main' then
			set_current_use(total_current,path_form)
			set_total_use(total_count,path_form)
			if nx_number(total_current) >= nx_number(total_count) then
				set_state_auto_wish(false)
				showUtf8Text('Đã hoàn thành auto ')
				update_btn_onOff()
				return
			end
			auto_use_wish()
		end
	end
end
function IsBusy()
    if nx_is_valid(nx_value("game_client")) then 
        if nx_is_valid(nx_value("game_client"):GetPlayer()) then
            if string.find(nx_value("game_client"):GetPlayer():QueryProp("State"), "offact") or string.find(nx_value("game_client"):GetPlayer():QueryProp("State"), "interact") or string.find(nx_value("game_client"):GetPlayer():QueryProp("State"), "life") or nx_value("form_stage_main\\form_main\\form_main_curseloading") then
                return true
            end
        end
    end
    return false
end
auto_use_wish = function()
	if nx_is_valid(nx_value(FORM_SHOP)) then 
		return
	end	
	local game_client = nx_value('game_client')
    if not nx_is_valid(game_client) then
        return 
    end
    local client_player = game_client:GetPlayer()
    if not nx_is_valid(client_player) then
        return 
    end
	local game_visual=nx_value("game_visual")
	if not nx_is_valid(game_visual) then
        return 
    end	
	if IsBusy() then
		return
	end	
	if nx_number(total_current) < nx_number(total_count) then
		nx_value("game_visual"):CustomSend(nx_int(182), nx_int(8))
		total_current = total_current + 1
		nx_pause(0.1)				
	end
end
local text_lang = false
function main_form_init(form)
    form.Fixed = false	
	-- if not text_lang then
		-- local get_lang = nx_string(readIni(nx_work_path()..'system_set.ini','main','Language',''))
		-- if get_lang ~= 'ChineseS' and get_lang ~= 'ChineseT' and get_lang ~= 'English' and get_lang ~= 'Russian' and get_lang ~= 'Thai' and get_lang ~= 'Vietnamese' and nx_int(get_lang) == nx_int(0) then	
			-- require('aow_auto\\auto_lang\\Vietnamese')
		-- else
			-- require('aow_auto\\auto_lang\\'..get_lang)
		-- end	
		-- text_lang = true	
	-- end
end
function on_main_form_open(form)	
  init_ui_content(form)
end
function show_hide_form()
  util_auto_show_hide_form(path_form)
end
function init_ui_content(form)
	load_text_auto_main(form)	
	update_btn_onOff()
end
auto_title_cp 		 = 'Chúc Phúc'
auto_help_cp		 = 'Hướng Dẫn<br>● Nhập số lần mà bạn muốn chúc phúc và ấn bắt đầu'
auto_text_edit_buy	= 'Số lượng muốn mua và dùng'
auto_lbl_1			= 'Số lượng đã dùng'

load_text_auto_main = function(form)
	if nx_is_valid(form) then
		form.lbl_siri_highest_priority_title.Text = utf8ToWstr('Chúc Phúc')
		form.btn_help.HintText = utf8ToWstr('Hướng Dẫn<br>● Nhập số lần mà bạn muốn chúc phúc và ấn bắt đầu')
		form.lbl_auto.Text = utf8ToWstr('Số lượng muốn mua và dùng')
		form.lbl_auto_1.Text = utf8ToWstr('Số lượng đã dùng')
	end
end
function on_btn_close_click(form)
	local form = nx_value(path_form)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
function on_main_form_close(form)	
	nx_destroy(form)
end
function btn_start_use(btn)
	local form = btn.ParentForm
	if nx_running(nx_current(),'auto_start_wish') then
		nx_execute(nx_current(),'set_state_auto_wish',false)
		nx_kill(nx_current(),'auto_start_wish')
	else
		nx_execute(nx_current(),'set_state_auto_wish',true)
		nx_execute(nx_current(),'auto_start_wish')
	end
	update_btn_onOff()
end
auto_start 	= 'Bắt Đầu'
auto_stop	= 'Dừng'
update_btn_onOff = function()
	local form = nx_value(path_form)
	if get_state_auto_wish() then
		form.btn_start_use.Text = utf8ToWstr(auto_stop)
	else
		form.btn_start_use.Text = utf8ToWstr(auto_start)
	end
end