require('auto_new\\autocack')
if not load_spec then
	auto_cack('0')
	auto_cack('2')
	auto_cack('6')
	auto_cack('14')
	load_spec = true
end
function iniStringSelect(inifile,type,method,name)
	local game_config = nx_value("game_config")
    local account = game_config.login_account
	local game_client = nx_value('game_client')	
	local client_player = game_client:GetPlayer()	
	local game_config = nx_value('game_config')
	local account = game_config.login_account
	local server_ID = game_config.server_id
	local dir = nx_function('ext_get_current_exe_path') .. 'nockasdd_'.. account..'_'..nx_string(server_ID) 
    local ini = nx_create("IniDocument")
	if not nx_is_valid(ini) then
        return
    end
	ini.FileName = dir .. "\\autotarget\\"..nx_string(inifile)..'.ini' 	
    local skill = {}
	local skillini = ""
	if ini:LoadFromFile() then	
		if method == "String"then
			skillini = ini:ReadString(nx_string(type), nx_string(name), "")
		end
		if method == "Int" then
			skillini = nx_number(ini:ReadInteger(nx_string(type), nx_string(name), ""))
		end
		if skillini ~= "" then
			table.insert(skill, skillini)					
		end
	end
	return skill
end
function getIniSetting(inifile,method,tree_1,tree_2,tree_3)
	local game_config = nx_value("game_config")
    local account = game_config.login_account
	local game_client = nx_value('game_client')	
	local client_player = game_client:GetPlayer()	
	local game_config = nx_value('game_config')
	local account = game_config.login_account
	local server_ID = game_config.server_id
	local dir = nx_function('ext_get_current_exe_path') .. 'nockasdd_'.. account..'_'..nx_string(server_ID) 
    local ini = nx_create("IniDocument")
	if not nx_is_valid(ini) then
        return
    end
	ini.FileName = dir .. "\\autotarget\\"..nx_string(inifile)..'.ini'   
	if not ini:LoadFromFile() then
		return false
	end
	local data = nil
	if method == 'String' then
		data = ini:ReadString(tree_1, tree_2, tree_3)
	end
	if method == 'Int' then
		data = nx_number(ini:ReadInteger(tree_1, tree_2, tree_3))
	end
	nx_destroy(ini)
	return data
end
