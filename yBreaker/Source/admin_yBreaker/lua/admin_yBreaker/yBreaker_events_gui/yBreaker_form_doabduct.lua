require("define\\request_type")
require("util_gui")
require("util_functions")
require("share\\chat_define")
require("share\\client_custom_define")
require("util_move")
require("share\\view_define")
require("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs")
require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")
require("admin_zdn\\zdn_lib_moving")

local THIS_FORM = "admin_yBreaker\\yBreaker_form_doabduct"

local auto_is_running_dynamic = false
local map_id = ""
local buff_remain_second = 0	-- Thời gian buff của cóc hồi (tính theo giây)
local buff_cnt_time = 8 * 60	-- Thời gian buff cóc trên nhân vật đã cài ở form (tính theo giây)

local max_distance_selectauto = 6
local used_abduct_item = false
local direct_run = false

-- Dữ liệu bắt cóc dạo
--local WINEXEC_PATH = "autodata\\tools.exe"
local DATA_ABDUCT_PATH = "yBreaker\\data\\data_abduct.lua"
local HOMEPOINT_INI_FILE = "share\\Rule\\HomePoint.ini"

-- Các định nghĩa trong hộp thư
local SUB_CLIENT_SET_JINGMAI = 1

local LETTER_SYSTEM_TYPE_MIN = 100 -- Lớn hơn cái này
local LETTER_SYSTEM_POST_USER = 101
local LETTER_SYSTEM_TEACH_NOTIFY = 102
local LETTER_SYSTEM_SINGLE_DIVORCE_NOTIFY = 103
local LETTER_SYSTEM_LOVER_RELATION_FREE = 104
local LETTER_SYSTEM_FRIEND = 105
local LETTER_USER_POST_TASK = 106
local LETTER_USER_OWNER_CROP_RECORD = 108
local LETTER_SYSTEM_TYPE_MAX = 199 -- Nhỏ hơn cái này là thư hệ thống

local LETTER_USER_TYPE_MIN = 0 -- Lớn hơn cái này
local LETTER_USER_POST_USER = 1
local LETTER_USER_POST_BACK_USER_OUT_TIME = 2
local LETTER_USER_POST_BACK_USER_REFUSE = 3
local LETTER_USER_POST_BACK_USER_FULL = 4
local LETTER_USER_POST_TRADE = 5
local LETTER_USER_POST_TRADE_PAY = 6
local LETTER_USER_WHISPER_USER = 10
local LETTER_USER_TYPE_MAX = 99 -- Nhỏ hơn cái này thì là thư người chơi

local POST_TABLE_SENDNAME = 0
local POST_TABLE_SENDUID = 1
local POST_TABLE_TYPE = 2
local POST_TABLE_LETTERNAME = 3
local POST_TABLE_VALUE = 4
local POST_TABLE_GOLD = 5
local POST_TABLE_SILVER = 6
local POST_TABLE_APPEDIXVALUE = 7
local POST_TABLE_DATE = 8
local POST_TABLE_READFLAG = 9
local POST_TABLE_SERIALNO = 10
local POST_TABLE_TRADE_MONEY = 11
local POST_TABLE_SELECT = 12
local POST_TABLE_LEFT_TIME = 13
local POST_TABLE_TRADE_DONE = 14

local Recv_rec_name = "RecvLetterRec"

-- Danh sác tọa độ đi tìm cóc
local dynamic_posmap = {}
-- Dữ liệu NPC đi bán
local dynamic_selldata = {}
-- Dữ liệu đứng đợi đợt sau
local dynamic_waitpos = {}
-- Điểm hồi sinh thần hành về sau khi bắt - Dữ liệu mảng để random
local dynamic_homepoint = {}
-- Bị dừng do có người đánh
local isCompleteBeauseAttacker = false
-- Lần cuối bị đánh
local lastBeingAttacked = 0
-- Khi tìm đường thất bại và tự tử thì set lên true
local isFindPathFalse = false

----------------------------------------
-- Lấy danh sách chat cho mấy đứa đánh mình
--
function getDataChatForAttacker()
    local dataDefault = {
        "??", "Vãi l?", "Cook!", "Gì dị 3?", "Cứu pé", "Wtf?", ":'(", "What the hell?",
        "DCMM?", "!!??", "?"
    }
    local ini = nx_execute("util_functions", "get_ini", "..\\bin\\yBreaker\\data\\data_abduct_chat.ini", true)
    if not nx_is_valid(ini) then
        return dataDefault
    end
    local listChats = {}
    local numchats = ini:GetSectionCount()
    local pos = 1
    for i = 0, numchats - 1 do
        listChats[pos] = ini:ReadString(i, "value", "")
        pos = pos + 1
    end
    return listChats
end

-----------------------------------------
-- Bắt cóc

function auto_run_dynamic()
    local step = 1
    local posOffset = 1
    local sellPosOffset = 1

    local doAbductPos = nil
    local direct_run = false
    local direct_run_sell = false
    local dissMissAbductItent = {}
    local direct_run_count = 0
    local intevalMessage = 0

    local fix_ride_executed = false
    local fix_extautoit_executed = false

    local lastStackUpTime = 0
    local isReturnedHomePoint = false -- Đã trở về điểm dừng chân
    local isSPRideCalled = false -- Đã gọi các loại ngựa đặc biệt rồi thì không gọi lại tránh việc cứ gọi nhiều lần

    -- Nếu bị đánh thì kết thúc hẳn auto cho đến khi chạy lại tùy theo cấu hình
    -- Trong phiên bản mới này bị đánh thì dừng lại 10 phút rồi chạy tiếp
    local isAutoStoped = false
    -- Đã log hoặc chat các đối tượng chưa
    -- Khi đã log rồi thì không log lại nữa
    local isLoggedAttacker = false

    local FORM_STALL_MAIN = "form_stage_main\\form_stall\\form_stall_main"
    local FORM_CONFIRM = "form_common\\form_confirm"
    local FORM_MAIN_REQUEST = "form_stage_main\\form_main\\form_main_request"

	local form = nx_value(THIS_FORM)
	local current_map = get_current_map()
	
	--Get map_id by select inindex of combobox
	map_id = get_mapid_by_selectindex(form.combobox_main_map)
	
	-- Kiểm tra map hiện tại có đúng như map đã chọn
	if current_map ~= map_id then
		-- Dịch chuyển đến map chính đã chọn
		--yBreaker_show_Utf8Text("Dịch chuyển qua map: " .. nx_string(map_id))
		TeleToHomePoint(homePointReturn[map_id][1])
		nx_pause(10)
		is_vaild_data = false
	else
		map_id = current_map
	end

	local posMap = abductPos[map_id]
	if posMap == nil then
		yBreaker_show_Utf8Text("Lỗi dữ liệu posMap")
		is_vaild_data = false
	end

	local sellDataMap = abductSell[map_id]
	if sellDataMap == nil then
		yBreaker_show_Utf8Text("Lỗi dữ liệu sellDataMap")
		is_vaild_data = false
	end

	local waitpos = waitPosAfterSell[map_id]
	if waitpos == nil then
		yBreaker_show_Utf8Text("Lỗi dữ liệu waitpos")
		is_vaild_data = false
	end

	local homepoint = homePointReturn[map_id]
	if homepoint == nil or homepoint == {} then
		yBreaker_show_Utf8Text("Lỗi dữ liệu homepoint")
		is_vaild_data = false
	end

	dynamic_posmap = posMap
	dynamic_selldata = sellDataMap
	dynamic_waitpos = waitpos
	dynamic_homepoint = homepoint
	
	-- Kiểm tra xem có đang load map hay không?
	if IsMapLoading() then
		is_vaild_data = false
	end
	
	-- Check thời gian setting có thể chạy 
	if not CanRun() then
		Stop()
		return
	end
	
    while auto_is_running_dynamic == true do
        local is_vaild_data = true
        local game_client
        local game_visual
        local game_player
        local player_client
        local game_scence
        local form

        form = nx_value(THIS_FORM)
        if not nx_is_valid(form) then
            is_vaild_data = false
        end
        game_client = nx_value("game_client")
        if not nx_is_valid(game_client) then
            is_vaild_data = false
        end
        game_visual = nx_value("game_visual")
        if not nx_is_valid(game_visual) then
            is_vaild_data = false
        end
        if is_vaild_data == true then
            game_player = game_visual:GetPlayer()
            if not nx_is_valid(game_player) then
                is_vaild_data = false
            end
            player_client = game_client:GetPlayer()
            if not nx_is_valid(player_client) then
                is_vaild_data = false
            end
            game_scence = game_client:GetScene()
            if not nx_is_valid(game_scence) then
                is_vaild_data = false
            end
        end

        -- Mở cái túi đồ
        local form_bag = nx_value("form_stage_main\\form_bag")
        local form_bagopen = 0
        while not nx_is_valid(form_bag) or form_bag.Visible == false do
            util_auto_show_hide_form("form_stage_main\\form_bag")
            nx_pause(0.1)
            form_bag = nx_value("form_stage_main\\form_bag")
            form_bagopen = form_bagopen + 1
            if form_bagopen > 10 then
                break
            end
        end
        if not nx_is_valid(form_bag) or not form_bag.Visible then
            tools_show_notice(nx_function("ext_utf8_to_widestr", "Không thể mở cái túi đồ lên được"))
            stop_type_dynamic()
            return false
        end

        -- Kích hoạt cái túi vật phẩm
        if not form_bag.rbtn_tool.Checked then
            form_bag.rbtn_tool.Checked = true
        end

        -- Kiểm tra và mua thuốc bắt cóc
        -- Tính số thuốc bắt cóc
        local numMediAbduct = 999
        local goods_grid = nx_value("GoodsGrid")
        if nx_is_valid(goods_grid) then
            numMediAbduct = goods_grid:GetItemCount("offitem_miyao10")
        end
        if numMediAbduct < 1 then
            local form_shop = nx_value("form_stage_main\\form_shop\\form_shop")
            if not nx_is_valid(form_shop) then
                nx_execute("custom_sender", "custom_open_mount_shop", 1)
                nx_pause(1)
            end
            local form_shop = nx_value("form_stage_main\\form_shop\\form_shop")
            local game_client = nx_value("game_client")
            if nx_is_valid(form_shop) and nx_is_valid(game_client) then
                local view_item = game_client:GetView(nx_string(VIEWPORT_SHOP))
                if nx_is_valid(view_item) then
                    local shopid = view_item:QueryProp("ShopID")
                    -- Page - Pos - Count
                    nx_execute("custom_sender", "custom_buy_item", shopid, nx_int(0), nx_int(18), nx_int(20))
                    nx_pause(0.5)
                    nx_execute("custom_sender", "custom_open_mount_shop", 0)
                    nx_pause(1)
                end
            end

            -- Vòng này đánh dấu bỏ qua để tiếp vòng sau
            is_vaild_data = false
        end
		
		-- Check thời gian setting có thể chạy 
		if not CanRun() then
			Stop()
			return
		end
		
		nx_execute("admin_zdn\\zdn_event_manager", "TriggerEvent", nx_current(), "on-task-interrupt")

        if is_vaild_data == true then
            local map = map_id
            local is_autofight = form.cbtn_dynamic_fight.Checked
            local isUseSpecialRide = form.cbtn_dynamic_usespride.Checked
            local isReturnHomePoint = form.cbtn_dynamic_returnhomepoint.Checked
            local isStopIfBeattacked = form.cbtn_dynamic_stop_if_beattacked.Checked
            local isChatAttacker = form.cbtn_dynamic_chat_attacker.Checked
			local isHelpMe = form.cbtn_dynamic_help_me.Checked
			local isHelpMeGuild = form.cbtn_dynamic_help_me_guild.Checked
			local isHelpMeLeague = form.cbtn_dynamic_help_me_league.Checked
			local isHelpMeTeam = form.cbtn_dynamic_help_me_team.Checked
			local isHelpMeRow = form.cbtn_dynamic_help_me_row.Checked

            -- Thời gian giới hạn
            local limitTimeF = nx_int(-1)
            local limitTimeT = nx_int(-1)

            local text_limitTimeF = form.combobox_dynamic_limittime_from.Text
            local text_limitTimeT = form.combobox_dynamic_limittime_to.Text
            if nx_widestr(text_limitTimeF) ~= nx_function("ext_utf8_to_widestr", "Không Giới Hạn") then
                limitTimeF = nx_int(nx_string(text_limitTimeF) .. nx_string("04"))
            end
            if nx_widestr(text_limitTimeT) ~= nx_function("ext_utf8_to_widestr", "Không Giới Hạn") then
                limitTimeT = nx_int(nx_string(text_limitTimeT) .. nx_string("00"))
            end

            -- Xác định trạng thái
            local logicstate = player_client:QueryProp("LogicState")
            local buff_abductor = get_buff_info("buf_abductor")
            local buff_abduct = get_buff_info("buf_offline_abduct_cd")
			local buff_count_time = (nx_number(form.combobox_count_time.Text) * 60)
            local buf_offline_abduct_fail = get_buff_info("buf_offline_abduct_fail")

            local os_h = tonumber(os.date("%H"))
            local os_m = tonumber(os.date("%M"))
            local os_modtime = nx_int(os_h * 100 + os_m)
            local isStopAuto = true
            if (limitTimeF < nx_int(0) or os_modtime > limitTimeF) and (limitTimeT < nx_int(0) or os_modtime < limitTimeT) then
                isStopAuto = false
            end

            -- Nếu auto bị dừng do bị đánh thì kiểm tra
            if isAutoStoped then
                -- Bị đánh 10 phút thì tiếp tục bắt cóc
                if tools_difftime(lastBeingAttacked) > 600 then
                    isAutoStoped = false
                    isCompleteBeauseAttacker = false
                    isLoggedAttacker = false
                end
            end

            -- Xử lý khi bị đánh hoặc chiến đấu
            if logicstate == 1 then
				nx_function("ext_flash_window") -- Nháy màn hình khi bị đánh
				
				-- Nếu cấu hình dừng nếu bị đánh thì thiết đặt dừng auto
				if isStopIfBeattacked then
					-- Dừng di chuyển khi bị đánh
					if game_player.state == "path_finding" then
						nx_value("path_finding"):StopPathFind(game_player)
						stopPlayerHackMove()
					end
					-- Thiết lập dừng
					isAutoStoped = true
					isCompleteBeauseAttacker = true
					lastBeingAttacked = os.time()
				end
				
				-- Luôn luôn ghi log khi bị đánh
                if not isLoggedAttacker then
                    isLoggedAttacker = true
                    local listAttacker = getListAttacker()
					local textChatLog = nx_function("ext_utf8_to_widestr", "Cứu! Đang bị thằng ")
                    local totalAttacker = table.getn(listAttacker)
                    for i = 1, totalAttacker do
                        -- Log thông tin người đánh (luôn luôn)
						-- Ghi log
                        consoleAttacker(nx_function("ext_widestr_to_utf8", player_client:QueryProp("Name")) .. ": " .. tostring(os.date("%c")) .. ": Tên Thù: " .. listAttacker[i].name .. ", Thực Lực: " .. listAttacker[i].level .. ", Bang: " .. listAttacker[i].guide .. ", Tọa độ: " .. listAttacker[i].position)
                        
						local posX = string.format("%.0f", player_client.DestX)
						local posZ = string.format("%.0f", player_client.DestZ)
						local ident = player_client:QueryProp("Ident")

						local pathX = player_client.DestX
						local pathY = player_client.DestY
						local pathZ = player_client.DestZ
						
						textChatLog = textChatLog .. nx_function("ext_utf8_to_widestr", listAttacker[i].name)
						textChatLog = textChatLog .. nx_function("ext_utf8_to_widestr", " đánh tại: <a href=\"findpath,")
						textChatLog = textChatLog .. nx_widestr(get_current_map())
						textChatLog = textChatLog .. nx_widestr(",")
						textChatLog = textChatLog .. nx_widestr(pathX)
						textChatLog = textChatLog .. nx_widestr(",")
						textChatLog = textChatLog .. nx_widestr(pathY)
						textChatLog = textChatLog .. nx_widestr(",")
						textChatLog = textChatLog .. nx_widestr(pathZ)
						textChatLog = textChatLog .. nx_widestr(",")
						textChatLog = textChatLog .. nx_widestr(ident)
						textChatLog = textChatLog .. nx_widestr("\" style=\"HLStype1\">")
						textChatLog = textChatLog .. nx_widestr(posX)
						textChatLog = textChatLog .. nx_widestr(",")
						textChatLog = textChatLog .. nx_widestr(posZ)
						textChatLog = textChatLog .. nx_widestr("</a>")
						
                        if i < totalAttacker then
                            textChatLog = textChatLog .. nx_widestr(", ")
                        end
						
						if isHelpMe then
							-- Check nếu GUI có check thì chat theo kênh
							if isHelpMeGuild then
								-- Chat kênh bang
								nx_execute("custom_sender", "custom_chat", nx_int(CHATTYPE_GUILD), textChatLog)
							elseif isHelpMeLeague then
								-- Chat kênh liên minh
								nx_execute("custom_sender", "custom_chat", nx_int(CHATTYPE_GUILD_LEAGUE), textChatLog)
							elseif isHelpMeTeam then
								-- Chat kênh nhóm
								nx_execute("custom_sender", "custom_chat", nx_int(CHATTYPE_TEAM), textChatLog)
							elseif isHelpMeRow then
								-- Chat kênh đội
								nx_execute("custom_sender", "custom_chat", nx_int(CHATTYPE_ROW), textChatLog)
							end
						end
						
                    end

                    if isChatAttacker then
                        -- Chat gần theo dữ liệu
                        local dataChatForAttacker = getDataChatForAttacker()
                        local chatNearRand = math.random(1, table.getn(dataChatForAttacker))
                        local chatNearText = nx_function("ext_utf8_to_widestr", dataChatForAttacker[chatNearRand])
                        nx_execute("custom_sender", "custom_chat", nx_int(CHATTYPE_VISUALRANGE), chatNearText)
                    end
                end
            end

            -- Nếu auto bị dừng do bị đánh và không còn chiến đấu nữa thì vứt con cóc nếu đang ôm
            if isAutoStoped and logicstate ~= 1 then
				-- Không vứt cóc
                --throwAbduct()
                nx_pause(0.2)
            end

            -- Nếu bị chết thì phải bắt đầu lại từ đầu
            if logicstate == 120 then
                step = 5
                fix_ride_executed = false
                fix_extautoit_executed = false
                nx_execute("custom_sender", "custom_relive", 2, 0)
                intevalMessage = -1
                direct_run_count = 0
                dissMissAbductItent = {}
                direct_run = false
                doAbductPos = nil
                used_abduct_item = false
                posOffset = 1
                isSPRideCalled = false
                -- Bị chết rồi thì set tìm đường thất bại về false
                isFindPathFalse = false
                nx_pause(20)
            elseif logicstate == 1 and is_autofight then
                -- Nếu chiến đấu thì cứ thế múc khô máu
                step = 4
            elseif buf_offline_abduct_fail ~= nil then
                -- Nếu bị định thân thì chờ hết buff
                step = 6
            elseif (buff_abduct ~= nil and buff_abduct > buff_count_time) or isAutoStoped then
                -- Còn lại thời gian bắt cóc thì đi đến vị trí đứng để tránh bị theo dõi
                -- Phiên bản mới sẽ thần hành về điểm hồi sinh
                -- Khi thiết đặt
                step = 5
            elseif buff_abductor ~= nil then
                -- Có buff ôm cóc thì đi bán cóc
                step = 2
            elseif doAbductPos ~= nil then
                -- Nếu có xác định tọa độ con cóc rồi thì chạy lại đó đã
                step = 3
            elseif isStopAuto then
                -- khi cóc bán không có tiền nữa thì thôi không bắt nữa
                step = 5
            else
                local readyThisStep = true
                if readyThisStep then
                    -- Lên ngựa nếu như chưa lên
                    if not isSPRideCalled and isUseSpecialRide then
                        callTheSpecialRiding()
                        isSPRideCalled = true
                    end

                    -- Phát hiện con cóc thì chạy lại
                    local game_scence_objs = game_scence:GetSceneObjList()
                    -- Đảo ngược mảng để cái bao gai nằm trước con cóc
                    local i = table.getn(game_scence_objs)

                    while true do
                        local scence_obj = game_scence_objs[i]
                        if nx_is_valid(scence_obj) then
                            local ident = scence_obj.Ident
                            local obj_type = scence_obj:QueryProp("Type")
                            local distance = string.format("%.0f", distance3d(game_player.PositionX, game_player.PositionY, game_player.PositionZ, scence_obj.PosiX, scence_obj.PosiY, scence_obj.PosiZ))
                            -- Có bao gai ở gần và đã thổi thì nhặt lên
                            if obj_type == 4 and scence_obj:QueryProp("ConfigID") == "OffAbductNpc_0" and used_abduct_item and tonumber(distance) <= max_distance_selectauto then
                                -- Nếu thổi thành công xuất hiện bao gai thì nhặt lên
                                nx_execute("custom_sender", "custom_select", ident)
                                nx_pause(0.2)
                                nx_execute("custom_sender", "custom_select", ident)
                                nx_pause(0.2)
                                nx_execute("custom_sender", "custom_select", ident)
                                nx_pause(0.2)
                                nx_execute("custom_sender", "custom_select", ident)
                                nx_pause(10)
                                local buff_abductor = get_buff_info("buf_abductor")
                                if buff_abductor ~= nil then
                                    direct_run_sell = true
                                    used_abduct_item = false
                                    sellPosOffset = 1
                                    direct_run_count = 0
                                    fix_extautoit_executed = false
                                    fix_ride_executed = false
                                    -- Lên ngựa nếu đi bán
                                    if isUseSpecialRide then
                                        callTheSpecialRiding()
                                    end
                                end
                                break
                            elseif obj_type == 2 and scence_obj:QueryProp("IsAbducted") == 0 and scence_obj:QueryProp("OffLineState") == 1 and not scence_obj:FindProp("OfflineTypeTvT") and doAbductPos == nil and not in_array(scence_obj:QueryProp("Name"), dissMissAbductItent) then
                                local ident = nx_string(ident)
                                local ident_name = scence_obj:QueryProp("Name")
                                local abduct = game_visual:GetSceneObj(ident)
                                if nx_is_valid(abduct) then
                                    -- Nếu có người bị định thân thì bỏ qua nó
                                    --if tools_have_nearabdut(ident) == -1 then
                                        doAbductPos = {}
                                        doAbductPos.Ident = ident
                                        doAbductPos.Name = ident_name
                                        doAbductPos.x = abduct.PositionX
                                        doAbductPos.y = abduct.PositionY
                                        doAbductPos.z = abduct.PositionZ
                                        -- Dừng 0.4s nếu cóc này không đi lại thì chạy lại chỗ nó
                                        -- Nếu cóc đi lại thì chạy lại trước mặt nó 1 mét chờ nó tới
                                        nx_pause(0.4)
                                        -- Xác định lại xem con cóc còn không
                                        local abduct = game_visual:GetSceneObj(ident)
                                        if nx_is_valid(abduct) then
                                            local pxd = doAbductPos.x - abduct.PositionX
                                            local pyd = doAbductPos.y - abduct.PositionY
                                            local pzd = doAbductPos.z - abduct.PositionZ
                                            local distance = math.sqrt(pxd * pxd + pyd * pyd + pzd * pzd)
                                            if distance > 0.3 then
                                                tools_show_notice(nx_function("ext_utf8_to_widestr", "Phát hiện có cóc đi lại, chạy lại trước mặt nó 5 mét"))
                                                -- Set lại tọa độ trước mặt cóc
                                                local radian = abduct.AngleY
                                                local angle = radian_to_degree(radian)
                                                local zz = abduct.PositionZ
                                                local xx = abduct.PositionX
                                                local yy = abduct.PositionY
                                                local dst = 5

                                                -- Trước mặt
                                                if angle <= 90 then
                                                    zz = zz + math.abs(math.sin(math.pi / 2 - radian) * dst)
                                                    xx = xx + math.abs(math.cos(math.pi / 2 - radian) * dst)
                                                elseif angle > 90 and angle <= 180 then
                                                    zz = zz - math.abs(math.sin(math.pi * 3 / 2 - radian) * dst)
                                                    xx = xx + math.abs(math.cos(math.pi * 3 / 2 - radian) * dst)
                                                elseif angle > 180 and angle <= 270 then
                                                    zz = zz - math.abs(math.sin(math.pi * 3 / 2 - radian) * dst)
                                                    xx = xx - math.abs(math.cos(math.pi * 3 / 2 - radian) * dst)
                                                elseif angle > 270 then
                                                    zz = zz + math.abs(math.sin(math.pi * 3 / 2 - radian) * dst)
                                                    xx = xx - math.abs(math.cos(math.pi * 3 / 2 - radian) * dst)
                                                end

                                                doAbductPos.x = xx
                                                doAbductPos.y = yy
                                                doAbductPos.z = zz
                                            else
                                                tools_show_notice(nx_function("ext_utf8_to_widestr", "Phát hiện có cóc đứng im, chạy lại chỗ nó"))
                                            end
                                            direct_run = true
                                            direct_run_count = 0
                                            fix_ride_executed = false
                                            fix_extautoit_executed = false
                                            step = 3
                                            break
                                        end
                                    --else
                                    --    table.insert(dissMissAbductItent, scence_obj:QueryProp("Name"))
                                    --end
                                end
                            
							elseif obj_type == 2 and scence_obj:QueryProp("IsAbducted") == 1 and scence_obj:QueryProp("OffLineState") == 1 and not scence_obj:FindProp("OfflineTypeTvT") and doAbductPos == nil and not in_array(scence_obj:QueryProp("Name"), dissMissAbductItent) then
								-- Check buff cóc hồi trên mục tiêu
								for j = 1, 20 do
									if scence_obj:FindProp(nx_string("BufferInfo") .. nx_string(j)) and nx_string(util_split_string(scence_obj:QueryProp(nx_string("BufferInfo") .. nx_string(j)), ",")[1]) == "buf_abducted" then
										local MessageDelay = nx_value("MessageDelay")
										if not nx_is_valid(MessageDelay) then
										  return 0
										end
										local buff_info = util_split_string(scence_obj:QueryProp(nx_string("BufferInfo") .. nx_string(j)), ",")
										local buff_time = buff_info[4]

										local server_now_time = MessageDelay:GetServerNowTime()
										local buff_diff_time = nx_int((buff_time - server_now_time) / 1000) -- Unit timesamp
										local buff_remain_h = nx_int(buff_diff_time / 3600) -- Giờ
										local buff_remain_m = nx_int((buff_diff_time - (buff_remain_h * 3600)) / 60) -- Phút
										local buff_remain_s = nx_int(buff_diff_time - (buff_remain_h * 3600) - (buff_remain_m * 60)) -- Giây
										buff_remain_second = nx_int(buff_remain_h) * 3600 + nx_int(buff_remain_m) * 60 + nx_int(buff_remain_s)	
									end
								end
								
								local buff_time_setting = nx_int(form.combobox_buff_time.Text) * 60
								
								if buff_remain_second ~= nil then
									if nx_int(buff_remain_second) < nx_int(buff_time_setting) then
										nx_function("ext_flash_window") -- Nháy màn hình khi có mục tiêu
										local ident = nx_string(ident)
										local ident_name = scence_obj:QueryProp("Name")
										local abduct = game_visual:GetSceneObj(ident)
										if nx_is_valid(abduct) then
											-- Nếu có người bị định thân thì bỏ qua nó
											--if tools_have_nearabdut(ident) == -1 then
												doAbductPos = {}
												doAbductPos.Ident = ident
												doAbductPos.Name = ident_name
												doAbductPos.x = abduct.PositionX
												doAbductPos.y = abduct.PositionY
												doAbductPos.z = abduct.PositionZ
												-- Dừng 0.4s nếu cóc này không đi lại thì chạy lại chỗ nó
												-- Nếu cóc đi lại thì chạy lại trước mặt nó 1 mét chờ nó tới
												nx_pause(0.4)
												-- Xác định lại xem con cóc còn không
												local abduct = game_visual:GetSceneObj(ident)
												if nx_is_valid(abduct) then
													local pxd = doAbductPos.x - abduct.PositionX
													local pyd = doAbductPos.y - abduct.PositionY
													local pzd = doAbductPos.z - abduct.PositionZ
													local distance = math.sqrt(pxd * pxd + pyd * pyd + pzd * pzd)
													if distance > 0.3 then
														tools_show_notice(nx_function("ext_utf8_to_widestr", "Phát hiện cóc sắp hồi, chạy lại trước mặt nó 5 mét"))
														-- Set lại tọa độ trước mặt cóc
														local radian = abduct.AngleY
														local angle = radian_to_degree(radian)
														local zz = abduct.PositionZ
														local xx = abduct.PositionX
														local yy = abduct.PositionY
														local dst = 5

														-- Trước mặt
														if angle <= 90 then
															zz = zz + math.abs(math.sin(math.pi / 2 - radian) * dst)
															xx = xx + math.abs(math.cos(math.pi / 2 - radian) * dst)
														elseif angle > 90 and angle <= 180 then
															zz = zz - math.abs(math.sin(math.pi * 3 / 2 - radian) * dst)
															xx = xx + math.abs(math.cos(math.pi * 3 / 2 - radian) * dst)
														elseif angle > 180 and angle <= 270 then
															zz = zz - math.abs(math.sin(math.pi * 3 / 2 - radian) * dst)
															xx = xx - math.abs(math.cos(math.pi * 3 / 2 - radian) * dst)
														elseif angle > 270 then
															zz = zz + math.abs(math.sin(math.pi * 3 / 2 - radian) * dst)
															xx = xx - math.abs(math.cos(math.pi * 3 / 2 - radian) * dst)
														end

														doAbductPos.x = xx
														doAbductPos.y = yy
														doAbductPos.z = zz
													else
														tools_show_notice(nx_function("ext_utf8_to_widestr", "Phát hiện cóc sắp hồi đứng im, chạy lại chỗ nó"))
													end
													direct_run = true
													direct_run_count = 0
													fix_ride_executed = false
													fix_extautoit_executed = false
													step = 3
													break
												end
											--else
											--    table.insert(dissMissAbductItent, scence_obj:QueryProp("Name"))
											--end
										end
										
										-- Đợi cóc theo thời gian hồi của cóc
										--nx_pause(buff_remain_second)
									end
								end
							end
                        end
                        i = i - 1
                        if i <= 0 then
                            break
                        end
                    end
                end
            end

            -- Bước 1: Chạy đi kiếm cóc
            if step == 1 then
                doAbductPos = nil

                -- Dữ liệu vị trí của map
                local posMap = dynamic_posmap
                if posMap == nil then
                    stop_type_dynamic()
                    tools_show_notice(nx_function("ext_utf8_to_widestr", "MAP này không hỗ trợ bắt cóc"))
                    return false
                end
                -- Tọa độ cần di chuyển hiện tại
                local pos = posMap[posOffset]
                if pos == nil and posOffset == 1 then
                    stop_type_dynamic()
                    tools_show_notice(nx_function("ext_utf8_to_widestr", "MAP này không hỗ trợ bắt cóc"))
                    return false
                end
                if not tools_move_isArrived2D(pos[1], pos[2], pos[3]) then
                    if intevalMessage == 0 then
                        tools_show_notice(nx_function("ext_utf8_to_widestr", "Di chuyển đến vị trí số " .. tostring(posOffset)))
						
						-- Dùng yên ngựa đôi và tật bôn (ngựa nhanh)
						if get_buff_info("buf_riding_01") ~= nil then
							--local form_shortcut_ride = nx_value("form_stage_main\\form_main\\form_main_shortcut_ride")
							--local grid = form_shortcut_ride.grid_shortcut_main
							--local game_shortcut = nx_value("GameShortcut")
							--if nx_is_valid(game_shortcut) then
							--	game_shortcut:on_main_shortcut_useitem(grid, 4, true)
							--	game_shortcut:on_main_shortcut_useitem(grid, 1, true)
							--end
						end
                    end
                    -- Số lần dịch chuyển nhỏ hơn 20 thì mới di chuyển
                    if direct_run_count < 20 then
                        local checkrun = tools_move_new(map, pos[1], pos[2], pos[3], direct_run)
                        direct_run = false
                        if checkrun == false then
                            direct_run_count = direct_run_count + 1
                        end
                    end
                    if direct_run_count >= 20 then
						
                        --suicidePlayer(true) -- Tự sát
                        isFindPathFalse = true
					elseif direct_run_count >= 15 then
                        -- Thử gọi file bên ngoài can thiệp để nhảy nhót
                        if fix_extautoit_executed == false then
                            tools_show_notice(nx_function("ext_utf8_to_widestr", "Xuống ngựa cũng không được, thử dùng Bạch Vân Cái Đỉnh"))
                            fix_extautoit_executed = true
							
							-- Dùng skill bạch vân cái đỉnh để thoát
							local fight = nx_value("fight")
							fight:TraceUseSkill("CS_jh_cqgf02", false, false)
                        end
                    elseif direct_run_count >= 8 then
                        -- Không di chuyển được thì xuống ngựa
                        if fix_ride_executed == false then
                            tools_show_notice(nx_function("ext_utf8_to_widestr", "Không di chuyển được, thử xuống ngựa"))
                            fix_ride_executed = true	
                        end
                        nx_execute("custom_sender", "custom_remove_buffer", "buf_riding_01")
                    end
                else
                    -- Đến điểm tìm cóc thì dừng một lát chờ load map
                    -- Set các bộ đếm di chuyển về 0 cho lần di chuyển tiếp theo
                    direct_run_count = 0
                    intevalMessage = -1
                    nx_pause(1)
                    -- Đến vị trí này rồi thì tăng posOffset
                    posOffset = posOffset + 1
					
					-- Nếu đã chạy hết vị trí thì dịch chuyển qua map phụ
                    if posOffset > table.getn(posMap) then
                        --posOffset = 1
							
						map_id = get_mapid_by_selectindex(form.combobox_sub_map)
						
						-- Update lại dữ liệu map
						local posMap = abductPos[map_id]
						if posMap == nil then
							yBreaker_show_Utf8Text("Lỗi dữ liệu posMap")
							is_vaild_data = false
						end

						local sellDataMap = abductSell[map_id]
						if sellDataMap == nil then
							yBreaker_show_Utf8Text("Lỗi dữ liệu sellDataMap")
							is_vaild_data = false
						end

						local waitpos = waitPosAfterSell[map_id]
						if waitpos == nil then
							yBreaker_show_Utf8Text("Lỗi dữ liệu waitpos")
							is_vaild_data = false
						end

						local homepoint = homePointReturn[map_id]
						if homepoint == nil or homepoint == {} then
							yBreaker_show_Utf8Text("Lỗi dữ liệu homepoint")
							is_vaild_data = false
						end

						dynamic_posmap = posMap
						dynamic_selldata = sellDataMap
						dynamic_waitpos = waitpos
						dynamic_homepoint = homepoint
						
						-- Dịch chuyển qua map phụ
						TeleToHomePoint(homePointReturn[map_id][1])
						nx_pause(10)
						
						-- Set lại vị trí số 1 của map mới
						posOffset = 1
                    end
                end
            elseif step == 2 then
                isReturnedHomePoint = false
                dissMissAbductItent = {}
                -- Dữ liệu bán cóc
                local sellDataMap = dynamic_selldata
                if sellDataMap == nil then
                    stop_type_dynamic()
                    tools_show_notice(nx_function("ext_utf8_to_widestr", "MAP này không hỗ trợ bắt cóc"))
                    return false
                end
                local sellData = sellDataMap[sellPosOffset]
                if sellData == nil then
                    stop_type_dynamic()
                    tools_show_notice(nx_function("ext_utf8_to_widestr", "MAP này không hỗ trợ bắt cóc"))
                    return false
                end
                -- Đi bán cóc
                -- Nếu mất buff thì thôi
                local buff_abductor = get_buff_info("buf_abductor")
                if buff_abductor == nil then
                    step = 1
                    isSPRideCalled = false
                    sellPosOffset = 1
                else
                    -- Xử lý đi bán cóc nếu bị kẹt
                    if not tools_move_isArrived2D(sellData.x, sellData.y, sellData.z) then
                        -- Khi bắt đầu tự tử thì không di chuyển nữa
                        if direct_run_count < 20 then
                            local checkrun = tools_move_new(map, sellData.x, sellData.y, sellData.z, direct_run_sell)
                            direct_run_sell = false
                            if checkrun == false then
                                direct_run_count = direct_run_count + 1
                            end
                        end
                        if direct_run_count >= 20 then
                            --suicidePlayer(true)
                            isFindPathFalse = true
                        elseif direct_run_count >= 15 then
                            -- Thử gọi file bên ngoài can thiệp để nhảy nhót
                            if fix_extautoit_executed == false then
                                tools_show_notice(nx_function("ext_utf8_to_widestr", "Xuống ngựa cũng không được, thử dùng Bạch Vân Cái Đỉnh"))
                                fix_extautoit_executed = true
								
								-- Dùng skill bạch vân cái đỉnh để thoát
								local fight = nx_value("fight")
								fight:TraceUseSkill("CS_jh_cqgf02", false, false)
                            end
                        elseif direct_run_count >= 8 then
                            -- Không di chuyển được thì xuống ngựa
                            if fix_ride_executed == false then
                                tools_show_notice(nx_function("ext_utf8_to_widestr", "Không di chuyển được, thử xuống ngựa"))
                                fix_ride_executed = true
                            end
                            nx_execute("custom_sender", "custom_remove_buffer", "buf_riding_01")
                        end
                    else
                        if buff_abduct == nil then
                            local game_scence_objs = game_scence:GetSceneObjList()

                            for i = 1, table.getn(game_scence_objs) do
                                if game_scence_objs[i]:FindProp("Type") and game_scence_objs[i]:QueryProp("Type") == 4 then
                                    local npc_id = game_scence_objs[i]:QueryProp("ConfigID")
                                    if npc_id == sellData.npc then
                                        -- Mở cái bảng nói chuyện
                                        local is_talking = false
                                        while is_talking == false do
                                            nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
                                            nx_pause(0.2)
                                            local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
                                            is_talking = form_talk.Visible
                                        end

                                        -- Bán con cóc
                                        nx_pause(0.2)
                                        nx_execute("form_stage_main\\form_talk_movie", "menu_select", 843000000) -- Nhìn xem ta đưa đến
                                        nx_pause(0.2)
                                        nx_execute("form_stage_main\\form_talk_movie", "menu_select", 843000004) -- Được
                                        nx_pause(1)

                                        -- Tắt cái form nói chuyện nếu có
                                        local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
                                        if form_talk.Visible == true then
                                            nx_execute("form_stage_main\\form_talk_movie", "menu_select", 843000005) -- Ta biết rồi
                                            nx_pause(0.2)
                                            nx_execute("form_stage_main\\form_talk_movie", "menu_select", 600000000) -- Để ta suy nghĩ lại
                                            nx_pause(0.2)
                                        end

                                        -- Tắt cái form nhận đồ
                                        nx_pause(0.2)
                                        local form_giveitems = util_get_form("form_stage_main\\form_give_item", true)
                                        if nx_is_valid(form_giveitems) then
                                            nx_pause(0.2)
                                            local form_giveitems1 = nx_value("form_stage_main\\form_give_item")
                                            if nx_is_valid(form_giveitems1) then
                                                nx_execute("form_stage_main\\form_give_item", "on_btn_mail_click", form_giveitems1.btn_mail)
                                            end
                                        end

                                        -- Tăng vị trí bán lên: Nếu quay lại mà vẫn còn buff ôm cóc thì đi bán chỗ khác, khi thổi con cóc khác thì sẽ reset
                                        sellPosOffset = sellPosOffset + 1
                                        if sellPosOffset > table.getn(sellDataMap) then
                                            sellPosOffset = 1
                                        end
										
										-- Chuyển đến step đợi sau khi bán cóc
										step = 5

                                        break
                                    end
                                end
                            end

                            -- Quay lại bước 1
                            step = 1
                            isSPRideCalled = false
                        end
                    end
                end
            elseif step == 3 then
                -- Di chuyển tới chỗ con cóc
                if doAbductPos ~= nil then
                    if not tools_move_isArrived2D(doAbductPos.x, doAbductPos.y, doAbductPos.z) then
                        local checkrun = tools_move_new(map, doAbductPos.x, doAbductPos.y, doAbductPos.z, direct_run)
                        direct_run = false
                        if checkrun == false then
                            direct_run_count = direct_run_count + 1
                        end
                        if direct_run_count >= 8 then
                            -- Nếu không tự tìm đường được thì bỏ qua con cóc này
                            tools_show_notice(nx_function("ext_utf8_to_widestr", "Cóc này không tự tìm đường được nên bỏ qua"))
                            if table.getn(dissMissAbductItent) > 70 then
                                dissMissAbductItent = {}
                            end
                            table.insert(dissMissAbductItent, doAbductPos.Name)
                            doAbductPos = nil
                            step = 1
                            direct_run_count = 0
                            fix_ride_executed = false
                            fix_extautoit_executed = false
                        end
                    else
                        -- Tới chỗ con cóc thì kiểm tra lại
                        local abduct = game_visual:GetSceneObj(nx_string(doAbductPos.Ident))
                        if nx_is_valid(abduct) then
                            -- Xác định khoảng cách 3D
                            local pxd = game_player.PositionX - abduct.PositionX
                            local pyd = game_player.PositionY - abduct.PositionY
                            local pzd = game_player.PositionZ - abduct.PositionZ
                            local distance = math.sqrt(pxd * pxd + pyd * pyd + pzd * pzd)
                            if distance < max_distance_selectauto then
                                -- Kiểm tra xem có ai đang bắt không
                                --if tools_have_nearabdut(doAbductPos.Ident) == -1 then
                                    -- Thổi con cóc
                                    used_abduct_item = true
                                    nx_execute("custom_sender", "custom_select", doAbductPos.Ident)
                                    nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", "offitem_miyao10")
                                --else
                                --    tools_show_notice(nx_function("ext_utf8_to_widestr", "Có người đang bắt rồi kiếm con khác không KS"))
                                --   table.insert(dissMissAbductItent, doAbductPos.Name)
                                --    doAbductPos = nil
                                --    step = 1
                                --end
                            else
                                tools_show_notice(nx_function("ext_utf8_to_widestr", "Quá xa con cóc"))
                                doAbductPos = nil
                                step = 1
                            end
                        else
                            tools_show_notice(nx_function("ext_utf8_to_widestr", "Bắt đầu nhặt cóc"))
                            doAbductPos = nil
                            step = 1
                        end
                    end
                else
                    step = 1
                end
            elseif step == 4 then
                -- Xuất chiêu đánh khô máu
                if logicstate == 1 then
                    local form_shortcut = nx_value("form_stage_main\\form_main\\form_main_shortcut")
                    local grid = form_shortcut.grid_shortcut_main
                    local game_shortcut = nx_value("GameShortcut")
                    if nx_is_valid(game_shortcut) then
                        game_shortcut:on_main_shortcut_useitem(grid, 0, true)
                        nx_pause(0.2)
                        game_shortcut:on_main_shortcut_useitem(grid, 1, true)
                        nx_pause(0.2)
                        game_shortcut:on_main_shortcut_useitem(grid, 2, true)
                        nx_pause(0.2)
                        game_shortcut:on_main_shortcut_useitem(grid, 3, true)
                        nx_pause(0.2)
                        game_shortcut:on_main_shortcut_useitem(grid, 4, true)
                        nx_pause(0.2)
                        game_shortcut:on_main_shortcut_useitem(grid, 5, true)
                    end
                else
                    step = 1
                end
            elseif step == 5 then
				--tools_show_notice(nx_function("ext_utf8_to_widestr", "Buff môi giới còn: ") .. util_text(nx_string(buff_abduct)))
				--tools_show_notice(nx_function("ext_utf8_to_widestr", "Thời gian cài đặt: ") .. util_text(nx_string(buff_count_time)))
                if (buff_abduct ~= nil and buff_abduct > buff_count_time) or isStopAuto or isAutoStoped then
				
                    -- Trong quá trình này thì xóa thư
                    if nx_is_valid(player_client) then
                        local rownum = player_client:GetRecordRows(Recv_rec_name)

                        for row = 0, rownum - 1 do
                            local ntype = player_client:QueryRecord(Recv_rec_name, row, POST_TABLE_TYPE)
                            local str_goods = nx_string(player_client:QueryRecord(Recv_rec_name, row, POST_TABLE_APPEDIXVALUE))
                            local serialno = nx_string(player_client:QueryRecord(Recv_rec_name, row, POST_TABLE_SERIALNO))
                            local gold = nx_int(player_client:QueryRecord(Recv_rec_name, row, POST_TABLE_GOLD))
                            local silver = nx_int(player_client:QueryRecord(Recv_rec_name, row, POST_TABLE_SILVER))

                            -- Xóa các thư của hệ thống, không tiền không vàng
                            -- Không có item hoặc chứa item thiết lập xóa
                            local itemID = getItemInMail(str_goods)
                            if  nx_int(ntype) > nx_int(LETTER_SYSTEM_TYPE_MIN) and nx_int(ntype) < nx_int(LETTER_SYSTEM_TYPE_MAX)
                                and gold <= nx_int(0) and silver <= nx_int(0)
                                and itemID == nx_string("fixitem_002")
                            then
                                -- Xóa vật phẩm thì set lại thời gian
                                nx_execute("custom_sender", "custom_del_letter_ok", 1, serialno)
                                break
                            end
                        end
                    end
					
                    -- Đứng im đây
                    if intevalMessage == 0 then
                        tools_show_notice(nx_function("ext_utf8_to_widestr", "Đang đợi lượt sau"))
                    end
					
					-- Thần hành về ĐHS
					-- Di chuyển tới đứng chỗ ẩn nếu đang đứng tại vị trí bán cóc :D
					local isStandOnSellPos = false
					for i = 1, table.getn(dynamic_selldata) do
						local sellpos = dynamic_selldata[i]
						if tools_move_isArrived2D(sellpos.x, sellpos.y, sellpos.z) then
							local pos = math.random(1, table.getn(dynamic_waitpos))
							local posData = dynamic_waitpos[pos]
							tools_move_new(map, posData[1], posData[2], posData[3], true)
							isStandOnSellPos = true
						end
					end
					-- Nếu đang đứng im thì kiểm tra xem trong phạm vi 1 mét chỗ mình đứng có ai ở đó không
					-- Khi đã trở về điểm dừng chân rồi thì bỏ qua phần kiểm tra này
					local haveStackUpObj = false
					if isStandOnSellPos == false and not isReturnedHomePoint then
						local isMoving = is_moving()
						if isMoving == false then
							local game_scence_objs = game_scence:GetSceneObjList()
							for i = 1, table.getn(game_scence_objs) do
								local obj = game_scence_objs[i]
								if nx_is_valid(obj) then
									local visualObj = game_visual:GetSceneObj(obj.Ident)
									if nx_is_valid(visualObj) then
										if obj:FindProp("Type") and obj:QueryProp("Type") == 2 and player_client:QueryProp("Name") ~= obj:QueryProp("Name") and obj:QueryProp("OffLineState") == 0 then
											-- Nếu có người đứng cách bán kính 0.8 mét
											if tools_move_isArrived2D(visualObj.PositionX, visualObj.PositionY, visualObj.PositionZ, 0.8) then
												haveStackUpObj = true
												-- Đánh dấu thời điểm có người đứng trùng
												if lastStackUpTime == 0 then
													lastStackUpTime = os.time()
												elseif tools_difftime(lastStackUpTime) > 2 then
													local pos = math.random(1, table.getn(dynamic_waitpos))
													local posData = dynamic_waitpos[pos]
													tools_move_new(map, posData[1], posData[2], posData[3], true)
													tools_show_notice(nx_function("ext_utf8_to_widestr", "Có người chiếm chỗ, đi chỗ khác đứng"))
													lastStackUpTime = 0
												end
											end
										end
									end
								end
							end
						end
					end
					-- Nếu không có ai đứng trùng thì reset lastStackUpTime
					if not haveStackUpObj then
						lastStackUpTime = 0
					end
					-- Nếu không có ai đứng trùng nữa và thiết lập về điểm dừng chân và chưa về điểm hồi sinh thì về
					if lastStackUpTime <= 0 and not haveStackUpObj and not isReturnedHomePoint and isReturnHomePoint and not is_moving() then
						-- Random cái điểm dừng chân
						local randHP = math.random(1, table.getn(dynamic_homepoint))
						local rand_dynamic_homepoint = dynamic_homepoint[randHP]
						if rand_dynamic_homepoint == nil then
							stop_type_dynamic()
							return false
						end

						-- Kiểm tra điểm dừng chân tồn tại
						local IsExists = false
						local HomePointCount = player_client:GetRecordRows("HomePointList")
						for i = 0, HomePointCount - 1 do
							if rand_dynamic_homepoint == player_client:QueryRecord("HomePointList", i, 0) then
								IsExists = true
								break
							end
						end

						-- Nếu chưa thêm điểm dừng chân
						if not IsExists then
							-- Xác định số điểm dừng chân đã mở
							local Max1 = player_client:QueryProp("JiangHuHomePointCount")
							if Max1 >= 2 then
								local Max2 = player_client:QueryProp("SchoolHomePointCount")
								local Max = Max1 + Max2
								-- Xác định điểm dừng chân giang hồ cuối cùng
								local LastHomePoint = ""
								local LastHomePointText = nx_widestr("")
								local CountJiangHuHomePoint = 0
								for i = 0, Max do
									local _hp = player_client:QueryRecord("HomePointList", i, 0)
									if _hp == 0 then
										break
									end
									local typename, htext = get_type_homepoint(_hp)
									if typename == "0" or typename == "1" then
										LastHomePoint = _hp
										LastHomePointText = util_text(nx_string(htext))
										CountJiangHuHomePoint = CountJiangHuHomePoint + 1
									end
								end
								-- Xóa cái điểm dừng chân cuối cùng đi
								if CountJiangHuHomePoint > 1 and LastHomePoint ~= "" then
									tools_show_notice(nx_function("ext_utf8_to_widestr", "Xóa điểm dừng chân: ") .. LastHomePointText)
									send_homepoint_msg_to_server(3, LastHomePoint) -- 3: Xóa điểm dừng chân
									nx_pause(0.5)
								end
								local typename, htext = get_type_homepoint(rand_dynamic_homepoint)
								tools_show_notice(nx_function("ext_utf8_to_widestr", "Thêm điểm dừng chân: ") .. util_text(nx_string(htext)))
								send_homepoint_msg_to_server(2, rand_dynamic_homepoint) -- 2: Thêm điểm dừng chân
								nx_pause(0.5)
							end
						end

						send_homepoint_msg_to_server(1, rand_dynamic_homepoint, 4) -- 1: Trở về điểm dừng chân 4: Điểm dừng chân giang hồ
						isReturnedHomePoint = true
						nx_pause(10)
						nx_pause(10)
						nx_pause(10)
						if get_buff_info("buf_riding_01") ~= nil then
							nx_execute("custom_sender", "custom_remove_buffer", "buf_riding_01")
						end
					end
                else
                    isSPRideCalled = false
                    step = 1
                end
            elseif step == 6 then
                if buf_offline_abduct_fail ~= nil then
                    -- Đứng im đây, bi định thân
                else
                    step = 1
                end
            end

            intevalMessage = intevalMessage + 1
            if intevalMessage >= 50 then
                intevalMessage = 0
            end
        end

        nx_pause(0.2)
    end
end

-- Xem thử bên cạnh có người bị định thân không
-- Nếu có trả về thời gian còn lại
-- Nếu không có trả về -1
function tools_have_nearabdut(ident)
    -- ident của con cóc
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return -1
    end
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return -1
    end
    local game_scence = game_client:GetScene()
    if not nx_is_valid(game_scence) then
        return -1
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return -1
    end
    local MessageDelay = nx_value("MessageDelay")
    if not nx_is_valid(MessageDelay) then
        return -1
    end
    local abduct = game_visual:GetSceneObj(nx_string(ident))
    if not nx_is_valid(abduct) then
        return -1
    end
    local gui = nx_value("gui")
    -- Xác định tọa độ con cóc
    local objX = abduct.PositionX
    local objY = abduct.PositionY
    local objZ = abduct.PositionZ
    -- Quét bên cạnh
    local game_scence_objs = game_scence:GetSceneObjList()
    for i = 1, table.getn(game_scence_objs) do
        local obj = game_scence_objs[i]
        if nx_is_valid(obj) then
            local visualObj = game_visual:GetSceneObj(obj.Ident)
            if nx_is_valid(visualObj) then
                if obj:FindProp("Type") and obj:FindProp("Type") and obj:QueryProp("Type") == 2 and player_client:QueryProp("Name") ~= obj:QueryProp("Name") then
                    -- Xác định khoảng cách 3D
                    local pxd = objX - visualObj.PositionX
                    local pyd = objY - visualObj.PositionY
                    local pzd = objZ - visualObj.PositionZ
                    local distance = math.sqrt(pxd * pxd + pyd * pyd + pzd * pzd)
                    if distance < 6 then
                        -- Xem thử có định thân hay không
                        for j = 1, 25 do
                            local buff = obj:QueryProp("BufferInfo" .. tostring(j))
                            if buff ~= 0 then
                                local buff_info = util_split_string(buff, ",")
                                if buff_info[1] == "buf_offline_abduct_fail" then
                                    local server_now_time = MessageDelay:GetServerNowTime()
                                    local buff_diff_time = nx_int((buff_info[4] - server_now_time) / 1000) -- Unit timesamp
                                    return buff_diff_time
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return -1
end

-- Di chuyển tới vị trí
-- Nếu trigger di chuyển thì trả về false
-- Nếu không trigger thì trả về true
function tools_move_new(scene, x, y, z, passtest)
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return true
    end
    local game_player = game_visual:GetPlayer()
    if not nx_is_valid(game_player) then
        return true
    end
    if passtest ~= nil and passtest == true then
        tools_show_notice(nx_function("ext_utf8_to_widestr", "Bắt đầu tìm đường"))
        nx_value("path_finding"):FindPathScene(scene, x, y, z, 0)
        return false
    end
    local beforeX = string.format("%.3f", game_player.PositionX)
    local beforeY = string.format("%.3f", game_player.PositionY)
    local beforeZ = string.format("%.3f", game_player.PositionZ)
    nx_pause(0.4)
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return true
    end
    local game_player = game_visual:GetPlayer()
    if not nx_is_valid(game_player) then
        return true
    end
    local afterX = string.format("%.3f", game_player.PositionX)
    local afterY = string.format("%.3f", game_player.PositionY)
    local afterZ = string.format("%.3f", game_player.PositionZ)

    local pxd = beforeX - afterX
    local pyd = beforeY - afterY
    local pzd = beforeZ - afterZ

      local distance = math.sqrt(pxd * pxd + pyd * pyd + pzd * pzd)
      if distance <= 0.6 then
        tools_show_notice(nx_function("ext_utf8_to_widestr", "Bắt đầu tìm đường"))
        nx_value("path_finding"):FindPathScene(scene, x, y, z, 0)
        return false
      end
    return true
end

function set_form_type_dynamic(form)

    if not nx_is_valid(form) then
        return 0
    end
	
    form.cbtn_dynamic_fight.Checked = true
    form.cbtn_dynamic_usespride.Checked = false
    form.cbtn_dynamic_returnhomepoint.Checked = false
    form.cbtn_dynamic_stop_if_beattacked.Checked = true
    form.cbtn_dynamic_chat_attacker.Checked = false
	form.cbtn_dynamic_help_me.Checked = true
	form.cbtn_dynamic_help_me_guild.Checked = false
	form.cbtn_dynamic_help_me_league.Checked = false
	form.cbtn_dynamic_help_me_team.Checked = true
	form.cbtn_dynamic_help_me_row.Checked = true

    local map = get_current_map()

    form.btn_dynamic_control.Text = nx_widestr("...")
    form.combobox_main_map.Text = util_text("school08")
    form.combobox_sub_map.Text = util_text("school05")
	
	-- Add main map for combobox
    local combobox_main_map = form.combobox_main_map
	-- Clear data before add new data
	combobox_main_map.DropListBox:ClearString()
	
    if combobox_main_map.DroppedDown then
        combobox_main_map.DroppedDown = false
    end

	add_string_to_combobox(combobox_main_map)
	combobox_main_map.DropListBox.SelectIndex = 0
	
	-- Add sub map for combobox
    local combobox_sub_map = form.combobox_sub_map
	-- Clear data before add new data
	combobox_sub_map.DropListBox:ClearString()
	
    if combobox_sub_map.DroppedDown then
        combobox_sub_map.DroppedDown = false
    end
	
	add_string_to_combobox(combobox_sub_map)
	combobox_sub_map.DropListBox.SelectIndex = 1

    if not nx_function("ext_is_file_exist", nx_work_path() .. DATA_ABDUCT_PATH) then
		yBreaker_show_Utf8Text("Lỗi file dữ liệu data_abduct.lua")
        return 0
    end

    -- Add file data abduct
    local file = assert(loadfile(nx_work_path() .. DATA_ABDUCT_PATH))
    file()

    -- Hạn giờ bắt cóc
    local combobox_lt1 = form.combobox_dynamic_limittime_from
	-- Clear data before add new data
	combobox_lt1.DropListBox:ClearString()
	
    if combobox_lt1.DroppedDown then
        combobox_lt1.DroppedDown = false
    end
    combobox_lt1.DropListBox:AddString(nx_function("ext_utf8_to_widestr", "Không Giới Hạn"))
    local combobox_lt2 = form.combobox_dynamic_limittime_to
	-- Clear data before add new data
	combobox_lt2.DropListBox:ClearString()
	
    if combobox_lt2.DroppedDown then
        combobox_lt2.DroppedDown = false
    end
    combobox_lt2.DropListBox:AddString(nx_function("ext_utf8_to_widestr", "Không Giới Hạn"))
    for j = 1, 24 do
        combobox_lt1.DropListBox:AddString(nx_widestr(j - 1))
        combobox_lt2.DropListBox:AddString(nx_widestr(j - 1))
    end
    combobox_lt1.Text = nx_function("ext_utf8_to_widestr", "Không Giới Hạn")
    combobox_lt2.Text = nx_function("ext_utf8_to_widestr", "Không Giới Hạn")
	
	-- Count time combobox
	local combobox_count_time = form.combobox_count_time
	
    combobox_count_time.Text = nx_widestr("8")
    combobox_count_time.DropListBox:ClearString()
	
    if combobox_count_time.DroppedDown then
        combobox_count_time.DroppedDown = false
    end
	
	-- Add string count time combobox
	for i = 1, 59 do
        combobox_count_time.DropListBox:AddString(nx_widestr(tostring(i)))
    end
	
	-- Delay time of abduct buff in combobox
	local combobox_buff_time = form.combobox_buff_time
	
    combobox_buff_time.Text = nx_widestr("8")
    combobox_buff_time.DropListBox:ClearString()
	
    if combobox_buff_time.DroppedDown then
        combobox_buff_time.DroppedDown = false
    end
	
	-- Add string count time combobox
	for i = 0, 60 do
        combobox_buff_time.DropListBox:AddString(nx_widestr(tostring(i)))
    end
	
    dynamic_posmap = posMap
    dynamic_selldata = sellDataMap
    dynamic_waitpos = waitpos
    dynamic_homepoint = homepoint

    form.btn_dynamic_control.Text = nx_function("ext_utf8_to_widestr", "Chạy")
	form.btn_dynamic_control.ForeColor = "255,255,255,255"
end

function stop_type_dynamic()
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return
    end
    auto_is_running_dynamic = false
    if form.btn_dynamic_control.Text ~= nx_widestr("...") then
        form.btn_dynamic_control.Text = nx_function("ext_utf8_to_widestr", "Chạy")
		form.btn_dynamic_control.ForeColor = "255,255,255,255"
    end
    --reset_window_title()
end

function start_type_dynamic()
	local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return
    end
	auto_is_running_dynamic = true
    if form.btn_dynamic_control.Text ~= nx_widestr("...") then
        form.btn_dynamic_control.Text = nx_function("ext_utf8_to_widestr", "Dừng")
		form.btn_dynamic_control.ForeColor = "255,220,20,60"
        auto_run_dynamic()
    end   
end

function on_form_main_init(form)
    form.Fixed = false
    form.is_minimize = false
end

function on_main_form_open(form)
    isFindPathFalse = false
    change_form_size()
    form.is_minimize = false
    set_form_type_dynamic(form)
end

function on_main_form_close(form)
    isFindPathFalse = false
    auto_is_running_dynamic = false
    nx_destroy(form)
end

function on_btn_close_click(btn)
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return
    end
    on_main_form_close(form)
end

function on_btn_dynamic_control_click(btn)
    if btn.Text == nx_widestr("...") then
        return 0
    end
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
    if auto_is_running_dynamic then
        stop_type_dynamic()
    else
        auto_is_running_dynamic = true
        btn.Text = nx_function("ext_utf8_to_widestr", "Dừng")
		btn.ForeColor = "255,220,20,60"
        isCompleteBeauseAttacker = false
        auto_run_dynamic()
    end
end

function change_form_size()
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return
    end
    local gui = nx_value("gui")
    --form.Left = (gui.Width - form.Width) / 2
    --form.Top = (gui.Height - form.Height) / 2
    form.Left = 100
    form.Top = 140
	form.cbtn_dynamic_returnhomepoint.Visible = false
	form.lbl_dynamic_returnhomepoint.Visible = false
end

-- function on_cbtn_dynamic_fight_changed(cbtn)
--     stop_type_dynamic()
-- end

-- function on_cbtn_dynamic_stop_if_beattacked_changed(cbtn)
--     stop_type_dynamic()
-- end

-- function on_cbtn_dynamic_chat_attacker_changed(cbtn)
--     stop_type_dynamic()
-- end

-- function on_cbtn_dynamic_help_me_changed(cbtn)
--     stop_type_dynamic()
-- end

-- function on_cbtn_dynamic_help_me_guild_changed(cbtn)
--     stop_type_dynamic()
-- end

-- function on_cbtn_dynamic_help_me_league_changed(cbtn)
--     stop_type_dynamic()
-- end

-- function on_cbtn_dynamic_help_me_team_changed(cbtn)
--     stop_type_dynamic()
-- end

-- function on_cbtn_dynamic_help_me_row_changed(cbtn)
--     stop_type_dynamic()
-- end

-- function on_cbtn_dynamic_usespride_changed(cbtn)
--     stop_type_dynamic()
-- end

-- function on_cbtn_dynamic_returnhomepoint_changed(cbtn)
--     stop_type_dynamic()
-- end

function on_combobox_count_time_selected(combobox)
	-- Update value for buff_count_time
	buff_cnt_time = nx_number(combobox.Text) * 60
end

function get_type_homepoint(type_name)
    local ini = nx_execute("util_functions", "get_ini", HOMEPOINT_INI_FILE)
    if not nx_is_valid(ini) then
        return "", ""
    end
    local index = ini:FindSectionIndex(nx_string(type_name))
    if index < 0 then
        return "", ""
    end
    local hp = ini:ReadString(index, "Type", "")
    local htext = ini:ReadString(index, "Name", "")
    return hp, htext
end

function send_homepoint_msg_to_server(...)
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return
    end
    game_visual:CustomSend(nx_int(CLIENT_CUSTOMMSG_SET_HOMEPOINT), unpack(arg))
end

-- Vứt bỏ con cóc đang ôm
function throwAbduct()
    if get_buff_info("buf_abductor") == nil then
        return false
    end
    local game_visual = nx_value("game_visual")
    if nx_is_valid(game_visual) then
        game_visual:CustomSend(nx_int(CLIENT_CUSTOMMSG_OFFLINE_GIVEUP_ABDUCT))
    end
    local form = nx_execute("util_gui", "util_get_form", "form_stage_main\\form_offline\\form_offline_abduct_tip", false, false)
    if nx_is_valid(form) and form.Visible then
        form:Close()
    end
end

-- Lấy danh sách các người đánh mình hoặc đang target vào mình
-- Trả về mảng dạng test thuần
function getListAttacker()
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return {}
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return {}
    end
    local game_scence = game_client:GetScene()
    if not nx_is_valid(game_scence) then
        return {}
    end
    local fight = nx_value("fight")
    if not nx_is_valid(fight) then
        return {}
    end
    local listAttackersID = {}
    local game_scence_objs = game_scence:GetSceneObjList()
    for i = 1, table.getn(game_scence_objs) do
        local obj = game_scence_objs[i]
        if nx_is_valid(obj) then
            if (fight:CanAttackPlayer(player_client, obj) and obj:QueryProp("IsAbductor") == 0) or nx_string(player_client.Ident) == nx_string(obj:QueryProp("LastObject")) then
                -- Tên đối thủ
                local attackerName = nx_function("ext_widestr_to_utf8", obj:QueryProp("Name"))
                -- Thực Lực Đối Thủ
                local attackerLevel = nx_function("ext_widestr_to_utf8", util_text(nx_string("desc_") .. nx_string(obj:QueryProp("LevelTitle"))))
                -- Bang
                local attackerGuide = "Không có bang"
                if nx_widestr(obj:QueryProp("GuildName")) ~= nx_widestr("0") then
                    attackerGuide = nx_function("ext_widestr_to_utf8", nx_widestr(obj:QueryProp("GuildName")))
                end
                local attackerPos = nx_function("ext_widestr_to_utf8", nx_widestr(nx_int(obj.DestX)) .. nx_widestr(", ") .. nx_widestr(nx_int(obj.DestZ)))
				
				--local attackerIdent = nx_string(obj.Ident)

                table.insert(listAttackersID, {
                    name = attackerName,
                    level = attackerLevel,
                    guide = attackerGuide,
                    position = attackerPos,
					--ident = attackerIdent
                })
            end
        end
    end
    return listAttackersID
end

function isBreakAttacker()
    return isCompleteBeauseAttacker, lastBeingAttacked
end

function isWrongFindPath()
    return isFindPathFalse
end

----------------------------------------------
-- Lấy item trong thư
-- Nếu trả về rỗng là không có item
-- Nếu trả về dấu - tức là chưa xác định được
-- Còn lại sẽ trả về configID của item đó
function getItemInMail(str_goods)
    local xmldoc = nx_create("XmlDocument")
    if not nx_is_valid(xmldoc) then
        return "-"
    end
    if not xmldoc:ParseXmlData(str_goods, 1) then
        nx_destroy(xmldoc)
        return ""
    end
    local xmlroot = xmldoc.RootElement
    local xmlelement = xmlroot:GetChildByIndex(0)
    if not nx_is_valid(xmlelement) then
        nx_destroy(xmldoc)
        return ""
    end
    local configid = xmlelement:QueryAttr("Config")
    if nx_string(configid) == "" then
        nx_destroy(xmldoc)
        return ""
    end
    nx_destroy(xmldoc)
    return nx_string(configid)
end

--
function show_hide_form_doabduct()
	util_auto_show_hide_form(THIS_FORM)
end

function add_string_to_combobox(combobox)
	-- Thiếu Lâm
    combobox.DropListBox:AddString(util_text("school08"))
	-- Đường Môn
	combobox.DropListBox:AddString(util_text("school05"))
	-- Võ Đang
	combobox.DropListBox:AddString(util_text("school07"))
	-- Nga Mi
	combobox.DropListBox:AddString(util_text("school06"))
	-- Cái Bang
	combobox.DropListBox:AddString(util_text("school02"))
	-- Cẩm Y Vệ
	combobox.DropListBox:AddString(util_text("school01"))
	-- Quân Tử Đường
	combobox.DropListBox:AddString(util_text("school03"))
	-- Cực Lạc Cốc
	combobox.DropListBox:AddString(util_text("school04"))
	-- Thành Đô
	combobox.DropListBox:AddString(util_text("city05"))
	-- Tô Châu
	combobox.DropListBox:AddString(util_text("city02"))
	-- Kim Lăng
	combobox.DropListBox:AddString(util_text("city03"))
	-- Lạc Dương
	combobox.DropListBox:AddString(util_text("city04"))
	-- Yến Kinh
	combobox.DropListBox:AddString(util_text("city01"))
end

function get_mapid_by_selectindex(combobox)
	local map_id = ""
	if combobox.DropListBox.SelectIndex == 0 then
		map_id = "school08"
	elseif combobox.DropListBox.SelectIndex == 1 then
		map_id = "school05"
	elseif combobox.DropListBox.SelectIndex == 2 then
		map_id = "school07"
	elseif combobox.DropListBox.SelectIndex == 3 then
		map_id = "school06"
	elseif combobox.DropListBox.SelectIndex == 4 then
		map_id = "school02"
	elseif combobox.DropListBox.SelectIndex == 5 then
		map_id = "school01"
	elseif combobox.DropListBox.SelectIndex == 6 then
		map_id = "school03"
	elseif combobox.DropListBox.SelectIndex == 7 then
		map_id = "school04"
	elseif combobox.DropListBox.SelectIndex == 8 then
		map_id = "city05"
	elseif combobox.DropListBox.SelectIndex == 9 then
		map_id = "city02"
	elseif combobox.DropListBox.SelectIndex == 10 then
		map_id = "city03"
	elseif combobox.DropListBox.SelectIndex == 11 then
		map_id = "city04"
	elseif combobox.DropListBox.SelectIndex == 12 then
		map_id = "city01"
	end
	
	return map_id
end

function IsRunning()
    return auto_is_running_dynamic
end

function CanRun()
    return not IsTaskDone()
end

function IsTaskDone()
	local buff_abduct = get_buff_info("buf_offline_abduct_cd")
	
	-- Get buff cóc trên người theo thời gian cài đặt trên form
	if buff_abduct ~= nil then
		if buff_abduct > buff_cnt_time then
			return true
		end
	end
    return false
end

function Start()
	util_show_form(THIS_FORM, true)
	start_type_dynamic()
	--nx_execute("admin_zdn\\zdn_event_manager", "Subscribe", Logic, "on-task-stop", nx_current(), "onTaskStop")
end

function Stop()
	stop_type_dynamic()
	
	local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return
    end
	--on_main_form_close(form)
	nx_execute("admin_zdn\\zdn_event_manager", "TriggerEvent", nx_current(), "on-task-stop")
end