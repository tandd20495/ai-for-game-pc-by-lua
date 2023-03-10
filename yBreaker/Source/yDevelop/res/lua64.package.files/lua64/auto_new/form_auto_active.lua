require('auto_new\\autocack')
function main_form_init(form)
  form.Fixed = false
end
FORM_MAP_SCENE= 'form_stage_main\\form_map\\form_map_scene'

function on_main_form_open(form)
	
	
end
function on_main_form_close(form) 
	 nx_destroy(form)	
end
function on_btn_close_click(form)
	local form = nx_value('auto_new\\form_auto_active')
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end

function btn_add_start(btn)
	local form = btn.ParentForm
	local file = add_file('Active')		
	local lic_full = nx_string(form.edt_key_full.Text)
	local lic_ab = nx_string(form.edt_key_ab.Text)
	local account = nx_boolean(form.check_box_account_main.Checked)
	nx_execute('auto_new\\autocack','save_key_auto_cack',lic_full,lic_ab,account)
	-- if lic_ab ~= '' then
		-- writeIni(file,'key','lic_ab',lic_ab)
		-- showUtf8Text('Save Key AB Success')
		-- return
	-- end	
	-- writeIni(file,'key','lic_full',lic_full)
	-- nx_execute('auto_new\\autocack','auto_add_server3',nx_string(lic_full))		
	
end

