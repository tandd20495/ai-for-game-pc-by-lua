require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")

local THIS_FORM = "admin_yBreaker\\yBreaker_form_password"

function on_form_main_init(form)
    form.Fixed = false
    form.is_minimize = false
	
	form.select_edit = nil
	form.open_upper = false
	form.soft_edit = nil

end

function on_main_form_open(form)
    change_form_size()
    form.is_minimize = false
	Load_PR(form)
	
end

function on_main_form_close(form)
    nx_destroy(form)
end

function on_btn_close_click(btn)
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return
    end
    on_main_form_close(form)
end

function change_form_size()
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return
    end
    local gui = nx_value("gui")
    form.Left = 100
    form.Top = 140
end

function show_hide_form_bugs()
	util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_password")
end


function on_encode_btn_click(btn)
	local form = btn.ParentForm
	local word_text = form.ipt_pw2_string.Text
	if not check_second_word(word_text) then
		return
	end
	local word_text = nx_string(form.ipt_pw2_string.Text)
	local enc_d = yBreaker_enc_o_d_e(word_text)
	form.ipt_pw2_encrypt.Text = (nx_widestr(enc_d))
	form.ipt_pw2_string.Text = ""
end
function on_save_btn_click(btn)
	local form = btn.ParentForm
	local enc_d = form.ipt_pw2_encrypt.Text
	Save_PR(form)
	local game_config = nx_value("game_config")
	local account = game_config.login_account
	yBreaker_send_notice_dialog("Mật khẩu mã hóa " .. nx_string(enc_d) .. " đã được lưu vào thư mục Cửu Âm .../bin/yBreaker_" .. account .. "/Password.ini để sử dụng cho những lần đăng nhập sau.")
end
function Save_PR(form)
	local ini = nx_create("IniDocument")
	local file = Get_Auto_ConfigDir("Password")
  	ini.FileName = file
	ini:WriteString("Pw2", "Pw2_Encrytped", nx_string(form.ipt_pw2_encrypt.Text))
	ini:SaveToFile()
	nx_destroy(ini)
end
function Load_PR(form)
	local ini = nx_create("IniDocument")
	local file = Get_Auto_ConfigDir("Password")
  	ini.FileName = file
  	if not ini:LoadFromFile() then
  		return
  	end
	form.ipt_pw2_encrypt.Text = nx_widestr(ini:ReadString("Pw2", "Pw2_Encrytped", ""))
end

function check_second_word(word_text)
  if nx_string(word_text) == "" then
    local gui = nx_value("gui")
    local text_info = gui.TextManager:GetText("24014")
    show_confirm(text_info)
    return false
  end
  return true
end

function on_pw2_string_get_focus(btn)
  local form = btn.ParentForm
  form.select_edit = btn
  form.soft_edit = btn
  if nx_function("ext_check_open_upper") then
    form.open_upper = true
    open_upper_deal(form)
  else
    close_upper_deal(form)
  end
end

function on_pw2_string_lost_focus(btn)
  local form = btn.ParentForm
  form.select_edit = nil
  close_upper_deal(form)
end
function on_pw2_string_changed(btn)
  local form = btn.ParentForm
  if not nx_is_valid(form) then
    return
  end
  if form.open_upper == false then
    if nx_function("ext_check_open_upper") then
      form.open_upper = true
      open_upper_deal(form)
    end
  elseif not nx_function("ext_check_open_upper") then
    form.open_upper = false
    close_upper_deal(form)
  end
end

function open_upper_deal(form)
  if not nx_is_valid(form) then
    return
  end
  if form.select_edit == nil then
    return
  end
  form.lbl_notice.Visible = true
  form.lbl_notice.Top = form.select_edit.Top + form.select_edit.Height
  form.lbl_notice.Left = form.select_edit.Left
end
function close_upper_deal(form)
  if not nx_is_valid(form) then
    return
  end
  form.lbl_notice.Visible = false
end
