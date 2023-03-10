require("util_gui")
require("util_functions")
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
  local form = nx_value("auto_new\\form_auto_encrypt")
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
function btn_save_pass(btn)
	local form = btn.ParentForm
	local pass = nx_string(form.edt_password_encrypt_2.Text)
	nx_execute('auto_new\\autocack','save_record_pass_1',pass)
end
function btn_save_pass_2(btn)
	nx_execute('auto_new\\autocack','save_record_pass_2')
end
function btn_encrypt(btn)
	local form = btn.ParentForm
	local pass_2 = form.edt_password.Text
	if not pass_2 or pass_2 == '' then 
		showUtf8Text(AUTO_LOG_COPY_PASS, 3)
		return
	end
	local ret = nx_execute('auto_new\\autocack', 'get_enc_pass', wstrToUtf8(pass_2))
	if ret == nil then 
		showUtf8Text(AUTO_LOG_NOT_ENCRYPT, 3)
		return
	else
		 form.edt_password_encrypt.Text = utf8ToWstr(ret)
		 form.edt_password.Text = ""
	end
end
function btn_encrypt_2(btn)
	local form = btn.ParentForm
	local pass_2 = form.edt_password_2.Text
	if not pass_2 or pass_2 == '' then 
		showUtf8Text(AUTO_LOG_COPY_PASS, 3)
		return
	end
	local ret = nx_execute('auto_new\\autocack', 'get_enc_pass', wstrToUtf8(pass_2))
	if ret == nil then 
		showUtf8Text(AUTO_LOG_NOT_ENCRYPT, 3)
		return
	else
		 form.edt_password_encrypt_2.Text = utf8ToWstr(ret)
		 form.edt_password_2.Text = ""
	end
end