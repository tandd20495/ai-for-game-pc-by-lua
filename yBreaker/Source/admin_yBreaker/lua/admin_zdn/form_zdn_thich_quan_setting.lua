require("util_functions")
require("admin_zdn\\zdn_form_common")

local ThichQuanData = {}
local ThichQuan = {}
local TaskStatusList = {}

function onFormOpen()
    loadConfig()
    initTqGridView()
end

function loadConfig()
    ThichQuanData = {}
    ThichQuan = {}
    local file = nx_resource_path() .. "yBreaker\\data\\thichquan\\the_luc.ini"
    local num = nx_number(IniRead(file, "the_luc_list", "total", 0))
    if num == 0 then
        return
    end
    for i = 1, num do
        local tqId = IniRead(file, nx_string(i), "GuanID", "0")
        local title = IniRead(file, nx_string(i), "Title", "0")
        local npc_config = IniRead(file, nx_string(i), "Npc", "0")
        local map_id = IniRead(file, nx_string(i), "MapId", "0")
        local pos = IniRead(file, nx_string(i), "Pos", "0")
        pos = util_split_wstring(pos, ",")
        if #pos ~= 3 then
            return
        end
        local menu = IniRead(file, nx_string(i), "Menu", "0")
        menu = util_split_wstring(menu, ",")
        for i = 1, #menu do
            menu[i] = nx_number(menu[i])
        end

        local child = {
            ["Title"] = title,
            ["MapId"] = nx_string(map_id),
            ["ID"] = nx_number(tqId),
            ["Npc"] = {
                ["Name"] = util_text(nx_string(npc_config)),
                ["mapId"] = nx_string(map_id),
                ["posX"] = nx_number(pos[1]),
                ["posY"] = nx_number(pos[2]),
                ["posZ"] = nx_number(pos[3]),
                ["dClick"] = 9
            },
            ["BeginMenu"] = menu
        }
        table.insert(ThichQuanData, child)
    end
end

function initTqGridView()
    TaskStatusList = {}

    if not nx_is_valid(Form) then
        return
    end
    for i = 0, #ThichQuanData - 1 do
        local gridIndex = Form.tq_grid.RowCount
        local cbtn = createCheckboxButton(i)
        Form.tq_grid:BeginUpdate()
        Form.tq_grid:InsertRow(gridIndex)
        Form.tq_grid:SetGridControl(gridIndex, 0, cbtn)
        Form.tq_grid:EndUpdate()
        TaskStatusList[ThichQuanData[i + 1].ID] = i
    end

    local disableListStr = nx_string(IniReadUserConfig("ThichQuan", "DisableList", ""))
    if disableListStr ~= "" then
        local disableList = util_split_string(disableListStr, ",")
        for i = 1, #disableList do
            local cbtn = Form.tq_grid:GetGridControl(nx_int(disableList[i] - 1), 0)
            if nx_is_valid(cbtn) then
                local btn = cbtn.btn
                if nx_is_valid(btn) then
                    btn.Checked = false
                end
            end
        end
    end

    local checked = nx_string(IniReadUserConfig("ThichQuan", "FollowMode", "0"))
    Form.follow_mode_cbtn.Checked = (checked == "1")
end

function createCheckboxButton(row)
    local data = ThichQuanData[row + 1]
    local gui = nx_value("gui")
    if not nx_is_valid(gui) then
        return 0
    end
    local groupbox = gui:Create("GroupBox")
    groupbox.BackColor = "0,0,0,0"
    groupbox.NoFrame = true
    local btn = gui:Create("CheckButton")
    groupbox:Add(btn)
    groupbox.btn = btn

    btn.Top = 0
    btn.Left = 0
    btn.Checked = checked
    btn.BoxSize = 12
    btn.NormalColor = "255,255,255,255"
    btn.FocusColor = "0,0,0,0"
    btn.PushColor = "0,0,0,0"
    btn.DisableColor = "0,0,0,0"
    btn.PushBlendColor = "255,255,255,255"
    btn.DisableBlendColor = "255,255,255,255"
    btn.Width = 240
    btn.Height = 25
    btn.BackColor = "255,192,192,192"
    btn.ForeColor = "255,255,255,255"
    btn.ShadowColor = "0,0,0,0"
    btn.TabStop = true
    btn.NoFrame = true
    btn.InSound = "MouseOn_20"
    btn.ClickSound = "ok_7"
    btn.Text = data.Title
    btn.NormalImage = "gui\\common\\checkbutton\\cbtn_out_4.png"
    btn.FocusImage = "gui\\common\\checkbutton\\cbtn_on_4.png"
    btn.CheckedImage = "gui\\common\\checkbutton\\cbtn_down_4.png"
    btn.DrawMode = "ExpandH"
    btn.Checked = true
    btn.ThichQuanIndex = row + 1
    return groupbox
end

function onBtnSubmitClick()
    local disableList = ""
    local cnt = Form.tq_grid.RowCount
    for i = 1, cnt do
        local cbtn = Form.tq_grid:GetGridControl(i - 1, 0)
        if nx_is_valid(cbtn) then
            local btn = cbtn.btn
            if nx_is_valid(btn) and not btn.Checked then
                if disableList ~= "" then
                    disableList = disableList .. ","
                end
                disableList = disableList .. i
            end
        end
    end
    IniWriteUserConfig("ThichQuan", "DisableList", disableList)
    IniWriteUserConfig("ThichQuan", "FollowMode", Form.follow_mode_cbtn.Checked and "1" or "0")
end

function onHyperCheckAllClick()
    local cnt = Form.tq_grid.RowCount
    for i = 1, cnt do
        local cbtn = Form.tq_grid:GetGridControl(i - 1, 0)
        if nx_is_valid(cbtn) then
            local btn = cbtn.btn
            if nx_is_valid(btn) and not btn.Checked then
                btn.Checked = true
            end
        end
    end
end

function onHyperUncheckAllClick()
    local cnt = Form.tq_grid.RowCount
    for i = 1, cnt do
        local cbtn = Form.tq_grid:GetGridControl(i - 1, 0)
        if nx_is_valid(cbtn) then
            local btn = cbtn.btn
            if nx_is_valid(btn) and btn.Checked then
                btn.Checked = false
            end
        end
    end
end
