function _auto_skill_isStarted()
  return auto_skill_started_bool
end

function _auto_skill_by_target(skill, target, pos)
  --pos = pos or currentPos()
  
  while _auto_skill_isStarted() do
    nx_pause(0)

    local player = getPlayer()
    if player ~= nil then
      local last_object = player:QueryProp("LastObject")
      if last_object ~= nil then
        last_object = getNpcByIdent(last_object)
        target = target or (last_object and last_object:QueryProp("ConfigID"))
      end
    end

    if target ~= nil then
      Fight_Skill(target, pos, skill)
    end
  end
end

function _auto_skill(skill, target, pos)
  skill = tonumber(skill)
  if not _auto_skill_isStarted() then
    auto_skill_started_bool = true
    add_chat_info("Auto Skill Vao Doi Tuong Dang Duoc Target")
    _auto_skill_by_target(skill, target, pos)
  else
    add_chat_info("Stop Auto Skill")
    auto_skill_started_bool = false
  end
end

return _auto_skill