require('util_gui')
require("util_move")
require('define\\gamehand_type')
require('const_define')
require('auto_new\\autocack')
require('form_stage_main\\form_taosha\\taosha_util')
local THIS_FORM = 'auto_new\\form_auto_use_item'
FORM_SETTING = "auto_new\\form_auto_set_item_buff"
if not load_auto_use_item then
auto_cack('0')
auto_core()
auto_cack('8')
load_auto_use_item = true
end
function main_form_init(form)
	form.Fixed = false
	form.inifile = ""	
end
function on_main_form_open(form)
	-- local inifile = add_file_user('auto_pick')
	-- local pick_all = wstrToUtf8(readIni(inifile,nx_string(AUTO_ITEM),'pick_all',''))
	-- if pick_all == nx_string('true') then
		-- form.cbtn_pick_all.Checked = true
	-- end
	update_btn_onOff()
	loadGridChat(form)
end 
function on_btn_close_click(form)   
  local form = nx_value("auto_new\\form_auto_use_item")
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
function on_main_form_close(form)	
	nx_destroy(form)
end

function on_click_btn_del(btn)
	local form = btn.ParentForm
	local inifile = add_file('auto_item')
	removeSection(inifile,btn.func_ai)
	loadGridChat(form)
end
function cbtn_pick_all(btn)
	local form = btn.ParentForm
	local inifile = add_file_user('auto_ai')	 
	writeIni(inifile,nx_string(AUTO_ITEM),'pick_all',btn.Checked)
end
function btn_start_use(btn)
	local form = btn.ParentForm
	if nx_running(nx_current(),'auto_start_use_item') then
		nx_execute(nx_current(),'setItemState',false)
		nx_kill(nx_current(),'auto_start_use_item')
	else
		nx_execute(nx_current(),'setItemState',true)
		nx_execute(nx_current(),'auto_start_use_item')
	end
	update_btn_onOff()
end
update_btn_onOff = function()
	local form = nx_value(THIS_FORM)
	if nx_running(nx_current(),'auto_start_use_item') then
		form.btn_start_use.Text = nx_widestr('Stop')
	else
		form.btn_start_use.Text = nx_widestr('Start')
	end
end
function on_right_grid(self)
	local form = self.ParentForm
	if not nx_find_custom(self,'UniqueID') then nx_set_custom(self,'UniqueID','1') end
	local gui = nx_value('gui')
	local game_hand = gui.GameHand
	local para1 = game_hand.Para1
	local para2 = game_hand.Para2	
	local no_item = game_hand:IsEmpty() or game_hand.Type ~= "viewitem" or (para1 ~= "121" and para1 ~= "2" and para1 ~= "123" and para1 ~= "125")	
	if no_item then return nil end	
	local form_set = util_get_form(FORM_SETTING,true,false)
    local item = nx_execute('goods_grid', 'get_view_item', game_hand.Para1, game_hand.Para2)
	if nx_is_valid(item) then 	
		local str = nil	
		local item_config = item:QueryProp('ConfigID')
		local item_index =  para1
		form_set.item_config_id = item_config
		form_set.item_view_index = item_index
		if form_set.Visible then
			util_show_form(FORM_SETTING,false)
			nx_pause(0.1)
		end
		util_show_form(FORM_SETTING,true)	
	end 	
	game_hand:ClearHand()
end

function loadGridChat(form)
	local gui = nx_value("gui")
	local grid = form.textgrid_pos	
	local funcname = ""	
	local func_name = ""
	local func_hand = ""
	local func_type = ""
	local keyhtml = ""
	local inifile = add_file('auto_item')
	local countini = nx_execute('auto_new\\autocack','sectionCount',inifile)
	grid:ClearRow()
	grid:ClearSelect()
	if countini > 0 then
		for j = 1, countini do
			funcname = getSectionName(inifile,j)			
			for i = 1, table.getn(funcname) do
				local btn_del = create_button(funcname[i],i,"Del",'on_click_btn_del')
				local mTextName = create_multitext()				
				keyhtml = ' Vật Phẩm <a href="" style=\"HLStype1\"> ['..getUtf8Text(nx_string(funcname[i]))..']</a>' 					
				mTextName.HtmlText =  utf8ToWstr(keyhtml)
				gridAndFunc(grid,mTextName,btn_del)
			end
		end		
	end
end
function gridAndFunc(grid,mTextName,btn_del)
	local form = nx_value(THIS_FORM)
	local row = grid:InsertRow(-1)
	grid:SetGridControl(row, 0, mTextName)
	grid:SetGridControl(row, 1, btn_del)	
end

function btn_add_item(btn)
	nx_execute('auto_new\\autocack','util__auto_show_form','auto_new\\form_auto_set_item')	
end
function btn_pick_item(btn)
	util_auto_show_hide_form('auto_new\\form_auto_pick')	
end