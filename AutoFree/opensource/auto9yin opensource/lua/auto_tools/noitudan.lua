require("const_define")
require("util_gui")
require("util_functions")
require("share\\server_custom_define")
require("define\\sysinfo_define")
require("share\\chat_define")
require("define\\request_type")
require("auto_tools\\tool_libs")
require("auto\\lib2")
require("auto\\lib")
local FORM_CONFIRM = "form_common\\form_confirm"	
local auto_is_running = false
local num_repeated = 0
function auto_init()
	-- Click 1 cai thi chay, click cai nua thi dung
	if not auto_is_running then
		auto_is_running = true
		AutoSendNotice("Bắt đầu tự động dùng nội tu đan")
		while auto_is_running == true do
			local tuido = util_get_form("form_stage_main\\form_bag", true, true)
			if nx_is_valid(tuido) then
				tuido:Show()
				tuido.Visible = true
				tuido.rbtn_tool.Checked = true
			end
				if not find_buffer("buf_lilianyao_2") and item_count_id("growitem_11") > 0 then
					use_item_id("growitem_11")
					nx_pause(0.5)
				local dialog = nx_execute("form_common\\form_confirm", "get_new_confirm_form", "confirm_use_item")
				if nx_is_valid(dialog) then
					local btn = dialog.ok_btn
					nx_execute(FORM_CONFIRM, "ok_btn_click", btn)
				end
				end
				if item_count_id("itm_neixiu_01") > 0 and not find_buffer("itmbuf_neixiu_01") then
					use_item_id("itm_neixiu_01")
				end
				if  item_count_id("itm_neixiu_02") > 0 and not find_buffer("itmbuf_neixiu_02") then --Nguyệt Ngưng Nội Tu Đan
					use_item_id("itm_neixiu_02")
				end
				if item_count_id("itm_neixiu_03") > 0 and not  find_buffer("itmbuf_neixiu_03") then
					use_item_id("itm_neixiu_03")
				end
				if item_count_id("itm_neixiu_04") > 0 and not  find_buffer("itmbuf_neixiu_04") then
					use_item_id("itm_neixiu_04")
				end
				if item_count_id("itm_neixiu_05") > 0 and not find_buffer("itmbuf_neixiu_05") then
					use_item_id("itm_neixiu_05")
				end
				if item_count_id("itm_neixiu_06") > 0 and not find_buffer("itmbuf_neixiu_06") then
					use_item_id("itm_neixiu_06")
				end
				if item_count_id("itm_neixiu_07") > 0 or item_count_id("itm_neixiu_08") > 0 or item_count_id("itm_neixiu_09") > 0 then
				if not find_buffer("itmbuf_neixiu_07")  then 
					if item_count_id("itm_neixiu_08") > 0 then
						use_item_id("itm_neixiu_08")
					else
						if item_count_id("itm_neixiu_09") > 0 then
							use_item_id("itm_neixiu_09")
						else 	
							if item_count_id("itm_neixiu_07") > 0 then
								use_item_id("itm_neixiu_07")
							end
						end
					end	
				end
				end
				num_repeated = num_repeated + 1
				if num_repeated >= 5 then
					num_repeated = 0
					AutoSendNotice("Đang tự động dùng nội tu đan")
				end
			nx_pause(5)
			end
	else
		auto_is_running = false
		AutoSendNotice("Kết thúc auto dùng nội tu đan")
	end
end

--item_schoolfight_002=tốc tu đan 30% 30ph
--itm_neixiu_01=Xích Ngọc Đan 20% 1h
--itm_neixiu_02=Nguyệt Ngưng Nội Tu Đan 40% 1h
--itm_neixiu_03=Thúy Ngọc Nội Tu Đan 100% 1h
--itm_neixiu_04=Hổ Phách Nội Tu Đan 100% 30ph
--itm_neixiu_05=Thần Lộ Nội Tu Đan 40% 15ph
--itm_neixiu_06=Triều Dương Nội Tu Đan 200% 15ph
--itm_neixiu_07=Tinh Chế Nguyệt Ngưng Nội Tu Đan 200% 1h // thứ 3
--itm_neixiu_08=Nguyệt Ngưng Nội Tụ Đan Tinh Chế (1 ngày) 200% 1h // dùng đầu tiên
--itm_neixiu_09=Nguyệt Ngưng Nội Tụ Đan Tinh Chế (3 ngày) 200% 1h // dùng thứ 2


--desc_buf_lilianyao_1_1=Tăng tốc độ chuyển đổi kinh nghiệm 25%
--desc_buf_lilianyao_1_2=Tăng tốc độ chuyển đổi kinh nghiệm 50%
--desc_buf_lilianyao_1_3=Tăng tốc độ chuyển đổi kinh nghiệm 100%
--desc_buf_lilianyao_1_4=Tăng tốc độ chuyển đổi kinh nghiệm 150%
--desc_buf_lilianyao_1_5=Tăng tốc độ chuyển đổi kinh nghiệm 250%
--desc_buf_lilianyao_1_6=Tăng tốc độ chuyển đổi kinh nghiệm 150%
--desc_buf_lilianyao_1_7=Tăng tốc độ chuyển đổi kinh nghiệm 200%
--desc_buf_lilianyao_1_8=Tăng tốc độ chuyển đổi kinh nghiệm 250%
--desc_buf_lilianyao_2_0=Tăng tốc độ chuyển đổi lịch luyện 350%

--faculty_yanwu_jhdw06=Minh linh đan

--growitem_1=Hàn Nha Thảo
--growitem_2=Hoàng Bách Đan
--growitem_3=Tụ Khí Đan
--growitem_4=Trấn Tâm Hoàn
--growitem_5=Bích Tiêu Đan
--growitem_6=Thiếu Dương Đan
--growitem_7=Thông Thiên Thào
--growitem_8=Hoàng Tiên Lộ
--growitem_11=Bách Hoa Thanh Tâm Đan
