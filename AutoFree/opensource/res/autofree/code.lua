require("util_gui")
require("util_move")
require("util_functions")
require("form_stage_main\\form_tiguan\\form_tiguan_util")
require("auto\\lib2")
require("auto\\lib")
require("auto_tools\\tool_libs")
require("util_static_data")
require("share\\client_custom_define")
require("goods_grid")
require("share\\view_define")
require("tips_func_skill")
require("define\\shortcut_key_define")
require("custom_sender")
require("auto\\tiguan")
require("auto_tools\\inspect")
require("player_state\\state_input")
require("player_state\\logic_const")
require("player_state\\state_const")
local game_client = nx_value("game_client")
local game_visual = nx_value("game_visual")
local client_player = game_client:GetPlayer()
local visual_player = game_visual:GetPlayer()
local game_scence = game_client:GetScene()
local scene = game_client:GetScene()
local scene_obj_table = scene:GetSceneObjList()
--local id = "bosstg04005"

function  boss_info()
	-- xác định tọa độ, id, map con boss thth
		local finish_cdts = nx_value("tiguan_finish_cdts")
		if not nx_is_valid(finish_cdts) or finish_cdts:GetChildCount() < 1 then
		  return 0
		end
		local cdt_tab = finish_cdts:GetChildList()
		local gui = nx_value("gui")
		if not nx_is_valid(gui) then
		  return 0
		end
		local boss_place = nx_widestr("")
		for i = 1, table.getn(cdt_tab) do
		  local child = cdt_tab[i]
		  if nx_number(child.ismust) == 1 then
			boss_place = gui.TextManager:GetText("ui_tiguan_place_" .. nx_string(child.cdt_id))
		  end
		end
		local gui = nx_value("gui")
		if not nx_is_valid(gui) then
		  return 0
		end
		local front = nx_function("ext_ws_find", boss_place, nx_widestr("href=\""))
		local back = nx_function("ext_ws_find", boss_place, nx_widestr("\" style="))
		boss_place = nx_function("ext_ws_substr", boss_place, front + 6, back - 9)
		boss_place = nx_function("ext_split_string", nx_string(boss_place), ",")
		local x, y, z = find_npc_pos(boss_place[2], boss_place[3])

		bossX = x
		bossY = y
		bossZ = z
		bossName = boss_place[3]
		bossScene = boss_place[2]
return x,y,z,bossName,bossScene		
end
