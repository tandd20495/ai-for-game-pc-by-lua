require("util_gui")
require("util_move") -- Xac dinh toa do distance3d
require("share\\chat_define")
require("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs")
require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")
require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_lib_moving")
require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_util")

local THIS_FORM = "admin_yBreaker\\yBreaker_form_scan_other"

function on_form_main_init(form)
	form.Fixed = false
	form.is_minimize = false

end
function on_main_form_open(form)
	change_form_size()
	form.edt_player.Text = IniReadUserConfig("Scan_Player", "PlayerList", nx_widestr(""))
	form.edt_guild.Text = IniReadUserConfig("Scan_Guild", "GuildList", nx_widestr(""))
	form.edt_buff.Text = IniReadUserConfig("Scan_Buff", "BuffList", nx_widestr(""))
	form.lbl_title.Text = ""
	form.chk_buff.Text = "buf_fan;buf_jzsj_040" -- Buff bị hải bố và buff tìm cây
	form.chk_player.Checked = true
	form.chk_guild.Checked = false
	form.chk_buff.Checked = false
end
function on_main_form_close(form)
	nx_destroy(form)
end
function on_btn_close_click(btn)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end

function change_form_size()
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	local gui = nx_value("gui")
	form.Left = 1323
	form.Top = 855
	--form.Top = (gui.Height - form.Height) / 2
end

function show_hide_form_scan_other()
	util_auto_show_hide_form(THIS_FORM)
	util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_boombuff")
end

-- Add player
function on_btn_add_name_click(btn)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	local client = nx_value("game_client")
	if not nx_is_valid(client) then
		return
	end
	local player = client:GetPlayer()
	if not nx_is_valid(player) then
		return
	end
	local obj = client:GetSceneObj(nx_string(player:QueryProp("LastObject")))
	
	local crtTxt = form.edt_player.Text
	if nx_is_valid(obj) then
		local tmp = obj:QueryProp("Name")
		
		local l = util_split_wstring(crtTxt, ";")
		for i = 1, #l do
			-- Kiểm tra trùng tên
			if l[i] == tmp then
				yBreaker_show_Utf8Text("Tên nhân vật trùng!")
				return
			end
		end
		if crtTxt ~= nx_widestr("") then
			crtTxt = crtTxt .. nx_widestr(";")
		end
		form.edt_player.Text = crtTxt .. tmp
	end
	
	yBreaker_show_Utf8Text("Đã cập nhật danh sách nhân vật mới!")
	IniWriteUserConfig("Scan_Player", "PlayerList", form.edt_player.Text)
end

-- Add guild
function on_btn_add_guild_click(btn)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	local client = nx_value("game_client")
	if not nx_is_valid(client) then
		return
	end
	local player = client:GetPlayer()
	if not nx_is_valid(player) then
		return
	end
	local obj = client:GetSceneObj(nx_string(player:QueryProp("LastObject")))
	
	local crtTxt = form.edt_guild.Text
	if nx_is_valid(obj) then
		local tmp = obj:QueryProp("GuildName")
		
		local l = util_split_wstring(crtTxt, ";")
		for i = 1, #l do
			-- Kiểm tra trùng tên
			if l[i] == tmp then
				yBreaker_show_Utf8Text("Bang hội trùng!")
				return
			end
		end
		if crtTxt ~= nx_widestr("") then
			crtTxt = crtTxt .. nx_widestr(";")
		end
		form.edt_guild.Text = crtTxt .. tmp
	end
	
	yBreaker_show_Utf8Text("Đã cập nhật danh sách bang hội mới!")
	IniWriteUserConfig("Scan_Guild", "GuildList", form.edt_guild.Text)
end


-- Add buff
function on_btn_add_buff_click(btn)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	--local client = nx_value("game_client")
	--if not nx_is_valid(client) then
	--	return
	--end
	--local player = client:GetPlayer()
	--if not nx_is_valid(player) then
	--	return
	--end
	--local obj = client:GetSceneObj(nx_string(player:QueryProp("LastObject")))
	
	--local crtTxt = form.edt_buff.Text
	--if nx_is_valid(obj) then
	--	local tmp = obj:QueryProp("Name")
	--	
	--	local l = util_split_wstring(crtTxt, ";")
	--	for i = 1, #l do
	--		-- Kiểm tra trùng tên
	--		if l[i] == tmp then
	--			yBreaker_show_Utf8Text("Buff trùng!")
	--			return
	--		end
	--	end
	--	if crtTxt ~= nx_widestr("") then
	--		crtTxt = crtTxt .. nx_widestr(";")
	--	end
	--	form.edt_buff.Text = crtTxt .. tmp
	--end
	
	IniWriteUserConfig("Scan_Buff", "BuffList", form.edt_buff.Text)
	yBreaker_show_Utf8Text("Đã cập nhật danh sách buff mới!")
end

