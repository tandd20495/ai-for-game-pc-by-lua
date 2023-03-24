function auto_theo_isStarted()
  return auto_theo_isStarted_bool
end

function ___auto_follow(id)
  if not auto_theo_isStarted() then
    add_chat_info("Bắt đầu di chuyển theo đối tượng...")
    auto_theo_isStarted_bool = true
  else
    add_chat_info("Dừng di chuyển theo đối tượng...")
    auto_theo_isStarted_bool = false
  end
  
  while auto_theo_isStarted() do
    nx_pause(0)
    local player = getPlayer()
    if player ~= nil then
      local follow_object = player:QueryProp("LastObject")
      local name = ""
      if id ~= nil then
        follow_object = getNpcById(id)
      else
        
        follow_object = getNpcByIdent(follow_object)
      end
      if follow_object ~= nil then
        if follow_object:FindProp("Name") then
          name =  nx_function("ext_widestr_to_utf8", follow_object:QueryProp("Name"))
        else
          local configId = follow_object:QueryProp("ConfigID")
          name = nx_function("ext_widestr_to_utf8", util_text(configId))
        end
        local pos = getDest(follow_object) 
        if not arrived(pos, 3) then
          move(pos, 1, "Đang di chuyển theo đối tượng [" ..name .."]")
        end
      else
        add_chat_info("Đối tượng không tồn tại...")
      end
    end
  end
end

return ___auto_follow
