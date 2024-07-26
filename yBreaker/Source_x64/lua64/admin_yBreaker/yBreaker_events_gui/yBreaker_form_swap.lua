require("utils")
require("util_gui")
require("util_functions")
require("tips_data")
require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")
require("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs")

-- Initialize skin path for form
local THIS_FORM = "admin_yBreaker\\yBreaker_form_swap"

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
	form.chk_bth.Checked = true
	form.chk_items.Checked = true
	form.btn_swap_items.Text = nx_function("ext_utf8_to_widestr", "Chạy")
	form.btn_swap_items.ForeColor = "255,255,255,255"
	
	-- Variable for swap item equip
    local swap_items_equip = false	
end

function on_main_form_close(form)
    swap_items_equip = false
    nx_destroy(form)
end

function change_form_size()
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return
    end
    local gui = nx_value("gui")
    form.Left = 1343
	form.Top = 692
    --form.Top = (gui.Height / 2)
end

function on_btn_close_click(btn)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end

-- Show hide form swap
function show_hide_form_swap()
	util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_swap")
end


-- Function swap items equip
function on_btn_swap_items_equip_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
	
	if swap_items_equip then
		swap_items_equip = false
		btn.Text = nx_function("ext_utf8_to_widestr", "Chạy")
		btn.ForeColor = "255,255,255,255"
    else
		swap_items_equip = true
		btn.Text = nx_function("ext_utf8_to_widestr", "Dừng")	
		btn.ForeColor = "255,220,20,60"		
    end
	
    local form_bag = util_get_form("form_stage_main\\form_bag")
	if nx_is_valid(form_bag) then
	
		local skill_pack_ini = get_ini_safe("share\\ModifyPack\\SkillPack.ini")
		if nx_is_valid(skill_pack_ini) then
		
			while swap_items_equip do
				nx_pause(0.1)
				local player = yBreaker_get_player()
				if nx_is_valid(player) then
					if player:FindProp("CurSkillID") then
						if player:QueryProp("CurSkillID") ~= "" then				
							equip_item_prop(form_bag, skill_pack_ini, player:QueryProp("CurSkillID"), 1)
							nx_pause(0.1)
						end
					end
				end
			end
		end
	end
end

-- Function get current weapon for swap (Tránh swap 2 cây song đao bích tiêu 20% giật)
function get_cur_weapon(skill_pack_ini, skill_prop)
	local game_client = nx_value("game_client")
	local client_player = game_client:GetPlayer()
	if nx_is_valid(client_player) then
		local scene = game_client:GetScene()
		local view_table = game_client:GetViewList()
		for i = 1, table.getn(view_table) do
			local view = view_table[i]
			if view.Ident == nx_string("1") then
				local view_obj_table = view:GetViewObjList()
				for k = 1, table.getn(view_obj_table) do
					local view_obj = view_obj_table[k]
					if view_obj:QueryProp("EquipType") == "Weapon" then
						local row = view_obj:GetRecordRows("PropModifyPackRec")
						local st_damage = 0
						local cp_damage = 0
						if row > 0 then
							for k = 0, row - 1 do
								local damage = view_obj:QueryRecord("PropModifyPackRec", k, 0)
								if nx_number(damage) > 13033 and nx_number(damage) < 13900 then
									if nx_number(damage) > 13224 then
										-- Công phá
										cp_damage = cp_damage + (nx_number(damage) - 13224)
									else
										-- Sát thương
										st_damage = st_damage + (nx_number(damage) - 13033)
									end
								end
							end
						end

						local skill_damage = 0
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
								if nx_string(tuple[1]) == nx_string(skill_prop) then
									skill_damage = skill_damage + 1
								end
							end
						end
						return st_damage, cp_damage, skill_damage
					end
				end
				break
			end
		end
	end
end

-- Function equip items by properties
function equip_item_prop(form_bag, skill_pack_ini, skill_prop, active)
	if nx_is_valid(form_bag) then
		if nx_is_valid(skill_pack_ini) then
			local item_quip = nx_null()
			local book_10per = nil
			local game_client = nx_value("game_client")
			local client_player = game_client:GetPlayer()
			
			-- Trả về giá trị skill gốc khi là skill võ kỹ
			-- ID: Trịch bút
			if skill_prop == "wuji_CS_tm_ywt07" then 
				skill_prop = "CS_tm_ywt07"
			end
			
			-- Mạnh bà 
			if skill_prop == "wuji_CS_tm_ywt05" then 
				skill_prop = "CS_tm_ywt05"
			end
			
			-- Vô Thường
			if skill_prop == "wuji_CS_tm_ywt03" then
				skill_prop = "CS_tm_ywt03"
			end
			
			-- Long trảo thủ cổ
			if skill_prop == "wuji_CS_sl_lzs06" then
				skill_prop = "CS_sl_lzs06"
			end
			if skill_prop == "wuji_CS_sl_lzs07" then
				skill_prop = "CS_sl_lzs07"
			end
			
			-- Thái cực quyền cổ
			if skill_prop == "wuji_CS_wd_tjq08" then
				skill_prop = "CS_wd_tjq08"
			end
			if skill_prop == "wuji_CS_wd_tjq06" then
				skill_prop = "CS_wd_tjq06"
			end
			if skill_prop == "wuji_CS_wd_tjq03" then
				skill_prop = "CS_wd_tjq03"
			end
			
			-- Kim xà thích
			if skill_prop == "wuji_CS_tm_jsc05" then
				skill_prop = "CS_tm_jsc05"
			end
			if skill_prop == "wuji_CS_tm_jsc06" then
				skill_prop = "CS_tm_jsc06"
			end
			
			-- Đả cẩu bổng Cổ
			if skill_prop == "wuji_CS_gb_dgbf02" then
				skill_prop = "CS_gb_dgbf02"
			end
			if skill_prop == "wuji_CS_gb_dgbf07" then
				skill_prop = "CS_gb_dgbf07"
			end
			if skill_prop == "wuji_CS_gb_dgbf08" then
				skill_prop = "CS_gb_dgbf08"
			end
			
			-- Mị ảnh kiếm
			if skill_prop == "wuji_CS_jh_myjf03" then
				skill_prop = "CS_jh_myjf03"
			end
			if skill_prop == "wuji_CS_jh_myjf08" then
				skill_prop = "CS_jh_myjf08"
			end
			
			-- Kim đỉnh
			if skill_prop == "wuji_CS_em_jdmz01" then
				skill_prop = "CS_em_jdmz01"
			end
			if skill_prop == "wuji_CS_em_jdmz02" then
				skill_prop = "CS_em_jdmz02"
			end
			if skill_prop == "wuji_CS_em_jdmz03" then
				skill_prop = "CS_em_jdmz03"
			end
			
			-- Tịch tà
			if skill_prop == "wuji_CS_jh_bxjf01" then
				skill_prop = "CS_jh_bxjf01"
			end
			if skill_prop == "wuji_CS_jh_bxjf04" then
				skill_prop = "CS_jh_bxjf04"
			end
			if skill_prop == "wuji_CS_jh_bxjf08" then
				skill_prop = "CS_jh_bxjf08"
			end
			
			-- Bích hải
			if skill_prop == "wuji_CS_th_bhcs04" then
				skill_prop = "CS_th_bhcs04"
			end
			if skill_prop == "wuji_CS_th_bhcs06" then
				skill_prop = "CS_th_bhcs06"
			end
			if skill_prop == "wuji_CS_th_bhcs07" then
				skill_prop = "CS_th_bhcs07"
			end
			
			-- Tứ Hải Đao - biến chiêu
			if skill_prop == "CS_dy_sdyjl01_hide" then
				skill_prop = "CS_dy_sdyjl01"
			end
			
			if skill_prop == "CS_dy_sdyjl05_hide" then
				skill_prop = "CS_dy_sdyjl05"
			end
			
			if skill_prop == "CS_dy_sdyjl09_hide" then
				skill_prop = "CS_dy_sdyjl09"
			end
			
			-- Xử lý vấn đề võ kỹ không thể swap bình thư, vũ khí, trang bị đầu, oản, thoái
  			-- Minh Giáo ---
			if skill_prop == "wuji_CS_jh_ldg02" or skill_prop == "wuji_CS_jh_ldg02_hide" then -- Phong Kinh Cung Minh normal - võ kỹ - hide
				skill_prop = "CS_jh_ldg02"
			elseif skill_prop == "wuji_CS_jh_ldg01" then -- Tiễn vũ mạn thiên (phá def)
				skill_prop = "CS_jh_ldg01"
			elseif skill_prop == "wuji_CS_jh_ldg05" then -- Vạn Tiễn Xuyên Tâm
				skill_prop = "CS_jh_ldg05"
				
			-- Thiếu Lâm --- 
			elseif skill_prop == "wuji_CS_sl_djgq04" then -- Hư bộ đoạn trửu (phá def)
				skill_prop = "CS_sl_djgq04"
			elseif skill_prop == "wuji_CS_sl_djgq02" then -- Phiên thiên phách địa
				skill_prop = "CS_sl_djgq02"
			elseif skill_prop == "wuji_CS_sl_djgq03" then -- tiên bộ xung chùy 
				skill_prop = "CS_sl_djgq03"
			
			-- Võ Đang --
			elseif skill_prop == "wuji_CS_wd_qfjf04" then -- Phong thanh tế nguyệt (phá def)
				skill_prop = "CS_wd_qfjf04"
			elseif skill_prop == "wuji_CS_wd_qfjf02" or  skill_prop == "wuji_CS_wd_qfjf02_sky" then -- Trọc kích thanh vị
				skill_prop = "CS_wd_qfjf02"
			elseif skill_prop == "wuji_CS_wd_qfjf06" or skill_prop == "wuji_CS_wd_qfjf06_sky" then -- Kích Trọc Dương Thanh
				skill_prop = "CS_wd_qfjf06"
				
			-- Uyên Ương Song Đao -- Xử lý trạng thái có nộ biến thành bộ khác
			elseif skill_prop == "CS_jh_yydf07_hide" then -- Thiên Kim Nhất Khắc (phá def)
				skill_prop = "CS_jh_yydf07"
			elseif skill_prop == "CS_jh_yydf02_hide" then -- Xung Phong
				skill_prop = "CS_jh_yydf02"
			elseif skill_prop == "CS_jh_yydf01_hide" then -- Thiên Giáo Diễm
				skill_prop = "CS_jh_yydf01"
			elseif skill_prop == "CS_jh_yydf03_hide" then -- Hút
				skill_prop = "CS_jh_yydf03"
			elseif skill_prop == "CS_jh_yydf04_hide" then -- Xoay
				skill_prop = "CS_jh_yydf04"
			
			-- Mị Ảnh Võ Kỹ
			elseif skill_prop == "wuji_CS_jh_myjf03" then -- hình ảnh bất ly (cổ)
				skill_prop = "CS_jh_myjf03"
			elseif skill_prop == "wuji_CS_jh_myjf08" then -- quỷ bộ trảm ảnh (cổ)
				skill_prop = "CS_jh_myjf08"
			
			-- Đã cẩu bổng (cổ)
			elseif skill_prop == "wuji_CS_gb_dgbf07" then -- Bát cẩu triều thiên (cổ)
				skill_prop = "CS_gb_dgbf07"
			elseif skill_prop == "wuji_CS_gb_dgbf08" then -- Thiên hạ vô cẩu (cổ)
				skill_prop = "CS_gb_dgbf08"
			elseif skill_prop == "wuji_CS_gb_dgbf02" then -- Tà đả cẩu bối  (cổ)
				skill_prop = "CS_gb_dgbf02"
			
			-- Huyết Sát Đao Võ Kỹ
			elseif skill_prop == "wuji_CS_jy_xsd03" then -- Đao Quang Huyết Ảnh (Xung Phong)
				skill_prop = "CS_jy_xsd03"
			elseif skill_prop == "wuji_CS_jy_xsd02" then -- Truy Tận Diệt Sát (Xích đu tới)
				skill_prop = "CS_jy_xsd02"
			elseif skill_prop == "CS_jy_xsd08_sky" then -- Hàn Phong Ẩm Huyết (Sky_TrênKhông)
				skill_prop = "CS_jy_xsd08"
			elseif skill_prop == "wuji_CS_jy_xsd07" then -- Cách Sách Vận Luân (khí chiêu 1 hit)
				skill_prop = "CS_jy_xsd07"
			
			-- Đã Cẩu Bổng (Võ Kỹ)
			elseif skill_prop == "wuji_CS_gbzp_dgbf07" then -- Bát cẩu triều thiên (Hất)
				skill_prop = "CS_gbzp_dgbf07"
			elseif skill_prop == "wuji_CS_gbzp_dgbf02" then -- Tà đả cẩu bối (1 hit)
				skill_prop = "CS_gbzp_dgbf02"
			elseif skill_prop == "wuji_CS_gbzp_dgbf08" then -- Thiên hạ Vô Cẩu (nộ)
				skill_prop = "CS_gbzp_dgbf08"
			
			-- Thái Cực Quyền (Fake) --
			elseif skill_prop == "wuji_CS_wdzp_tjq08" then -- Khai Thái Cực (fake)
				skill_prop = "CS_wdzp_tjq08"
			
			-- Diêm Vương Thiếp --
			elseif skill_prop == "wuji_CS_tm_ywt03" then -- Vô Thường Đạo (võ kỹ)
				skill_prop = "CS_tm_ywt03"
			elseif skill_prop == "wuji_CS_tm_ywt04" then -- Sát Thần Dương Đạo (võ kỹ)
				skill_prop = "CS_tm_ywt04"
			elseif skill_prop == "wuji_CS_tm_ywt05" then -- Mạnh Bà Quán Nhật (võ kỹ) 
				skill_prop = "CS_tm_ywt05"
			elseif skill_prop == "wuji_CS_tm_ywt06" then -- Oan Hồn Thiêu Thân (võ kỹ)  
				skill_prop = "CS_tm_ywt06"
			elseif skill_prop == "wuji_CS_tm_ywt07" then -- Diêm Vương Trịch Bút (võ kỹ)
				skill_prop = "CS_tm_ywt07"
			elseif skill_prop == "CS_tm_ywt07_sky" then -- Diêm Vương Trịch Bút (trên không)
				skill_prop = "CS_tm_ywt07"
			elseif skill_prop == "wuji_CS_tm_ywt07_sky" then -- Diêm Vương Trịch Bút (trên không + võ kỹ)
				skill_prop = "CS_tm_ywt07"
			
			-- TCQ cổ --
			elseif skill_prop == "wuji_CS_wd_tjq08" then -- TCQ ( cổ VK)
				skill_prop = "CS_wd_tjq08"
			-- LTT cổ --
			elseif skill_prop == "wuji_CS_sl_lzs07" then -- LTT cổ VK ----Phê Cang
				skill_prop = "CS_sl_lzs07"
			elseif skill_prop == "wuji_CS_sl_lzs06" then -- LTT cổ VK ---Tróc ảnh
				skill_prop = "CS_sl_lzs06"
			end

			local LimitIndex = nx_execute("tips_data", "get_ini_prop", "share\\Skill\\skill_new.ini", skill_prop, "UseLimit", "")
			if LimitIndex == nil then
				return
			end
			
			-- 27: Hỏa đạn/ 25: Phi tiêu/ 26: Phi đao
			if nx_number(LimitIndex) == nx_number(27) or nx_number(LimitIndex) == nx_number(25) or nx_number(LimitIndex) == nx_number(26) then
				LimitIndex = 0
			end
			
			local skill_query = nx_value("SkillQuery")
			if not nx_is_valid(skill_query) then
				return
			end
			
			-- Get item type
			local ItemType = skill_query:GetSkillWeaponType(nx_int(LimitIndex))
			if ItemType == nil then
				return
			end
			
			-- Get weapon properties
			local weapon_st_damage, weapon_cp_damage, weapon_skill_damage = get_cur_weapon(skill_pack_ini, skill_prop)

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
							--if nx_number(view_obj:QueryProp("ItemType")) == nx_number(ItemType) or nx_number(view_obj:QueryProp("ItemType")) == nx_number(145) then
							-- nx_number(0): Fix cho hộ chỉ
							if nx_number(view_obj:QueryProp("ItemType")) == nx_number(ItemType) or ItemType == nx_number(0) then
								-- Đếm dòng skill 10% trên trang bị
								local cnt_opt_skill = 0
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
										if nx_string(tuple[1]) == nx_string(skill_prop) then
											-- Đếm dòng skill 10% trên trang bị
											cnt_opt_skill = cnt_opt_skill + 1
										end
									end
								end
								
								-- Nếu dòng skill >= 2 dòng (20%) thì mới gán item để swap
								if nx_number(weapon_skill_damage) < nx_number(cnt_opt_skill) and cnt_opt_skill >= 2 then
								--if cnt_opt_skill >= 2 then
									item_quip = view_obj
									
									-- Lấy dòng % trên vũ khí (Song đao 20%, ...)
									weapon_skill_damage = cnt_opt_skill
								end
							end
							
							-- Đổi bình thư
							if active ~= nil and nx_number(view_obj:QueryProp("ItemType")) == nx_number(191) then
								local row = view_obj:GetRecordRows("SkillModifyPackRec")
								if row > 0 then
									local prop = view_obj:QueryRecord("SkillModifyPackRec", 0, 0)
									local sec_index = skill_pack_ini:FindSectionIndex(nx_string(prop))
									local value = ""
									if sec_index >= 0 then
										value = skill_pack_ini:ReadString(sec_index, "r", nx_string(""))
									end
									local tuple = util_split_string(value, ",")
									if nx_string(tuple[1]) == nx_string(skill_prop) then
										book_10per = view_obj										
									end
								end
							end
						end
						break
					end
				end

				local form_swap = nx_value(THIS_FORM)
				
				-- Swap bình thư nếu check vào checkbox
				if form_swap.chk_items.Checked == true then
					-- Đổi đồ 30%
					if nx_is_valid(item_quip) then
						-- Tạm thời không dùng swap cũ nữa
						nx_execute("form_stage_main\\form_bag_func", "on_bag_right_click", form_bag.imagegrid_equip, nx_number(item_quip.Ident) - 1)	
					end
				end
				
				-- Swap bình thư nếu check vào checkbox
				if form_swap.chk_bth.Checked == true then
				
					-- Đổi bình thư xích huyết tăng 15% damage khi dưới 50% máu
					local player = yBreaker_get_player()
					if player:QueryProp("HPRatio") < 50 then
						if not nx_function("find_buffer", player, "buf_zs_hs_5_1_01") then
							use_book_by_configID("zs_hs_5_1")
							nx_pause(0.5)
						end
					end

					-- Đổi bình thư 10%
					if nx_is_valid(book_10per) then
						nx_execute("form_stage_main\\form_bag_func", "on_bag_right_click", form_bag.imagegrid_equip, nx_number(book_10per.Ident) - 1)
					end
				end
			end
		end
	end
end


-- Dùng bình thư bởi ID của bình thư và Skill
-- Nếu skill rỗng thì chỉ quan tâm đến ID bình thư
-- Nếu nhiều bình thư trùng nhau thì bình thư đầu tiên sẽ được chọn
function use_book_by_configID(config_ID, skill_ID)
    local goods_grid = nx_value("GoodsGrid")
    local game_client = nx_value("game_client")
    local view = game_client:GetView(nx_string(121))
    local list_book = view:GetViewObjList()
    for j, book in pairs(list_book) do
        if nx_is_valid(book) then
            local grid, index = goods_grid:GetToolBoxGridAndPos(config_ID)
            if not nx_is_valid(grid) then
                return false
            end
            if skill_ID == nil then
                -- Không quan tâm skill thì kết thúc
                goods_grid:ViewUseItem(grid.typeid, grid:GetBindIndex(index), grid, index)
               -- checkItemIsEquipSuccess(config_ID)
                return true
            end
            local skillInt = arraySkillIntergerByID[skill_ID]
            if skillInt == nil then
                return false
            end
            local book_skill = book:QueryRecord("SkillModifyPackRec", 0, 0)
            if nx_int(book_skill) == nx_int(skillInt) then
                goods_grid:ViewUseItem(grid.typeid, grid:GetBindIndex(index), grid, index)
                --checkItemIsEquipSuccess(config_ID)
                return true
            end
        end
    end
end
