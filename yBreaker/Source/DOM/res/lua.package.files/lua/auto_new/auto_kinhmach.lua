require("auto_new\\autocack")
if not load_spec_mach then
	auto_cack('0')
	auto_cack('2')
	auto_cack('6')
	auto_cack('14')
	load_spec_mach = true
end
local main_form = "auto_new\\auto_kinhmach"
function on_form_main_init(form)
  form.Fixed = false
end
function on_main_form_open(form)
  change_form_size()
  form.btn_start_mach.Text = nx_widestr("Start")
  updateButton(form)
  reload_form()
end
function on_main_form_close(form)
  nx_destroy(form)
end
function on_btn_close_click(btn)
  local form = nx_value(main_form)
  if not nx_is_valid(form) then
    return
  end
  on_main_form_close(form)
end
function change_form_size()
  local form = nx_value(main_form)
  if not nx_is_valid(form) then
    return
  end
  local gui = nx_value("gui")
  form.Left = 100
  form.Top = 140
end
function on_btn_start_click(btn)
  local form = btn.ParentForm
  if not nx_is_valid(form) then
    return
  end
  local arr = getJingMai()
  local arr2 = getJmai("machtancong")
  local aa = deepcompare(arr, arr2, true)
  if nx_running('auto_new\\auto_special_lib', "startRunJingmai") then
    nx_kill('auto_new\\auto_special_lib', "startRunJingmai")
  else
    nx_execute('auto_new\\auto_special_lib', "startRunJingmai")
  end
  updateButton(form)
end
function updateButton(form)
  if nx_running('auto_new\\auto_special_lib', "startRunJingmai") then
    form.btn_start_mach.Text = nx_widestr("Stop")
  else
    form.btn_start_mach.Text = nx_widestr("Start")
  end
end
function on_btn_savenoi_click(btn)
  local form = btn.ParentForm
  if not nx_is_valid(form) then
    return
  end
  saveJingmai("machtancong")
  reload_form()
end
function on_btn_savengoai_click(btn)
  local form = btn.ParentForm
  if not nx_is_valid(form) then
    return
  end
  saveJingmai("machphongthu")
  reload_form()
end
function reload_form()
  local form = nx_value(main_form)
  if not nx_is_valid(form) then
    return
  end
  local game_config = nx_value("game_config")
  local account = game_config.login_account
  local ini = nx_create("IniDocument")
  if not nx_is_valid(ini) then
    return
  end
  ini.FileName = account .. "\\Jingmai.ini"
  local jingmais_in = {}
  local jingmais_out = {}
  if ini:LoadFromFile() then
    for i = 1, 8 do
      local jm = ini:ReadString(nx_string("machtancong"), nx_string("mach" .. i), "")
      if jm ~= "" then
        table.insert(jingmais_in, jm)
      end
    end
    for i = 1, 8 do
      local jm = ini:ReadString(nx_string("machphongthu"), nx_string("mach" .. i), "")
      if jm ~= "" then
        table.insert(jingmais_out, jm)
      end
    end
  end
  nx_destroy(ini)
  if table.getn(jingmais_in) <= 0 then
    form.lbl_machnoi.Text = nx_function("ext_utf8_to_widestr", "   B\225\186\165m n\195\186t b\195\170n c\225\186\161nh \196\145\225\187\131 l\198\176u m\225\186\161ch")
  else
    form.lbl_machnoi.Text = nx_function("ext_utf8_to_widestr", "C\195\179 ") .. nx_widestr(table.getn(jingmais_in)) .. nx_function("ext_utf8_to_widestr", " m\225\186\161ch \196\145\198\176\225\187\163c k\195\173ch ho\225\186\161t")
    local text = nx_widestr("")
    for i = 1, table.getn(jingmais_in) do
      text = text .. nx_widestr("<s>- <font color=\"#5FD00B\">") .. util_text(nx_string(jingmais_in[i])) .. nx_widestr("</font><br>")
    end
    form.lbl_machnoi.HintText = text
  end
  if table.getn(jingmais_out) <= 0 then
    form.lbl_machngoai.Text = nx_function("ext_utf8_to_widestr", "  B\225\186\165m n\195\186t b\195\170n c\225\186\161nh \196\145\225\187\131 l\198\176u m\225\186\161ch")
  else
    form.lbl_machngoai.Text = nx_function("ext_utf8_to_widestr", "C\195\179 ") .. nx_widestr(table.getn(jingmais_out)) .. nx_function("ext_utf8_to_widestr", " m\225\186\161ch \196\145\198\176\225\187\163c k\195\173ch ho\225\186\161t")
    local text = nx_widestr("")
    for i = 1, table.getn(jingmais_out) do
      text = text .. nx_widestr("<s>- <font color=\"#5FD00B\">") .. util_text(nx_string(jingmais_out[i])) .. nx_widestr("</font><br>")
    end
    form.lbl_machngoai.HintText = text
  end
end
