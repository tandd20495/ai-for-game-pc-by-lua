require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")

function get_miracle()
	-- Click 1 cai thi chay, click cai nua thi dung
	if not auto_is_running then
		auto_is_running = true
		num_repeated = 0
		yBreaker_show_Utf8Text("Bắt đầu nhận kỳ ngộ!")
		
		while auto_is_running == true do
			auto_capture_qt()
			
			num_repeated = num_repeated + 1
			if num_repeated >= 12 then
				num_repeated = 0
				yBreaker_show_Utf8Text("Đang tự động nhận kỳ ngộ!")
			end
			nx_pause(2)
		end
	else
		auto_is_running = false
		yBreaker_show_Utf8Text("Kết thúc nhận kỳ ngộ!")
	end
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
					if nx_is_valid(form_giveitems1) and form_giveitems1.Visible and nx_find_custom(form_giveitems1, "btn_mail") then
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
    if npc_id == "npc_qygp_zy_xlh2" then
        return {"841004884", "841004885", "100011213", "101011213"}
    end
    -- Tiểu Mẫn (Thiết 1)
    if npc_id == "npc_qy_luxia_xiaomin_0" then
        return {"841005683", "100012257", "101012257"}
    end
    -- Tô Tú Vân (Thiết 2)
    if npc_id == "WorldNpc01146" then
    	return {"841001445", "840014451"}
    end
    -- Ô Hạ (Nữ Nhi Hồng x4)
    if npc_id == "npc_qygp_cc_wu" then
        return {"841004886", "100018911", "101018911"}
    end
    -- Bốc Man Tài (Gà Nướng Trui)
    if npc_id == "NPC_qygp_bybukuai" then
        return {"841004952", "100018240", "101018240"}
    end
    -- Trần Tiểu Thành (Nghịch Thiên Tà Công)
    if npc_id == "funnpcskill002001" then
        return {"841004298", "841004299", "841004300", "840043000"}
    end
    -- Nhạc Minh Kha (Mảnh Thác Bản)
    if npc_id == "WorldNpc_qywx_007" then
        return {"841006152", "100010345", "101010345"}
    end
    -- Ngô Quỳnh (Kim Ngân Hoa)
    if npc_id == "Npc_qygp_chz_003" then
        return {"841006740", "840067400"}
    end
    -- Chồn con (Điêu nhung)
    if npc_id == "npc_cwqy_cc_01" then
    	return {"841004405", "100012222", "101012222"}
    end
    -- La Sát Nữ (Tàn Dương)
    if npc_id == "qy_ng_cjbook_jh_202" then
        return {"841003673", "840036730"}
    end
    -- La Sát Nữ (Vô Vọng)
    if npc_id == "qy_ng_cjbook_jh_201" then
        return {"841003672", "840036720"}
    end
    -- La Sát Nữ (Tử Hà)
    if npc_id == "qy_ng_cjbook_jh_204" then
        return {"841003675", "840036750"}
    end
    -- Năng Chuyên Đô (Bệ Xảo 2)
    if npc_id == "WorldNpc09727" then
    	return {"841001239", "840012391"}
    end
    -- Thành Bích Quân (Đả Cẩu Bổng)
    if npc_id == "WorldNpc09611" then
        return {"841001143", "841001072", "840010721"}
    end
    -- Tổ Hưng (Long Trảo Thủ)
    if npc_id == "WorldNpc00343" then
        return {"841001465", "841001466", "841001467", "841001517", "841001518", "841001519", "840015191"}
    end
    -- Lư Đại Thúc (Phệ Ma Tán)
    if npc_id == "npc_qygp_dy_wle" then
        return {"841004887", "100018763", "101018763"}
    end
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
    if npc_id == "NPC_qygp_tjq_jmy001" then
        return {"841004877", "841004878", "841004879", "841004880", "841004881", "841004882", "841004883", "100010930", "101010930"}
    end
    -- Bành Xương Quý (Đả Cẩu Bổng)
    if npc_id == "WorldNpc04349" then
        return {"841002465", "841002466", "841002467", "841002468", "841002470", "100017404", "101017404"}
    end
    -- Mật Lư - Trị Giang (Yết Chi Thượng Hạng) - Bỏ, rẻ rờ
    if npc_id == "Npc_qygp_shl_002" then
      --return {"841008048", "841008049", "840080490"}
    end
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

-- Chạy...
get_miracle()