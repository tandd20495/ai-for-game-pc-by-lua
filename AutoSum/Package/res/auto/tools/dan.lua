function __auto_dan(cam_pho)
  if not __is_auto_dan then
    __is_auto_dan = true
    local visual = nx_value("game_visual")
    if not nx_is_valid(visual) then
      return false
    end
    local client = nx_value("game_client")
    if not nx_is_valid(client) then
      return false
    end
    local scene = client:GetScene()
    if not nx_is_valid(scene) then
      return false
    end
    local client_player = client:GetPlayer()
    if not nx_is_valid(client_player) then
      return false
    end
    add_chat_info("Start Auto Đàn")
    while __is_auto_dan do
      nx_pause(1)
      local logic_state = client_player:QueryProp("LogicState")
      if nx_int(logic_state) ~= nx_int(10) then
        
      end
    end
  else
    add_chat_info("Kết thúc auto đàn")
    __is_auto_dan = false
  end
end

return __auto_dan