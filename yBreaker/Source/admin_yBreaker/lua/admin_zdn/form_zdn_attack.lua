require("util_gui")
require("util_functions")
require("admin_zdn\\zdn_form_common")

local MAX_SET = 6

function onFormOpen(form)
	if nx_execute("admin_zdn\\zdn_logic_skill", "IsRunning") then
		updateBtnSubmitState(true)
	else
		updateBtnSubmitState(false)
	end
	Form.cbx_set.DropListBox:ClearString()
	for i = 1, MAX_SET do
		Form.cbx_set.DropListBox:AddString(Utf8ToWstr("Bộ ") .. nx_widestr(i))
	end
	loadConfig(form)
end

function onFormClose()
	nx_execute("admin_zdn\\zdn_logic_skill", "StopAutoAttack")
end

function onBtnSubmitClick(btn)
	if not nx_execute("admin_zdn\\zdn_logic_skill", "IsRunning") then
		saveFormData()
		nx_execute("admin_zdn\\zdn_logic_skill", "AutoAttackBySet", nx_number(getSelectedSet()))
		updateBtnSubmitState(true)
	else
		nx_execute("admin_zdn\\zdn_logic_skill", "StopAutoAttack")
		updateBtnSubmitState(false)
	end
end

function loadConfig(form)
	local set = nx_number(IniReadUserConfig("KyNang", "Selected", 0))
	if set == 0 then
		IniWriteUserConfig("KyNang", "Selected", "1")
		set = 1
	end
	Form.cbx_set.DropListBox.SelectIndex = set - 1
	Form.cbx_set.Text = Utf8ToWstr("Bộ ") .. nx_widestr(set)

	local cbtn = nx_string(IniReadUserConfig("KyNang", "Pick", "0"))
	Form.cbtn_pick.Checked = cbtn == "1"

	cbtn = nx_string(IniReadUserConfig("KyNang", "RadiusMode", "0"))
	Form.cbtn_radius.Checked = cbtn == "1"
	Form.edit_radius.Text = IniReadUserConfig("KyNang", "Radius", nx_widestr("50"))

	cbtn = nx_string(IniReadUserConfig("KyNang", "NpcListMode", "0"))
	Form.cbtn_npc_list.Checked = cbtn == "1"
	Form.edit_npc_list.Text = IniReadUserConfig("KyNang", "NpcList", nx_widestr(""))
end

function saveFormData()
	IniWriteUserConfig("KyNang", "Selected", getSelectedSet())
	IniWriteUserConfig("KyNang", "NpcList", Form.edit_npc_list.Text)
end

function onBtnSettingClick(btn)
	util_auto_show_hide_form("admin_zdn\\form_zdn_skill_setting")
end

function getSelectedSet()
	if not nx_is_valid(Form) then
		return 1
	end
	return Form.cbx_set.DropListBox.SelectIndex + 1
end

function onCbtnPickChanged(btn)
	IniWriteUserConfig("KyNang", "Pick", btn.Checked and "1" or "0")
end

function onCbtnRadiusChanged(btn)
	IniWriteUserConfig("KyNang", "RadiusMode", btn.Checked and "1" or "0")
end

function onCbtnNpcListChanged(btn)
	IniWriteUserConfig("KyNang", "NpcListMode", btn.Checked and "1" or "0")
end

function onBtnAddNpcClick()
	local client = nx_value("game_client")
	if not nx_is_valid(client) then
		return
	end
	local player = client:GetPlayer()
	if not nx_is_valid(player) then
		return
	end
	local npc = client:GetSceneObj(nx_string(player:QueryProp("LastObject")))
	if nx_is_valid(npc) then
		local crtTxt = Form.edit_npc_list.Text
		local tmp = util_text(npc:QueryProp("ConfigID"))
		local l = util_split_wstring(crtTxt, ",")
		for i = 1, #l do
			if l[i] == tmp then
				return
			end
		end
		if crtTxt ~= nx_widestr("") then
			crtTxt = crtTxt .. nx_widestr(",")
		end
		Form.edit_npc_list.Text = crtTxt .. tmp
		IniWriteUserConfig("KyNang", "NpcList", Form.edit_npc_list.Text)
	end
end

function onEditRadiusChanged(edt)
	IniWriteUserConfig("KyNang", "Radius", edt.Text)
end
