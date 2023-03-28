require("utils")
require("util_gui")
require("util_functions")
require("tips_data")
require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")
require("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs")

-- Initialize skin path for form
local THIS_FORM = "admin_yBreaker\\yBreaker_form_swap"

function on_form_main_init(form)
    form.Fixed = false
    form.is_minimize = false
end

function on_main_form_open(form)
    change_form_size()
    form.is_minimize = false
	-- Variable for swap 30% + book 10%
    local autoswapvk = false
	-- Variable for swap book defense
	local autoswap = false

end

function on_main_form_close(form)
    autoswapvk = false
	autoswap = false
    nx_destroy(form)
end

function change_form_size()
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return
    end
    local gui = nx_value("gui")
    form.Left = 240
    form.Top = (gui.Height / 2)
end

function on_btn_close_click(btn)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end

-- Function swap 30% + book 10% damage
function on_btn_swap_30_per_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
	
	if autoswapvk then
		autoswapvk = false
		btn.Text = nx_function("ext_utf8_to_widestr", "Công")
    else
		autoswapvk = true
		btn.Text = nx_function("ext_utf8_to_widestr", "Dừng")	  
    end
	
    local form = util_get_form("form_stage_main\\form_bag")
    if nx_is_valid(form) then
      local ini = get_ini_safe("share\\ModifyPack\\SkillPack.ini")
      if nx_is_valid(ini) then
        while autoswapvk do
          nx_pause(0.1)
		  
          local player = yBreaker_get_player()
          if nx_is_valid(player) then
            if player:FindProp("CurSkillID") then
              local fight = nx_value("fight")
              if player:QueryProp("CurSkillID") ~= "" then				
                EquipItemProp(form, ini, player:QueryProp("CurSkillID"), 1)
                nx_pause(0.0001)
              end
            end
          end
        end
      end
    end
end

-- Function swap book defense
function on_btn_swap_book_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
	
	if autoswap then
		autoswap = false
		btn.Text = nx_function("ext_utf8_to_widestr", "Thủ")
	else
		autoswap = true
		btn.Text = nx_function("ext_utf8_to_widestr", "Dừng")
	end
	
	local form = util_get_form("form_stage_main\\form_bag")
	if nx_is_valid(form) then
		local ini = get_ini_safe("share\\ModifyPack\\SkillPack.ini")
		
		if nx_is_valid(ini) then
			while autoswap do
				LoadItemInBag()
				nx_pause(0.1)
				
				local player = yBreaker_get_player()
				if nx_is_valid(player) then
					if player:FindProp("CurSkillID") then
						local fight = nx_value("fight")
						if player:QueryProp("CurSkillID") ~= "" then
							SwapTrangBi(ini,player:QueryProp("CurSkillID"))
							nx_pause(0.0001)
						else

							local role = util_get_role_model()
							local target_role = util_get_target_role_model()
							local target = AutoGetCurSelect2()
							if nx_is_valid(role) and nx_is_valid(target_role) then
								if role.state ~= "locked" then
									-- 1% máu mana
									local curSkillDamage, curCPDamage, curSTDamage, binhthuName = getCurrentWeapon(ini,ItemType, "")
									if nx_string(binhthuName) ~= nx_string("ng_ss_5_3") then
										showUtf8Text("1%", 3)
										local form = util_get_form("form_stage_main\\form_bag")
										if nx_is_valid(form) then
											for i=1,table.getn(bagItem) do
												if bagItem[i]["ItemEquipType"] == "FacultyPaint" or bagItem[i]["ItemEquipType"] == "FacultyBook" then
													if bagItem[i]["ConfigID"] == "ng_ss_5_3" then
														nx_execute("form_stage_main\\form_bag_func", "on_bag_right_click", form.imagegrid_equip, nx_number(bagItem[i]["ItemID"]) - 1)
														break
													end
												end
											end
										end
										nx_pause(0.5)
									end
								elseif role.state == "locked" and target_role.state == "locked" and target:QueryProp("CurSkillTaolu") ~= "" and role.state == "locked" then
									-- giảm damage 3%
									local curSkillDamage, curCPDamage, curSTDamage, binhthuName = getCurrentWeapon(ini,ItemType, "")
									if nx_string(binhthuName) ~= nx_string("ng_ss_5_2") then
										local form = util_get_form("form_stage_main\\form_bag")
										if nx_is_valid(form) then
											for i=1,table.getn(bagItem) do
												if bagItem[i]["ItemEquipType"] == "FacultyPaint" or bagItem[i]["ItemEquipType"] == "FacultyBook" then
													if bagItem[i]["ConfigID"] == "ng_ss_5_2" then
														nx_execute("form_stage_main\\form_bag_func", "on_bag_right_click", form.imagegrid_equip, nx_number(bagItem[i]["ItemID"]) - 1)
														break
													end
												end
											end
										end
										nx_pause(0.5)
									end
									-- end giảm damage
								end
							end
						end
					end
				end
			end
		end
	end
end

-- Show hide form swap
function show_hide_form_swap(btn)
	util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_swap")
end


local bagItem = {}
function getCurWeapon(ini, skill_prop)
	local game_client = nx_value("game_client")
	local client_player = game_client:GetPlayer()
	if nx_is_valid(client_player) then
		local scene = game_client:GetScene()
		local view_table = game_client:GetViewList()
		for i = 1, table.getn(view_table) do
			local view = view_table[i]
			if view.Ident == nx_string("1") then
				local view_obj_table = view:GetViewObjList()
				for k = 1, table.getn(view_obj_table) do
					local view_obj = view_obj_table[k]
					if view_obj:QueryProp("EquipType") == "Weapon" then
						local row = view_obj:GetRecordRows("PropModifyPackRec")
						local newdamage = 0
						local newcp = 0
						if row > 0 then
							for k = 0, row - 1 do
								local damage = view_obj:QueryRecord("PropModifyPackRec", k, 0)
								if nx_number(damage) > 13033 and nx_number(damage) < 13900 then
									if nx_number(damage) > 13224 then
										-- cong pha
										newcp = newcp + (nx_number(damage) - 13224)
									else
										-- sat thuong vu khi
										newdamage = newdamage + (nx_number(damage) - 13033)
									end
								end
							end
						end

						local skilldmg = 0
						local row = view_obj:GetRecordRows("SkillModifyPackRec")
						if row > 0 then
							for k = 0, row - 1 do
								local prop = view_obj:QueryRecord("SkillModifyPackRec", k, 0)
								local sec_index = ini:FindSectionIndex(nx_string(prop))
								local value = ""
								if sec_index >= 0 then
									value = ini:ReadString(sec_index, "r", nx_string(""))
								end
								local tuple = util_split_string(value, ",")
								if nx_string(tuple[1]) == nx_string(skill_prop) then
									skilldmg = skilldmg + 1
								end
							end
						end
						return newdamage, newcp, skilldmg
					end
				end
				break
			end
		end
	end
end
function getCurrentWeapon(ini,skill_type, skill)
local game_client = nx_value("game_client")
  if nx_is_valid(game_client) then
    local view_table = game_client:GetViewList()
    local skillDamage = 0
    local CPDamage = 0
    local STDamage = 0
    local binhthuName = ""

    for i = 1, table.getn(view_table) do
      local view = view_table[i]
      if view.Ident == nx_string("1") then
        local view_obj_table = view:GetViewObjList()
        for k = 1, table.getn(view_obj_table) do
          local view_obj = view_obj_table[k]
          if view_obj:QueryProp("EquipType") == "Weapon" or view_obj:QueryProp("EquipType") == "Wrist" then

            local row = view_obj:GetRecordRows("SkillModifyPackRec")
            if row > 0 then
              for k = 0, row - 1 do
                local prop = view_obj:QueryRecord("SkillModifyPackRec", k, 0)
                local sec_index = ini:FindSectionIndex(nx_string(prop))
                local value = ""
                if sec_index >= 0 then
                  value = ini:ReadString(sec_index, "r", nx_string(""))
                end
                local tuple = util_split_string(value, ",")
                if string.find(nx_string(skill), nx_string(tuple[1])) then
                  skillDamage = skillDamage + 1
                end
              end
            end

            local row2 = view_obj:GetRecordRows("PropModifyPackRec")
            if row2 > 0 then
              for x = 0, row2 - 1 do
                local damage = nx_number(view_obj:QueryRecord("PropModifyPackRec", x, 0))
                if damage > 13033 and damage < 13900 then
                  if nx_number(damage) > 13224 then
                    CPDamage = CPDamage + nx_number(view_obj:QueryProp("MaxMeleeDamage")) + damage - 13224
                  else
                    STDamage = STDamage + nx_number(view_obj:QueryProp("MaxMeleeDamage")) + damage - 13033
                  end
                end
              end
            end
          end

          if view_obj:QueryProp("EquipType") == "FacultyPaint" or view_obj:QueryProp("EquipType") == "FacultyBook" then
            local row = view_obj:GetRecordRows("SkillModifyPackRec")
            if row > 0 then
              for k = 0, row - 1 do
                local prop = view_obj:QueryRecord("SkillModifyPackRec", k, 0)
                local sec_index = ini:FindSectionIndex(nx_string(prop))
                local value = ""
                if sec_index >= 0 then
                  value = ini:ReadString(sec_index, "r", nx_string(""))
                end
                local tuple = util_split_string(value, ",")
                -- AutoSendMessage(nx_string(tuple[1]))
                binhthuName = nx_string(tuple[1])
              end
            else

              binhthuName = view_obj:QueryProp("ConfigID")
            end
          end
        end
        break
      end
    end

    return skillDamage, CPDamage, STDamage, binhthuName
  end
end

function LoadItemInBag()
  bagItem = {}
  local game_client = nx_value("game_client")
  if nx_is_valid(game_client) then
    local ini = get_ini_safe("share\\ModifyPack\\SkillPack.ini")
    local view_table = game_client:GetViewList()
    for i = 1, table.getn(view_table) do
      local view = view_table[i]
      if view.Ident == nx_string("121") then
        local view_obj_table = view:GetViewObjList()
        for k = 1, table.getn(view_obj_table) do
          local view_obj = view_obj_table[k]
          if view_obj:QueryProp("EquipType") == "Weapon" or view_obj:QueryProp("EquipType") == "Wrist" or view_obj:QueryProp("EquipType") == "FacultyPaint" or view_obj:QueryProp("EquipType") == "FacultyBook" then
            -- AutoSendMessage("Does this call")
            local itemID = nx_number(view_obj.Ident)
            local skillDamage = 0
            local skillProp = ""
            local CPDamage = 0
            local STDamage = 0
            local skillTable = {}
            local phyDef = 0
            local row = view_obj:GetRecordRows("SkillModifyPackRec")
            if row > 0 then
              for k = 0, row - 1 do
                local prop = view_obj:QueryRecord("SkillModifyPackRec", k, 0)
                local sec_index = ini:FindSectionIndex(nx_string(prop))
                local value = ""
                if sec_index >= 0 then
                  value = ini:ReadString(sec_index, "r", nx_string(""))
                end
                local tuple = util_split_string(value, ",")
                  table.insert(skillTable, nx_string(tuple[1]))
              end
            end

            if view_obj:QueryProp("EquipType") == "Weapon" then
              local row2 = view_obj:GetRecordRows("PropModifyPackRec")
              if row2 > 0 then
                for x = 0, row2 - 1 do
                  local damage = nx_number(view_obj:QueryRecord("PropModifyPackRec", x, 0))
                  if damage > 13033 and damage < 13900 then
                    if nx_number(damage) > 13224 then
                      CPDamage = CPDamage + nx_number(view_obj:QueryProp("MaxMeleeDamage")) + damage - 13224
                    else
                      STDamage = STDamage + nx_number(view_obj:QueryProp("MaxMeleeDamage")) + damage - 13033
                    end
                  end
                end
              end
            end

            if view_obj:QueryProp("EquipType") == "Wrist" then
              phyDef = nx_number(view_obj:QueryProp("PhyDef"))
            end



            if itemID > 42 then itemID = itemID - 12 end

            table.insert(bagItem, {
              ItemType = nx_number(view_obj:QueryProp("ItemType")),
              ItemEquipType = view_obj:QueryProp("EquipType"),
              ItemID = itemID,
              Skill = skillTable,
              CongPha = CPDamage,
              SatThuong = STDamage,
              PhysicDef = phyDef,
              ConfigID = view_obj:QueryProp("ConfigID")
            })
          end
        end
        break
      end
    end

  end
end

function SwapTrangBi(ini,skill)
  local LimitIndex = nx_execute("tips_data", "get_ini_prop", "share\\Skill\\skill_new.ini", skill, "UseLimit", "")
  if LimitIndex == nil then
    return
  end
  local skill_query = nx_value("SkillQuery")
  if not nx_is_valid(skill_query) then
    return
  end
  local ItemType = skill_query:GetSkillWeaponType(nx_int(LimitIndex))
  if ItemType == nil then
    return
  end
  local player = yBreaker_get_player()
  local needWeapon, needWrist, needBinhThu = nil, nil, nil
  local curSkillDamage, curCPDamage, curSTDamage, binhthuName = getCurrentWeapon(ini,ItemType, skill)
  local tongDamage = curCPDamage + curSTDamage
  local phyDef = 0

  for i=1,table.getn(bagItem) do
    if phyDef == 0 then phyDef = 0 end
    local skillDamage = 0
    if ItemType == 0 then
      -- if bagItem[i]["ItemEquipType"] == "Weapon" then
      --   local itemDamage = bagItem[i]["CongPha"] + bagItem[i]["SatThuong"]
      --   if itemDamage > tongDamage then
      --     needWeapon = bagItem[i]["ItemID"]
      --   end
      -- end
      if bagItem[i]["ItemEquipType"] == "Wrist" or bagItem[i]["ItemEquipType"] == "Weapon" then
        if table.getn(bagItem[i]["Skill"]) >= 1 then
          for key,value in pairs(bagItem[i]["Skill"]) do
            if string.find(nx_string(skill), nx_string(value)) then
              skillDamage = skillDamage + 1
            end
          end
        end

        if skillDamage > 0 and skillDamage > curSkillDamage then
          curSkillDamage = skillDamage
          needWrist = bagItem[i]["ItemID"]
        end
      end
    else
      if bagItem[i]["ItemEquipType"] == "Wrist" then
        if table.getn(bagItem[i]["Skill"]) <= 0 then

          if bagItem[i]["PhysicDef"] >= phyDef then

            phyDef = bagItem[i]["PhysicDef"]
            needWrist = bagItem[i]["ItemID"]

          end
        end
      end

      if nx_number(ItemType) == nx_number(bagItem[i]["ItemType"]) then
        if table.getn(bagItem[i]["Skill"]) >= 1 then
          for key,value in pairs(bagItem[i]["Skill"]) do
            if string.find(nx_string(skill), nx_string(value)) then
              skillDamage = skillDamage + 1
            end
          end
        end

        if nx_number(skillDamage) > 0  then
          if nx_number(skillDamage) > nx_number(curSkillDamage) then
            curSkillDamage = nx_number(skillDamage)
            needWeapon = bagItem[i]["ItemID"]
          end
        else
          if nx_number(curSkillDamage) <= 0 then
            local itemDamage = bagItem[i]["CongPha"] + bagItem[i]["SatThuong"]
            if nx_number(itemDamage) > nx_number(tongDamage) then
              tongDamage = itemDamage
              needWeapon = bagItem[i]["ItemID"]
            end
          end
        end
      end
    end

    if bagItem[i]["ItemEquipType"] == "FacultyPaint" or bagItem[i]["ItemEquipType"] == "FacultyBook" then
      if player:QueryProp("HPRatio") < 50 then
        if not nx_function("find_buffer", player, "buf_zs_hs_5_1_01") then
          if bagItem[i]["ConfigID"] == "zs_hs_5_1" then
            needBinhThu = bagItem[i]["ItemID"]
          end
        else
          if table.getn(bagItem[i]["Skill"]) >= 1 then
            for key,value in pairs(bagItem[i]["Skill"]) do
              if string.find(nx_string(skill), nx_string(value)) then
                needBinhThu = bagItem[i]["ItemID"]
              end
            end
          end
        end
      else
        if table.getn(bagItem[i]["Skill"]) >= 1 then
          for key,value in pairs(bagItem[i]["Skill"]) do
            if string.find(nx_string(skill), nx_string(value)) then
              needBinhThu = bagItem[i]["ItemID"]
            end
          end
        end
      end
    end

  end
  local form = util_get_form("form_stage_main\\form_bag")
  if nx_is_valid(form) then
    if needWeapon ~= nil then
      nx_execute("form_stage_main\\form_bag_func", "on_bag_right_click", form.imagegrid_equip, nx_number(needWeapon) - 1)
    end
    if needWrist ~= nil then
      nx_execute("form_stage_main\\form_bag_func", "on_bag_right_click", form.imagegrid_equip, nx_number(needWrist) - 1)
    else
      if curSkillDamage <= 0 then
        for i=1,table.getn(bagItem) do
          if bagItem[i]["ItemEquipType"] == "Wrist" then
            if table.getn(bagItem[i]["Skill"]) <= 0 then
              if bagItem[i]["PhysicDef"] >= phyDef then
                nx_execute("form_stage_main\\form_bag_func", "on_bag_right_click", form.imagegrid_equip, nx_number(bagItem[i]["ItemID"]) - 1)
              end
            end
          end
        end
      end
    end
    if needBinhThu ~= nil then
      nx_execute("form_stage_main\\form_bag_func", "on_bag_right_click", form.imagegrid_equip, nx_number(needBinhThu) - 1)
    end
  end
 
end

function EquipItemProp(form, ini, skill_prop, active)
	if nx_is_valid(form) then
		if nx_is_valid(ini) then
			local item = nx_null()
			local binhthu = nil
			local item_tru = nil
			local item_cp = nil
			local game_client = nx_value("game_client")
			local client_player = game_client:GetPlayer()

			local LimitIndex = nx_execute("tips_data", "get_ini_prop", "share\\Skill\\skill_new.ini", skill_prop, "UseLimit", "")
			if LimitIndex == nil then
				return
			end
			local skill_query = nx_value("SkillQuery")
			if not nx_is_valid(skill_query) then
				return
			end
			local ItemType = skill_query:GetSkillWeaponType(nx_int(LimitIndex))
			if ItemType == nil then
				return
			end

			local item_trudmg, item_cpdmg, skilldamage = getCurWeapon(ini, skill_prop)

			if nx_is_valid(client_player) then

				local scene = game_client:GetScene()
				local view_table = game_client:GetViewList()
				for i = 1, table.getn(view_table) do
					local view = view_table[i]
					if view.Ident == nx_string("121") then
						local view_obj_table = view:GetViewObjList()
						for k = 1, table.getn(view_obj_table) do
							local view_obj = view_obj_table[k]

							if ItemType == nx_number(0) or nx_number(view_obj:QueryProp("ItemType")) == nx_number(ItemType) then

								local skilldmg = 0
								local row = view_obj:GetRecordRows("SkillModifyPackRec")
								if row > 0 then
									for k = 0, row - 1 do
										local prop = view_obj:QueryRecord("SkillModifyPackRec", k, 0)
										local sec_index = ini:FindSectionIndex(nx_string(prop))
										local value = ""
										if sec_index >= 0 then
											value = ini:ReadString(sec_index, "r", nx_string(""))
										end
										local tuple = util_split_string(value, ",")
										if nx_string(tuple[1]) == nx_string(skill_prop) then
											skilldmg = skilldmg + 1
										end
									end
								end
								if nx_number(skilldamage) < nx_number(skilldmg) then
									item = view_obj
									skilldamage = skilldmg
								end

								
							end

							if active ~= nil and nx_number(view_obj:QueryProp("ItemType")) == nx_number(191) then
								
								local row = view_obj:GetRecordRows("SkillModifyPackRec")
								if row > 0 then
									local prop = view_obj:QueryRecord("SkillModifyPackRec", 0, 0)
									local sec_index = ini:FindSectionIndex(nx_string(prop))
									local value = ""
									if sec_index >= 0 then
										value = ini:ReadString(sec_index, "r", nx_string(""))
									end
									local tuple = util_split_string(value, ",")
									if nx_string(tuple[1]) == nx_string(skill_prop) then
										binhthu = view_obj
										
									end
								end
							end

						end
						break
					end
				end

				if nx_is_valid(item) then
					local name = nx_function("ext_widestr_to_utf8", util_text(item:QueryProp("ConfigID")))
					nx_execute("form_stage_main\\form_bag_func", "on_bag_right_click", form.imagegrid_equip, nx_number(item.Ident) - 1)
					
				end

				if nx_is_valid(binhthu) then
					
					nx_execute("form_stage_main\\form_bag_func", "on_bag_right_click", form.imagegrid_equip, nx_number(binhthu.Ident) - 1)
				end
			end
		end
	end
end
function get_ini_value(ini_path, section, key, defaut)
  local ini = get_ini(ini_path, true)
  if not nx_is_valid(ini) then
    return defaut
  end
  local index = ini:FindSectionIndex(section)
  if index < 0 then
    return defaut
  end
  return ini:ReadString(index, key, defaut)
end

function checkSkill(skillId, object, type)
	local gui = nx_value("gui")
	local skill_query = nx_value("SkillQuery")
	local skill_type = skill_query:GetSkillType(skillId)
	local effecttype = skill_static_query_by_id(skillId, "EffectType")
	local target_type = skill_static_query_by_id(skillId, "TargetType")
	local var_pkg = skill_static_query_by_id(skillId, "MinVarPropNo")
	local t1, t2, h1, h2 = nil, nil, nil, nil
	local varprop_paht = "share\\Skill\\skill_lock_varprop.ini"
	if nx_number(skill_type) == 1 then
		varprop_paht = "share\\Skill\\skill_normal_varprop.ini"
	end
	local hit_shape_pak = nx_int(get_ini_value(varprop_paht, nx_string(var_pkg), "HitShapePkg", "-1"))
	local target_shape_pak = nx_int(get_ini_value(varprop_paht, nx_string(var_pkg), "TargetShapePkg", "-1"))
	local data_query = nx_value("data_query_manager")
	if not nx_is_valid(data_query) then
		return
	end
	local hit_shape = data_query:Query(5, nx_number(hit_shape_pak), "HitShapePara2")
	local target_shape = data_query:Query(4, nx_number(target_shape_pak), "TargetShapePara2")


	if type ~= nil then
		if nx_int(target_type) == nx_int(2) then
			return false
		else
			return true
		end
	else

		if nx_int(effecttype) == nx_int(2) then
			return true
		end
	end

	return false
end
function auto_swap_binhthu()

end
