require("util_gui")
require("define\\gamehand_type")
require("const_define")
require("auto_new\\autocack")
if not load_spec_party then
	auto_cack('0')
	auto_cack('2')
	auto_cack('6')
	auto_cack('14')
	load_spec_party = true
end
local THIS_FORM = "auto_new\\auto_party"
function main_form_init(form)
  form.Fixed = false
end
function on_main_form_open(form)
  init_ui_content(form)
end
FORM_MAIN_REQUEST = "form_stage_main\\form_main\\form_main_request"
function on_btn_start_click(form)
  local btn = form.ParentForm
  local form_search = util_get_form(THIS_FORM, true, false)
  local nameaccount = form_search.edt_name_player.Text
  local nameuft = wstrToUtf8(nameaccount)
  partyBug(nameuft)
end
function init_ui_content(form)
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
