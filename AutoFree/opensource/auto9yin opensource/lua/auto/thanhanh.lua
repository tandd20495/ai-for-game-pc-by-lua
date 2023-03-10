require("util_gui")
require('auto\\lib')

local THIS_FORM = "auto\\thanhanh"

local map_point = {
	{
		name = "born01",
		point = "HomePointborn01A,HomePointborn01B,HomePointborn01C,HomePointborn01D"
	},
	{
		name = "born02",
		point = "HomePointborn02A,HomePointborn02B,HomePointborn02C,HomePointborn02D,HomePointborn02E,HomePointborn02F"
	},
	{
		name = "born03",
		point = "HomePointborn03A,HomePointborn03B,HomePointborn03C,HomePointborn03D,HomePointborn03E"
	}, 
	{
		name = "born04",
		point = "HomePointborn04A,HomePointborn04B,HomePointborn04C,HomePointborn04D"
	},
	{
		name = "city05",
		point = "HomePointcity05A,HomePointcity05B,HomePointcity05C"
	},
	{
		name = "city01",
		point = "HomePointcity01A,HomePointcity01B,HomePointcity01C,HomePointcity01D"
	},
	{
		name = "city02",
		point = "HomePointcity02A,HomePointcity02B,HomePointcity02C,HomePointcity02D,HomePointcity02E,HomePointcity02F"
	},
	{
		name = "city03",
		point = "HomePointcity03A,HomePointcity03B,HomePointcity03C,HomePointcity03D,HomePointcity03E"
	},
	{
		name = "city04",
		point = "HomePointcity04A,HomePointcity04B,HomePointcity04C,HomePointcity04D,HomePointcity04E"
	},
	{
		name = "school01",
		point = "HomePointschool01B,HomePointschool01C"
	},
	{
		name = "school02",
		point = "HomePointschool02A"
	},
	{
		name = "school03",
		point = "HomePointschool03B,HomePointschool03C,HomePointschool03D"
	},
	{
		name = "school04",
		point = "HomePointschool04B,HomePointschool04C"
	},
	{
		name = "school05",
		point = "HomePointschool05B,HomePointschool05C,HomePointschool05D"
	},
	{
		name = "school06",
		point = "HomePointschool06A,HomePointschool06B,HomePointschool06D"
	},
	{
		name = "school07",
		point = "HomePointschool07A,HomePointschool07B,HomePointschool07C,HomePointschool07D,HomePointschool07F,HomePointschool07G"
	},
	{
		name = "school08",
		point = "HomePointschool08A,HomePointschool08B,HomePointschool08C,HomePointschool08E"
	},
	{
		name = "scene08",
		point = "HomePointscene08A,HomePointscene08B,HomePointscene08C,HomePointscene08D,HomePointscene08E"
	},
	{
		name = "scene09",
		point = "HomePointscene09A,HomePointscene09B,HomePointscene09C,HomePointscene09D"
	},
	{
		name = "force_yihua",
		point = "HomePointschool09A,HomePointschool09B"
	},
	{
		name = "force_taohua",
		point = "HomePointschool10A,HomePointschool10B"
	},
	{
		name = "force_wugen",
		point = "HomePointschool11A,HomePointschool11B"
	},
	{
		name = "newschool_wuxian",
		point = "HomePointschool12A"
	},
	{
		name = "newschool_xuedao",
		point = "HomePointschool13A"
	},
	{
		name = "newschool_gumu",
		point = "HomePointschool14A"
	},
	{
		name = "newschool_nianluo",
		point = "HomePointschool15A"
	},
	{
		name = "newschool_changfeng",
		point = "HomePointschool16A"
	},
	{
		name = "newschool_huashan",
		point = "HomePointschool17A"
	},
	{
		name = "newschool_shenshui",
		point = "HomePointschool19A,HomePointschool19B"
	},
	{
		name = "scene_scene16",
		point = "HomePointscene16A,HomePointscene16B,HomePointscene16C,HomePointscene16D,HomePointscene16E"
	},
	{
		name = "scene_scene17",
		point = "HomePointscene17A,HomePointscene16B,HomePointscene17C,HomePointscene17D"
	},
	{
		name = "scene_scene19",
		point = "HomePointscene19A,HomePointscene19B"
	},
	{
		name = "newschool_damo",
		point = "HomePointschool18A"
	}

}

function on_script_init(form)
	form.Fixed = false
	form.select_map = 1
	form.select_point = 1
	form.point_name = nil
end

function on_script_open(form)
	form.select_map = 1
	form.select_point = 1
	form.combobox1.DropListBox:ClearString()
	form.combobox2.DropListBox:ClearString()
	for r = 1, table.getn(map_point) do
		form.combobox1.DropListBox:AddString(util_text(map_point[r]["name"]))
	end
	form.combobox1.OnlySelect = true
	form.combobox2.OnlySelect = true

	form.combobox1.DropListBox.SelectIndex = form.select_map - 1
	form.combobox2.DropListBox.SelectIndex = form.select_point - 1
end

function on_script_close(form)
end

function on_close_click(btn)
	util_auto_show_hide_form("auto\\thanhanh")
end

function on_btn1_click(cbtn)
	local form = cbtn.ParentForm
	local is_exits_point = nx_execute("form_stage_main\\form_homepoint\\home_point_data", "IsExistRecordHomePoint", nx_string(form.point_name))
	if is_exits_point then
		AutoSendMessage("Bạn đã lưu địa điểm này rồi")
	else
		local bRet, hp_info = GetHomePointFromHPid(nx_string(form.point_name))
		if bRet then
			nx_execute("form_stage_main\\form_homepoint\\home_point_data", "send_homepoint_msg_to_server", 2, hp_info[1])
			AutoSendMessage("Bạn đã lưu địa điểm thành công !")
		end
	end
end

function on_combobox1_selected(boxitem)
	local form = boxitem.ParentForm
	form.select_map = form.combobox1.DropListBox.SelectIndex + 1
	local data = nx_function("ext_split_wstring", nx_widestr(map_point[form.select_map]["point"]), nx_widestr(","))

	form.combobox2.DropListBox:ClearString()
	for r = 1, table.getn(data) do
		local location = nx_ws_lower(nx_widestr("ui_") .. nx_widestr(data[r]))
		form.combobox2.DropListBox:AddString(util_text(nx_string(location)))
	end


end

function on_combobox2_selected(boxitem)
	local form = boxitem.ParentForm
	form.select_point = form.combobox2.DropListBox.SelectIndex + 1
	local data = nx_function("ext_split_wstring", nx_widestr(map_point[form.select_map]["point"]), nx_widestr(","))
	form.point_name = data[form.select_point]

end