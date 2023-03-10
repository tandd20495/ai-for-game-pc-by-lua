require('auto_new\\autocack')

local color_selected = "255,0,165,35"
local color_noselected = "255,255,255,255"
local PAGENUM_GAP = 2
local NAVIGATOR_GAP = 6
local array_auto_recode_list = nil
function main_form_init(form)
	form.Fixed = false
	form.curTargetName = AUTO_CACK
	form.nPageRecordNum = 20
	form.nMaxRecordNum = 0
	form.curPageNum = 1
	form.nMaxPageNum = 0
	form.nMaxNavNum = 9
	array_auto_recode_list = nx_create("ArrayList")
	array_auto_recode_list.Name = "auto_record"
end
function get_auto_record_doc()
	return create_auto_record_doc()
end
function main_form_open(form)
	change_form_size()
	Show_Navigator_Button(form, false)
end
function on_main_form_close(form)
	if nx_is_valid(array_auto_recode_list) then
		array_auto_recode_list:ClearChild()
		nx_destroy(array_auto_recode_list)
	end
	nx_destroy(form)
end
function on_btn_close_click(btn)
	local form = btn.ParentForm
	form:Close()
end
function on_btn_front_click(btn)
	local form = btn.ParentForm
	SwitchToPage(form, 1)
end
function on_btn_end_click(btn)
	local form = btn.ParentForm
	SwitchToPage(form, form.nMaxPageNum)
end
function on_btn_prev_click(btn)
	local form = btn.ParentForm
	if nx_int(form.curPageNum) <= nx_int(1) then
		form.curPageNum = 1
	else
		form.curPageNum = form.curPageNum - 1
	end
	SwitchToPage(form, form.curPageNum)
end
function on_btn_next_click(btn)
	local form = btn.ParentForm
	if nx_int(form.curPageNum) >= nx_int(form.nMaxPageNum) then
		form.curPageNum = form.nMaxPageNum
	else
		form.curPageNum = form.curPageNum + 1
	end
	SwitchToPage(form, form.curPageNum)
end
function on_btn_clearrec_click(btn)
	local form = btn.ParentForm
	local xml_doc = get_auto_record_doc()
	delete_auto_record(xml_doc, form.curTargetName)
	Init_Form(form, form.curTargetName)
end
function on_page_click(btn)
	local form = btn.ParentForm
	local cur_page = nx_int(btn.Text)
	SwitchToPage(form, cur_page)
end
function Init_Form(target_name)
	local form = nx_execute("util_gui", "util_get_form", "auto_new\\form_auto_news", true, false, 1)
    form.Visible = true
    form:Show()
	form.curTargetName = target_name
	LoadAutoRecord(form)
	SwitchToPage(form, form.nMaxPageNum)
end
function LoadAutoRecord(form)
	array_auto_recode_list:ClearChild()
	local xml_doc = get_auto_record_doc()
	local record = get_auto_record(xml_doc, form.curTargetName)
	for i = 1, table.getn(record) do
		local child = record[i]
		local Record_Item = array_auto_recode_list:CreateChild("")
		Record_Item.name = child.name
		Record_Item.content = child.content
		Record_Item.chat_time = child.time
	end
	form.nMaxRecordNum = nx_int(array_auto_recode_list:GetChildCount())
	form.nMaxPageNum = nx_int((form.nMaxRecordNum + form.nPageRecordNum - 1) / form.nPageRecordNum)
end

function AddContentToList(form, sender_name, chat_content, chat_time)
	local gui = nx_value("gui")
	local textchat = nx_value("gui").TextManager:GetFormatText(nx_string('Auto: <font color=\"#b30059\">[ {@0:text} ]</font><br>Time:  <font color=\"#8600b3\">[ {@1:text} ]</font> <br><font color=\"#0000b3\">{@2:text}</font>'), nx_widestr(sender_name), nx_widestr(chat_time), nx_widestr(chat_content))
	local info = nx_widestr(gui.TextManager:GetFormatText("gcw_chat_refuse_message", sender_name, chat_time, chat_content))
	local mltbox_list = form.mltbox_list
	if nx_is_valid(mltbox_list) then
		mltbox_list:AddHtmlText(textchat, -1)
		mltbox_list.VScrollBar.Value = mltbox_list.VScrollBar.Maximum
	end
end

function SwitchToPage(form, index)
	form.nMaxRecordNum = nx_int(array_auto_recode_list:GetChildCount())
	form.nMaxPageNum = nx_int((form.nMaxRecordNum + form.nPageRecordNum - 1) / form.nPageRecordNum)
	form.mltbox_list.HtmlText = ""
	if nx_int(index) < nx_int(1) or nx_int(index) > nx_int(form.nMaxPageNum) then
		Show_Navigator_Button(form, false)
		ClearAllNavigator(form)
		return
	end
	form.curPageNum = nx_int(index)
	local begin_index = (index - 1) * form.nPageRecordNum
	local end_index = begin_index + form.nPageRecordNum
	if not (end_index < form.nMaxRecordNum) or not end_index then
		end_index = form.nMaxRecordNum
	end		
	for i = begin_index, end_index - 1 do
		local child = array_auto_recode_list:GetChildByIndex(i)
		AddContentToList(form, child.name, child.content, child.chat_time)
	end
	Refresh_Navigator(form, form.curPageNum, form.nMaxPageNum)
end

function Refresh_Navigator(form, cur_page, page_num)
	local nav_num = 0
	local nav_first = 0
	if nx_int(page_num) <= nx_int(form.nMaxNavNum) then
		nav_num = page_num
		nav_first = 1
	else
		nav_num = form.nMaxNavNum
		local flag = nx_int(form.nMaxNavNum / 2)
		if cur_page - flag <= 1 then
			nav_first = 1
		elseif page_num >= cur_page + flag then
			nav_first = cur_page - flag
		else
			nav_first = page_num - form.nMaxNavNum + 1
		end
	end
	local ctrl_width = form.btn_front.Width
	local ctrl_height = form.btn_front.Height
	local begin_width = ctrl_width * 2 + NAVIGATOR_GAP + 2 * NAVIGATOR_GAP
	local end_width = ctrl_width * 2 + NAVIGATOR_GAP + 2 * NAVIGATOR_GAP
	local middle_width = ctrl_width * nav_num + (nav_num - 1) * PAGENUM_GAP
	local begin_xpos = (form.groupbox_nav.Width - (begin_width + middle_width + end_width)) / 2
	local begin_ypos = 6
	form.btn_front.Left = begin_xpos
	form.btn_front.Top = begin_ypos
	form.btn_prev.Left = begin_xpos + ctrl_width + NAVIGATOR_GAP
	form.btn_prev.Top = begin_ypos
	ClearAllNavigator(form)
	local curMaxNav = nav_first + nav_num - 1
	for i = nav_first, curMaxNav do
		local btn = GetNewPagePot(nx_string(i), ctrl_width, ctrl_height)
		btn.Left = begin_xpos + begin_width + (ctrl_width + PAGENUM_GAP) * (i - nav_first)
		btn.Top = begin_ypos
		if nx_int(cur_page) == nx_int(i) then
			btn.ForeColor = color_selected
		else
			btn.ForeColor = color_noselected
		end
		form.groupbox_nav:Add(btn)
	end
	form.btn_next.Left = begin_xpos + begin_width + middle_width + 2 * NAVIGATOR_GAP
	form.btn_next.Top = begin_ypos
	form.btn_end.Left = begin_xpos + begin_width + middle_width + 2 * NAVIGATOR_GAP + ctrl_width + NAVIGATOR_GAP
	form.btn_end.Top = begin_ypos
	Show_Navigator_Button(form, page_num > 0)
end
function ClearAllNavigator(form)
	local gui = nx_value("gui")
	local child_table = form.groupbox_nav:GetChildControlList()
	for i = 1, table.getn(child_table) do
		local child = child_table[i]
		if nx_is_valid(child) and nx_find_custom(child, "page_num") then
			form.groupbox_nav:Remove(child)
			gui:Delete(child)
		end
	end
end
function GetNewPagePot(text, width, height)
	local gui = nx_value("gui")
	local btn = gui:Create("Button")
	if not nx_is_valid(btn) then
		return nil
	end
	btn.Text = nx_widestr(text)
	btn.Font = "font_tip"
	btn.Width = width
	btn.Height = height
	btn.BackColor = "0,192,192,192"
	btn.LineColor = "0,0,0,0"
	btn.page_num = nx_string(text)
	nx_bind_script(btn, nx_current())
	nx_callback(btn, "on_click", "on_page_click")
	return btn
end
function Show_Navigator_Button(form, bShow)
	form.btn_front.Visible = bShow
	form.btn_end.Visible = bShow
	form.btn_prev.Visible = bShow
	form.btn_next.Visible = bShow
end
function change_form_size()
	local form = nx_value("auto_new\\form_auto_news")
	if not nx_is_valid(form) then
		return
	end
	local gui = nx_value("gui")
end
----------------------------
