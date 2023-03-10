require('auto_new\\autocack')

local THIS_FORM = 'auto_new\\form_auto_update'
inifile = nil
listsrc = ''
array_list_src = nil
function main_form_init(form)
	form.Fixed = false
	form.skillid = ""	
end

	
function on_main_form_open(form)
	auto_update_version()
	loadGridChat(form)
	local inifile = add_file_user('auto_ai')
	local show_update = wstrToUtf8(readIni(inifile,'Setting','not_show_update',''))
	if show_update == nx_string('true') then
		form.cb_not_show_later.Checked = true		
	else
		form.cb_not_show_later.Checked = false
	end
end 
function on_cb_not_show_later(self)
	local form = self.ParentForm
	local inifile = add_file_user('auto_ai')
	if self.Checked then
		writeIni(inifile,'Setting','not_show_update','true')
	else
		writeIni(inifile,'Setting','not_show_update','false')
	end
end 

auto_update_version = function()	
	local str = "https://autocack.net/config/update.txt"
	nx_set_value("nockasdd_autocack_url", str)
	local url = nx_value("nockasdd_autocack_url")
	local httpclient = nx_create("GenericHTTPClient")
	if nil ~= url and "" ~= url and nx_is_valid(httpclient) then
		httpclient:Request(url, 1, "MERONG(0.9/;p)")
		nx_set_value("nockasdd_autocack_url", nil)
	end
	local content = httpclient:QueryHTTPResponse()
	local file = add_file_res('update')
	local f = assert(io.open(file, 'wb')) -- open in "binary" mode
	f:write(content)
	f:close()
end	
function getSectionName(inifile,index)	
    local ini = nx_create("IniDocument")
	if not nx_is_valid(ini) then
        return
    end
	local set = {}
	ini.FileName = inifile
	if ini:LoadFromFile() then
		local sect_list = ini:GetSectionList()
		if #sect_list >= 1 then
			for k, v in pairs(sect_list) do
				if nx_number(k) == nx_number(index) then
					table.insert(set,v)
					return set
				end
			end
		end
	end
end

function on_btn_close_click(form)   
  local form = nx_value("auto_new\\form_auto_update")
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
function on_main_form_close(form)	
	nx_destroy(form)
end


FORM_MAP_SCENE= 'form_stage_main\\form_map\\form_map_scene'
function removeSection(inifile,section, item)	 
    local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then
        return
    end
	ini.FileName = nx_string(inifile) 
	if ini:LoadFromFile() then
		if ini:FindSection(section) then
			ini:DeleteItem(section,item)
			ini:SaveToFile()
			nx_destroy(ini)
		end
	end
end


function removeEmptyItems(input) 
	for i = #input, 1, -1 do 
		if input[i] == nil or input[i] == '' then 
			table.remove(input, i) 
		end 
	end 
	return input
end  
function auto_split_string(input, splitChar) 
	local t = util_split_string(input, splitChar) 
	return removeEmptyItems(t) 
end  

function loadGridChat(form)
	local gui = nx_value("gui")	
	local funcname = ""	
	local func_name = ""
	local func_hand = ""	
	local inifile = add_file_res('update')
	local countini = nx_execute('auto_new\\autocack','sectionCount',inifile)
	local mltbox_list = form.mltbox_list
	mltbox_list:Clear()
	form.lbl_2.Text = nx_widestr(nx_string(nx_execute('auto_new\\autocack','get_version_auto')))
	if countini > 0 then
		for j = 1, countini do
			funcname = getSectionName(inifile,j)					
			for i = 1, table.getn(funcname) do
				local update_info = wstrToUtf8(readIni(inifile,funcname[i],'info',''))
				local auto_update = auto_split_string(update_info,';')
				if nx_is_valid(mltbox_list) then
					local text_title = gui.TextManager:GetFormatText(nx_string('<font font-size=\"20px\" color=\"#ffff26\">[ {@0:text} ]</font>'), utf8ToWstr(funcname[i]))
					mltbox_list:AddHtmlText(text_title, -1)
					add_to_log(mltbox_list,auto_update)
				end					
			end			
		end		
	end	
end
function add_to_log(mltbox_list,auto_update)
	local gui = nx_value("gui")
	for j =1,table.getn(auto_update) do												
		text_title = gui.TextManager:GetFormatText(nx_string('<font color=\"#cfffbf\"> 	 - {@0:text}</font>'), utf8ToWstr(auto_update[j]))						
		mltbox_list:AddHtmlText(text_title, -1)	
	end	
end

function gridAndFunc(grid,info)
	local form = nx_value(THIS_FORM)
	for i =1,table.getn(info) do	
			
		local info_update = 'Update '..nx_string(i)..' :'..info[i]
		local row = grid:InsertRow(-1)
		grid:SetGridText(row, 1, utf8ToWstr(info_update))
	end	
end
function create_multitext()
  local gui = nx_value('gui')
  if not nx_is_valid(gui) then
    return
  end
  local multitextbox = gui:Create('MultiTextBox')
  if not nx_is_valid(multitextbox) then
    return
  end
    multitextbox.DrawMode = 'Expand'
	multitextbox.LineColor = '0,0,0,0'
	multitextbox.Solid = false
	multitextbox.AutoSize = false
	multitextbox.Font = 'font_text'
	multitextbox.LineTextAlign = 'Center'	
	multitextbox.SelectBarColor = '0,0,0,0'
	multitextbox.MouseInBarColor = '0,0,0,0'
	multitextbox.BackColor = '0,255,255,255'
	multitextbox.ViewRect = '0,0,270,50'
	multitextbox.Width = 260
	multitextbox.Height = multitextbox:GetContentHeight() + 2
	multitextbox.Left = 10
	multitextbox.Top = 0
  return multitextbox
end
-- function loadGridAutoSkill(form)
	-- local gui = nx_value("gui")
	-- local grid = form.textgrid_pos	
	-- grid:ClearRow()
	-- grid:ClearSelect()
	-- local ini = nx_create("IniDocument")
	-- if not nx_is_valid(ini) then
        -- return
    -- end
	-- local file = add_file('auto_tt')
	-- ini.FileName = file
	-- local inifile = add_file_user('auto_ai')	
	-- local active = wstrToUtf8(readIni(inifile,AUTO_CROP,'active',''))
	-- if ini:LoadFromFile() then	
		-- if ini:FindSection(active) then		
			-- local pos_table = nx_string(readIni(file,nx_string(active),'pos',''))			
			-- local count_pos = auto_split_string(nx_string(pos_table),'|')
			-- listsrc = pos_table
			-- array_list_src = count_pos
			-- if nx_number(table.getn(count_pos)) > 0 then
				-- for i = 1, table.getn(count_pos) do
					-- local split_item = auto_split_string(nx_string(count_pos[i]),';')
					-- local scene = split_item[1]
					-- local config_id = split_item[2]
					-- local pos = split_item[3]		
					-- local pos_split = auto_split_string(nx_string(pos),',')
					-- local x,y,z = nx_string(pos_split[1]),nx_string(pos_split[2]),nx_string(pos_split[3])
					-- if x ~= nil and config_id ~= nil then
						-- local btn_del = create_multitextbox(THIS_FORM, 'on_click_btn_del',auto_del,count_pos[i], 'HLStypebargaining')
						-- local btn_up = create_multitextbox(THIS_FORM, 'on_click_up',auto_up,nx_string(i), 'HLStypelaba')	
						-- local btn_down = create_multitextbox(THIS_FORM, 'on_click_down',auto_down,nx_string(i), 'HLStypelaba')	
						-- local multitextbox = create_multitextbox(THIS_FORM, 'on_click_hyper_move', wstrToUtf8(util_text(config_id)),nx_string(scene) .. ';' .. string.format('%.3f', x) .. ',' .. string.format('%.3f', y) .. ',' .. string.format('%.3f', z), 'HLChatItem1')		
						-- gridAndFunc(grid,multitextbox,btn_up,btn_down,btn_del)	
					-- end
				-- end
			-- end
		-- end		
	-- end
-- end
-- function gridAndFunc(grid,mTextName,btn_up,btn_down,btn_del)
	-- local form = nx_value(THIS_FORM)
	-- local row = grid:InsertRow(-1)
	-- grid:SetGridControl(row, 0, mTextName)
	-- grid:SetGridControl(row, 1, btn_up)
	-- grid:SetGridControl(row, 2, btn_down)
	-- grid:SetGridControl(row, 3, btn_del)		
-- end


create_multitextbox = function(script_name, call_back_func_name, text, data_source, style)
	local multitextbox = nx_value('gui'):Create('MultiTextBox')
	multitextbox.DrawMode = 'Expand'
	multitextbox.LineColor = '0,0,0,0'
	multitextbox.Solid = false
	multitextbox.AutoSize = false
	multitextbox.Font = 'font_text_title1'
	multitextbox.LineTextAlign = 'Center'	
	multitextbox.SelectBarColor = '0,0,0,0'
	multitextbox.MouseInBarColor = '0,0,0,0'
	multitextbox.BackColor = '0,255,255,255'
	multitextbox.ViewRect = '0,0,100,0'
	multitextbox.Width = 100	
	multitextbox.HtmlText = utf8ToWstr('<a style="'..nx_string(style)..'"> ' .. nx_string(text) .. '</a>') -- 
	multitextbox.Height = multitextbox:GetContentHeight() + 2
	multitextbox.Left = 10
	multitextbox.Top = 0		
	multitextbox.DataSource = nx_string(data_source)
	nx_bind_script(multitextbox, nx_string(script_name))
	nx_callback(multitextbox, 'on_click_hyperlink', nx_string(call_back_func_name))
	return multitextbox
end


