local HELP_FORM = "admin_yBreaker\\yBreaker_form_main_help"

-- Form Help
function on_form_main_help_init(help_form)
	help_form.Fixed = false
	help_form.is_minimize = false
end


function on_main_form_help_open(help_form)
	change_form_size()
	help_form.is_minimize = false
end

--
function on_main_form_help_close(help_form)
	nx_destroy(help_form)
end

--
function change_form_size()
	local help_form = nx_value(HELP_FORM)
	if not nx_is_valid(help) then
		return
	end
	
	help_form.Left = 1155
	help_form.Top = 350
end

--
function on_btn_close_form_help(btn)
	local help_form = nx_value(HELP_FORM)
	if not nx_is_valid(help_form) then
		return
	end
	on_main_form_help_close(help_form)
end
	
