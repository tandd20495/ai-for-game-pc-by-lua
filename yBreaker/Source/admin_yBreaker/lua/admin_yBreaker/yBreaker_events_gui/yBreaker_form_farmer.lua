require("utils")
require("util_gui")
require("util_move")
require("util_functions")
require("share\\chat_define")
require("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs")

local THIS_FORM = "admin_yBreaker\\yBreaker_form_farmer"
local PICK_FORM = "form_stage_main\\form_pick\\form_droppick"
local auto_is_running = false
local direct_run = false
local last_table_ident = {}
local INTVAL_MESSAGE = 0

local list_seeds = {
	"croppernpc20051", -- Lúa mạch
	"croppernpc20052", -- Lúa
	"croppernpc10001", -- Măng Đông
	"croppernpc10018", -- Mè
	"croppernpc10043", -- Trữ Ma
	"croppernpc10044", -- Hỏa Ma
	"croppernpc10040", -- Măng Tây
	"croppernpc10002", -- Hoa Quế
	"croppernpc10045", -- La Bố Ma
	"croppernpc10003", -- Cây Tùng
	"croppernpc10004", -- Hồng Tiêu
	"croppernpc10005", -- Rau Hẹ
	"croppernpc10031", -- Hành Lá
	"croppernpc10022", -- Đậu Nành
	"croppernpc10035", -- Bình Cô
	"croppernpc10038", -- Lô Duẩn
	"croppernpc10006", -- Rau Cúc
	"croppernpc10023", -- Gừng
	"croppernpc10041", -- Cải Xanh
	"croppernpc10007", -- Sơn dược
	"croppernpc10024", -- Cà Chua
	"croppernpc10032", -- Hoa Tiêu
	"croppernpc10025", -- Chanh
	"croppernpc10033", -- Mã Đề
	"croppernpc10039", -- Nhục Quế
	"croppernpc10008", -- Dẻ
	"croppernpc10009", -- Triều Thiên
	"croppernpc10010", -- Rau Thơm
	"croppernpc10011", -- Tỏi
	"croppernpc10019", -- Cải Trắng
	"croppernpc10021", -- Cà
	"croppernpc10028", -- Tỏi Xanh
	"croppernpc10015", -- Hồ Tiêu
	"croppernpc10030", -- Tỏi Tây
	"croppernpc10013", -- Măng Tre
	"croppernpc20001", -- Nghị Tàm
	"croppernpc20002", -- Sa Tàm
	"croppernpc20003", -- Chương Tàm Noãn
	"croppernpc30001", -- Hoa Hồng
	"croppernpc30003" -- Hạt giống Nô En, Cây Thông ...
}
local nongyao_data = {
	{grass = "nongyao10003", worm = "nongyao10002"}, -- Sâu thông thường
	{grass = "nongyao10007", worm = "nongyao10006"} -- Loại hoa
}

function auto_run(form)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	local step = 1
	local city = get_current_map()
	local data = get_seed_data(form.combobox_seed.Text)
	local posp = get_dataposp(city, form.combobox_posp.Text)
	local poss = get_dataposs(city, form.combobox_poss.Text)

	direct_run = true
	last_table_ident = {}

	if data == false or posp == false or poss == false then
		tools_show_notice(nx_function("ext_utf8_to_widestr", "Map không hỗ trợ!"))
		on_btn_control_click(form.btn_control)
		return 0
	end

	while auto_is_running == true do
		local is_vaild_data = true
		local game_client
		local game_visual
		local game_player
		local player_client
		local game_scence

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

		if is_vaild_data == true then
			local logicstate = player_client:QueryProp("LogicState")

			-- Nếu bị chết thì phải bắt đầu lại từ đầu
			if logicstate == 120 then
				step = 1
				last_table_ident = {}
				nx_execute("custom_sender", "custom_relive", 2, 0)
				logmessage(nx_function("ext_utf8_to_widestr", "Nhân vật bị trọng thương, chạy lại từ đầu!"), true, true)
				nx_pause(15)
			end

			-- Trồng cây
			if data.croptype == 0 then
				-- Check dụng cụ trồng cây
				local goods_grid = nx_value('GoodsGrid')
				if goods_grid:GetItemCount("tool_nf_06") == 0 then
					-- Check pass rương và tự mua cuốc
					local game_client=nx_value("game_client")
					local player_client=game_client:GetPlayer()
					if not player_client:FindProp("IsCheckPass") or player_client:QueryProp("IsCheckPass") ~= 1 then
						yBreaker_show_Utf8Text("Mở khóa rương để tự mua cuốc", 3)
						return 
					else 		
						-- Mua Cần câu trong Tạp Hóa ------------- Shop Giang hồ ---- 1: Công Cụ, 16: số thứ tự cuốc, 1: Mua (Tương tự vậy thì 1,1,1: Tab Công Cụ, Mua Liệp Thú Đoản Kiếm)
						nx_execute("custom_sender", "custom_open_mount_shop", 1)
						nx_execute("custom_sender", "custom_buy_item", "Shop_zahuo_00102", 1,16,1)
						nx_execute("custom_sender", "custom_open_mount_shop", 0)
					end 
				end	
				
				-- Đến điểm thứ 1
				if step == 1 then
					if not tools_move_isArrived(posp[1].x, posp[1].y, posp[1].z, 0.5) then
						logmessage(nx_function("ext_utf8_to_widestr", "Đang di chuyển đến điểm thứ") .. nx_widestr(" 1"), false, false)
						tools_move(city, posp[1].x, posp[1].y, posp[1].z, direct_run)
						direct_run = false
					else
						-- Sau khi đến điểm 1 trồng data.numonepoint cây
						for i = 1, data.numonepoint do
							if not auto_is_running then
								return 0
							end
							local form_bag = nx_value("form_stage_main\\form_bag")
							if nx_is_valid(form_bag) then
								form_bag.rbtn_material.Checked = true
							end
							logmessage(nx_function("ext_utf8_to_widestr", "Đang trồng") .. nx_widestr(" ") .. util_text(data.seedid) .. nx_widestr(" ") .. nx_widestr(tostring(i)), true, true)
							nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", data.seedid)
							nx_pause(6.2)
						end

						-- Trồng xong chuyển bước 2
						direct_run = true
						step = 2
					end
				-- Đến điểm thứ 2
				elseif step == 2 then
					if not tools_move_isArrived(posp[2].x, posp[2].y, posp[2].z, 0.5) then
						logmessage(nx_function("ext_utf8_to_widestr", "Đang di chuyển đến điểm thứ") .. nx_widestr(" 2"), false, false)
						tools_move(city, posp[2].x, posp[2].y, posp[2].z, direct_run)
						direct_run = false
					else
						-- Sau khi đến điểm 2 trồng data.numonepoint cây
						for i = 1, data.numonepoint do
							if not auto_is_running then
								return 0
							end
							local form_bag = nx_value("form_stage_main\\form_bag")
							if nx_is_valid(form_bag) then
								form_bag.rbtn_material.Checked = true
							end
							logmessage(nx_function("ext_utf8_to_widestr", "Đang trồng") .. nx_widestr(" ") .. util_text(data.seedid) .. nx_widestr(" ") .. nx_widestr(tostring(i)), true, true)
							nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", data.seedid)
							nx_pause(6.2)
						end
						-- Trồng xong chuyển bước 3
						direct_run = true
						step = 3
					end
				-- Đến điểm thứ 3
				elseif step == 3 then
					if not tools_move_isArrived(posp[3].x, posp[3].y, posp[3].z, 0.5) then
						logmessage(nx_function("ext_utf8_to_widestr", "Đang di chuyển đến điểm thứ") .. nx_widestr(" 3"), false, false)
						tools_move(city, posp[3].x, posp[3].y, posp[3].z, direct_run)
						direct_run = false
					else
						-- Sau khi đến điểm 3 trồng data.numonepoint cây
						for i = 1, data.numonepoint do
							if not auto_is_running then
								return 0
							end
							local form_bag = nx_value("form_stage_main\\form_bag")
							if nx_is_valid(form_bag) then
								form_bag.rbtn_material.Checked = true
							end
							logmessage(nx_function("ext_utf8_to_widestr", "Đang trồng") .. nx_widestr(" ") .. util_text(data.seedid) .. nx_widestr(" ") .. nx_widestr(tostring(i)), true, true)
							nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", data.seedid)
							nx_pause(6.2)
						end
						-- Trồng xong chuyển bước 3
						direct_run = true
						step = 4
					end
				-- Thu hoạch, diệt sâu, diệt cỏ
				elseif step == 4 then
					-- Check nhặt đồ
					tool_getPickForm()

					local numcroper = 0 -- Số cây/tằm trên ruộng

					local game_scence_objs = game_scence:GetSceneObjList()
					local num_objs = table.getn(game_scence_objs)
					local pickID = 0
					local pickIdent = nil
					local idIll = false

					for i = 1, num_objs do
						local objI = i
						if game_scence_objs[objI]:QueryProp("ConfigID") == data.croppernpc and game_scence_objs[objI]:QueryProp("Owner") == player_client:QueryProp("Name") then
							local CropTempState = game_scence_objs[objI]:QueryProp("CropTempState")
							local Resource = game_scence_objs[objI]:QueryProp("Resource")
							local Ident = game_scence_objs[objI].Ident
							local IdentResource = nx_string(Resource) .. nx_string(Ident)

							numcroper = numcroper + 1

							-- Diệt sâu
							if CropTempState == 1 and not in_array(IdentResource, last_table_ident) then
								idIll = true
								table.insert(last_table_ident, IdentResource)
								local okPos = false
								-- Chạy lại chỗ cây (Thử lại 5 lần)
								for i = 1, 5 do
									if not tools_move_isArrived(game_scence_objs[objI].PosiX, game_scence_objs[objI].PosiY, game_scence_objs[objI].PosiZ, 0.5) then
										tools_move(city, game_scence_objs[objI].PosiX, game_scence_objs[objI].PosiY, game_scence_objs[objI].PosiZ, direct_run)
										direct_run = false
									else
										okPos = true
										break
									end
								end
								-- Chọn cây
								if okPos then
									nx_execute("custom_sender", "custom_select", Ident)
									nx_pause(0.1)
									nx_execute("custom_sender", "custom_select", Ident)
									nx_pause(0.1)
									-- Dùng thuốc
									local form_bag = nx_value("form_stage_main\\form_bag")
									if nx_is_valid(form_bag) then
										form_bag.rbtn_material.Checked = true
									end
									nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", nongyao_data[data.nongyao].worm)
									nx_pause(4)
								end
								break
							-- Diệt cỏ
							elseif CropTempState == 256 and not in_array(IdentResource, last_table_ident) then
								idIll = true
								table.insert(last_table_ident, IdentResource)
								local okPos = false
								-- Chạy lại chỗ cây (Thử lại 5 lần)
								for i = 1, 5 do
									if not tools_move_isArrived(game_scence_objs[objI].PosiX, game_scence_objs[objI].PosiY, game_scence_objs[objI].PosiZ, 0.5) then
										tools_move(city, game_scence_objs[objI].PosiX, game_scence_objs[objI].PosiY, game_scence_objs[objI].PosiZ, direct_run)
										direct_run = false
									else
										okPos = true
										break
									end
								end
								-- Chọn cây
								if okPos then
									nx_execute("custom_sender", "custom_select", Ident)
									nx_pause(0.1)
									nx_execute("custom_sender", "custom_select", Ident)
									nx_pause(0.1)
									-- Dùng thuốc
									local form_bag = nx_value("form_stage_main\\form_bag")
									if nx_is_valid(form_bag) then
										form_bag.rbtn_material.Checked = true
									end
									nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", nongyao_data[data.nongyao].grass)
									nx_pause(4)
								end
								break
							-- Đánh dấu cây đầu tiên sẽ hái
							elseif Resource == data.resource then
								if pickID == 0 then
									pickID = objI
									pickIdent = Ident
								end
							end
						end
					end

					-- Thu hoạch nếu như không có trị bệnh
					if not idIll and pickID ~= 0 and pickIdent ~= nil then
						local okPos = false
						-- Chạy lại chỗ cây (Thử lại 5 lần)
						for i = 1, 5 do
							if not tools_move_isArrived(game_scence_objs[pickID].PosiX, game_scence_objs[pickID].PosiY, game_scence_objs[pickID].PosiZ, 0.5) then
								tools_move(city, game_scence_objs[pickID].PosiX, game_scence_objs[pickID].PosiY, game_scence_objs[pickID].PosiZ, direct_run)
								direct_run = false
							else
								okPos = true
								break
							end
						end
						-- Thu hoạch
						if okPos then
							if not nx_is_valid(nx_value(PICK_FORM)) then
								nx_execute("custom_sender", "custom_select", pickIdent)
								nx_pause(0.2)
							end
							if not nx_is_valid(nx_value(PICK_FORM)) then
								nx_execute("custom_sender", "custom_select", pickIdent)
							end
						end
					end

					-- Hết cây và không phải vừa hái xong thì kết thúc
					if numcroper == 0 then
						step = 1
						last_table_ident = {}
					end
				end
			-- Nuôi tằm
			else
				-- Check dụng cụ nuôi tằm
				local goods_grid = nx_value('GoodsGrid')
				if goods_grid:GetItemCount("tool_nf_16") == 0 then
					-- Check pass rương và tự mua dụng cụ
					local game_client=nx_value("game_client")
					local player_client=game_client:GetPlayer()
					if not player_client:FindProp("IsCheckPass") or player_client:QueryProp("IsCheckPass") ~= 1 then
						yBreaker_show_Utf8Text("Mở khóa rương để tự mua dụng cụ", 3)
						return 
					else 		
						-- Mua Cần câu trong Tạp Hóa ------------- Shop Giang hồ ---- 1: Công Cụ, 17: số thứ tự dụng cụ nuôi tằm, 1: Mua (Tương tự vậy thì 1,1,1: Tab Công Cụ, Mua Liệp Thú Đoản Kiếm)
						nx_execute("custom_sender", "custom_open_mount_shop", 1)
						nx_execute("custom_sender", "custom_buy_item", "Shop_zahuo_00102", 1,17,1)
						nx_execute("custom_sender", "custom_open_mount_shop", 0)
					end 
				end	
				
				-- Đến vị trí bắt đầu nuôi tằm
				if step == 1 then
					if not tools_move_isArrived(poss.x, poss.y, poss.z, 0.5) then
						tools_move(city, poss.x, poss.y, poss.z, direct_run)
						direct_run = false
					else
						direct_run = true
						step = 2
					end
				-- Thả tằm ra
				elseif step == 2 then
					local game_scence_objs = game_scence:GetSceneObjList()
					local nearestPNC = nil
					local nearestPNCDistance = 0
					local numCroped = 0

					-- Tìm thấy khung tằm gần nhất
					for i = 1, table.getn(game_scence_objs) do
						local id = game_scence_objs[i]:QueryProp("ConfigID")
						local owner = game_scence_objs[i]:QueryProp("Owner")

						if id == "CanNpc0001" then
							local distance = tonumber(string.format("%.3f", distance2d(game_player.PositionX, game_player.PositionZ, game_scence_objs[i].PosiX, game_scence_objs[i].PosiZ)))
							if nearestPNCDistance == 0 or nearestPNCDistance > distance then
								nearestPNCDistance = distance
								nearestPNC = i
							end
						elseif id == data.croppernpc and owner == player_client:QueryProp("Name") then
							-- Số con tằm đã trồng
							numCroped = numCroped + 1
						end
					end

					-- Chạy lại chỗ khung tằm và gieo tằm
					if nearestPNC ~= nil then
						local okPos = false
						for i = 1, 7 do
							if not tools_move_isArrived(game_scence_objs[nearestPNC].PosiX, game_scence_objs[nearestPNC].PosiY, game_scence_objs[nearestPNC].PosiZ, 0.5) then
								tools_move(city, game_scence_objs[nearestPNC].PosiX, game_scence_objs[nearestPNC].PosiY, game_scence_objs[nearestPNC].PosiZ, direct_run)
								direct_run = false
							else
								okPos = true
								direct_run = true
								break
							end
						end
						if okPos then
							nx_execute("custom_sender", "custom_select", game_scence_objs[nearestPNC].Ident)
							nx_pause(0.2)
							local form_bag = nx_value("form_stage_main\\form_bag")
							if nx_is_valid(form_bag) then
								form_bag.rbtn_material.Checked = true
							end
							nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", data.seedid)
							nx_pause(6.2)
							numCroped = numCroped + 1
						end
					end

					-- Nếu hết khung tằm hoặc số con tằm đã gieo đã đủ thì chuyển sang bước sau
					if nearestPNC == nil or numCroped >= data.numonepoint then
						step = 3
					end
				-- Diệt sâu và thu hoạch (Ưu tiên diệt sâu, nếu đang thu hoạch có sâu thì bỏ đi diệt trước)
				elseif step == 3 then
					-- Check nhặt đồ
					tool_getPickForm()

					local numcroper = 0

					local game_scence_objs = game_scence:GetSceneObjList()
					local pickID = 0
					local pickIdent = nil
					local idIll = false

					for i = 1, table.getn(game_scence_objs) do
						local objI = i
						if game_scence_objs[objI]:QueryProp("ConfigID") == data.croppernpc and game_scence_objs[objI]:QueryProp("Owner") == player_client:QueryProp("Name") then
							local CropTempState = game_scence_objs[objI]:QueryProp("CropTempState")
							local Resource = game_scence_objs[objI]:QueryProp("Resource")
							local Ident = game_scence_objs[objI].Ident
							local IdentResource = nx_string(Resource) .. nx_string(Ident)

							numcroper = numcroper + 1

							-- Diệt sâu
							if CropTempState == 1 and not in_array(IdentResource, last_table_ident) then
								idIll = true
								table.insert(last_table_ident, IdentResource)
								local okPos = false
								-- Chạy lại chỗ tằm (Thử lại 6 lần)
								for i = 1, 6 do
									if not tools_move_isArrived(game_scence_objs[objI].PosiX, game_scence_objs[objI].PosiY, game_scence_objs[objI].PosiZ, 0.5) then
										tools_move(city, game_scence_objs[objI].PosiX, game_scence_objs[objI].PosiY, game_scence_objs[objI].PosiZ, direct_run)
										direct_run = false
									else
										okPos = true
										direct_run = true
										break
									end
								end
								-- Chọn tằm
								if okPos then
									nx_execute("custom_sender", "custom_select", Ident)
									nx_pause(0.1)
									-- Dùng thuốc
									local form_bag = nx_value("form_stage_main\\form_bag")
									if nx_is_valid(form_bag) then
										form_bag.rbtn_material.Checked = true
									end
									nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", "nongyao10005")
									nx_pause(5)
								end
								break
							-- Cho ăn
							elseif CropTempState == 256 and not in_array(IdentResource, last_table_ident) then
								idIll = true
								table.insert(last_table_ident, IdentResource)
								local okPos = false
								-- Chạy lại chỗ tằm (Thử lại 6 lần)
								for i = 1, 6 do
									if not tools_move_isArrived(game_scence_objs[objI].PosiX, game_scence_objs[objI].PosiY, game_scence_objs[objI].PosiZ, 0.5) then
										tools_move(city, game_scence_objs[objI].PosiX, game_scence_objs[objI].PosiY, game_scence_objs[objI].PosiZ, direct_run)
										direct_run = false
									else
										okPos = true
										direct_run = true
										break
									end
								end
								-- Chọn tằm
								if okPos then
									nx_execute("custom_sender", "custom_select", Ident)
									nx_pause(0.1)
									-- Dùng thuốc
									local form_bag = nx_value("form_stage_main\\form_bag")
									if nx_is_valid(form_bag) then
										form_bag.rbtn_material.Checked = true
									end
									nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", "nongyao10004")
									nx_pause(5)
								end
								break
							-- Đánh dấu tằm đầu tiên sẽ thu hoạch
							elseif Resource == data.resource then
								if pickID == 0 then
									pickID = objI
									pickIdent = Ident
								end
							end
						end
					end

					-- Thu hoạch nếu như không có trị bệnh
					if not idIll and pickID ~= 0 and pickIdent ~= nil then
						local okPos = false
						-- Chạy lại chỗ tằm (Thử lại 6 lần)
						for i = 1, 6 do
							if not tools_move_isArrived(game_scence_objs[pickID].PosiX, game_scence_objs[pickID].PosiY, game_scence_objs[pickID].PosiZ, 0.5) then
								tools_move(city, game_scence_objs[pickID].PosiX, game_scence_objs[pickID].PosiY, game_scence_objs[pickID].PosiZ, direct_run)
								direct_run = false
							else
								okPos = true
								break
							end
						end
						-- Thu hoạch
						if okPos then
							if not nx_is_valid(nx_value(PICK_FORM)) then
								nx_execute("custom_sender", "custom_select", pickIdent)
								nx_pause(0.2)
							end
							if not nx_is_valid(nx_value(PICK_FORM)) then
								nx_execute("custom_sender", "custom_select", pickIdent)
							end
						end
					end

					-- Nếu hết tằm và không phải vừa nhặt tằm thì hoàn tất vòng
					if numcroper == 0 then
						step = 1
						last_table_ident = {}
					end
				end
			end
		end
		nx_pause(0.5)
	end
end
function get_seed_data(seedvalue)
	-- Lúa mạch
	if seedvalue == util_text("croppernpc20051") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1113",
			croppernpc = "croppernpc20051",
			resource = "npc\\cj_040051"
		}
	end
	-- Lúa
	if seedvalue == util_text("croppernpc20052") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1114",
			croppernpc = "croppernpc20052",
			resource = "npc\\cj_040051"
		}
	end
	-- Măng Đông
	if seedvalue == util_text("croppernpc10001") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1001",
			croppernpc = "croppernpc10001",
			resource = "npc\\cj_040051"
		}
	end
	-- Mè
	if seedvalue == util_text("croppernpc10018") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1018",
			croppernpc = "croppernpc10018",
			resource = "npc\\cj_040051"
		}
	end
	-- Trữ ma
	if seedvalue == util_text("croppernpc10043") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1043",
			croppernpc = "croppernpc10043",
			resource = "npc\\cj_040201"
		}
	end
	-- Hỏa ma
	if seedvalue == util_text("croppernpc10044") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1044",
			croppernpc = "croppernpc10044",
			resource = "npc\\cj_040201"
		}
	end
	-- Măng Tây
	if seedvalue == util_text("croppernpc10040") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1040",
			croppernpc = "croppernpc10040",
			resource = "npc\\cj_040201"
		}
	end
	-- Hoa Quế
	if seedvalue == util_text("croppernpc10002") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1002",
			croppernpc = "croppernpc10002",
			resource = "npc\\cj_040201"
		}
	end
	-- La bố ma
	if seedvalue == util_text("croppernpc10045") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1045",
			croppernpc = "croppernpc10045",
			resource = "npc\\cj_040201"
		}
	end
	-- Tùng
	if seedvalue == util_text("croppernpc10003") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1003",
			croppernpc = "croppernpc10003",
			resource = "npc\\cj_040201"
		}
	end
	-- La Hồng Tiêu
	if seedvalue == util_text("croppernpc10004") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1004",
			croppernpc = "croppernpc10004",
			resource = "npc\\cj_040201"
		}
	end
	-- Rau Hẹ
	if seedvalue == util_text("croppernpc10005") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1005",
			croppernpc = "croppernpc10005",
			resource = "npc\\cj_040201"
		}
	end
	-- Hành Lá
	if seedvalue == util_text("croppernpc10031") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1031",
			croppernpc = "croppernpc10031",
			resource = "npc\\cj_040201"
		}
	end
	-- Đậu Nành
	if seedvalue == util_text("croppernpc10022") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1022",
			croppernpc = "croppernpc10022",
			resource = "npc\\cj_040201"
		}
	end
	-- Bình Cô
	if seedvalue == util_text("croppernpc10035") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1035",
			croppernpc = "croppernpc10035",
			resource = "npc\\cj_040201"
		}
	end
	-- Lô Duẩn
	if seedvalue == util_text("croppernpc10038") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1038",
			croppernpc = "croppernpc10038",
			resource = "npc\\cj_040201"
		}
	end
	-- Rau Cúc
	if seedvalue == util_text("croppernpc10006") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1006",
			croppernpc = "croppernpc10006",
			resource = "npc\\cj_040201"
		}
	end
	-- Gừng
	if seedvalue == util_text("croppernpc10023") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1023",
			croppernpc = "croppernpc10023",
			resource = "npc\\cj_040201"
		}
	end
	-- Cải Xanh
	if seedvalue == util_text("croppernpc10041") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1041",
			croppernpc = "croppernpc10041",
			resource = "npc\\cj_040201"
		}
	end
	-- Sơn dược
	if seedvalue == util_text("croppernpc10007") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1007",
			croppernpc = "croppernpc10007",
			resource = "npc\\cj_040014"
		}
	end
	-- Cà Chua
	if seedvalue == util_text("croppernpc10024") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1024",
			croppernpc = "croppernpc10024",
			resource = "npc\\cj_040014"
		}
	end
	-- Hoa Tiêu
	if seedvalue == util_text("croppernpc10032") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1032",
			croppernpc = "croppernpc10032",
			resource = "npc\\cj_040014"
		}
	end
	-- Chanh
	if seedvalue == util_text("croppernpc10025") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1025",
			croppernpc = "croppernpc10025",
			resource = "npc\\cj_040014"
		}
	end
	-- Mã Đề
	if seedvalue == util_text("croppernpc10033") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1033",
			croppernpc = "croppernpc10033",
			resource = "npc\\cj_040014"
		}
	end
	-- Nhục Quế
	if seedvalue == util_text("croppernpc10039") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1039",
			croppernpc = "croppernpc10039",
			resource = "npc\\cj_040014"
		}
	end
	-- Dẻ
	if seedvalue == util_text("croppernpc10008") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1008",
			croppernpc = "croppernpc10008",
			resource = "npc\\cj_040014"
		}
	end
	-- Triều Thiên
	if seedvalue == util_text("croppernpc10009") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1009",
			croppernpc = "croppernpc10009",
			resource = "npc\\cj_040014"
		}
	end
	-- Rau Thơm
	if seedvalue == util_text("croppernpc10010") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1010",
			croppernpc = "croppernpc10010",
			resource = "npc\\cj_ty0003a"
		}
	end
	-- Tỏi
	if seedvalue == util_text("croppernpc10011") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1011",
			croppernpc = "croppernpc10011",
			resource = "npc\\cj_041120a"
		}
	end
	-- Cải Trắng
	if seedvalue == util_text("croppernpc10019") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1019",
			croppernpc = "croppernpc10019",
			resource = "npc\\cj_ty0003a"
		}
	end
	-- Cà
	if seedvalue == util_text("croppernpc10021") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1021",
			croppernpc = "croppernpc10021",
			resource = "npc\\cj_ty0003a"
		}
	end
	-- Tỏi Xanh
	if seedvalue == util_text("croppernpc10028") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1028",
			croppernpc = "croppernpc10028",
			resource = "npc\\cj_ty0003a"
		}
	end
	-- Hồ Tiêu
	if seedvalue == util_text("croppernpc10015") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1015",
			croppernpc = "croppernpc10015",
			resource = "npc\\cj_ty0003a"
		}
	end
	-- Tỏi Tây
	if seedvalue == util_text("croppernpc10030") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1030",
			croppernpc = "croppernpc10030",
			resource = "npc\\cj_ty0003a"
		}
	end
	-- Măng Tre
	if seedvalue == util_text("croppernpc10013") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1013",
			croppernpc = "croppernpc10013",
			resource = "npc\\cj_ty0003a"
		}
	end
	-- Nghị Tàm
	if seedvalue == util_text("croppernpc20001") then
		return {
			nongyao = 1,
			croptype = 1,
			numonepoint = 6,
			seedid = "seed63",
			croppernpc = "croppernpc20001",
			resource = "npc\\cj_040204"
		}
	end
	-- Sa Tàm
	if seedvalue == util_text("croppernpc20002") then
		return {
			nongyao = 1,
			croptype = 1,
			numonepoint = 6,
			seedid = "seed64",
			croppernpc = "croppernpc20002",
			resource = "npc\\cj_040204"
		}
	end
	-- Chương Tàm Noãn
	if seedvalue == util_text("croppernpc20003") then
		return {
			nongyao = 1,
			croptype = 1,
			numonepoint = 6,
			seedid = "seed65",
			croppernpc = "croppernpc20003",
			resource = "npc\\cj_040204"
		}
	end
	-- Hoa Hồng
	if seedvalue == util_text("croppernpc30001") then
		return {
			nongyao = 2,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed2001",
			croppernpc = "croppernpc30001",
			resource = "npc\\npcitem929"
		}
	end
	-- Cây thông blabla các kiểu
	if seedvalue == util_text("croppernpc30003") then
		return {
			nongyao = 2,
			croptype = 0,
			numonepoint = 9,
			seedid = "haiwai_Christmastreeseed",
			croppernpc = "croppernpc30003",
			resource = "npc\\npcitem929"
		}
	end
	return false
end
-- Lấy danh sách các điểm trồng cây và nuôi tằm mà MAP hỗ trợ
function get_listpos(map)
	-------------------------------
	--Ngũ Đại thành thị:
	-- Yến Kinh
	if map == "city01" then
		return {1, 1}
	end
	-- Tô Châu
	if map == "city02" then
		return {1, 1}
	end
	-- Kim Lăng
	if map == "city03" then
		return {1, 1}
	end
	-- Lạc Dương
	if map == "city04" then
		return {1, 1}
	end
	-- Thành Đô
	if map == "city05" then
		return {1, 1}
	end
	-------------------------------
	--Tứ Đại Thôn Trấn:
	-- Thiên đăng trấn
	if map == "born04" then
		return {6, 2}
	end
	-------------------------------
	return false
end
-- Lấy tọa độ trồng cây
function get_dataposp(map, posvalue)
	local datapos = false
	----------------------------------------------------------------------------
	--Ngũ Đại Thành Thị:
	-- Yến Kinh
	if map == "city01" then
		datapos = {
			{{x = 877.483, y = -92.144, z = -34.691}, {x = 875.546, y = -93.012, z = -24.561}, {x = 868.546, y = -91.894, z = -30.504}}
		}
	end
	-- Tô Châu
	if map == "city02" then
		datapos = {
			{{x = 778.233, y = 4.546, z = 592.381}, {x = 783.447, y = 5.425, z = 602.096}, {x = 777.537, y = 4.802, z = 611.312}}
		}
	end
	-- Kim Lăng
	if map == "city03" then
		datapos = {
			{{x = 1733.175, y = 2.447, z = 57.913}, {x = 1744.332, y = 4.175, z = 56.781}, {x = 1734.476, y = 3.362, z = 46.475}}
		}
	end
	-- Lạc Dương
	if map == "city04" then
		datapos = {
			{{x = 1227.644, y = -26.883, z = 848.117}, {x = 1228.689, y = -26.883, z = 837.726}, {x = 1239.021, y = -26.884, z = 833.257}}
		}
	end
	-- Thành Đô
	if map == "city05" then
		datapos = {
			{{x = 478.020, y = 21.845, z = 779.901}, {x = 482.616, y = 20.254, z = 773.212}, {x = 486.174, y = 20.511, z = 781.615}}
		}
	end
	----------------------------------------------------------------------------
	--Thôn Trấn:
	-- Thiên đăng trấn
	if map == "born04" then
		datapos = {
			{{x = 619.695, y = -39.684, z = 655.062}, {x = 619.759, y = -39.685, z = 646.301}},
			{{x = 607.614, y = -39.684, z = 676.535}, {x = 606.975, y = -39.684, z = 685.874}},
			{{x = 606.868, y = -39.684, z = 695.763}, {x = 606.310, y = -39.684, z = 705.447}},
			{{x = 587.868, y = -41.695, z = 704.704}, {x = 579.036, y = -41.695, z = 703.944}},
			{{x = 578.648, y = -41.695, z = 694.115}, {x = 588.051, y = -41.695, z = 694.579}},
			{{x = 588.118, y = -41.695, z = 686.328}, {x = 579.831, y = -41.695, z = 686.566}}
		}
	end
	---------------------------------------------------------------------------
	if datapos == false then
		return false
	end
	local id = 0
	for i = 1, 20 do
		if posvalue == (nx_function("ext_utf8_to_widestr", "Vị trí số") .. nx_widestr(" ") .. nx_widestr(tostring(i))) then
			id = i
			break
		end
	end
	if id == 0 or id > table.getn(datapos) then
		return false
	end
	return datapos[id]
end
-- Lấy tọa độ nuôi tằm
function get_dataposs(map, posvalue)
	local datapos = false
	------------------------------------------------
	--Ngũ Đại Thành Thị:
	-- Yến Kinh
	if map == "city01" then
		datapos = {
			{x = 832.346, y = -95.942, z = 1.417}
		}
	end
	-- Tô Châu
	if map == "city02" then
		datapos = {
			{x = 795.560, y = 3.546, z = 778.763}
		}
	end
	-- Kim Lăng
	if map == "city03" then
		datapos = {
			{x = 1266.381, y = 6.642, z = 394.308}
		}
	end
	-- Lạc Dương
	if map == "city04" then
		datapos = {
			{x = 789.303, y = -28.035, z = 1028.656}
		}
	end
	-- Thành Đô
	if map == "city05" then
		datapos = {
			{x = 863.263, y = 22.652, z = 367.273}
		}
	end
	------------------------------------------------
	--Thôn Trấn:
	-- Thiên đăng trấn
	if map == "born04" then
		datapos = {
			{x = 613.563, y = -39.684, z = 672.094},
			{x = 635.587, y = -39.604, z = 676.768}
		}
	end
	------------------------------------------------
	if datapos == false then
		return false
	end
	local id = 0
	for i = 1, 20 do
		if posvalue == (nx_function("ext_utf8_to_widestr", "Vị trí số") .. nx_widestr(" ") .. nx_widestr(tostring(i))) then
			id = i
			break
		end
	end
	if id == 0 or id > table.getn(datapos) then
		return false
	end
	return datapos[id]
end
function build_combobox(form)
	local map = get_current_map()
		local listpos = get_listpos(map)
	form.lbl_2.Text = util_text(map)
	if listpos == false then
		auto_is_running = false
		form.lbl_4.Text = nx_function("ext_utf8_to_widestr", "Không hỗ trợ")
		return false
	end
	form.lbl_4.Text = nx_function("ext_utf8_to_widestr", "Có thể thực hiện")
	local combobox_seed = form.combobox_seed
	combobox_seed.DropListBox:ClearString()
	if combobox_seed.DroppedDown then
		combobox_seed.DroppedDown = false
	end
	for i = 1, table.getn(list_seeds) do
		combobox_seed.DropListBox:AddString(util_text(list_seeds[i]))
	end
	combobox_seed.Text = util_text""
	local combobox_posp = form.combobox_posp
	combobox_posp.DropListBox:ClearString()
	if combobox_posp.DroppedDown then
		combobox_posp.DroppedDown = false
	end
	local combobox_poss = form.combobox_poss
	combobox_poss.DropListBox:ClearString()
	if combobox_poss.DroppedDown then
		combobox_poss.DroppedDown = false
	end

	if listpos ~= false then
		combobox_posp.Text = nx_function("ext_utf8_to_widestr", "Vị trí số") .. nx_widestr(" 1")
		combobox_poss.Text = nx_function("ext_utf8_to_widestr", "Vị trí số") .. nx_widestr(" 1")

		for i = 1, listpos[1] do
			combobox_posp.DropListBox:AddString(nx_function("ext_utf8_to_widestr", "Vị trí số") .. nx_widestr(" ") .. nx_widestr(tostring(i)))
		end
		for i = 1, listpos[2] do
			combobox_poss.DropListBox:AddString(nx_function("ext_utf8_to_widestr", "Vị trí số") .. nx_widestr(" ") .. nx_widestr(tostring(i)))
		end
	else
		combobox_posp.Text = "--"
		combobox_poss.Text = "--"
	end
end
function on_form_main_init(form)
	form.Fixed = false
	form.is_minimize = false
end
function on_main_form_open(form)
	change_form_size()
	form.is_minimize = false
	auto_is_running = false
	build_combobox(form)
	form.btn_control.Text=nx_function("ext_utf8_to_widestr","Bắt Đầu")
	form.btn_control.ForeColor = "255,0,255,0"
end
function on_main_form_close(form)
	auto_is_running = false
	nx_destroy(form)
end
function on_btn_close_click(btn)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
function on_btn_control_click(btn)
	local form = btn.ParentForm
	if not nx_is_valid(form) then
		return
	end
	if auto_is_running then
		auto_is_running = false
		form.btn_control.Text=nx_function("ext_utf8_to_widestr","Bắt Đầu")
		form.btn_control.ForeColor = "255,0,255,0"
	else
		auto_is_running = true
		form.btn_control.Text=nx_function("ext_utf8_to_widestr","Kết Thúc")
		form.btn_control.ForeColor = "255,255,0,0"
		auto_run()
	end
end
function change_form_size()
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	local gui = nx_value("gui")
	form.Left = 140
	--form.Top = (gui.Height - form.Height) / 2
	form.Top = 100
end
function on_combobox_seed_selected(combobox)
end
function on_combobox_posp_selected(combobox)
end
function on_combobox_poss_selected(combobox)
end
function get_current_map()
	return nx_value("form_stage_main\\form_map\\form_map_scene").current_map
end
function logmessage(text, resetCounter, resetAfterCall)
	if resetCounter ~= nil then
		INTVAL_MESSAGE = 0
	end
	INTVAL_MESSAGE = INTVAL_MESSAGE + 1
	if INTVAL_MESSAGE == 1 then
		tools_show_notice(text)
	end
	if INTVAL_MESSAGE >= 6 then
		INTVAL_MESSAGE = 0
	end
	if resetAfterCall ~= nil then
		INTVAL_MESSAGE = 0
	end
end

function show_hide_form_farmer()
	util_auto_show_hide_form(THIS_FORM)
end