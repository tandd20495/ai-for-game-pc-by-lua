require("auto_new\\autocack")
if not load_spec_active_spec then
	auto_cack('0')
	auto_cack('2')
	auto_cack('6')
	auto_cack('14')
	load_spec_active_spec = true
end
function main_form_init(form)
  form.Fixed = false
end
FORM_MAP_SCENE = "form_stage_main\\form_map\\form_map_scene"
function on_main_form_open(form)
	local file = add_file("Active")
	load_auto_spec(form)
	if AUTO_VER_SPECIAL == 'AUTO_SPECIAL' then
		form.edt_key_target.Text = nx_widestr(nx_string(readIni(file, "key", "lic_target", "")))
		form.edt_key_thbb.Text = nx_widestr(nx_string(readIni(file, "key", "lic_thbb", "")))
		form.edt_key_search_player.Text = nx_widestr(nx_string(readIni(file, "key", "lic_search_player", "")))
		form.edt_key_undef_pro.Text = nx_widestr(nx_string(readIni(file, "key", "lic_def", "")))
		form.edt_key_swap.Text = nx_widestr(nx_string(readIni(file, "key", "lic_swap", "")))
		form.edt_key_ping_pro.Text = nx_widestr(nx_string(readIni(file, "key", "lic_ping_plus", "")))
		form.edt_key_ping_classic.Text = nx_widestr(nx_string(readIni(file, "key", "lic_ping", "")))
		form.edt_key_auto_speed.Text = nx_widestr(nx_string(readIni(file, "key", "lic_auto_speed", "")))
	end
	form.edt_key_undef.Text = nx_widestr(nx_string(readIni(file, "key", "lic_undef", "")))
	form.edt_key_bug_quat.Text = nx_widestr(nx_string(readIni(file, "key", "lic_bugquat", "")))
	form.edt_key_bug_hpmp.Text = nx_widestr(nx_string(readIni(file, "key", "lic_hpmp", "")))
end
load_auto_spec = function(form)
	if not nx_is_valid(form) then
		return
	end
	if AUTO_VER_SPECIAL == 'AUTO_SPECIAL' then
		form.lbl_1.Visible = true
		form.edt_key_target.Visible = true
		form.edt_key_thbb.Visible = true
		form.edt_key_undef_pro.Visible = true
		form.edt_key_search_player.Visible = true
		form.edt_key_swap.Visible = true
		form.edt_key_ping_pro.Visible = true
		form.edt_key_ping_classic.Visible = true
		form.edt_key_auto_speed.Visible = true
	else
		form.lbl_1.Visible = false
		form.edt_key_target.Visible = false
		form.edt_key_thbb.Visible = false
		form.edt_key_undef_pro.Visible = false
		form.edt_key_search_player.Visible = false
		form.edt_key_swap.Visible = false
		form.edt_key_ping_pro.Visible = false
		form.edt_key_ping_classic.Visible = false
		form.edt_key_auto_speed.Visible = false
	end
end
function on_main_form_close(form)
  nx_destroy(form)
end
function on_btn_close_click(form)
  local form = nx_value("auto_new\\form_auto_active_special")
  if not nx_is_valid(form) then
    return
  end
  on_main_form_close(form)
end
function btn_add_start(btn)
  local form = btn.ParentForm
  local file = add_file("Active")
  if AUTO_VER_SPECIAL == 'AUTO_SPECIAL' then
	local lic_target = form.edt_key_target.Text
	local lic_thbb = form.edt_key_thbb.Text
	local lic_search_player = form.edt_key_search_player.Text
	local lic_undef_pro = form.edt_key_undef_pro.Text
	local lic_swap = form.edt_key_swap.Text
	local lic_ping_pro = form.edt_key_ping_pro.Text
	local lic_auto_speed = form.edt_key_auto_speed.Text
	local lic_ping_classic = form.edt_key_ping_classic.Text
	writeIni(file, "key", "lic_target", lic_target)
	writeIni(file, "key", "lic_thbb", lic_thbb)
	writeIni(file, "key", "lic_search_player", lic_search_player)
	writeIni(file, "key", "lic_def", lic_undef_pro)
	writeIni(file, "key", "lic_swap", lic_swap)
	writeIni(file, "key", "lic_ping_plus", lic_ping_pro)
	writeIni(file, "key", "lic_ping", lic_ping_classic)
	writeIni(file, "key", "lic_auto_speed", lic_auto_speed)
	auto_add_server_target(nx_string(lic_target))
	auto_add_server_def(nx_string(lic_undef_pro))
	auto_add_server_ping(nx_string(lic_ping_classic))
	auto_add_server_plus(nx_string(lic_ping_pro))
	auto_add_server_swap(nx_string(lic_swap))
	auto_add_server_thbb(nx_string(lic_thbb))
	auto_add_server_auto_speed(nx_string(lic_auto_speed))  
  end
  local lic_undef = form.edt_key_undef.Text
  local lic_bugquat = form.edt_key_bug_quat.Text
  local lic_buff_hpmp = form.edt_key_bug_hpmp.Text 
  writeIni(file, "key", "lic_undef", lic_undef)
  writeIni(file, "key", "lic_bugquat", lic_bugquat)
  writeIni(file, "key", "lic_hpmp", lic_buff_hpmp) 
  auto_add_server_lic_undef(nx_string(lic_undef))
  showUtf8Text("Save Active Success")
end
