require('util_gui')
require("util_move")
require('define\\gamehand_type')
require('const_define')
require('auto_new\\autocack')
local THIS_FORM = 'auto_new\\form_auto_contact'
function main_form_init(form)
  form.Fixed = false
  
end
function on_main_form_open(form)
  init_ui_content(form)
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
auto_check_version = function()	
	local str = "https://autocack.net/config/version_update.php"
	nx_set_value("nockasdd_autocack_url_ver", str)
	local url = nx_value("nockasdd_autocack_url_ver")
	local httpclient = nx_create("GenericHTTPClient")
	if nil ~= url and "" ~= url and nx_is_valid(httpclient) then
		httpclient:Request(url, 1, "MERONG(0.9/;p)")
		nx_set_value("nockasdd_autocack_url_ver", nil)
	end
	local content = httpclient:QueryHTTPResponse()
	local split = auto_split_string(content,';')
	if nx_string(nx_execute('auto_new\\autocack','get_version_auto')) == nx_string(split[1]) then
		showUtf8Text(AUTO_VERSION_LOG,3)			
	else			
		showUtf8Text(AUTO_VERSION_LOG_NOT_VER..nx_string(nx_execute('auto_new\\autocack','get_version_auto'))..'/'..nx_string(split[1]),3)
		local inifile = add_file_user('auto_ai')
		local show_update = wstrToUtf8(readIni(inifile,'Setting','not_show_update',''))
		if show_update == '0' or show_update == nil or not show_update then 
			show_update = nx_string('true') 
		end
		if show_update == nx_string('false') then
			util_show_form('auto_new\\form_auto_update',true)
		end
	end
	local msg = split[2]
	if nx_string(msg) == '' or msg == nil then
		msg = ""
	end
	showUtf8Text(nx_string(msg),2)
end	
function btn_check_version(btn)
	auto_check_version() 
end
function btn_contact_fb(btn)
	local url = "https://www.facebook.com/autocacknew"
	nx_function("ext_open_url", url)
end
function btn_check_update(btn)
	util_show_form('auto_new\\form_auto_update',true)
end
function btn_download_auto(btn)
	local str = "https://autocack.net/config/download.php"
	nx_set_value("nockasdd_autocack_url_download", str)
	local url = nx_value("nockasdd_autocack_url_download")
	local httpclient = nx_create("GenericHTTPClient")
	if nil ~= url and "" ~= url and nx_is_valid(httpclient) then
		httpclient:Request(url, 1, "MERONG(0.9/;p)")
		nx_set_value("nockasdd_autocack_url_download", nil)
	end
	local content = httpclient:QueryHTTPResponse()
	nx_function("ext_open_url", content)
end
btn_update_auto = function(btn)	
	local str = "https://autocack.net/config/version_update.php"
	nx_set_value("nockasdd_autocack_url_version_base", str)
	local url = nx_value("nockasdd_autocack_url_version_base")
	local httpclient = nx_create("GenericHTTPClient")
	if nil ~= url and "" ~= url and nx_is_valid(httpclient) then
		httpclient:Request(url, 1, "MERONG(0.9/;p)")
		nx_set_value("nockasdd_autocack_url_download", nil)
	end
	showUtf8Text('Tạm dừng hoạt động dữ liệu đang chạy')
	nx_execute('auto_new\\autocack','set_auto_cack_load')
	nx_pause(1)	
	if not os.remove(nx_work_path()..'auto_cack.dll') then
		nx_function('ext_move_file',nx_work_path()..'auto_cack.dll',nx_script_path()..'auto_cack.dll')
	end
	if nx_function("ext_is_file_exist", nx_script_path()..'auto_cack.dll') then		
		os.remove(nx_script_path()..'auto_cack.dll')
	end
	nx_pause(1)		
	showUtf8Text('Bắt đầu tải auto')
	local content = httpclient:QueryHTTPResponse()		
	if nx_string(content) ~= nx_string(get_version_auto()) then
		local file_download = nx_work_path()..'auto_cack.dll'
		local command = "curl https://autocack.net/config/auto_cack.dll" .. " -o \"" .. file_download .. "\" --ssl-no-revoke -L -O"		
		nx_function("ext_win_exec", command)
		nx_pause(2)
		if nx_function("ext_is_file_exist", file_download) then		
			nx_execute('auto_new\\autocack','auto_cack','0')
		end
	end
	nx_pause(2)
	if nx_string(content) == nx_string(get_version_auto()) then
		showUtf8Text('Đã hoàn tất update')
	end
end
