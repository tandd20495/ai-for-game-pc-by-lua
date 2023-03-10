require("util_gui")
require("util_move")
require("util_functions")
require("auto\\lib")
local count = 0
local chat_history = {}
local THIS_FORM = "auto\\rao"
function AutoSetStatus(status)
	local form = util_get_form(THIS_FORM, true)
	if form.auto_start then 
		form.btn_ok.Text = nx_function("ext_utf8_to_widestr", "Rao")
		form.auto_start = false
		return
	else 
		form.btn_ok.Text = nx_function("ext_utf8_to_widestr", "Kết thúc")
		form.auto_start = true
	end
end
function AddChatStr( str )
	local form = util_get_form(THIS_FORM, true)
	local form_chat = nx_value("form_main_chat")
	local count = table.getn(chat_history)
	if nx_is_valid(form) then
		chat_history[count + 1] = str
		form.combobox_tab_2.DropListBox:AddString(str)
	end
end
function AutoRao(form)
	

    if form.auto_start then AutoSetStatus(false) else AutoSetStatus(true) end

    while form.auto_start do
    	local _select = form.choosetype
    	local gan = form.check_box_1.Checked
	    local map = form.check_box_2.Checked
	    local school = form.check_box_3.Checked
	    local guild = form.check_box_4.Checked
	    local newschool = form.check_box_5.Checked
	    local delay = nx_number(form.tab_3_input.Text)

    	if _select == 0 then
	    	AutoSendMessage("Vui lòng chat ở khung chat sau đó chọn dòng chat bạn muốn rao")
	    	AutoSetStatus(false)
	    	return
	    end
    	nx_pause(1)
    	count = count + 1
    	if count >= delay then
    		count = 0
    		if gan then 
    			nx_execute("custom_sender", "custom_chat", 1, chat_history[_select])
	        end
	        if map then 
	        	nx_execute("custom_sender", "custom_chat", 2, chat_history[_select])
	        end
	        if school then 
	        	nx_execute("custom_sender", "custom_chat", 8, chat_history[_select])
	        end
	        if guild then 
	        	nx_execute("custom_sender", "custom_chat", 6, chat_history[_select])
	        end
	        if newschool then 
	        	nx_execute("custom_sender", "custom_chat", 32, chat_history[_select])
	        end
	        if newschool then 
	        	nx_execute("custom_sender", "custom_chat", 39, chat_history[_select])
	        end
	        if newschool then 
	        	nx_execute("custom_sender", "custom_chat", 33, chat_history[_select])
	        end
	        if newschool then 
	        	nx_execute("custom_sender", "custom_chat", 34, chat_history[_select])
	        end
	        if newschool then 
	        	nx_execute("custom_sender", "custom_chat", 36, chat_history[_select])
	        end
	        if newschool then 
	        	nx_execute("custom_sender", "custom_chat", 37, chat_history[_select])
	        end
	        if newschool then 
	        	nx_execute("custom_sender", "custom_chat", 38, chat_history[_select])
	        end
    	end
    end
end
function on_rao_init( self )
	self.Fixed = false
	self.auto_start = false
	self.choosetype = 0
end
function on_rao_open( self )
	local form_chat = nx_value("form_main_chat")

	self.combobox_tab_2.DropListBox:ClearString()
	for k = 1, table.getn(chat_history) do
		self.combobox_tab_2.DropListBox:AddString(chat_history[k])
	end
end
function on_btn_ok_click( btn )
	local form = btn.ParentForm
	AutoRao(form)
end
function on_rao_close( self )
	-- body
end
function on_combobox_2_selected( combobox )
	local form = combobox.ParentForm
	local k = combobox.DropListBox.SelectIndex + 1
	form.choosetype = k
	form.tab_mltbox_1.HtmlText = nx_widestr(chat_history[k])
end
function FormClose( self )
	util_auto_show_hide_form(THIS_FORM)
end