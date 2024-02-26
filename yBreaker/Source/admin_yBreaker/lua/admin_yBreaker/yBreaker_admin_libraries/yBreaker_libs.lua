require("util_gui")
require("tips_data")
require("util_functions")
require("share\\server_custom_define")
require("define\\sysinfo_define")
require("share\\chat_define")
require("define\\request_type")

local inspect = require("admin_yBreaker\\yBreaker_admin_libraries\\inspect")

-- Function check guildname of user can use yBreaker
function yBreaker_check_user_guild()
	local game_client = nx_value("game_client")
	local player_client = game_client:GetPlayer()
	local user_guild = player_client:QueryProp("GuildName")
	if user_guild == nx_function("ext_utf8_to_widestr", "NhấtPhẩmCác") then  
		-- Actived yBreaker
        --return true
    else
		--yBreaker_show_Utf8Text("Text")
		
		-- Deactived yBreaker
		--return false
	end
	
	-- Deactived yBreaker_check_user_guild()
	return true
end

-- Function check name of user can use yBreaker
function yBreaker_check_name_user_name()
	local game_client = nx_value("game_client")
	local player_client = game_client:GetPlayer()
	local user_name = player_client:QueryProp("Name")
	if user_name == nx_function("ext_utf8_to_widestr", "BạchYCầmSư") or
	   user_name == nx_function("ext_utf8_to_widestr", ".ChủngHổ.")	 then   
		
		-- Actived yBreaker
        --return true
    else
		--yBreaker_show_Utf8Text("Text")
		
		-- Deactived yBreaker
		--return false
	end
	
	-- Deactived yBreaker_check_user_name()
	return true
end

-- Character table string
local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
-- encoding
function yBreaker_enc_o_d_e(data)
  return ((data:gsub('.', function(x) 
    local r,b='',x:byte()
    for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
    return r;
  end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
    if (#x < 6) then return '' end
    local c=0
    for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
    return b:sub(c+1,c+1)
  end)..({ '', '==', '=' })[#data%3+1])
end
-- decoding
function yBreaker_dec_o_d_e(data)
  data = string.gsub(data, '[^'..b..'=]', '')
  return (data:gsub('.', function(x)
    if (x == '=') then return '' end
    local r,f='',(b:find(x)-1)
    for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
    return r;
  end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
    if (#x ~= 8) then return '' end
    local c=0
    for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
    return string.char(c)
  end))
end

-- Show notice dialog to warning
function yBreaker_send_notice_dialog(content)
  local content = nx_function("ext_utf8_to_widestr", content)
  ShowTipDialog(content)
end

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
	
	if (command == "/help") or (command == "/HELP") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_main_help") 
		return true
	end
	
	if (command == "/at") or (command == "/AT") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_automation") 
		return true
	end
	
	--if (command == "/ai") or (command == "/AI") then
	--	util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_ai") 
	--	return true
	--end
	
	if (command == "/set") or (command == "/SET") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_setting") 
		return true
	end
	
	if (command == "/a") or (command == "/A") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_pvp") 
		return true
	end
	
	if (command == "/s") or (command == "/S") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_swap") 
		return true
	end
	
	if (command == "/d") or (command == "/D") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_selectinfo") 
		return true
	end
	
	if (command == "/q") or (command == "/Q") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_godseyes") 
		return true
	end
	
	if (command == "/w") or (command == "/W") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_jingmai") 
		return true
	end
	
	if (command == "/e") or (command == "/E") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_bugs") 
		return true
	end
	
	if (command == "/z") or (command == "/Z") then
		nx_execute("admin_yBreaker\\yBreaker_scripts_func\\yBreaker_scripts_godping", "yBreaker_god_ping")
		return true
	end
	
	if (command == "/x") or (command == "/X") then
		nx_execute(nx_current(),"yBreaker_show_HP_bar")
		return true
	end
	
	if (command == "/c") or (command == "/C") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_customscan") 
		return true
	end
	
	if (command == "/b") or (command == "/B") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_boombuff") 
		return true
	end
		
	if (command == "/blink") or (command == "/BLINK") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_blink") 
		return true
	end
	
	if (command == "/lam") or (command == "/LAM") then
		nx_execute("admin_yBreaker\\yBreaker_scripts_func\\yBreaker_scripts_bughpmp","yBreaker_buff_hpmp")
		return true
	end
	
	if (command == "/th") or (command == "/TH") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_stackthbb") 
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
		
	if (command == "/spam") or (command == "/SPAM") then
		nx_execute("admin_yBreaker\\yBreaker_scripts_func\\yBreaker_scripts_spamskill","spam_Skill")
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
			
	if (command == "/die") or (command == "/DIE") then
		nx_execute("admin_yBreaker\\yBreaker_scripts_func\\yBreaker_scripts_suicide","yBreaker_suicide_player")
		return true
	end
	
	if (command == "/tm") or (command == "/TM") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_tamma") 
		return true
	end
	
	if (command == "/use") or (command == "/USE") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_useitems") 
		return true
	end
	
	if (command == "/stall") or (command == "/STALL") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_stallonline") 
		return true
	end
	
	--if (command == "/kn") or (command == "/KN") then
	--	nx_execute("admin_yBreaker\\yBreaker_scripts_func\\yBreaker_scripts_getmiracle","get_miracle")
	--	return true
	--end
	
	if (command == "/lt") or (command == "/LT") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_winepractice") 
		return true
	end
	
	if (command == "/sm") or (command == "/SM") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_spammail") 
		return true
	end
	
	if (command == "/lc") or (command == "/LC") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_luyencong") 
		return true
	end
	
	if (command == "/tn") or (command == "/TN") then
	 	util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_thunghiep") 
	 	return true
	end
	
	if (command == "/pw") or (command == "/PW") then
		util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_password") 
		return true
	end
	
	--if (command == "/trongtrot") or (command == "/TRONGTROT") then
	--	util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_farmer") 
	--	return true
	--end
	
	--if (command == "/cauca") or (command == "/CAUCA") then
	--	util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_fisher") 
	--	return true
	--end
	
	--if (command == "/thuthap") or (command == "/THUTHAP") then
	--  util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_collecter") 
	--	return true
	--end
	
	--if (command == "/sanbat") or (command == "/SANBAT") then
	--	util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_hunter") 
	--	return true
	--end
	
	if (command == "/coc") or (command == "/COC") then
	 	util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_doabduct") 
	 	return true
	end
	
	if (command == "/vcd") or (command == "/VCD") then
	 	util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_Qvcd") 
	 	return true
	end
	
	-----zdn 
	if (command == "/tl") or (command == "/TL") then
		util_auto_show_hide_form("admin_zdn\\form_zdn_task") 
		return true
	end
	if (command == "/skill") or (command == "/SKILL") then
		util_auto_show_hide_form("admin_zdn\\form_zdn_skill_setting") 
		return true
	end
	if (command == "/atk") or (command == "/ATK") then
		util_auto_show_hide_form("admin_zdn\\form_zdn_attack") 
		return true
	end
	if (command == "/vt") or (command == "/VT") then
		util_auto_show_hide_form("admin_zdn\\form_zdn_escort") 
		return true
	end
	if (command == "/ltt") or (command == "/LTT") then
		util_auto_show_hide_form("admin_zdn\\form_zdn_ltt") 
		return true
	end
	if (command == "/n6") or (command == "/N6") then
		util_auto_show_hide_form("admin_zdn\\form_zdn_noi6") 
		return true
	end
	if (command == "/tdc") or (command == "/TDC") then
		util_auto_show_hide_form("admin_zdn\\form_zdn_tdc") 
		return true
	end
	if (command == "/vp") or (command == "/VP") then
		util_auto_show_hide_form("admin_zdn\\form_zdn_vat_pham") 
		return true
	end
	if (command == "/nd") or (command == "/ND") then
		util_auto_show_hide_form("admin_zdn\\form_zdn_nhat_do") 
		return true
	end
	if (command == "/cay") or (command == "/CAY") then
		util_auto_show_hide_form("admin_zdn\\form_zdn_cay") 
		return true
	end
	if (command == "/anthe") or (command == "/ANTHE") then
		util_auto_show_hide_form("admin_zdn\\form_zdn_an_the") 
	 	return true
	end
	if (command == "/dotham") or (command == "/DOTHAM") then
		util_auto_show_hide_form("admin_zdn\\form_zdn_do_tham") 
		return true
	end
	if (command == "/hk") or (command == "/HK") then
		util_auto_show_hide_form("admin_zdn\\form_zdn_hao_kiet") 
		return true
	end
	if (command == "/thth") or (command == "/THTH") then
		util_auto_show_hide_form("admin_zdn\\form_zdn_thich_quan") 
		return true
	end
	if (command == "/thuthap") or (command == "/THUTHAP") then
		util_auto_show_hide_form("admin_zdn\\form_zdn_thu_thap") 
		return true
	end
	if (command == "/trongtrot") or (command == "/TRONGTROT") then
		util_auto_show_hide_form("admin_zdn\\form_zdn_farm") 
		return true
	end
	
	--- Function temp
	if (command == "/battho") or (command == "/BATTHO") then
	 	util_auto_show_hide_form("admin_zdn\\form_zdn_bat_tho") 
	 	return true
	end

	-- if (command == "/chatloop") or (command == "/CHATLOOP") then
	-- 	util_auto_show_hide_form("admin_zdn\\form_zdn_chat_loop") 
	-- 	return true
	-- end
	if (command == "/ctz") or (command == "/CTZ") then
	 	util_auto_show_hide_form("admin_zdn\\form_zdn_chien_truong") 
	 	return true
	end
	-- if (command == "/coc") or (command == "/COC") then
	-- 	util_auto_show_hide_form("admin_zdn\\form_zdn_coc") 
	-- 	return true
	-- end

	if (command == "/kyngo") or (command == "/KYNGO") then
	 	util_auto_show_hide_form("admin_zdn\\form_zdn_ky_ngo") 
	 	return true
	end
	if (command == "/logz") or (command == "/LOGZ") then
		util_auto_show_hide_form("admin_zdn\\form_zdn_log") 
		return true
	end
	if (command == "/lcz") or (command == "/LCZ") then
		util_auto_show_hide_form("admin_zdn\\form_zdn_luyen_cong") 
		return true
	end
	if (command == "/lcgv") or (command == "/LCGV") then
	 	util_auto_show_hide_form("admin_zdn\\form_zdn_luyen_cong_binh") 
	 	return true
	end

	if (command == "/ontuyen") or (command == "/ONTUYEN") then
	 	util_auto_show_hide_form("admin_zdn\\form_zdn_on_tuyen") 
	 	return true
	end

	if (command == "/tmz") or (command == "/TMZ") then
		util_auto_show_hide_form("admin_zdn\\form_zdn_tam_ma") 
		return true
	end
	if (command == "/ttz") or (command == "/TTZ") then
		util_auto_show_hide_form("admin_zdn\\form_zdn_thien_the") 
		return true
	end
	if (command == "/ththz") or (command == "/THTHZ") then
		util_auto_show_hide_form("admin_zdn\\form_zdn_thth") 
		return true
	end
	if (command == "/tnz") or (command == "/TNZ") then
		util_auto_show_hide_form("admin_zdn\\form_zdn_thu_nghiep") 
		return true
	end
	if (command == "/f") or (command == "/F") then
		util_auto_show_hide_form("admin_zdn\\form_zdn_smart_setting") 
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
	local file = io.open("D:\\yBreaker_log.txt", "a")
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
	
	if not nx_is_valid(client_player) then
		return false
	end
	
	return client_player
end

-- Function show HP
local isStart = false
function yBreaker_show_HP_bar()
	nx_pause(1)
	FORM_MAIN_SELECT = "form_stage_main\\form_main\\form_main_select"
	local form = nx_value(FORM_MAIN_SELECT)
	if nx_is_valid(form) then
		if not isStart then
			isStart = true
			form.prog_hp.TextVisible = true
		else
			form.prog_hp.TextVisible = false
			isStart = false
		end
	end
end

-- Function set ID title for window client
function yBreaker_set_id_title()
  local account = nx_value("game_sock").account
  local game_config = nx_value("game_config")
  if not nx_is_valid(game_config) then
    return
  end
  local title = nx_widestr("yBreaker-") .. nx_widestr(account) .. nx_widestr("  ") .. nx_widestr(game_config.server_name)
  nx_function("ext_set_window_title", nx_widestr(title))
end

-- Function set char name title for window client
function yBreaker_set_char_name_title()
  local game_client = nx_value("game_client")
  if not nx_is_valid(game_client) then
    return
  end
  local client_player = game_client:GetPlayer()
  if not nx_is_valid(client_player) then
    return
  end
  
  local game_config = nx_value("game_config")
   if not nx_is_valid(game_config) then
    return
  end
  local player_name = client_player:QueryProp("Name")
  local title = nx_widestr("yBreaker-") .. nx_widestr(player_name) .. nx_widestr("  ") .. nx_widestr(game_config.server_name)
  nx_function("ext_set_window_title", nx_widestr(title))
end

-- Function set org title for window client
function yBreaker_set_org_title()
	local game_config = nx_value("game_config")
	local title = nx_widestr(util_text("ui_GameName")) .. nx_widestr("  ") .. nx_widestr(game_config.server_name)
	nx_function("ext_set_window_title", title)
end

-- Function to setting FPS
function yBreaker_fps_setting(fps_int)
	local world = nx_value("world")
	local scene = world.MainScene
	local game_control = scene.game_control
	game_control.MaxDisplayFPS = nx_int(fps_int)
end

-- Function find buff by ID
function yBreaker_find_buffer(buff_id) -- tìm buff chỉ trả về có hoặc không
	if nx_function("find_buffer", nx_value("game_client"):GetPlayer(), buff_id) then
		return true
	end
	return false
end

-- Function use skill by skill ID
function yBreaker_use_skill_id(skill_id)
	local fight = nx_value("fight")
	fight:TraceUseSkill(skill_id, false, false)
end

-- Function to unlock password 2
-- Function unlock pass 2
function unlock_my_pw2()
	local ini = nx_create("IniDocument")
	local file = Get_Config_Dir_Ini("Password")
  	ini.FileName = file
  	if not ini:LoadFromFile() then
		nx_value("SystemCenterInfo"):ShowSystemCenterInfo(nx_function("ext_utf8_to_widestr"," Chưa lưu mật khẩu rương."), 2)
  		return false
  	end
	local read_PR = nx_string(ini:ReadString("Pw2", "Pw2_Encrytped", ""))
	if read_PR ~= nil and read_PR ~= "" and read_PR ~= " " then
		local dec_d = yBreaker_dec_o_d_e(read_PR)
		nx_execute("custom_sender", "check_second_word", nx_widestr(dec_d))
	else
		nx_value("SystemCenterInfo"):ShowSystemCenterInfo(nx_function("ext_utf8_to_widestr","Chưa lưu mật khẩu rương."), 2)
		return false
	end
end

function check_encrypted_pw2()
	local ini = nx_create("IniDocument")
	local file = Get_Config_Dir_Ini("Password")
  	ini.FileName = file
  	if not ini:LoadFromFile() then
  		return false
  	end
	local read_PR = nx_string(ini:ReadString("Pw2", "Pw2_Encrytped", ""))
	if read_PR ~= nil and read_PR ~= "" and read_PR ~= " " then
		return true
	else
		return false
	end
end

function Get_Config_Dir_Ini(func_name)
	local game_config = nx_value("game_config")
	local account = game_config.login_account
    local dir = nx_function("ext_get_current_exe_path") .. "yBreaker_" .. account 
    local file = ""
    if not nx_function("ext_is_exist_directory", nx_string(dir)) then
		nx_function("ext_create_directory", nx_string(dir))
    end
	if func_name == "Password" then
		file = dir .. nx_string("\\Password.ini")
	end
	
	if func_name == "Setting" then
		file = dir .. nx_string("\\Setting.ini")
	end
	
    if not nx_function("ext_is_file_exist", file) then
		if func_name == "Password" then
			local PR = nx_create("StringList")
			PR:AddString("[Pw2]")
			PR:AddString("Pw2_Encrytped=")
			PR:SaveToFile(file)
		end
		
		if func_name == "Setting" then
			local set = nx_create("StringList")
			set:AddString("[Setting]")
			set:AddString("Unlock_Pass_2=")
			set:AddString("Add_Del_Text=")
			set:AddString("Skip_Story_Movie=")
			set:AddString("Title_Char_Name=")	
			set:AddString("Title_ID=")
			set:AddString("Auto_Get_Miracle=")			
			set:AddString("Auto_Use_Caiyao=")
			set:AddString("Hidden_Expire_Bag=")
			set:AddString("Auto_Swap_Weapon=")
			set:SaveToFile(file)
		end
    end
    return file
end

function yBreaker_use_caiyao()
	local GoodsGrid = nx_value("GoodsGrid")	
	local caiyao_count = GoodsGrid:GetItemCount("caiyao20002")	--  Màn thầu
	local buf_baosd_01 = yBreaker_get_buff_id_info("buf_baosd_01") -- buf_baosd_01=Bụng đói vơ quàng
	--local buf_baosd_02 = yBreaker_get_buff_id_info("buf_baosd_02") -- buf_baosd_02=Cơ Trường Lộc Lộc
	--local buf_baosd_03 = yBreaker_get_buff_id_info("buf_baosd_03") -- buf_baosd_03=Nhu cầu thiết yếu
	
	local ini = nx_create("IniDocument")
	local file = Get_Config_Dir_Ini("Setting")
  	ini.FileName = file
  	if not ini:LoadFromFile() then
  		return
  	end
	local setting_caiyao = nx_string(ini:ReadString(nx_string("Setting"), "Auto_Use_Caiyao", ""))
	--local caiyao_num = nx_int(ini:ReadString(nx_string("Setting"), "Caiyao_Number", ""))
	
	if setting_caiyao == nx_string("true") and (buf_baosd_01 ~= nil) and caiyao_count > 0 then	
	--if setting_caiyao == nx_string("true") and caiyao_num > nx_int(0) and (buf_baosd_01 ~= nil) and caiyao_count > 0 then
		--yBreaker_show_Utf8Text("Setting:" .. nx_string(setting_caiyao) .. " Number:" .. nx_string(caiyao_num))
		nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", "caiyao20002")		
		nx_pause(1)
	end	
end

-- Xuống ngựa
function yBreaker_get_down_the_horse()
	if get_buff_info("buf_riding_01") ~= nil then
		nx_execute("custom_sender", "custom_remove_buffer", "buf_riding_01")
		nx_pause(0.2)
	end
end

--Thụ Nghiệp
-- Nhận số điểm thụ nghiệp nếu < 1000 điểm và trong ngày chưa max trả về true
function yBreaker_is_School_Dance_Finish()
	local game_client = nx_value('game_client')
	if not nx_is_valid(game_client) then
		return false
	end
	local player = game_client:GetPlayer()
	local f = 'form_stage_main\\form_school_dance\\form_school_dance_member'
	local t = nx_int(player:QueryProp('SchoolDanceTotalScore'))
	local d = nx_int(player:QueryProp('SchoolDanceDayScore'))
	if t < nx_int(1000) and d < nx_int(nx_execute(f, 'get_inisec', 'DayScore')) then
		return true
	else
		return false
	end
end

function yBreaker_get_skill_data(grid, index)
    if not nx_is_valid(grid) then
        return ""
    end
    local itemName = grid:GetItemName(index)
    if nx_widestr(itemName) == nx_widestr("") then
        return ""
    end
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return ""
    end
    local view = game_client:GetView(nx_string(40))
    if not nx_is_valid(view) then
        return ""
    end
    local viewobj_list = view:GetViewObjList()
    for i = 1, table.getn(viewobj_list) do
        local configID = viewobj_list[i]:QueryProp("ConfigID")
        if util_text(configID) == itemName then
            return configID
        end
    end
    return ""
end

--Function change weapon adaptation when perform skill
function yBreaker_change_weapon_click(grid, index)
	if not nx_is_valid(grid) then
	return
	end
	if grid:IsEmpty(index) then
	return
	end
	local skill_id = yBreaker_get_skill_data(grid, index)
	local form_bag = util_get_form("form_stage_main\\form_bag")
	if nx_is_valid(form_bag) then
		local weapon_quip = nx_null()
		local game_client = nx_value("game_client")
		local client_player = game_client:GetPlayer()
		
		local LimitIndex = nx_execute("tips_data", "get_ini_prop", "share\\Skill\\skill_new.ini", skill_id, "UseLimit", "")
		if LimitIndex == nil then
		return false
		end
		local skill_query = nx_value("SkillQuery")
		if not nx_is_valid(skill_query) then
		return false
		end
		local ItemType = skill_query:GetSkillWeaponType(nx_int(LimitIndex))
		if ItemType == nil or nx_int(ItemType) == nx_int(0) then
		return false
		end

		if nx_is_valid(client_player) then
			local view_table = game_client:GetViewList()
			for i = 1, table.getn(view_table) do
				local view = view_table[i]
				if view.Ident == nx_string("121") then
					local view_obj_table = view:GetViewObjList()
					for k = 1, table.getn(view_obj_table) do
						local view_obj = view_obj_table[k]
						-- Check vũ khí tương ứng
						if nx_number(view_obj:QueryProp("ItemType")) == nx_number(ItemType) then
							weapon_quip = view_obj
							break
						end
					end
				end
			end

			-- Đổi vũ khí tương ứng
			if nx_is_valid(weapon_quip) then
				nx_execute("form_stage_main\\form_bag_func", "on_bag_right_click", form_bag.imagegrid_equip, nx_number(weapon_quip.Ident) - 1)	
			end
		end
	end
end

-- Function change 30% percent adaptation
local skill_id_backup = ""
function yBreaker_change_item_skill_pressing(grid, index)
	if not nx_is_valid(grid) then
	return
	end
	if grid:IsEmpty(index) then
	return
	end
	
	local skill_id = yBreaker_get_skill_data(grid, index)
	-- Trả về giá trị skill gốc khi là skill võ kỹ
	-- ID: Trịch bút
	if skill_id == "wuji_CS_tm_ywt07" then 
		skill_id = "CS_tm_ywt07"
	end
	
	-- Mạnh bà 
	if skill_id == "wuji_CS_tm_ywt05" then 
		skill_id = "CS_tm_ywt05"
	end
	
	-- Vô Thường
	if skill_id == "wuji_CS_tm_ywt03" then
		skill_id = "CS_tm_ywt03"
	end
	
	-- Long trảo thủ cổ
	if skill_id == "wuji_CS_sl_lzs06" then
		skill_id = "CS_sl_lzs06"
	end
	if skill_id == "wuji_CS_sl_lzs07" then
		skill_id = "CS_sl_lzs07"
	end
	
	-- Thái cực quyền cổ
	if skill_id == "wuji_CS_wd_tjq08" then
		skill_id = "CS_wd_tjq08"
	end
	if skill_id == "wuji_CS_wd_tjq06" then
		skill_id = "CS_wd_tjq06"
	end
	if skill_id == "wuji_CS_wd_tjq03" then
		skill_id = "CS_wd_tjq03"
	end
	
	-- Kim xà thích
	if skill_id == "wuji_CS_tm_jsc05" then
		skill_id = "CS_tm_jsc05"
	end
	if skill_id == "wuji_CS_tm_jsc06" then
		skill_id = "CS_tm_jsc06"
	end
	
	-- Đả cẩu bổng Cổ
	if skill_id == "wuji_CS_gb_dgbf02" then
		skill_id = "CS_gb_dgbf02"
	end
	if skill_id == "wuji_CS_gb_dgbf07" then
		skill_id = "CS_gb_dgbf07"
	end
	if skill_id == "wuji_CS_gb_dgbf08" then
		skill_id = "CS_gb_dgbf08"
	end
	
	-- Mị ảnh kiếm
	if skill_id == "wuji_CS_jh_myjf03" then
		skill_id = "CS_jh_myjf03"
	end
	if skill_id == "wuji_CS_jh_myjf08" then
		skill_id = "CS_jh_myjf03"
	end
	
	-- Kim đỉnh
	if skill_id == "wuji_CS_em_jdmz01" then
		skill_id = "CS_em_jdmz01"
	end
	if skill_id == "wuji_CS_em_jdmz02" then
		skill_id = "CS_em_jdmz02"
	end
	if skill_id == "wuji_CS_em_jdmz03" then
		skill_id = "CS_em_jdmz03"
	end
	
	-- Tịch tà
	if skill_id == "wuji_CS_jh_bxjf01" then
		skill_id = "CS_jh_bxjf01"
	end
	if skill_id == "wuji_CS_jh_bxjf04" then
		skill_id = "CS_jh_bxjf04"
	end
	if skill_id == "wuji_CS_jh_bxjf08" then
		skill_id = "CS_jh_bxjf08"
	end
	
	-- Bích hải
	if skill_id == "wuji_CS_th_bhcs04" then
		skill_id = "CS_th_bhcs04"
	end
	if skill_id == "wuji_CS_th_bhcs06" then
		skill_id = "CS_th_bhcs06"
	end
	if skill_id == "wuji_CS_th_bhcs07" then
		skill_id = "CS_th_bhcs07"
	end
	
	-- Tứ Hải Đao - biến chiêu
	if skill_id == "CS_dy_sdyjl01_hide" then
		skill_id = "CS_dy_sdyjl01"
	end
	
	if skill_id == "CS_dy_sdyjl05_hide" then
		skill_id = "CS_dy_sdyjl05"
	end
	
	if skill_id == "CS_dy_sdyjl09_hide" then
		skill_id = "CS_dy_sdyjl09"
	end
		
	local form_bag = util_get_form("form_stage_main\\form_bag")
	if nx_is_valid(form_bag) then
		local skill_pack_ini = get_ini_safe("share\\ModifyPack\\SkillPack.ini")
		if nx_is_valid(skill_pack_ini) then
			local weapon_quip = nx_null()
			local game_client = nx_value("game_client")
			local client_player = game_client:GetPlayer()
			
			local LimitIndex = nx_execute("tips_data", "get_ini_prop", "share\\Skill\\skill_new.ini", skill_id, "UseLimit", "")
			if LimitIndex == nil then
			return false
			end
			-- 27: Hỏa đạn/ 25: Phi tiêu/ 26: Phi đao
			if nx_number(LimitIndex) == nx_number(27) or nx_number(LimitIndex) == nx_number(25) or nx_number(LimitIndex) == nx_number(26) then
				LimitIndex = 0
			end
			
			local skill_query = nx_value("SkillQuery")
			if not nx_is_valid(skill_query) then
			return false
			end
			local ItemType = skill_query:GetSkillWeaponType(nx_int(LimitIndex))
			if ItemType == nil then
			return false
			end

			if nx_is_valid(client_player) then
				local view_table = game_client:GetViewList()
				for i = 1, table.getn(view_table) do
					local view = view_table[i]
					if view.Ident == nx_string("121") then
						local view_obj_table = view:GetViewObjList()
						for k = 1, table.getn(view_obj_table) do
							local view_obj = view_obj_table[k]

							-- ItemType: Get vũ khí dựa vào skill ở trên/ 
							-- nx_number(145): Oản
							-- nx_int(0): Tất cả các loại (Oản + B.thư, ...)
							if nx_number(view_obj:QueryProp("ItemType")) == nx_number(ItemType) or nx_number(view_obj:QueryProp("ItemType")) == nx_number(145) then

								local row = view_obj:GetRecordRows("SkillModifyPackRec")
								if row > 0 then
									for k = 0, row - 1 do
										local prop = view_obj:QueryRecord("SkillModifyPackRec", k, 0)
										local sec_index = skill_pack_ini:FindSectionIndex(nx_string(prop))
										local value = ""
										if sec_index >= 0 then
											value = skill_pack_ini:ReadString(sec_index, "r", nx_string(""))
										end
										
										local tuple = util_split_string(value, ",")
										if nx_string(tuple[1]) == nx_string(skill_id) and skill_id ~= skill_id_backup then
											item_quip = view_obj
											skill_id_backup = skill_id
										end
									end
								end
							end
						end
						break
					end
				end

				-- Đổi đồ 30%
				if nx_is_valid(item_quip) then
					nx_execute("form_stage_main\\form_bag_func", "on_bag_right_click", form_bag.imagegrid_equip, nx_number(item_quip.Ident) - 1)	
				end
			end
		end
	end
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

auto_swap_weapon_skill = function()
	if not auto_skill_weapon_uid then		
		local inifile = add_file_user('auto_skill')
		local skilltaolu = wstrToUtf8(readIni(inifile,'SettingSkill','Active',''))
		if skilltaolu ~= '' then
			local weaponuid = nx_string(readIni(inifile,skilltaolu,'item_uid',''))
			auto_skill_weapon_uid = weaponuid
		end
	end
	if not check_skill_weapon_enable(auto_skill_weapon_uid) then
		local weapon = get_weapon_use_by_uid(auto_skill_weapon_uid)
		if weapon == nil then
			nx_pause(0.5)
			swap_weapon_autoskill(auto_skill_weapon_uid)
		end
	end
end

function getBattlefieldWeapon()
  local game_client = nx_value('game_client')
  local ini = get_ini_safe('share\\ModifyPack\\SkillPack.ini')
  if nx_is_valid(game_client) then
    local view_table = game_client:GetViewList()
    local skillDamage = 0
    local CPDamage = 0
    local STDamage = 0
    local binhthuName = ''
    for i = 1, table.getn(view_table) do
      local view = view_table[i]
      if view.Ident == nx_string('1') then
        local view_obj_table = view:GetViewObjList()
        for k = 1, table.getn(view_obj_table) do
          local view_obj = view_obj_table[k]
          if string.find(nx_string(view_obj:QueryProp('ConfigID')), 'battlefield') and view_obj:QueryProp('EquipType') == 'Weapon' then
            return true
          end
        end
      end
    end
  end
  return false
end

function getCurPos()
	local game_client = nx_value("game_client")
	local game_visual = nx_value("game_visual")
	if not nx_is_valid(game_client) or  not nx_is_valid(game_visual) then return end
	local client_player = game_client:GetPlayer()
	local visual_player = game_visual:GetPlayer()
	if not nx_is_valid(client_player) or not nx_is_valid(visual_player) then return end
	return visual_player.PositionX, visual_player.PositionY, visual_player.PositionZ
end

function getDistancePlayerToObj(obj)
	local vObj = getVisualObj(obj)
	if not nx_is_valid(vObj) then return 9999999999 end
	return getDistanceFromPos(vObj.PositionX, vObj.PositionY, vObj.PositionZ)
end

getDistanceFromPos = function(x, y, z)
  if x == nil or z == nil then
	--reset_current_pos()
	return 999999 
  end
  local game_visual = nx_value("game_visual")
  if not nx_is_valid(game_visual) then
    return 999999
  end
  local visual_player = game_visual:GetPlayer()
  if not nx_is_valid(visual_player) then
    return 999999
  end
  local rX = visual_player.PositionX - x
  local rY = visual_player.PositionY - y
  local rZ = visual_player.PositionZ - z
  local r = math.sqrt(rX * rX + rY * rY + rZ * rZ)
  return r
end

function is_mp_full_train()
  local player = getPlayer()
  if not nx_is_valid(player) then return true end
  local mp = nx_number(player:QueryProp('MPRatio'))
  local hp = nx_number(player:QueryProp('HPRatio'))
  local logic_state = getPlayerLogicState()
  return (logic_state ~= 102 and mp > 10 and hp > 30) or (mp > 90 and hp > 90)
end

function getPlayerLogicState( ... )
  local role = nx_value('role')
  if not nx_is_valid(role) then return 1 end
  local game_visual = nx_value('game_visual')
  if not nx_is_valid(game_visual) then return 1 end
  return game_visual:QueryRoleLogicState(role)
end
function get_captain_name()
  local player = getPlayer()
  if not nx_is_valid(player) then return nx_widestr('') end
  return nx_widestr(player:QueryProp('TeamCaptain'))
end
function get_player_name( ... )
  local player = getPlayer()
  if not nx_is_valid(player) then return nil end
  return nx_widestr(player:QueryProp('Name'))
end
function get_pos_player_dis(name)
  local game_client = nx_value('game_client')
  if not nx_is_valid(game_client) then return end
  local game_scene = game_client:GetScene()
  if not nx_is_valid(game_scene) then return  end
  local obj_list = game_scene:GetSceneObjList()
  for i,obj in pairs(obj_list) do
    if name == nx_widestr(obj:QueryProp('Name')) then return obj end
  end
  return nil
end

get_weapon_by_id_uid = function(uid)
	if uid == nil then return end 
	local game_client = nx_value("game_client")
	if not nx_is_valid(game_client) then
		return
	end
	local view = game_client:GetView("121")
	if not nx_is_valid(view) then return end
	local viewobj_list = view:GetViewObjList()
	for i = 1 ,table.getn(viewobj_list) do
		local obj = viewobj_list[i]
		if nx_string(obj:QueryProp('UniqueID')) == nx_string(uid) then
			return obj.Ident,obj:QueryProp('ConfigID')
		end
	end	
	return nil	
end
get_weapon_use_by_uid = function(uid)
	if uid == nil then return end 
	local game_client = nx_value("game_client")
	if not nx_is_valid(game_client) then
		return
	end
	local view = game_client:GetView("1")
	if not nx_is_valid(view) then return end
	local viewobj_list = view:GetViewObjList()
	for i = 1 ,table.getn(viewobj_list) do
		local obj = viewobj_list[i]
		if nx_number(obj.Ident) == nx_number('22') then
			if obj:QueryProp('UniqueID') == uid then
				return obj.Ident,obj:QueryProp('ConfigID')
			end
		end
	end	
	return nil	
end
function swap_weapon_autoskill(uid)	
	if uid == nil then return end 
	local game_client = nx_value("game_client")
	if not nx_is_valid(game_client) then
		return
	end
	local ident,config = get_weapon_by_id_uid(uid)
	if ident ~= nil then
		local form = util_get_form('form_stage_main\\form_bag')
		if nx_is_valid(form) then
			nx_execute('form_stage_main\\form_bag_func', 'on_bag_right_click', form.imagegrid_equip, nx_number(ident) - 1)
		end
	end
end
