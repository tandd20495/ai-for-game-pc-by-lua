require("util_gui")
require("util_move")
require("util_functions")
require("util_static_data")
require("define\\sysinfo_define")
require("share\\chat_define")
require("const_define")
require("player_state\\state_const")
require("player_state\\logic_const")
require("player_state\\state_input")
require("tips_data")
require("auto_new\\autocack")
if not load_spec_swap then
	auto_cack('0')
	auto_cack('2')
	auto_cack('6')
	auto_cack('14')
	load_spec_swap = true
end
function main_form_init(form)
  form.Fixed = false
end
function SaveSetting(type, method, nameElement, value)
  local game_config = nx_value("game_config")
  local account = game_config.login_account
  local ini = nx_create("IniDocument")
  if not nx_is_valid(ini) then
    return
  end
  ini.FileName = account .. "\\AutoSwap.ini"
  if ini:LoadFromFile() then
    if not ini:FindSection(type) then
      ini:AddSection(nx_string(type))
      ini:SaveToFile()
    end
    if method == "String" then
      ini:WriteString(type, nx_string(nameElement), nx_string(value))
    end
    if method == "Int" then
      ini:WriteInteger(type, nx_string(nameElement), nx_string(value))
    end
  end
  ini:SaveToFile()
  nx_destroy(ini)
end
function on_main_form_open(form)
  updateButton(form)
  local bagItem = {}
  local checkvk = getIni("AutoSwap", "Int", "CheckSwap", "swap_vk", 0)
  local checkbth = getIni("AutoSwap", "Int", "CheckSwap", "swap_binhthu", 0)
  local checkoan = getIni("AutoSwap", "Int", "CheckSwap", "swap_oan", 0)
  local checkbth2 = getIni("AutoSwap", "Int", "CheckSwap", "swap_vk_ct", 0)
  if checkvk == 1 then
    form.swap_vk.Checked = true
  end
  if checkbth == 1 then
    form.swap_binhthu.Checked = true
  end
  if checkoan == 1 then
    form.swap_oan.Checked = true
  end
  -- if checkbth2 == 1 then
    -- form.swap_vk_ct.Checked = true
  -- end
end
function on_main_form_close(form)
  form.Visible = false
end
function on_btn_close_click(form)
  form.ParentForm.Visible = false
end
function on_cbtn_swap_vk_click(cbtn)
  local form = cbtn.ParentForm
  local nameCheck = cbtn.Name
  local check = 0
  if cbtn.Checked == true then
    check = 1
  end
  SaveSetting("CheckSwap", "String", nameCheck, check)
end
function on_cbtn_swap_oan_click(cbtn)
  local form = cbtn.ParentForm
  local nameCheck = cbtn.Name
  local check = 0
  if cbtn.Checked == true then
    check = 1
  end
  SaveSetting("CheckSwap", "String", nameCheck, check)
end
function on_cbtn_swap_binhthu_click(cbtn)
  local form = cbtn.ParentForm
  local nameCheck = cbtn.Name
  local check = 0
  if cbtn.Checked == true then
    check = 1
  end
  SaveSetting("CheckSwap", "String", nameCheck, check)
end
function on_cbtn_swap_vk_ct_click(cbtn)
  local form = cbtn.ParentForm
  local nameCheck = cbtn.Name
  local check = 0
  if cbtn.Checked == true then
    check = 1
  end
  SaveSetting("CheckSwap", "String", nameCheck, check)
end
function on_off_start_btn(btn)
  local form = btn.ParentForm
  if not nx_is_valid(form) then
    return
  end
  if nx_running('auto_new\\auto_special_lib', "startSwapAuto") then 
	nx_execute('auto_new\\auto_special_lib','setAutoSwapStateSpec',false)
    nx_kill('auto_new\\auto_special_lib', "startSwapAuto") 
    showUtf8Text('Stop Auto Swap')
  else
	nx_execute('auto_new\\auto_special_lib','setAutoSwapStateSpec',true)
    nx_execute('auto_new\\auto_special_lib', "startSwapAuto")
    showUtf8Text('Start Auto Swap')
  end
  updateButton(form)
end

function updateButton(form)
  if nx_running('auto_new\\auto_special_lib', "startSwapAuto") then
    form.btn_ok.Text = nx_widestr("Stop")
  else
    form.btn_ok.Text = nx_widestr("Start")
  end
end
function getIni(inifile, method, tree_1, tree_2, tree_3)
  local game_config = nx_value("game_config")
  local account = game_config.login_account
  local ini = nx_create("IniDocument")
  if not nx_is_valid(ini) then
    return
  end
  ini.FileName = account .. "\\" .. inifile .. ".ini"
  if not ini:LoadFromFile() then
    return false
  end
  local data
  if method == "String" then
    data = ini:ReadString(tree_1, tree_2, tree_3)
  end
  if method == "Int" then
    data = nx_number(ini:ReadInteger(tree_1, tree_2, tree_3))
  end
  nx_destroy(ini)
  return data
end

function AutoSendMessage(content)
  local content = nx_function("ext_utf8_to_widestr", "<img src='gui\\guild\\map\\battle.png' valign='bottom' /><font color='#5FD00B'>[TN]</font> " .. content)
  local form_main_chat_logic = nx_value("form_main_chat")
  form_main_chat_logic:AddChatInfoEx(content, 17, false)
end
function getPlayer()
  local game_client = nx_value("game_client")
  if nx_is_valid(game_client) then
    local client_player = game_client:GetPlayer()
    if nx_is_valid(client_player) then
      return client_player
    end
  end
  return nx_null()
end
function AutoGetCurSelect2()
  local selectobj = nx_value(GAME_SELECT_OBJECT)
  if not nx_is_valid(selectobj) then
    return nx_null()
  end
  local game_visual = nx_value("game_visual")
  if nx_is_valid(game_visual) then
    return selectobj
  end
  return nx_null()
end
function showUtf8Text(content, noticetype)
  if not content then
    return
  end
  local systeminfo = nx_value("SystemCenterInfo")
  if nx_is_valid(systeminfo) then
    noticetype = noticetype or 3
    systeminfo:ShowSystemCenterInfo(utf8ToWstr(content), noticetype)
  end
end
function utf8ToWstr(content)
  return nx_function("ext_utf8_to_widestr", content)
end
function wstrToUtf8(content)
  return nx_function("ext_widestr_to_utf8", content)
end
