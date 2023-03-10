require('util_gui')
require("util_move")
require('define\\gamehand_type')
require('const_define')
require('auto_new\\autocack')
if not load_auto_stall then
auto_cack('0')
auto_cack('2')
auto_cack('12')
load_auto_stall = true
end
local THIS_FORM = 'auto_new\\form_auto_stall'
function main_form_init(form)
  form.Fixed = false
  
end
FORM_STALL_MAIN = 'form_stage_main\\form_stall\\form_stall_main'
local load_maps_shop = {
	'Thành Đô',
	'Tô Châu'
}
function loadMap(mapName)	
	if mapName == utf8ToWstr('Thành Đô') then
		mapID = 'city05'
		homepoint = 'HomePointcity05B'			
		x,y,z = 805.057,23.034,583.881
	elseif	mapName == utf8ToWstr('Tô Châu') then
		mapID = 'city02'
		homepoint = 'HomePointcity02E'
		x,y,z = 525.327,5.300,399.262
	end
	return mapID,homepoint,x,y,z 
end
function init_ui_content(form)	
	local combobox = form.cbx_shop_map	
	if combobox.DroppedDown then
		combobox.DroppedDown = false
	end
  for i = 1, table.getn(load_maps_shop)do
		form.cbx_shop_map.DropListBox:AddString(utf8ToWstr(load_maps_shop[i]))
  end  
  combobox.Text = utf8ToWstr(load_maps_shop[1])	
	local game_client = nx_value("game_client")  
	local client_role = game_client:GetPlayer()
	local name = client_role:QueryProp("StallName")
	if nx_string(name) == '0' or name == nil then
		name = 'Auto Cack'
	end
	form.edt_name_stall.Text = nx_widestr(name)	
	updateBtn(form)	
end
function on_main_form_open(form)
  init_ui_content(form)
end


function on_cbx_map_selected(cbx)
	local form = cbx.ParentForm

end


function updateBtn(form)	
	if not nx_is_valid(form) then		
		return
	end
	if nx_running(nx_current(),'auto_stall') then
		form.btn_auto_stall.Text = nx_widestr("Stop")
	else
		form.btn_auto_stall.Text = nx_widestr("Start")
	end
end

function btn_auto_stall(btn)
	local form = btn.ParentForm
	local current = "auto_stall"
	local game_visual = nx_value("game_visual")
	if nx_running(nx_current(),current) then	
		runAutoStall = false
		nx_execute(nx_current(),'setAutoStallState',runAutoStall)
		nx_kill(nx_current(),current)
		game_visual:CustomSend(nx_int(656))
	else
		runAutoStall = true
		nx_execute(nx_current(),'setAutoStallState',runAutoStall)
		nx_execute(nx_current(),current)		
	end		
	updateBtn(form)
end
function btn_auto_set(btn)
	nx_execute(nx_current(),'add_stall_item_buy')
	nx_pause(2)
	nx_execute(nx_current(),'add_stall_item_sell')
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