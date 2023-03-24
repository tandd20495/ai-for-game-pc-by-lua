function show_head_message(msg, delay)
  local head_game = nx_value("HeadGame")
  if nx_is_valid(head_game) then
    head_game:ShowChatTextOnHead(getPlayer(),  nx_widestr(nx_function("ext_utf8_to_widestr", msg)), delay)
  end
end

function SendNotice(str, type)
  local SystemCenterInfo = nx_value("SystemCenterInfo")
  if type == nil then
		type = 3
	end
  SystemCenterInfo:ShowSystemCenterInfo(nx_function("ext_utf8_to_widestr", nx_string(str)), type)
end

function add_chat_info(info)
	local form_main_chat_logic = nx_value("form_main_chat")
	if nx_is_valid(form_main_chat_logic) then
		local format_text = "<font color='#FFFF33'>{@0:name}</font>"
		local formatted_text = nx_value("gui").TextManager:GetFormatText(format_text, nx_function("ext_utf8_to_widestr", nx_string(info)))
		form_main_chat_logic:AddChatInfoEx(formatted_text, CHATTYPE_SYSTEM, false)
	end
end

function add_chat_info_raw(info)
	local form_main_chat_logic = nx_value("form_main_chat")
	form_main_chat_logic:AddChatInfoEx(info, CHATTYPE_SYSTEM, false)
end

function text(id)
  local f = nx_value("gui")
  if nx_is_valid(f) then
	  return f.TextManager:GetText(id)
  else
    return ""
  end
end