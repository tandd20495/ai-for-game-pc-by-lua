require('utils')
require('util_gui')
require('util_move')
require('tips_data')
require('util_functions')
require('game_object')
require('const_define')
require('player_state\\state_const')
require('player_state\\logic_const')
require("player_state\\state_input")
require('define\\sysinfo_define')
require('define\\request_type')
require('share\\chat_define')
require('share\\client_custom_define')
require('share\\logicstate_define')
require('share\\view_define')
require('share\\capital_define')
require('share\\itemtype_define')
require('form_stage_main\\form_battlefield\\battlefield_define')
require("form_stage_main\\form_tvt\\define")
require("form_stage_main\\form_task\\task_define")
require('util_static_data')
require('define\\team_rec_define')
require('auto_new\\autocack')
local bug_list = {
  "Tele Đảo Thanh Hải",
  "Tele Di Hoa Cung",  
  "Bổ Khoái",
  "Hải Bố"
}
function main_form_init(form)
    form.Fixed = false
end
function on_main_form_open(form)
  
  init_ui_content(form)
end
function show_hide_form_bug()
  util_show_form("auto_new\\form_auto_b",false)
end
function reset_form_b(form)
	form.cbx_load_bug.DropListBox:ClearString()
	form.cbx_load_bug.Text = nx_widestr("")
end

function on_btn_start_bug(form)
  local btn = form.ParentForm
  local id, idcs = autoGetBugID(btn.cbx_load_bug.Text)
  local game_visual = nx_value("game_visual")
  game_visual:CustomSend(id, idcs)
end
function autoGetBugID(bug_int_list)
	if bug_int_list == utf8ToWstr("Bổ Khoái") then
        id =nx_int(926)
        idcs = nx_int(8) 
	elseif bug_int_list == utf8ToWstr("Hải Bố") then
			util_auto_show_hide_form("form_stage_main\\form_arrest\\form_publish_arrest")
	elseif bug_int_list == utf8ToWstr("Tele Đảo Thanh Hải") then
				id = nx_int(554)
                idcs = nx_int(1)
     elseif bug_int_list == utf8ToWstr("Tele Di Hoa Cung") then
				id = nx_int(521)
                idcs = nx_int(1)
    end
    return id, idcs
end
function update_btn_start_speed()
  local form = util_get_form("auto_new\\form_auto_b", true, false)
  if form.Visible == false then
    autoStartSpeed = false
  end
  if nx_running(nx_current(),"autoSpeed") then
    form.btn_start_speed.Text = nx_widestr("Stop")
    autoStartSpeed = true
  else
    form.btn_start_speed.Text = nx_widestr("Start")
    autoStartSpeed = false
  end
end
function init_ui_content(form)
  reset_form_b(form)
  update_btn_start_speed()
  update_btn_start_jump()
  update_btn_start_help()
  update_btn_start_stl()
  autoStartSpeed = false
  autoStartJump = false
  autoStartstl = false
  autoStartHelp = false
  local combobox = form.cbx_load_bug
	if combobox.DroppedDown then
		combobox.DroppedDown = false
	end
  for i = 1, table.getn(bug_list)do
  		form.cbx_load_bug.DropListBox:AddString(utf8ToWstr(bug_list[i]))
  end
    combobox.Text = utf8ToWstr(bug_list[1])
    form.btn_start_stop.Text = nx_widestr("Start")
    form.btn_start_speed.Text = nx_widestr("Start")
    form.btn_start_jump.Text = nx_widestr("Start")
    form.btn_clickstl_speed.Text = nx_widestr("Start")
    form.btn_clickhelpper_speed.Text = nx_widestr("Start")
end
function on_btn_close_click(form)
	show_hide_form_bug()
end
function on_btn_start_speed(form)
  local btn = form.ParentForm
  local form1 = util_get_form("auto_new\\form_auto_b", true, false)
  if autoStartSpeed then
    autoStartSpeed = false
    btn.btn_start_speed.Text = nx_widestr("Start")
  else
    local speed_int = form1.edt_speed_int.Text
    if nx_int(speed_int) >= nx_int(45) then
        showUtf8Text("Chọn thấp thôi bạn ơi văng games đấy", 3)
      return
    end
    autoStartSpeed = true
    btn.btn_start_speed.Text = nx_widestr("Stop")
    showUtf8Text("Tốc Độ Là : "..nx_string(nx_int(speed_int)).." lần", 3)
    showUtf8Text("Auto chỉ sử dụng khi khinh công. Ít sữ dụng tránh bị report", 3)
    autoSpeed(nx_int(speed_int))
  end
  update_btn_start_speed()
end
function autoSpeed(speed)
  local role = util_get_role_model()
  local game_visual = nx_value("game_visual")
  local game_player = game_visual:GetPlayer()
      while autoStartSpeed == true do
      if nx_is_valid(role) and role.state ~= "locked" and role.state ~= "motion" then
	  role.move_dest_orient = role.AngleY
	  role.server_pos_can_accept = true
	  game_visual:QueryRoleMoveSpeed(role)
      game_visual:SetRoleMoveSpeed(role, speed)
      
      local scene_obj = nx_value("scene_obj")
      local scene = nx_value("scene")
      local terrain = scene.terrain
      terrain = nx_value("terrain")
    end
    nx_pause(0)
  end
end
function jumpjump()
local game_visual = nx_value('game_visual')
local role = util_get_role_model()
  while autoStartJump == true do
    if nx_is_valid(role) and role.state ~= "locked" then
		role.move_dest_orient = role.AngleY
		role.server_pos_can_accept = true
	    local visual_player = game_visual:GetPlayer()
	    game_visual:SwitchPlayerState(visual_player, 10000, 22)
    end
    nx_pause(1)
  end
end
function update_btn_start_jump()
  local form = util_get_form("auto_new\\form_auto_b", true, false)
  if form.Visible == false then
    autoStartJump = false
  end
  if nx_running(nx_current(),"jumpjump") then
    form.btn_start_jump.Text = nx_widestr("Stop")
    autoStartJump = true
  else
    form.btn_start_jump.Text = nx_widestr("Start")
    autoStartJump = false
  end
end
function on_btn_start_jump(form)
  local btn = form.ParentForm
  local form1 = util_get_form("auto_new\\form_auto_b", true, false)
  if autoStartJump then
    autoStartJump = false
    btn.btn_start_jump.Text = nx_widestr("Start")
  else
    autoStartJump = true
    btn.btn_start_jump.Text = nx_widestr("Stop")
    showUtf8Text("Ít sữ dụng tránh bị report chỉ nên dùng cho đàn", 3)
    jumpjump()
  end
  update_btn_start_jump()
end
function clickstl(name)
  while autoStartstl == true do
	   local HELPER_FROM = "form_stage_main\\form_helper\\form_main_helper_manager"
	    nx_execute(HELPER_FROM, "close_helper_form")
	   local game_visual = nx_value("game_visual")
	     game_visual:CustomSend(nx_int(101), 119, utf8ToWstr(name), 1, "item_ssf_shoushaoyang_z")
       nx_pause(0.5)
     end
end
function helppertrans()
  while autoStartHelp == true do
    nx_pause(0.5)
    local HELPER_FROM = "form_stage_main\\form_helper\\form_main_helper_manager"
    nx_execute(HELPER_FROM, "close_helper_form")
  end
end
function update_btn_start_stl()
  local form = util_get_form("auto_new\\form_auto_b", true, false)
  if form.Visible == false then
    autoStartstl = false
  end
  if nx_running(nx_current(),"clickstl") then
    form.btn_clickstl_speed.Text = nx_widestr("Stop")
    autoStartstl = true
  else
    form.btn_clickstl_speed.Text = nx_widestr("Start")
    autoStartstl = false
  end
end
function on_btn_start_stl(form)
  local btn = form.ParentForm
  local form1 = util_get_form("auto_new\\form_auto_b", true, false)
  if autoStartstl then
    autoStartstl = false
    btn.btn_clickstl_speed.Text = nx_widestr("Start")
  else
    local name = wstrToUtf8(form1.edt_clickstl_int.Text)
    autoStartstl = true
    btn.btn_clickstl_speed.Text = nx_widestr("Stop")
    showUtf8Text("Ít sữ dụng tránh bị report chỉ nên dùng cho đàn", 3)
    clickstl(name)
  end
  update_btn_start_stl()
end
function update_btn_start_help()
  local form = util_get_form("auto_new\\form_auto_b", true, false)
  if form.Visible == false then
    autoStartHelp = false
  end
  if nx_running(nx_current(),"helppertrans") then
    form.btn_clickhelpper_speed.Text = nx_widestr("Stop")
    autoStartHelp = true
  else
    form.btn_clickhelpper_speed.Text = nx_widestr("Start")
    autoStartHelp = false
  end
end
function on_btn_start_help(form)
  local btn = form.ParentForm
  if autoStartHelp then
    autoStartHelp = false
    btn.btn_clickhelpper_speed.Text = nx_widestr("Start")
  else
    autoStartHelp = true
    btn.btn_clickhelpper_speed.Text = nx_widestr("Stop")
    helppertrans()
  end
  update_btn_start_help()
end