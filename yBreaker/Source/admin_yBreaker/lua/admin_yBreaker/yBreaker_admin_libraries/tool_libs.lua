require("util_gui")
require("util_static_data")
require("util_functions")
require("share\\server_custom_define")
require("define\\sysinfo_define")
require("share\\chat_define")
require("define\\request_type")
require("form_stage_main\\form_homepoint\\form_home_point")
require("form_stage_main\\form_homepoint\\home_point_data")

local inspect = require("admin_yBreaker\\yBreaker_admin_libraries\\inspect")
local md5 = require("admin_yBreaker\\yBreaker_admin_libraries\\md5")
local trueKey = "eddb37578a4591658daa476d3621ebf6"
local trueKeyTrack = "1e8ed8dce18f7aa8bb6c2c700ad9df7e"
local isAdmRightSet = nil
local isDismissTrackSet = nil
local player_max_neigong = ""
local player_max_neigong_name = ""
local findPathBusy = false
local testFileTableRun = {}
local suitPlayer = ""
local tool_pvptaolu = nil
local tool_pvpbinhthu = nil
local suitDefault = {
    Hat = "",
    Cloth = "",
    Pants = "",
    Shoes = "",
    Cloak = "",
    Waist = "",
    Back = "",
    Face = "",
    Mount = ""
}
local suitCurrentData = {}
local suitCurrentActive = -1
local weaponCurrentData = {
    [1] = "", -- Đơn kiếm
    [2] = "", -- Song kiếm
    [3] = "", -- Đơn đao
    [4] = "", -- Song đao
    [5] = "", -- Đoản côn
    [6] = "", -- Trường côn
    [7] = "", -- Đoản kiếm
    [8] = "", -- Song thích
    [9] = ""  -- Cung
}
local weaponCurrentPlayer = ""
local SubType2TtemType = {
    [1] = ITEMTYPE_WEAPON_SWORD, -- Đơn kiếm
    [2] = ITEMTYPE_WEAPON_SSWORD, -- Song kiếm
    [3] = ITEMTYPE_WEAPON_BLADE, -- Đơn đao
    [4] = ITEMTYPE_WEAPON_SBLADE, -- Song đao
    [5] = ITEMTYPE_WEAPON_COSH, -- Đoản côn
    [6] = ITEMTYPE_WEAPON_STUFF, -- Trường côn
    [7] = ITEMTYPE_WEAPON_THORN, -- Đoản kiếm
    [8] = ITEMTYPE_WEAPON_STHORN, -- Song thích
    [9] = ITEMTYPE_WEAPON_BOW -- Cung
}

MY_TRACK_LOGIN_URL = "http://track.writeblabla.com/cacktracking/"
MY_CLIENT_ID = "admin"
--MY_CLIENT_ID = "thu"
--MY_CLIENT_ID = "linh"
--MY_CLIENT_ID = "mong"
--MY_CLIENT_ID = "kinhkha"
--MY_CLIENT_ID = "soi"

local secondWordBackup = nil

function setSecondWord(value)
    secondWordBackup = value
end

function getSecondWord()
    return secondWordBackup
end

function tools_reload_cache()
    isAdmRightSet = nil
    isDismissTrackSet = nil
    player_max_neigong = ""
    player_max_neigong_name = ""
    testFileTableRun = {}
    suitPlayer = ""
    suitCurrentData = suitDefault
    suitCurrentActive = -1
    weaponCurrentData = {
        [1] = "", -- Đơn kiếm
        [2] = "", -- Song kiếm
        [3] = "", -- Đơn đao
        [4] = "", -- Song đao
        [5] = "", -- Đoản côn
        [6] = "", -- Trường côn
        [7] = "", -- Đoản kiếm
        [8] = "", -- Song thích
        [9] = ""  -- Cung
    }
    weaponCurrentPlayer = ""
    tool_pvptaolu = nil
    tool_pvpbinhthu = nil
end

function tools_show_notice(info, noticetype)
    if noticetype == nil then
        noticetype = 3
    end
    local SystemCenterInfo = nx_value("SystemCenterInfo")
    if not nx_is_valid(SystemCenterInfo) then
        return false
    end
    SystemCenterInfo:ShowSystemCenterInfo(info, noticetype)
end

function tools_difftime(t)
    if t == nil then
        return os.time()
    end
    return os.difftime(os.time(), t)
end

function in_array(item, array)
    for _,v in pairs(array) do
        if v == item then
            return true
        end
    end
    return false
end

function console(str, isdebug)
    local file = io.open("D:\\log.txt", "a")
    if file == nil then
        nx_value("SystemCenterInfo"):ShowSystemCenterInfo(nx_widestr("Can't open file D:\\log.txt, please check this file!"), 3)
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

function consoleAttacker(str, isdebug)
    local file = io.open("D:\\logAttacker.txt", "a")
    if file == nil then
        nx_value("SystemCenterInfo"):ShowSystemCenterInfo(nx_widestr("Can't open file D:\\logAttacker.txt, please check this file!"), 3)
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

function tools_move(scene, x, y, z, passtest, findonlymap)
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return false
    end
    local game_player = game_visual:GetPlayer()
    if not nx_is_valid(game_player) then
        return false
    end
    if passtest ~= nil and passtest == true then
        tools_show_notice(nx_function("ext_utf8_to_widestr", "Bắt đầu tìm đường"))
        if findonlymap == nil then
            nx_value("path_finding"):FindPathScene(scene, x, y, z, 0)
        else
            nx_value("path_finding"):FindPath(x, y, z, 0)
        end
        return true
    end
    local beforeX = string.format("%.3f", game_player.PositionX)
    local beforeY = string.format("%.3f", game_player.PositionY)
    local beforeZ = string.format("%.3f", game_player.PositionZ)
    nx_pause(1)
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return false
    end
    local game_player = game_visual:GetPlayer()
    if not nx_is_valid(game_player) then
        return false
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
        if findonlymap == nil then
            nx_value("path_finding"):FindPathScene(scene, x, y, z, 0)
        else
            nx_value("path_finding"):FindPath(x, y, z, 0)
        end
      end
end

----------------------------------
-- Kiểm tra đến tọa độ 3D x, y, z chưa
-- offset khoảng cách xem là đến
-- fixedComparePos bỏ giá trị này thì lấy tọa độ của mình để so sánh
function tools_move_isArrived(x, y, z, offset, fixedComparePos)
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return false
    end
    local game_player = game_visual:GetPlayer()
    if not nx_is_valid(game_player) then
        return false
    end
    if offset == nil then
        offset = 1
    end

    local px, py, pz
    if fixedComparePos == nil then
        px = string.format("%.3f", game_player.PositionX)
        py = string.format("%.3f", game_player.PositionY)
        pz = string.format("%.3f", game_player.PositionZ)
    else
        px = string.format("%.3f", fixedComparePos[1])
        py = string.format("%.3f", fixedComparePos[2])
        pz = string.format("%.3f", fixedComparePos[3])
    end

    local pxd = px - x
    local pyd = py - y
    local pzd = pz - z

    local distance = math.sqrt(pxd * pxd + pyd * pyd + pzd * pzd)

    if offset >= distance then
        return true
    end
    return false
end

function tools_move_isArrived2D(x, y, z, offset, fixedComparePos)
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return false
    end
    local game_player = game_visual:GetPlayer()
    if not nx_is_valid(game_player) then
        return false
    end
    if offset == nil then
        offset = 1
    end

    local px, py, pz
    if fixedComparePos == nil then
        px = string.format("%.3f", game_player.PositionX)
        py = string.format("%.3f", game_player.PositionY)
        pz = string.format("%.3f", game_player.PositionZ)
    else
        px = string.format("%.3f", fixedComparePos[1])
        py = string.format("%.3f", fixedComparePos[2])
        pz = string.format("%.3f", fixedComparePos[3])
    end

    local pxd = px - x
    local pyd = py - y
    local pzd = pz - z

    local distance = math.sqrt(pxd * pxd + pzd * pzd)

    if offset >= distance then
        return true
    end
    return false
end

function get_buff_info(buff_id, obj)
    -- Nếu tồn tại buff_id thì trả về thời gian của buff đó, nếu buff không có thời gian thì trả về 0
    -- Nếu không tồn tại buff thì thả về nil
    local objGetBuff = nil
    if obj == nil then
        local game_client = nx_value("game_client")
        if not nx_is_valid(game_client) then
            return nil
        end
        objGetBuff = game_client:GetPlayer()
    else
        objGetBuff = obj
    end
    if not nx_is_valid(objGetBuff) then
        return nil
    end
    for i = 1, 25 do
        local buff = objGetBuff:QueryProp("BufferInfo" .. tostring(i))
        if buff ~= 0 and buff ~= "" then
            local buff_info = util_split_string(buff, ",")
            local buff_name = nx_string(buff_info[1])
            if nx_string(buff_id) == nx_string(buff_name) then
                local buff_time = buff_info[4]
                if nx_int(buff_time) == nx_int(0) then
                    return 0
                end
                local MessageDelay = nx_value("MessageDelay")
                if not nx_is_valid(MessageDelay) then
                    return nil
                end
                local server_now_time = MessageDelay:GetServerNowTime()
                local buff_diff_time = tonumber((buff_time - server_now_time) / 1000) -- Unit timesamp
                return buff_diff_time
            end
        end
    end
    return nil
end

function print_r(t)
    local text_table = ""
    local print_r_cache = {}

    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            text_table = text_table .. indent .. "*" .. tostring(t) .. "\n"
        else
            print_r_cache[tostring(t)] = true

            if (type(t) == "table") then
                for pos, val in pairs(t) do
                    if (type(val) == "table") then
                        text_table = text_table .. indent.."["..pos.."] => "..tostring(t).." {" .. "\n"
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        text_table = text_table .. indent..string.rep(" ",string.len(pos)+6).."}" .. "\n"
                    elseif (type(val)=="string") then
                        text_table = text_table .. indent.."["..pos..'] => "'..val..'"' .. "\n"
                    else
                        text_table = text_table .. indent.."["..pos.."] => "..tostring(val) .. "\n"
                    end
                end
            else
                text_table = text_table .. indent..tostring(t) .. "\n"
            end
        end
    end
    if (type(t)=="table") then
        text_table = text_table .. tostring(t).." {" .. "\n"
        sub_print_r(t,"    ")
        text_table = text_table .. "}" .. "\n"
    else
        sub_print_r(t,"    ")
    end
    return text_table
end

function auto_capture_qt(obj_list)
    if obj_list == nil then
        local game_client = nx_value("game_client")
        if not nx_is_valid(game_client) then
            return false
        end
        local game_scence = game_client:GetScene()
        if not nx_is_valid(game_scence) then
            return false
        end
        obj_list = game_scence:GetSceneObjList()
    end
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return false
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return false
    end
    local obj_num = table.getn(obj_list)
    local has_qt = false
    for i = 1, obj_num do
        if  obj_list[i]:FindProp("Type") and obj_list[i]:QueryProp("Type") == 4
            and obj_list[i]:FindProp("ConfigID")
            and nx_is_valid(player_client) and nx_string(player_client.Ident) == nx_string(obj_list[i]:QueryProp("TraceObject"))
        then
            local npc_id = obj_list[i]:QueryProp("ConfigID")
            local qt_data = get_qt_data(npc_id)
            local npc_ident = nx_property(obj_list[i], "Ident")
            if qt_data ~= false and npc_ident ~= nil then
                -- Mở cái bảng nói chuyện
                local is_talking = false
                local num_select_NPC = 0
                while (is_talking == false and num_select_NPC < 30) do
                    num_select_NPC = num_select_NPC + 1
                    nx_execute("custom_sender", "custom_select", npc_ident)
                    nx_pause(0.2)
                    local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
                    is_talking = form_talk.Visible
                end

                -- Cuộc hội thoại nhận kỳ ngộ
                for j = 1, table.getn(qt_data) do
                    nx_pause(0.6)
                    nx_execute("form_stage_main\\form_talk_movie", "menu_select", qt_data[j])
                end

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

                has_qt = true
                break
            end
        end
    end

    if has_qt == true then
        local game_client = nx_value("game_client")
        if not nx_is_valid(game_client) then
            return false
        end
        local game_scence = game_client:GetScene()
        if not nx_is_valid(game_scence) then
            return false
        end
        return game_scence:GetSceneObjList()
    else
        return obj_list
    end
end

function get_qt_data(npc_id)
    -- Thành Trường Nghĩa (Đả Cẩu Bổng)
    if npc_id == "gb340" then
        return {"841002737", "841002738", "840027381"}
    end
    -- Thù Di (Tham Hợp Chỉ)
    if npc_id == "Npc_qygp_chz_002" then
        return {"841006739", "840067390"}
    end
    -- Tiêu Dao Sơn Nhân (Thái Cực Quyền)
    if npc_id == "wd004" then
        return {"841001121", "841001122", "841001123", "840011231"}
    end
    -- Từ Lão Hán (Nữ Nhi Hồng x4)
    -- if npc_id == "npc_qygp_zy_xlh2" then
    --     return {"841004884", "841004885", "100011213", "101011213"}
    -- end
    -- Tiểu Mẫn (Thiết 1)
    if npc_id == "npc_qy_luxia_xiaomin_0" then
        return {"841005683", "100012257", "101012257"}
    end
    -- Tô Tú Vân (Thiết 2)
    --if npc_id == "WorldNpc01146" then
    --	return {"841001445", "840014451"}
    --end
    -- Ô Hạ (Nữ Nhi Hồng x4)
    -- if npc_id == "npc_qygp_cc_wu" then
    --     return {"841004886", "100018911", "101018911"}
    -- end
    -- Bốc Man Tài (Gà Nướng Trui)
    -- if npc_id == "NPC_qygp_bybukuai" then
    --     return {"841004952", "100018240", "101018240"}
    -- end
    -- Trần Tiểu Thành (Nghịch Thiên Tà Công)
    if npc_id == "funnpcskill002001" then
        return {"841004298", "841004299", "841004300", "840043000"}
    end
    -- Nhạc Minh Kha (Mảnh Thác Bản)
    if npc_id == "WorldNpc_qywx_007" then
        return {"841006152", "100010345", "101010345"}
    end
    -- Ngô Quỳnh (Kim Ngân Hoa)
    -- if npc_id == "Npc_qygp_chz_003" then
    --     return {"841006740", "840067400"}
    -- end
    -- Chồn con (Điêu nhung)
    --if npc_id == "npc_cwqy_cc_01" then
    --	return {"841004405", "100012222", "101012222"}
    --end
    -- La Sát Nữ (Tàn Dương)
    if npc_id == "qy_ng_cjbook_jh_202" then
        return {"841003673", "840036730"}
    end
    -- La Sát Nữ (Vô Vọng)
    if npc_id == "qy_ng_cjbook_jh_201" then
        return {"841003672", "840036720"}
    end
    -- La Sát Nữ (Tử Hà)
    -- if npc_id == "qy_ng_cjbook_jh_204" then
    --     return {"841003675", "840036750"}
    -- end
    -- Năng Chuyên Đô (Bệ Xảo 2)
    --if npc_id == "WorldNpc09727" then
    --	return {"841001239", "840012391"}
    --end
    -- Thành Bích Quân (Đả Cẩu Bổng)
    if npc_id == "WorldNpc09611" then
        return {"841001143", "841001072", "840010721"}
    end
    -- Tổ Hưng (Long Trảo Thủ)
    if npc_id == "WorldNpc00343" then
        return {"841001465", "841001466", "841001467", "841001517", "841001518", "841001519", "840015191"}
    end
    -- Lư Đại Thúc (Phệ Ma Tán)
    -- if npc_id == "npc_qygp_dy_wle" then
    --     return {"841004887", "100018763", "101018763"}
    -- end
    -- Võ tăng tuần tra (Long Trảo Thủ)
    if npc_id == "sl006" then
        return {"841000819", "841000820", "840008201"}
    end
    -- Dị Hương (Thái Cực Quyền)
    if npc_id == "wd061" then
        return {"841001313", "841001314", "840013141"}
    end
    -- Thanh Pháp (Long Trảo Thủ)
    if npc_id == "FuncNpc00718" then
        return {"841001330", "841001331", "841001332", "840013321"}
    end
    -- Lý Thu Hà (Thái Cực Quyền)
    if npc_id == "wd013" then
        return {"841001715", "840017151"}
    end
    -- Phan Thắng Dịch (Đả Cấu Bổng)
    if npc_id == "WorldNpc08409" then
        return {"841001661", "841001662", "840016621"}
    end
    -- Tằng Thị Lộc (Thái Cực Quyền)
    if npc_id == "WorldNpc10474" then
        return {"841001036", "841001795", "841001183", "840011831"}
    end
    -- Phú Thương Cát Tiền (Du mộc)
    if npc_id == "wd016" then
        return {"841000879", "841000936", "840009361"}
    end
    -- Kiếm Ngô Khu (Phệ Ma Tán)
    -- if npc_id == "NPC_qygp_tjq_jmy001" then
    --     return {"841004877", "841004878", "841004879", "841004880", "841004881", "841004882", "841004883", "100010930", "101010930"}
    -- end
    -- Bành Xương Quý (Đả Cẩu Bổng)
    if npc_id == "WorldNpc04349" then
        return {"841002465", "841002466", "841002467", "841002468", "841002470", "100017404", "101017404"}
    end
    -- Mật Lư - Trị Giang (Yết Chi Thượng Hạng) - Bỏ, rẻ rờ
    --if npc_id == "Npc_qygp_shl_002" then
        --return {"841008048", "841008049", "840080490"}
    --end
    -- Thanh Phục - Long Trảo Thủ
    if npc_id == "FuncNpc00717" then
        return {"841001023", "841001038", "841001041", "841001116", "841001327", "840013271"}
    end
    -- Lão Khất - Đả Cẩu Bổng
    if npc_id == "npc_qygp_x01" then
        return {"841004902", "100056061", "101056061", "102056061"}
    end
    return false
end

---------------------------------------
-- Nhặt toàn bộ item trong dropbox
-- Hoặc các item cố định được chỉ ra
-- Nếu có item thì trả về số item
-- Nếu không có trả về 0
--
function tool_getPickForm(itemIDs)
    local client = nx_value("game_client")
    if not nx_is_valid(client) then
        return 0
    end
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return 0
    end
    local client_player = client:GetPlayer()
    if not nx_is_valid(client_player) then
        return 0
    end
    local view = client:GetView(nx_string(80))
    if not nx_is_valid(view) then
        return 0
    end
    local viewobj_list = view:GetViewObjList()
    local numberItems = table.getn(viewobj_list)
    if numberItems > 0 then
        for k = 1, numberItems do
            local item = viewobj_list[k]
            local itemID = item:QueryProp("ConfigID")
            if itemIDs == nil or in_array(itemID, itemIDs) then
                nx_execute("custom_sender", "custom_pickup_single_item", nx_int(item.Ident))
            end
        end
        nx_execute("custom_sender", "custom_close_drop_box")
    end
    return numberItems
end

function is_moving(offset)
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return true
    end
    local game_player = game_visual:GetPlayer()
    if not nx_is_valid(game_player) then
        return true
    end
    if offset == nil then
        offset = 0.2
    end
    local beforeX = string.format("%.3f", game_player.PositionX)
    local beforeY = string.format("%.3f", game_player.PositionY)
    local beforeZ = string.format("%.3f", game_player.PositionZ)
    nx_pause(0.2)
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
    -- Nếu vẫn bị di chuyển thì giảm số này xuống nhỏ hơn nữa
      if distance <= offset then
        return false
      end
    return true
end

function find_npc_pos(scene_id, search_npc_id)
    local mgr = nx_value("SceneCreator")
    if nx_is_valid(mgr) then
        local res = mgr:GetNearestNpcPos(scene_id, search_npc_id)
        if res ~= nil and table.getn(res) == 3 then
            return res[1], res[2], res[3]
        end
    end
    return -10000, -10000, -10000
end

function tools_trace_npc(scene_id, npc_id)
    local x, y, z = find_npc_pos(scene_id, npc_id)
    local path_finding = nx_value("path_finding")
    if not nx_is_valid(path_finding) then
        return false
    end
    local trace_flag = path_finding.AutoTraceFlag
    if -10000 < nx_number(x) then
        if trace_flag == 1 then
            path_finding:TraceTargetByID(scene_id, nx_float(x), nx_float(y), nx_float(z), 1.8, npc_id)
        else
            path_finding:DrawToTarget(scene_id, nx_float(x), nx_float(y), nx_float(z), 1.8, npc_id)
        end
    else
        return false
    end
    return true
end

function tools_trace_npc_with_pos(scene_id, npc_id, x, y, z)
    local path_finding = nx_value("path_finding")
    if not nx_is_valid(path_finding) then
        return false
    end
    local trace_flag = path_finding.AutoTraceFlag
    if trace_flag == 1 then
        path_finding:TraceTargetByID(scene_id, nx_float(x), nx_float(y), nx_float(z), 1.8, npc_id)
    else
        path_finding:DrawToTarget(scene_id, nx_float(x), nx_float(y), nx_float(z), 1.8, npc_id)
    end
    return true
end

-- Lấy giá trị nào đó của Payer và trả về kiểu nx_int
function getPlayerPropInt(prop)
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return nx_int(0)
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return nx_int(0)
    end
    return nx_int(player_client:QueryProp(nx_string(prop)))
end

-- Lấy giá trị nào đó của Payer và trả về kiểu nx_widestr
function getPlayerPropWideStr(prop)
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return nx_widestr("")
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return nx_widestr("")
    end
    return nx_widestr(player_client:QueryProp(nx_string(prop)))
end

-- Lấy giá trị nào đó của Payer và trả về kiểu nx_string
function getPlayerPropStr(prop)
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return nx_string("")
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return nx_string("")
    end
    return nx_string(player_client:QueryProp(nx_string(prop)))
end

function get_current_map(showtext)
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return nx_string("")
    end
    local game_scence = game_client:GetScene()
    if not nx_is_valid(game_scence) then
        return nx_string("")
    end
    if showtext == nil then
        return game_scence:QueryProp("Resource")
    else
        return game_scence:QueryProp("ConfigID")
    end
end

-- Lên các loại tọa kỵ đặc biệt
function callTheSpecialRiding()
    -- Đang cưỡi thì kết thúc
    if get_buff_info("buf_riding_01") ~= nil then
        return true
    end
    local goods_grid = nx_value("GoodsGrid")
    if not nx_is_valid(goods_grid) then
        return false
    end
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return false
    end
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return false
    end
    local game_scence = game_client:GetScene()
    if not nx_is_valid(game_scence) then
        return false
    end
    local client_player = game_client:GetPlayer()
    if not nx_is_valid(client_player) then
        return false
    end
    local rideArray = {
        "Marry_mount_1_fc", -- Bạch Mã Liễn (180 ngày)
        "newyear_mount_1", -- Tam Dương Liên (30 ngày)
        "newyear_mount_2", -- Tam Dương Liên (7 ngày)
        "mount_2_001" -- Lạc Đà
    }
    for j = 1, table.getn(rideArray) do
        local rideID = rideArray[j]
        if goods_grid:GetItemCount(rideID) > 0 then
            nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", rideID)
            nx_pause(8)
            local game_scence_objs = game_scence:GetSceneObjList()
            for i = 1, table.getn(game_scence_objs) do
                local obj = game_scence_objs[i]
                if nx_is_valid(obj) then
                    local visualObj = game_visual:GetSceneObj(obj.Ident)
                    if nx_is_valid(visualObj) then
                        if obj:QueryProp("Type") == 4 and obj:QueryProp("RideName") == rideID and obj:QueryProp("HostName") == client_player:QueryProp("Name") then
                            tools_show_notice(nx_function("ext_utf8_to_widestr", "Lên tọa kỵ"))
                            local ident = obj.Ident
                            nx_execute("custom_sender", "custom_select", nx_string(ident))
                            nx_pause(0.2)
                            nx_execute("custom_sender", "custom_select", nx_string(ident))
                            nx_pause(3)
                            return true
                        end
                    end
                end
            end
        end
    end
end

-- Phục vụ việc đánh đấm

-- Biến này lưu tạm để đỡ phải query nhiều
local skillSetData = {
    [1] = nil,
    [2] = nil,
    [3] = nil,
    [4] = nil,
    [5] = nil,
    [6] = nil,
    [7] = nil,
    [8] = nil
}

-- Trả về collType và CollGroupType của skill thứ index
function getSkillData(grid, index)
    local setIndex = index + 1
    if skillSetData[setIndex] ~= nil then
        return skillSetData[setIndex].stype, skillSetData[setIndex].gtype, skillSetData[setIndex].ttype, skillSetData[setIndex].id
    end
    if not nx_is_valid(grid) then
        return -1, -1, 0, ""
    end
    local itemName = grid:GetItemName(index)
    if nx_widestr(itemName) == nx_widestr("") then
        return -1, -1, 0, ""
    end
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return -1, -1, 0, ""
    end
    local view = game_client:GetView(nx_string(40))
    if not nx_is_valid(view) then
        return -1, -1, 0, ""
    end
    local viewobj_list = view:GetViewObjList()
    for i = 1, table.getn(viewobj_list) do
        local configID = viewobj_list[i]:QueryProp("ConfigID")
        if util_text(configID) == itemName then
            local cool_type = skill_static_query_by_id(configID, "CoolDownCategory")
            local cool_team = skill_static_query_by_id(configID, "CoolDownTeam")
            local target_type = skill_static_query_by_id(configID, "TargetType")
            skillSetData[setIndex] = {
                stype = cool_type,
                gtype = cool_team,
                ttype = target_type,
                id = configID
            }
            return cool_type, cool_team, target_type, configID
        end
    end
    return -1, -1, 0, ""
end

-- Reset lại dữ liệu skill
function resetSkillData()
    skillSetData = {
        [1] = nil,
        [2] = nil,
        [3] = nil,
        [4] = nil,
        [5] = nil,
        [6] = nil
    }
end

-- Xuất skill đánh tới tấp
function killCompetitor(obj, vobj)
    local FORM_SHORTCUT_PATH = "form_stage_main\\form_main\\form_main_shortcut"
    local form = nx_value(FORM_SHORTCUT_PATH)
    if not nx_is_valid(form) then
        return false
    end
    local grid = form.grid_shortcut_main
    if not nx_is_valid(grid) then
        return false
    end
    local gui = nx_value("gui")
    if not nx_is_valid(gui) then
        return false
    end
    if not nx_is_valid(obj) then
        return false
    end
    if not nx_is_valid(vobj) then
        return false
    end
    local fight = nx_value("fight")
    if not nx_is_valid(fight) then
        return false
    end
    -- Ô đầu tiên là ô phá def
    local gindex = 0
    local readyDestroyParry = false
    local cool_type, cool_team, target_type, skill_id = getSkillData(grid, gindex)
    if cool_type > -1 and  not gui.CoolManager:IsCooling(nx_int(cool_type), nx_int(cool_team)) and grid:GetItemCoverImage(gindex) ~= "" then
        readyDestroyParry = true
    end
    if obj:QueryProp("InParry") ~= 0 and readyDestroyParry then
        -- Đối thủ đỡ đòn thì phá def
        fight:TraceUseSkill(skill_id, false, false)
    else
        -- Đối thủ không đỡ đòn thì đánh tự do
        -- Đánh random skill
        while true do
            if not nx_is_valid(grid) or not nx_is_valid(vobj) or not nx_is_valid(fight) then
                break
            else
                local gindex = math.random(0, 7)
                local cool_type, cool_team, target_type, skill_id = getSkillData(grid, gindex)
                if cool_type > -1 and  not gui.CoolManager:IsCooling(nx_int(cool_type), nx_int(cool_team)) and grid:GetItemCoverImage(gindex) ~= "" then
                    if target_type == 1 then
                        nx_execute("game_effect", "add_ground_pick_decal", "map\\tex\\Target_area_G.dds", 16, "20")
                        nx_execute("game_effect", "locate_ground_pick_decal", vobj.PositionX, vobj.PositionY, vobj.PositionZ)
                        fight:TraceUseSkill(skill_id, false, true)
                        nx_execute("game_effect", "del_ground_pick_decal")
                    else
                        fight:TraceUseSkill(skill_id, false, false)
                    end
                    break
                end
            end
            nx_pause(0)
        end
    end
end

-- Lấy tọa độ hiện tại của nhân vật
function get_current_player_pos()
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return nil
    end
    local game_player = game_visual:GetPlayer()
    if not nx_is_valid(game_player) then
        return nil
    end
    return {game_player.PositionX, game_player.PositionY, game_player.PositionZ}
end

-- Nhảy 1 phát đến tọa độ nào đó
-- Khoảng cách nhảy không quá lớn
-- dissMisscheck => Nil thì sẽ check điểm đến, không thì chỉ nhảy
function jump_to(pos, stepDistance, stepPause, dissMisscheck)
    if stepDistance == nil then
        stepDistance = 50
    end
    if stepPause == nil then
        stepPause = 2
    end
    if not tools_move_isArrived(pos[1], pos[2], pos[3], 0.5) then
        local x = nx_float(pos[1])
        local y = nx_float(pos[2])
        local z = nx_float(pos[3])
        local px = string.format("%.3f", nx_string(x))
        local py = string.format("%.3f", nx_string(y))
        local pz = string.format("%.3f", nx_string(z))

        local game_visual = nx_value("game_visual")
        if not nx_is_valid(game_visual) then
            return false
        end
        local game_client = nx_value("game_client")
        if not nx_is_valid(game_client) then
            return false
        end
        local role = nx_value("role")
        if not nx_is_valid(role) then
            return false
        end
        local scene_obj = nx_value("scene_obj")
        if not nx_is_valid(scene_obj) then
            return false
        end
        local game_player = game_visual:GetPlayer()
        if not nx_is_valid(game_player) then
            return false
        end
        local player_client = game_client:GetPlayer()
        if not nx_is_valid(player_client) then
            return false
        end

        scene_obj:SceneObjAdjustAngle(role, x, z)
        role.move_dest_orient = role.AngleY
        role.server_pos_can_accept = true
        -- game_visual:SwitchPlayerState(role, 1, 5)
        -- game_visual:SwitchPlayerState(role, 1, 6)
        -- game_visual:SwitchPlayerState(role, 1, 7)
        -- if y > role.PositionY then
          role:SetPosition(role.PositionX, y, role.PositionZ)
        -- end
        game_visual:SetRoleMoveDestX(role, x)
        game_visual:SetRoleMoveDestY(role, y)
        game_visual:SetRoleMoveDestZ(role, z)
        game_visual:SetRoleMoveDistance(role, stepDistance)
        game_visual:SetRoleMaxMoveDistance(role, 1)
        game_visual:SwitchPlayerState(role, 1, 103)
        if stepPause > 0 then
            nx_pause(stepPause)
            --if dissMisscheck == nil then
                --local scene = nx_value("game_scene")
                --while (nx_is_valid(scene) and not scene.terrain.LoadFinish) or ((nx_is_valid(player_client) and nx_is_valid(game_player)) and not tools_move_isArrived2D(player_client.DestX, player_client.DestY, player_client.DestZ, 1, {game_player.PositionX, game_player.PositionY, game_player.PositionZ})) do
                --    nx_pause(0)
                --end
            --end
        end
    end
end

function getMD5(str)
    return md5.sumhexa(str)
end

function isAdmRights()
        --REM source check admin để chạy auto bug hpmp (bug lãm)
    -- if isAdmRightSet ~= nil then
    --     return isAdmRightSet
    -- end
    -- if not nx_function("ext_is_file_exist", nx_work_path() .. "autodata\\key.dat") then
    --     isAdmRightSet = false
    --     return false
    -- end
    -- local file = io.open (nx_work_path() .. "autodata\\key.dat", "r")
    -- io.input(file)
    -- local key = io.read()
    -- if getMD5(key) ~= trueKey then
    --     isAdmRightSet = false
    --     return false
    -- end
    -- isAdmRightSet = true
    return true
end

function isDismissTrackAcc()
    if isDismissTrackSet ~= nil then
        return isDismissTrackSet
    end
    if not nx_function("ext_is_file_exist", nx_work_path() .. "autodata\\trackkey.dat") then
        isDismissTrackSet = false
        return false
    end
    local file = io.open (nx_work_path() .. "autodata\\trackkey.dat", "r")
    io.input(file)
    local key = io.read()
    if getMD5(key) ~= trueKeyTrack then
        isDismissTrackSet = false
        return false
    end
    isDismissTrackSet = true
    return true
end

-- Kiểm tra có đang dịch chuyển không để nhảy
function jump_to_pos(pos, stepDistance, stepPause)
    local form_map = nx_value("form_stage_main\\form_map\\form_map_scene")
    local game_visual = nx_value("game_visual")
    if pos == nil or pos[1] == nil or pos[2] == nil or pos[3] == nil or not nx_is_valid(game_visual) or nx_is_valid(nx_value("form_common\\form_loading")) then
        return nil
    end

    local game_player = game_visual:GetPlayer()
    if not nx_is_valid(game_player) or game_player == nil or not nx_is_valid(nx_value("path_finding")) or form_map == nil or not nx_is_valid(form_map) or form_map.current_map == nil then
        return nil
    end

    local x, y, z = nx_float(pos[1]), nx_float(pos[2]), nx_float(pos[3])
    local fx, fy, fz = nx_string(x),nx_string(y), nx_string(z)
    fx, fy, fz = string.format("%.3f", fx), string.format("%.3f", fy), string.format("%.3f", fz)

    local beforeX = string.format("%.3f", game_player.PositionX)
    local beforeY = string.format("%.3f", game_player.PositionY)
    local beforeZ = string.format("%.3f", game_player.PositionZ)
    nx_pause(1)
    if nx_is_valid(nx_value("form_common\\form_loading")) then
        return nil
    end
    local afterX = string.format("%.3f", game_player.PositionX)
    local afterY = string.format("%.3f", game_player.PositionY)
    local afterZ = string.format("%.3f", game_player.PositionZ)

    local pxd = beforeX - afterX
    local pyd = beforeY - afterY
    local pzd = beforeZ - afterZ

    local distance = math.sqrt(pxd * pxd + pyd * pyd + pzd * pzd)
    if distance <= 0.6 then
        -- Kiểm tra nếu không di chuyển thì mới bắt dầu dịch chuyển
        local game_client = nx_value("game_client")
        if not nx_is_valid(game_client) then
            return false
        end
        local player = game_client:GetPlayer()
        if not nx_is_valid(player) then
            return false
        end
        local state = player:QueryProp("State")
        if nx_string(state) == "" or state == nil or state == 0 then
            jump_to(pos, stepDistance, stepPause)
        end
    end
    return true
end

----------------------------------------------
-- Nhảy đến tọa độ trong MAP hiện tại kiểu mới hiện đại
-- fixedY => không nil thì cố định Y điểm cuối
-- dissMisscheck => Không nil thì sẽ check điếm đến
function jump_to_pos_new(x, y, z, map, fixedY, dissMisscheck)
    local lastArrivePos = {x, y, z}
    -- Xác định tọa độ Y của điểm đến cuối cùng
    local walkHeight, maxHeight, waterHeight = getInfoHeightOfPos(lastArrivePos[1], lastArrivePos[3])
    lastArrivePos[2] = walkHeight
    if waterHeight == walkHeight then
        lastArrivePos[2] = lastArrivePos[2] + 5
    end
    if fixedY ~= nil then
        -- Cố định Y điểm cuối
        lastArrivePos[2] = y
    end

    -- Khoảng cách mỗi bước nhảy
    local stepDistance = 90
    -- Tính toán trước khi nhảy thật
    local isPreCalculate = true
    -- Giả lập tọa độ điểm đến khi tính toán
    local virtualCalcPos = nil

    -- Nếu đến rồi thì dừng
    findPathBusy = true

    -- Tính khoảng cách 2D bởi lẽ cùng x,z mà thay đổi y thì là tự tử
    while not tools_move_isArrived2D(lastArrivePos[1], lastArrivePos[2], lastArrivePos[3], 0.5) and findPathBusy do
        local currentPos = nil
        if isPreCalculate then
            if virtualCalcPos == nil then
                -- Khi tính toán thì bước đầu tiên lấy tọa độ nhân vật
                currentPos = get_current_player_pos()
            else
                -- Các bước tiếp theo lấy từ điểm đến
                currentPos = virtualCalcPos
            end
        else
            -- Tọa độ của nhân vật đang đứng
            currentPos = get_current_player_pos()
        end
        if currentPos == nil then
            tools_show_notice(nx_function("ext_utf8_to_widestr", "Lỗi dữ liệu"), 2)
            findPathBusy = false
            nx_execute("form_stage_main\\form_map\\form_map_scene", "stopJumpToPosMap")
            return false
        end
        -- Điểm đến tiếp theo
        local nextPos = nil
        -- Điểm đến tiếp theo là điểm cuối cùng
        local isFinalPos = false

        -- Cách nhau stepDistance mét thì là điểm cuối
        if tools_move_isArrived(lastArrivePos[1], lastArrivePos[2], lastArrivePos[3], stepDistance, currentPos) then
            nextPos = lastArrivePos
            isFinalPos = true
        else
            -- Tìm ra điểm tiếp theo
            -- Cách mỗi 10 mét lấy 1 điểm, tối đa stepDistance mét
            -- Nếu tại điểm nào

            local currentDst = 5
            local setPos = nil
            local radian = getAngleForward(currentPos[1], currentPos[3], lastArrivePos[1], lastArrivePos[3])
            local angle = radian_to_degree(radian)
            while 1 do
                local xx = currentPos[1]
                local zz = currentPos[3]
                -- Trước mặt
                if angle <= 90 then
                    zz = zz + math.abs(math.sin(math.pi / 2 - radian) * currentDst)
                    xx = xx + math.abs(math.cos(math.pi / 2 - radian) * currentDst)
                elseif angle > 90 and angle <= 180 then
                    zz = zz - math.abs(math.sin(math.pi * 3 / 2 - radian) * currentDst)
                    xx = xx + math.abs(math.cos(math.pi * 3 / 2 - radian) * currentDst)
                elseif angle > 180 and angle <= 270 then
                    zz = zz - math.abs(math.sin(math.pi * 3 / 2 - radian) * currentDst)
                    xx = xx - math.abs(math.cos(math.pi * 3 / 2 - radian) * currentDst)
                elseif angle > 270 then
                    zz = zz + math.abs(math.sin(math.pi * 3 / 2 - radian) * currentDst)
                    xx = xx - math.abs(math.cos(math.pi * 3 / 2 - radian) * currentDst)
                end
                local posTmp = {xx, -10000, zz}
                -- Xác định chiều cao của pos này
                local walkHeight, maxHeight = getInfoHeightOfPos(posTmp[1], posTmp[3])
                posTmp[2] = maxHeight + 20
                -- Nếu không vượt quá nhân vật stepDistance mét thì lấy điểm đó
                if tools_move_isArrived(posTmp[1], posTmp[2], posTmp[3], stepDistance, currentPos) then
                    setPos = posTmp
                else
                    break
                end
                currentDst = currentDst + 5
                if currentDst > stepDistance then
                    break
                end
            end
            if setPos == nil then
                tools_show_notice(nx_function("ext_utf8_to_widestr", "Địa hình này không thể di chuyển giữa hai điểm, thử chọn điểm đến khác"), 2)
                findPathBusy = false
                nx_execute("form_stage_main\\form_map\\form_map_scene", "stopJumpToPosMap")
                return false
            end
            nextPos = setPos
        end
        if nextPos ~= nil then
            if isPreCalculate then
                -- Xử lý khi tính toán
                if isFinalPos then
                    -- Step cuối cùng thì kết thúc tính
                    isPreCalculate = false
                else
                    -- Chưa step cuối thì giả lập điểm đến
                    virtualCalcPos = nextPos
                end
            else
                -- Sau khi tính toán thì thực hiện
                -- Dừng mỗi bước nhảy (giây)
                local stepPause = 5
                if isFinalPos then
                    -- Lần cuối cùng thì không dừng nữa
                    stepPause = 0
                end
                jump_to(nextPos, stepDistance, stepPause, dissMisscheck)
            end
        end
        nx_pause(0.05)
    end

    findPathBusy = false
    nx_execute("form_stage_main\\form_map\\form_map_scene", "stopJumpToPosMap")
    tools_show_notice(nx_function("ext_utf8_to_widestr", "Đã đến nơi"))
end

---------------------------------------
-- Khống chế dừng lúc đang nhảy
function stop_jump_to_pos_new()
    findPathBusy = false
    nx_execute("form_stage_main\\form_map\\form_map_scene", "stopJumpToPosMap")
end

-- Xác định tọa độ Y (độ cao) từ X và Z
-- Dữ liệu trả về có Y lớn hơn 20m so với thực tế để đảm bảo nhảy trên không trung
function get_pos_y_from_xz(terrain, x, z)
    if not nx_is_valid(terrain) then
        return 0, 0
    end
    local floor_index = 0
    local y = terrain:GetPosiY(x, z)
    if terrain:GetWalkWaterExists(x, z) and y < terrain:GetWalkWaterHeight(x, z) then
        -- Nếu có nước và độ cao ở dưới nước thì thiết đặt Y trên mặt nước 15 mét
        y = terrain:GetWalkWaterHeight(x, z) + 15
    else
        -- Hàm get_pos_floor_index nằm ở util_move
        -- Xác định tầng và độ cao của tầng
        local floor, floor_y = get_pos_floor_index(terrain, x, y, z)
        if floor > -1 then
            y = floor_y
            floor_index = floor
        end
    end

    return y + 20, floor_index
end

--[[
Bug tới tọa độ trong MAP
    dest: Mảng tọa độ
    stepDistance: Khoảng cách mỗi step nên là 40 - 50, tùy khu vực mà có thể nên thu nhỏ xuống
    stepPause: Thời gian mỗi bước nhảy. Mặc định là 2
    fixedY: Cố định phương cao nhảy, mặc định là không: Một số MAP có thể xác định sai Y do đó cần thiết cố định chiều cao nhảy
]]--
function jump_direct_to_pos(dest, stepDistance, stepPause, fixedY)
    if stepDistance == nil then
        stepDistance = 45
    end
    local currentPos = get_current_player_pos()
    if currentPos == nil then
        return false
    end
    -- Xác đinh khoảng cách theo phương X và phương Z
    local dx = dest[1] - currentPos[1]
    local dz = dest[3] - currentPos[3]

    local a = dz / dx
    local b = dest[3] - a * dest[1]

    -- Xác định khoảng cách 2D điểm đứng và điểm đến để tính ra số lần dịch chuyển
    local distance = math.sqrt(dx * dx + dz * dz)
    local steps = math.ceil(distance / stepDistance)

    -- Mỗi bước dịch chuyển bằng
    local dxStepDistance = dx / steps

    local current_step = 1
    while current_step <= steps and not nx_value("loading") do
        nx_pause(0)
        local scene = nx_value("game_scene")
        if not nx_is_valid(scene) then
            return false
        end
        local terrain = scene.terrain
        if not nx_is_valid(terrain) then
            return false
        end
        tools_show_notice(nx_widestr(current_step .. "/" .. steps))
        local x = currentPos[1] + dxStepDistance * current_step
        local z = a * x + b
        local y, floor_index = get_pos_y_from_xz(terrain, x, z)
        if current_step == steps then
            x = dest[1]
            z = dest[3]
            y = y - 20
            floor_index = nil
        end
        local pos = {x, y, z}
        -- Xử lý khi cố định chiều cao
        if fixedY ~= nil then
            -- Ở bước nhảy cuối cùng
            if current_step == steps then
                if dest[2] > -1000 then
                    -- Nếu thiết lập chiều cao nhảy thì chiều cao nhảy là giá trị thiết lập
                    pos[2] = dest[2] + 0.5
                    -- Nếu không thiết lập thì
                end
            else
                -- Ở các bước nhảy khác thì
                -- Chiều cao nhảy là chiều cao cố định
                pos[2] = fixedY
            end
        end
        jump_to_pos(pos, stepDistance, stepPause)
        current_step = current_step + 1
    end
end

-----------------------
-- Hàm phụ
--
function normalize_angle(angle)
    local value = math.fmod(angle, math.pi * 2)
    if value < 0 then
        value = value + math.pi * 2
    end
    return value
end

--------------------------
-- Hàm phụ tính Radian thành độ
--
function radian_to_degree(radian)
  return math.floor(normalize_angle(radian) * 3600 / (math.pi * 2)) * 0.1
end

-------------------------------
-- Xác định AngleY giữa hai điểm
function getAngleForward(myposx, myposz, toposx, toposz)
    -- x tương ứng trục y. z tương ứng trục x trong mặt phẳng tọa độ
    local x1 = myposz
    local x2 = toposz
    local y1 = myposx
    local y2 = toposx
    if x2 == x1 then
        return 0
    end
    local tana = math.abs(y2 - y1) / math.abs(x2 - x1)
    local radian = math.atan(tana)
    if x2 > x1 and y2 > y1 then
        radian = radian
    elseif x2 < x1 and y2 > y1 then
        radian = math.pi - radian
    elseif x2 < x1 and y2 < y1 then
        radian = math.pi + radian
    elseif x2 > x1 and y2 < y1 then
        radian = (2 * math.pi) - radian
    end
    return radian
end

--------------------------
-- Cho nhân vật đi thẳng tới
--
function setPlayerHackMove()
    local role = nx_value("role")
    if not nx_is_valid(role) then
        return false
    end
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return false
    end
    game_visual:SwitchPlayerState(role, 1, 3)
end

----------------------------
-- Cho nhân vật dừng lại
--
function stopPlayerHackMove()
    local role = nx_value("role")
    if not nx_is_valid(role) then
        return false
    end
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return false
    end
    game_visual:SwitchPlayerState(role, "static", 1)
end

------------------------------
-- Xóa nội dung log trong form
--
function clearLogForm()
    local formName = "admin_yBreaker\\yBreaker_form_log"
    local form = util_show_form(formName, true)
    if nx_is_valid(form) then
        form.mltbox_content:Clear()
    end
end

-----------------------------------
-- Log vào form
--
function logToForm(text, wided)
    if text == nil then
        return
    end
    if wided == nil or not wided then
        text = nx_function("ext_utf8_to_widestr", text)
    else
        text = nx_widestr(text)
    end
    local formName = "admin_yBreaker\\yBreaker_form_log"
    local form = util_show_form(formName, true)
    if nx_is_valid(form) then
        --nx_value("gui").Desktop:ToFront(form)
        form.mltbox_content:AddHtmlText(text, -1)
    end
end

--------------------------------
-- Xác định chiều cao của điểm trên MAP
-- trả về 1 là chiều cao đứng
-- 2 là chiều cao cao nhất
--
function getInfoHeightOfPos(x, z)
    local scene = nx_value("game_scene")
    if not nx_is_valid(scene) then
        return nil
    end
    local terrain = scene.terrain
    if not nx_is_valid(terrain) then
        return nil
    end
    -- Chiều cao thực tế tại một điểm
    local posY = terrain:GetPosiY(x, z)
    -- Chiều cao nhân vật sẽ đứng trên mặt đất tại một điểm
    local walkHeight = terrain:GetWalkHeight(x, z)
    -- Chiều cao tối đa tại một điểm
    local maxHeight = walkHeight
    local floorHeightTable = {}
    local floor_count = terrain:GetFloorCount(x, z)
    for i = floor_count - 1, 0, -1 do
        local floor_height = terrain:GetFloorHeight(x, z, i)
        if floor_height ~= posY then
            table.insert(floorHeightTable, floor_height)
        end
        if floor_height > maxHeight then
            maxHeight = floor_height
        end
    end
    -- Kiểm tra chiều cao mặt nước
    local waterHeight = -10000
    if terrain:GetWalkWaterExists(x, z) then
        waterHeight = terrain:GetWalkWaterHeight(x, z)
    end
    -- Nếu chiều cao của nước hơn chiều cao lầu thì trả về chiều cao nước
    if waterHeight > maxHeight then
        maxHeight = waterHeight
    end
    -- Nếu chiều cao của nước hơn chiều cao đứng thì trả về chiều cao nước
    if waterHeight > walkHeight then
        walkHeight = waterHeight
    end
    return walkHeight, maxHeight, waterHeight
end

--------------------------------
-- Xác định nội công thấp nhất
-- nội công cao cấp nhất của người chơi
--
function getMinAndMaxNeigong()
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return "", ""
    end
    local view = game_client:GetView(nx_string(43))
    if not nx_is_valid(view) then
        return "", ""
    end

    local viewobj_list = view:GetViewObjList()
    local minNeigongID = ""
    local maxNeigongID = ""
    local minNeigongVal = 1000
    local maxNeigongVal = 0

    for i = 1, table.getn(viewobj_list) do
        local configid = viewobj_list[i]:QueryProp("ConfigID")
        local level = viewobj_list[i]:QueryProp("Level")
        local quality = viewobj_list[i]:QueryProp("Quality")
        local val = level * quality
        if val >= maxNeigongVal then
            maxNeigongID = configid
            maxNeigongVal = val
        end
        if val <= minNeigongVal then
            minNeigongID = configid
            minNeigongVal = val
        end
    end

    -- Lấy nội công cao hơn tư cấu hình (theo nhân vật)
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return "", ""
    end
    if player_client:QueryProp("Name") == player_max_neigong_name and player_max_neigong ~= "" then
        -- Nếu biến tạm đã ghi thì trả về
        maxNeigongID = player_max_neigong
    else
        -- Đọc từ cấu hình
        local game_config = nx_value("game_config")
        local account = game_config.login_account
        local ini = nx_create("IniDocument")
        if not nx_is_valid(ini) then
            return "", ""
        end
        ini.FileName = account .. "\\yBreaker_config.ini"
        if ini:LoadFromFile() then
            max_neigong = ini:ReadString(nx_string("neigong"), nx_string("max"), "")
            if max_neigong ~= "" then
                player_max_neigong_name = player_client:QueryProp("Name")
                player_max_neigong = max_neigong
                maxNeigongID = player_max_neigong
            end
        end
        nx_destroy(ini)
    end

    return minNeigongID, maxNeigongID
end

-- Lấy bộ võ PVP theo thiết lập
function getPvpTaolu()
    -- Đọc từ cache
    if tool_pvptaolu ~= nil then
        return tool_pvptaolu
    end
    -- Đọc từ file ini
    local game_config = nx_value("game_config")
    local account = game_config.login_account
    local ini = nx_create("IniDocument")
    if not nx_is_valid(ini) then
        return ""
    end
    ini.FileName = account .. "\\yBreaker_config.ini"
    if ini:LoadFromFile() then
        tool_pvptaolu = ini:ReadString(nx_string("pvp"), nx_string("taolu"), "")
    end
    nx_destroy(ini)
    return tool_pvptaolu
end

-- Lấy bình thư PVP theo thiết lập
function getPvpBinhThu()
    -- Đọc từ cache
    if tool_pvpbinhthu ~= nil then
        return tool_pvpbinhthu
    end
    -- Đọc từ file ini
    local game_config = nx_value("game_config")
    local account = game_config.login_account
    local ini = nx_create("IniDocument")
    if not nx_is_valid(ini) then
        return ""
    end
    ini.FileName = account .. "\\yBreaker_config.ini"
    if ini:LoadFromFile() then
        tool_pvpbinhthu = ini:ReadString(nx_string("pvp"), nx_string("binhthu"), "")
    end
    nx_destroy(ini)
    return tool_pvpbinhthu
end

------------------------------------------
-- Kiểm tra nhân vật hoặc đối tượng khác có ở dưới nước hay không
--
function is_in_water(vobj)
    local visual_target = nx_null()
    if vobj ~= nil and nx_is_valid(vobj) then
        visual_target = vobj
    else
        local game_visual = nx_value("game_visual")
        if not nx_is_valid(game_visual) then
            return false
        end
        local game_player = game_visual:GetPlayer()
        if not nx_is_valid(game_player) then
            return false
        end
        visual_target = game_player
    end
    if not nx_is_valid(visual_target) then
        return false
    end
    local scene = nx_value("game_scene")
    if not nx_is_valid(scene) then
        return false
    end
    local terrain = scene.terrain
    if not nx_is_valid(terrain) then
        return false
    end
    return terrain:GetWalkWaterExists(visual_target.PositionX, visual_target.PositionZ)
end

-- Tự tử: Sử dụng ma tâm
-- Chú ý: Trước khi sử dụng cần kiểm tra xem skill ma khí tung hoành đã học hay chưa
function suicidePlayer(quick)
    local skill_id = "CS_jh_tmjt06"
    if get_buff_info("buf_riding_01") ~= nil then
        nx_execute("custom_sender", "custom_remove_buffer", "buf_riding_01")
        nx_pause(0.2)
    end
    local fight = nx_value("fight")
    if not nx_is_valid(fight) then
        return false
    end
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return false
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return false
    end
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return false
    end
    local game_player = game_visual:GetPlayer()
    if not nx_is_valid(game_player) then
        return false
    end
    local skill = fight:FindSkill(skill_id)
    -- Kiểm tra buff ma tâm
    -- Đang trọng thương còn mana logic là 121
    if nx_int(player_client:QueryProp("Dead")) == nx_int(0) and player_client:QueryProp("LogicState") ~= 121 then
        -- Sử dụng ma khí tung hoành khi không có buff
		if nx_is_valid(skill) then
			if get_buff_info("buf_CS_jh_tmjt06") == nil then
				-- Sử dụng ma khí tung hoành
				fight:TraceUseSkill(skill_id, false, false)
			end
		end
		-- Xác định nội công
		local minNeigongID, maxNeigongID = getMinAndMaxNeigong()
		if minNeigongID == "" or maxNeigongID == "" then
			return false
		end
		-- Chuyển nội thấp
		if player_client:QueryProp("CurNeiGong") ~= minNeigongID then
			nx_execute("custom_sender", "custom_use_neigong", nx_string(minNeigongID))
			nx_pause(0.5)
		end
		-- Chuyển nội cao
		if not nx_is_valid(player_client) or not nx_is_valid(game_player) then
			return false
		end
		if player_client:QueryProp("CurNeiGong") ~= maxNeigongID then
			nx_execute("custom_sender", "custom_use_neigong", nx_string(maxNeigongID))
		end
        if quick ~= nil and not is_in_water(game_player) then
            local x = nx_float(game_player.PositionX)
            local y = nx_float(game_player.PositionY)
            local z = nx_float(game_player.PositionZ)
            local game_visual = nx_value("game_visual")
            local role = nx_value("role")
            local scene_obj = nx_value("scene_obj")
            scene_obj:SceneObjAdjustAngle(role, x, z)
            role.move_dest_orient = role.AngleY
            role.server_pos_can_accept = true
            game_visual:SwitchPlayerState(role, 1, 5)
            game_visual:SwitchPlayerState(role, 1, 6)
            game_visual:SwitchPlayerState(role, 1, 7)
            role:SetPosition(role.PositionX, y, role.PositionZ)
            game_visual:SetRoleMoveDestX(role, x)
            game_visual:SetRoleMoveDestY(role, y)
            game_visual:SetRoleMoveDestZ(role, z)
            game_visual:SetRoleMoveDistance(role, 1)
            game_visual:SetRoleMaxMoveDistance(role, 1)
            game_visual:SwitchPlayerState(role, 1, 103)
        end
    end
end

-------------------------------------------------
-- Xác định xem có người chơi ở gần hay không
-- targetMe = nil thì quét hết ng chơi
-- targetMe ~= nil thì quét ng chơi đang target vào bản thân
--
function isHaveNearPlayer(targetMe)
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return true
    end
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return true
    end
    local game_scence = game_client:GetScene()
    if not nx_is_valid(game_scence) then
        return true
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return true
    end
    local gui = nx_value("gui")
    if not nx_is_valid(gui) then
        return true
    end

    -- Quét các đối tượng
    local game_scence_objs = game_scence:GetSceneObjList()
    for i = 1, table.getn(game_scence_objs) do
        local obj = game_scence_objs[i]
        if nx_is_valid(obj) then
            if obj:QueryProp("Type") == 2 and player_client:QueryProp("Name") ~= obj:QueryProp("Name") and obj:QueryProp("OffLineState") == 0 and
               (targetMe == nil or nx_string(player_client.Ident) == nx_string(obj:QueryProp("LastObject")))
            then
                return true
            end
        end
    end
    return false
end

-- Xác đinh khoảng cách của đối thủ
function getCompetitorDistance(vobj)
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return 9999
    end
    local game_player = game_visual:GetPlayer()
    if not nx_is_valid(game_player) then
        return 9999
    end
    if not nx_is_valid(vobj) then
        return 9999
    end
    local objX = vobj.PositionX
    local objZ = vobj.PositionZ
    local pxd = objX - game_player.PositionX
    local pzd = objZ - game_player.PositionZ
    local distance = math.sqrt(pxd * pxd + pzd * pzd)
    return distance
end

-------------------------------------------------
-- Xác định xem có NPC ở gần hay không
-- Trả về nil nếu không có
-- Trả về khoảng cách nếu có NPC
--
function isHaveNearNPC(configID)
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return nil
    end
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return nil
    end
    local game_scence = game_client:GetScene()
    if not nx_is_valid(game_scence) then
        return nil
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return nil
    end
    local gui = nx_value("gui")
    if not nx_is_valid(gui) then
        return nil
    end

    -- Quét các đối tượng
    local game_scence_objs = game_scence:GetSceneObjList()
    for i = 1, table.getn(game_scence_objs) do
        local obj = game_scence_objs[i]
        local vobj = game_visual:GetSceneObj(nx_string(obj.Ident))
        if nx_is_valid(obj) and nx_is_valid(vobj) then
            if nx_string(obj:QueryProp("ConfigID")) == nx_string(configID) then
                return getCompetitorDistance(vobj)
            end
        end
    end
    return nil
end

function stopAllTestFile()
    testFileTableRun = {}
end

function isTestFileRun(testfile)
    if testFileTableRun[testfile] == nil then
        return false
    end
    return testFileTableRun[testfile]
end

function startTestFileRun(testfile)
    testFileTableRun[testfile] = true
end

function stopTestFileRun(testfile)
    testFileTableRun[testfile] = false
end

-------------------------------------
-- Lấy thiết lập thời trang đang set
--
function getCurrentSuitInfo()
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return false
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return false
    end
    if player_client:QueryProp("Name") == suitPlayer and suitCurrentActive ~= -1 then
        return suitCurrentActive, suitCurrentData.Hat, suitCurrentData.Cloth, suitCurrentData.Pants, suitCurrentData.Shoes, suitCurrentData.Cloak, suitCurrentData.Waist, suitCurrentData.Back, suitCurrentData.Face, suitCurrentData.Mount
    else
        -- Đọc từ cấu hình
        local game_config = nx_value("game_config")
        local account = game_config.login_account
        local ini = nx_create("IniDocument")
        if not nx_is_valid(ini) then
            return false
        end
        local noConfigSuit = true
        ini.FileName = nx_function("ext_get_current_exe_path") .. account .. "\\yBreaker_config.ini"
        if ini:LoadFromFile() then
            local sactive = ini:ReadInteger(nx_string("suitset"), nx_string("Active"), 1)
            if sactive == 1 then
                suitCurrentActive = true
            else
                suitCurrentActive = false
            end
            suitCurrentData = {
                Hat = ini:ReadString(nx_string("suitset"), nx_string("Hat"), ""), -- Tóc
                Cloth = ini:ReadString(nx_string("suitset"), nx_string("Cloth"), ""), -- Áo
                Pants = ini:ReadString(nx_string("suitset"), nx_string("Pants"), ""), -- Quần
                Shoes = ini:ReadString(nx_string("suitset"), nx_string("Shoes"), ""), -- Giày
                Cloak = ini:ReadString(nx_string("suitset"), nx_string("Cloak"), ""), -- Phi Phong
                Waist = ini:ReadString(nx_string("suitset"), nx_string("Waist"), ""), -- Trang Sức Đai
                Back = ini:ReadString(nx_string("suitset"), nx_string("Back"), ""), -- Trang Sức Lưng
                Face = ini:ReadString(nx_string("suitset"), nx_string("Face"), ""), -- Mặt Nạ
                Mount = ini:ReadString(nx_string("suitset"), nx_string("Mount"), "") -- Ngựa
            }
            suitPlayer = player_client:QueryProp("Name")
            noConfigSuit = false
        end
        nx_destroy(ini)
        if suitCurrentActive == -1 or noConfigSuit then
            return false
        end
    end

    return suitCurrentActive, suitCurrentData.Hat, suitCurrentData.Cloth, suitCurrentData.Pants, suitCurrentData.Shoes, suitCurrentData.Cloak, suitCurrentData.Waist, suitCurrentData.Back, suitCurrentData.Face, suitCurrentData.Mount
end

-------------------------------------
-- Lấy thiết lập vũ khí đang set
--
function getCurrentWeaponSetInfo()
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return "", "", "", "", "", "", "", ""
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return "", "", "", "", "", "", "", ""
    end
    if player_client:QueryProp("Name") == weaponCurrentPlayer then
        return weaponCurrentData[1], weaponCurrentData[2], weaponCurrentData[3], weaponCurrentData[4], weaponCurrentData[5], weaponCurrentData[6], weaponCurrentData[7], weaponCurrentData[8], weaponCurrentData[9]
    else
        -- Đọc từ cấu hình
        local game_config = nx_value("game_config")
        local account = game_config.login_account
        local ini = nx_create("IniDocument")
        if not nx_is_valid(ini) then
            return "", "", "", "", "", "", "", ""
        end
        local noConfigWeapon = true
        ini.FileName = account .. "\\yBreaker_config.ini"
        if ini:LoadFromFile() then
            weaponCurrentData = {
                [1] = ini:ReadString(nx_string("weaponset"), nx_string("WeaponSubType1"), ""),
                [2] = ini:ReadString(nx_string("weaponset"), nx_string("WeaponSubType2"), ""),
                [3] = ini:ReadString(nx_string("weaponset"), nx_string("WeaponSubType3"), ""),
                [4] = ini:ReadString(nx_string("weaponset"), nx_string("WeaponSubType4"), ""),
                [5] = ini:ReadString(nx_string("weaponset"), nx_string("WeaponSubType5"), ""),
                [6] = ini:ReadString(nx_string("weaponset"), nx_string("WeaponSubType6"), ""),
                [7] = ini:ReadString(nx_string("weaponset"), nx_string("WeaponSubType7"), ""),
                [8] = ini:ReadString(nx_string("weaponset"), nx_string("WeaponSubType8"), ""),
                [9] = ini:ReadString(nx_string("weaponset"), nx_string("WeaponSubType9"), "")
            }
            weaponCurrentPlayer = player_client:QueryProp("Name")
            noConfigWeapon = false
        end
        nx_destroy(ini)
        if noConfigWeapon then
            return "", "", "", "", "", "", "", "", ""
        end
    end

    return weaponCurrentData[1], weaponCurrentData[2], weaponCurrentData[3], weaponCurrentData[4], weaponCurrentData[5], weaponCurrentData[6], weaponCurrentData[7], weaponCurrentData[8], weaponCurrentData[9]
end

----------------------------------
-- Xem loại vũ khí đang cầm theo kiểu subtype
--
function getWeaponSubType()
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return 0
    end
    local view = game_client:GetView(nx_string(1))
    if not nx_is_valid(view) then
        return 0
    end
    local isWeaponSubType = 0 -- 0 thì không có cầm vũ khí hỗ trợ PVC
    local item_lst = view:GetViewObjList()
    for k = 1, table.getn(item_lst) do
        local itemtype = item_lst[k]:QueryProp("ItemType")
        if nx_int(itemtype) == nx_int(ITEMTYPE_WEAPON_SWORD) then
            -- Đơn kiếm
            isWeaponSubType = 1
            break
        elseif nx_int(itemtype) == nx_int(ITEMTYPE_WEAPON_SSWORD) then
            -- Song kiếm
            isWeaponSubType = 2
            break
        elseif nx_int(itemtype) == nx_int(ITEMTYPE_WEAPON_BLADE) then
            -- Đơn đao
            isWeaponSubType = 3
            break
        elseif nx_int(itemtype) == nx_int(ITEMTYPE_WEAPON_SBLADE) then
            -- Song đao
            isWeaponSubType = 4
            break
        elseif nx_int(itemtype) == nx_int(ITEMTYPE_WEAPON_COSH) then
            -- Đoản Côn
            isWeaponSubType = 5
            break
        elseif nx_int(itemtype) == nx_int(ITEMTYPE_WEAPON_STUFF) then
            -- Trường Côn
            isWeaponSubType = 6
            break
        elseif nx_int(itemtype) == nx_int(ITEMTYPE_WEAPON_THORN) then
            -- Đoản Kiếm
            isWeaponSubType = 7
            break
        elseif nx_int(itemtype) == nx_int(ITEMTYPE_WEAPON_STHORN) then
            -- Song thích
            isWeaponSubType = 8
            break
        elseif nx_int(itemtype) == nx_int(ITEMTYPE_WEAPON_BOW) then
            -- Cung
            isWeaponSubType = 9
            break
        end
    end
    return isWeaponSubType
end

---------------------------------------------------
-- Đổi đồ nhân vật
--
function updatePlayerShape()
    nx_pause(0.7)
    local role_composite = nx_value("role_composite")
    if not nx_is_valid(role_composite) then
        return false
    end
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return false
    end
    local game_player = game_visual:GetPlayer()
    if not nx_is_valid(game_player) then
        return false
    end
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return false
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return false
    end
    local role = nx_value("role")
    if not nx_is_valid(role) then
        return false
    end
    local collect_card_manager = nx_value("CollectCardManager")
    if not nx_is_valid(collect_card_manager) then
        return false
    end

    local sactive, Hat, Cloth, Pants, Shoes, Cloak, Waist, Back, Face, Mount = nx_execute("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs", "getCurrentSuitInfo")
    if sactive then
        -- Mặt Nạ
        if Face ~= "" then
            local BufferEffect = nx_value("BufferEffect")
            local effect_id = BufferEffect:GetBufferEffectInfoByID(Face, "effect")
            local scene = nx_value("game_scene")
            local game_effect = scene.game_effect
            if nx_find_custom(game_player, "face_effect_id") then
                game_effect:RemoveEffect(game_player.face_effect_id, game_player, game_player)
            end
            game_effect:CreateEffect(nx_string(effect_id), game_player, game_player, "", "", "", "", game_player, true)
            game_player.face_effect_id = effect_id
        end
        -- Trang Sức Lưng
        if Back ~= "" then
            if nx_find_custom(role, "dec_link_name" .. nx_string(3)) then
                local link_name = nx_custom(role, "dec_link_name" .. nx_string(3))
                if link_name ~= "" then
                    collect_card_manager:UnLinkCardDecorate(role, nx_string(link_name))
                    nx_set_custom(role, "dec_link_name" .. nx_string(3), "")
                end
            end
            nx_set_custom(role, "dec_link_name" .. nx_string(3), Back)
            collect_card_manager:LinkCardDecorate(role, Back)
        end
        -- Phi Phong Đổi
        if Cloak ~= "" then
            role_composite:UnLinkSkin(game_player, "cloak")
            role_composite:LinkSkin(game_player, "cloak", Cloak .. ".xmod", false)
        end
        -- Trang Sức Eo
        if Waist ~= "" then
            role_composite:UnLinkSkin(game_player, "waist")
            role_composite:LinkSkin(game_player, "waist", Waist .. ".xmod", false)
        end
        -- Mũ áo quần giày
        if Hat ~= "" then
            role_composite:UnLinkSkin(game_player, "hat")
            link_hat_skin(role_composite, game_player, Hat)
        end
        if Cloth ~= "" then
            role_composite:UnLinkSkin(game_player, "cloth")
            link_cloth_skin(role_composite, game_player, Cloth)
        end
        if Pants ~= "" then
            role_composite:UnLinkSkin(game_player, "pants")
            link_pants_skin(role_composite, game_player, Pants)
        end
        if Shoes ~= "" then
            role_composite:UnLinkSkin(game_player, "shoes")
            role_composite:LinkSkin(game_player, "shoes", Shoes .. ".xmod", false)
        end
    end
end

---------------------------------------------------
-- Đổi ngựa nhân vật
--
function updatePlayerMount()
    nx_pause(0.7)
    local role_composite = nx_value("role_composite")
    if not nx_is_valid(role_composite) then
        return false
    end
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return false
    end
    local game_player = game_visual:GetPlayer()
    if not nx_is_valid(game_player) then
        return false
    end
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return false
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return false
    end
    local role = nx_value("role")
    if not nx_is_valid(role) then
        return false
    end
    local collect_card_manager = nx_value("CollectCardManager")
    if not nx_is_valid(collect_card_manager) then
        return false
    end

    local sactive, Hat, Cloth, Pants, Shoes, Cloak, Waist, Back, Face, Mount = nx_execute("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs", "getCurrentSuitInfo")
    if sactive then
        -- Ngựa đổi
        if Mount ~= "" and player_client:QueryProp("Mount") ~= 0 and player_client:QueryProp("Mount") ~= "" then
            nx_execute("role_composite", "load_from_ini", role, "ini\\" .. Mount .. ".ini")
        end
    end
end

---------------------------------------------------
-- Đổi vũ khí của nhân vật
--
function updatePlayerWeapon()
    nx_pause(0.7)
    local role_composite = nx_value("role_composite")
    if not nx_is_valid(role_composite) then
        return false
    end
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return false
    end
    local game_player = game_visual:GetPlayer()
    if not nx_is_valid(game_player) then
        return false
    end
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return false
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return false
    end
    local role = nx_value("role")
    if not nx_is_valid(role) then
        return false
    end
    local collect_card_manager = nx_value("CollectCardManager")
    if not nx_is_valid(collect_card_manager) then
        return false
    end

    local sactive, Hat, Cloth, Pants, Shoes, Cloak, Waist, Back, Face, Mount = nx_execute("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs", "getCurrentSuitInfo")
    local wps1, wps2, wps3, wps4, wps5, wps6, wps7, wps8, wps9 = nx_execute("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs", "getCurrentWeaponSetInfo")
    if sactive then
        -- Vũ khí đổi
        local currWeaponSubType = getWeaponSubType()
        local tableSetWeapon = {
            [1] = wps1,
            [2] = wps2,
            [3] = wps3,
            [4] = wps4,
            [5] = wps5,
            [6] = wps6,
            [7] = wps7,
            [8] = wps8,
            [9] = wps9
        }
        if currWeaponSubType > 0 and tableSetWeapon[currWeaponSubType] ~= nil and tableSetWeapon[currWeaponSubType] ~= "" then
            role_composite:UnLinkWeapon(role)
            game_visual:SetRoleWeaponName(role, tableSetWeapon[currWeaponSubType])
            role_composite:UseWeapon(role, game_visual:QueryRoleWeaponName(role), 2, nx_int(SubType2TtemType[currWeaponSubType]))
            role_composite:RefreshWeapon(role)
        end
    end
end

-- Giết = song thích
function killCompetitorByST(obj, vobj, allowedTargetSkill, allowedAQ)
    local gui = nx_value("gui")
    if not nx_is_valid(gui) then
        return false
    end
    if not nx_is_valid(obj) then
        return false
    end
    if not nx_is_valid(vobj) then
        return false
    end
    local fight = nx_value("fight")
    if not nx_is_valid(fight) then
        return false
    end

    -- SkillID - ColType - ColTeam
    local skillPhaDef = {"CS_jl_shuangci06", 5583, 50108} -- Tu la hủ cốt
    local skill1 = {"CS_jl_shuangci02", 5410, 50108} -- Huyền độc tỏa mộc
    local skill2 = {"CS_jl_shuangci05", 5662, 50108} -- Âm hồn xuất khiếu
    local skillNo = {"CS_jl_shuangci07", 5530, 50108} -- Ôn thần tứ dật
    local skillTarget = {"CS_jl_shuangci04", 5527, 50108} -- Tu la hủ cốt
    local skillVoKy = {"CS_jl_shuangci03", 5419, 50108} -- Ác Quỷ Tranh Thực

    -- Ô đầu tiên là ô phá def
    local readyDestroyParry = false
    if not gui.CoolManager:IsCooling(nx_int(skillPhaDef[2]), nx_int(skillPhaDef[3])) then
        readyDestroyParry = true
    end
    if obj:QueryProp("InParry") ~= 0 and readyDestroyParry then
        -- Đối thủ đỡ đòn thì phá def
        fight:TraceUseSkill(skillPhaDef[1], false, false)
    else
        -- Đối thủ không đỡ đòn thì đánh ưu tiên âm hồn, huyền độc, độc xà
        local StopSkill = false
        -- Ôn thần nếu đủ nộ và sắp hết buff nộ
        -- Không ôn thần nếu NPC đang đánh bị ngã (Áp dụng trong THTH)
        local buffNC = get_buff_info("buf_CS_jl_shuangci07")
        if getPlayerPropInt("SP") > nx_int(25) and (buffNC == nil or buffNC < 5) and get_buff_info("buff_tg_pobati", obj) == nil then
            StopSkill = true
            fight:TraceUseSkill(skillNo[1], false, false)
        end
        -- Đánh huyền độc
        if not StopSkill then
            if not gui.CoolManager:IsCooling(nx_int(skill1[2]), nx_int(skill1[3])) then
                StopSkill = true
                fight:TraceUseSkill(skill1[1], false, false)
            end
        end
        -- Ác quỷ tranh thực nếu cho phép, hết buff và chiêu sẵn sàng
        if not StopSkill then
            if allowedAQ ~= nil and get_buff_info("buf_CS_jl_shuangci03") == nil and not gui.CoolManager:IsCooling(nx_int(skillVoKy[2]), nx_int(skillVoKy[3])) then
                StopSkill = true
                fight:TraceUseSkill(skillVoKy[1], false, false)
            end
        end
        -- Đánh độc xà
        if not StopSkill and allowedTargetSkill ~= nil then
            if not gui.CoolManager:IsCooling(nx_int(skillTarget[2]), nx_int(skillTarget[3])) then
                StopSkill = true
                fight:TraceUseSkill(skillTarget[1], false, false)
            end
        end
        -- Đánh âm hồn
        if not StopSkill then
            if not gui.CoolManager:IsCooling(nx_int(skill2[2]), nx_int(skill2[3])) then
                StopSkill = true
                fight:TraceUseSkill(skill2[1], false, false)
            end
        end
    end
end

-- Kiểm tra sắp skill ma khí tung hoành đúng ô
function check_valid_skill_mkth()
    local form = nx_value("form_stage_main\\form_main\\form_main_shortcut")
    local grid = form.grid_shortcut_2
    local gindex = 7
    --grid:SetSelectItemIndex(nx_int(gindex))
    --nx_execute("form_stage_main\\form_main\\form_main_shortcut", "on_main_shortcut_useitem", grid, gindex, true)
    if nx_widestr(grid:GetItemName(gindex)) ~= util_text("cs_jh_tmjt06") then
        return false
    end
    return true
end

-- Giết = phật tâm chưởng
function killCompetitorByPTC(obj, vobj, allowedBuffSkill)
    local gui = nx_value("gui")
    if not nx_is_valid(gui) then
        return false
    end
    if not nx_is_valid(obj) then
        return false
    end
    if not nx_is_valid(vobj) then
        return false
    end
    local fight = nx_value("fight")
    if not nx_is_valid(fight) then
        return false
    end

    -- SkillID - ColType - ColTeam
    local skillPhaDef = {"CS_jh_xfz06", 12843, 50272} -- Tịch Diệt Gia Trì
    local skill1 = {"CS_jh_xfz02", 12839, 50272} -- Không Tương Vô Tương
    local skillNo = {"CS_jh_xfz05", 12842, 50272} -- Thiên Cổ Lôi Âm Như La Ấn
    local skillTarget = {"CS_jh_xfz01", 12833, 50272} -- Phi Thường Vô Thường
    local skillBuff = {"CS_jh_xfz03", 12840, 50272} -- Pháp Giới Hư Không Bồ Tát Ấn

    -- Ô đầu tiên là ô phá def
    local readyDestroyParry = false
    if not gui.CoolManager:IsCooling(nx_int(skillPhaDef[2]), nx_int(skillPhaDef[3])) then
        readyDestroyParry = true
    end
    if obj:QueryProp("InParry") ~= 0 and readyDestroyParry then
        -- Đối thủ đỡ đòn thì phá def
        fight:TraceUseSkill(skillPhaDef[1], false, false)
    else
        -- Đối thủ không đỡ đòn thì đánh
        local StopSkill = false
        -- Đánh skill Thiên Cổ Lôi Âm Như La Ấn nếu đủ 25 nộ khí
        if getPlayerPropInt("SP") > nx_int(25) and not gui.CoolManager:IsCooling(nx_int(skillNo[2]), nx_int(skillNo[3])) then
            StopSkill = true
            nx_execute("game_effect", "add_ground_pick_decal", "map\\tex\\Target_area_G.dds", 16, "20")
            nx_execute("game_effect", "locate_ground_pick_decal", vobj.PositionX, vobj.PositionY, vobj.PositionZ)
            fight:TraceUseSkill(skillNo[1], false, true)
            nx_execute("game_effect", "del_ground_pick_decal")
        end
        -- Đánh Không Tương Vô Tương
        if not StopSkill then
            if not gui.CoolManager:IsCooling(nx_int(skill1[2]), nx_int(skill1[3])) then
                StopSkill = true
                fight:TraceUseSkill(skill1[1], false, false)
            end
        end
        -- Đánh Phi Thường Vô Thường
        if not StopSkill then
            if not gui.CoolManager:IsCooling(nx_int(skillTarget[2]), nx_int(skillTarget[3])) then
                StopSkill = true
                fight:TraceUseSkill(skillTarget[1], false, false)
            end
        end
        -- Đánh Pháp Giới Hư Không Bồ Tát Ấn
        if not StopSkill and allowedBuffSkill ~= nil then
            if not gui.CoolManager:IsCooling(nx_int(skillBuff[2]), nx_int(skillBuff[3])) then
                StopSkill = true
                fight:TraceUseSkill(skillBuff[1], false, false)
            end
        end
        -- Tịch Diệt Gia Trì
        if not StopSkill then
            if not gui.CoolManager:IsCooling(nx_int(skillPhaDef[2]), nx_int(skillPhaDef[3])) then
                StopSkill = true
                fight:TraceUseSkill(skillPhaDef[1], false, false)
            end
        end
    end
end

-- Quét tìm NPC theo ID (NPC đầu tiên)
-- configID dưới dạng table
-- Không có NPC trả về nil, có trả về obj và visual
-- noCanAttack => bỏ trống thì chỉ quét NPC đánh được
-- distance => bỏ trống thì không giới hạn khoảng cách
-- dismissDead => Bỏ trống thì không quan tâm sống chết, nếu không bỏ thì chỉ quét NPC chưa chết
function find_npc_to_kill(configID, noCanAttack, distance, dismissDead)
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return nil
    end
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return nil
    end
    local game_scence = game_client:GetScene()
    if not nx_is_valid(game_scence) then
        return nil
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return nil
    end
    local gui = nx_value("gui")
    if not nx_is_valid(gui) then
        return nil
    end
    local fight = nx_value("fight")
    if not nx_is_valid(fight) then
        return nil
    end

    -- Quét các đối tượng, lấy đối tượng gần nhất
    local minDistance = 9999
    local curObj = nil
    local curVObj = nil
    local game_scence_objs = game_scence:GetSceneObjList()
    curObj = nx_null()
    curVObj = nx_null()

    -- Duyệt các đối tượng để kiểm tra
    for i = 1, table.getn(game_scence_objs) do
        local obj = game_scence_objs[i]
        local vobj = game_visual:GetSceneObj(nx_string(obj.Ident))
        if nx_is_valid(obj) and nx_is_valid(vobj) then
            -- Xác định khoảng cách từ mình tới NPC
            local currDistance = getCompetitorDistance(vobj)
            -- Kiểm tra các điều kiện
            if in_array(nx_string(obj:QueryProp("ConfigID")), configID) and (
                dismissDead ~= nil or (obj:QueryProp("Dead") ~= 1 and obj:QueryProp("Dead") ~= 2)
            ) and (noCanAttack ~= nil or fight:CanAttackNpc(player_client, obj)) and (
                distance == nil or tools_move_isArrived(vobj.PositionX, vobj.PositionY, vobj.PositionZ, distance)
            ) and (
                currDistance < minDistance
            ) then
                minDistance = currDistance
                curObj = obj
                curVObj = vobj
            end
        end
    end
    if nx_is_valid(curObj) and nx_is_valid(curVObj) then
        return curObj, curVObj
    end
    return nil
end

-- Nhấp vào đối thủ, nếu đã chọn trả về true, nếu chưa thì nhấp vào trả về false
function setTargetCompetitor(obj)
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return false
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return false
    end
    if not nx_is_valid(obj) then
        return false
    end
    local selObjID = player_client:QueryProp("LastObject")
    local selObj = game_client:GetSceneObj(nx_string(selObjID))
    if nx_is_valid(selObj) and selObj.Ident == obj.Ident then
        return true
    else
        nx_execute("custom_sender", "custom_select", obj.Ident)
    end
    return false
end

-----------------
-- Xác định khoảng cách từ một điểm đến đối tượng
--
function getDistanceWithObj(pos, vobj)
    if not nx_is_valid(vobj) then
        return 0
    end
    local px = string.format("%.3f", vobj.PositionX)
    local py = string.format("%.3f", vobj.PositionY)
    local pz = string.format("%.3f", vobj.PositionZ)

    local pxd = px - pos[1]
    local pyd = py - pos[2]
    local pzd = pz - pos[3]

    return math.sqrt(pxd * pxd + pzd * pzd)
end

-- Function swap button 2 trong form swap cần sử dụng
function AutoGetCurSelect2()
  if not nx_is_valid((nx_value(GAME_SELECT_OBJECT))) then
    return nil
  end
  if nx_is_valid((nx_value("game_visual"))) then
    return (nx_value(GAME_SELECT_OBJECT))
  end
  return nil
end

-- Thụ nghiệp
function X_DeadState(OBJ)
	if nx_is_valid(nx_value("game_client")) and nx_is_valid(nx_value("game_client"):GetPlayer()) and nx_value("game_client"):GetPlayer():FindProp("LogicState") and nx_value("game_client"):GetPlayer():QueryProp("LogicState") == 120 then
		return true
	end
	if nx_is_valid(nx_value("game_client")) and nx_is_valid(nx_value("game_client"):GetPlayer()) and nx_value("game_client"):GetPlayer():FindProp("Dead") and nx_value("game_client"):GetPlayer():QueryProp("Dead") == 1 then
		return true
	end
	return false
end

function X_Relive(type,p_time)
	if type == "near" then
		nx_execute("custom_sender", "custom_relive", 2, 0)
		nx_pause(p_time)
	elseif type == "home" then
		nx_execute("custom_sender", "custom_relive", 0, 0)
		nx_pause(p_time)
	elseif type == "chientruong" then
		nx_execute("custom_sender", "custom_relive", 10)
		nx_pause(p_time)
	end
end

function X_GetHomeSchool()
	local game_client = nx_value("game_client")
	if not nx_is_valid(game_client) then
		return nil
	end
	local client_player = game_client:GetPlayer()
	local home_tele_id = nil
	local maxhp = GetRecordHomePointCount()
	for index = maxhp-1, 0, -1 do
		if nx_is_valid(client_player) then
			local home_tele_index = client_player:QueryRecord(HomePointList, index, 1)
			if nx_string(home_tele_index) == "2" then
				home_tele_id = nx_string(client_player:QueryRecord(HomePointList, index, 0))
				break
			end
		end
	end
	return home_tele_id
end

function tele(hp_id)
	local target_hp = nx_string(hp_id)
	local is_exist = IsExistRecordHomePoint(nx_string(target_hp))
	if is_exist then
		send_homepoint_msg_to_server(Use_HomePoint,target_hp,4)
		return true
	else
		local _ExTypecount = GetExistHomePointCount(JiangHu_HomePoint)
		local _MaxTypeCount = GetTypeHomePointCount(JiangHu_HomePoint)
		if _ExTypecount < _MaxTypeCount then
			send_homepoint_msg_to_server(Add_HomePoint,target_hp)
			--nx_execute("form_stage_main\\form_homepoint\\home_point_data","send_homepoint_msg_to_server",Add_HomePoint,target_hp)
			nx_pause(0.5)
			send_homepoint_msg_to_server(Use_HomePoint,target_hp,4)
			--nx_execute("form_stage_main\\form_homepoint\\home_point_data","send_homepoint_msg_to_server",Use_HomePoint,target_hp,4)
			return true
		else
			local game_client = nx_value("game_client")
			local client_player = game_client:GetPlayer()
			if nx_is_valid(client_player) then
				local maxhp = GetRecordHomePointCount()
				for index = maxhp-1, 0, -1 do
					local last_hp_id = client_player:QueryRecord(HomePointList, index, 0)
					local bRet, hp_info = GetHomePointFromHPid(last_hp_id)
					if bRet == true then
						local hp_type = get_hp_type(hp_info[HP_TYPE])
						if hp_type == JiangHu_HomePoint then
							send_homepoint_msg_to_server(Del_HomePoint,last_hp_id)
							--nx_execute("form_stage_main\\form_homepoint\\home_point_data","send_homepoint_msg_to_server",Del_HomePoint,last_hp_id)
							nx_pause(0.5)
							send_homepoint_msg_to_server(Add_HomePoint,target_hp)
							--nx_execute("form_stage_main\\form_homepoint\\home_point_data","send_homepoint_msg_to_server",Add_HomePoint,target_hp)
							nx_pause(0.5)
							send_homepoint_msg_to_server(Use_HomePoint,target_hp,4)
							--nx_execute("form_stage_main\\form_homepoint\\home_point_data","send_homepoint_msg_to_server",Use_HomePoint,target_hp,4)
							return true
							--break
						end
					end
				end
			end
		end
	end
end

function tele_map(map)
	local HPCount = GetSceneHomePointCount()
	if HPCount >= 0 then
		for i = 0, HPCount - 1 do
			local bRet, hp_info = GetHomePointFromIndexNo(i)
			if bRet == true then
				--Trùng hàm get_scene_name nên phải gọi trực tiếp get_scene_name của home_point_data mới xử lý dc HP_SCENE_NO
				local sceneID = nx_execute("form_stage_main\\form_homepoint\\home_point_data","get_scene_name",nx_int(hp_info[HP_SCENE_NO]))
				--local sc_name = get_scene_name(sceneID)
				local hpTYPE = hp_info[HP_TYPE]
				if (map == sceneID or map == get_scene_name(sceneID)) and hpTYPE <= 1 then
					local tele_id = nx_string(hp_info[HP_ID])
					tele(tele_id)
					return true
				end
			end
		end
	end
end

function map_id()
	local client = nx_value("game_client")
	if not nx_is_valid(client) then
		return
	end
	local scene = client:GetScene()
	if not nx_is_valid(scene) then
		return
	end
	return scene:QueryProp("Resource")
end

function move_(scene, x, y, z, passtest)
	if passtest == nil then
		passtest = true
	end
	if passtest == true then
		tools_show_notice(nx_function("ext_utf8_to_widestr", "Đang chạy tới..."))
		nx_value("path_finding"):FindPathScene(scene, x, y, z, 0)
		return true
	end
end

function be_finding(visual_player)
	if nil == visual_player then
		local game_visual = nx_value("game_visual")
		if not nx_is_valid(game_visual) then
			return false
		end
		visual_player = game_visual:GetPlayer()
	end
	if nx_find_custom(visual_player, "path_finding") then
		if visual_player.path_finding and visual_player.path_finding ~= nil then
			return true
		end
	end

	return false
end

function X_StopFinding()
	if nx_is_valid(nx_value("game_visual")) then
		nx_value("path_finding"):StopPathFind(nx_value("game_visual"):GetPlayer())
	end
end

function xuongngua()
	if get_buff_info("buf_riding_01") ~= nil then
		nx_execute("custom_sender", "custom_remove_buffer", "buf_riding_01")
		nx_pause(0.2)
	end
end

function stop_finding()
	if be_finding() then
		local form_map = nx_value("form_stage_main\\form_map\\form_map_scene")
		local start_x = form_map.pic_map.TerrainStartX
		local start_z = form_map.pic_map.TerrainStartZ
		move_(map_id(),start_x, 0, start_z,true)
		--nx_value("path_finding"):StopPathFind(nx_value("game_visual"):GetPlayer())
	end
end

-- Lấy data npc dịch chuyển ẩn thế về bát phái
function atData(name)
	-- Đạt Ma
	if name == "newschool_damo" then
		return {
		telemap="school18",
		related_map="school08",
		npc_id = "offline_chuansong_dmp01",
		--toa_do = {x = -375.869, y = 276.226, z = -573.367},
		talk_code = {841007892, 840007892}
		}
	end
	-- Huyết Đao
	if name == "newschool_xuedao" then
		return {
		telemap="born02",
		related_map="school01",
		npc_id = "offline_chuansong_xd01",
		--toa_do = {x = 557.210, y = 32.434, z = 918.891},
		talk_code = {841007530, 840007530}
		}
	end
	-- Hoa Sơn
	if name == "newschool_huashan" then
		return {
		telemap="school17",
		related_map="school03",
		npc_id = "offline_chuansong_hsp01",
		--toa_do = {x = 1566.037, y = 133.525, z = 693.222},
		talk_code = {841007886, 840007886}
		}
	end
	-- Thần Thủy Cung
	if name == "newschool_shenshui" then
		return {
		telemap="school19",
		related_map="school06",
		npc_id = "offline_chuansong_ssg01",
		talk_code = {841007890, 840007890}
		}
	end
	-- Ngũ Tiên
	if name == "newschool_wuxian" then
		return {
		telemap="school12",
		related_map="school04",
		npc_id = "offline_chuansong_wxj01",
		talk_code = {841007888, 840007888}
		}
	end
	-- Cổ Mộ
	if name == "newschool_gumu" then
		return {
		telemap="school14",
		related_map="school07",
		npc_id = "offline_chuansong_gm01",
		talk_code = {841007534, 840007534}
		}
	end
	-- TPTC
	if name == "newschool_changfeng" then
		return {
		telemap="city03",
		related_map="school02",
		npc_id = "offline_chuansong_cf01",
		talk_code = {841007773, 840007773}
		}
	end
	-- Niệm La
	if name == "newschool_nianluo" then
		return {
		telemap="school15",
		related_map="school05",
		npc_id = "offline_chuansong_nl01",
		talk_code = {841007775, 840007775}
		}
	end
	return false
end
-----XData--End