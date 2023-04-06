require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")

local THIS_FORM = "admin_yBreaker\\yBreaker_form_bugs"
-- Declare variable
local isStartJump = false
local isJetsu = false

function on_form_main_init(form)
    form.Fixed = false
    form.is_minimize = true

end

function on_btn_minimize_click(btn)
  local form = btn.ParentForm
  form.Visible = false
end

function on_main_form_open(form)
    change_form_size()
    form.is_minimize = false
	
	-- Get FPS current for edit text
	local world = nx_value("world")
	local scene = world.MainScene
	local game_control = scene.game_control
	local form1 = util_get_form("admin_yBreaker\\yBreaker_form_bugs", true, false)
	form1.ipt_fps_value.Text = nx_widestr(game_control.MaxDisplayFPS)
end

function on_main_form_close(form)
    nx_destroy(form)
end

function on_btn_close_click(btn)
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return
    end
    isStartJump = false
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
	yBreaker_show_Utf8Text("Đã áp dụng FPS mới", 3)
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
    yBreaker_show_Utf8Text("Tốc độ hiện tại tăng: "..nx_string(nx_int(speed_int)).." lần", 3)
    yBreaker_show_Utf8Text("Chỉ sử dụng khi khinh công.", 3)
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
--	local hate_player_name = string.match(nx_string(form1.ipt_char_name.Text), "/(%a*)%s*(%a*%d*)")
--    for str in string.gmatch(nx_function("ext_widestr_to_utf8", ), "([^".."%s".."]+)") do
 --           table.insert(hate_player_name, str)
 --   end	
    nx_execute("custom_sender", "custom_add_relation", nx_int(10), nx_widestr(form1.ipt_char_name.Text), nx_int(3), nx_int(-1))
	
	--//Add danh sách đen
	--nx_execute("custom_sender", "custom_add_relation", 4, nx_widestr("Fanta.Sarsi"), 8, nx_int(-1))	
	--// Remove chí hữu
	--nx_execute("custom_sender", "custom_add_relation", 7, nx_widestr("Fanta.Sarsi"), 1, nx_int(-1))	
	--// Thêm túc địch
	--nx_execute("custom_sender", "custom_add_relation", 4, nx_widestr("Fanta.Sarsi"), 3, 4)	
	--// Thêm huyết cừu
	--nx_execute("custom_sender", "custom_add_relation", 10, nx_widestr("Fanta.Sarsi"), 3, nx_int(-1))
	--nx_execute("custom_sender", "custom_add_relation", 4, nx_widestr("Fanta.Sarsi"), 4, 3)
end

-- Function delete hate player
function on_btn_del_hate_player_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
	
	local form1 = util_get_form("admin_yBreaker\\yBreaker_form_bugs", true, false)	
	nx_execute("custom_sender", "custom_add_relation", nx_int(6), nx_widestr(form1.ipt_char_name.Text), nx_int(3), nx_int(-1))
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
	if isStartJump then
		isStartJump = false
		form1.btn_jump_hight.Text = nx_function("ext_utf8_to_widestr", "Nhảy Cao")
	else
	
		isStartJump = true
		form1.btn_jump_hight.Text =  nx_function("ext_utf8_to_widestr", "Dừng Lại")
		yBreaker_show_Utf8Text("Tự nhảy cao chỉ nên dùng cho clone đàn", 3)
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

	if isJetsu then
		isJetsu = false
		-- Execute special.lua in lua
		nx_execute("special", "switch_mode")
		
		form.btn_jetsu.Text = nx_function("ext_utf8_to_widestr", "Nhẫn Thuật")
	else
		isJetsu = true
		-- Execute special.lua in lua
		nx_execute("special", "switch_mode")
		
		-- Switch mode 3 để lên cao/ độn thổ
		--nx_execute("special", "custom_btn_mode", "mode_1") Mode này nhảy liên tục
		nx_execute("special", "custom_btn_mode", "mode_3")
		yBreaker_show_Utf8Text("Bấm Space để trở lại bình thương")
		form.btn_jetsu.Text = nx_function("ext_utf8_to_widestr", "Dừng Lại")
	end
end

-- Function Bay lên trời/ Độn thổ
function on_btn_god_ping_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
	
	-- Execute function đè ping
	nx_execute("admin_yBreaker\\yBreaker_scripts_func\\yBreaker_scripts_godping", "yBreaker_god_ping")

	if form.btn_god_ping.Text == nx_function("ext_utf8_to_widestr", "Dừng Lại") then
		
		form.btn_god_ping.Text = nx_function("ext_utf8_to_widestr", "Cấm Thuật")
	else
		form.btn_god_ping.Text = nx_function("ext_utf8_to_widestr", "Dừng Lại")
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

-- Update speed
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
  while isStartJump == true do
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
		isStartJump = false
	end
	
	if nx_running(nx_current(),"jumpjump") then
		form.btn_jump_hight.Text = nx_function("ext_utf8_to_widestr", "Dừng Lại")
		isStartJump = true
	else
		form.btn_jump_hight.Text = nx_function("ext_utf8_to_widestr", "Nhảy Cao")
		isStartJump = false
	end
end
