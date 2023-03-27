require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")

local THIS_FORM = "admin_yBreaker\\yBreaker_form_bugs"
-- Declare variable
local autoStartJump = false
local autoJutsu = false

function on_form_main_init(form)
    form.Fixed = false
    form.is_minimize = false

end

function on_main_form_open(form)
    change_form_size()
    form.is_minimize = false
	
	-- Get FPS current for edit text
	--local scene = world.MainScene
	--local game_control = scene.game_control
	--local form1 = util_get_form("admin_yBreaker\\yBreaker_form_bugs", true, false)
	--form1.ipt_fps_value.Text = nx_widestr(game_control.MaxDisplayFPS)
end

function on_main_form_close(form)
    nx_destroy(form)
end

function on_btn_close_click(btn)
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return
    end
    autoStartJump = false
    on_main_form_close(form)
end

function change_form_size()
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return
    end
    local gui = nx_value("gui")
    form.Left = 100
    form.Top = 140
end

function show_hide_form_bugs()
	util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_bugs")
end

-- Function apply FPS
function on_btn_fps_apply_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end

	local form1 = util_get_form("admin_yBreaker\\yBreaker_form_bugs", true, false)
	local fps_int = form1.ipt_fps_value.Text
    
	-- Apply new FPS setting
	fps_setting(nx_int(fps_int))
	yBreaker_show_Utf8Text("Đã lưu setting FPS mới", 3)
end

-- Function apply Speed
function on_btn_speed_apply_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end

  local btn = form.ParentForm
  local form1 = util_get_form("admin_yBreaker\\yBreaker_form_bugs", true, false)
  if autoStartSpeed then
    autoStartSpeed = false
    btn.btn_speed_apply.Text = nx_widestr("Start Speed")
  else
    local speed_int = form1.ipt_speed_value.Text
    if nx_int(speed_int) >= nx_int(45) then
        yBreaker_show_Utf8Text("Chọn thấp hơn 45 thôi", 3)
      return
    end
    autoStartSpeed = true
    btn.btn_speed_apply.Text = nx_widestr("Stop Speed")
    yBreaker_show_Utf8Text("Tốc Độ Là : "..nx_string(nx_int(speed_int)).." lần", 3)
    yBreaker_show_Utf8Text("Auto chỉ sử dụng khi khinh công. Ít sữ dụng tránh bị report", 3)
    autoSpeed(nx_int(speed_int))
  end
  update_btn_start_speed()
end

-- Function add hate player
function on_btn_add_hate_player_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
	
	local form1 = util_get_form("admin_yBreaker\\yBreaker_form_bugs", true, false)
	local t = {}
    for str in string.gmatch(nx_function("ext_widestr_to_utf8", yBreaker_Utf8_to_Wstr(form1.ipt_char_name.Text)), "([^".."%s".."]+)") do
            table.insert(t, str)
    end	
    nx_execute("custom_sender", "custom_add_relation", nx_int(10), nx_function("ext_utf8_to_widestr",t[2]), nx_int(3), nx_int(-1))
	
	-- Thông báo
	yBreaker_show_Utf8Text("Đã thêm vào danh sách thù")
end

-- Function delete hate player
function on_btn_del_hate_player_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
	
	local form1 = util_get_form("admin_yBreaker\\yBreaker_form_bugs", true, false)
	local t = {}
    for str in string.gmatch(nx_function("ext_widestr_to_utf8", yBreaker_Utf8_to_Wstr(form1.ipt_char_name.Text)), "([^".."%s".."]+)") do
            table.insert(t, str)
    end
	
	-- Thông báo
    nx_execute("custom_sender", "custom_add_relation", nx_int(6), nx_function("ext_utf8_to_widestr",t[2]), nx_int(3), nx_int(-1))
	yBreaker_show_Utf8Text("Đã xóa khỏi danh sách thù")
end

-- Function Hải bố
function on_btn_hai_bo_click(btn)
	util_auto_show_hide_form("form_stage_main\\form_arrest\\form_publish_arrest")
end

-- Function Bổ khoái
function on_btn_bo_khoai_click(btn)
    nx_value("game_visual"):CustomSend(nx_int(926), nx_int(8),nx_int(1))
end

-- Function tele DHC
function on_btn_tele_DHC_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
	
	-- Send message to tele DHC
	nx_value("game_visual"):CustomSend(nx_int(521), nx_int(1),nx_int(1))
end

-- Function tele Đảo thanh hải 1
function on_btn_tele_DAO_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end

	-- Send message to tele Thanh Hải 1
	nx_value("game_visual"):CustomSend(nx_int(554), nx_int(1),nx_int(1))
end

-- Function tự nhảy cao không tốn khinh công
function on_btn_jump_hight_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end

	local form1 = util_get_form("admin_yBreaker\\yBreaker_form_bugs", true, false)
	if autoStartJump then
		autoStartJump = false
		form1.btn_jump_hight.Text = nx_function("ext_utf8_to_widestr", "Nhảy Cao")
	else
	
		autoStartJump = true
		form1.btn_jump_hight.Text =  nx_function("ext_utf8_to_widestr", "Dừng Lại")
		yBreaker_show_Utf8Text("Ít sữ dụng tránh bị report chỉ nên dùng cho đàn", 3)
		jumpjump()
	end
	
	-- Execute start jump
	update_btn_start_jump()

end

-- Function Bay lên trời/ Độn thổ
function on_btn_jetsu_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end

	if autoJutsu then
		autoJutsu = false
		-- Execute special.lua in lua
		nx_execute("special", "switch_mode")
		
		form.btn_jetsu.Text = nx_function("ext_utf8_to_widestr", "Nhẫn Thuật")
	else
		autoJutsu = true
		-- Execute special.lua in lua
		nx_execute("special", "switch_mode")
		
		-- Switch mode 3 để lên cao/ độn thổ
		--nx_execute("special", "custom_btn_mode", "mode_1") Mode này nhảy liên tục
		nx_execute("special", "custom_btn_mode", "mode_3")
		yBreaker_show_Utf8Text("Bấm Space để trở lại bình thương")
		form.btn_jetsu.Text = nx_function("ext_utf8_to_widestr", "Dừng Lại")
	end
end

function autoSpeed(speed)
  local role = util_get_role_model()
  local game_visual = nx_value("game_visual")
  local game_player = game_visual:GetPlayer()
      while autoStartSpeed == true do
      if nx_is_valid(role) and role.state ~= "locked" and role.state ~= "motion" then
      game_visual:SetRoleMoveSpeed(role, speed)
      game_visual:QueryRoleMoveSpeed(role)
      local scene_obj = nx_value("scene_obj")
      local scene = nx_value("scene")
      local terrain = scene.terrain
      terrain = nx_value("terrain")
    end
    nx_pause(0)
  end
end

function update_btn_start_speed()
  local form = util_get_form("admin_yBreaker\\yBreaker_form_bugs", true, false)
  if form.Visible == false then
    autoStartSpeed = false
  end
  if nx_running(nx_current(),"autoSpeed") then
    form.btn_speed_apply.Text = nx_widestr("Stop Speed")
    autoStartSpeed = true
  else
    form.btn_speed_apply.Text = nx_widestr("Start Speed")
    autoStartSpeed = false
  end
end

-- Function jump
function jumpjump()
local game_visual = nx_value('game_visual')
local role = util_get_role_model()
  while autoStartJump == true do
    if nx_is_valid(role) and role.state ~= "locked" then
	     local visual_player = game_visual:GetPlayer()
	      game_visual:SwitchPlayerState(visual_player, 30000, 22)
    end
    nx_pause(0.5)
  end
end

-- Function update start jump
function update_btn_start_jump()
	local form = util_get_form("admin_yBreaker\\yBreaker_form_bugs", true, false)
	
	if form.Visible == false then
		autoStartJump = false
	end
	
	if nx_running(nx_current(),"jumpjump") then
		form.btn_jump_hight.Text = nx_function("ext_utf8_to_widestr", "Dừng Lại")
		autoStartJump = true
	else
		form.btn_jump_hight.Text = nx_function("ext_utf8_to_widestr", "Nhảy Lên")
		autoStartJump = false
	end
end
