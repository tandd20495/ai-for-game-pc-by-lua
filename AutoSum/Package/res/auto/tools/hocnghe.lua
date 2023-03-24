local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\multiple.lua"))
multiple = file()
local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\thanhanh.lua"))
file()

local lac_duong_map = "city04"

function ___hoc_nghe_isStarted()
	return auto_hoc_nghe_bool
end


function _auto_hoc_nghe()
  local ok = false
  while ___hoc_nghe_isStarted() do
    nx_pause(0)
    if not nx_value("loading") and nx_value("form_stage_main\\form_map\\form_map_scene") ~= nil then
      local map = LayMapHienTai()
      if getNpcById("npc_6n_cc_sxsl_006") == nil and not ok then
        mo_than_hanh()
        thanhanh_to_hp_by_id("HomePointcity04A")
        ok = true
        nx_pause(10)
      elseif map == lac_duong_map and not nx_value("loading") then
        if not da_hoc_nghe("sh_cs") then -- tru su
          local tru_su = "JobLuoY011"
          local pos = get_npc_pos(lac_duong_map, tru_su)
          if not arrived(pos, 3) then
            thanhanh_bay_ben(pos, 50, ___hoc_nghe_isStarted)
          end
          if getNpcById(tru_su) ~= nil then
            talk(tru_su, {0,0,0}, ___hoc_nghe_isStarted)
          end
        elseif da_hoc_nghe("sh_cs") and not da_hoc_thuc_don("hc_0301030") then -- tru su, mang xa`o ruou.
          local tru_su = "JobLuoY011"
          local pos = get_npc_pos(lac_duong_map, tru_su)
          if not arrived(pos, 3) then
            thanhanh_bay_ben(pos, 50, ___hoc_nghe_isStarted)
          end
          if getNpcById(tru_su) ~= nil then
            local tru_su = "JobLuoY011"
            talk_id(tru_su, {805000000}, ___hoc_nghe_isStarted)
            local form = util_get_form("form_stage_main\\form_shop\\form_shop", true)
            if nx_is_valid(form) then
              nx_execute("custom_sender", "custom_buy_item", form.shopid, 1, 10, 1)
              local book = "hcitem_0301030"
              while ___hoc_nghe_isStarted() and not has_item(book, 2) do
                nx_pause(1)
              end
              if nx_is_valid(form) then
                nx_destroy(form)
              end
              study_book(book)
            end
          end
        -- elseif not da_hoc_nghe("sh_ds") then -- doc su
        --   local doc_su = "JobLuoY010"
        --   local pos = get_npc_pos(lac_duong_map, doc_su)
        --   if not arrived(pos, 3) then
        --     thanhanh_bay_ben(pos, 50, ___hoc_nghe_isStarted)
        --   end
        --   if getNpcById(doc_su) ~= nil then
        --     talk(doc_su, {0,0,0}, ___hoc_nghe_isStarted)
        --   end
        elseif not da_hoc_nghe("sh_nf") then -- nong phu
          local nong_phu = "JobLuoY005"
          local pos = get_npc_pos(lac_duong_map, nong_phu)
          if not arrived(pos, 3) then
            thanhanh_bay_ben(pos, 45, ___hoc_nghe_isStarted)
          end
          if getNpcById(nong_phu) ~= nil then
            talk(nong_phu, {0,0,0}, ___hoc_nghe_isStarted)
          end
        else
          break
        end
      end
    end
  end
end

if not ___hoc_nghe_isStarted() then
  auto_hoc_nghe_bool = true
  local file = assert(loadfile(nx_resource_path() .. "auto\\accounts\\qtd.lua"))
  local accounts = file()
  accounts = table.slice(accounts, 145, 200)
  --accounts = table.slice(accounts, 103, 142)
  add_chat_info("bat dau hoc nghe", 3)
  function run()
    _auto_hoc_nghe()
  end
  --run()
  multiple(run, accounts, ___hoc_nghe_isStarted)
  auto_hoc_nghe_bool = false
  add_chat_info("hoc nghe xong", 3)
else 
  auto_hoc_nghe_bool = false
  add_chat_info("dung hoc nghe",3)
end