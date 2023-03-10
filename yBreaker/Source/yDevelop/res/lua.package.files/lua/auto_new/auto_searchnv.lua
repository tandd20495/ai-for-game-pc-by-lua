require("util_gui")
require("define\\gamehand_type")
require("const_define")
require('auto_new\\autocack')
if not load_spec_search then
	auto_cack('0')
	auto_cack('2')
	auto_cack('6')
	auto_cack('14')
	load_spec_search = true
end
local THIS_FORM = "auto_new\\auto_searchnv"
function main_form_init(form)
  form.Fixed = false
end
function on_main_form_open(form)
  init_ui_content(form)
end
function autoShowInfo(current, x, z, ident, id)
  local info = "T\225\187\141a \196\144\225\187\153 : <a href='findObj," .. current .. "," .. nx_string(x) .. ", " .. nx_string(0) .. ", " .. nx_string(z) .. ", " .. nx_string(ident) .. "' style='HLStype1'>[" .. id .. "]</a> (" .. string.format("%.0f", x) .. ", " .. string.format("%.0f", z) .. ")"
  return info
end
function targetName(nametarget)
  local game_visual = nx_value("game_visual")
  if not nx_is_valid(game_visual) then
    return true
  end
  local game_client = nx_value("game_client")
  if not nx_is_valid(game_client) then
    return true
  end
  local game_scence = game_client:GetScene()
  if not nx_is_valid(game_scence) then
    return true
  end
  local player_client = game_client:GetPlayer()
  if not nx_is_valid(player_client) then
    return true
  end
  local gui = nx_value("gui")
  if not nx_is_valid(gui) then
    return true
  end
  local game_scence_objs = game_scence:GetSceneObjList()
  for i = 1, table.getn(game_scence_objs) do
    local obj = game_scence_objs[i]
    if nx_is_valid(obj) and obj:QueryProp("Type") == 2 and player_client:QueryProp("Name") ~= obj:QueryProp("Name") and obj:QueryProp("OffLineState") == 0 and nametarget == obj:QueryProp("Name") then
      return obj
    end
  end
  return nil
end
function on_btn_start_click(form)
  local btn = form.ParentForm
  local form_search = util_get_form(THIS_FORM, true, false)
  local nameaccount = form_search.edt_name_player.Text
  local nameuft = wstrToUtf8(nameaccount)
  if nx_running('auto_new\\auto_special_lib', "auto_search_player_to_map") then
    nx_execute('auto_new\\auto_special_lib', "setSendNVState", false)
    nx_kill('auto_new\\auto_special_lib', "auto_search_player_to_map")
  else
    nx_execute('auto_new\\auto_special_lib', "setSendNVState", true)
    nx_execute('auto_new\\auto_special_lib', "auto_search_player_to_map", nameuft)
  end
  update_btn_search(btn)
end
function update_btn_search(form)
  if nx_running('auto_new\\auto_special_lib', "auto_search_player_to_map") then
    form.btn_start.Text = nx_widestr("Stop")
  else
    form.btn_start.Text = nx_widestr("Start")
  end
end
function init_ui_content(form)
  update_btn_search(form)
end
function on_btn_close_click(form)
  local form = nx_value(THIS_FORM)
  if not nx_is_valid(form) then
    return
  end
  on_main_form_close(form)
end
function on_main_form_close(form)
  nx_destroy(form)
end
