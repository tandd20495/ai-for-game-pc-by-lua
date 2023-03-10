require('util_gui')
require("util_move")
require('define\\gamehand_type')
require('const_define')
require('auto_new\\autocack')
local THIS_FORM = 'auto_new\\form_auto_changelog'
      
function main_form_init(form)
  form.Fixed = false
  
end
function on_main_form_open(form)
  init_ui_content(form)
end
function init_ui_content(form)  
	change_form_size(form)
	nx_execute(nx_current(), "open_web_view", form)
end
function close_web_view()
  local form = util_get_form(THIS_FORM, false)
  if nx_is_valid(form) then
	form.web_autocack:Disable()
    form:Close()
  end
end
function show_playsnail_main_form()
  local form = util_get_form(THIS_FORM, false)
  if nx_is_valid(form) then
    form:Close()
    return 0
  end
  local form = util_get_form(THIS_FORM, true, false)
  if nx_is_valid(form) then
    util_show_form(THIS_FORM, true)
  end
end
function change_form_size(form)
  local form = util_get_form(THIS_FORM, false)
  if not nx_is_valid(form) then
    return 0
  end
  local gui = nx_value("gui")
  form.AbsLeft = (gui.Desktop.Width - form.Width) / 2
  form.AbsTop = (gui.Desktop.Height - form.Height) / 2
end
function open_web_view(form)
  local strMsg = "https://autocack.net/"
  form.web_autocack:Refresh()
  form.web_autocack:NavigatePost(nx_widestr(strMsg), nx_widestr(""))
  --form.lbl_2.Text = nx_execute("playsnail\\playsnail_common", "GetCfgItem", "playsnail", "Domain")
end
function on_btn_close_click(form)
	local form = nx_value(THIS_FORM)
	close_web_view()
end
function on_main_form_close(form)	
	close_web_view()
end


