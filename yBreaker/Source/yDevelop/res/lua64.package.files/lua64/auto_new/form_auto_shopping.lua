require("define\\object_type_define")
require("util_static_data")
require("utils")
require("util_gui")
require("util_move")
require("util_functions")
require("share\\chat_define")
require('auto_new\\autocack')

local THIS_FORM = "auto_new\\form_auto_shopping"
local CARD_MAIN_TYPE_WEAPON = 1
local CARD_MAIN_TYPE_EQUIP = 2
local CARD_MAIN_TYPE_HORSE = 3
local CARD_MAIN_TYPE_OTHENR = 4
local CARD_MAIN_TYPE_DECORATE = 5
local inmage_path = "gui\\language\\ChineseS\\card\\"
local CARD_INI = "share\\Rule\\card.ini"
player_max_neigong = ''
player_max_neigong_name = ''
findPathBusy = false
suitPlayer = ''
local suitDefault = {
    Hat = '',
    Cloth = '',
    Pants = '',
    Shoes = '',
    Cloak = '',
    Waist = '',
    Back = '',
    Face = '',
    Mount = ''
}
local currentSuitSet = {
    Hat = "", -- Tóc
    Cloth = "", -- Áo
    Pants = "", -- Quần
    Shoes = "", -- Giày
    Cloak = "", -- Phi Phong
    Waist = "", -- Trang Sức Đai
    Back = "", -- Trang Sức Lưng
    Face = "", -- Mặt Nạ
    Mount = "" -- Ngựa
}
local currentSetWeapon = {
    [1] = "", -- Đơn kiếm
    [2] = "", -- Song kiếm
    [3] = "", -- Đơn đao
    [4] = "", -- Song đao
    [5] = "", -- Đoản côn
    [6] = "", -- Trường côn
    [7] = "", -- Đoản kiếm
    [8] = "",  -- Song thích
    [9] = ""  -- Song thích
}
local SubType2TtemType = {
    [1] = ITEMTYPE_WEAPON_SWORD, -- Đơn kiếm
    [2] = ITEMTYPE_WEAPON_SSWORD, -- Song kiếm
    [3] = ITEMTYPE_WEAPON_BLADE, -- Đơn đao
    [4] = ITEMTYPE_WEAPON_SBLADE, -- Song đao
    [5] = ITEMTYPE_WEAPON_COSH, -- Đoản côn
    [6] = ITEMTYPE_WEAPON_STUFF, -- Trường côn
    [7] = ITEMTYPE_WEAPON_THORN, -- Đoản kiếm
    [8] = ITEMTYPE_WEAPON_STHORN,  -- Song thích
    [9] = ITEMTYPE_WEAPON_BOW -- Cung
}
local SubType2Text = {
    [1] = "Đơn Kiếm", -- Đơn kiếm
    [2] = "Song Kiếm", -- Song kiếm
    [3] = "Đơn Đao", -- Đơn đao
    [4] = "Song Đao", -- Song đao
    [5] = "Đoản Côn", -- Đoản côn
    [6] = "Trường Côn", -- Trường côn
    [7] = "Đoản Kiếm", -- Đoản kiếm
    [8] = "Song Thích",  -- Song thích
    [9] = "Cung"  -- Cung
}
-- function tools_reload_cache() 
    -- player_max_neigong = ""
    -- player_max_neigong_name = ""
    -- testFileTableRun = {}
    -- suitPlayer = ""
    -- suitCurrentData = suitDefault
    -- suitCurrentActive = -1
    -- weaponCurrentData = {
        -- [1] = "", -- Đơn kiếm
        -- [2] = "", -- Song kiếm
        -- [3] = "", -- Đơn đao
        -- [4] = "", -- Song đao
        -- [5] = "", -- Đoản côn
        -- [6] = "", -- Trường côn
        -- [7] = "", -- Đoản kiếm
        -- [8] = "",  -- Song thích
        -- [9] = ""  -- Song thích
    -- }
    -- weaponCurrentPlayer = ""
    -- tool_pvptaolu = nil
    -- tool_pvpbinhthu = nil
-- end
function on_form_main_init(form)
    form.Fixed = false
    form.is_minimize = false
end

function on_main_form_close(form)
    nx_destroy(form)
end

function on_main_form_open(form)
    change_form_size()
    form.is_minimize = false
    refreshSaveBtn(form)
end
function getCurrentSuitInfo()
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return false
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return false
    end
    if player_client:QueryProp("Name") == suitPlayer and suitCurrentActive ~= -1 then
        return suitCurrentActive, suitCurrentData.Hat, suitCurrentData.Cloth, suitCurrentData.Pants, suitCurrentData.Shoes, suitCurrentData.Cloak, suitCurrentData.Waist, suitCurrentData.Back, suitCurrentData.Face, suitCurrentData.Mount
    else
        -- Đọc từ cấu hình
        local game_config = nx_value("game_config")
        local account = game_config.login_account
        local ini = nx_create("IniDocument")
        if not nx_is_valid(ini) then
            return false
        end
        local noConfigSuit = true
        ini.FileName = nx_function("ext_get_current_exe_path") .. account .. "\\tools_config.ini"
        if ini:LoadFromFile() then
            local sactive = ini:ReadInteger(nx_string("suitset"), nx_string("Active"), 1)
            if sactive == 1 then
                suitCurrentActive = true
            else
                suitCurrentActive = false
            end
            suitCurrentData = {
                Hat = ini:ReadString(nx_string("suitset"), nx_string("Hat"), ""), -- Tóc
                Cloth = ini:ReadString(nx_string("suitset"), nx_string("Cloth"), ""), -- Áo
                Pants = ini:ReadString(nx_string("suitset"), nx_string("Pants"), ""), -- Quần
                Shoes = ini:ReadString(nx_string("suitset"), nx_string("Shoes"), ""), -- Giày
                Cloak = ini:ReadString(nx_string("suitset"), nx_string("Cloak"), ""), -- Phi Phong
                Waist = ini:ReadString(nx_string("suitset"), nx_string("Waist"), ""), -- Trang Sức Đai
                Back = ini:ReadString(nx_string("suitset"), nx_string("Back"), ""), -- Trang Sức Lưng
                Face = ini:ReadString(nx_string("suitset"), nx_string("Face"), ""), -- Mặt Nạ
                Mount = ini:ReadString(nx_string("suitset"), nx_string("Mount"), "") -- Ngựa
            }
            suitPlayer = player_client:QueryProp("Name")
            noConfigSuit = false
        end
        nx_destroy(ini)
        if suitCurrentActive == -1 or noConfigSuit then
            return false
        end
    end
    return suitCurrentActive, suitCurrentData.Hat, suitCurrentData.Cloth, suitCurrentData.Pants, suitCurrentData.Shoes, suitCurrentData.Cloak, suitCurrentData.Waist, suitCurrentData.Back, suitCurrentData.Face, suitCurrentData.Mount
end
function getCurrentWeaponSetInfo()
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return "", "", "", "", "", "", "", ""
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return "", "", "", "", "", "", "", ""
    end
    if player_client:QueryProp("Name") == weaponCurrentPlayer then
        return weaponCurrentData[1], weaponCurrentData[2], weaponCurrentData[3], weaponCurrentData[4], weaponCurrentData[5], weaponCurrentData[6], weaponCurrentData[7], weaponCurrentData[8], weaponCurrentData[9]
    else
        -- Đọc từ cấu hình
        local game_config = nx_value("game_config")
        local account = game_config.login_account
        local ini = nx_create("IniDocument")
        if not nx_is_valid(ini) then
            return "", "", "", "", "", "", "", ""
        end
        local noConfigWeapon = true
        ini.FileName = account .. "\\tools_config.ini"
        if ini:LoadFromFile() then
            weaponCurrentData = {
                [1] = ini:ReadString(nx_string("weaponset"), nx_string("WeaponSubType1"), ""),
                [2] = ini:ReadString(nx_string("weaponset"), nx_string("WeaponSubType2"), ""),
                [3] = ini:ReadString(nx_string("weaponset"), nx_string("WeaponSubType3"), ""),
                [4] = ini:ReadString(nx_string("weaponset"), nx_string("WeaponSubType4"), ""),
                [5] = ini:ReadString(nx_string("weaponset"), nx_string("WeaponSubType5"), ""),
                [6] = ini:ReadString(nx_string("weaponset"), nx_string("WeaponSubType6"), ""),
                [7] = ini:ReadString(nx_string("weaponset"), nx_string("WeaponSubType7"), ""),
                [8] = ini:ReadString(nx_string("weaponset"), nx_string("WeaponSubType8"), ""),
                [9] = ini:ReadString(nx_string("weaponset"), nx_string("WeaponSubType9"), "")
            }
            weaponCurrentPlayer = player_client:QueryProp("Name")
            noConfigWeapon = false
        end
        nx_destroy(ini)
        if noConfigWeapon then
            return "", "", "", "", "", "", "", "", ""
        end
    end

    return weaponCurrentData[1], weaponCurrentData[2], weaponCurrentData[3], weaponCurrentData[4], weaponCurrentData[5], weaponCurrentData[6], weaponCurrentData[7], weaponCurrentData[8], weaponCurrentData[9]
end
function refreshSaveBtn(form)
    if not nx_is_valid(form) then
        return false
    end
    local sactive, Hat, Cloth, Pants, Shoes, Cloak, Waist, Back, Face, Mount = getCurrentSuitInfo()
    local wps1, wps2, wps3, wps4, wps5, wps6, wps7, wps8, wps9 = getCurrentWeaponSetInfo()
     if not sactive then
        form.btn_save.Text = nx_function("ext_utf8_to_widestr", "Lưu và kích hoạt tự đổi đồ")
    else
        form.btn_save.Text = nx_function("ext_utf8_to_widestr", "Lưu và bỏ tự đổi đồ")
    end
    currentSuitSet = {
        Hat = Hat, -- Tóc
        Cloth = Cloth, -- Áo
        Pants = Pants, -- Quần
        Shoes = Shoes, -- Giày
        Cloak = Cloak, -- Phi Phong
        Waist = Waist, -- Trang Sức Đai
        Back = Back, -- Trang Sức Lưng
        Face = Face, -- Mặt Nạ
        Mount = Mount -- Ngựa
    }
    currentSetWeapon = {
        [1] = wps1, -- Đơn kiếm
        [2] = wps2, -- Song kiếm
        [3] = wps3, -- Đơn đao
        [4] = wps4, -- Song đao
        [5] = wps5, -- Đoản côn
        [6] = wps6, -- Trường côn
        [7] = wps7, -- Đoản kiếm
        [8] = wps8,  -- Song thích
        [9] = wps9  -- Cung
    }
end


function on_btn_close_click(btn)
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return false
    end
    on_main_form_close(form)
end

function change_form_size()
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return false
    end
    local gui = nx_value("gui")
    --form.Left = (gui.Width - form.Width) / 2
    --form.Top = (gui.Height - form.Height) / 2
    form.Left = 100
    form.Top = 140
end

-- Sử dụng PVC
function on_btn_usecard_click(btn)
    if not nx_is_valid(btn) then
        return false
    end
    local model = btn.model
    local SubType = btn.SubType
    local game_visual = nx_value("game_visual")
    local game_player = game_visual:GetPlayer()
    local role_composite = nx_value("role_composite")
    local role = nx_value("role")
    if not nx_is_valid(role) then
        return
    end
    if not nx_is_valid(role_composite) then
        return
    end
    local model_table = util_split_string(model, ";")
    local count = table.getn(model_table)
    if count == 0 then
        return
    end
    if SubType ~= -1 then
        local base_table = util_split_string(model_table[1], ",")
        local base_count = table.getn(base_table)
        if base_count ~= 2 then
            showUtf8Text("Lỗi model: " .. nx_string(model))
            return
        end
        local prop_value = base_table[2]
        currentSetWeapon[tonumber(SubType)] = prop_value
        -- Áp dụng cho vũ khí
        local currWeaponSubType = getWeaponSubType()
        if currWeaponSubType == SubType then
            role_composite:UnLinkWeapon(role)
            game_visual:SetRoleWeaponName(role, prop_value)
            role_composite:UseWeapon(role, game_visual:QueryRoleWeaponName(role), 2, nx_int(SubType2TtemType[tonumber(SubType)]))
            role_composite:RefreshWeapon(role)
        else
            showUtf8Text("Đã áp dụng Sau khi lưu thiết lập tự đổi set đồ và thay vũ khí sẽ có tác dụng")
        end
        return
    end
    -- Áp dụng cho các loại pvc khác
    for i = 1, count do
        --local base_table = util_split_string(model_table[i], ":") -- Dùng card manager
        local base_table = util_split_string(model_table[i], ",") -- Dùng ini
        if base_table ~= nil then
            local base_count = table.getn(base_table)
            if base_count == 2 then
                local prop_name = nx_string(base_table[1])
                local prop_value = nx_string(base_table[2])
                if prop_name == "Hat" and prop_value ~= nil and prop_value ~= "" then
                    unlinkPlayerSkin("hat")
                    link_hat_skin(role_composite, game_player, prop_value)
                    currentSuitSet.Hat = prop_value
                elseif prop_name == "Shoes" then
                    unlinkPlayerSkin("shoes")
                    role_composite:LinkSkin(game_player, "shoes", prop_value .. ".xmod", false)
                    currentSuitSet.Shoes = prop_value
                elseif prop_name == "Cloth" then
                    unlinkPlayerSkin("cloth")
                    link_cloth_skin(role_composite, game_player, prop_value)
                    currentSuitSet.Cloth = prop_value
                elseif prop_name == "Pants" then
                    unlinkPlayerSkin("pants")
                    link_pants_skin(role_composite, game_player, prop_value)
                    currentSuitSet.Pants = prop_value
                elseif prop_name == "Cloak" then
                    unlinkPlayerSkin("cloak")
                    role_composite:LinkSkin(game_player, "cloak", prop_value .. ".xmod", false)
                    currentSuitSet.Cloak = prop_value
                elseif prop_name == "Waist" then
                    unlinkPlayerSkin("waist")
                    role_composite:LinkSkin(game_player, "waist", prop_value .. ".xmod", false)
                    currentSuitSet.Waist = prop_value
                elseif prop_name == "Mount" then
                    -- Ngựa
                    currentSuitSet.Mount = prop_value
                    local game_client = nx_value("game_client")
                    local player_client = game_client:GetPlayer()
                    local role = nx_value("role")
                    if player_client:QueryProp("Mount") ~= 0 and player_client:QueryProp("Mount") ~= "" then
                        nx_execute("role_composite", "load_from_ini", role, "ini\\" .. prop_value .. ".ini")
                    end
                    showUtf8Text("Đã áp dụng loại Tọa Kỵ này. Nếu đang trên ngựa vui lòng xuống ngựa và gọi ngựa lại. Nếu chưa lên ngựa thì lên ngựa để áp dụng")
                elseif prop_name == "back" then
                    -- Trang sức lưng
                    currentSuitSet.Back = prop_value
                    local game_client = nx_value("game_client")
                    local player_client = game_client:GetPlayer()
                    local role = nx_value("role")
                    local collect_card_manager = nx_value("CollectCardManager")
                    if nx_find_custom(role, "dec_link_name" .. nx_string(3)) then
                        local link_name = nx_custom(role, "dec_link_name" .. nx_string(3))
                        if link_name ~= "" then
                            collect_card_manager:UnLinkCardDecorate(role, nx_string(link_name))
                            nx_set_custom(role, "dec_link_name" .. nx_string(3), "")
                        end
                    end
                    nx_set_custom(role, "dec_link_name" .. nx_string(3), prop_value)
                    collect_card_manager:LinkCardDecorate(role, prop_value)
                elseif prop_name == "face" then
                    -- Mặt nạ
                    currentSuitSet.Face = prop_value
                    local BufferEffect = nx_value("BufferEffect")
                    local effect_id = BufferEffect:GetBufferEffectInfoByID(prop_value, "effect")
                    local scene = nx_value("game_scene")
                    local game_effect = scene.game_effect
                    if nx_find_custom(game_player, "face_effect_id") then
                        game_effect:RemoveEffect(game_player.face_effect_id, game_player, game_player)
                    end
                    game_effect:CreateEffect(nx_string(effect_id), game_player, game_player, "", "", "", "", game_player, true)
                    game_player.face_effect_id = effect_id
                end
            end
        end
    end
end

function create_item_cardrow(card_id, player_sex, card_model, SubType)
    --local collect_card_manager = nx_value("CollectCardManager")
    --if not nx_is_valid(collect_card_manager) then
    --    return nx_null()
    --end
    --local card_info_table = collect_card_manager:GetCardInfo(card_id)
    local photo = nx_resource_path() .. inmage_path .. nx_string(card_id) .. ".png"
    local gui = nx_value("gui")
    local groupbox = gui:Create("GroupBox")
    if not nx_is_valid(groupbox) then
        return nx_null()
    end

    if SubType == nil then
        SubType = -1
    end

    local btn_use = gui:Create("Button")
    local btn_unuse = gui:Create("Button")
    local lbl_name = gui:Create("Label")
    local lbl_pic = gui:Create("Label")
    local lbl_bgpic = gui:Create("Label")
    groupbox:Add(btn_use)
    groupbox:Add(btn_unuse)
    groupbox:Add(lbl_name)
    groupbox:Add(lbl_bgpic)
    groupbox:Add(lbl_pic)
    groupbox.Left = -3
    groupbox.Top = -3
    groupbox.Width = 279
    groupbox.Height = 113
    groupbox.BackColor = "0,255,255,255"
    groupbox.NoFrame = true
    groupbox.BackImage = "gui\\common\\form_back\\bg_donghai1.png"
    groupbox.DrawMode = "Expand"
    groupbox.AutoSize = false

    if nx_is_valid(btn_use) then
        btn_use.NormalImage = "gui\\common\\button\\btn_normal_out.png"
        btn_use.FocusImage = "gui\\common\\button\\btn_normal_on.png"
        btn_use.CheckedImage = "gui\\common\\button\\btn_normal_down.png"
        btn_use.Width = 100
        btn_use.Height = 30
        btn_use.Left = 75
        btn_use.Top = 29
        btn_use.Name = "sort"
        btn_use.Text = nx_function("ext_utf8_to_widestr", "Dùng")
        btn_use.DrawMode = "Expand"
        btn_use.ForeColor = "255,246,255,181"
        btn_use.model = card_model
        btn_use.SubType = SubType
        --if player_sex == nx_int(0) then
        --    btn_use.model = card_info_table[11]
        --else
        --    btn_use.model = card_info_table[10]
        --end
        nx_bind_script(btn_use, nx_current())
        nx_callback(btn_use, "on_click", "on_btn_usecard_click")
        --nx_set_custom(btn_use, "type", tvt_type)
    end
    if nx_is_valid(btn_unuse) then
        btn_unuse.NormalImage = "gui\\common\\button\\btn_normal_out.png"
        btn_unuse.FocusImage = "gui\\common\\button\\btn_normal_on.png"
        btn_unuse.CheckedImage = "gui\\common\\button\\btn_normal_down.png"
        btn_unuse.Width = 100
        btn_unuse.Height = 30
        btn_unuse.Left = 75
        btn_unuse.Top = 64
        btn_unuse.Name = "sort"
        btn_unuse.Text = nx_function("ext_utf8_to_widestr", "Hủy")
        btn_unuse.DrawMode = "Expand"
        btn_unuse.ForeColor = "255,246,255,181"
        btn_use.model_path = ""
        btn_use.item_type = ""
        nx_bind_script(btn_unuse, nx_current())
        nx_callback(btn_unuse, "on_click", "on_btn_unuse_click")
        --nx_set_custom(btn_unuse, "type", tvt_type)
    end
    if nx_is_valid(lbl_name) then
        lbl_name.Left = 75
        lbl_name.Top = 8
        lbl_name.Width = 167
        lbl_name.Height = 16
        lbl_name.ForeColor = "255,216,203,55"
        lbl_name.Font = "font_main"
        lbl_name.Align = "Left"
        lbl_name.Text = util_text("card_item_" .. nx_string(card_id))
    end
    if nx_is_valid(lbl_bgpic) then
        lbl_bgpic.Left = 5
        lbl_bgpic.Top = 8
        lbl_bgpic.Width = 66
        lbl_bgpic.Height = 98
        lbl_bgpic.AutoSize = false
        lbl_bgpic.BackImage = "gui\\common\\imagegrid\\icon_yqd_qd_1.png"
        lbl_bgpic.DrawMode = "FitWindow"
    end
    if nx_is_valid(lbl_pic) then
        lbl_pic.Left = 11
        lbl_pic.Top = 14
        lbl_pic.Width = 55
        lbl_pic.Height = 86
        lbl_pic.AutoSize = false
        lbl_pic.BackImage = photo
        lbl_pic.DrawMode = "FitWindow"
    end
    return groupbox
end

function on_btn_use_click(btn)
    local game_visual = nx_value("game_visual")
    local game_player = game_visual:GetPlayer()
    local role_composite = nx_value("role_composite")
    local model_path = btn.model_path
    local item_type = btn.item_type

    if nx_int(item_type) == nx_int(ITEMTYPE_EQUIP_HAT) then
        -- Tóc
        link_hat_skin(role_composite, game_player, model_path)
        currentSuitSet.Hat = model_path
    elseif nx_int(item_type) == nx_int(ITEMTYPE_EQUIP_CLOTH) or nx_int(item_type) == nx_int(ITEMTYPE_ORIGIN_SUIT) or nx_int(item_type) == nx_int(ITEMTYPE_GUILD_SUIT) then
        -- Áo thường + Áo danh phận + Áo bang
        -- Xóa áo, quần, giày trước
        unlinkPlayerSkin("cloth")
        if nx_int(item_type) == nx_int(ITEMTYPE_ORIGIN_SUIT) or nx_int(item_type) == nx_int(ITEMTYPE_GUILD_SUIT) then
            unlinkPlayerSkin("pants")
            unlinkPlayerSkin("shoes")
            currentSuitSet.Pants = ""
            currentSuitSet.Shoes = ""
        end
        -- Thêm loại mới
        link_cloth_skin(role_composite, game_player, model_path)
        currentSuitSet.Cloth = model_path
    elseif nx_int(item_type) == nx_int(ITEMTYPE_EQUIP_PANTS) then
        -- Quần
        link_pants_skin(role_composite, game_player, model_path)
        currentSuitSet.Pants = model_path
    elseif nx_int(item_type) == nx_int(ITEMTYPE_EQUIP_SHOES) then
        -- Giày
        role_composite:LinkSkin(game_player, "shoes", model_path .. ".xmod", false)
        currentSuitSet.Shoes = model_path
    end
end

function on_btn_unuse_click(btn)
end

-- Tóc của PVC
function create_item_cardhat(card_id, head_model, head_icon)
    local gui = nx_value("gui")
    local groupbox = gui:Create("GroupBox")
    if not nx_is_valid(groupbox) then
        return nx_null()
    end
    local btn_use = gui:Create("Button")
    local btn_unuse = gui:Create("Button")
    local lbl_name = gui:Create("Label")
    local lbl_pic = gui:Create("Label")
    local lbl_bgpic = gui:Create("Label")
    groupbox:Add(btn_use)
    groupbox:Add(btn_unuse)
    groupbox:Add(lbl_name)
    groupbox:Add(lbl_bgpic)
    groupbox:Add(lbl_pic)
    groupbox.Left = -3
    groupbox.Top = -3
    groupbox.Width = 279
    groupbox.Height = 113
    groupbox.BackColor = "0,255,255,255"
    groupbox.NoFrame = true
    groupbox.BackImage = "gui\\common\\form_back\\bg_donghai1.png"
    groupbox.DrawMode = "Expand"
    groupbox.AutoSize = false

    if nx_is_valid(btn_use) then
        btn_use.NormalImage = "gui\\common\\button\\btn_normal_out.png"
        btn_use.FocusImage = "gui\\common\\button\\btn_normal_on.png"
        btn_use.CheckedImage = "gui\\common\\button\\btn_normal_down.png"
        btn_use.Width = 100
        btn_use.Height = 30
        btn_use.Left = 107
        btn_use.Top = 29
        btn_use.Name = "sort"
        btn_use.Text = nx_function("ext_utf8_to_widestr", "Dùng")
        btn_use.DrawMode = "Expand"
        btn_use.ForeColor = "255,246,255,181"
        btn_use.model_path = head_model
        btn_use.item_type = ITEMTYPE_EQUIP_HAT
        nx_bind_script(btn_use, nx_current())
        nx_callback(btn_use, "on_click", "on_btn_use_click")
        --nx_set_custom(btn_use, "type", tvt_type)
    end
    if nx_is_valid(btn_unuse) then
        btn_unuse.NormalImage = "gui\\common\\button\\btn_normal_out.png"
        btn_unuse.FocusImage = "gui\\common\\button\\btn_normal_on.png"
        btn_unuse.CheckedImage = "gui\\common\\button\\btn_normal_down.png"
        btn_unuse.Width = 100
        btn_unuse.Height = 30
        btn_unuse.Left = 107
        btn_unuse.Top = 64
        btn_unuse.Name = "sort"
        btn_unuse.Text = nx_function("ext_utf8_to_widestr", "Hủy")
        btn_unuse.DrawMode = "Expand"
        btn_unuse.ForeColor = "255,246,255,181"
        btn_use.model_path = head_model
        btn_use.item_type = ITEMTYPE_EQUIP_HAT
        nx_bind_script(btn_unuse, nx_current())
        nx_callback(btn_unuse, "on_click", "on_btn_unuse_click")
        --nx_set_custom(btn_unuse, "type", tvt_type)
    end
    if nx_is_valid(lbl_name) then
        lbl_name.Left = 107
        lbl_name.Top = 8
        lbl_name.Width = 167
        lbl_name.Height = 16
        lbl_name.ForeColor = "255,216,203,55"
        lbl_name.Font = "font_main"
        lbl_name.Align = "Left"
        lbl_name.Text = util_text("card_item_" .. nx_string(card_id))
    end
    if nx_is_valid(lbl_bgpic) then
        lbl_bgpic.Left = 5
        lbl_bgpic.Top = 8
        lbl_bgpic.Width = 98
        lbl_bgpic.Height = 98
        lbl_bgpic.AutoSize = false
        lbl_bgpic.BackImage = "gui\\common\\imagegrid\\icon_yqd_qd_1.png"
        lbl_bgpic.DrawMode = "FitWindow"
    end
    if nx_is_valid(lbl_pic) then
        lbl_pic.Left = 11
        lbl_pic.Top = 14
        lbl_pic.Width = 86
        lbl_pic.Height = 86
        lbl_pic.AutoSize = false
        lbl_pic.BackImage = head_icon
        lbl_pic.DrawMode = "FitWindow"
    end
    return groupbox
end

function create_item_row(itemName, player_sex)
    local gui = nx_value("gui")
    local groupbox = gui:Create("GroupBox")
    if not nx_is_valid(groupbox) then
        return nx_null()
    end
    local btn_use = gui:Create("Button")
    local btn_unuse = gui:Create("Button")
    local lbl_name = gui:Create("Label")
    local lbl_pic = gui:Create("Label")
    local lbl_bgpic = gui:Create("Label")
    groupbox:Add(btn_use)
    groupbox:Add(btn_unuse)
    groupbox:Add(lbl_name)
    groupbox:Add(lbl_bgpic)
    groupbox:Add(lbl_pic)
    groupbox.Left = -3
    groupbox.Top = -3
    groupbox.Width = 279
    groupbox.Height = 113
    groupbox.BackColor = "0,255,255,255"
    groupbox.NoFrame = true
    groupbox.BackImage = "gui\\common\\form_back\\bg_donghai1.png"
    groupbox.DrawMode = "Expand"
    groupbox.AutoSize = false

    local role_composite = nx_value("role_composite")
    local item_query = nx_value("ItemQuery")
    -- ID cái thông tin về Art của Item
    local row = item_query:GetItemPropByConfigID(itemName, "ArtPack")
    -- Loại ITEM
    local item_type = item_query:GetItemPropByConfigID(itemName, "ItemType")
    -- Tên Item
    local item_name = item_query:GetItemPropByConfigID(itemName, "QName")
    -- Giới hạn giới tính: 0 là nam 1 là nữ 2 là thông dụng
    local item_sex = item_query:GetItemPropByConfigID(itemName, "NeedSex")

    -- Model và ảnh cho nữ
    local modelF_path = item_static_query(nx_int(row), "FemaleModel", STATIC_DATA_ITEM_ART)
    local modelF_photo = item_static_query(nx_int(row), "FemalePhoto", STATIC_DATA_ITEM_ART)

    -- Model và ảnh cho nam
    local modelM_path = item_static_query(nx_int(row), "MaleModel", STATIC_DATA_ITEM_ART)
    local modelM_photo = item_static_query(nx_int(row), "Photo", STATIC_DATA_ITEM_ART)

    local model_photo = ""
    local model_path = ""
    if player_sex == nx_int(1) then
        -- Nữ
        model_photo = modelF_photo
        model_path = modelF_path
        if model_photo == "" and modelM_photo ~= "" then
            model_photo = modelM_photo
        end
    else
        -- Nam
        model_photo = modelM_photo
        model_path = modelM_path
        if model_photo == "" and modelF_photo ~= "" then
            model_photo = modelF_photo
        end
    end

    if nx_is_valid(btn_use) then
        btn_use.NormalImage = "gui\\common\\button\\btn_normal_out.png"
        btn_use.FocusImage = "gui\\common\\button\\btn_normal_on.png"
        btn_use.CheckedImage = "gui\\common\\button\\btn_normal_down.png"
        btn_use.Width = 100
        btn_use.Height = 30
        btn_use.Left = 107
        btn_use.Top = 29
        btn_use.Name = "sort"
        btn_use.Text = nx_function("ext_utf8_to_widestr", "Dùng")
        btn_use.DrawMode = "Expand"
        btn_use.ForeColor = "255,246,255,181"
        btn_use.model_path = model_path
        btn_use.item_type = item_type
        nx_bind_script(btn_use, nx_current())
        nx_callback(btn_use, "on_click", "on_btn_use_click")
        --nx_set_custom(btn_use, "type", tvt_type)
    end
    if nx_is_valid(btn_unuse) then
        btn_unuse.NormalImage = "gui\\common\\button\\btn_normal_out.png"
        btn_unuse.FocusImage = "gui\\common\\button\\btn_normal_on.png"
        btn_unuse.CheckedImage = "gui\\common\\button\\btn_normal_down.png"
        btn_unuse.Width = 100
        btn_unuse.Height = 30
        btn_unuse.Left = 107
        btn_unuse.Top = 64
        btn_unuse.Name = "sort"
        btn_unuse.Text = nx_function("ext_utf8_to_widestr", "Hủy")
        btn_unuse.DrawMode = "Expand"
        btn_unuse.ForeColor = "255,246,255,181"
        btn_use.model_path = model_path
        btn_use.item_type = item_type
        nx_bind_script(btn_unuse, nx_current())
        nx_callback(btn_unuse, "on_click", "on_btn_unuse_click")
        --nx_set_custom(btn_unuse, "type", tvt_type)
    end
    if nx_is_valid(lbl_name) then
        lbl_name.Left = 107
        lbl_name.Top = 8
        lbl_name.Width = 167
        lbl_name.Height = 16
        lbl_name.ForeColor = "255,216,203,55"
        lbl_name.Font = "font_main"
        lbl_name.Align = "Left"
        lbl_name.Text = util_text(item_name)
    end
    if nx_is_valid(lbl_bgpic) then
        lbl_bgpic.Left = 5
        lbl_bgpic.Top = 8
        lbl_bgpic.Width = 98
        lbl_bgpic.Height = 98
        lbl_bgpic.AutoSize = false
        lbl_bgpic.BackImage = "gui\\common\\imagegrid\\icon_yqd_qd_1.png"
        lbl_bgpic.DrawMode = "FitWindow"
    end
    if nx_is_valid(lbl_pic) then
        lbl_pic.Left = 11
        lbl_pic.Top = 14
        lbl_pic.Width = 86
        lbl_pic.Height = 86
        lbl_pic.AutoSize = false
        lbl_pic.BackImage = model_photo
        lbl_pic.DrawMode = "FitWindow"
    end
    return groupbox
end

function refresh_item_view(load_type)
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return false
    end
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return false
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return false
    end
    local player_sex = nx_int(player_client:QueryProp("Sex"))

    local group = form.groupscrollbox_1
    group:DeleteAll()

    local ini = nx_execute("util_functions", "get_ini", "share\\item\\equipment.ini")
    local itemsCount = ini:GetSectionCount()

    for i = 0, itemsCount - 1 do
        --local itemID = ini:GetSectionByIndex(i)
        local itemName = ini:ReadString(i, "QName", "")
        local itemType = ini:ReadInteger(i, "ItemType", -1)
        local itemSex = nx_int(ini:ReadInteger(i, "NeedSex", -1))
        if (itemSex == player_sex or itemSex == nx_int(2)) and itemType == load_type then
            local groupbox = create_item_row(itemName, player_sex)
            if nx_is_valid(groupbox) then
                group:Add(groupbox)
            end
        end
    end

    group:ResetChildrenYPos()
end

-- Xem tóc thường
function on_btn_view_hat_click(btn)
    refresh_item_view(ITEMTYPE_EQUIP_HAT)
end

-- Xem tóc PVC
function on_btn_view_hatpvc_click(btn)
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return false
    end
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return false
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return false
    end
    local player_sex = nx_int(player_client:QueryProp("Sex"))
    local group = form.groupscrollbox_1
    group:DeleteAll()
    local collect_card_manager = nx_value("CollectCardManager")

    local ini = nx_execute("util_functions", "get_ini", CARD_INI)
    if not nx_is_valid(ini) then
        return false
    end
    local numberCards = ini:GetSectionCount()
    -- Đảo ngược lại
    for i = 0, numberCards - 1 do
        local j = numberCards - i
        local card_id = nx_int(ini:GetSectionByIndex(j))
        local card_type = ini:ReadInteger(j, "ItemType", 0) -- 180 là quần áo
        local card_body_type = ini:ReadInteger(j, "body_type", 0) -- 1 là pvc thu nhỏ
        if card_type == 180 and card_body_type == 0 then
            local card_head_skill = collect_card_manager:GetCardHeadIcon(card_id)
            local female_head_prop = card_head_skill[1]
            local female_head_model = card_head_skill[2]
            local female_head_icon = card_head_skill[3]
            local male_head_prop = card_head_skill[4]
            local male_head_model = card_head_skill[5]
            local male_head_icon = card_head_skill[6]

            local head_prop = ""
            local head_model = ""
            local head_icon = ""
            if player_sex == nx_int(0) then
                head_prop = male_head_prop
                head_model = male_head_model
                head_icon = male_head_icon
            else
                head_prop = female_head_prop
                head_model = female_head_model
                head_icon = female_head_icon
            end

            if (head_prop == "Hat" or head_prop == "hat") and head_model ~= nil and head_model ~= "" then
                local groupbox = create_item_cardhat(card_id, head_model, head_icon)
                if nx_is_valid(groupbox) then
                    group:Add(groupbox)
                end
            end
        end
    end

    --[[
    local card_id_table = collect_card_manager:OnChooseCard(nx_int(CARD_MAIN_TYPE_EQUIP), nx_int(0), nx_int(0), nx_int(0), nx_int(0), nx_int(0))
    local card_num = table.getn(card_id_table)
    local card_offset = 0
    while 1 do
        card_offset = card_offset + 1
        local i = ((card_offset - 1) * 3) + 1
        if card_id_table[i] == nil then
            break
        end
        local card_id = card_id_table[i]
        local card_head_skill = collect_card_manager:GetCardHeadIcon(card_id)
        local female_head_prop = card_head_skill[1]
        local female_head_model = card_head_skill[2]
        local female_head_icon = card_head_skill[3]
        local male_head_prop = card_head_skill[4]
        local male_head_model = card_head_skill[5]
        local male_head_icon = card_head_skill[6]

        local head_prop = ""
        local head_model = ""
        local head_icon = ""
        if player_sex == nx_int(0) then
            head_prop = male_head_prop
            head_model = male_head_model
            head_icon = male_head_icon
        else
            head_prop = female_head_prop
            head_model = female_head_model
            head_icon = female_head_icon
        end

        if (head_prop == "Hat" or head_prop == "hat") and head_model ~= nil and head_model ~= "" then
            local groupbox = create_item_cardhat(card_id, head_model, head_icon)
            if nx_is_valid(groupbox) then
                group:Add(groupbox)
            end
        end
    end
    ]]--

    group:ResetChildrenYPos()
end

-- Xem áo thường
function on_btn_view_cloth_click(btn)
    refresh_item_view(ITEMTYPE_EQUIP_CLOTH)
end
function unlinkPlayerSkin(part)
    local role_composite = nx_value("role_composite")
    if not nx_is_valid(role_composite) then
        return false
    end
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return false
    end
    local game_player = game_visual:GetPlayer()
    if not nx_is_valid(game_player) then
        return false
    end
    role_composite:UnLinkSkin(game_player, part)
end
function tools_reload_cache()
    isAdmRightSet = nil
    isDismissTrackSet = nil
    player_max_neigong = ""
    player_max_neigong_name = ""
    testFileTableRun = {}
    suitPlayer = ""
    suitCurrentData = suitDefault
    suitCurrentActive = -1
    weaponCurrentData = {
        [1] = "", -- Đơn kiếm
        [2] = "", -- Song kiếm
        [3] = "", -- Đơn đao
        [4] = "", -- Song đao
        [5] = "", -- Đoản côn
        [6] = "", -- Trường côn
        [7] = "", -- Đoản kiếm
        [8] = "", -- Song thích
        [9] = ""  -- Cung
    }
    weaponCurrentPlayer = ""
    tool_pvptaolu = nil
    tool_pvpbinhthu = nil
end
function getWeaponSubType()
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return 0
    end
    local view = game_client:GetView(nx_string(1))
    if not nx_is_valid(view) then
        return 0
    end
    local isWeaponSubType = 0 -- 0 thì không có cầm vũ khí hỗ trợ PVC
    local item_lst = view:GetViewObjList()
    for k = 1, table.getn(item_lst) do
        local itemtype = item_lst[k]:QueryProp("ItemType")
        if nx_int(itemtype) == nx_int(ITEMTYPE_WEAPON_SWORD) then
            -- Đơn kiếm
            isWeaponSubType = 1
            break
        elseif nx_int(itemtype) == nx_int(ITEMTYPE_WEAPON_SSWORD) then
            -- Song kiếm
            isWeaponSubType = 2
            break
        elseif nx_int(itemtype) == nx_int(ITEMTYPE_WEAPON_BLADE) then
            -- Đơn đao
            isWeaponSubType = 3
            break
        elseif nx_int(itemtype) == nx_int(ITEMTYPE_WEAPON_SBLADE) then
            -- Song đao
            isWeaponSubType = 4
            break
        elseif nx_int(itemtype) == nx_int(ITEMTYPE_WEAPON_COSH) then
            -- Đoản Côn
            isWeaponSubType = 5
            break
        elseif nx_int(itemtype) == nx_int(ITEMTYPE_WEAPON_STUFF) then
            -- Trường Côn
            isWeaponSubType = 6
            break
        elseif nx_int(itemtype) == nx_int(ITEMTYPE_WEAPON_THORN) then
            -- Đoản Kiếm
            isWeaponSubType = 7
            break
        elseif nx_int(itemtype) == nx_int(ITEMTYPE_WEAPON_STHORN) then
            -- Song thích
            isWeaponSubType = 8
            break
        elseif nx_int(itemtype) == nx_int(ITEMTYPE_WEAPON_BOW) then
            -- Cung
            isWeaponSubType = 9
            break
        end
    end
    return isWeaponSubType
end
function updatePlayerMount()
		nx_pause(0.5)
    local role_composite = nx_value("role_composite")
    if not nx_is_valid(role_composite) then
        return false
    end
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return false
    end
    local game_player = game_visual:GetPlayer()
    if not nx_is_valid(game_player) then
        return false
    end
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return false
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return false
    end
    local role = nx_value("role")
    if not nx_is_valid(role) then
        return false
    end
    local collect_card_manager = nx_value("CollectCardManager")
    if not nx_is_valid(collect_card_manager) then
        return false
    end

    local sactive, Hat, Cloth, Pants, Shoes, Cloak, Waist, Back, Face, Mount = getCurrentSuitInfo()
    if sactive then
        -- Ngựa đổi
        if Mount ~= "" and player_client:QueryProp("Mount") ~= 0 and player_client:QueryProp("Mount") ~= "" then
            nx_execute("role_composite", "load_from_ini", role, "ini\\" .. Mount .. ".ini")
        end
    end
end
function updatePlayerShape()
    	nx_pause(0.2)
    local role_composite = nx_value("role_composite")
    if not nx_is_valid(role_composite) then
        return false
    end
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return false
    end
    local game_player = game_visual:GetPlayer()
    if not nx_is_valid(game_player) then
        return false
    end
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return false
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return false
    end
    local role = nx_value("role")
    if not nx_is_valid(role) then
        return false
    end
    local collect_card_manager = nx_value("CollectCardManager")
    if not nx_is_valid(collect_card_manager) then
        return false
    end

    local sactive, Hat, Cloth, Pants, Shoes, Cloak, Waist, Back, Face, Mount = getCurrentSuitInfo()
    if sactive then
        -- Mặt Nạ
         -- Mũ áo quần giày   
         showUtf8Text(nx_string(Cloth),10)
        if nx_string(Hat) ~= "" then
            role_composite:UnLinkSkin(game_player, "hat")
            link_hat_skin(role_composite, game_player, nx_string(Hat))
        end
        if nx_string(Cloth) ~= "" then
            role_composite:UnLinkSkin(game_player, "cloth")
            link_cloth_skin(role_composite, game_player, nx_string(Cloth))
        end
        if nx_string(Pants) ~= "" then
            role_composite:UnLinkSkin(game_player, "pants")
            link_pants_skin(role_composite, game_player, nx_string(Pants))
        end
        if nx_string(Shoes) ~= "" then
            role_composite:UnLinkSkin(game_player, "shoes")
            role_composite:LinkSkin(game_player, "shoes", nx_string(Shoes) .. ".xmod", false)
        end
        if Face ~= "" then
            local BufferEffect = nx_value("BufferEffect")
            local effect_id = BufferEffect:GetBufferEffectInfoByID(Face, "effect")
            local scene = nx_value("game_scene")
            local game_effect = scene.game_effect
            if nx_find_custom(game_player, "face_effect_id") then
                game_effect:RemoveEffect(game_player.face_effect_id, game_player, game_player)
            end
            game_effect:CreateEffect(nx_string(effect_id), game_player, game_player, "", "", "", "", game_player, true)
            game_player.face_effect_id = effect_id
        end
        -- Trang Sức Lưng
        if Back ~= "" then
            if nx_find_custom(role, "dec_link_name" .. nx_string(3)) then
                local link_name = nx_custom(role, "dec_link_name" .. nx_string(3))
                if link_name ~= "" then
                    collect_card_manager:UnLinkCardDecorate(role, nx_string(link_name))
                    nx_set_custom(role, "dec_link_name" .. nx_string(3), "")
                end
            end
            nx_set_custom(role, "dec_link_name" .. nx_string(3), Back)
            collect_card_manager:LinkCardDecorate(role, Back)
        end
        -- Phi Phong Đổi
        if Cloak ~= "" then
            role_composite:UnLinkSkin(game_player, "cloak")
            role_composite:LinkSkin(game_player, "cloak", nx_string(Cloak) .. ".xmod", false)
        end
        -- Trang Sức Eo
        if Waist ~= "" then
            role_composite:UnLinkSkin(game_player, "waist")
            role_composite:LinkSkin(game_player, "waist", nx_string(Waist) .. ".xmod", false)
        end       
    end
end
function updatePlayerWeapon()
	  nx_pause(0.2)
    local role_composite = nx_value("role_composite")
    if not nx_is_valid(role_composite) then
        return false
    end
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return false
    end
    local game_player = game_visual:GetPlayer()
    if not nx_is_valid(game_player) then
        return false
    end
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return false
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return false
    end
    local role = nx_value("role")
    if not nx_is_valid(role) then
        return false
    end
    local collect_card_manager = nx_value("CollectCardManager")
    if not nx_is_valid(collect_card_manager) then
        return false
    end

    local sactive, Hat, Cloth, Pants, Shoes, Cloak, Waist, Back, Face, Mount = getCurrentSuitInfo()
    local wps1, wps2, wps3, wps4, wps5, wps6, wps7, wps8, wps9 = getCurrentWeaponSetInfo()
    if sactive then
        -- Vũ khí đổi
        local currWeaponSubType = getWeaponSubType()
        local tableSetWeapon = {
            [1] = wps1,
            [2] = wps2,
            [3] = wps3,
            [4] = wps4,
            [5] = wps5,
            [6] = wps6,
            [7] = wps7,
            [8] = wps8,
            [9] = wps9
        }
        if currWeaponSubType > 0 and tableSetWeapon[currWeaponSubType] ~= nil and tableSetWeapon[currWeaponSubType] ~= "" then
            role_composite:UnLinkWeapon(role)
            game_visual:SetRoleWeaponName(role, tableSetWeapon[currWeaponSubType])
            role_composite:UseWeapon(role, game_visual:QueryRoleWeaponName(role), 2, nx_int(SubType2TtemType[currWeaponSubType]))
            role_composite:RefreshWeapon(role)
        end
    end
end
-- Xem áo PVC
function on_btn_view_clothpvc_click(btn)
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return false
    end
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return false
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return false
    end
    local player_sex = nx_int(player_client:QueryProp("Sex"))
    local group = form.groupscrollbox_1
    group:DeleteAll()
    --[[
    local collect_card_manager = nx_value("CollectCardManager")
    local card_id_table = collect_card_manager:OnChooseCard(nx_int(CARD_MAIN_TYPE_EQUIP), nx_int(0), nx_int(0), nx_int(0), nx_int(0), nx_int(0))
    local card_num = table.getn(card_id_table)
    local card_offset = 0
    while 1 do
        card_offset = card_offset + 1
        local i = ((card_offset - 1) * 3) + 1
        if card_id_table[i] == nil then
            break
        end
        local card_id = card_id_table[i]
        local groupbox = create_item_cardrow(card_id, player_sex)
        if nx_is_valid(groupbox) then
            group:Add(groupbox)
        end
    end
    ]]--
    local ini = nx_execute("util_functions", "get_ini", CARD_INI)
    if not nx_is_valid(ini) then
        return false
    end
    local numberCards = ini:GetSectionCount()
    -- Đảo ngược lại
    for i = 0, numberCards - 1 do
        local j = numberCards - i
        local card_id = ini:GetSectionByIndex(j)
        local card_type = ini:ReadInteger(j, "ItemType", 0) -- 180 là quần áo
        local card_body_type = ini:ReadInteger(j, "body_type", 0) -- 1 là pvc thu nhỏ
        local card_model = ""
        if player_sex == nx_int(0) then
            -- Nam
            card_model = ini:ReadString(j, "MaleModelData", "")
        else
            -- Nữ
            card_model = ini:ReadString(j, "FemaleModelData", "")
        end
        if card_type == 180 and card_body_type == 0 then
            local groupbox = create_item_cardrow(card_id, player_sex, card_model)
            if nx_is_valid(groupbox) then
                group:Add(groupbox)
            end
        end
    end

    group:ResetChildrenYPos()
end

-- Xem quần thường
function on_btn_view_pants_click(btn)
    refresh_item_view(ITEMTYPE_EQUIP_PANTS)
end

-- Xem giày thường
function on_btn_view_shoes_click(btn)
    refresh_item_view(ITEMTYPE_EQUIP_SHOES)
end

-- Xem bộ danh phận
function on_btn_view_origin_suit_click(btn)
    refresh_item_view(ITEMTYPE_ORIGIN_SUIT)
end

-- Xem ngựa
function on_btn_view_mount_click(btn)
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return false
    end
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return false
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return false
    end
    local player_sex = nx_int(player_client:QueryProp("Sex"))
    local group = form.groupscrollbox_1
    group:DeleteAll()
    local ini = nx_execute("util_functions", "get_ini", CARD_INI)
    if not nx_is_valid(ini) then
        return false
    end
    local numberCards = ini:GetSectionCount()
    -- Đảo ngược lại
    for i = 0, numberCards - 1 do
        local j = numberCards - i
        local card_id = ini:GetSectionByIndex(j)
        local card_type = ini:ReadInteger(j, "ItemType", 0) -- 180 là quần áo
        local card_model = ""
        if player_sex == nx_int(0) then
            -- Nam
            card_model = ini:ReadString(j, "MaleModelData", "")
        else
            -- Nữ
            card_model = ini:ReadString(j, "FemaleModelData", "")
        end
        if card_type == ITEMTYPE_MOUNT then
            local groupbox = create_item_cardrow(card_id, player_sex, card_model)
            if nx_is_valid(groupbox) then
                group:Add(groupbox)
            end
        end
    end

    group:ResetChildrenYPos()
end

-- Xem trang sức đai
function on_btn_view_waist_click(btn)
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return false
    end
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return false
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return false
    end
    local player_sex = nx_int(player_client:QueryProp("Sex"))
    local group = form.groupscrollbox_1
    group:DeleteAll()
    local ini = nx_execute("util_functions", "get_ini", CARD_INI)
    if not nx_is_valid(ini) then
        return false
    end
    local numberCards = ini:GetSectionCount()
    -- Đảo ngược lại
    for i = 0, numberCards - 1 do
        local j = numberCards - i
        local card_id = nx_int(ini:GetSectionByIndex(j))
        local card_type = ini:ReadInteger(j, "MainType", 0) -- 180 là quần áo
        local card_stype = ini:ReadInteger(j, "SubType", 0) -- 180 là quần áo
        local card_model = ""
        if player_sex == nx_int(0) then
            -- Nam
            card_model = ini:ReadString(j, "MaleModelData", "")
        else
            -- Nữ
            card_model = ini:ReadString(j, "FemaleModelData", "")
        end
        if card_type == 5 and card_stype == 2 then
            local groupbox = create_item_cardrow(card_id, player_sex, card_model)
            if nx_is_valid(groupbox) then
                group:Add(groupbox)
            end
        end
    end

    group:ResetChildrenYPos()
end

-- Xem phi phong
function on_btn_view_cloak_click(btn)
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return false
    end
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return false
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return false
    end
    local player_sex = nx_int(player_client:QueryProp("Sex"))
    local group = form.groupscrollbox_1
    group:DeleteAll()
    local ini = nx_execute("util_functions", "get_ini", CARD_INI)
    if not nx_is_valid(ini) then
        return false
    end
    local numberCards = ini:GetSectionCount()
    -- Đảo ngược lại
    for i = 0, numberCards - 1 do
        local j = numberCards - i
        local card_id = nx_int(ini:GetSectionByIndex(j))
        local card_type = ini:ReadInteger(j, "MainType", 0) -- 180 là quần áo
        local card_stype = ini:ReadInteger(j, "SubType", 0) -- 180 là quần áo
        local card_model = ""
        if player_sex == nx_int(0) then
            -- Nam
            card_model = ini:ReadString(j, "MaleModelData", "")
        else
            -- Nữ
            card_model = ini:ReadString(j, "FemaleModelData", "")
        end
        if card_type == 5 and card_stype == 4 then
            local groupbox = create_item_cardrow(card_id, player_sex, card_model)
            if nx_is_valid(groupbox) then
                group:Add(groupbox)
            end
        end
    end

    group:ResetChildrenYPos()
end

-- Xem trang sức lưng
function on_btn_view_back_click(btn)
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return false
    end
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return false
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return false
    end
    local player_sex = nx_int(player_client:QueryProp("Sex"))
    local group = form.groupscrollbox_1
    group:DeleteAll()
    local ini = nx_execute("util_functions", "get_ini", CARD_INI)
    if not nx_is_valid(ini) then
        return false
    end
    local numberCards = ini:GetSectionCount()
    -- Đảo ngược lại
    for i = 0, numberCards - 1 do
        local j = numberCards - i
        local card_id = nx_int(ini:GetSectionByIndex(j))
        local card_type = ini:ReadInteger(j, "MainType", 0) -- 180 là quần áo
        local card_stype = ini:ReadInteger(j, "SubType", 0) -- 180 là quần áo
        local card_model = ""
        if player_sex == nx_int(0) then
            -- Nam
            card_model = ini:ReadString(j, "MaleModelData", "")
        else
            -- Nữ
            card_model = ini:ReadString(j, "FemaleModelData", "")
        end
        if card_type == 5 and card_stype == 3 then
            local groupbox = create_item_cardrow(card_id, player_sex, card_model)
            if nx_is_valid(groupbox) then
                group:Add(groupbox)
            end
        end
    end

    group:ResetChildrenYPos()
end

-- Xem mặt nạ
function on_btn_view_face_click(btn)
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return false
    end
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return false
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return false
    end
    local player_sex = nx_int(player_client:QueryProp("Sex"))
    local group = form.groupscrollbox_1
    group:DeleteAll()
    local ini = nx_execute("util_functions", "get_ini", CARD_INI)
    if not nx_is_valid(ini) then
        return false
    end
    local numberCards = ini:GetSectionCount()
    -- Đảo ngược lại
    for i = 0, numberCards - 1 do
        local j = numberCards - i
        local card_id = nx_int(ini:GetSectionByIndex(j))
        local card_type = ini:ReadInteger(j, "MainType", 0) -- 180 là quần áo
        local card_stype = ini:ReadInteger(j, "SubType", 0) -- 180 là quần áo
        local card_model = ""
        if player_sex == nx_int(0) then
            -- Nam
            card_model = ini:ReadString(j, "MaleFaceBuffEffectID", "")
        else
            -- Nữ
            card_model = ini:ReadString(j, "FemaleFaceBuffEffectID", "")
        end
        if card_type == 5 and card_stype == 5 then
            local groupbox = create_item_cardrow(card_id, player_sex, "face," .. card_model)
            if nx_is_valid(groupbox) then
                group:Add(groupbox)
            end
        end
    end

    group:ResetChildrenYPos()
end

-- Xem Vũ Khí
function on_btn_view_weapon_click(btn)
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return false
    end
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return false
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return false
    end
    local player_sex = nx_int(player_client:QueryProp("Sex"))
    local group = form.groupscrollbox_1
    group:DeleteAll()
    local ini = nx_execute("util_functions", "get_ini", CARD_INI)
    if not nx_is_valid(ini) then
        return false
    end
    local numberCards = ini:GetSectionCount()
    -- Đảo ngược lại
    for i = 0, numberCards - 1 do
        local j = numberCards - i
        local card_id = nx_int(ini:GetSectionByIndex(j))
        local card_type = ini:ReadInteger(j, "MainType", 0) -- 1 là vũ khí
        local card_stype = ini:ReadInteger(j, "SubType", 0) -- Xác định loại vũ khí
        local card_model = ""
        if player_sex == nx_int(0) then
            -- Nam
            card_model = ini:ReadString(j, "MaleModelData", "")
        else
            -- Nữ
            card_model = ini:ReadString(j, "FemaleModelData", "")
        end
        if card_type == 1 then
            local groupbox = create_item_cardrow(card_id, player_sex, card_model, card_stype)
            if nx_is_valid(groupbox) then
                group:Add(groupbox)
            end
        end
    end

    group:ResetChildrenYPos()
end

-- Xóa tóc
function on_btn_clear_hat_click(btn)
    unlinkPlayerSkin("hat")
    currentSuitSet.Hat = ""
    showUtf8Text("Đã xóa tóc")
end

-- Xóa áo
function on_btn_clear_cloth_click(btn)
    unlinkPlayerSkin("cloth")
    currentSuitSet.Cloth = ""
    showUtf8Text("Đã xóa áo")
end

-- Xóa quần
function on_btn_clear_pants_click(btn)
    unlinkPlayerSkin("pants")
    currentSuitSet.Pants = ""
    showUtf8Text("Đã xóa quần")
end

-- Xóa giày
function on_btn_clear_shoes_click(btn)
    unlinkPlayerSkin("shoes")
    currentSuitSet.Shoes = ""
    showUtf8Text("Đã xóa giày")
end

-- Xóa Phi Phong
function on_btn_clear_cloak_click(btn)
    unlinkPlayerSkin("cloak")
    currentSuitSet.Cloak = ""
    showUtf8Text("Đã xóa phi phong")
end

-- Xóa Trang Sức Đai
function on_btn_clear_waist_click(btn)
    unlinkPlayerSkin("waist")
    currentSuitSet.Waist = ""
    showUtf8Text("Đã xóa trang sức đai")
end

-- Xóa Trang Sức Lưng
function on_btn_clear_back_click(btn)
    currentSuitSet.Back = ""
    showUtf8Text("Đã bỏ trang sức lưng")
    local game_client = nx_value("game_client")
    local player_client = game_client:GetPlayer()
    local role = nx_value("role")
    local collect_card_manager = nx_value("CollectCardManager")
    if nx_find_custom(role, "dec_link_name" .. nx_string(3)) then
        local link_name = nx_custom(role, "dec_link_name" .. nx_string(3))
        if link_name ~= "" then
            collect_card_manager:UnLinkCardDecorate(role, nx_string(link_name))
            nx_set_custom(role, "dec_link_name" .. nx_string(3), "")
        end
    end
end

-- Xóa Mặt Nạ
function on_btn_clear_face_click(btn)
    currentSuitSet.Face = ""
    showUtf8Text("Đã bỏ mặt nạ")
    local game_visual = nx_value("game_visual")
    local game_player = game_visual:GetPlayer()
    local scene = nx_value("game_scene")
    local game_effect = scene.game_effect
    if nx_find_custom(game_player, "face_effect_id") then
        game_effect:RemoveEffect(game_player.face_effect_id, game_player, game_player)
    end
end

-- RS Ngựa
function on_btn_clear_mount_click(btn)
    currentSuitSet.Mount = ""
    showUtf8Text("Đã hủy thiết lập ngựa")
end

-- Lưu set đồ, bật hoặc tắt tự động thiết lập
function on_btn_save_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
    local game_config = nx_value("game_config")
    local account = game_config.login_account
    local ini = nx_create("IniDocument")
    local game_client = nx_value("game_client")
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(ini) then
        return
    end    
    local type2 = "suitset"
    ini.FileName = account .. "\\tools_config.ini"
	if not nx_function("ext_is_file_exist", ini.FileName) then			
		ini:SaveToFile()
	end
    if ini:LoadFromFile() then
        -- Xóa cấu hình trước
        ini:DeleteSection(nx_string(type2))
        ini:AddSection(nx_string(type2))
        -- Ghi dữ liệu
        local sactive, Hat, Cloth, Pants, Shoes, Cloak, Waist, Back, Face, Mount = getCurrentSuitInfo()
        if sactive then
            ini:WriteInteger(nx_string(type2), "Active", 0)
        else
            ini:WriteInteger(nx_string(type2), "Active", 1)
        end
        ini:WriteString(nx_string(type2), "Hat", nx_string(currentSuitSet.Hat))
        ini:WriteString(nx_string(type2), "Cloth", nx_string(currentSuitSet.Cloth))
        ini:WriteString(nx_string(type2), "Pants", nx_string(currentSuitSet.Pants))
        ini:WriteString(nx_string(type2), "Shoes", nx_string(currentSuitSet.Shoes))
        ini:WriteString(nx_string(type2), "Cloak", nx_string(currentSuitSet.Cloak))
        ini:WriteString(nx_string(type2), "Waist", nx_string(currentSuitSet.Waist))
        ini:WriteString(nx_string(type2), "Back", nx_string(currentSuitSet.Back))
        ini:WriteString(nx_string(type2), "Face", nx_string(currentSuitSet.Face))
        ini:WriteString(nx_string(type2), "Mount", nx_string(currentSuitSet.Mount))
        
        local type1 = "weaponset"
        ini:DeleteSection(nx_string(type1))
        ini:AddSection(nx_string(type1))
        ini:WriteString(nx_string(type1), "WeaponSubType1", currentSetWeapon[1])
        ini:WriteString(nx_string(type1), "WeaponSubType2", currentSetWeapon[2])
        ini:WriteString(nx_string(type1), "WeaponSubType3", currentSetWeapon[3])
        ini:WriteString(nx_string(type1), "WeaponSubType4", currentSetWeapon[4])
        ini:WriteString(nx_string(type1), "WeaponSubType5", currentSetWeapon[5])
        ini:WriteString(nx_string(type1), "WeaponSubType6", currentSetWeapon[6])
        ini:WriteString(nx_string(type1), "WeaponSubType7", currentSetWeapon[7])
        ini:WriteString(nx_string(type1), "WeaponSubType8", currentSetWeapon[8])
        ini:WriteString(nx_string(type1), "WeaponSubType9", currentSetWeapon[9])
	end
    ini:SaveToFile()
    nx_destroy(ini)
    tools_reload_cache()
    refreshSaveBtn(form)
end

function unlinkPlayerSkin(part)
    local role_composite = nx_value("role_composite")
    if not nx_is_valid(role_composite) then
        return false
    end
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return false
    end
    local game_player = game_visual:GetPlayer()
    if not nx_is_valid(game_player) then
        return false
    end
    role_composite:UnLinkSkin(game_player, part)
end
