-- check status of task by id (single task not multiple tasks like spy)
function get_daily_task_form_name()
	local game_player = getPlayer()
	local school = game_player:QueryProp("NewSchool")
	if school and tonumber(school) ~= 0 then
		return "form_stage_main\\form_school_war\\form_newschool_school_msg_info"
	else
		return "form_stage_main\\form_school_war\\form_new_school_msg_info"
	end
end

local daily_task_form_name = get_daily_task_form_name()

function query_task_done_single(taskId)
	local game_client = nx_value("game_client")
	local client_player = game_client:GetPlayer()
	local rownum = client_player:GetRecordRows("Task_Record")
	for row = 0, rownum - 1 do
		local id = client_player:QueryRecord("Task_Record", row, 0)
		if nx_string(id) == nx_string(taskId) then
			local max = client_player:QueryRecord("Task_Record", row, 5)
			local done_count = client_player:QueryRecord("Task_Record", row, 4)
			return max == done_count, max - done_count
		end
	end
	return nil
end

function query_uncomplete_task_target(taskId)
	local game_client = nx_value("game_client")
	local client_player = game_client:GetPlayer()
	local rownum = client_player:GetRecordRows("Task_Record")
	for row = rownum - 1, 0, -1 do
		local id = client_player:QueryRecord("Task_Record", row, 0)
		local max = client_player:QueryRecord("Task_Record", row, 5)
		local done_count = client_player:QueryRecord("Task_Record", row, 4)
		if nx_string(id) == nx_string(taskId) and max > done_count then
			local target = client_player:QueryRecord("Task_Record", row, 6)
			return target, max - done_count
		end
	end
	return nil
end

function get_daily_interact(type)
	local mgr = nx_value("InteractManager")
	return mgr:GetInteractTime(type)
end

function query_task_status_by_target(taskId, targetId)
	local game_client = nx_value("game_client")
	local client_player = game_client:GetPlayer()
	local rownum = client_player:GetRecordRows("Task_Record")
	for row = 0, rownum - 1 do
		local id = client_player:QueryRecord("Task_Record", row, 0)
		local target = client_player:QueryRecord("Task_Record", row, 6)
		if nx_string(id) == nx_string(taskId) and target ~= nil and nx_string(target:lower()) == nx_string(targetId:lower()) then
			local max = client_player:QueryRecord("Task_Record", row, 5)
			local done_count = client_player:QueryRecord("Task_Record", row, 4)
			return max == done_count, max - done_count
		end
	end
	return nil
end

function query_task_status_by_order(taskId, order)
	local game_client = nx_value("game_client")
	local client_player = game_client:GetPlayer()
	if client_player == nil or nx_value("loading") then return nil end
	local rownum = client_player:GetRecordRows("Task_Record")
	for row = 0, rownum - 1 do
		local id = client_player:QueryRecord("Task_Record", row, 0)
		local orderNo = client_player:QueryRecord("Task_Record", row, 3)
		if nx_string(id) == nx_string(taskId) and nx_int(order) == nx_int(orderNo) then
			local max = client_player:QueryRecord("Task_Record", row, 5)
			local done_count = client_player:QueryRecord("Task_Record", row, 4)
			return max == done_count, max - done_count
		end
	end
	return nil
end

function da_nhan_quest(taskId)
	local game_client = nx_value("game_client")
	local client_player = game_client:GetPlayer()
	if not nx_is_valid(client_player) then return false end
	local rownum = client_player:GetRecordRows("Task_Accepted")
	for row = 0, rownum - 1 do
		local id = client_player:QueryRecord("Task_Accepted", row, 0)
		if nx_string(id) == nx_string(taskId) then
			return true
		end
	end
	return false
end

function get_task_info(isStarted, tasks)
	local player = getPlayer()
	if not nx_is_valid(player) then
		return nil
	end
	local num = player:GetRecordRows("Task_Accepted")
	if nx_int(num) <= nx_int(0) then
		return nil
	end
  for i = 0, num - 1 do
    if not isStarted() then
      break
    end
		local id = tonumber(player:QueryRecord("Task_Accepted", i, 0))
		local scene = tonumber(player:QueryRecord("Task_Accepted", i, 3))
		local submitInfo = nx_string(player:QueryRecord("Task_Accepted", i, 16))
		local title = nx_string(player:QueryRecord("Task_Accepted", i, 5))
		local status = tonumber(player:QueryRecord("Task_Accepted", i, 6))
		local prize = player:QueryRecord("Task_Accepted", i, 17)
		local step = tonumber(player:QueryRecord("Task_Accepted", i, 8))
		prize = util_split_string(prize, ",")
    prize = prize[11]
		local task = tasks[id]
		local submitMap, submitNpc = get_submit_detail(submitInfo)
		submitNpc = submitNpc or nx_string(player:QueryRecord("Task_Accepted", i, 4))
		if task ~= nil and task.tracked then
			return {
				id = id,
				title = title,
				submitNpc = submitNpc,
				submitMap = submitMap,
				status = status,
				prize = prize,
				missions = get_mission(isStarted, id, task.ignore_order),
				step = step
			}
		end
  end
  return nil
end

function get_mission(isStarted, taskID, is_ignore_order)
	local missions = {}
	local miss = nil
	local player = getPlayer()
	if not nx_is_valid(player) then
		return missions
	end
	local num = player:GetRecordRows("Task_Record")
	if nx_int(num) <= nx_int(0) then
		return missions
	end
	local temp_order = 1
  for i = 0, num - 1 do
    if not isStarted() then
      break
    end
		local id = tonumber(player:QueryRecord("Task_Record", i, 0))
		if id == taskID then
			local order = tonumber(player:QueryRecord("Task_Record", i, 3))
			local curNum = tonumber(player:QueryRecord("Task_Record", i, 4))
			local maxNum = tonumber(player:QueryRecord("Task_Record", i, 5))
			--if curNum < maxNum then
				local key = nx_string(player:QueryRecord("Task_Record", i, 6))
				local scene = nx_string(player:QueryRecord("Task_Record", i, 7))
				local info = nx_string(player:QueryRecord("Task_Record", i, 8))
				local index = tonumber(player:QueryRecord("Task_Record", i, 2))
				local map, npc = get_mission_detail(info)
				info = util_split_string(info, "_")
				miss = {
					Key = key,
					Scene = scene,
					Type = info[1],
					Index = index,
					Map = map,
					Npc = npc,
					Done = curNum == maxNum
				}
				-- mot so task ko can order nen deu bang nhau, neu gan cung 1 order se mat mission den sau
				if is_ignore_order then
					missions[temp_order] = miss
					temp_order = temp_order + 1
				else
					missions[order] = miss
				end
			--end
		end
	end
	return missions	
end

function get_mission_detail(info)
	if info == nil then
		return nil, nil
	end
	local text = util_text(info)
	local match = string.match(nx_string(text), '<a href="(.*)" ')
	local parts = util_split_string(match, ",")
	local map = parts[2]
	local npc = parts[3]
	return map, npc
end

function get_submit_detail(info)
	if info == nil then
		return nil, nil
	end
	local text = util_text(info)
	local match = string.match(nx_string(text), '<a href="(.*)" ')
	local parts = util_split_string(match, ",")
	local map = parts[2]
	local npc = parts[3]
	return map, npc
end


local queryRoundTimer = 0
function queryTaskOnServer(tasks, type)
	--1 tuan hoan(an the)
	--2 daily
	local sub_type = type or 2
	add_chat_info("Query task info")
	if timerDiff(queryRoundTimer) < 5 then
		add_chat_info("Query task info cancel")
    return
  end
  
  queryRoundTimer = timerInit()
  for taskId, task in pairs(tasks) do
    nx_execute("custom_sender", "custom_send_query_round_task", nx_int(sub_type), nx_int(taskId))
  end  
end

function showWanFa(type)
  local q_type = type or "daily"
  local form = nx_value(daily_task_form_name)
  if not nx_is_valid(form) then
		util_show_form(daily_task_form_name, true)
    return false
	end
  if not form.rbtn_m4.Checked then
    form.rbtn_m4.Checked = true
    nx_execute(daily_task_form_name, "on_m_checked_changed", form.rbtn_m4)
    return false
  end
  if q_type == "daily" then
    if not form.rbtn_0.Checked then
      form.rbtn_0.Checked = true
      nx_execute(daily_task_form_name, "on_m_checked_changed", form.rbtn_0)
      return false
    end
    if not nx_find_custom(form, "force_task_info") then
      nx_execute(daily_task_form_name, "on_m_checked_changed", form.rbtn_0)
      return false
    end
    if not nx_is_valid(form.force_task_info) then
      nx_execute(daily_task_form_name, "on_m_checked_changed", form.rbtn_0)
      return false
    end
		return true
  elseif q_type == "weekly" then
    if not form.rbtn_4.Checked then
      form.rbtn_4.Checked = true
      nx_execute(daily_task_form_name, "on_rbtn_md_click", form.rbtn_4)
      return false
    end
    if not nx_find_custom(form, "force_round_task_info") then
      nx_execute(daily_task_form_name, "on_rbtn_md_click", form.rbtn_4)
      return false
    end
    if not nx_is_valid(form.force_round_task_info) then
      nx_execute(daily_task_form_name, "on_rbtn_md_click", form.rbtn_4)
      return false
    end
		return true
	elseif q_type == "event" then
    if not form.rbtn_2.Checked then
      form.rbtn_2.Checked = true
      nx_execute(daily_task_form_name, "on_rbtn_md_click", form.rbtn_2)
      return false
    end
    if not nx_find_custom(form, "force_round_task_info") then
      nx_execute(daily_task_form_name, "on_rbtn_md_click", form.rbtn_2)
      return false
    end
    if not nx_is_valid(form.force_round_task_info) then
      nx_execute(daily_task_form_name, "on_rbtn_md_click", form.rbtn_2)
      return false
    end
    return true 
  end
end

function findWeeklyChildTask(taskId)
  local form = nx_value(daily_task_form_name)
  if not nx_is_valid(form) then
    return nil
  end
  if not form.rbtn_m4.Checked then
    return nil
	end
	
	if not form.rbtn_4.Checked then
		form.rbtn_4.Checked = true
		nx_execute(daily_task_form_name, "on_rbtn_md_click", form.rbtn_4)
		return nil
	end
	if not nx_find_custom(form, "force_round_task_info") then
		return nil
	end
	if not nx_is_valid(form.force_round_task_info) then
		return nil
	end
  return form.force_round_task_info:GetChild(nx_string(taskId))  
end

function findEventChildTask(taskId)
  local form = nx_value(daily_task_form_name)
  if not nx_is_valid(form) then
    return nil
  end
  if not form.rbtn_m4.Checked then
    return nil
	end
	
	if not form.rbtn_2.Checked then
		form.rbtn_2.Checked = true
		nx_execute(daily_task_form_name, "on_rbtn_md_click", form.rbtn_2)
		return nil
	end
	if not nx_find_custom(form, "force_task_info") then
		return nil
	end
	if not nx_is_valid(form.force_task_info) then
		return nil
	end
  return form.force_task_info:GetChild(nx_string(taskId))  
end

function is_completed_weekly_task(id, button_no)
	local child
	if button_no == 2 then
		child = findEventChildTask(id)
	else
		child = findWeeklyChildTask(id)
	end
	--SendNotice(nx_string(child.circle) .."/" ..nx_string(child.max_circle))
  --SendNotice(nx_string(child.round) .."/" ..nx_string(child.max_round))
	if child ~= nil and child.round >= child.max_round and child.max_round > 0 then
    return true
  end
  return false  
end

function do_simple_task(isStarted, task, anthe_map_id)
	if task == nil then 
		add_chat_info("Task cannot be nil")
		return
	end
  local task_id = task.id
  local missions = task.missions
  local order = 0
  add_chat_info("Đang Làm Quest " ..wstrToUtf8(util_text(task.title)))
	while isStarted() do
    nx_pause(3)
    ngu_phong()
    local currentMap = LayMapHienTai()
    if not query_task_status_by_order(task_id, order) then
      add_chat_info("13")
      local mission = missions[order]
      if mission ~= nil then
        add_chat_info("12")
        local type = mission.Type
        local map = mission.Map
        local npc = mission.Npc
        local pos = get_npc_pos(map, npc)
				if type == "interactinfo" then
					do_interact_task(isStarted, map, npc, anthe_map_id)
				elseif type == "specialinfo" then
					do_special_task(isStarted, map, npc)
        end
      end
    else
      add_chat_info("14")
      if order >= #missions then
        add_chat_info("Trả Quest " ..wstrToUtf8(util_text(task.title)))
        local da_tra = talk_to_npc(isStarted, task.submitMap, task.submitNpc, anthe_map_id)      
        if da_tra then
          add_chat_info("1")
          break
        end
      else
        add_chat_info("2")
        order = order + 1
      end
    end
	end
end

function do_interact_task(isStarted, map, npc, anthe_map_id)
	talk_to_npc(isStarted, map, npc, anthe_map_id)
end

function do_special_task(isStarted, map, npc)
	
end

function talk_to_npc(isStarted, map, npc, anthe_map_id)
  local currentMap = LayMapHienTai()
  if currentMap ~= map then
    add_chat_info("3")
    if map == anthe_map_id then
      add_chat_info("4")
      local player = getPlayer()
      if not player:FindProp("Dead") or player:QueryProp("Dead") == 0 then
        add_chat_info("9")
        tu_sat()
      elseif player:QueryProp("Dead") == 1 then
        -- hoi sinh mon phai
        add_chat_info("10")
        nx_execute("custom_sender", "custom_relive", 0, 0)
        nx_pause(3)
      end
    else
      add_chat_info("11")
      tele_ve_map(map)
      nx_pause(3)
    end
  else
    add_chat_info("5")
    local pos = get_npc_pos(map, npc)
    move(pos, 1)
    if arrived(pos, 2) then
      add_chat_info("6")
      talk(npc, {0,0,0}, isStarted)
      add_chat_info("7")
      return true
    end
  end
  add_chat_info("8")
  return false
end