local SUB_CLIENT_NORMAL_BEGIN = 11
local SUB_CLIENT_NORMAL_EXIT = 12
local SUB_CLIENT_UPDATE_ACT = 24
local SUB_SERVER_ACT_BEGIN = 21
local SUB_CLIENT_ACT_EXIT = 22
local SUB_CLIENT_ACT_PAY = 23
local is_faculty = check_wuxue_is_faculty("ng_jz_001")
local dich_can_dan = "faculty_event_02_2"
local dich_can_dan_mua = "faculty_event_02_new_2"
local tu_linh_dan = "zhenqi_activity_001_2"
local tu_linh_dan_mua = "zhenqi_activity_001_new_2"
local tinh_che_tuyet_lien_dan = "additem_0020_4"
local tinh_che_tuyet_lien_dan_mua = "additem_0020_new_4"
local hop_ky_tran = "box_power_redeem"
local hop_ky_tran_mua = "box_power_redeem_new"
local dich_can_dan_1 = "faculty_event_02_1"
local dich_can_dan_b = "faculty_event_02_b"
local tu_ha_dan = "additem_0022"
local mo_khi_dan = "additem_0024"
  -- nx_execute("faculty", "set_faculty_wuxue", "ng_jz_001")
  -- nx_execute("custom_sender", "custom_send_faculty_msg", SUB_CLIENT_NORMAL_BEGIN)
-- nx_execute("custom_sender", "custom_send_faculty_msg", SUB_SERVER_ACT_BEGIN)
-- nx_execute("custom_sender", "custom_send_faculty_msg", SUB_CLIENT_ACT_PAY, nx_int(0), nx_int(1))
--util_show_form("form_stage_main\\form_wuxue\\form_team_faculty_setting", true) -- show form chon kiu luyen nhom
-- --nx_execute("custom_sender", "custom_send_faculty_msg", SUB_CLIENT_ACT_EXIT)
-- local game_player = getPlayer()
-- local day_value = game_player:QueryProp("ActDayValue")
-- local cost_value = game_player:QueryProp("ActCostSuiYin")
-- local cul_dv = ( day_value - cost_value )
-- local type_index = nx_int(1) -- thuoc 0 1 2
-- local cost_type = nx_int(1) -- 1 bac khoa, 4: bac nen
-- local cost0 = get_dien_vo_item_cost(0)
-- local cost1 = get_dien_vo_item_cost(1)
-- SendNotice(nx_string(cul_dv > cost0 or cul_dv > cost1))
-- SendNotice(nx_string(cul_dv < cost1))
--clear_all_data()
-- local game_config = nx_value("game_config")
-- local account = game_config.login_account
-- local server = game_config.server_name
-- SendNotice(server)
-- local form = util_get_form(FORM_NEW_ORIGIN_MAIN, true, false)
-- nx_execute("form_stage_main\\form_origin_new\\form_new_origin_main", "open_form")
-- nx_execute("form_stage_main\\form_origin_new\\form_new_origin_main", "on_btn_person_click", form)
-- local person_form = util_get_form(FORM_NEW_ORIGIN_PERSON, true, false)
-- local diem_text = person_form.lbl_GetValue.Text
-- local diem = util_split_string(nx_string(diem_text), "/")
-- local diem_tuan = person_form.lbl_WeekRemainValue.Text

-- --return nx_int(diem_tuan) == nx_int(0) and nx_int(diem[1]) == nx_int(diem[2])
-- SendNotice(nx_string( nx_int(diem_tuan) == nx_int(0) and nx_int(diem[1]) == nx_int(diem[2])))
--SendNotice(diem[1])
--lbl_WeekRemainValue.Text
--delete_item_by_id("qizhen_0101_01", 2, 1) -- delete tuyet lien tu
--local form = util_get_form("form_stage_main\\form_shop\\form_shop", true, false)
-- local GoodsGrid = nx_value("GoodsGrid")
--   if not nx_is_valid(GoodsGrid) then
--     return
--   end
--   local gui = nx_value("gui")
--   if not nx_is_valid(gui) then
--     return
--   end
--   local game_client = nx_value("game_client")
--   if not nx_is_valid(game_client) then
--     return
--   end
  -- local view = game_client:GetView(nx_string(view_ident))
  -- if not nx_is_valid(view) then
  --   return
  -- end
  -- if optype == "createview" then
  --   GoodsGrid:ViewRefreshGrid(grid)
  -- elseif optype == "deleteview" then
  --   GoodsGrid:ViewRefreshGrid(grid)
  -- elseif optype == "additem" then
  --   GoodsGrid:ViewUpdateItem(grid, index)
  -- elseif optype == "delitem" then
  --   GoodsGrid:ViewDeleteItem(grid, index)
  -- elseif optype == "updateitem" then
  --   GoodsGrid:ViewUpdateItem(grid, index)
  -- end
  

  -- local form_name = util_get_form("form_stage_main\\form_mail\\form_mail_send", true, false)

  -- local GoodsGrid = nx_value("GoodsGrid")
  -- if nx_is_valid(GoodsGrid) then
  --   SendNotice("refresh")
  --   GoodsGrid:ViewRefreshGrid(form_name.postbox)
  -- end

  -- local form = util_get_form("form_stage_main\\form_mail\\form_mail_send", true, false)
  -- local bag = util_get_form("form_stage_main\\form_bag", true, false)
  -- nx_execute("form_stage_main\\form_bag_func", "on_bag_select_changed", bag.imagegrid_task, 3)
  -- nx_execute("form_stage_main\\form_mail\\form_mail_send", "on_postbox_select_changed", form.postbox)
  -- local viewId = 125
  -- local id = "Item_5nei_duihuan"
  -- local game_client = nx_value("game_client")
	-- local view = game_client:GetView(nx_string(viewId))
	-- local viewobj_list = view:GetViewObjList()
	-- for index, view_item in pairs(viewobj_list) do
  --   if view_item:QueryProp("ConfigID") == id and view_item:QueryProp("Amount")==24 then
  --     SendNotice("d")
	-- 		local goods_grid = nx_value("GoodsGrid")
  --     if nx_is_valid(goods_grid) then
  --       SendNotice("eeee")
  --       goods_grid:ViewGridPutToAnotherView(view, 35)
  --     end
  --     -- local form = util_get_form("form_stage_main\\form_mail\\form_mail_send", true, false)
  --     -- local bag = util_get_form("form_stage_main\\form_bag", true, false)
  --     -- nx_execute("form_stage_main\\form_bag_func", "on_bag_select_changed", bag.imagegrid_task, 3)
  --     -- nx_execute("form_stage_main\\form_mail\\form_mail_send", "on_postbox_select_changed", form.postbox)
	-- 	end
  -- end
 
-- SendNotice(VIEWPORT_POST_BOX)
--   local form = util_get_form("form_stage_main\\form_mail\\form_mail_send", true, false)
--   local bag = util_get_form("form_stage_main\\form_bag", true, false)

-- local goodsgrid = nx_value("GoodsGrid")
-- goodsgrid:ViewRefreshGrid(form.postbox)
-- goodsgrid:ViewUpdateItem(form.postbox, 0)

--   local goodsgrid = nx_value("GoodsGrid")
--   if not nx_is_valid(goodsgrid) then
--     return
--   end
--   goodsgrid:ViewGridOnSelectItem(bag.imagegrid_task, 49)

--   nx_execute("form_stage_main\\form_bag_func", "on_bag_select_changed", bag.imagegrid_tool, 3)

--   goodsgrid:ViewGridOnSelectItem(form.postbox, -1)

  
--nx_execute("form_stage_main\\form_mail\\form_mail_send", "on_postbox_select_changed", form.postbox)

  -- local bag = util_get_form("form_stage_main\\form_bag", true, false)
  -- local grid = bag.imagegrid_task
  -- local GoodsGrid = nx_value("GoodsGrid")
  -- if not nx_is_valid(GoodsGrid) then
  --   return
  -- end
  -- nx_execute("form_stage_main\\form_bag_func", "on_bag_select_changed", bag.imagegrid_task, 3)
  -- GoodsGrid:ViewGridOnSelectItem(grid, 56)
  -- GoodsGrid:ViewGridPutToAnotherView(grid, 35)

  -- nx_execute('custom_sender', 'custom_active_parry', 0, 0)
  --local FORM_TIGUAN_TRACE = "form_stage_main\\form_tiguan\\form_tiguan_trace"
--   local form_trace = util_get_form(FORM_TIGUAN_TRACE, true, false)

-- local FORM_DETAIL = "form_stage_main\\form_tiguan\\form_tiguan_detail"
-- if nx_is_valid(nx_value(FORM_DETAIL)) and util_get_form(FORM_DETAIL, true).Visible then
-- SendNotice("f")
-- end

-- local MAP_FORM = "form_stage_main\\form_map\\form_map_scene"
-- local form_map = nx_value(MAP_FORM)
-- SendNotice(nx_is_valid(form_map))
-- local FORM_SKILL = "form_stage_main\\form_main\\form_main_shortcut_extraskill"
-- local form_skill = nx_value(FORM_SKILL)
-- local grid = form_skill.imagegrid_skill
-- local grid_count = grid.ClomnNum * grid.RowNum
-- for i = 0, grid_count - 1 do
--   local skill_id = nx_execute(FORM_SKILL, "get_skill_id_by_index", i)
--   local skill_flag = nx_execute(FORM_SKILL, "get_skill_flag_by_index", i)
--   console(skill_id)
--   console("\t")
--   console(skill_flag)
-- end

--SendNotice(current_boss)

  --_____test_started_bool = true
  function _____test_started()
    return _____test_started_bool
  end
  -- nhap nhay sang window
  --nx_function("ext_flash_window")

-- local show = true
--   local shortcut_form = nx_value("form_stage_main\\form_main\\form_main_shortcut")
--   if not nx_is_valid(shortcut_form) then
--     return
--   end
--   shortcut_form.Visible = show
--   if true == show then
--     local itemskill_shortcut_grid = nx_value("form_stage_main\\form_main\\form_main_shortcut_itemskill")
--     if nx_is_valid(itemskill_shortcut_grid) and itemskill_shortcut_grid.Visible == true then
--       shortcut_form.Visible = false
--     end
--     local buff_common_grid = nx_value("form_stage_main\\form_main\\form_main_shortcut_buff_common")
--     if nx_is_valid(buff_common_grid) and buff_common_grid.Visible == true and buff_common_grid.isclose_shortgrid == 0 then
--       shortcut_form.Visible = false
--     end
--   end

  -- local game_visual = nx_value("game_visual")
  -- if not nx_is_valid(game_visual) then
  --   return 0
  -- end
  
  --game_visual:CustomSend(nx_int(CLIENT_CUSTOMMSG_BEGIN_QIN), nx_string("musician_10052"))
  
  -- local CUSTOMMSG_SUB_MODIFY_BINGLU_ADD_LEVEL = 1
  -- custom_modify_binglu(CUSTOMMSG_SUB_MODIFY_BINGLU_ADD_LEVEL, "binglu111", nx_number(106), nx_int(1))

-- SendNotice(nx_is_valid(nx_value("form_stage_main\\form_map\\form_map_scene")))
-- local game_visual = nx_value("game_visual")
--   if not nx_is_valid(game_visual) then
--     return false
--   end
--   if game_visual:QueryRoleFloorIndex(role) ~= FLOOR_UNDER_WATER then
--     console_log("\206\180\189\248\200\235\203\174\214\208")
--     return false
--   end
--   local terrain_height = terrain:GetFloorHeight(role.PositionX, role.PositionZ, 0)
--   local water_height = terrain:GetWalkWaterHeight(role.PositionX, role.PositionZ)
--   if water_height - terrain_height > role.height then
--     return true
--   end
--   console_log("\203\228\200\187\194\228\203\174\163\172\181\171\184\223\182\200\178\187\185\187\206\222\183\168\207\194\199\177")
--   return false
-- local game_visual = nx_value("game_visual")
-- local world = nx_value("world")
-- local scene = world.MainScene
-- local terrain = scene.terrain

-- terrain.WaterVisible = true
--   terrain.GroundVisible = true
--   terrain.VisualVisible = true
--   terrain.HelperVisible = false
--   terrain:RefreshGround()
--   terrain:RefreshVisual()
--   terrain:RefreshGrass()
--   terrain:RefreshWater()


-- local ini = nx_execute("util_functions", "get_ini", "share\\creator\\npc_creator\\scenenpc.ini")
--   if not nx_is_valid(ini) then
--     nx_msgbox("share\\creator\\scenenpc.ini " .. get_msg_str("msg_120"))
--   end
--   local count = ini:GetSectionCount()
-- SendNotice(count)

--role:SetPosition(role.PositionX, 200, role.PositionZ)

-- local y = terrain:GetPosiY(pos2[1], pos2[3])
-- add_chat_info(y)
-- if terrain:GetFloorExists(x, z, floor_index) then
--   y = terrain:GetFloorHeight(x, z, floor_index)
-- end
-- local role = nx_value("role")
-- game_visual:SetRoleMoveDistance(role, 50)
-- role:SetPosition(role.PositionX, 200, role.PositionZ)

-- local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\inspect.lua"))
-- local inspect = file()
-- function debugpos(str, isdebug)
-- 	local file = io.open("D:\\path.txt", "a")
-- 	if file == nil then
-- 		nx_value("SystemCenterInfo"):ShowSystemCenterInfo(nx_widestr("Can't open file D:\\log.txt, please check this file!"), 3)
-- 	else
-- 		file:write(inspect(str))
-- 		if isdebug ~= nil then
-- 			file:write("\n")
-- 			file:write(inspect(getmetatable(str)))
-- 			file:write("\n--------------------------------------")
-- 		end
-- 		file:write("\n")
-- 		file:close()
-- 	end
-- end

-- local client = nx_value("game_client")
--   if not nx_is_valid(client) then
--     return
--   end
--   local scene = client:GetScene()
--   if not nx_is_valid(scene) then
--     return
--   end
--   local scene_id = scene:QueryProp("Resource")
--   local path_finding = nx_value("path_finding")
-- scene_id = scene_id .."_main"
--   local count = path_finding:GetPathPointCount(scene_id)
--   for n = 1, count do
--     local xr, yr, zr = path_finding:GetPathPointPos(scene_id, n)
--     local points = path_finding:GetLinkPoints(scene_id, n)
--     debugpos(n)
--     debugpos(xr ..":" ..yr ..":" ..zr)
--     debugpos(points, true)
--     for p = 1, table.getn(points) do
--       local xo, yo, zo = path_finding:GetPathPointPos(scene_id, points[p])
--       debugpos(p)
--       debugpos(xo ..":" ..yo ..":" ..zo)
--       -- local x1, z1 = trans_scene_pos_to_map(xr, zr, form.pic_map)
--       -- local x2, z2 = trans_scene_pos_to_map(xo, zo, form.pic_map)
--       -- form.main_path:AddLine(x1, z1, x2, z2)
--     end
--     debugpos("#####################")
--   end

--   SendNotice("Done")
-- local bag = util_get_form("form_stage_main\\form_bag", true, false)
-- local grid = bag.imagegrid_tool
-- local game_client = nx_value("game_client")
--   local toolbox_view = game_client:GetView(nx_string(2))
--   if not nx_is_valid(toolbox_view) then
--     return
--   end
--   local bind_index = grid:GetBindIndex(27)
--   local viewobj = toolbox_view:GetViewObj(nx_string(bind_index))

-- nx_execute("tips_game", "show_goods_tip", viewobj, grid:GetMouseInItemLeft(), grid:GetMouseInItemTop(), 32, 32, bag)
-- nx_execute("form_stage_main\\form_life\\form_job_main_new", "chang_life_skill_photo", viewobj)
-- local path_finding = nx_value("path_finding")
-- local trace_flag = path_finding.AutoTraceFlag
-- --SendNotice(path_finding:IsDynamicCloneScene())
-- SendNotice(trace_flag)
--if path_finding:IsDynamicCloneScene() and path_finding:IsInDynamicCloneRandomZone(pos_x, pos_z) then
--   local ktst = "clone001"
--   local tru_kim = "TriggerNpc00007"

-- local file = assert(loadfile(nx_resource_path() .. "auto\\camdia\\ktst.lua"))
--file()
-- local boss_3_ma_tien = "bossclone001013"
-- local ruong = get_bao_ruong()
--add_chat_info(getPlayer().Ident)
-- local buf_tho = "buf_clone001_008"
-- remove_buff(buf_tho)


-- local item_id = "item_exchange_xm_mark"
-- local item_pos = tim_item_pos(item_id, 125, 1)
-- SendNotice(item_pos)
-- local ngu_uan = "item_exchange_xm_mark"
-- local the_thoi_trang = "haiwai_box_pingzheng_001"
-- local pos, id = tim_item_pos(the_thoi_trang, 2)
-- add_chat_info(pos)
-- add_chat_info(id)
-- local bag = util_get_form("form_stage_main\\form_bag", true, false)
-- nx_execute("form_stage_main\\form_bag_func", "on_bag_select_changed", bag["imagegrid_tool"], 1)
--local file = assert(loadfile(nx_resource_path() .. "auto\\daily\\como.lua"))


if _____test_started_bool then
  add_chat_info("OFF")
  _____test_started_bool = false
else
  add_chat_info("ON")
  _____test_started_bool = true
end
-- local tru_su = "JobLuoY011"
-- talk_id(tru_su, {805000000}, _____test_started)
-- local form = util_get_form("form_stage_main\\form_shop\\form_shop", true)
-- if nx_is_valid(form) then
--   nx_execute("custom_sender", "custom_buy_item", form.shopid, 1, 10, 1)
--   local book = "hcitem_0301030"
--   while _____test_started() and not has_item(book, 2) do
--     nx_pause(1)
--   end
--   if nx_is_valid(form) then
--     nx_destroy(form)
--   end
--   study_book(book)
-- end
-- require("util_static_data")
-- require("share\\static_data_type")
-- require("form_stage_main\\form_relation\\relation_define")
-- require("role_composite")

-- local hdm_map_id = "school13"
-- local chau_thuong_id = "NPC_xdm_dy_hs"
-- local scene = nx_value("game_scene")
-- local game_visual = nx_value("game_visual")
-- local client = nx_value("game_client")
-- local terrain = scene.terrain
-- local role = nx_value("role")
-- local client_player = client:GetPlayer()
-- local pos = {-346.615,324.908,-145.129,0.675}--get_npc_pos(hdm_map_id, chau_thuong_id)
-- local x,y,z = pos[1], pos[2], pos[3]
-- terrain:RelocateVisual(client_player, x, y, z)
-- terrain:RelocateVisual(role, x, y, z)
-- role:SetPosition(x, y, z)
-- terrain:RefreshVisual()
--game_visual:SwitchPlayerState(role, 1, 103)

--superunlock()
--local como = file()
--como(_____test_started)
-- len_lua(_____test_started)
-- local con_lua = "AIRidePet01"
--dung_vat_pham(con_lua, 1, 0)
--debug_talk("newmp_gumu_yswc_001", {0,0,0,0}, _____test_started)
-- local item = "tigennpc_08"
-- item = item:gsub("%npc", "")
-- SendNotice(item)
-- local a = getDistanceTo({-419.468475, 356.332031, -304.523468})
-- SendNotice(a)
-- local daily_tasks = 
-- {
--   [20605] = true,
--   [20601] = true,-- bat chim de
--   [20602] = true,-- bat chim kho

-- }
-- for i, task in pairs(daily_tasks) do
--   SendNotice(i)
--   SendNotice(task)
-- end  
-- if not form_mail.Visible then
--   nx_execute("form_stage_main\\form_mail\\form_mail", "auto_show_mail_form")
-- else
--   nx_execute("form_stage_main\\form_mail\\form_mail", "send_on_click", form_mail.send)
-- end
-- dung_het_vat_pham(_____test_started, hop_ky_tran_mua, 2, 0, {1,2,3,4})
-- dung_het_vat_pham(_____test_started, tu_linh_dan_mua, 2, 0)

--dung_het_vat_pham(_____test_started, hop_ky_tran, 2, 0, {1,2,3,4})
-- dung_het_vat_pham(_____test_started, tinh_che_tuyet_lien_dan, 2, 0)
-- dung_het_vat_pham(_____test_started, dich_can_dan, 2, 0)
-- dung_het_vat_pham(_____test_started, tu_linh_dan, 2, 0)
--thanhanh_to_hp_by_id("HomePointcity04A")

--dung_het_vat_pham(_____test_started, tu_ha_dan, 2, 0)


--thanhanh_to_hp_by_id("HomePointcity03B")
--local rbtn = nx_custom(form, openbook_table[book_id][3])
-- local lag_pos = {
--   "-646.853,289.964,-200.292,-1.152;-648.133,289.664,-226.410,2.008"
-- }
-- local file = assert(loadfile(nx_resource_path() .. "auto\\thanhhai.lua"))
-- file()
-- console(thanhhai_read_thuoc_info("lnt"))
-- local iniformula = nx_execute("util_functions", "get_ini", "share\\Item\\fuse_formula.ini")
--   local sec_index = iniformula:FindSectionIndex(nx_string(5002))
--   if sec_index < 0 then
--     return 0
--   end
--   local needitem = iniformula:ReadString(sec_index, "Material", "")
--   add_chat_info(needitem)
-- add_chat_info(nx_string(util_text("interactinfo_15970")))
-- local info = util_text("interactinfo_15970")
-- local match = string.match(nx_string(info), '<a href="(.*)" ')
-- local parts = util_split_string(match, ",")
-- add_chat_info(parts[2])
-- add_chat_info(parts[3])
-- local tasks = get_arraylist("force_round_task_info")
-- local child = tasks:GetChild(nx_string(33))
-- if child ~= nil then
--   add_chat_info(child.round)
--   add_chat_info(child.max_round)
--   add_chat_info(child.circle)
--   add_chat_info(child.max_circle)
-- else
--   add_chat_info('nil')
-- end
--local form = util_get_form("form_stage_main\\form_common_notice", true, false)
util_show_form("form_stage_main\\form_single_notice", true)
add_chat_info(nx_is_valid(form))
-- local pos = get_npc_pos("school11" ,"wgm_task_002")
-- console(pos)

-- function buff_stack(buff_id)
  -- local buffInfoCount = 0
  -- local player = getPlayer()
	-- local has_buffInfo = false
  -- while buffInfoCount < 20 do
    -- nx_pause(0)
    -- if has_buffInfo then
      -- local buffInfo = player:QueryProp("BufferInfo"..nx_string(buffInfoCount))
      -- local info = split(nx_string(buffInfo), ",|")
      -- if info[1] == nx_string(buff_id) then
        -- return info[#info]
      -- end
    -- end
    -- buffInfoCount = buffInfoCount + 1
    -- has_buffInfo = player:FindProp("BufferInfo"..nx_string(buffInfoCount))
  -- end
-- end

-- function get_canfuse_num(node_id, job_id, bind_type)
  -- local Fuse_OnlyUseBindType = 0
  -- local Fuse_OnlyUseUnbindType = 1
  -- local Fuse_UseAllType = 2
  -- local game_client = nx_value("game_client")
  -- if not nx_is_valid(game_client) then
    -- return 0
  -- end
  -- local iniformula
  -- if job_id == "sh_ss" or job_id == "sh_hs" then
    -- iniformula = nx_execute("util_functions", "get_ini", "share\\Item\\fuse_wx.ini")
  -- else
    -- iniformula = nx_execute("util_functions", "get_ini", "share\\Item\\fuse_formula.ini")
  -- end
  -- local sec_index = iniformula:FindSectionIndex(nx_string(node_id))
  -- if sec_index < 0 then
    -- return 0
  -- end
  -- local needitem = iniformula:ReadString(sec_index, "Material", "")
  -- if needitem == "" then
    -- return 0
  -- end
  -- local view = game_client:GetView(nx_string(VIEWPORT_MATERIAL_TOOL))
  -- if not nx_is_valid(view) then
    -- return 0
  -- end
  -- local tool = game_client:GetView(nx_string(VIEWPORT_TOOL))
  -- if not nx_is_valid(tool) then
    -- return 0
  -- end
  -- local viewobj_count = view:GetViewObjCount()
  -- local toolobj_count = tool:GetViewObjCount()
  -- local str_lst = util_split_string(needitem, ";")
  -- local flag = false
  -- local min_num = 999
  -- if 0 < table.getn(str_lst) then
    -- for i = 1, table.getn(str_lst) do
      -- local str_temp = util_split_string(str_lst[i], ",")
      -- local item = str_temp[1]
      -- local num = nx_int(str_temp[2])
      -- if num <= nx_int(0) then
        -- num = 1
      -- end
      -- local total = 0
      -- local Material_total = 0
      -- local Tool_total = 0
      -- for i = 1, viewobj_count do
        -- local obj = view:GetViewObjByIndex(i - 1)
        -- local tempid = obj:QueryProp("ConfigID")
        -- local bind_status = obj:QueryProp("BindStatus")
        -- if tempid == item and (bind_type == Fuse_OnlyUseBindType and bind_status == 1 or bind_type == Fuse_OnlyUseUnbindType and bind_status == 0 or bind_type == Fuse_UseAllType) then
          -- flag = true
          -- local cur_amount = obj:QueryProp("Amount")
          -- Material_total = Material_total + cur_amount
        -- end
      -- end
      -- for i = 1, toolobj_count do
        -- local obj = tool:GetViewObjByIndex(i - 1)
        -- local tempid = obj:QueryProp("ConfigID")
        -- local bind_status = obj:QueryProp("BindStatus")
        -- if tempid == item and (bind_type == Fuse_OnlyUseBindType and bind_status == 1 or bind_type == Fuse_OnlyUseUnbindType and bind_status == 0 or bind_type == Fuse_UseAllType) then
          -- flag = true
          -- local cur_amount = obj:QueryProp("Amount")
          -- Tool_total = Tool_total + cur_amount
        -- end
      -- end
      -- local Material_total = nx_int(Material_total / nx_int(num))
      -- local Tool_total = nx_int(Tool_total / nx_int(num))
      -- local temp_min_num = 0
      -- if Material_total > Tool_total then
        -- temp_min_num = Material_total
      -- else
        -- temp_min_num = Tool_total
      -- end
      -- if nx_int(temp_min_num) < nx_int(min_num) then
        -- min_num = temp_min_num
      -- end
    -- end
  -- else
    -- flag = true
    -- min_num = 1
  -- end
  -- if flag == false then
    -- min_num = 0
  -- end
  -- return min_num
-- end
--add_chat_info()
--nx_execute("custom_sender", "custom_send_fuse", nx_string(5002), nx_int(get_canfuse_num(5002, "", 2)), 0, 2)
-- local form = util_get_form("form_stage_main\\form_origin_new\\form_new_origin_main", false, false)
-- if not nx_is_valid(form) then
--   nx_execute("form_stage_main\\form_origin_new\\form_new_origin_main", "open_form")
-- end
-- if not form.Visible then
--   util_auto_show_hide_form("form_stage_main\\form_origin_new\\form_new_origin_main")
-- end
-- nx_execute("form_stage_main\\form_origin_new\\form_new_origin_main", "on_btn_person_click", form)
--nx_execute("form_stage_main\\form_origin_new\\form_new_origin_main", "open_form")
--jump_out_stuck_pos(_____test_started, lag_pos)
--den_pos({-175.691,324.907,-163.590}, _____test_started)

-- local a = get_npc_pos("school05", "FuncNpc01020")
-- nhan_thuong_danh_phan(3301)

-- function get_scene_id_by_name(scene_id)
  -- local ini = nx_execute("util_functions", "get_ini", "share\\rule\\maplist.ini")
  -- if not nx_is_valid(ini) then
    -- return false
  -- end
  -- local item_count = ini:GetSectionItemCount(0)
  -- local index = 0
  -- local scene_name = ""
  -- for i = 1, item_count do
    -- index = index + 1
    -- local scene_name = nx_string(ini:GetSectionItemValue(0, i - 1))
    -- if index == scene_id then
      -- return scene_name
    -- end
  -- end
  -- return ""
-- end
-- function use_skill_musician(grid, index)
  -- local gui = nx_value("gui")
  -- gui.GameHand:ClearHand()
  -- nx_execute("custom_sender", "custom_use_item", grid.typeid, grid:GetBindIndex(index))
-- end

--=====================================
-- function simulate_close_scene()
	-- local form = nx_value("form_stage_main\\form_close_scene")
	-- if not nx_is_valid(form) then
		-- form = nx_execute("util_gui", "util_get_form", "form_stage_main\\form_close_scene", true, false)
		-- nx_set_value("form_stage_main\\form_close_scene", form)
	-- end
	-- form.simulate = 1
	-- form:Show()
	-- nx_pause(2)
	-- form.keep_time = 3
	-- nx_execute("form_stage_main\\form_close_scene", "up_and_down_open", form)
	-- nx_pause(3.5)
	-- nx_destroy(form)
-- end

-- function trans_scene_pos_to_image(x, z, map_width, map_height, terrain_start_x, terrain_start_z, terrain_width, terrain_height)
  -- local map_x = map_width - (x - terrain_start_x) / terrain_width * map_width
  -- local map_z = (z - terrain_start_z) / terrain_height * map_height
  -- return map_x, map_z
-- end
-- function trans_image_pos_to_scene(x, z, map_width, map_height, terrain_start_x, terrain_start_z, terrain_width, terrain_height)
  -- local pos_x = x * terrain_width / map_width + terrain_start_x
  -- local pos_z = z * terrain_height / map_height + terrain_start_z
  -- return pos_x, pos_z
-- end
-- function trans_scene_pos_to_map(x, z, pic_map)
  -- local map_x, map_z
  -- map_x, map_z = trans_scene_pos_to_image(x, z, pic_map.ImageWidth, pic_map.ImageHeight, pic_map.TerrainStartX, pic_map.TerrainStartZ, pic_map.TerrainWidth, pic_map.TerrainHeight)
  -- local sx = (map_x - pic_map.CenterX) * pic_map.ZoomWidth
  -- local sz = (map_z - pic_map.CenterY) * pic_map.ZoomHeight
  -- sx = sx + pic_map.Width / 2
  -- sz = sz + pic_map.Height / 2
  -- return sx, sz
-- end


talk_to({ id = "WorldNpc10203",mapId = "city04"}, {600000000})