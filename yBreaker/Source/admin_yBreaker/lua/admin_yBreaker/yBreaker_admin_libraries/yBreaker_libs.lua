require("util_gui")
require("util_functions")
require("share\\server_custom_define")
require("define\\sysinfo_define")
require("share\\chat_define")
require("define\\request_type")

local inspect = require("admin_yBreaker\\yBreaker_admin_libraries\\inspect")

-- Function to show WideString Text all system
function yBreaker_show_WstrText(info, noticetype)
	if noticetype == nil then
		noticetype = 3
	end
	nx_value("SystemCenterInfo"):ShowSystemCenterInfo(info, noticetype)
end

-- Function to show UTF-8 Text in .lua
function yBreaker_show_Utf8Text(str, mode)
	if not str then return end
	local SystemCenterInfo = nx_value('SystemCenterInfo')
	if nx_is_valid(SystemCenterInfo) then
		if not mode then mode = 3 end
		SystemCenterInfo:ShowSystemCenterInfo(utf8ToWstr(str), mode)
	end
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

-- Function timmer for ..._fixitem.lua
function TimerInit()
    return os.clock()
end

function TimerDiff(t)
    if t == 0 or t == nil then
      return 999999
    end
    return os.clock() - t
end

-- Function find item index from bag for ..._fixitem.lua
function find_item_index_from_bag(viewPort, configId)
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

-- Function find item index from VatPham for ..._fixitem.lua
function find_item_index_from_VatPham(configId)
    return find_item_index_from_bag(2, configId)
end