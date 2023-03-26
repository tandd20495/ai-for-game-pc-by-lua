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

-- Function convert UTF-8 to WideString
function yBreaker_Utf8_to_Wstr(content)
	return nx_function("ext_utf8_to_widestr", content)
end

-- Function convert WideString to UTF-8
function yBreaker_Wstr_to_Utf8(content)
	return nx_function("ext_widestr_to_utf8", content)
end

-- Function define command to execute function
function yBreaker_command_chat(str_chat)
	local command = nx_string(str_chat)
	-- Split string for /code
	local split_str = util_split_string(nx_string(str_chat), " ") -- " " là khoảng trắng để tách chuỗi chat
	
	if (command == "/yt") or (command == "/YT") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_main") 
		return true
	end
	
	if (command == "/pvc") or (command == "/PVC") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_modpvc") 
		return true	
	end
	
	if (command == "/debug") or (command == "/DEBUG") then
		nx_execute("admin_yBreaker\\yBreaker_scripts_func\\yBreaker_scripts_debugtest","show_hide_form_debug_test_yBreaker")
		return true
	end	
	
	-- Function split string chat to run script is define at yBreaker\scripts folder
	if (split_str[1] == "/code") or (split_str[1] == "/CODE") then
		if split_str[2] == "" then
			yBreaker_show_Utf8Text("Nhập thêm tên file để chạy lệnh này. Ví dụ: /code filename")
		else
			local file = assert(loadfile(nx_resource_path() .. "yBreaker\\scripts\\" .. split_str[2] .. ".lua"))
			file()
		end
		return true
	end
	
	if (command == "/codenew") or (command == "/CODENEW") then
		nx_execute("admin_yBreaker\\yBreaker_scripts_func\\yBreaker_scripts_codenew","new_function_admin_yBreaker")
		return true
	end
	
	if (command == "/pvp") or (command == "/PVP") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_pvp") 
		return true
	end
	
	if (command == "/bugs") or (command == "/BUGS") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_bugs") 
		return true
	end
	
	if (command == "/tele") or (command == "/TELE") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_teleport") 
		return true
	end
	
	if (command == "/dan") or (command == "/DAN") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_zither") 
		return true
	end
	
	if (command == "/config") or (command == "/CONFIG") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_config") 
		return true
	end
	
	if (command == "/shop") or (command == "/SHOP") then
		nx_execute("admin_yBreaker\\yBreaker_scripts_func\\yBreaker_scripts_grocery","show_hide_grocery")
		return true
	end
	
	if (command == "/fix") or (command == "/FIX") then
		nx_execute("admin_yBreaker\\yBreaker_scripts_func\\yBreaker_scripts_fixitems","fix_equipped_items_durability")
		return true
	end
	
	if (command == "/chat") or (command == "/CHAT") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_chat") 
		return true
	end
	
	if (command == "/swap") or (command == "/SWAP") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_swap") 
		return true
	end
	
	if (command == "/skill") or (command == "/SKILL") then
		nx_execute("admin_yBreaker\\yBreaker_scripts_func\\yBreaker_scripts_spamskill","spam_Skill")
		return true
	end
	
	if (command == "/mach") or (command == "/MACH") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_jingmai") 
		return true
	end
	
	if (command == "/timdan") or (command == "/TIMDAN") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_searchzither") 
		return true
	end
	
	if (command == "/timcay") or (command == "/TIMCAY") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_searchherb") 
		return true
	end
	
	if (command == "/mat") or (command == "/MAT") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_godseyes") 
		return true
	end
	
	if (command == "/blink") or (command == "/BLINK") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_blink") 
		return true
	end
	
	if (command == "/buff") or (command == "/BUFF") then
		nx_execute("admin_yBreaker\\yBreaker_scripts_func\\yBreaker_scripts_bughpmp","buff_full_hpmp")
		return true
	end
	
	if (command == "/die") or (command == "/DIE") then
		nx_execute("admin_yBreaker\\yBreaker_scripts_func\\yBreaker_scripts_suicide","auto_init")
		return true
	end
	
	--if command == 'reload' then
	--	local world = nx_value("world")
	--	world:ReloadAllScript()
	--	return true
	--end
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
			local buff_time = yBreaker_get_second_from_text(form["lbl_time" .. tostring(i)].Text)
			if buff_time == nil then
				return -1
			else
				return buff_time
			end
		end
	end
	return nil
end

-- Function for time use in _spamskill.lua
function yBreaker_get_second_from_text(text)
	local num
	local texttime
	--ui_minute=phút
	--ui_hour=Giờ
	--ui_day=Ngày
	--ui_second=s
	num = string.match(nx_string(text), "(%d+)")
	if num ~= nil then
		local cstart = string.len(num) + 1
		texttime = string.sub(nx_string(text), cstart, cstart)
		num = tonumber(num)

		if texttime == "N" or texttime == "n" then
			num = num * 86400
		elseif texttime == "G" or texttime == "g" then
			num = num * 3600
		elseif texttime == "P" or texttime == "p" then
			num = num * 60
		end

		return num
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

-- Function get thực lực player for search zither/herb
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

-- Function get current map for search zither/herb
function yBreaker_get_current_map()
	return nx_value("form_stage_main\\form_map\\form_map_scene").current_map
end

-- Function get info player for swap function
function yBreaker_get_player()
	local client = nx_value("game_client")
	local client_player = client:GetPlayer()
	return client_player
end

-- DEMO chưa dùng
-- Get map ID by name
function yBreaker_get_map_id(name)
	if name == "cyv" then
		return "school01"
	elseif name == "cb" then
		return "school02"
	elseif name == "qtd" then
		return "school03"
	elseif name == "clc" then
		return "school04"
	elseif name == "dm" then
		return "school05"
	elseif name == "nm" then
		return "school06"
	elseif name == "vd" then
		return "school07"
	elseif name == "tl" then
		return "school08"
	elseif name == "dhd" then
		return "school10"
	elseif name == "vcm" then
		return "school11"
	elseif name == "hdm" then
		return "school13"
	elseif name == "cm" then
		return "school14"
	elseif name == "nlb" then
		return "school15"
	elseif name == "hs" then
		return "school17"
	elseif name == "ttc" then
		return "school19"
	elseif name == "yk" then
		return "city01"
	elseif name == "tc" then
		return "city02"
	elseif name == "kl" then
		return "city03"
	elseif name == "ld" then
		return "city04"
	elseif name == "td" then
		return "city05"
	end
end

-- Lấy Hành trang ID trả về config ID
function yBreaker_get_bag_id_by_config_id(configId)
	local form = nx_value("form_stage_main\\form_bag")
	if not nx_is_valid(form) then
		return nil
	end
	local item_query = nx_value("ItemQuery")
	if not nx_is_valid(item_query) then
		return nil
	end
	local goods_grid = nx_value("GoodsGrid")
	if not nx_is_valid(goods_grid) then
	return nil
	end
	local bExist = item_query:FindItemByConfigID(nx_string(configId))
	if not bExist then
		return nil
	end
  -- local count = goods_grid:GetItemCount(configid)
  -- if count == 0 then
  --   return nil
	-- end
	--ItemQuery:GetItemPropByConfigID(nx_string(item_config), nx_string("IsMarketItem"))
	local bag_no = item_query:GetItemPropByConfigID(nx_string(configId), nx_string("ViewID"))
		bag_no = tonumber(bag_no)
	local rbtn
	if bag_no == 1 then
		return 2 	-- Túi vật phẩm
	elseif bag_no == 2 then
		return 121	-- Túi trang bị
	elseif bag_no == 3 then
		return 123 	-- Túi nguyên liệu
	elseif bag_no == 4 then
		return 125 	-- Túi nhiệm vụ
	end
end
