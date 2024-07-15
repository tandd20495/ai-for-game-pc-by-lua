-- Declacre libraries
require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")
require("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs")

-- Implement function
function xabac()
	-- Get X/Z current
	local game_visual = nx_value("game_visual")
	local visual_player = game_visual:GetPlayer()
	local pos_X_save = visual_player.PositionX
	local pos_Y_save = visual_player.PositionY
	local pos_Z_save = visual_player.PositionZ
	local map_query = nx_value("MapQuery")
	--if not nx_is_valid(map_query) then
	--	is_vaild_data = false
	--end

	--if is_vaild_data == true then
	local city = map_query:GetCurrentScene()
	local posX = pos_X_save
	local posY = pos_Y_save
	local posZ = pos_Z_save
	local game_client=nx_value("game_client")
	local player_client=game_client:GetPlayer()
		
	if isRungning == true then
		isRungning = false
		yBreaker_show_Utf8Text("Xả bạc kết thúc!")
	else
		yBreaker_show_Utf8Text("Xả bạc bắt đầu!")
		yBreaker_show_Utf8Text("Lấy tọa độ từ khi bắt đầu để chạy ra")
		isRungning = true
		while isRungning do
		nx_pause(1)
			-- Nếu bị chết thì trị thương lân cận
			local logicstate = player_client:QueryProp("LogicState")
			if logicstate == 120 then
				nx_execute("custom_sender", "custom_relive", 2, 0)
				nx_pause(7)
			-- Chưa tới điểm đứng đó thì di chuyển đến
			elseif not tools_move_isArrived(posX, posY, posZ) then
				tools_move(city, posX, posY, posZ, direct_run)
				direct_run = false
			else
				local fight = nx_value("fight")
				-- Dung bạch vân cái đỉnh
				fight:TraceUseSkill("CS_jh_cqgf02", false, false)
			end
		end
	
--end
	end
end

-- Run function
xabac()