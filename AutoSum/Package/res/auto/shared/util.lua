function IniRead(file, section, key, default)
	key = nx_string(key)
	local ini = nx_create("IniDocument")
	ini.FileName = file
	if not ini:LoadFromFile() then
		nx_destroy(ini)
		return nx_widestr(default)
	end
	local text = ini:ReadString(section, key, default)
	if text == nil or text == "" then
		return nx_widestr("0")
	end
	nx_destroy(ini)
	return utf8ToWstr(text)
end

function IniLoad(file)
	local ini = nx_create("IniDocument")
	ini.FileName = file
	if not ini:LoadFromFile() then
		nx_destroy(ini)
	end

	return ini
end

function utf8ToWstr(content)
  return nx_function("ext_utf8_to_widestr", content)
end

function wstrToUtf8(content)
return nx_function("ext_widestr_to_utf8", content)
end

function timerDiff(t)
  if t == 0 then
    return 999999
  end
  return os.clock() - t  
end

function timerInit()
  return os.clock()
end

function LayMapHienTai()
	return nx_value("form_stage_main\\form_map\\form_map_scene").current_map
end

function getPlayer()
	local game_client = nx_value("game_client")
	local player = game_client:GetPlayer()
	return player
end

function getDest(object)
	return {object.DestX, object.DestY, object.DestZ}
end

function error(e)
	add_chat_info("Get Pos error")
end

function getVisualObj(obj)
	if not nx_is_valid(obj) then
		return
	end
	local game_visual = nx_value("game_visual")
	local vObj = game_visual:GetSceneObj(obj.Ident)
	return vObj	
end

function getPos(object)
	local result = nil
	-- function _temp()
	-- 	if object ~= nil then 
	-- 		-- local x, y, z = nx_find_custom(object, "PosiX"), nx_find_custom(object, "PosiY"), nx_find_custom(object, "PosiZ")
	-- 		-- SendNotice(x)
	-- 		-- if x and y and z then
	-- 			result = {object.PosiX, object.PosiY, object.PosiZ}
	-- 		-- end
	-- 	end
	-- end
	-- pcall(_temp, error)
	local vObj = getVisualObj(object)
	if nx_is_valid(vObj) then
		result = {vObj.PositionX, vObj.PositionY, vObj.PositionZ}
	end
	return result
end

function get_map_id(name)
	if name == "cyv" then
		return "school01"
	elseif name == "cb" then
		return "school02"
	elseif name == "qtd" then
		return "school03"
	elseif name == "clc" then
		return "school04"
	elseif name == "dm" then
		return "school05"
	elseif name == "nm" then
		return "school06"
	elseif name == "vd" then
		return "school07"
	elseif name == "tl" then
		return "school08"
	elseif name == "dhd" then
		return "school10"
	elseif name == "vcm" then
		return "school11"
	elseif name == "hdm" then
		return "school13"
	elseif name == "cm" then
		return "school14"
	elseif name == "nlb" then
		return "school15"
	elseif name == "hs" then
		return "school17"
	elseif name == "ttc" then
		return "school19"
	elseif name == "yk" then
		return "city01"
	elseif name == "tc" then
		return "city02"
	elseif name == "kl" then
		return "city03"
	elseif name == "ld" then
		return "city04"
	elseif name == "td" then
		return "city05"
	end
end

function vntext(ui_key)
	return wstrToUtf8(util_text(nx_string(ui_key)))
end

function get_bag_id_by_config_id(configId)
	local form = nx_value("form_stage_main\\form_bag")
  if not nx_is_valid(form) then
    return nil
  end
  local item_query = nx_value("ItemQuery")
  if not nx_is_valid(item_query) then
    return nil
  end
  local goods_grid = nx_value("GoodsGrid")
  if not nx_is_valid(goods_grid) then
    return nil
	end
	local bExist = item_query:FindItemByConfigID(nx_string(configId))
	if not bExist then
		return nil
	end
  -- local count = goods_grid:GetItemCount(configid)
  -- if count == 0 then
  --   return nil
	-- end
	--ItemQuery:GetItemPropByConfigID(nx_string(item_config), nx_string("IsMarketItem"))
  local bag_no = item_query:GetItemPropByConfigID(nx_string(configId), nx_string("ViewID"))
  bag_no = tonumber(bag_no)
  local rbtn
  if bag_no == 1 then
    return 2 -- tui vat pham
  elseif bag_no == 2 then
    return 121 -- tui trang bi
  elseif bag_no == 3 then
    return 123 -- tui nguyen lieu
  elseif bag_no == 4 then
    return 125 -- tui nhiem vu
  end
end