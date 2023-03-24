local game_visual = nx_value("game_visual")
game_visual.HidePlayer = true
nx_function("ext_hide_player_F9")
local world = nx_value("world")
local scene = world.MainScene
local game_control = scene.game_control
game_control.MaxDisplayFPS = 30

local bMovie = util_is_form_visible("form_stage_main\\form_movie_new")
while bMovie do
	nx_pause(1.5)
	bMovie = util_is_form_visible("form_stage_main\\form_movie_new")
end
		local game_client
		local game_scence
		local game_scence_objs
		game_client = nx_value("game_client")
		game_scence = game_client:GetScene()
		game_scence_objs = game_scence:GetSceneObjList()

		for i = 1, table.getn(game_scence_objs) do
			if game_scence_objs[i]:FindProp("NpcType") and game_scence_objs[i]:QueryProp("ConfigID") == "funnpcborn003031" then
			local pos = {game_scence_objs[i].DestX, game_scence_objs[i].DestY, game_scence_objs[i].DestZ}
			jump_to(pos)
			nx_pause(2)
			local is_talking = false
				while is_talking == false do
					nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
					nx_pause(0.4)
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					is_talking = form_talk.Visible
				end
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 500001340)
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 501001340)
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 502001340)
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 503001340)
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 504001340)
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 505001340)
			nx_pause(1.5)
			break
			end
		end
		nx_pause(2)
		local game_client
		local game_scence
		local game_scence_objs
		game_client = nx_value("game_client")
		game_scence = game_client:GetScene()
		game_scence_objs = game_scence:GetSceneObjList()

		for i = 1, table.getn(game_scence_objs) do
			if game_scence_objs[i]:FindProp("NpcType") and game_scence_objs[i]:QueryProp("ConfigID") == "funnpcborn003035" then
			local is_talking = false
				while is_talking == false do
					nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
					nx_pause(0.4)
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					is_talking = form_talk.Visible
				end
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 500001347)
			nx_pause(1.5)
			break
			end
		end
		
		util_show_form("form_stage_main\\form_bag", true)
		nx_pause(0.5)
		local form = util_get_form("form_stage_main\\form_bag", true)
		nx_pause(0.5)
		form.rbtn_tool.Checked = true
		nx_pause(0.5)
		nx_execute("form_stage_main\\form_bag", "on_rbtn_checked_changed", form.rbtn_tool)
		nx_pause(2)
		nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", "tbook_CS_jh_cqgf03")
		nx_pause(1.5)
		local form = util_get_form("form_stage_main\\form_wuxue\\form_skillbook_preview", "on_btn_study_click", true)
		nx_execute("form_stage_main\\form_wuxue\\form_skillbook_preview", "on_btn_study_click", form.btn_study)
		nx_pause(5)
		
		local game_client
		local game_scence
		local game_scence_objs
		game_client = nx_value("game_client")
		game_scence = game_client:GetScene()
		game_scence_objs = game_scence:GetSceneObjList()

		for i = 1, table.getn(game_scence_objs) do
			if game_scence_objs[i]:FindProp("NpcType") and game_scence_objs[i]:QueryProp("ConfigID") == "funnpcborn003035" then
			local is_talking = false
				while is_talking == false do
					nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
					nx_pause(0.4)
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					is_talking = form_talk.Visible
				end
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 500001347)
			nx_pause(1.5)
			break
			end
		end
		
		util_show_form("form_stage_main\\form_bag", true)
		nx_pause(0.5)
		local form = util_get_form("form_stage_main\\form_bag", true)
		nx_pause(0.5)
		form.rbtn_tool.Checked = true
		nx_pause(0.5)
		nx_execute("form_stage_main\\form_bag", "on_rbtn_checked_changed", form.rbtn_tool)
		nx_pause(2)
		nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", "tbook_CS_jh_cqgf02")
		nx_pause(1.5)
		local form = util_get_form("form_stage_main\\form_wuxue\\form_skillbook_preview", "on_btn_study_click", true)
		nx_execute("form_stage_main\\form_wuxue\\form_skillbook_preview", "on_btn_study_click", form.btn_study)
		nx_pause(5)
		
		local game_client
		local game_scence
		local game_scence_objs
		game_client = nx_value("game_client")
		game_scence = game_client:GetScene()
		game_scence_objs = game_scence:GetSceneObjList()

		for i = 1, table.getn(game_scence_objs) do
			if game_scence_objs[i]:FindProp("NpcType") and game_scence_objs[i]:QueryProp("ConfigID") == "funnpcborn003035" then
			local is_talking = false
				while is_talking == false do
					nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
					nx_pause(0.4)
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					is_talking = form_talk.Visible
				end
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 500001347)
			nx_pause(1.5)
			break
			end
		end
		
		util_show_form("form_stage_main\\form_bag", true)
		nx_pause(0.5)
		local form = util_get_form("form_stage_main\\form_bag", true)
		nx_pause(0.5)
		form.rbtn_tool.Checked = true
		nx_pause(0.5)
		nx_execute("form_stage_main\\form_bag", "on_rbtn_checked_changed", form.rbtn_tool)
		nx_pause(2)
		nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", "tbook_CS_jh_cqgf05")
		nx_pause(1.5)
		local form = util_get_form("form_stage_main\\form_wuxue\\form_skillbook_preview", "on_btn_study_click", true)
		nx_execute("form_stage_main\\form_wuxue\\form_skillbook_preview", "on_btn_study_click", form.btn_study)
		nx_pause(5)
		
		local game_client
		local game_scence
		local game_scence_objs
		game_client = nx_value("game_client")
		game_scence = game_client:GetScene()
		game_scence_objs = game_scence:GetSceneObjList()

		for i = 1, table.getn(game_scence_objs) do
			if game_scence_objs[i]:FindProp("NpcType") and game_scence_objs[i]:QueryProp("ConfigID") == "funnpcborn003035" then
			local is_talking = false
				while is_talking == false do
					nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
					nx_pause(0.4)
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					is_talking = form_talk.Visible
				end
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 500001347)
			nx_pause(1.5)
			break
			end
		end
		
		local game_client
		local game_scence
		local game_scence_objs
		game_client = nx_value("game_client")
		game_scence = game_client:GetScene()
		game_scence_objs = game_scence:GetSceneObjList()

		for i = 1, table.getn(game_scence_objs) do
			if game_scence_objs[i]:FindProp("NpcType") and game_scence_objs[i]:QueryProp("ConfigID") == "funnpcborn003035" then
			local is_talking = false
				while is_talking == false do
					nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
					nx_pause(0.4)
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					is_talking = form_talk.Visible
				end
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 200001347)
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 201001347)
			nx_pause(1.5)
			break
			end
		end
		
local bMovie = util_is_form_visible("form_stage_main\\form_movie_new")
while bMovie do
	nx_pause(1.5)
	bMovie = util_is_form_visible("form_stage_main\\form_movie_new")
end

local pos = {172.116,6.238,-123.835}
jump_to(pos)
nx_pause(4)
local count = 0
	while count < 2 do
		local game_client
		local game_scence
		local game_scence_objs
		game_client = nx_value("game_client")
		game_scence = game_client:GetScene()
		game_scence_objs = game_scence:GetSceneObjList()
		local player_client = game_client:GetPlayer()
		local fight = nx_value("fight")
		for i = 1, table.getn(game_scence_objs) do
			nx_pause(0.5)
			if not nx_is_valid (game_scence_objs[i]) then
				break
			end
			if fight:CanAttackNpc(player_client, game_client:GetSceneObj(nx_string(game_scence_objs[i].Ident))) then
				nx_execute("custom_sender", "custom_select", nx_string(game_scence_objs[i].Ident))
				nx_pause(0.4)
				while game_scence_objs[i]:QueryProp("Dead") ~= 1 do
					nx_pause(1.5)
					fight:TraceUseSkill("cs_jh_cqgf04", false, false)
					if not nx_is_valid (game_scence_objs[i]) or game_scence_objs[i]:QueryProp("Dead") == 1 then
						count = count + 1
					break
			end
				end
				
			end
		end
	end
nx_pause(5)
local pos = {127.794,11.962,-87.473}
jump_to(pos)
nx_pause(7)


		local game_client
		local game_scence
		local game_scence_objs
		game_client = nx_value("game_client")
		game_scence = game_client:GetScene()
		game_scence_objs = game_scence:GetSceneObjList()

		for i = 1, table.getn(game_scence_objs) do
			if game_scence_objs[i]:FindProp("NpcType") and game_scence_objs[i]:QueryProp("ConfigID") == "funnpcborn003032" then
			local is_talking = false
				while is_talking == false do
					nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
					nx_pause(0.4)
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					is_talking = form_talk.Visible
				end
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 500001342)
			nx_pause(1.5)
			break
			end
		end
		
		util_show_form("form_stage_main\\form_bag", true)
		nx_pause(0.5)
		local form = util_get_form("form_stage_main\\form_bag", true)
		nx_pause(0.5)
		form.rbtn_tool.Checked = true
		nx_pause(0.5)
		nx_execute("form_stage_main\\form_bag", "on_rbtn_checked_changed", form.rbtn_tool)
		nx_pause(0.5)
		nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", "book_zs_default_01")
		nx_pause(2)
		local form = util_get_form("form_stage_main\\form_wuxue\\form_skillbook_preview", "on_btn_study_click", true)
		nx_execute("form_stage_main\\form_wuxue\\form_skillbook_preview", "on_btn_study_click", form.btn_study)
		nx_pause(5)
		
		local fight = nx_value("fight")
		fight:TraceUseSkill("zs_default_01", false, false)
		nx_pause(2)
		fight:TraceUseSkill("zs_default_01", false, false)
		nx_pause(2)
		
		
		local game_client
		local game_scence
		local game_scence_objs
		game_client = nx_value("game_client")
		game_scence = game_client:GetScene()
		game_scence_objs = game_scence:GetSceneObjList()

		for i = 1, table.getn(game_scence_objs) do
			if game_scence_objs[i]:FindProp("NpcType") and game_scence_objs[i]:QueryProp("ConfigID") == "funnpcborn003032" then
			local is_talking = false
				while is_talking == false do
					nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
					nx_pause(0.4)
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					is_talking = form_talk.Visible
				end
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 500001342)
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 501001342)
			nx_pause(1.5)
			break
			end
		end
		
		local game_client
		local game_scence
		local game_scence_objs
		game_client = nx_value("game_client")
		game_scence = game_client:GetScene()
		game_scence_objs = game_scence:GetSceneObjList()

		for i = 1, table.getn(game_scence_objs) do
			if game_scence_objs[i]:FindProp("NpcType") and game_scence_objs[i]:QueryProp("ConfigID") == "funnpcborn003032" then
			local is_talking = false
				while is_talking == false do
					nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
					nx_pause(0.4)
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					is_talking = form_talk.Visible
				end
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 500001342)
			nx_pause(1.5)
			break
			end
		end
		
		util_show_form("form_stage_main\\form_bag", true)
		nx_pause(0.5)
		local form = util_get_form("form_stage_main\\form_bag", true)
		nx_pause(0.5)
		form.rbtn_tool.Checked = true
		nx_pause(0.5)
		nx_execute("form_stage_main\\form_bag", "on_rbtn_checked_changed", form.rbtn_tool)
		nx_pause(0.5)
		nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", "book_hw_normal")
		nx_pause(5)
		local form = util_get_form("form_stage_main\\form_wuxue\\form_skillbook_preview", "on_btn_study_click", true)
		nx_execute("form_stage_main\\form_wuxue\\form_skillbook_preview", "on_btn_study_click", form.btn_study)
		nx_pause(5)
		
		
		local game_client
		local game_scence
		local game_scence_objs
		game_client = nx_value("game_client")
		game_scence = game_client:GetScene()
		game_scence_objs = game_scence:GetSceneObjList()

		for i = 1, table.getn(game_scence_objs) do
			if game_scence_objs[i]:FindProp("NpcType") and game_scence_objs[i]:QueryProp("ConfigID") == "funnpcborn003032" then
			local is_talking = false
				while is_talking == false do
					nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
					nx_pause(0.4)
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					is_talking = form_talk.Visible
				end
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 500001342)
			nx_pause(15)
			break
			end
		end
		
		util_show_form("form_stage_main\\form_bag", true)
		nx_pause(0.5)
		local form = util_get_form("form_stage_main\\form_bag", true)
		nx_pause(0.5)
		form.rbtn_equip.Checked = true
		nx_pause(0.5)
		nx_execute("form_stage_main\\form_bag", "on_rbtn_checked_changed", form.rbtn_equip)
		nx_pause(0.5)
		nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", "hw_fb_rw_01003")
		
		local game_client
		local game_scence
		local game_scence_objs
		game_client = nx_value("game_client")
		game_scence = game_client:GetScene()
		game_scence_objs = game_scence:GetSceneObjList()

		for i = 1, table.getn(game_scence_objs) do
			if game_scence_objs[i]:FindProp("NpcType") and game_scence_objs[i]:QueryProp("ConfigID") == "funnpcborn003032" then
			local is_talking = false
				while is_talking == false do
					nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
					nx_pause(0.4)
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					is_talking = form_talk.Visible
				end
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 200001342)
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 201001342)
			nx_pause(1.5)
			break
			end
		end
		
		pos = {109.712,11.963,-108.392}
		jump_to(pos)
		nx_pause(7)
		
		
		local count = 0
		local waittime = 0
		while count < 3 do
			local game_client
			local game_scence
			local game_scence_objs
			game_client = nx_value("game_client")
			game_scence = game_client:GetScene()
			game_scence_objs = game_scence:GetSceneObjList()
			local player_client = game_client:GetPlayer()
			local fight = nx_value("fight")
			for i = 1, table.getn(game_scence_objs) do
				nx_pause(1.5)
				if not nx_is_valid(game_scence_objs[i]) then
					break
				end
				if fight:CanAttackNpc(player_client, game_client:GetSceneObj(nx_string(game_scence_objs[i].Ident))) then
					nx_execute("custom_sender", "custom_select", nx_string(game_scence_objs[i].Ident))
					nx_pause(0.4)
					while game_scence_objs[i]:QueryProp("Dead") ~= 1 do
						nx_pause(0.5)
						fight:TraceUseSkill("hw_normal_fb", false, false)
						if not nx_is_valid (game_scence_objs[i]) or game_scence_objs[i]:QueryProp("Dead") == 1 then
							count = count + 1
							break
						end
					end
				else
					waittime = waittime + 1
					if waittime == 30 then
						count = 3
					end
				end
			end
		end
		nx_pause(1)
		pos = {119.007,11.963,-113.217}
		jump_to(pos)
		nx_pause(4)
		
		local game_client
		local game_scence
		local game_scence_objs
		game_client = nx_value("game_client")
		game_scence = game_client:GetScene()
		game_scence_objs = game_scence:GetSceneObjList()

		for i = 1, table.getn(game_scence_objs) do
			if game_scence_objs[i]:FindProp("NpcType") and game_scence_objs[i]:QueryProp("ConfigID") == "funnpcborn003042" then
				local is_talking
				nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
				nx_pause(0.7)
				nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
				nx_pause(0.5)
				local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
				is_talking = form_talk.Visible
				if is_talking then
					nx_pause(0.4)
					nx_execute("form_stage_main\\form_talk_movie", "menu_select", 500001343)
					nx_pause(1.5)
					break
				end
			end
		end
		
		local pos = {103.186,12.522,-122.158}
		jump_to(pos)
		nx_pause(4)
		
		util_show_form("form_stage_main\\form_bag", true)
		nx_pause(0.5)
		local form = util_get_form("form_stage_main\\form_bag", true)
		nx_pause(0.5)
		form.rbtn_task.Checked = true
		nx_pause(0.5)
		nx_execute("form_stage_main\\form_bag", "on_rbtn_checked_changed", form.rbtn_task)
		nx_pause(0.5)
		nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", "useitem_museborn_2")
		nx_pause(5)
		
		local pos = {84.497,13.037,-97.333}
		jump_to(pos)
		nx_pause(5)
		
		
		
		local game_client = nx_value("game_client")
		local player_client = game_client:GetPlayer()
		local logicstate = player_client:QueryProp("LogicState")
		while logicstate == 1 do
			logicstate = player_client:QueryProp("LogicState")
			local game_client
			local game_scence
			local game_scence_objs
			game_client = nx_value("game_client")
			game_scence = game_client:GetScene()
			game_scence_objs = game_scence:GetSceneObjList()
			local player_client = game_client:GetPlayer()
			local fight = nx_value("fight")
			for i = 1, table.getn(game_scence_objs) do
				nx_pause(0.5)
				if not nx_is_valid(game_scence_objs[i]) then
					break
				end
				if (fight:CanAttackNpc(player_client, game_client:GetSceneObj(nx_string(game_scence_objs[i].Ident))) and game_scence_objs[i]:QueryProp("ConfigID") == "bossborn003002" )then
					nx_execute("custom_sender", "custom_select", nx_string(game_scence_objs[i].Ident))
					nx_pause(0.5)
					fight:TraceUseSkill("cs_jh_cqgf04", false, false)
					break
				end
			end
		end
		nx_pause(5)
		local pos = {29.007,21.756,-109.402}
		jump_to(pos)
		nx_pause(4)
   
		local game_client
		local game_scence
		local game_scence_objs
		game_client = nx_value("game_client")
		game_scence = game_client:GetScene()
		game_scence_objs = game_scence:GetSceneObjList()

		for i = 1, table.getn(game_scence_objs) do
			if game_scence_objs[i]:FindProp("NpcType") and game_scence_objs[i]:QueryProp("ConfigID") == "funnpcborn003033" then
			local is_talking = false
				while is_talking == false do
					nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
					nx_pause(0.4)
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					is_talking = form_talk.Visible
				end
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 500001344)
			nx_pause(1.5)
			break
			end
		end
		
		util_show_form("form_stage_main\\form_bag", true)
		nx_pause(0.5)
		local form = util_get_form("form_stage_main\\form_bag", true)
		nx_pause(0.5)
		form.rbtn_tool.Checked = true
		nx_pause(0.5)
		nx_execute("form_stage_main\\form_bag", "on_rbtn_checked_changed", form.rbtn_tool)
		nx_pause(2)
		nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", "book_qinggon_4")
		nx_pause(5)
		
		local game_client
		local game_scence
		local game_scence_objs
		game_client = nx_value("game_client")
		game_scence = game_client:GetScene()
		game_scence_objs = game_scence:GetSceneObjList()

		for i = 1, table.getn(game_scence_objs) do
			if game_scence_objs[i]:FindProp("NpcType") and game_scence_objs[i]:QueryProp("ConfigID") == "funnpcborn003033" then
			local is_talking = false
				while is_talking == false do
					nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
					nx_pause(0.4)
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					is_talking = form_talk.Visible
				end
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 500001344)
			nx_pause(1.5)
			break
			end
		end
		
		pos = {18.569,29.540,-112.105}
		jump_to(pos)
		nx_pause(4)
		
		local game_client
		local game_scence
		local game_scence_objs
		game_client = nx_value("game_client")
		game_scence = game_client:GetScene()
		game_scence_objs = game_scence:GetSceneObjList()

		for i = 1, table.getn(game_scence_objs) do
			if game_scence_objs[i]:FindProp("NpcType") and game_scence_objs[i]:QueryProp("ConfigID") == "GatherBorn003001" then
				nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
				nx_pause(0.8)
				nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
				nx_pause(7)
				break
			end
		end
		
		pos = {29.007,21.756,-109.402}
		jump_to(pos)
		nx_pause(10)
		
		local game_client
		local game_scence
		local game_scence_objs
		game_client = nx_value("game_client")
		game_scence = game_client:GetScene()
		game_scence_objs = game_scence:GetSceneObjList()

		for i = 1, table.getn(game_scence_objs) do
			if game_scence_objs[i]:FindProp("NpcType") and game_scence_objs[i]:QueryProp("ConfigID") == "funnpcborn003033" then
			local is_talking = false
				while is_talking == false do
					nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
					nx_pause(0.4)
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					is_talking = form_talk.Visible
				end
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 500001344)
			nx_pause(1.5)
			break
			end
		end
		
		util_show_form("form_stage_main\\form_bag", true)
		nx_pause(0.5)
		local form = util_get_form("form_stage_main\\form_bag", true)
		nx_pause(0.5)
		form.rbtn_tool.Checked = true
		nx_pause(0.5)
		nx_execute("form_stage_main\\form_bag", "on_rbtn_checked_changed", form.rbtn_tool)
		nx_pause(0.5)
		nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", "ng_tbook_jh_001")
		nx_pause(2)
		local form = util_get_form("form_stage_main\\form_wuxue\\form_skillbook_preview", "on_btn_study_click", true)
		nx_execute("form_stage_main\\form_wuxue\\form_skillbook_preview", "on_btn_study_click", form.btn_study)
		nx_pause(5)
		
		local game_client
		local game_scence
		local game_scence_objs
		game_client = nx_value("game_client")
		game_scence = game_client:GetScene()
		game_scence_objs = game_scence:GetSceneObjList()

		for i = 1, table.getn(game_scence_objs) do
			if game_scence_objs[i]:FindProp("NpcType") and game_scence_objs[i]:QueryProp("ConfigID") == "funnpcborn003033" then
			local is_talking = false
				while is_talking == false do
					nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
					nx_pause(0.4)
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					is_talking = form_talk.Visible
				end
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 500001344)
			nx_pause(1.5)
			break
			end
		end
		
		local game_client
		local game_scence
		local game_scence_objs
		game_client = nx_value("game_client")
		game_scence = game_client:GetScene()
		game_scence_objs = game_scence:GetSceneObjList()

		for i = 1, table.getn(game_scence_objs) do
			if game_scence_objs[i]:FindProp("NpcType") and game_scence_objs[i]:QueryProp("ConfigID") == "funnpcborn003033" then
			local is_talking = false
				while is_talking == false do
					nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
					nx_pause(0.4)
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					is_talking = form_talk.Visible
				end
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 200001344)
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 201001344)
			nx_pause(1.5)
			break
			end
		end
		
		nx_pause(1.5)
		local game_client
		local game_scence
		local game_scence_objs
		game_client = nx_value("game_client")
		game_scence = game_client:GetScene()
		game_scence_objs = game_scence:GetSceneObjList()

		for i = 1, table.getn(game_scence_objs) do
			if game_scence_objs[i]:FindProp("NpcType") and game_scence_objs[i]:QueryProp("ConfigID") == "funnpcborn003040" then
			local is_talking = false
				while is_talking == false do
					nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
					nx_pause(0.4)
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					is_talking = form_talk.Visible
				end
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 500001348)
			nx_pause(1.5)
			break
			end
		end
		nx_pause(1.5)
		nx_execute("custom_sender", "custom_jingmai_msg", 1, "jm_zuyangming")
		nx_pause(3)
		
		local game_client
		local game_scence
		local game_scence_objs
		game_client = nx_value("game_client")
		game_scence = game_client:GetScene()
		game_scence_objs = game_scence:GetSceneObjList()
		for i = 1, table.getn(game_scence_objs) do
			if game_scence_objs[i]:FindProp("NpcType") and game_scence_objs[i]:QueryProp("ConfigID") == "funnpcborn003044" then
			local is_talking = false
				while is_talking == false do
					nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
					nx_pause(0.4)
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					is_talking = form_talk.Visible
				end
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 500001349)
			nx_pause(1.5)
			break
			end
		end
		
		local game_client
		local game_scence
		local game_scence_objs
		game_client = nx_value("game_client")
		game_scence = game_client:GetScene()
		game_scence_objs = game_scence:GetSceneObjList()

		for i = 1, table.getn(game_scence_objs) do
			if game_scence_objs[i]:FindProp("NpcType") and game_scence_objs[i]:QueryProp("ConfigID") == "funnpcborn003044" then
			local is_talking = false
				while is_talking == false do
					nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
					nx_pause(0.4)
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					is_talking = form_talk.Visible
				end
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 500001349)
			nx_pause(1.5)
			break
			end
		end
		
		local game_client
		local game_scence
		local game_scence_objs
		game_client = nx_value("game_client")
		game_scence = game_client:GetScene()
		game_scence_objs = game_scence:GetSceneObjList()

		for i = 1, table.getn(game_scence_objs) do
			if game_scence_objs[i]:FindProp("NpcType") and game_scence_objs[i]:QueryProp("ConfigID") == "funnpcborn003044" then
			local is_talking = false
				while is_talking == false do
					nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
					nx_pause(0.4)
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					is_talking = form_talk.Visible
				end
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 500001349)
			nx_pause(1.5)
			break
			end
		end
		
		pos = {35.357,21.638,-107.905}
		jump_to(pos)
		nx_pause(4)
		
		local game_client
		local game_scence
		local game_scence_objs
		game_client = nx_value("game_client")
		game_scence = game_client:GetScene()
		game_scence_objs = game_scence:GetSceneObjList()

		for i = 1, table.getn(game_scence_objs) do
			if game_scence_objs[i]:FindProp("NpcType") and game_scence_objs[i]:QueryProp("ConfigID") == "funnpcborn003043" then
				nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
				nx_pause(0.4)
				nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
			end
		end
		
		local game_client = nx_value("game_client")
		local game_visual = nx_value("game_visual")
		local fight = nx_value("fight")
		local player_client = game_client:GetPlayer()
		local select_target_ident = player_client:QueryProp("LastObject")
        local select_target = game_client:GetSceneObj(nx_string(select_target_ident))
        local select_target_visual = game_visual:GetSceneObj(nx_string(select_target_ident))
		local obj_type = nx_number(select_target:QueryProp("Type"))
		while fight:CanAttackNpc(player_client, select_target) do
			fight:TraceUseSkill("cs_jh_cqgf04", false, false)
			nx_pause(1.5)
		end
		
		pos = {29.007,21.756,-109.402}
		jump_to(pos)
		nx_pause(4)
		
		local game_client
		local game_scence
		local game_scence_objs
		game_client = nx_value("game_client")
		game_scence = game_client:GetScene()
		game_scence_objs = game_scence:GetSceneObjList()
		for i = 1, table.getn(game_scence_objs) do
			if game_scence_objs[i]:FindProp("NpcType") and game_scence_objs[i]:QueryProp("ConfigID") == "funnpcborn003044" then
			local is_talking = false
				while is_talking == false do
					nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
					nx_pause(0.4)
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					is_talking = form_talk.Visible
				end
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 500001597)
			nx_pause(1.5)
			break
			end
		end
		nx_pause(2)
		local game_client
		local game_scence
		local game_scence_objs
		game_client = nx_value("game_client")
		game_scence = game_client:GetScene()
		game_scence_objs = game_scence:GetSceneObjList()
		for i = 1, table.getn(game_scence_objs) do
			if game_scence_objs[i]:FindProp("NpcType") and game_scence_objs[i]:QueryProp("ConfigID") == "funnpcborn003044" then
			local is_talking = false
				while is_talking == false do
					nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
					nx_pause(0.4)
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					is_talking = form_talk.Visible
				end
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 200001597)
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 201001597)
			
			nx_pause(1.5)
			
			break
			end
		end

		
		pos = {26.419,22.000,-108.941}
		jump_to(pos)
		nx_pause(4)
		
		local game_client
		local game_scence
		local game_scence_objs
		game_client = nx_value("game_client")
		game_scence = game_client:GetScene()
		game_scence_objs = game_scence:GetSceneObjList()
		for i = 1, table.getn(game_scence_objs) do
			if game_scence_objs[i]:FindProp("NpcType") and game_scence_objs[i]:QueryProp("ConfigID") == "funnpcborn003037" then
			local is_talking = false
				while is_talking == false do
					nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
					nx_pause(0.4)
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					is_talking = form_talk.Visible
				end
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 500001346)
			
			
			local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
		
		if nx_is_valid(form_talk) then
			
				local menu_id = form_talk.mltbox_menu:GetItemKeyByIndex(0)
				nx_execute("form_stage_main\\form_talk_movie", "menu_select", menu_id)
				nx_pause(1)

		end
		nx_pause(1.5)
			break
			end
		end
		nx_pause(2)
		
		
		pos = {-13.464,23.297,-124.951}
		jump_to(pos)
		nx_pause(4)
		
		pos = {-57.064,29.724,-118.797}
		jump_to(pos)
		nx_pause(8)
		
		local bMovie = util_is_form_visible("form_stage_main\\form_movie_new")
		while bMovie do
			nx_pause(1.5)
			local form = util_get_form("form_stage_main\\form_movie_new", false, false)
			if nx_is_valid(form) then
				nx_execute("form_stage_main\\form_movie_new", "on_btn_end_click", form.btn_end)
				nx_pause(0.5)
				form = util_get_form("form_common\\form_confirm", true)
				nx_pause(0.5)
				nx_execute("form_common\\form_confirm", "ok_btn_click", form.ok_btn)
			end
			bMovie = util_is_form_visible("form_stage_main\\form_movie_new")
		end
		
		pos = {-71.009,29.724,-121.166,-1.746}
		jump_to(pos)
		nx_pause(10)
		local game_client = nx_value("game_client")
		local player_client = game_client:GetPlayer()
		local logicstate = player_client:QueryProp("LogicState")
		while logicstate == 1 do
			logicstate = player_client:QueryProp("LogicState")
			local game_client
			local game_scence
			local game_scence_objs
			game_client = nx_value("game_client")
			game_scence = game_client:GetScene()
			game_scence_objs = game_scence:GetSceneObjList()
			local player_client = game_client:GetPlayer()
			local fight = nx_value("fight")
			for i = 1, table.getn(game_scence_objs) do
				if not nx_is_valid(game_scence_objs[i]) then
					break
				end
				if (fight:CanAttackNpc(player_client, game_client:GetSceneObj(nx_string(game_scence_objs[i].Ident))) and game_scence_objs[i]:QueryProp("ConfigID") == "bossborn003003" )then
					nx_execute("custom_sender", "custom_select", nx_string(game_scence_objs[i].Ident))
					nx_pause(0.5)
					fight:TraceUseSkill("skill_musejuben_2", false, false)
					break
				end
			end
			local fight = nx_value("fight")
			fight:TraceUseSkill("skill_musejuben_9", false, false)
			fight:TraceUseSkill("skill_musejuben_7", false, false)
			nx_pause(1.5)
		end
		nx_pause(2)
		pos = {-78.412,29.724,-118.584}
		jump_to(pos)
		nx_pause(4)
		
		local game_client
		local game_scence
		local game_scence_objs
		game_client = nx_value("game_client")
		game_scence = game_client:GetScene()
		game_scence_objs = game_scence:GetSceneObjList()
		for i = 1, table.getn(game_scence_objs) do
			if game_scence_objs[i]:FindProp("NpcType") and game_scence_objs[i]:QueryProp("ConfigID") == "funnpcborn003034" then
			local is_talking = false
				while is_talking == false do
					nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
					nx_pause(0.4)
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					is_talking = form_talk.Visible
				end
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 500001346)
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 501001346)
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 502001346)
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 503001346)
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 504001346)
			nx_pause(0.4)
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", 201001346)
			nx_pause(1.5)
			break
			end
		end
		
		local bMovie = util_is_form_visible("form_stage_main\\form_movie_new")
		while bMovie do
			nx_pause(1.5)
			local form = util_get_form("form_stage_main\\form_movie_new", false, false)
			if nx_is_valid(form) then
				nx_execute("form_stage_main\\form_movie_new", "on_btn_end_click", form.btn_end)
			end
			bMovie = util_is_form_visible("form_stage_main\\form_movie_new")
		end
		return 1