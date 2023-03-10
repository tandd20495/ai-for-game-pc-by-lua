require("utils")
require("util_gui")
require("util_move")
require("util_functions")
require("share\\chat_define")
require("auto_tools\\tool_libs")
require("auto\\lib2")
require("auto\\lib")
local THIS_FORM = "auto_tools\\tools_crop"
local PICK_FORM = "form_stage_main\\form_pick\\form_droppick"
local auto_is_running = false
local direct_run = false
local last_table_ident = {}
local INTVAL_MESSAGE = 0

local list_seeds = {

"croppernpc10001", --Măng đông
"croppernpc10002", --Cây quế
"croppernpc10003", --Cây Tùng
"croppernpc10004", --Hồng Tiêu
"croppernpc10005", --Rau Hẹ
"croppernpc10006", --Rau cúc
"croppernpc10007", --Sơn Dược
"croppernpc10008", --Hạt Dẻ
"croppernpc10009", --Triều Thiên Tiêu
"croppernpc10010", --Rau thơm
"croppernpc10011", --Tỏi
"croppernpc10012", --Nấm hương
"croppernpc10013", --Măng tre
"croppernpc10014", --Giao Bạch
"croppernpc10015", --Hồ Tiêu
"croppernpc10016", --Hành Hẹ
"croppernpc10017", --Đông Cô
"croppernpc10018", --Mè
"croppernpc10019", --Cải trắng
"croppernpc10021", --Cà Tím
"croppernpc10022", --Đậu Nành
"croppernpc10023", --Gừng tươi
"croppernpc10024", --Cà Chua
"croppernpc10025", --Cây chanh
"croppernpc10026", --Cây táo
"croppernpc10027", --Đinh Hương
"croppernpc10028", --Tỏi xanh
"croppernpc10029", --Hướng Nhật Quỳ
"croppernpc10030", --Tỏi Tây
"croppernpc10031", --Hành lá
"croppernpc10032", --Tần Bì
"croppernpc10033", --Mã Đề
"croppernpc10034", --Cây hạnh
"croppernpc10035", --Bình cô
"croppernpc10036", --Đậu tằm
"croppernpc10037", --Cải cúc
"croppernpc10038", --Măng Lau
"croppernpc10039", --Nhục Quế
"croppernpc10040", --Măng tây
"croppernpc10041", --Cải xanh
"croppernpc10042", --Bách Hợp
"croppernpc10043", --Trữ Ma
"croppernpc10044", --Hỏa Ma
"croppernpc10045", --La Bố Ma
--"croppernpc10046", --Hồng Ma
--"croppernpc10047", --Kiếm Ma
--"croppernpc10048", --Cẩn Ma
--"croppernpc10049", --Hoàng Ma
--"croppernpc10050", --Thanh Ma
--"croppernpc10051", --Đồng Ma
--"croppernpc10052", --Á Ma
--"croppernpc10053", --Thô Nhung Miên Hoa
--"croppernpc10054", --Bạch Miên Hoa
--"croppernpc10055", --Hồng Miên Hoa
--"croppernpc10056", --Thảo Miên Hoa
--"croppernpc10057", --Mộc Miên Hoa
--"croppernpc10058", --Trường Nhung Miên Hoa
--"croppernpc10059", --Tế Nhung Miên
--"croppernpc10060", --Nhung Miên Hoa
--"croppernpc10061", --Vân Miên Hoa
--"croppernpc10062", --Thái Miên Hoa
"croppernpc20001", --Nghị Tàm
"croppernpc20002", --Sa Tàm
"croppernpc20003", --Chương Tàm Noãn
"croppernpc20051", --Lúa Mạch
"croppernpc20052", --Lúa
	"croppernpc30003", -- Hạt giống Nô En, Cây Thông ...
	"croppernpc30001" -- hoa hồng
}
local nongyao_data = {
	{grass = "nongyao10003", worm = "nongyao10002"}, -- Sâu thông thường
	{grass = "nongyao10007", worm = "nongyao10006"} -- Loại hoa
}

function auto_run(form)
	local step = 1
	local city = get_current_map()
	local data = get_seed_data(form.combobox_seed.Text) -- loại cây, tằm
	--local posp = get_dataposp(city, form.combobox_posp.Text) -- tọa độ trồng cây -- sửa 2 thằng này là dc
	--local poss = get_dataposs(city, form.combobox_poss.Text) -- tọa độ nuôi tằm
	local x1,y1,z1= toado()
	AutoSendNotice("đã thiết lập vị trí đầu tiên, mời bạn di chuyển tới vị trí thứ 2")
	nx_pause(5)
	local x2,y2,z2= toado()
	AutoSendNotice("đã thiết lập xong vị trí, bắt đầu auto")
	nx_pause(1)
	direct_run = true
	last_table_ident = {}

--	if data == false or posp == false or poss == false then
	if data == false then
		tools_show_notice("tool_crop_wrong_map")
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
				logmessage(util_text("tool_message_is_die"), true, true)
				nx_pause(15)
			end

			-- Trồng cây
			if data.croptype == 0 then
				-- Đến điểm thứ 1
				if step == 1 then
				--	if not tools_move_isArrived(posp[1].x, posp[1].y, posp[1].z, 0.5) then
				if not tools_move_isArrived(x1, y1, z1, 0.5) then
						logmessage(util_text("tool_message_move_to_pos") .. nx_widestr(" 1"), false, false)
						--tools_move(city, posp[1].x, posp[1].y, posp[1].z, direct_run)
						tools_move(city, x1, y1, z1, direct_run)
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
							logmessage(util_text("tool_message_drills") .. nx_widestr(" ") .. util_text(data.seedid) .. nx_widestr(" ") .. nx_widestr(tostring(i)), true, true)
							nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", data.seedid)
							nx_pause(6.2)
						end

						-- Trồng xong chuyển bước 2
						direct_run = true
						step = 2
					end
				-- Đến điểm thứ 2
				elseif step == 2 then
					--if not tools_move_isArrived(posp[2].x, posp[2].y, posp[2].z, 0.5) then
					if not tools_move_isArrived(x2, y2, z2, 0.5) then
						logmessage(util_text("tool_message_move_to_pos") .. nx_widestr(" 2"), false, false)
						--tools_move(city, posp[2].x, posp[2].y, posp[2].z, direct_run)
						tools_move(city, x2, y2, z2, direct_run)
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
							logmessage(util_text("tool_message_drills") .. nx_widestr(" ") .. util_text(data.seedid) .. nx_widestr(" ") .. nx_widestr(tostring(i)), true, true)
							nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", data.seedid)
							nx_pause(6.2)
						end

						-- Trồng xong chuyển bước 3
						direct_run = true
						step = 3
					end
				-- Thu hoạch, diệt sâu, diệt cỏ
				elseif step == 3 then
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
								else
								pickup_all_item()
							end
							if not nx_is_valid(nx_value(PICK_FORM)) then
								nx_execute("custom_sender", "custom_select", pickIdent)
								else
								pickup_all_item()
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
				-- Đến vị trí bắt đầu nuôi tằm
				if step == 1 then
					--if not tools_move_isArrived(poss.x, poss.y, poss.z, 0.5) then
					--	tools_move(city, poss.x, poss.y, poss.z, direct_run)
					if not tools_move_isArrived(x1, y1, z1, 0.5) then
						tools_move(x1, y1, z1, direct_run)
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
								else
								pickup_all_item()
							end
							if not nx_is_valid(nx_value(PICK_FORM)) then
								nx_execute("custom_sender", "custom_select", pickIdent)
								else
								pickup_all_item()
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
	-- Măng Đông
	if seedvalue == util_text("croppernpc10001") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1001",
			croppernpc = "croppernpc10001",
			resource = "npc\\cj_040012"
		}
	end
	 --Cây quế
	if seedvalue == util_text("croppernpc10002") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1002",
			croppernpc = "croppernpc10002",
			resource = "npc\\cj_040030"
		}
	end
	-- Cây Tùng
	if seedvalue == util_text("croppernpc10003") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1003",
			croppernpc = "croppernpc10003",
			resource = "npc\\cj_040033"
		}
	end
	-- Hồng Tiêu
	if seedvalue == util_text("croppernpc10004") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1004",
			croppernpc = "croppernpc10004",
			resource = "npc\\cj_041160b"
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
			resource = "npc\\cj_040018"
		}
	end
	-- Rau cúc
	if seedvalue == util_text("croppernpc10006") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1006",
			croppernpc = "croppernpc10006",
			resource = "npc\\cj_040004"
		}
	end
	-- Sơn Dược
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
	-- Hạt Dẻ
	if seedvalue == util_text("croppernpc10008") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1008",
			croppernpc = "croppernpc10008",
			resource = "npc\\cj_040045"
		}
	end
	-- Ớt Chỉ Thiên
	if seedvalue == util_text("croppernpc10009") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1009",
			croppernpc = "croppernpc10009",
			resource = "npc\\cj_041160b"
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
	-- Nấm hương
	if seedvalue == util_text("croppernpc10012") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1012",
			croppernpc = "croppernpc10012",
			resource = "npc\\cj_ty0004b"
		}
	end
	-- Măng tre
	if seedvalue == util_text("croppernpc10013") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1013",
			croppernpc = "croppernpc10013",
			resource = "npc\\cj_040002"
		}
	end
	
	if seedvalue == util_text("croppernpc10014") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1014",
			croppernpc = "croppernpc10014",
			resource = "npc\\cj_040018"
		}
	end
	
	if seedvalue == util_text("croppernpc10015") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1015",
			croppernpc = "croppernpc10015",
			resource = "npc\\cj_ty0001b"
		}
	end
	
	if seedvalue == util_text("croppernpc10016") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1016",
			croppernpc = "croppernpc10016",
			resource = "npc\\cj_041120a"
		}
	end
	
	if seedvalue == util_text("croppernpc10017") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1017",
			croppernpc = "croppernpc10017",
			resource = "npc\\cj_040051"
		}
	end
	
	if seedvalue == util_text("croppernpc10018") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1018",
			croppernpc = "croppernpc10018",
			resource = "npc\\cj_040028"
		}
	end
	
	if seedvalue == util_text("croppernpc10019") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1019",
			croppernpc = "croppernpc10019",
			resource = "npc\\cj_041210b"
		}
	end
	
	
	if seedvalue == util_text("croppernpc10021") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1021",
			croppernpc = "croppernpc10021",
			resource = "npc\\cj_ts0001b"
		}
	end
	
	if seedvalue == util_text("croppernpc10022") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1022",
			croppernpc = "croppernpc10022",
			resource = "npc\\cj_040008"
		}
	end
	
	if seedvalue == util_text("croppernpc10023") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1023",
			croppernpc = "croppernpc10023",
			resource = "npc\\cj_040010"
		}
	end
	
	if seedvalue == util_text("croppernpc10024") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1024",
			croppernpc = "croppernpc10024",
			resource = "npc\\cj_ts0002b"
		}
	end
		
	if seedvalue == util_text("croppernpc10025") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1025",
			croppernpc = "croppernpc10025",
			resource = "npc\\cj_040035"
		}
	end
		
	if seedvalue == util_text("croppernpc10026") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1026",
			croppernpc = "croppernpc10026",
			resource = "npc\\cj_040020"
		}
	end
		
	if seedvalue == util_text("croppernpc10027") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1027",
			croppernpc = "croppernpc10027",
			resource = "npc\\cj_040036"
		}
	end
		
	if seedvalue == util_text("croppernpc10028") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1028",
			croppernpc = "croppernpc10028",
			resource = "npc\\cj_041120a"
		}
	end
		
	if seedvalue == util_text("croppernpc10029") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1029",
			croppernpc = "croppernpc10029",
			resource = "npc\\cj_040038"
		}
	end
		
	if seedvalue == util_text("croppernpc10030") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1030",
			croppernpc = "croppernpc10030",
			resource = "npc\\cj_041120a"
		}
	end
		
	if seedvalue == util_text("croppernpc10031") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1031",
			croppernpc = "croppernpc10031",
			resource = "npc\\cj_041120a"
		}
	end
		
	if seedvalue == util_text("croppernpc10032") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1032",
			croppernpc = "croppernpc10032",
			resource = "npc\\cj_ty0001b"
		}
	end
		
	if seedvalue == util_text("croppernpc10033") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1033",
			croppernpc = "croppernpc10033",
			resource = "npc\\cj_040018"
		}
	end
		
	if seedvalue == util_text("croppernpc10034") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1034",
			croppernpc = "croppernpc10034",
			resource = "npc\\cj_040039"
		}
	end
		-- --Bình cô
	if seedvalue == util_text("croppernpc10035") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1035",
			croppernpc = "croppernpc10035",
			resource = "npc\\cj_ty0004b"
		}
	end
		-- -Đậu tằm
	if seedvalue == util_text("croppernpc10036") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1036",
			croppernpc = "croppernpc10036",
			resource = "npc\\cj_040008"
		}
	end
		-- --Cải cúc
	if seedvalue == util_text("croppernpc10037") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1037",
			croppernpc = "croppernpc10037",
			resource = "npc\\cj_ty0003b"
		}
	end

--Măng Lau
	if seedvalue == util_text("croppernpc10038") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1038",
			croppernpc = "croppernpc10038",
			resource = "npc\\cj_040022"
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
			resource = "npc\\cj_040016"
		}
	end
		-- --Măng tây
	if seedvalue == util_text("croppernpc10040") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1040",
			croppernpc = "croppernpc10040",
			resource = "npc\\cj_040002"
		}
	end
		-- --Cải xanh
	if seedvalue == util_text("croppernpc10041") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1041",
			croppernpc = "croppernpc10041",
			resource = "npc\\cj_041210a"
		}
	end
		-- "croppernpc10042", --Bách Hợp
	if seedvalue == util_text("croppernpc10042") then
		return {
			nongyao = 1,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed1042",
			croppernpc = "croppernpc10042",
			resource = "npc\\cj_040048"
		}
	end
--Trữ Ma
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
		-- hoa hồng
	if seedvalue == util_text("croppernpc30001") then
		return {
			nongyao = 2,
			croptype = 0,
			numonepoint = 9,
			seedid = "seed2001",
			croppernpc = "croppernpc30001",
			resource = "npc\\itemnpc818"
		}
	end
	return false
end
-- Lấy danh sách các điểm trồng cây và nuôi tằm mà MAP hỗ trợ
function get_listpos(map)
	-- Tô châu
	if map == "city02" then
		return {4, 2}
	end
	-- Thiên đăng trấn
	if map == "born04" then
		return {6, 2}
	end
	-- Thành Đô
	if map == "city05" then
		return {4, 6}
	end
	return false
end
-- Lấy tọa độ trồng cây
function get_dataposp(map, posvalue)
	local datapos = false
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
	-- Thành Đô
	if map == "city05" then
		datapos = {
			{{x = 520.905, y = 16.042, z = 787.033}, {x = 515.046, y = 17.126, z = 791.580}},
			{{x = 504.228, y = 19.061, z = 808.783}, {x = 503.559, y = 18.768, z = 798.017}},
			{{x = 482.335, y = 21.433, z = 783.444}, {x = 488.898, y = 19.653, z = 777.606}},
			{{x = 499.843, y = 17.221, z = 765.552}, {x = 500.710, y = 16.403, z = 756.404}}
		}
	end
	--Tô châu
		if map == "city02" then
		datapos = {
			{{x = 776.401, y = -0.196, z = 681.938}, {x = 786.084, y = -0.194, z = 687.332}},
			{{x = 780.977, y = 0.010, z = 664.990}, {x = 775.657, y = 0.010, z = 653.638}},
			{{x = 779.873, y = 5.104, z = 628.477}, {x = 780.409, y = 5.382, z = 617.321}},
			{{x = 780.418, y = 5.218, z = 603.592}, {x = 781.789, y = 5.097, z = 595.701}}
		}
	end
	if datapos == false then
		return false
	end
	local id = 0
	for i = 1, 20 do
		if posvalue == (util_text("tool_select_pospre3") .. nx_widestr(" ") .. nx_widestr(tostring(i))) then
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
	-- Tô châu
		if map == "city02" then
		datapos = {
			{x = 1059.5, y = 2.873, z = 963.783},
			{x = 1064.579, y = 2.873, z = 945.776}
		}
	end
	-- Thiên đăng trấn
	if map == "born04" then
		datapos = {
			{x = 613.563, y = -39.684, z = 672.094},
			{x = 635.587, y = -39.604, z = 676.768}
		}
	end
	-- Thành Đô 
	if map == "city05" then
		datapos = {
			{x = 860.297, y = 22.653, z = 367.466},
			{x = 833.634, y = 25.901, z = 287.720},
			{x = 1183.361, y = 58.966, z = 988.750},
			{x = 1204.572, y = 58.966, z = 992.377},
			{x = 862.823, y = 54.845, z = 1007.150},
			{x = 844.417, y = 54.813, z = 1017.602}
		}
	end
	if datapos == false then
		return false
	end
	local id = 0
	for i = 1, 20 do
		if posvalue == (util_text("tool_select_pospre3") .. nx_widestr(" ") .. nx_widestr(tostring(i))) then
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
	local combobox_seed = form.combobox_seed
	combobox_seed.DropListBox:ClearString()
	if combobox_seed.DroppedDown then
		combobox_seed.DroppedDown = false
	end
	for i = 1, table.getn(list_seeds) do
		combobox_seed.DropListBox:AddString(util_text(list_seeds[i]))
	end
	combobox_seed.Text = util_text(list_seeds[1])
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
	form.btn_control.Text = util_text("tool_start")
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
		btn.Text = util_text("tool_start")
	else
		auto_is_running = true
		btn.Text = util_text("tool_stop")
		auto_run(form)
	end
end
function change_form_size()
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	local gui = nx_value("gui")
	form.Left = (gui.Width - form.Width) / 2
	--form.Top = (gui.Height - form.Height) / 2
	form.Top = 100
end
function on_combobox_seed_selected(combobox)
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
function tools_show_form()
util_auto_show_hide_form("auto_tools\\tools_crop")
end
----------
