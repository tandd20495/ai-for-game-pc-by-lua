local FormInstanceID = "CommonNoteForm"
local CountConfigPath = "share\\Rule\\CountLimit.ini"
local TimeConfigPath = "share\\Rule\\TimeLimit.ini"
local TimeLimitRecTableName = "Time_Limit_Form_Rec"
local CountLimitRecTableName = "Count_Limit_Form_Rec"
local TimeLimitTable = {}
local CountLimitTable = {}
local TYPE_ERROR = 0
local TYPE_COMMON = 1
local TYPE_BANGPAI = 2
local TYPE_MENPAI = 3
local TYPE_JINDI = 4
local TYPE_SHILI = 5
local TYPE_DUOSHU = 6
local TYPE_CITAN = 7
local TYPE_FANGHUO = 8
local TYPE_YUNBIAO = 9
local TYPE_XUECHOU = 10
local TYPE_HUSHU = 11
local TYPE_XUNLUO = 12
local TYPE_HAIBU = 13
local TYPE_SANLEI = 14
local TYPE_XIASHI = 15
local TYPE_BANGFEI = 16
local TYPE_WULIN = 17
local TYPE_SHOULEI = 18
local TYPE_JIUHUO = 19
local TYPE_JIEFEI = 20
local TYPE_SHIMEN = 21
local TYPE_DALEI = 22
local TYPE_BATTLE = 23
local TYPE_JIUYINZHI_OLD = 24
local TYPE_WORLDWAR = 25
local TYPE_HUASHAN = 26
local LIMIT_TVT_BOSSHELER = 27
local TVT_TYPE_JHBOSS = 28
local TVT_TYPE_JHBOSS2 = 29
local TYPE_JIUYINZHI = 30
local TYPE_SCHOOLDANCE = 31
local TYPE_XUJIA_FISHING = 40
local TYPE_TAOHUA_PRESENT = 41
local TYPE_TAOHUA_ENEMY = 42
local TYPE_YHG_SHIER = 43
local TVT_YIHUA_DEF = 45
local TVT_WEATHER_WAR = 46
local TVT_WEATHER_SUBGROUP = 48
local TVT_GREED_ABDUCTOR = 49
local TVT_ZHONGQIU_ACTIVITY = 50
local TVT_GUILD_DOTA = 51
local TVT_WORLDWAR_COLLECT = 52
local TYPE_CROSSCLONE = 54
local TVT_TG_RANDOM_FIGHT = 55
local TVT_GMDD_TOTAL = 57
local TVT_GUMU_RESCUE = 59
local TVT_GUMU_KILL_RENEGADE = 60
local TVT_FOEMAN_INFALL = 64
local TVT_GUILD_STATION = 69
local TVT_CROSS_GUILD_WAR = 72
local TVT_NEW_TERRITORY_PVP_1 = 75
local TVT_NEW_TERRITORY_PVP_2 = 76
local TVT_XINMO = 79
local TYPE_SSG_SCHOOLMEET = 80
local TYPE_WUJIDAO = 81
local TYPE_WXJ_SCHOOLMEET_TEST = 82
local TYPE_WUXIAN_FETE = 83
local TYPE_DMP_SCHOOLMEET_TEST = 85
local TYPE_SONG_JING = 86
local TYPE_ACT_ESCORT = 87
local TYPE_YEAR_BOSS_ACT = 88
local TVT_OUTLAND_WAR = 91
local TVT_OUTLAND_WAR_GUIDE = 93
local TVT_SKY_HILL = 94
local TVT_PROTECT_SCHOOL = 97
local TYPE_SCHOOL_COUNTER_ATTACK = 98
local TVT_SCHOOL_EXTINCT_GUIDE = 99
local TYPE_GUILD_BOSS = 100
local TYPE_TEACH_EXAM = 101
local TYPE_ROYAL_TREASURE = 102
local TYPE_BALANCE_WAR = 103
local LIMIT_TVT_WUDAO_WAR = 104
local LIMIT_TVT_LUAN_DOU = 105
local TVT_MINGJIAO_DUILIAN = 106
local LIMIT_TVT_JYF_LOCAL_PLAYER = 107
local LIMIT_TVT_JYF_CROSS_PLAYER = 109
local LIMIT_TVT_WUDAO_YANWU = 112
local LIMIT_TVT_HORSE_RACE = 113
local LIMIT_TVT_SJY_SCHOOL_MEET = 114
local LIMIT_TVT_SHENJI_DRILL = 115
local LIMIT_TVT_MIDDLE_SPRING_HUNT = 116
local LIMIT_TVT_YUBI_ACTIVITY = 117
local LIMIT_TVT_GUILD_CHAMPION_WAR = 119
local LIMIT_TVT_GUILD_CHAMPION_TJ = 120
local LIMIT_TVT_MAZE_HUNT = 121
local LIMIT_TVT_XMG_SCHOOL_MEET = 122
local LIMIT_TVT_DEFEND_YG = 123
local LIMIT_TVT_LEAGUE_MATCHES = 124
local TYPE_MAX = 125

local TYPEINFO = {
    [TYPE_COMMON] = {
        -1,
        "",
        0
    },
    [TYPE_BANGPAI] = {
        ITT_BANGPAIZHAN,
        "ui_Type2",
        0
    },
    [TYPE_MENPAI] = {
        ITT_MENPAIZHAN,
        "ui_Type3",
        0
    },
    [TYPE_JINDI] = {
        -1,
        "ui_Type4",
        1
    },
    [TYPE_SHILI] = {
        -1,
        "ui_Type5",
        1
    },
    [TYPE_DUOSHU] = {
        ITT_DUOSHU,
        "ui_Type6",
        1
    },
    [TYPE_CITAN] = {
        ITT_SPY_MENP,
        "ui_Type7",
        1
    },
    [TYPE_FANGHUO] = {
        ITT_FANGHUO,
        "ui_Type8",
        1
    },
    [TYPE_YUNBIAO] = {
        ITT_YUNBIAO,
        "ui_Type9",
        0
    },
    [TYPE_XUECHOU] = {
        -1,
        "ui_xuechou_title",
        0
    },
    [TYPE_HUSHU] = {
        ITT_HUSHU,
        "ui_Type19",
        1
    },
    [TYPE_XUNLUO] = {
        ITT_PATROL,
        "ui_Type20",
        1
    },
    [TYPE_HAIBU] = {
        ITT_ARREST,
        "ui_Type10",
        0
    },
    [TYPE_SANLEI] = {
        ITT_WORLDLEITAI,
        "ui_Type11",
        1
    },
    [TYPE_XIASHI] = {
        ITT_XIASHI,
        "ui_Type12",
        0
    },
    [TYPE_BANGFEI] = {
        ITT_BANGFEI,
        "ui_Type13",
        0
    },
    [TYPE_WULIN] = {
        ITT_WORLDLEITAI_RANDOM,
        "ui_Type14",
        1
    },
    [TYPE_SHOULEI] = {
        ITT_SHOULEI,
        "ui_Type15",
        0
    },
    [TYPE_JIUHUO] = {
        ITT_JIUHUO,
        "ui_Type16",
        1
    },
    [TYPE_JIEFEI] = {
        ITT_JIEBIAO,
        "ui_Type17",
        0
    },
    [TYPE_SHIMEN] = {
        ITT_SHIMEN,
        "ui_Type18",
        0
    },
    [TYPE_DALEI] = {
        ITT_DALEI,
        "ui_Type15",
        0
    },
    [TYPE_BATTLE] = {
        -1,
        "ui_battlefield",
        1
    },
    [TYPE_WORLDWAR] = {
        -1,
        "ui_worldwar",
        0
    },
    [TYPE_HUASHAN] = {
        -1,
        "ui_Type26",
        0
    },
    [LIMIT_TVT_BOSSHELER] = {
        -1,
        "ui_random_clone",
        1
    },
    [TYPE_JIUYINZHI] = {
        -1,
        "ui_jyz_type30_01",
        0
    },
    [TYPE_SCHOOLDANCE] = {
        ITT_SCHOOL_DANCE,
        "ui_school_dance",
        0
    },
    [TYPE_XUJIA_FISHING] = {
        -1,
        "ui_xujia_fishing",
        0
    },
    [TYPE_TAOHUA_PRESENT] = {
        -1,
        "ui_taohua_present_scene",
        0
    },
    [TYPE_TAOHUA_ENEMY] = {
        -1,
        "ui_taohua_enemy_scene",
        0
    },
    [TYPE_YHG_SHIER] = {
        -1,
        "ui_yhg_twelvedock",
        1
    },
    [TVT_WEATHER_WAR] = {
        -1,
        "tianqi_jianghu_1",
        1
    },
    [TVT_WEATHER_SUBGROUP] = {
        -1,
        "tianqi_subgroup",
        1
    },
    [TVT_GREED_ABDUCTOR] = {
        -1,
        "tvt_abduct_1",
        0
    },
    [TVT_ZHONGQIU_ACTIVITY] = {
        -1,
        "zhongqiu_type",
        1
    },
    [TVT_WORLDWAR_COLLECT] = {
        -1,
        "ui_lxc_collect",
        0
    },
    [TYPE_CROSSCLONE] = {
        -1,
        "ui_Type4",
        1
    },
    [TVT_TG_RANDOM_FIGHT] = {
        -1,
        "ui_Type55",
        0
    },
    [TVT_GMDD_TOTAL] = {
        -1,
        "ui_Type57",
        0
    },
    [TVT_GUMU_RESCUE] = {
        -1,
        "ui_Type59",
        0
    },
    [TVT_GUMU_KILL_RENEGADE] = {
        -1,
        "ui_gmp_smdh_wf_06",
        1
    },
    [TVT_FOEMAN_INFALL] = {
        -1,
        "ui_Type64",
        1
    },
    [TVT_XINMO] = {
        TVT_XINMO,
        "ui_Type79",
        1
    },
    [TVT_CROSS_GUILD_WAR] = {
        -1,
        "ui_guild_kuafu_001",
        1
    },
    [TVT_NEW_TERRITORY_PVP_1] = {
        -1,
        "ui_dhpvp_title_001",
        1
    },
    [TVT_NEW_TERRITORY_PVP_2] = {
        -1,
        "ui_dhpvp_title_002",
        1
    },
    [TYPE_SSG_SCHOOLMEET] = {
        -1,
        "ui_Type80",
        1
    },
    [TYPE_WUJIDAO] = {
        -1,
        "ui_Type81",
        1
    },
    [TYPE_WXJ_SCHOOLMEET_TEST] = {
        -1,
        "ui_Type82",
        1
    },
    [TYPE_WUXIAN_FETE] = {
        -1,
        "ui_Type83",
        0
    },
    [TYPE_DMP_SCHOOLMEET_TEST] = {
        -1,
        "ui_Type85",
        1
    },
    [TYPE_SONG_JING] = {
        -1,
        "ui_Type86",
        1
    },
    [TYPE_ACT_ESCORT] = {
        ITT_ACTIVE_ESCORT,
        "ui_Type87",
        1
    },
    [TYPE_YEAR_BOSS_ACT] = {
        ITT_YEAR_BOSS_ACT,
        "ui_type_yearboss",
        1
    },
    [TVT_OUTLAND_WAR] = {
        ITT_OUTLAND_WAR,
        "ui_Type91",
        1
    },
    [TVT_OUTLAND_WAR_GUIDE] = {
        -1,
        "ui_type_outland_war_guide",
        0
    },
    [TVT_SKY_HILL] = {
        ITT_SKY_HILL,
        "ui_type_skyhill",
        1
    },
    [TVT_PROTECT_SCHOOL] = {
        ITT_PROTECT_SCHOOL,
        "ui_type_protect_school",
        1
    },
    [TYPE_SCHOOL_COUNTER_ATTACK] = {
        ITT_SCHOOL_COUNTER_ATTACK,
        "ui_type_school_counter_attack",
        1
    },
    [TVT_SCHOOL_EXTINCT_GUIDE] = {
        -1,
        "ui_type_school_extinct_guide",
        0
    },
    [TYPE_GUILD_BOSS] = {
        ITT_GUILD_BOSS,
        "ui_type_guild_boss",
        0
    },
    [TYPE_TEACH_EXAM] = {
        ITT_TEACH_EXAM,
        "ui_type_teach_exam",
        1
    },
    [TYPE_ROYAL_TREASURE] = {
        -1,
        "ui_type_royal_treasure",
        1
    },
    [TYPE_BALANCE_WAR] = {
        ITT_BALANCE_WAR,
        "jsq_balance_war",
        1
    },
    [LIMIT_TVT_WUDAO_WAR] = {
        ITT_WUDAO_WAR,
        "ui_wudaodahui_headtitle",
        1
    },
    [LIMIT_TVT_LUAN_DOU] = {
        ITT_LUAN_DOU,
        "tips_chos_war_tips",
        1
    },
    [TVT_MINGJIAO_DUILIAN] = {
        -1,
        "ui_mingjiaoduilian_title",
        0
    },
    [LIMIT_TVT_JYF_LOCAL_PLAYER] = {
        -1,
        "tips_jiuyang_faculty",
        0
    },
    [LIMIT_TVT_JYF_CROSS_PLAYER] = {
        -1,
        "tips_jiuyang_faculty",
        1
    },
    [LIMIT_TVT_WUDAO_YANWU] = {
        ITT_WUDAO_YANWU,
        "tips_testskill_tips",
        1
    },
    [LIMIT_TVT_HORSE_RACE] = {
        ITT_HORSE_RACE,
        "tips_horse_race_tips",
        1
    },
    [LIMIT_TVT_SJY_SCHOOL_MEET] = {
        ITT_SJY_MEET,
        "tips_sjy_school_met_tips",
        1
    },
    [LIMIT_TVT_SHENJI_DRILL] = {
        ITT_SHENJI_DRILL,
        "tips_sjy_drill",
        1
    },
    [LIMIT_TVT_MIDDLE_SPRING_HUNT] = {
        ITT_MIDDLE_SPRING_HUNT,
        "tips_middle_spring_hunt",
        1
    },
    [LIMIT_TVT_YUBI_ACTIVITY] = {
        ITT_YUBI_ACTIVITY,
        "tips_yubi_activity",
        1
    },
    [LIMIT_TVT_GUILD_CHAMPION_WAR] = {
        -1,
        "tips_guild_champion_war",
        1
    },
    [LIMIT_TVT_MAZE_HUNT] = {
        ITT_MAZE_HUNT_HILL,
        "tips_maze_hunt_activity",
        1
    },
    [LIMIT_TVT_XMG_SCHOOL_MEET] = {
        ITT_XMG_MEET,
        "tips_xmg_school_met_tips",
        1
    },
    [LIMIT_TVT_DEFEND_YG] = {
        -1,
        "tips_dyyg_tips",
        0
    },
    [LIMIT_TVT_LEAGUE_MATCHES] = {
        -1,
        "tips_bhls_tips",
        1
    }
}
function show_form()
    create_timelimit_table()
    create_countlimit_table()
    for i = 1, TYPE_MAX - 1 do
        if i ~= 99 and i ~= 55 then
            local time_num, count_num = GetItemNum(nx_number(i))
            local itmecount = time_num + count_num
            local instanceid = nx_string(FormInstanceID) .. nx_string(i)
            if itmecount > 0 then
                local form =
                    nx_execute(
                    "util_gui",
                    "util_get_form",
                    "form_stage_main\\form_common_notice",
                    true,
                    false,
                    instanceid
                )
                if nx_is_valid(form) then
                    form.BelongType = i
                    update_info(form)
                    local type_info = TYPEINFO[form.BelongType]
                    if type_info ~= nil and table.getn(type_info) >= 2 then
                        local gui = nx_value("gui")
                        form.lbl_title.Text = nx_widestr(gui.TextManager:GetText(type_info[2]))
                    end
                    if nx_number(time_num) > 0 then
                        init_timer(form)
                    end
                    form:Show()
                    if nx_find_custom(form, "showformflag") then
                        form.Visible = form.showformflag
                    end
                    local gui = nx_value("gui")
                    if type_info == nil or type_info[1] == nil or type_info[1] == -1 then
                        form.btn_tvt.Visible = false
                    end
                    if type_info == nil or type_info[3] == nil or type_info[3] == 0 then
                        form.btn_quit.Visible = false
                    end
                    if type_info ~= nil and type_info[4] ~= nil and type_info[4] ~= "" then
                        form.btn_show.NormalImage = type_info[4]
                        form.btn_show.FocusImage = type_info[5]
                        form.btn_show.PushImage = type_info[6]
                    end
                    local time_num, count_num = GetItemNum(nx_number(i))
                    change_form_size(form, time_num, count_num)
                end
            else
                local form =
                    nx_execute(
                    "util_gui",
                    "util_get_form",
                    "form_stage_main\\form_common_notice",
                    false,
                    false,
                    instanceid
                )
                if nx_is_valid(form) then
                    form:Close()
                end
            end
        end
    end
end
