require("util_gui")
require("form_stage_main\\form_homepoint\\form_home_point")
local THIS_FORM = "auto_tools\\tools_thanhanh"
local b={
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

function reset_this_form(form)
	form.combobox_friends.DropListBox:ClearString()
	form.combobox_friends.Text = nx_widestr("")
	form.combobox_mode.DropListBox:ClearString()
	form.combobox_mode.Text = nx_widestr("")
	form.btn_control.Visible = false
	form.btn_control.Text = util_text("tool_start")
end
function on_form_main_init(form)
	form.Fixed = false
	form.is_minimize = false
end
function on_main_form_open(form)
	change_form_size()
	form.is_minimize = false
form.select_map=1
form.select_point=1
form.combobox_friends.DropListBox:ClearString()
form.combobox_mode.DropListBox:ClearString()
	for d=1,table.getn(b) do 
		form.combobox_friends.DropListBox:AddString(util_text(b[d]["name"]))
	end
form.combobox_friends.OnlySelect=true
form.combobox_mode.OnlySelect=true
form.combobox_friends.DropListBox.SelectIndex=form.select_map-1
form.combobox_mode.DropListBox.SelectIndex=form.select_point-1 
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
	form.Left = (gui.Width - form.Width) / 2
	--form.Top = (gui.Height - form.Height) / 2
	form.Top = 100
end
function on_combobox_mode_selected(combobox)
end
function on_combobox_friends_selected(combobox)
end
function on_close_click(form)
util_auto_show_hide_form("auto_tools\\tools_thanhanh")
end
function on_btn_control_click(f)
local c=f.ParentForm
local g=nx_execute("form_stage_main\\form_homepoint\\home_point_data","IsExistRecordHomePoint",nx_string(c.point_name))
	if g then 
		AutoSendNotice("Bạn đã lưu địa điểm này rồi")
		else 
		local h,i=GetHomePointFromHPid(nx_string(c.point_name))
			if h then
				nx_execute("form_stage_main\\form_homepoint\\home_point_data","send_homepoint_msg_to_server",2,i[1])
				--AutoSendMessage("Bạn đã lưu địa điểm thành công !")
			end 
	end 
end
function on_combobox_friends_selected(j)
local c=j.ParentForm
c.select_map=c.combobox_friends.DropListBox.SelectIndex+1
local k=nx_function("ext_split_wstring",nx_widestr(b[c.select_map]["point"]),nx_widestr(","))c.combobox_mode.DropListBox:ClearString()
	for d=1,table.getn(k)do 
		local l=nx_ws_lower(nx_widestr("ui_")..nx_widestr(k[d]))
		c.combobox_mode.DropListBox:AddString(util_text(nx_string(l)))
	end 
end
function on_combobox_mode_selected(j)
local c=j.ParentForm
c.select_point=c.combobox_mode.DropListBox.SelectIndex+1
local k=nx_function("ext_split_wstring",nx_widestr(b[c.select_map]["point"]),nx_widestr(","))
c.point_name=k[c.select_point]
end

function AutoSendNotice(C)
	local C=nx_function("ext_utf8_to_widestr",C)
	ShowTipDialog(C)
end
function AutoSendMessage(C)
	local C=nx_function("ext_utf8_to_widestr","<img src=\"gui\\guild\\map\\battle.png\" valign=\"bottom\" /><font color=\"#5FD00B\">[AUTO]</font> "..C)
	local D=nx_value("form_main_chat")
	D:AddChatInfoEx(C,17,false)
end
function GetHomePointFromHPid(E)
	local F=nx_execute("util_functions","get_ini","share\\Rule\\HomePoint.ini")
	if not nx_is_valid(F)then 
		return false 
	end
	local G=F:FindSectionIndex(E)
	if G<0 then 
		return false 
	end
	local H={}
	H[1]=E
	H[2]=F:ReadInteger(G,"SceneID",0)
	H[3]=F:ReadString(G,"Name","")
	H[4]=F:ReadInteger(G,"Safe",0)
	local I=F:ReadString(G,"PositonXYZ","")
	H[5]=util_split_string(nx_string(I),",")
	H[6]=F:ReadString(G,"Ui_Introduction","")
	H[7]=F:ReadString(G,"Ui_Picture","")
	H[8]=F:ReadInteger(G,"Type",0)
	H[9]=F:ReadString(G,"SpecialSec","")
	return true,H 
end