require("util_gui")
require("define\\gamehand_type")
require("const_define")
require('auto_new\\autocack')
if not load_auto_traning then
auto_cack('0')
auto_cack('2')
auto_cack('11')
load_auto_traning = true
end
function main_form_init(form)

    form.Fixed = false	
end
function on_main_form_open(form)
  init_ui_content(form)
end
function show_hide_form()
  util_auto_show_hide_form("auto_new\\form_auto_smile_1")
end
function init_ui_content(form)
	
end
function on_btn_close_click(form)
local form = nx_value("auto_new\\form_auto_smile_1")
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
function on_main_form_close(form)	
	nx_destroy(form)
end
function btn_start_1(btn)
	local form = btn.ParentForm	
	local form_shop = nx_value("form_stage_main\\form_shop\\form_shop")
    if nx_is_valid(form_shop) then
		nx_execute("custom_sender", "custom_open_mount_shop", 0)
    else
		nx_execute("custom_sender", "custom_open_mount_shop", 1)
    end
end
function btn_start_2(btn)
	local form = btn.ParentForm
	nx_execute('auto_new\\autocack','util__auto_show_form',"auto_new\\form_auto_music")
end
function btn_start_3(btn)
	local form = btn.ParentForm
	nx_execute('auto_new\\autocack','util__auto_show_form',"auto_new\\form_auto_item")
	
end
function btn_start_4(btn)
	nx_execute('auto_new\\autocack','util__auto_show_form',"auto_new\\form_auto_lookup")
		
end
function btn_start_5(btn)
	local form = btn.ParentForm
	nx_execute('auto_new\\autocack','util__auto_show_form',"auto_new\\form_auto_chat")
	
end
function btn_start_6(btn)
	local form = btn.ParentForm
	nx_execute('auto_new\\autocack','util__auto_show_form',"auto_new\\form_auto_b")	
end
function btn_start_7(btn)
	local form = btn.ParentForm
	nx_execute('auto_new\\autocack','nx_autoexecute','auto_new\\autocack','auto_oakhau')

end
function btn_start_8(btn)
	local form = btn.ParentForm	
	nx_execute('auto_new\\autocack','util__auto_show_form','auto_new\\form_auto_info')
end
function btn_start_9(btn)
	local form = btn.ParentForm
	nx_execute('auto_new\\autocack','util__auto_show_form','auto_new\\form_auto_buymarket')
	
end
function btn_start_10(btn)
	local form = btn.ParentForm
	nx_execute('auto_new\\autocack','util__auto_show_form','auto_new\\form_auto_spendmoney')
end
function btn_start_11(btn)
	local form = btn.ParentForm
	nx_execute('auto_new\\autocack','util__auto_show_form','auto_new\\form_auto_qvcd')
end

function btn_start_12(btn)
	local form = btn.ParentForm
	nx_execute('auto_new\\autocack','util__auto_show_form','auto_new\\form_auto_nmq')
end
function btn_start_13(btn)
	nx_execute('auto_new\\autocack','util__auto_show_form','auto_new\\form_auto_shopping')
end
-- function btn_start_14(btn)
	-- nx_execute('auto_new\\autocack','util__auto_show_form',"auto_tools\\tools_homepoint")	

-- end
-- function btn_start_15(btn)
	-- nx_execute('auto_new\\autocack','util__auto_show_form',"autobug")	
-- end








