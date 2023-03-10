require('auto_new\\autocack')
function main_form_init(form)
  form.Fixed = false
end
function on_main_form_open(form)
	update_btn_start_swap(form)
	update_btn_start_fix_item(form) 
	update_btn_start_blink(form)
	update_btn_start_faculty(form)
	--update_btn_start_tartet(form)	
end
function on_main_form_close(form) 
	 nx_destroy(form)	
end
function on_btn_close_click(form)
	local form = nx_value('auto_new\\form_auto_run_func')
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
function on_btn_start_swap_click(btn)
	local form = btn.ParentForm	
	if nx_running('auto_new\\auto_script','swapauto') then
		nx_execute('auto_new\\auto_script','setAutoSwapState',false)
		nx_kill('auto_new\\auto_script','swapauto')
	else
		nx_execute('auto_new\\auto_script','setAutoSwapState',true)
		nx_execute('auto_new\\auto_script','swapauto')
	end
	update_btn_start_swap(form)	
end
function on_btn_start_fix_item_click(btn)
	local form = btn.ParentForm	
	if nx_running('auto_new\\auto_script','autoSuaDo') then
		nx_execute('auto_new\\auto_script','setAutoFixState',false)
		showUtf8Text("Stop "..AUTO_LOG_FIX_ITEM, 3)
		nx_kill('auto_new\\auto_script','autoSuaDo')
	else
		showUtf8Text("Start "..AUTO_LOG_FIX_ITEM, 3)
		nx_execute('auto_new\\auto_script','setAutoFixState',true)
		nx_execute('auto_new\\auto_script','autoSuaDo')
	end
	update_btn_start_fix_item(form)

end
function on_btn_start_blink_click(btn)
	local form = btn.ParentForm	
	if nx_running('auto_new\\auto_script','blinkMapAuto') then
		run = false
		showUtf8Text(END_BLINK, 3)
		nx_kill('auto_new\\auto_script','blinkMapAuto')
	else
		nx_execute('auto_new\\auto_script','blinkMapAuto')
	end
	update_btn_start_blink(form)

end
function on_btn_start_faculty_click(btn)
	local form = btn.ParentForm	
	if nx_running('autobufffaculty','autoBufferFaculy') then
		thuoc = false
		--showUtf8Text("Stop Cắn nội tu", 3)
		nx_kill('autobufffaculty','autoBufferFaculy')
	else
		nx_execute('autobufffaculty','autoBufferFaculy')
	end
	update_btn_start_faculty(form)

end
function on_btn_start_tartet_click(btn)
	local form = btn.ParentForm	
	nx_execute('auto_new\\auto_script',"suicidePlayer",true)	
end
update_btn_start_swap = function(form)
	if not nx_is_valid(form) then		
		return
	end
	if nx_running('auto_new\\auto_script','swapauto') then
		form.btn_start_swap.Text = nx_widestr("Stop")
	else
		form.btn_start_swap.Text = nx_widestr("Start")
	end
end
update_btn_start_fix_item = function(form)
	if not nx_is_valid(form) then		
		return
	end
	if nx_running('auto_new\\auto_script','autoSuaDo') then
		form.btn_start_fix_item.Text = nx_widestr("Stop")
	else
		form.btn_start_fix_item.Text = nx_widestr("Start")
	end
end
update_btn_start_blink = function(form)
	if not nx_is_valid(form) then		
		return
	end
	if nx_running('auto_new\\auto_script','blinkMapAuto') then
		form.btn_start_blink.Text = nx_widestr("Stop")
	else
		form.btn_start_blink.Text = nx_widestr("Start")
	end
end
update_btn_start_faculty = function(form)
	if not nx_is_valid(form) then		
		return
	end
	if nx_running('autobufffaculty','autoBufferFaculy') then
		form.btn_start_faculty.Text = nx_widestr("Stop")
	else
		form.btn_start_faculty.Text = nx_widestr("Start")
	end
end
update_btn_start_tartet = function(form)
	if not nx_is_valid(form) then		
		return
	end
	if nx_running('auto_oakhau','auto_target') then
		form.btn_start_tartet.Text = nx_widestr("Stop")
	else
		form.btn_start_tartet.Text = nx_widestr("Start")
	end
end