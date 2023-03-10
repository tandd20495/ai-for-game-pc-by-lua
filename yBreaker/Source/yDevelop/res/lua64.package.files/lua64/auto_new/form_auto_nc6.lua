require('util_gui')
require("util_move")
require('define\\gamehand_type')
require('const_define')
require('auto_new\\autocack')
if not load_auto_nc6 then
	auto_cack('0')
	auto_cack('6')
	auto_cack('8')
	auto_cack('10')
	load_auto_nc6 = true
end
local THIS_FORM = 'auto_new\\form_auto_nc6'
function main_form_init(form)
  form.Fixed = false
end
function on_main_form_open(form)
  init_ui_content(form)
end

function init_ui_content(form)	
	updateBtnAuto(form)
	updateCheckedAuto(form)
end

function on_btn_close_click(form)
local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end	
	on_main_form_close(form)
end
function on_main_form_close(form)	
	nx_destroy(form)
end
function btn_start_nc6(btn)
	local form = btn.ParentForm
	if nx_execute(nx_current(),'getAutoNC6State') then
		nx_execute(nx_current(),'stopAutoAi')
	else
		nx_execute(nx_current(),'autoStartQuest')
	end
	updateBtnAuto(form)
end
updateCheckedAuto = function(form)
	local check_dd = getIni_Nc6('quest_nc6.ini','String','full_quest','DaoDai', '')
	local check_vp = getIni_Nc6('quest_nc6.ini','String','full_quest','VuPhong', '')
	local check_nt = getIni_Nc6('quest_nc6.ini','String','full_quest','NhanhTay', '')
	local check_hg = getIni_Nc6('quest_nc6.ini','String','full_quest','HoangGia', '')	
	if nx_string(check_dd) == 'true' then
		form.check_box_3.Checked = true
	end
	if nx_string(check_vp) == 'true' then
		form.check_box_1.Checked = true
	end
	if nx_string(check_nt) == 'true' then
		form.check_box_4.Checked = true
	end
	if nx_string(check_hg) == 'true' then
		form.check_box_2.Checked = true
	end
end
function btn_start_reset(btn)
	SaveSetting_nc6("quest_nc6.ini","Setting","String","DaoDai",'false')
	SaveSetting_nc6("quest_nc6.ini","Setting","String","Quest_Step",'1')
	SaveSetting_nc6("quest_nc6.ini","NhanhTay","String","Step",'1')
	SaveSetting_nc6("quest_nc6.ini","NhanhTay","String","complete",'false')
	SaveSetting_nc6("quest_nc6.ini","DaoDai","String","Step",'1')
	SaveSetting_nc6("quest_nc6.ini","DaoDai","String","complete",'false')
	SaveSetting_nc6("quest_nc6.ini","VuPhong","String","Step",'1')
	SaveSetting_nc6("quest_nc6.ini","VuPhong","String","complete",'false')
	SaveSetting_nc6("quest_nc6.ini","HoangGia","String","Step",'1')
	SaveSetting_nc6("quest_nc6.ini","HoangGia","String","complete",'false')
end
updateBtnAuto = function(form)
	if nx_execute(nx_current(),'getAutoNC6State') then
		form.btn_start_nc6.Text = nx_widestr('Stop')
	else
		form.btn_start_nc6.Text = nx_widestr('Start')
	end
end
function on_cbtn_auto_box_3(cbtn)	
	if cbtn.Checked then
		SaveSetting_nc6("quest_nc6.ini","full_quest","String","DaoDai","true")
		SaveSetting_nc6("quest_nc6.ini","DaoDai","String","Step_all","1")
	else
		SaveSetting_nc6("quest_nc6.ini","full_quest","String","DaoDai","false")
	end
end
function on_cbtn_auto_box_4(cbtn)	
	if cbtn.Checked then
		SaveSetting_nc6("quest_nc6.ini","full_quest","String","NhanhTay","true")
		SaveSetting_nc6("quest_nc6.ini","NhanhTay","String","Step_all","2")
	else
		SaveSetting_nc6("quest_nc6.ini","full_quest","String","NhanhTay","false")
	end
end
function on_cbtn_auto_box_1(cbtn)	
	if cbtn.Checked then
		SaveSetting_nc6("quest_nc6.ini","full_quest","String","VuPhong","true")
		SaveSetting_nc6("quest_nc6.ini","VuPhong","String","Step_all","3")
	else
		SaveSetting_nc6("quest_nc6.ini","full_quest","String","VuPhong","false")
	end
end
function on_cbtn_auto_box_2(cbtn)	
	if cbtn.Checked then
		SaveSetting_nc6("quest_nc6.ini","full_quest","String","HoangGia","true")
		SaveSetting_nc6("quest_nc6.ini","HoangGia","String","Step_all","4")
	else
		SaveSetting_nc6("quest_nc6.ini","full_quest","String","HoangGia","false")
	end
end





checkStepAuto = function(section,step)
	if nx_number(getIni_Nc6('quest_nc6.ini','String',section,'Step', '')) == step then
		return true
	end
	return false
end
saveStepAuto = function(section,value,step)
	SaveSetting_nc6('quest_nc6.ini',section,'String',value,step)
end
function AutoExecMenu(title, name, pos)
  local form = util_get_form(FORM_TALK)
    if not nx_is_valid(form) or not form.Visible then
        return 0
    end
    local form_main_chat_logic = nx_value('form_main_chat')
    if not nx_is_valid(form_main_chat_logic) then
      return 0
    end
    local form_title = nx_ws_lower(form_main_chat_logic:DeleteHtml(form.mltbox_title.HtmlText))
    local check_title = nx_ws_lower(nx_widestr(util_text('menu_title_sale_faild_job_error')))
    if nx_function('ext_ws_find', form_title, check_title) ~= -1 then
      local game_visual = nx_value('game_visual')
      if not nx_is_valid(game_visual) then        
        return false
      end
      local visual_player = game_visual:GetPlayer()
      local player_pos_x = visual_player.PositionX
      local player_pos_y = visual_player.PositionY
      local player_pos_z = visual_player.PositionZ
      local point, dist = nx_execute(nx_current(), 'FindNearPoint', player_pos_x, player_pos_y, player_pos_z)
      local data = nx_execute(nx_current(), 'AutoAbductData', nx_value('form_stage_main\\form_map\\form_map_scene').current_map)
      current_point, dist = nx_execute(nx_current(), 'FindNearPoint', player_pos_x, player_pos_y, player_pos_z, point)
      nx_execute(nx_current(), 'AutoSetCurrent', current_point)
      AutoMove(data.pos[current_point].x,data.pos[current_point].y,data.pos[current_point].z,data.pos[current_point].o)
      nx_execute(FORM_TALK, 'menu_select', form.mltbox_menu:GetItemKeyByIndex(0))
      return 
    else
      check_title = nx_ws_lower(nx_widestr(util_text('menu_title_sale_faild_cd_error')))
      if nx_function('ext_ws_find', form_title, check_title) ~= -1 then
        nx_execute(FORM_TALK, 'menu_select', form.mltbox_menu:GetItemKeyByIndex(0))
        return 
      end
    end

    if title ~= nil then
        title = nx_ws_lower(nx_widestr(util_text(title)))
        if nx_function('ext_ws_find', form_title, title) == -1 then
            return
        end
    end
    if pos ~= nil then
      nx_execute(FORM_TALK, 'menu_select', form.mltbox_menu:GetItemKeyByIndex(pos))
    else
      local found_menu = false
      local menu_table = util_split_wstring(nx_widestr(form.menus), nx_widestr('|'))
      local menu_num1 = table.getn(menu_table)
      if menu_num1 > 4 and not found_menu then
          menu_num1 = round((menu_num1 - 0.1) / 4)
          for k = 0, menu_num1 do
              local menu = form.mltbox_menu
              local temp_menu = {}
              local menu_num = menu.ItemCount
              if nx_int(menu_num) > nx_int(0) and menu.Visible then
                  for i = 0, menu_num - 1 do
                      if found_menu then break end
                      local htmltext = menu:GetItemTextNoHtml(i)
                      htmltext = nx_ws_lower(form_main_chat_logic:DeleteHtml(htmltext))
                      htmltext2 = nx_ws_lower(nx_widestr(util_text(name)))
                      if nx_function('ext_ws_find', htmltext, htmltext2) ~= -1 then
                        found_menu = true
                          nx_execute(FORM_TALK, 'menu_select', form.mltbox_menu:GetItemKeyByIndex(i))
                          break
                      end
                  end
              end
              if not found_menu then
                  form.menu_page = k + 1
                  nx_execute(FORM_TALK, 'update_menu_control', form, form.menus)
              else
                  break
              end
          end
      else
          local menu = form.mltbox_menu
          local temp_menu = {}
          local menu_num = menu.ItemCount
          if nx_int(menu_num) > nx_int(0) and menu.Visible then
              for i = 0, menu_num - 1 do
                  if found_menu then break end
                  local htmltext = menu:GetItemTextNoHtml(i)
                  htmltext = form_main_chat_logic:DeleteHtml(htmltext)
                  if nx_function('ext_ws_find', htmltext, nx_widestr(util_text(name))) ~= -1 then
                    found_menu = true
                      nx_execute(FORM_TALK, 'menu_select', form.mltbox_menu:GetItemKeyByIndex(i))
                      break
                  end
              end
          end
      end
  end
end