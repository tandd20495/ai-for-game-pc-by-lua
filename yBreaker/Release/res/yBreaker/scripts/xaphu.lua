require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")
require("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs")

function click_NPCdriver_fast()

	if not isClickNPCDriver then
		isClickNPCDriver = true
		yBreaker_show_Utf8Text("Bắt đầu chọn xa phu nhanh!")
	 
		while isClickNPCDriver == true do
			nx_pause(0.1)
			local game_client = nx_value("game_client")
			local game_visual = nx_value("game_visual")
			if nx_is_valid(game_client) and nx_is_valid(game_visual) then
				local client_player = game_client:GetPlayer()
				local game_player = game_visual:GetPlayer()
				local game_scence = game_client:GetScene()
				local formtran = nx_value("form_stage_main\\form_world_trans_tool")
				local formtalk = nx_value("form_stage_main\\form_talk_movie")
				if nx_is_valid(game_player) and nx_is_valid(client_player) and nx_is_valid(game_scence) then

					if CheckNPC(GetDoubleHorseData(0)) ~= nil then						
						if nx_is_valid(formtran) then
							nx_execute("custom_sender", "custom_create_world_trans_tool", nx_int(2), nx_string(GetDoubleHorseData(1)))
							
						else
							if formtalk.Visible then
								nx_execute("form_stage_main\\form_talk_movie", "menu_select", 830000000)--Ta muốn đi thành khác
							else
								nx_execute("custom_sender", "custom_select", CheckNPC(GetDoubleHorseData(0)).Ident)
							end
							
						end
					end
				end
			end	
		end
	else
		isClickNPCDriver = false
		yBreaker_show_Utf8Text("Kết thúc chọn xa phu nhanh!")
	end
end

function GetDoubleHorseData(data)
	if map_id() == "school01" then--Cẩm Y
		if data == 0 then return "Transschool01A"
		elseif data == 1 then return 13
		end
	elseif map_id() == "school02" then--Cái Bang
		if data == 0 then return "Transschool02A"
		elseif data == 1 then return 13
		end
	elseif map_id() == "school03" then--Quân Tử
		if data == 0 then return "Transschool03A"
		elseif data == 1 then return 14
		end
	elseif map_id() == "school04" then--Cực Lạc
		if data == 0 then return "Transschool04A"
		elseif data == 1 then return 14
		end
	elseif map_id() == "school05" then--Đường Môn
		if data == 0 then return "Transschool05A"
		elseif data == 1 then return 17
		end
	elseif map_id() == "school06" then--Nga Mi
		if data == 0 then return "Transschool06A"
		elseif data == 1 then return 17
		end
	elseif map_id() == "school07" then--Võ Đang
		if data == 0 then return "Transschool07A"
		elseif data == 1 then return 16
		end
	elseif map_id() == "school08" then--Thiếu Lâm
		if data == 0 then return "Transschool08A"
		elseif data == 1 then return 16
		end
	else return nil
	end
end

function CheckNPC(npc)
	local game_client=nx_value("game_client")
	local game_visual=nx_value("game_visual")
	if nx_is_valid(game_client)and nx_is_valid(game_visual)then 
		local game_player=game_visual:GetPlayer()
		local game_scence=game_client:GetScene()
		local game_scence_objs = game_scence:GetSceneObjList()
		local num_objs = table.getn(game_scence_objs)
		for i = 1, num_objs do
			local object = game_scence_objs[i]
			if nx_is_valid(object) then
				if not game_client:IsPlayer(object.Ident) and object:QueryProp("Type") == 4 and object:QueryProp("ConfigID") == npc then
					local vis_object = game_visual:GetSceneObj(object.Ident)
					if nx_is_valid(vis_object) then
						return object
					end
				end
			end
		end
	end
	return nil
end

--Execute function
click_NPCdriver_fast()