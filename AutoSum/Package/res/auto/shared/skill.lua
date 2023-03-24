local WINEXEC_PATH = nx_resource_path() .. "auto\\test.exe"
local CLIENT_SET_PARRY = 2
local TYPE_PLAYER = 2
GLOBAL_SKILL_LIST = {
  { 
    ["name"] = "cs_jl_shuangci", 
    ["buff_nochieu"] = "CS_jl_shuangci02",
    ["nodacthu"] = "CS_jl_shuangci07",
    ["phadef"] = "CS_jl_shuangci06",
    ["combo"] = "CS_jl_shuangci05,CS_jl_shuangci06" --CS_jl_shuangci03 ac quy tranh thuc, CS_jl_shuangci04: doc xa tho tin
  }, --song thich clc - 1
  { 
    ["name"] = "cs_tm_jsc", 
    ["buff_nochieu"] = "CS_tm_jsc03",
    ["nochieu"] = "CS_tm_jsc06",
    ["phadef"] = "CS_tm_jsc04",
    ["combo"] = "CS_tm_jsc01,CS_tm_jsc07"
  }, -- kim xa thich - 2
	{ 
		["name"] = "cs_jh_cqgf",
		["buff_nochieu"] = "cs_jh_cqgf07",
    ["nochieu"] = "cs_jh_cqgf05",
    ["phadef"] = "cs_jh_cqgf02",
    ["combo"] = "cs_jh_cqgf01,cs_jh_cqgf04"
	}, -- Tho Thien Cong Phu  - 3
  { ["name"] = "cs_jy_yzq" }, --  - 4
  { ["name"] = "cs_jy_xsd" }, --  - 5
	{ ["name"] = "CS_hs_hsjf" }, --  - 6
	{
		["name"] = "CS_jy_shd",
		["buff_nochieu"] = "",
    ["nochieu"] = "CS_jy_shd06",
    ["phadef"] = "CS_jy_shd04",
    ["combo"] = "CS_jy_shd02,CS_jy_shd01,CS_jy_shd03,CS_jy_shd07"
	}, -- That Hon Dao Phap - cyv 0 7
	{
		["name"] = "CS_gm_txjj",
		["buff_nochieu"] = "CS_gm_txjj04",
    ["nochieu"] = "CS_gm_txjj08",
    ["phadef"] = "CS_gm_txjj06",
    ["combo"] = "CS_gm_txjj03,CS_gm_txjj01,CS_gm_txjj02"
	}, -- Thien Tam Kiem Quyet - co mo 8
	{
		["name"] = "CS_jh_slbwj",
		["buff_nochieu"] = "", -- CS_jh_slbwj03: Thái Âm Hóa Sinh
    ["nochieu"] = "CS_jh_slbwj07", -- Long Ngâm Nộ Đào
    ["phadef"] = "CS_jh_slbwj04", -- Uy Nhiếp Vạn Linh
    ["combo"] = "CS_jh_slbwj06,CS_jh_slbwj01" -- Đằng Thiên Đảo Địa,Khu Lôi Bôn Vân
	}, -- Thần Long Bắc Võ Kiếm 9
	{
		["name"] = "CS_xd_dyshd",
		["buff_nochieu"] = "CS_xd_dyshd05",
    ["nochieu"] = "CS_xd_dyshd07", 
    ["phadef"] = "CS_xd_dyshd04", 
    ["combo"] = "CS_xd_dyshd06,CS_xd_dyshd05,CS_xd_dyshd01,CS_xd_dyshd07" 
	} -- dia nguc nhiep hon dao 10
}

viagra_list = {
  {
    ["name"] = "yp_donghai_03",
    ["buff"] = "buf_yp_pl_004"
  },
  {
    ["name"] = "yaopin90026",
    ["buff"] = ""
  }
}

cau_hoa_list = {
  "",
  "caiyao20002",
  "caiyao10197"
}

function skill_use(skillId, delay)
	delay = delay or 0
	nx_pause(delay)
	local fight = nx_value("fight")
	fight:TraceUseSkill(skillId, false, false)
end

function skill_use_non_stop(skillId, delay, isStarted)
	while not isStarted() do
		skill_use(skillId)
		nx_pause(delay)
	end
end

function kich_hoat_noi_cong(id)
	local game_client = nx_value("game_client")
	local player = game_client:GetPlayer()
	if player:QueryProp("CurNeiGong") ~= id then
		nx_execute("custom_sender", "custom_use_neigong", id)
	end
end


function do_don()
	nx_execute("custom_sender", "custom_active_parry", nx_int(1), nx_int(0))
	--nx_function("ext_win_exec", WINEXEC_PATH .. " MOUSEDOWN")
end

function huy_do_don()
	nx_execute("custom_sender", "custom_active_parry", nx_int(0), nx_int(0))
	--nx_function("ext_win_exec", WINEXEC_PATH .. " MOUSEUP")
end

function da_hoc_skill(skill_id)
	local fight = nx_value("fight")
  local skill = fight:FindSkill(skill_id)
  if nx_is_valid(skill) then
		return true
	else
		return false
  end
end

function set_do_don(flag)
	nx_execute("custom_sender", "custom_active_parry", nx_int(CLIENT_SET_PARRY), nx_int(flag))
end

function set_auto_do_don()
	local parry_type = 2 -- 2: auto, 0: manual
	nx_execute("custom_sender", "custom_active_parry", nx_int(CLIENT_SET_PARRY), nx_int(parry_type))
end

function set_auto_bo_sung_am_khi()
	nx_execute("custom_sender", "custom_auto_equip_shotweapon", nx_int(1)) -- 0 khong, 1 co
end

function query_skill_info(id)
	local game_client = nx_value("game_client")
	local view = game_client:GetView(nx_string(40))
	local viewobj_list = view:GetViewObjList()
	for index, skill in pairs(viewobj_list) do
		if skill:QueryProp("ConfigID") == id then
			return {
				["Level"] = skill:QueryProp("Level"),
				["MaxLevel"] = skill:QueryProp("MaxLevel"),
				["TotalFillValue"] = skill:QueryProp("TotalFillValue"),
				["CurFillValue"] = skill:QueryProp("CurFillValue")
			}
		end
	end
end

function da_hoc_nc(id)
	local game_client = nx_value("game_client")
	local view = game_client:GetView(nx_string(43))
	local viewobj_list = view:GetViewObjList()
	for index, nc in pairs(viewobj_list) do
		if nc:QueryProp("ConfigID") == id then
			return true
		end
	end
	return false
end

function get_noi_cong_info(noicong_id)
	local game_client = nx_value("game_client")
	if not nx_is_valid(game_client) then
		return nil
	end
	local noicong_view = game_client:GetView(nx_string(43))
	if not nx_is_valid(noicong_view) then
		return nil
	end
	local noicong_view_objlist = noicong_view:GetViewObjList()
	for i, obj in pairs(noicong_view_objlist) do
		local config_id = obj:QueryProp("ConfigID")
		if nx_string(config_id) == nx_string(noicong_id) then
			return {
				["MaxLevel"] = obj:QueryProp("MaxLevel"),
				["Level"] = obj:QueryProp("Level"),
				["TotalFillValue"] = obj:QueryProp("TotalFillValue"),
				["CurFillValue"] = obj:QueryProp("CurFillValue")
			}
		end
	end
	return nil
end

function Fight_Skill(boss_name, fightPos, selectskill)
	local game_client = nx_value("game_client")
	if not nx_is_valid(game_client) then
		return false
	end
	local game_visual = nx_value("game_visual")
	if not nx_is_valid(game_visual) then
		return false
	end
	local client_player = game_client:GetPlayer()
	local visual_player = game_visual:GetPlayer()
	local player_pos_x = visual_player.PositionX
	local player_pos_y = visual_player.PositionY
	local player_pos_z = visual_player.PositionZ

	local buffAD = get_buff_info("buf_CS_jh_yydld06_4")
	local buffSD = get_buff_info("buf_CS_jh_yydf05")
	local buffTH = get_buff_info("buf_CS_tm_jsc03")
	local buffKF = get_buff_info("buf_CS_jh_cqgf07")
	local buffOT = get_buff_info("buf_CS_jl_shuangci07")
	local buffHD = get_buff_info("buf_CS_jl_shuangci02")
	local fight = nx_value("fight")
	local boss_obj = select_target_byName(boss_name)
	if boss_obj ~= nil then
		local can_attack_npc = boss_obj:QueryProp("ConfigID") == boss_name and fight:CanAttackNpc(client_player, boss_obj)
		local can_attack_player = nx_string(boss_obj:QueryProp("Name")) == nx_string(boss_name) and fight:CanAttackPlayer(client_player, boss_obj)
		if can_attack_npc or can_attack_player then
			local pos = getDest(boss_obj)
			add_chat_info(pos[1])
			if (buffAD == nil or buffAD < 5) and (buffKF == nil or buffKF < 5) and (buffTH == nil or buffTH < 5) and (buffHD == nil or buffHD < 20) then
				nx_pause(0.1)
				fight:TraceUseSkill(GLOBAL_SKILL_LIST[selectskill].buff_nochieu, false, false)
			end
			if fightPos ~= nil and not arrived(fightPos) then
				jump_to(fightPos, 1)
			elseif fightPos == nil and not arrived(pos, 3) then
				jump_to(pos, 1)
			else
				if buffSD or buffAD then
					if client_player:QueryProp("SP") >= 50 then
						if (buffOT == nil or buffOT < 10) and (buffSD == nil or buffSD < 5) then
							fight:TraceUseSkill(GLOBAL_SKILL_LIST[selectskill].nodacthu, false, false)
						end
						nx_pause(0.1)
						fight:TraceUseSkill(GLOBAL_SKILL_LIST[selectskill].nochieu2, false, false)
					end
					if nx_function("find_buffer", boss_obj, "BuffInParry") then
						nx_pause(0.1)
						fight:TraceUseSkill(GLOBAL_SKILL_LIST[selectskill].phadef2, false, false)
					else
						local skill2 = util_split_string(GLOBAL_SKILL_LIST[selectskill].combo2, ",")
						for m = 1, table.getn(skill2) do
							add_chat_info("T\225\187\177 \196\145\195\161nh chu\225\187\151i li\195\170n chi\195\170u theo b\225\187\153 c\195\179 buff ...")
							nx_pause(0.1)
							fight:TraceUseSkill(skill2[m], false, false)
						end
					end
				else
					if client_player:QueryProp("SP") >= 50 then
						if (buffOT == nil or buffOT < 5) and (buffSD == nil or buffSD < 5) and GLOBAL_SKILL_LIST[selectskill].nodacthu then
							fight:TraceUseSkill(GLOBAL_SKILL_LIST[selectskill].nodacthu, false, false)
						end
						if GLOBAL_SKILL_LIST[selectskill].nochieu then
							nx_pause(0.1)
							fight:TraceUseSkill(GLOBAL_SKILL_LIST[selectskill].nochieu, false, false)
						end
					end
					if nx_function("find_buffer", boss_obj, "BuffInParry") then
						nx_pause(0.1)
						fight:TraceUseSkill(GLOBAL_SKILL_LIST[selectskill].phadef, false, false)
					else
						local skill = util_split_string(GLOBAL_SKILL_LIST[selectskill].combo, ",")
						for n = 1, table.getn(skill) do
							add_chat_info("Tiến hành chuỗi liên chiêu theo bộ ...")
							nx_pause(0.1)
							fight:TraceUseSkill(skill[n], false, false)
						end
					end
				end
			end
		end
	else
		add_chat_info("Đối tượng không tồn tại" .."[" ..boss_name .."]")
	end
end

function Fight_Skill_by_obj(boss_obj, fightPos, selectskill)
	local game_client = nx_value("game_client")
	if not nx_is_valid(game_client) then
		return false
	end
	local game_visual = nx_value("game_visual")
	if not nx_is_valid(game_visual) then
		return false
	end
	local client_player = game_client:GetPlayer()
	local visual_player = game_visual:GetPlayer()
	local player_pos_x = visual_player.PositionX
	local player_pos_y = visual_player.PositionY
	local player_pos_z = visual_player.PositionZ

	local buffAD = get_buff_info("buf_CS_jh_yydld06_4")
	local buffSD = get_buff_info("buf_CS_jh_yydf05")
	local buffTH = get_buff_info("buf_CS_tm_jsc03")
	local buffKF = get_buff_info("buf_CS_jh_cqgf07")
	local buffOT = get_buff_info("buf_CS_jl_shuangci07")
	local buffHD = get_buff_info("buf_CS_jl_shuangci02")
	local fight = nx_value("fight")
	local boss_name = boss_obj:QueryProp("ConfigID")
	if boss_obj ~= nil then
		local can_attack_npc = boss_obj:QueryProp("ConfigID") == boss_name and fight:CanAttackNpc(client_player, boss_obj)
		local can_attack_player = nx_string(boss_obj:QueryProp("Name")) == nx_string(boss_name) and fight:CanAttackPlayer(client_player, boss_obj)
		if can_attack_npc or can_attack_player then
			local pos = getDest(boss_obj)
			add_chat_info(pos[1])
			if (buffAD == nil or buffAD < 5) and (buffKF == nil or buffKF < 5) and (buffTH == nil or buffTH < 5) and (buffHD == nil or buffHD < 20) then
				nx_pause(0.1)
				fight:TraceUseSkill(GLOBAL_SKILL_LIST[selectskill].buff_nochieu, false, false)
			end
			if fightPos ~= nil and not arrived(fightPos) then
				jump_to(fightPos, 1)
			elseif fightPos == nil and not arrived(pos, 3) then
				jump_to(pos, 1)
			else
				if buffSD or buffAD then
					if client_player:QueryProp("SP") >= 50 then
						if (buffOT == nil or buffOT < 10) and (buffSD == nil or buffSD < 5) then
							fight:TraceUseSkill(GLOBAL_SKILL_LIST[selectskill].nodacthu, false, false)
						end
						nx_pause(0.1)
						fight:TraceUseSkill(GLOBAL_SKILL_LIST[selectskill].nochieu2, false, false)
					end
					if nx_function("find_buffer", boss_obj, "BuffInParry") then
						nx_pause(0.1)
						fight:TraceUseSkill(GLOBAL_SKILL_LIST[selectskill].phadef2, false, false)
					else
						local skill2 = util_split_string(GLOBAL_SKILL_LIST[selectskill].combo2, ",")
						for m = 1, table.getn(skill2) do
							add_chat_info("T\225\187\177 \196\145\195\161nh chu\225\187\151i li\195\170n chi\195\170u theo b\225\187\153 c\195\179 buff ...")
							nx_pause(0.1)
							fight:TraceUseSkill(skill2[m], false, false)
						end
					end
				else
					if client_player:QueryProp("SP") >= 50 then
						if (buffOT == nil or buffOT < 5) and (buffSD == nil or buffSD < 5) and GLOBAL_SKILL_LIST[selectskill].nodacthu then
							fight:TraceUseSkill(GLOBAL_SKILL_LIST[selectskill].nodacthu, false, false)
						end
						if GLOBAL_SKILL_LIST[selectskill].nochieu then
							nx_pause(0.1)
							fight:TraceUseSkill(GLOBAL_SKILL_LIST[selectskill].nochieu, false, false)
						end
					end
					if nx_function("find_buffer", boss_obj, "BuffInParry") then
						nx_pause(0.1)
						fight:TraceUseSkill(GLOBAL_SKILL_LIST[selectskill].phadef, false, false)
					else
						local skill = util_split_string(GLOBAL_SKILL_LIST[selectskill].combo, ",")
						for n = 1, table.getn(skill) do
							add_chat_info("Tiến hành chuỗi liên chiêu theo bộ ...")
							nx_pause(0.1)
							fight:TraceUseSkill(skill[n], false, false)
						end
					end
				end
			end
		end
	else
		add_chat_info("Đối tượng không tồn tại" .."[" ..boss_name .."]")
	end
end

function select_target_byName(playername)
  local game_client = nx_value("game_client")
  local game_visual = nx_value("game_visual")
  if not nx_is_valid(game_client) then
    return
  end
  if not nx_is_valid(game_visual) then
    return
  end
  local client_scene = game_client:GetScene()
  if not nx_is_valid(client_scene) then
    return
  end
  local obj_list = client_scene:GetSceneObjList()
  for i = 1, table.maxn(obj_list) do
    local client_scene_obj = obj_list[i]
    local visual_scene_obj = game_visual:GetSceneObj(client_scene_obj.Ident)
    local type = client_scene_obj:QueryProp("Type")
    if type == TYPE_PLAYER then
      local Name = client_scene_obj:QueryProp("Name")
      if nx_string(playername) == nx_string(Name) then
        local fight = nx_value("fight")
				fight:SelectTarget(visual_scene_obj)
				return client_scene_obj
      end
    else
      local Name = client_scene_obj:QueryProp("ConfigID")
      if nx_string(playername) == nx_string(Name) then
        local fight = nx_value("fight")
        fight:SelectTarget(visual_scene_obj)
        return client_scene_obj
      end
    end
  end
end

function get_di_cot_skill_list()
  local game_client = nx_value("game_client")
	local view = game_client:GetView(nx_string(40))
  local viewobj_list = view:GetViewObjList()
  local dicot_list = {}
  dicot_list[#dicot_list + 1] = ""
  for index, skill in pairs(viewobj_list) do
    local configId = skill:QueryProp("ConfigID")
    if string.find(configId, "CS_change_") then
      dicot_list[#dicot_list + 1] = configId
		end
  end
  return dicot_list
end

function dung_thuoc_tang_luc(data, callback)
	callback = callback or add_chat_info
  if data.cauhoa > 1 then
    callback("Câu hỏa")
    local buff_time = get_buff_info("buff_xjzgh_01")
    if buff_time == nil or buff_time <= 180 then -- khong co buff hoac buff nho hon 3'
      while not has_buff("buff_xjzgh_02") do
        nx_pause(0)
        skill_use("xjz_01", 10)
      end
      nx_execute("custom_sender", "custom_remove_buffer", "buff_xjzgh_01")
      dung_vat_pham(cau_hoa_list[data.cauhoa], 1, 8)
    end
  end
  if data.thuoc_str ~= "" then
    callback("Thuốc")
    local thuoc = util_split_string(data.thuoc_str, ",")
    for i = 1, table.getn(thuoc) do
      for j = 1, table.getn(viagra_list) do
        local buff_time = get_buff_info(viagra_list[j].buff)
        if thuoc[i] == viagra_list[j].name and (buff_time == nil or buff_time <= 180) then
          nx_execute("custom_sender", "custom_remove_buffer", viagra_list[j].buff)
          dung_vat_pham(viagra_list[j].name, 1, 5)
          break
        end
      end
    end
  end
  if data.dicot > 1 then
    callback("Dị cốt")
    local di_cot_list = get_di_cot_skill_list()
    local di_cot = di_cot_list[data.dicot]
    local buff_time = get_buff_info("buf_"..di_cot)
    if buff_time == nil or buff_time <= 180 then
      skill_use(di_cot)
    end
  end
end

function ban_am_khi(id)
	skill_use("hw_normal_" ..id)--_zl") -- cham
	-- skill_use("hw_normal_dw") -- hoa dan
	-- skill_use("hw_normal_fd") -- phi dao
	-- skill_use("hw_normal_fb") -- phi tieu
	-- skill_use("hw_normal_jk") -- cơ quát
	-- skill_use("hw_normal_hy") -- cơ quát
end

function Fight_Skill_targeted(isStarted, skill, pos)
	while isStarted() do
		nx_pause(0)
		local player = getPlayer()
		if player ~= nil then
			local last_object = player:QueryProp("LastObject")
			if last_object ~= nil then
				last_object = getNpcByIdent(last_object)
				if last_object and last_object:QueryProp("Dead") ~= 1 then
					Fight_Skill_by_obj(last_object, pos, skill)
				else
					break
				end
			end
		end
	end
end

function spam_Skill(fightPos, selectskill)
	local game_client = nx_value("game_client")
	if not nx_is_valid(game_client) then
		return false
	end
	local game_visual = nx_value("game_visual")
	if not nx_is_valid(game_visual) then
		return false
	end
	local client_player = game_client:GetPlayer()
	local visual_player = game_visual:GetPlayer()
	local player_pos_x = visual_player.PositionX
	local player_pos_y = visual_player.PositionY
	local player_pos_z = visual_player.PositionZ

	local buffAD = get_buff_info("buf_CS_jh_yydld06_4")
	local buffSD = get_buff_info("buf_CS_jh_yydf05")
	local buffTH = get_buff_info("buf_CS_tm_jsc03")
	local buffKF = get_buff_info("buf_CS_jh_cqgf07")
	local buffOT = get_buff_info("buf_CS_jl_shuangci07")
	local buffHD = get_buff_info("buf_CS_jl_shuangci02")
	local fight = nx_value("fight")
	if (buffAD == nil or buffAD < 5) and (buffKF == nil or buffKF < 5) and (buffTH == nil or buffTH < 5) and (buffHD == nil or buffHD < 20) then
		nx_pause(0.1)
		fight:TraceUseSkill(GLOBAL_SKILL_LIST[selectskill].buff_nochieu, false, false)
	end
	if fightPos ~= nil and not arrived(fightPos) then
		jump_to(fightPos, 1)
	else
		if buffSD or buffAD then
			if client_player:QueryProp("SP") >= 50 then
				if (buffOT == nil or buffOT < 10) and (buffSD == nil or buffSD < 5) then
					fight:TraceUseSkill(GLOBAL_SKILL_LIST[selectskill].nodacthu, false, false)
				end
				nx_pause(0.1)
				fight:TraceUseSkill(GLOBAL_SKILL_LIST[selectskill].nochieu2, false, false)
			end
			if nx_function("find_buffer", boss_obj, "BuffInParry") then
				nx_pause(0.1)
				fight:TraceUseSkill(GLOBAL_SKILL_LIST[selectskill].phadef2, false, false)
			else
				local skill2 = util_split_string(GLOBAL_SKILL_LIST[selectskill].combo2, ",")
				for m = 1, table.getn(skill2) do
					add_chat_info("T\225\187\177 \196\145\195\161nh chu\225\187\151i li\195\170n chi\195\170u theo b\225\187\153 c\195\179 buff ...")
					nx_pause(0.1)
					fight:TraceUseSkill(skill2[m], false, false)
				end
			end
		else
			if client_player:QueryProp("SP") >= 50 then
				if (buffOT == nil or buffOT < 5) and (buffSD == nil or buffSD < 5) and GLOBAL_SKILL_LIST[selectskill].nodacthu then
					fight:TraceUseSkill(GLOBAL_SKILL_LIST[selectskill].nodacthu, false, false)
				end
				if GLOBAL_SKILL_LIST[selectskill].nochieu then
					nx_pause(0.1)
					fight:TraceUseSkill(GLOBAL_SKILL_LIST[selectskill].nochieu, false, false)
				end
			end
			local skill = util_split_string(GLOBAL_SKILL_LIST[selectskill].combo, ",")
			for n = 1, table.getn(skill) do
				add_chat_info("Tiến hành chuỗi liên chiêu theo bộ ...")
				nx_pause(0.1)
				fight:TraceUseSkill(skill[n], false, false)
			end
		end
	end
end