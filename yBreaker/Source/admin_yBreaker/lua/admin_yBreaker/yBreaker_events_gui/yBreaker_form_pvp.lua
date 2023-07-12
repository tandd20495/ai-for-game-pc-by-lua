require("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs")
require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")
	-- Swap(có tích chọn: VK theo skill đánh/vk+oản 30%/bình thư/áo)
	-- Bắt Target
	-- Auto Def
	-- Swap Mạch/đồ

local THIS_FORM = "admin_yBreaker\\yBreaker_form_pvp"
local auto_is_running = false

local arrayActions = {
	-- Phá def của các bộ skill
    -- Các bộ hay sử dụng
    "chz_07", 			-- Tham Hợp Chỉ
	"tdbj_05", 			-- Huyết Hải Ma Đao
	"xfz_07", 			-- Phật Tâm Chưởng
	"jb_aq_08", 		-- Linh Lung Đầu
	"wuji_CS_tm_ywt05", -- Diêm Vương Trịch Bút
	"CS_yhwq_hsqs03", 	-- Hoa Thần (Vô Khuyết)
	"tjq03",			-- Thái Cực Quyền (Cổ)
	"myjf05", 			-- Mị Ảnh Kiếm Pháp
	"dgbf05",			-- Đả Cẩu Bổng (Cổ)
	"wxq_04", 			-- Long Trảo Thủ cổ
	"shl_03", 			-- Thánh Hỏa Lệnh
	"xld_05", 			-- Tu La Đao
	"lhq03", 			-- La Hán Quyền
	"jdmz03",			-- Kim Đỉnh
    "qzjf_05", -- Cù Chi Kiếm Pháp
    "tzcq_06", -- Thái Cực Quyền
    "xsd_01_01", -- Huyết Sát Đao
    "CS_hs_kfkj05", -- Cuồng Phong Khoái Kiếm
    "xyt_07", -- Thô Thiển
    "jgjf_03", -- Cửu Cung
    "jb_2h_04", -- Tuyết Trai
    "CS_hs_hsjf03", -- Hoa Sơn Kiếm
    "jb_8h_06", -- Phong Ma Trượng Pháp
    "jb_2h_08", -- Ngọc Nữ Kiếm Pháp (Trấn phái Nga Mi)
    "bxjf_05", -- Tịch Tà Kiếm Pháp
    "wlbgg_02", -- Ngũ Lang Bát Quái Côn
    "dgb_08", -- Đả Cẩu Bổng
	
    -- Các bộ ít hay sử dụng hơn
    "ynsxj_06", -- Ngọc Nữ Tố Tâm Kiếm
    "jsjf_04", -- Kim Xà Kiếm
    "jb_0h_08", -- Ma Tâm
    "yyd07", -- Uyên Ương Song Đao (không nộ)
    "sfj_03", -- Thần Phong Quyết
    "kfdf07", -- Cuồng Phong Đao
    "bwq_04", -- Nhạc Gia Thương Pháp
    "CS_jh_klsjj01", -- Húc Nhật Kiếm Pháp
    "jb_2h_05", -- Đoạt Mệnh Thập Tam Kiếm
    "wyc_05", -- Nghê Thường Động
    "jb_6h_06", -- Thiên La Vũ
    "CS_jh_plbz06", -- Phá Liên Bát Trứ
    "bgd_05", -- Bát Quái Đao
    "hsqs_03", -- Hoa Thần Thất Thức
    "jb_aqss_04", -- Truy Hồn Trảo
    "jb_2h_07", -- Mặc Tử Kiếm
    "xyjj_02", -- Tây Dương Tích Kiếm
    "yxj_04", -- Thái Huyền Tương Hoa Kiếm Phổ
    "CS_jz_yydbf02", -- Âm Dương Đại Bi Phủ (Mật truyền QTĐ)
    "yywd_06", -- Viên Nguyệt Loan Đao

    "CS_jh_ahlj04", -- Ngạo Hàn Lục Quyết
    "CS_jh_yydld01", -- Âm Dương Đảo Loạn Đao
    "CS_jh_gwc05", -- Quỷ Vương Thích
    "CS_tm_ykr02", -- Ẩn Không Nhẫn
    "jysp_03", -- Cô Tẩy Thích Quyết
    "CS_jh_yybtbf04", -- Nhất Dương Bi Thiếp Bổng Pháp

    -- Các bộ ít sử dụng
    "qxj_02", -- Thất Tình Kiếm (Song Kiếm Cast Shops)
    "CS_jh_yxfj06", -- Vân Tiêu Phi Kiếm
    "att_2H_04", -- Thanh Phong Kiếm
    "CS_jh_hq02", -- Hầu Quyền
    "CS_dm_qys01", -- Đại Bi Nhàn Dược ... (Đạt Ma)
    "qzwds_03", -- Thiên Thù Vạn Độc Thủ
    "CS_gb_xlsbzc01", -- Hàn Long Chưởng Pháp
    "bhjtz_04_hide02", -- Thuệ Thủy Quyết
    "nrjbd_05", -- Nam Nhân Kiến Bất Đắc
    "jb_1h_07", -- Kim Lộc Thần Đao
    "xlxf_04", -- Huyết Long Tà Phủ
    "CS_jh_mzmyc01", -- Thiên Ma Thích Quyết
    "wgl01", -- Vũ Quỷ Lục
    "taiq_04", -- Nam Dương Quyền Pháp
    "xfsyt_02", -- Toàn Phong Hảo Hiệp Thoái
    "ttg_04", -- Thiết Đầu Công
    "xyt_06", -- Tiêu Dao Thoái Pháp
    "tzcq_07", -- Kim Đỉnh Miên Chưởng
    "jxc03", -- Kinh Tuyết Thích
    "CS_jh_kxtd_07", -- Khôi Tinh Thích Đấu
    "sbz_04", -- Hàng Long Thập Ba Chưởng
    "CS_jy_tdshs04", -- Thiên Địa Sưu Hồn Tỏa
    "xdj_01", -- Huyết Đao Quyết
    "hjdf_02", -- Hồ Gia Đao Pháp
    "jb_1h_05", -- Đoạn Tình Thất Tuyệt, Viêm Dương Đao, Khốn Thiên Đao Quyết
    "wdj_05", -- Thái Cực Kiếm, Toàn Chân Kiếm
    "bhcs_06", -- Bích Hải Triều Sinh Khúc
    "CS_wd_rzrj03", -- Nhiễu Chỉ Nhu Kiếm (Tuyệt Học Võ Đang)
    "CS_jl_bmjs01", -- Bát Môn Kim Tỏa (Tuyệt Học Cực Lạc Cốc)
    "CS_jb_3h_05", -- Kim Xà Thích
    "CS_em_qcc01", -- Khuynh Thành Thích
    "CS_wxj_gyxhj02", -- Cổ Nguyệt Liên Hoàn Quyết
    "wsgf_06", -- Võ Thánh Côn Pháp
    "CS_dm_fmgf06", -- Phục Ma Côn Pháp
    "jb_aq_03", -- Mê Hồn Tiêu
}
local dataSkill = {
    ["hsd"] = {
        ["sk1"] = {"CS_jy_xsd04", 7847, 50162, 8}, -- Huyết Chiến Bát Phương - Dậm ngã
        ["sk2"] = {"CS_jy_xsd01", 7811, 50162, 1}, -- Huyết Tẩy Sơn Hà - Trói
        ["sk3"] = {"CS_jy_xsd02", 7845, 50162, 4}, -- Truy Tận Sát Tuyệt - Kéo
        ["sk4"] = {"CS_jy_xsd03", 7846, 50162, 4}, -- Đao Quang Huyết Ảnh - Xung phong
    },
    ["cuchi"] = {
        ["sk1"] = {"CS_jh_qzjf03", 14373, 50302, 1}, -- Mai Hoa Tam Lộng - Bá thể đỏ
        ["sk2"] = {"CS_jh_qzjf04", 14374, 50302, 8}, -- Lãnh Mai Phất Diện - Đánh ngã
        ["sk3"] = {"CS_jh_qzjf02", 14372, 50302, 4}, -- Mai Chiếm Tiên Xuân - Xung phong
    },
    ["tuyettrai"] = {
        ["sk1"] = {"CS_jh_hyjf03", 8464, 50167, 8}, -- Mạn Thiên Phong Tuyết - Cấm khinh công
        ["sk2"] = {"CS_jh_hyjf07", 8502, 50167, 1}, -- Tuyết Lạc Vô Ngấn - Đánh ngã
        ["sk3"] = {"CS_jh_hyjf02", 8462, 50167, 4}, -- Phong Sương Ảnh Tuyết - Xung phong 6 mét
    },
    ["cuucung"] = {
        ["sk1"] = {"CS_jh_jgjf06", 11690, 50254, 8}, -- Nhị Tứ Vi Kiên - Đánh ngã 15 mét
        ["sk2"] = {"CS_jh_jgjf05", 11689, 50254, 8}, -- Lục Bát Vi Túc - Dậm định thân 15 mét
        ["sk3"] = {"CS_jh_jgjf02", 11686, 50254, 4}, -- Thượng Hạ Đối Địch - Xung phong 3 mét
    },
	
	["thc"] = {
        ["sk1"] = {"CS_jh_chz01", 12221, 30000, 2}, -- Chỉ Thỉ Thiên Nhật 	- Xung Phong 5m -> 20m
		["sk2"] = {"CS_jh_chz02", 12222, 30000, 2}, -- Bàng Chỉ Khúc Dụ 	- Xung Phong 5m -> 20m
		["sk3"] = {"CS_jh_chz03", 12223, 30000, 2}, -- Nhất Đạn Chỉ Khoảnh 	- Điểm huyệt mê
		["sk4"] = {"CS_jh_chz04", 12224, 30000, 2}, -- Đạn Chỉ Thốc Sinh 	- Xung Phong 5m -> 20m
    },
	
    ["ptc"] = {
        ["sk1"] = {"CS_jh_xfz02", 12839, 50272, 4}, -- Không Tương Vô Tương - Đánh Mê
        ["sk2"] = {"CS_jh_xfz01", 12833, 50272, 4} 	-- Phi Thường Vô Thường - Xung Phong
    },
    ["ltt"] = {
        ["sk1"] = {"CS_sl_lzs02", 8100, 50109, 4}, -- Bổ Phong (Cổ) - Xung Phong 20 mét
        ["sk2"] = {"CS_sl_lzs05", 4858, 50109, 4}, -- Bão Tàn (Cổ) - Xung Phong 6 mét
        ["sk3"] = {"CS_sl_lzs01", 3504, 50109, 8}, -- Đào Hư (Cổ) - Buff để lần sau xung phong choáng
    }
}
local taoluText = {
    [""] = "N/A",
    ["hsd"] = "Huyết Sát Đao",
    ["cuchi"] = "Cù Chi",
    ["tuyettrai"] = "Tuyết Trai",
    ["cuucung"] = "Cửu Cung",
	["thc"] = "Tham Hợp Chỉ",
    ["ptc"] = "Phật Tâm",
    ["ltt"] = "LTT (Cổ)"
}
local binhthuText = {
    [""] = "Không dùng",
    ["ng_ss_5_3"] = "Tiên Thiên (1%)",
    ["ng_ss_5_2"] = "Thánh Hỏa (PC)",
    ["ng_ss_5_1"] = "Nhật Nguyệt (5%)",
    ["zs_hs_5_1"] = "Xích Huyết (15%)"
}

-- Các biến mang tính setting
-- Bộ Skill sử dụng
local taolu = ""
-- Tự đỡ đòn hay người đỡ
local isAutoActiveParry = false
-- Bình thư dùng trong trạng thái phòng ngự
local binhthu = ""

local arraySkillIntergerByID = {
    ["CS_wd_tjq08"] = 6306, -- Khai cổ
    ["CS_sl_lzs07"] = 6206, -- Phê Hàng cổ
    ["CS_jy_xsd08"] = 9721 -- Hàn Phong Ẩm Huyết
}

-- Kiểm tra đã trang bị thành công item chưa
-- Chờ mãi mãi cho đến khi trang bị xong
function checkItemIsEquipSuccess(ItemID)
    local game_client = nx_value("game_client")
    local view = game_client:GetView(nx_string(1))
    while 1 do
        if not nx_is_valid(view) then
            return false
        end
        local items = view:GetViewObjList()
        for j, item in pairs(items) do
            if nx_is_valid(item) and item:QueryProp("ConfigID") == ItemID then
                return true
            end
        end
        nx_pause(0)
    end
end

-- Dùng bình thư bởi ID của bình thư và Skill
-- Nếu skill rỗng thì chỉ quan tâm đến ID bình thư
-- Nếu nhiều bình thư trùng nhau thì bình thư đầu tiên sẽ được chọn
function useBinhThuByIDAndSkill(configID, SkillID)
    local goods_grid = nx_value("GoodsGrid")
    local game_client = nx_value("game_client")
    local view = game_client:GetView(nx_string(121))
    local items = view:GetViewObjList()
    for j, item in pairs(items) do
        if nx_is_valid(item) then
            local grid, index = goods_grid:GetToolBoxGridAndPos(configID)
            if not nx_is_valid(grid) then
                return false
            end
            if SkillID == nil then
                -- Không quan tâm skill thì kết thúc
                goods_grid:ViewUseItem(grid.typeid, grid:GetBindIndex(index), grid, index)
                --logToForm(nx_function("ext_utf8_to_widestr", "Trang bị bình thư: ") .. util_text(configID), true)
                --logToForm("Đang chờ trang bị bình thư xong")
                checkItemIsEquipSuccess(configID)
                return true
            end
            local skillInt = arraySkillIntergerByID[SkillID]
            if skillInt == nil then
                return false
            end
            local binhthuSkill = item:QueryRecord("SkillModifyPackRec", 0, 0)
            if nx_int(binhthuSkill) == nx_int(skillInt) then
                goods_grid:ViewUseItem(grid.typeid, grid:GetBindIndex(index), grid, index)
                --logToForm(nx_function("ext_utf8_to_widestr", "Trang bị bình thư: ") .. util_text(configID), true)
                --logToForm("Đang chờ trang bị bình thư xong")
                checkItemIsEquipSuccess(configID)
                return true
            end
        end
    end
end

-- Các biến dưới đây dùng tạm do code điều khiển
local timeStartSkill = 0

function auto_run()
    -- Reset lại thời gian ra chiêu
    timeStartSkill = 0

    while auto_is_running == true do
        local is_vaild_data = true
        local game_client
        local game_visual
        local game_player
        local game_scence
        local player_client
        game_client = nx_value("game_client")
        if not nx_is_valid(game_client) then
            is_vaild_data = false
        end
        game_visual = nx_value("game_visual")
        if not nx_is_valid(game_visual) then
            is_vaild_data = false
        end
        local gui = nx_value("gui")
        if not nx_is_valid(gui) then
            is_vaild_data = false
        end
        local fight = nx_value("fight")
        if not nx_is_valid(fight) then
            is_vaild_data = false
        end
        local goods_grid = nx_value("GoodsGrid")

        if is_vaild_data == true then
            game_player = game_visual:GetPlayer()
            if not nx_is_valid(game_player) then
                is_vaild_data = false
            end
            game_scence = game_client:GetScene()
            if not nx_is_valid(game_scence) then
                is_vaild_data = false
            end
            player_client = game_client:GetPlayer()
            if not nx_is_valid(player_client) then
                is_vaild_data = false
            end
        end

        -- Nếu dữ liệu ok hết
        if is_vaild_data == true then
            --clearLogForm()
            --logToForm(nx_function("ext_utf8_to_widestr", "Bộ võ: <font color=\"#FF0000\">") .. nx_function("ext_utf8_to_widestr", taoluText[taolu]) .. nx_widestr("</font>"), true)
            if binhthu == "" then
                --logToForm(nx_function("ext_utf8_to_widestr", "Bình thư phòng: <font color=\"#FF0000\">Không dùng (tự swap)</font>"), true)
            else
                --logToForm(nx_function("ext_utf8_to_widestr", "Bình thư phòng: <font color=\"#FF0000\">") .. util_text(binhthu) .. nx_widestr("</font>"), true)
            end
            local select_target_ident = player_client:QueryProp("LastObject")
            local select_target = game_client:GetSceneObj(nx_string(select_target_ident))
            local select_targetv = game_visual:GetSceneObj(nx_string(select_target_ident))
            if nx_is_valid(select_target) and nx_is_valid(select_targetv) then
                local isSkillDestroyParry = false
                local actor_role = select_targetv:GetLinkObject("actor_role")
                if nx_is_valid(actor_role) then
                    local mount_action_list = actor_role:GetActionBlendList()
                    local floor_count = table.maxn(mount_action_list)
                    for i = 0, floor_count - 1 do
                        local action_name = mount_action_list[i + 1]
                        if in_array(action_name, arrayActions) then
                            isSkillDestroyParry = true
                            if timeStartSkill == 0 then
                                -- Xác định thời gian bắt đầu ra chiêu
                                local msg_delay = nx_value("MessageDelay")
                                timeStartSkill = msg_delay:GetServerNowTime()
                            end
                            break
                        end
                    end
                end
                -- Xử lý khi đối thủ đánh phá def
                if isSkillDestroyParry then
                    -- Khi mình ra chiêu thì set lên true để không gửi lệnh nhả def
                    local isHitSkill = false
                    -- Xác định khoảng cách với đối thủ
                    local distance = getCompetitorDistance(select_targetv)
                    -- Xác định thời gian mili giây
                    local msg_delay = nx_value("MessageDelay")
                    local currentMiniSec = msg_delay:GetServerNowTime()
                    local diffTime = currentMiniSec - timeStartSkill
                    if diffTime < 60 then
                        -- Trong vòng 60ms đối thủ ra chiêu thì mới đánh skill khắc nếu không đối thủ sẽ có cơ hội đỡ đòn
                        if taolu == "hsd" then
                            -- Huyết Sát Đao
                            -- Truy tận vào
                            if distance > 5 and not isHitSkill and not gui.CoolManager:IsCooling(nx_int(dataSkill[taolu]["sk3"][2]), nx_int(dataSkill[taolu]["sk3"][3])) then
                                fight:TraceUseSkill(dataSkill[taolu]["sk3"][1], false, false)
                                isHitSkill = true
                            end
                            -- Dậm
                            if distance < 5 and not isHitSkill and not gui.CoolManager:IsCooling(nx_int(dataSkill[taolu]["sk1"][2]), nx_int(dataSkill[taolu]["sk1"][3])) then
                                fight:TraceUseSkill(dataSkill[taolu]["sk1"][1], false, false)
                                isHitSkill = true
                            end
                             -- Trói
                            if not isHitSkill and not gui.CoolManager:IsCooling(nx_int(dataSkill[taolu]["sk2"][2]), nx_int(dataSkill[taolu]["sk2"][3])) then
                                nx_execute("game_effect", "add_ground_pick_decal", "map\\tex\\Target_area_G.dds", 16, "20")
                                nx_execute("game_effect", "locate_ground_pick_decal", select_targetv.PositionX, select_targetv.PositionY, select_targetv.PositionZ)
                                fight:TraceUseSkill(dataSkill[taolu]["sk2"][1], false, false)
                                nx_execute("game_effect", "del_ground_pick_decal")
                                isHitSkill = true
                            end
                            -- Xung phong
                            if distance < 5 and not isHitSkill and not gui.CoolManager:IsCooling(nx_int(dataSkill[taolu]["sk4"][2]), nx_int(dataSkill[taolu]["sk4"][3])) then
                                fight:TraceUseSkill(dataSkill[taolu]["sk4"][1], false, false)
                                isHitSkill = true
                            end
                        elseif taolu == "cuchi" then
                            -- Cù Chi Kiếm Pháp
                            -- Đánh bá thể đỏ cho ngã
                            if not gui.CoolManager:IsCooling(nx_int(dataSkill[taolu]["sk1"][2]), nx_int(dataSkill[taolu]["sk1"][3])) then
                                nx_execute("game_effect", "add_ground_pick_decal", "map\\tex\\Target_area_G.dds", 16, "20")
                                nx_execute("game_effect", "locate_ground_pick_decal", select_targetv.PositionX, select_targetv.PositionY, select_targetv.PositionZ)
                                fight:TraceUseSkill(dataSkill[taolu]["sk1"][1], false, false)
                                nx_execute("game_effect", "del_ground_pick_decal")
                                isHitSkill = true
                            end
                            -- Đánh ngã bởi skill khác
                            if not isHitSkill and not gui.CoolManager:IsCooling(nx_int(dataSkill[taolu]["sk2"][2]), nx_int(dataSkill[taolu]["sk2"][3])) then
                                fight:TraceUseSkill(dataSkill[taolu]["sk2"][1], false, false)
                                isHitSkill = true
                            end
                            -- Xung phong
                            if distance < 5 and not isHitSkill and not gui.CoolManager:IsCooling(nx_int(dataSkill[taolu]["sk3"][2]), nx_int(dataSkill[taolu]["sk3"][3])) then
                                fight:TraceUseSkill(dataSkill[taolu]["sk3"][1], false, false)
                                isHitSkill = true
                            end
                        elseif taolu == "tuyettrai" then
                            -- Tuyết Trai Kiếm Pháp
                            -- Đánh ngã
                            if not gui.CoolManager:IsCooling(nx_int(dataSkill[taolu]["sk2"][2]), nx_int(dataSkill[taolu]["sk2"][3])) then
                                nx_execute("game_effect", "add_ground_pick_decal", "map\\tex\\Target_area_G.dds", 16, "20")
                                nx_execute("game_effect", "locate_ground_pick_decal", select_targetv.PositionX, select_targetv.PositionY, select_targetv.PositionZ)
                                fight:TraceUseSkill(dataSkill[taolu]["sk2"][1], false, false)
                                nx_execute("game_effect", "del_ground_pick_decal")
                                isHitSkill = true
                            end
                            -- Đánh cấm khinh công
                            if distance < 5 and not isHitSkill and not gui.CoolManager:IsCooling(nx_int(dataSkill[taolu]["sk1"][2]), nx_int(dataSkill[taolu]["sk1"][3])) then
                                fight:TraceUseSkill(dataSkill[taolu]["sk1"][1], false, false)
                                isHitSkill = true
                            end
                            -- Xung phong
                            if distance <= 6 and not isHitSkill and not gui.CoolManager:IsCooling(nx_int(dataSkill[taolu]["sk3"][2]), nx_int(dataSkill[taolu]["sk3"][3])) then
                                fight:TraceUseSkill(dataSkill[taolu]["sk3"][1], false, false)
                                isHitSkill = true
                            end
                        elseif taolu == "cuucung" then
                            -- Cửu Cung Kiếm Pháp
                            -- Đánh ngã
                            if distance < 15 and not isHitSkill and not gui.CoolManager:IsCooling(nx_int(dataSkill[taolu]["sk1"][2]), nx_int(dataSkill[taolu]["sk1"][3])) then
                                fight:TraceUseSkill(dataSkill[taolu]["sk1"][1], false, false)
                                isHitSkill = true
                            end
                            -- Đánh định thân
                            if distance < 15 and not isHitSkill and not gui.CoolManager:IsCooling(nx_int(dataSkill[taolu]["sk2"][2]), nx_int(dataSkill[taolu]["sk2"][3])) then
                                fight:TraceUseSkill(dataSkill[taolu]["sk2"][1], false, false)
                                isHitSkill = true
                            end
                            -- Xung phong
                            if distance <= 4 and not isHitSkill and not gui.CoolManager:IsCooling(nx_int(dataSkill[taolu]["sk3"][2]), nx_int(dataSkill[taolu]["sk3"][3])) then
                                fight:TraceUseSkill(dataSkill[taolu]["sk3"][1], false, false)
                                isHitSkill = true
                            end
						elseif taolu == "thc" then
						    -- Điểm huyệt
                            -- Đánh mê
                            if distance < 20 and not isHitSkill and not gui.CoolManager:IsCooling(nx_int(dataSkill[taolu]["sk3"][2]), nx_int(dataSkill[taolu]["sk3"][3])) then
                                fight:TraceUseSkill(dataSkill[taolu]["sk3"][1], false, false)
                                isHitSkill = true
                            end
                            -- Đánh xung phong
                            if distance < 20 and not isHitSkill and not gui.CoolManager:IsCooling(nx_int(dataSkill[taolu]["sk2"][2]), nx_int(dataSkill[taolu]["sk1"][3])) then
                                fight:TraceUseSkill(dataSkill[taolu]["sk1"][1], false, false)
                                isHitSkill = true
                            end
							-- Đánh xung phong
                            if distance < 20 and not isHitSkill and not gui.CoolManager:IsCooling(nx_int(dataSkill[taolu]["sk2"][2]), nx_int(dataSkill[taolu]["sk2"][3])) then
                                fight:TraceUseSkill(dataSkill[taolu]["sk2"][1], false, false)
                                isHitSkill = true
                            end
                        elseif taolu == "ptc" then
                            -- Phật Tâm Chưởng
                            -- Đánh mê
                            if distance < 25 and not isHitSkill and not gui.CoolManager:IsCooling(nx_int(dataSkill[taolu]["sk1"][2]), nx_int(dataSkill[taolu]["sk1"][3])) then
                                fight:TraceUseSkill(dataSkill[taolu]["sk1"][1], false, false)
                                isHitSkill = true
                            end
                            -- Đánh xung phong
                            if distance < 25 and not isHitSkill and not gui.CoolManager:IsCooling(nx_int(dataSkill[taolu]["sk2"][2]), nx_int(dataSkill[taolu]["sk2"][3])) then
                                fight:TraceUseSkill(dataSkill[taolu]["sk2"][1], false, false)
                                isHitSkill = true
                            end
                        elseif taolu == "ltt" then
                            -- Long Trảo Thủ (Cổ)
                            -- Xung phong 20m
                            if distance <= 20 and not isHitSkill and not gui.CoolManager:IsCooling(nx_int(dataSkill[taolu]["sk1"][2]), nx_int(dataSkill[taolu]["sk1"][3])) then
                                fight:TraceUseSkill(dataSkill[taolu]["sk1"][1], false, false)
                                isHitSkill = true
                            end
                            -- Xung Phong 6m
                            if distance <= 6 and not isHitSkill and not gui.CoolManager:IsCooling(nx_int(dataSkill[taolu]["sk2"][2]), nx_int(dataSkill[taolu]["sk2"][3])) then
                                fight:TraceUseSkill(dataSkill[taolu]["sk2"][1], false, false)
                                isHitSkill = true
                            end
                            -- Buff 20m
                            if distance <= 20 and not isHitSkill and not gui.CoolManager:IsCooling(nx_int(dataSkill[taolu]["sk3"][2]), nx_int(dataSkill[taolu]["sk3"][3])) then
                                fight:TraceUseSkill(dataSkill[taolu]["sk3"][1], false, false)
                                isHitSkill = true
                            end
                        end
                    end

                    if getPlayerPropInt("InParry") ~= nx_int(0) then
                        -- Nếu đang đỡ đòn thì hủy, bất kỳ có ra chiêu hay không
                        nx_execute("custom_sender", "custom_active_parry", nx_int(0), nx_int(0))
                    end
                else
                    -- Thiết lập lại thời gian ra chiêu phá def
                    -- Đỡ đòn nếu còn chiến đấu
                    timeStartSkill = 0
                    --logToForm("Đỡ đòn tự do")
                    if isAutoActiveParry and getPlayerPropInt("InParry") == nx_int(0) and game_player.state == "static" and getPlayerPropInt("LogicState") == nx_int(1) then
                        nx_execute("custom_sender", "custom_active_parry", nx_int(1), nx_int(0))
                    end

                    -- Bình Thư
                    local currentSkillID = player_client:QueryProp("CurSkillID")
                    if currentSkillID == "CS_wd_tjq08" then
                        -- Khai Thái Cực Cổ
                        useBinhThuByIDAndSkill("pz_CS_wd_tjq", "CS_wd_tjq08")
                    elseif currentSkillID == "CS_sl_lzs07" then
                        -- Phê Hàng Cổ
                        useBinhThuByIDAndSkill("pz_CS_sl_lzs", "CS_sl_lzs07")
                    elseif currentSkillID == "CS_jy_xsd08" then
                        -- Hàn Phong Ẩm Huyết
                        useBinhThuByIDAndSkill("pz_CS_jy_xsd", "CS_jy_xsd08")
                    elseif binhthu ~= "" then
                        -- Swap bình thư ở trạng thái phòng ngự
                        useBinhThuByIDAndSkill(binhthu)
                    end
                end
            else
                --logToForm("Mời chọn đối thủ")
            end
        end
        nx_pause(0)
    end
end

function on_form_main_init(form)
    form.Fixed = false
    form.is_minimize = true
end

function on_btn_minimize_click(btn)
  local form = btn.ParentForm
  form.Visible = false
end

function on_main_form_open(form)
    change_form_size()
    form.is_minimize = false
    auto_is_running = false
    isAutoActiveParry = false
	
	-- Khởi tạo file ini nếu chưa có
	local game_config = nx_value("game_config")
	local account = game_config.login_account
	local ini = nx_create("IniDocument")
	if not nx_is_valid(ini) then
        return
    end
	
	-- Kiểm tra file đã có chưa?
    ini.FileName = account .. "\\yBreaker_config.ini"
	if not nx_function("ext_is_file_exist", nx_work_path() .. ini.FileName) then
		local section_config = "pvp"
		local taolu_create = ""
        ini:LoadFromFile()
		-- Thêm cấu hình nếu chưa có
		if not ini:FindSection(nx_string(section_config)) then
			ini:AddSection(nx_string(section_config))
		end
		-- Write file ini
		ini:WriteString(nx_string(section_config), "taolu", taolu_create)
		ini:SaveToFile()
		nx_destroy(ini)
    end

    -- Build các bộ võ + Bình Thư
    taolu = nx_execute("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs", "getPvpTaolu")
    binhthu = nx_execute("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs", "getPvpBinhThu")
    reloadSelectTaolu(taolu)
    reloadSelectBinhThu(binhthu)
	form.btn_start_pvp.Text = nx_function("ext_utf8_to_widestr", "Chạy")
	form.btn_start_pvp.ForeColor = "255,255,255,255"
end

function reloadSelectTaolu(setTaolu)
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return
    end
    local combobox_taolu = form.combobox_taolu
    combobox_taolu.DropListBox:ClearString()
    if combobox_taolu.DroppedDown then
        combobox_taolu.DroppedDown = false
    end
	--REM võ chưa sử dụng
    -- combobox_taolu.DropListBox:AddString(nx_function("ext_utf8_to_widestr", taoluText["hsd"]))
    -- combobox_taolu.DropListBox:AddString(nx_function("ext_utf8_to_widestr", taoluText["cuchi"]))
    -- combobox_taolu.DropListBox:AddString(nx_function("ext_utf8_to_widestr", taoluText["tuyettrai"]))
    -- combobox_taolu.DropListBox:AddString(nx_function("ext_utf8_to_widestr", taoluText["cuucung"]))
	combobox_taolu.DropListBox:AddString(nx_function("ext_utf8_to_widestr", taoluText["thc"]))
    combobox_taolu.DropListBox:AddString(nx_function("ext_utf8_to_widestr", taoluText["ptc"]))
    combobox_taolu.DropListBox:AddString(nx_function("ext_utf8_to_widestr", taoluText["ltt"]))
    if setTaolu == "" then
        combobox_taolu.Text = nx_widestr(nx_function("ext_utf8_to_widestr", "----"))
    else
        combobox_taolu.Text = nx_widestr(nx_function("ext_utf8_to_widestr", taoluText[setTaolu]))
    end
end

function reloadSelectBinhThu(setBinhThu)
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return
    end
    local combobox_binhthu = form.combobox_binhthu
    combobox_binhthu.DropListBox:ClearString()
    if combobox_binhthu.DroppedDown then
        combobox_binhthu.DroppedDown = false
    end
    combobox_binhthu.DropListBox:AddString(nx_function("ext_utf8_to_widestr", binhthuText[""]))
    combobox_binhthu.DropListBox:AddString(nx_function("ext_utf8_to_widestr", binhthuText["ng_ss_5_3"]))
    combobox_binhthu.DropListBox:AddString(nx_function("ext_utf8_to_widestr", binhthuText["ng_ss_5_2"]))
    combobox_binhthu.DropListBox:AddString(nx_function("ext_utf8_to_widestr", binhthuText["ng_ss_5_1"]))
    combobox_binhthu.DropListBox:AddString(nx_function("ext_utf8_to_widestr", binhthuText["zs_hs_5_1"]))
    if setBinhThu == "" then
        combobox_binhthu.Text = nx_widestr(nx_function("ext_utf8_to_widestr", binhthuText[""]))
    else
        combobox_binhthu.Text = nx_widestr(nx_function("ext_utf8_to_widestr", binhthuText[setBinhThu]))
    end
end

function resetTaolu(setTaolu)
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return
    end
    taolu = setTaolu
    reloadSelectTaolu(taolu)
end

function resetBinhThu(setBinhThu)
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return
    end
    binhthu = setBinhThu
    reloadSelectBinhThu(binhthu)
end

function on_main_form_close(form)
    auto_is_running = false
    isAutoActiveParry = false
    nx_destroy(form)
    nx_execute("admin_yBreaker\\yBreaker_events_gui\\yBreaker_form_log", "on_btn_close_click", true)
end

function on_btn_close_click(form)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end

function on_btn_start_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
    if auto_is_running then
        auto_is_running = false
		btn.Text = nx_function("ext_utf8_to_widestr", "Chạy")
		btn.ForeColor = "255,255,255,255"
    else
        if taolu == "" then
            tools_show_notice(nx_function("ext_utf8_to_widestr", "Hãy thiết lập bộ võ PVP trước"), 2)
            return false
        end
        auto_is_running = true
		btn.Text = nx_function("ext_utf8_to_widestr", "Dừng")
		btn.ForeColor = "255,220,20,60"
        auto_run()
    end
end

function on_btn_parry_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
    if isAutoActiveParry then
        btn.Text = nx_function("ext_utf8_to_widestr", "Tự Đỡ")
		btn.ForeColor = "255,255,255,255"
        isAutoActiveParry = false
    else
        btn.Text = nx_function("ext_utf8_to_widestr", "Bỏ Đỡ")
		btn.ForeColor = "255,220,20,60"
        isAutoActiveParry = true
    end
end

function change_form_size()
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return
    end
    local gui = nx_value("gui")
    form.Left = 100
    form.Top = (gui.Height / 2)
end

function on_groupbox_dbomall_get_capture(groupbox)
    groupbox.BackImage = "gui\\common\\form_line\\mibox_1.png"
end

function on_groupbox_dbomall_lost_capture(groupbox)
    groupbox.BackImage = ""
end

function on_combobox_taolu_selected(combobox)
    local form = combobox.ParentForm
    if not nx_is_valid(form) then
        return
    end
    local setTaolu = ""
    -- Xác định ra key bộ võ
    if nx_widestr(form.combobox_taolu.Text) == nx_function("ext_utf8_to_widestr", taoluText["hsd"]) then
        setTaolu = "hsd"
    -- elseif nx_widestr(form.combobox_taolu.Text) == nx_function("ext_utf8_to_widestr", taoluText["cuchi"]) then
    --     setTaolu = "cuchi"
    -- elseif nx_widestr(form.combobox_taolu.Text) == nx_function("ext_utf8_to_widestr", taoluText["tuyettrai"]) then
    --     setTaolu = "tuyettrai"
    -- elseif nx_widestr(form.combobox_taolu.Text) == nx_function("ext_utf8_to_widestr", taoluText["cuucung"]) then
    --     setTaolu = "cuucung"
	elseif nx_widestr(form.combobox_taolu.Text) == nx_function("ext_utf8_to_widestr", taoluText["thc"]) then
        setTaolu = "thc"
    elseif nx_widestr(form.combobox_taolu.Text) == nx_function("ext_utf8_to_widestr", taoluText["ptc"]) then
        setTaolu = "ptc"
    elseif nx_widestr(form.combobox_taolu.Text) == nx_function("ext_utf8_to_widestr", taoluText["ltt"]) then
        setTaolu = "ltt"
    end
    taolu = setTaolu
end

function on_combobox_binhthu_selected(combobox)
    local form = combobox.ParentForm
    if not nx_is_valid(form) then
        return
    end
    local setBinhThu = ""
    -- Xác định ra ID bình thư
    if nx_widestr(form.combobox_binhthu.Text) == nx_function("ext_utf8_to_widestr", binhthuText["ng_ss_5_3"]) then
        setBinhThu = "ng_ss_5_3"
    elseif nx_widestr(form.combobox_binhthu.Text) == nx_function("ext_utf8_to_widestr", binhthuText["ng_ss_5_2"]) then
        setBinhThu = "ng_ss_5_2"
    elseif nx_widestr(form.combobox_binhthu.Text) == nx_function("ext_utf8_to_widestr", binhthuText["ng_ss_5_1"]) then
        setBinhThu = "ng_ss_5_1"
    elseif nx_widestr(form.combobox_binhthu.Text) == nx_function("ext_utf8_to_widestr", binhthuText["zs_hs_5_1"]) then
        setBinhThu = "zs_hs_5_1"
    end
    binhthu = setBinhThu
end

function show_hide_form_pvp()
	util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_pvp")
end