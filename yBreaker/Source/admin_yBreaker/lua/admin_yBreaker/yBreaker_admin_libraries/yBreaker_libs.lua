require("util_gui")
require("util_functions")
require("share\\server_custom_define")
require("define\\sysinfo_define")
require("share\\chat_define")
require("define\\request_type")

local inspect = require("admin_yBreaker\\yBreaker_admin_libraries\\inspect")

-- Function to show WideString Text all system
-- Use: yBreaker_show_WstrText(util_text("Text"))
function yBreaker_show_WstrText(info, noticetype)
	if noticetype == nil then
		noticetype = 3
	end
	nx_value("SystemCenterInfo"):ShowSystemCenterInfo(info, noticetype)
end

-- Function to show UTF-8 Text all system
-- Use: yBreaker_show_Utf8Text("Text")
-- Use: yBreaker_show_Utf8Text("Text" ..(variable))
function yBreaker_show_Utf8Text(info, noticetype)
    local info = nx_function("ext_utf8_to_widestr", info)
       if noticetype == nil then
           noticetype = 3
       end
       nx_value("SystemCenterInfo"):ShowSystemCenterInfo(info, noticetype)
end

-- Function to write log
function yBreaker_console(str, isdebug)
	local file = io.open("D:\\log_yBreaker.txt", "a")
	if file == nil then
		nx_value("SystemCenterInfo"):ShowSystemCenterInfo(nx_widestr("Can't open file D:\\log_yBreaker.txt, please check this file!"), 3)
	else
		file:write(inspect(str))
		if isdebug ~= nil then
			file:write("\n")
			file:write(inspect(getmetatable(str)))
			file:write("\n--------------------------------------")
		end
		file:write("\n")
		file:close()
	end
end

-- Function get buff exist on player for ..._spamskill.lua
function yBreaker_get_buff_id_info(buff_id)
	-- Nếu tồn tại buff_id thì trả về thời gian của buff đó, nếu buff không có thời gian thì trả về -1
	-- Nếu không tồn tại buff thì thả về nil
	local form = nx_value("form_stage_main\\form_main\\form_main_buff")
	if not nx_is_valid(form) then
		return nil
	end
	
	for i = 1, 24 do
		if nx_string(form["lbl_photo" .. tostring(i)].buffer_id) == buff_id then
			local buff_time = get_second_from_text(form["lbl_time" .. tostring(i)].Text)
			if buff_time == nil then
				return -1
			else
				return buff_time
			end
		end
	end
	return nil
end

-- Function timme for ..._fixitem.lua
function yBreaker_time_init()
    return os.clock()
end

function yBreaker_time_diff(t)
    if t == 0 or t == nil then
      return 999999
    end
    return os.clock() - t
end

-- Function find item index from bag for ..._fixitem.lua
function yBreaker_find_item_index_from_luggage(viewPort, configId)
    local client = nx_value("game_client")
    local view = client:GetView(nx_string(viewPort))
    if not nx_is_valid(view) then
        return 0
    end
    for i = 1, 100 do
        local obj = view:GetViewObj(nx_string(i))
        if nx_is_valid(obj) then
            if nx_string(obj:QueryProp("ConfigID")) == configId then
                return i
            end
        end
    end
    return 0
end

-- Function find item index from ItemBag for ..._fixitem.lua
function yBreaker_find_item_index_from_ItemBag(configId)
    return yBreaker_find_item_index_from_luggage(2, configId)
end

-- Function get powerlevel for search zither/herb
function yBreaker_get_powerlevel(powerlevel)
  local pl = nx_number(powerlevel)
  if pl < 6 then
    return "tips_title_0"
  elseif pl >= 151 then
    return "tips_title_151"
  elseif pl >= 136 then
    return "tips_title_136"
  elseif pl >= 121 then
    return "tips_title_121"
  end
  local s = powerlevel / 10
  local y = powerlevel % 10
  if y >= 6 then
    y = 6
  elseif y == 0 then
    s = s - 1
    y = 6
  else
    y = 1
  end
  return "tips_title_" .. nx_string(nx_int(s) * 10 + y)
end
