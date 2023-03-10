require('auto_new\\autocack')
function main_form_init(form)
  form.Fixed = false
end
function on_main_form_open(form)
 
end
function on_main_form_close(form) 
	 nx_destroy(form)	
end
function on_btn_close_click(form)   
  local form = nx_value("auto_new\\form_auto_main")
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
function on_auto_btn_smile_1_click(form)  
  util_auto_show_hide_form("auto_new\\form_auto_smile_1")
end
function on_auto_btn_smile_2_click(form)  
  util_auto_show_hide_form("auto_new\\form_auto_contact")
end
function on_auto_btn_support_click(form)  
	util_auto_show_hide_form("auto_new\\form_auto_support")
end
function on_auto_btn_pvp_click(form)  
	util_auto_show_hide_form("auto_new\\form_auto_all")
end
function on_auto_btn_cack_click(form)  
  util_auto_show_hide_form("auto_new\\form_auto_cack")
end
function on_auto_btn_ai_click(form)  
  util_auto_show_hide_form("auto_new\\form_auto_ai_new")
end
