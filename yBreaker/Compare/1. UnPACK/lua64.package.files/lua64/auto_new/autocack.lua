require('utils')
require('util_gui')
require('util_move')
require('tips_data')
require('util_functions')
require('game_object')
require('const_define')
require('player_state\\state_const')
require('player_state\\logic_const')
require("player_state\\state_input")
require('define\\sysinfo_define')
require('define\\request_type')
require('share\\chat_define')
require('share\\client_custom_define')
require('share\\logicstate_define')
require('share\\view_define')
require('share\\capital_define')
require('share\\itemtype_define')
require('form_stage_main\\form_battlefield\\battlefield_define')
require("form_stage_main\\form_tvt\\define")
require("form_stage_main\\form_task\\task_define")
require('util_static_data')
require('define\\team_rec_define')
require('auto_new\\auto_text')
AUTO_VERSION = '2.8.5' 
AUTO_DELAY_CPU_NOT_RUN = false
AUTO_DELAY_TIME_CPU = 0
AUTO_VER_SPECIAL = 'AUTO_SPECIAL' --'AUTO_SPECIAL'AUTO_NORMAL
FORM_LOADING = 'form_common\\form_loading' 
FORM_GOTO_COVER = 'form_stage_main\\form_goto_cover' 
FORM_MAIN_CURSELOADING = 'form_stage_main\\form_main\\form_main_curseloading'
FORM_MAIN_REQUEST = 'form_stage_main\\form_main\\form_main_request'
FORM_HOME_POINT = 'form_stage_main\\form_homepoint\\form_home_point'
HOME_POINT_DATA = 'form_stage_main\\form_homepoint\\home_point_data'
FORM_DROPPICK = 'form_stage_main\\form_pick\\form_droppick'
FORM_FISH = 'form_stage_main\\form_life\\form_fishing_op'
FORM_MAIN_SHORTCUT = 'form_stage_main\\form_main\\form_main_shortcut'
FORM_MAIN_SHORTCUT_RIDE = 'form_stage_main\\form_main\\form_main_shortcut_ride'
FORM_ESCORT = 'form_stage_main\\form_school_war\\form_escort'
FORM_ESCORTNPC_CONTROL_LIST = 'form_stage_main\\form_school_war\\form_escortnpc_control_list'
FORM_TALK_MOVIE = 'form_stage_main\\form_talk_movie'
GAME_GUI_MAIN = 'form_stage_main\\form_main\\form_main'
FORM_MAIN_REQUEST = 'form_stage_main\\form_main\\form_main_request'
FORM_BATTLEFIELD_REWARD = 'form_stage_main\\form_battlefield\\form_battlefield_reward'
FORM_BATTLEFIELD_JOIN = 'form_stage_main\\form_battlefield\\form_battlefield_join'
FORM_HURT_DANGER = 'form_stage_main\\form_hurt_danger'
FORM_DIE_BATTLEFIELD = 'form_stage_main\\form_die_battlefield'
FORM_SHOP = 'form_stage_main\\form_shop\\form_shop'
FORM_GIVE = 'form_stage_main\\form_give_item'
FORM_MAP_SCENE= 'form_stage_main\\form_map\\form_map_scene'
FORM_BAG = 'form_stage_main\\form_bag'
FORM_DIE = 'form_stage_main\\form_die'
FORM_NOTICE_SHORTCUT = 'form_stage_main\\form_main\\form_notice_shortcut'
FORM_SINGLE_NOTICE = 'form_stage_main\\form_single_notice'
FORM_GM_CHAT = 'form_stage_main\\form_gmcc\\form_gmcc_chat'
FORM_TVT_SKILL = 'form_stage_main\\form_tvt\\form_tvt_skill'
SKILL_STATIC_INI = 'share\\Skill\\skill_static.ini'
FORM_TIGUAN_ONE = 'form_stage_main\\form_tiguan\\form_tiguan_one'
FORM_TIGUAN_TRACE  = 'form_stage_main\\form_tiguan\\form_tiguan_ds_trace'
FORM_TIGUAN_DETAIL  = 'form_stage_main\\form_tiguan\\form_tiguan_detail'
FORM_TIGUAN_READY = 'form_stage_main\\form_tiguan\\form_tiguan_ready'
FORM_TVT_TIGUAN = 'form_stage_main\\form_tvt\\form_tvt_tiguan'
FORM_TIGUAN_GO = 'form_stage_main\\form_tiguan\\form_tiguan_go'
FORM_STALL_MAIN = 'form_stage_main\\form_stall\\form_stall_main'
FORM_GENERAL_INFO_MAIN = 'form_stage_main\\form_general_info\\form_general_info_main'
FORM_MATCH = 'form_stage_main\\form_match\\form_match'
FORM_MATCH_REVENGE_REWARD = 'form_stage_main\\form_match\\form_match_Weekreward'
FORM_AUTO_AI = 'auto_new\\form_auto_ai_new'
FORM_AUTO_AI_NEW = 'auto_new\\form_auto_ai'
FORM_AUTO_SKILL = 'auto_new\\form_auto_skill'
FORM_MAIN_SELECT = 'form_stage_main\\form_main\\form_main_select'
FORM_LOGIN = 'form_stage_login\\form_login'
FORM_FACULTY_TEAM = 'form_stage_main\\form_wuxue\\form_team_faculty_member'
auto_pick_item_load_check = false
get_pick_item_check = function()
	return auto_pick_item_load_check
end
set_pick_item_check = function(value)
	auto_pick_item_load_check = value
end

function break_parry_auto()
	if nx_running('auto_new\\auto_special_lib', 'auto_start_undef') then
		nx_kill('auto_new\\auto_special_lib', 'auto_start_undef') 		
		showUtf8Text(auto_stop_def_classic)
	else 		
		nx_execute('auto_new\\auto_special_lib', 'auto_start_undef')
		showUtf8Text(auto_start_def_classic)
	end
end
function auto_bug_quat()
	if nx_running('auto_new\\auto_special_lib', 'auto_start_stop_quat') then
		nx_kill('auto_new\\auto_special_lib', 'auto_start_stop_quat') 		
		showUtf8Text(auto_stop_bug_quat)
	else 		
		nx_execute('auto_new\\auto_special_lib', 'auto_start_stop_quat')
		showUtf8Text(auto_start_bug_quat)
	end
end

---------------function ArrayList------------------

data_boss_err = {
  ["bosstg03001"]="340.734009,80.789001,814.367981;336.11499,80.039001,812.830933",
  ["bosstg03004"]="315.075012,77.473999,843.510986;319.04422,77.461411,843.615417",
  ["bosstg03005"]="305.25201416016,78.082000732422,852.49700927734;308.160675,77.461411,842.004395",
  ["bosstg03008"]="339.673004,80.735001,814.960999;335.298492,80.039001,812.472656",
  ["bosstg03009"]="340.519989,80.735001,813.356018;335.791565,80.039001,813.058228",
  ["bosstg28001"]="96.499001,-3.726,316.932007;88.721565,-3.728,317.060181",
  ["bosstg28002"]="84.081001,-3.758,401.67099;86.438858,-3.759,395.319275",
  ["bosstg28003"]="54.707001,-7.46,291.997009;44.971172,-7.460211,297.435699",
  ["bosstg28004"]="61.005001,-7.46,301.891998;53.062046,-7.460211,308.240234",
  ["bosstg28005"]="93.274002,-3.73,316.953003;88.789139,-3.728,317.341309",
  ["bosstg02001"]="283.187012,42.587002,1127.953003;286.375427,42.398136,1115.780762",
  ["bosstg02002"]="251.882004,46.655998,1054.958984;256.076172,46.655567,1061.256958",
  ["bosstg02003"]="283.097992,42.598,1127.968018;286.565063,42.398136,1113.785767",
  ["bosstg02004"]="283.212006,42.587002,1127.895996;287.068115,42.398136,1112.823975",
  ["bosstg02005"]="250.199005,46.655998,1050.800049;253.30159,46.655567,1056.21167",
  ["bosstg07003"]="148.869003,20.344,1478.876953;149.06308,19.804461,1463.028198",
  ["bosstg07004"]="150.382996,20.344,1478.45105;144.991318,19.804461,1464.182251",
  ["bosstg07001"]="134.537003,19.844,1437.94104;131.680099,18.633001,1425.852661",
  ["bosstg07002"]="137.820007,19.922001,1436.887939;133.834106,18.633001,1425.262207",
  ["bosstg29001"]="1086.680054,46.458,379.653015;1078.979004,44.508533,372.907501",
  ["bosstg29002"]="1059.119019,45.618999,429.953003;1060.298096,45.618004,421.698517",
  ["bosstg29003"]="1058.300049,45.641998,429.614014;1059.151367,45.622002,421.517517",
  ["bosstg29004"]="1080.977051,46.452,408.756012;1066.394775,44.508533,413.475525",
  ["bosstg29005"]="1041.766968,46.466,423.691986;1039.767578,46.466003,425.482056",
  ["bosstg29006"]="1080.938965,46.452,410.373993;1067.784546,44.508533,413.609711",
  ["bosstg04001"]="578.353027,39.367001,254.852005;585.033752,38.617001,251.229721",
  ["bosstg04002"]="591.828979,38.916,241.130005;589.123108,38.617001,249.597733",
  ["bosstg04003"]="594.89801,38.916,240.992004;588.631653,38.617001,250.401855",
  ["bosstg04004"]="580.091003,38.722,247.205994;585.239014,38.617001,247.170731",
  ["bosstg04005"]="607.163025,38.616001,260.597992;606.843933,38.617001,253.334854",
  ["bosstg27001"]="-187.472,174.834,710.575989;-188.594849,172.091248,729.976379",
  ["bosstg27002"]="-188.977997,174.834,710.502991;-188.977997,174.834,710.502991",
  ["bosstg27003"]="-146.026993,172.865005,727.388;-148.80809,172.670685,741.384338",
  ["bosstg27004"]="-187.778,173.320999,716.370972;-188.08975219727,172.373046875,726.22277832031",
  ["bosstg27005"]="-179.701004,172.102997,775.44397;-174.093689,172.35759,785.546387",
  ["bosstg27006"]="-255.718994,179.546005,754.39502;-246.466202,178.40744,750.235046",
  ["bosstg11001"]="382.264008,88.153,1006.195007;376.398834,85.394234,993.715698",
  ["bosstg11002"]="404.134003,87.094002,996.661011;404.643799,87.094002,992.540466",
  ["bosstg11003"]="338.358002,87.095001,1006.343994;338.892853,85.394234,990.890869",
  ["bosstg11004"]="383.127014,88.153,1006.280029;377.036499,85.394234,992.243469",
  ["bosstg11005"]="381.411987,88.153,1006.169006;378.443085,85.394234,994.578552",
  ["bosstg01001"]="1344.0059814453,86.59400177002,706.79797363281;1347.072388,86.594002,704.544434",
  ["bosstg01103"]="1320.9949951172,83.762001037598,652.82598876953;1320.198975,82.594025,671.329102",
  ["bosstg01101"]="1266.6330566406,84.026000976563,679.51300048828;1254.334106,84.106003,677.983582",
  ["bosstg01201"]="1366.7829589844,82.59400177002,637.87200927734;1357.126221,82.594025,639.200195",
  ["bosstg01102"]="1344.0059814453,86.59400177002,706.79797363281;1347.072388,86.594002,704.544434",
  ["bosstg01202"]="1297.255,82.595,637.672;1292.523682,82.594025,642.609802",
  ["bosstg30001"]="846.22302246094,-4.7870001792908,694.09600830078;845.961914,-6.311,704.752808",
  ["bosstg30002"]="880.28698730469,-6.3790001869202,697.37701416016;884.528992,-6.378803,718.674622",
  ["bosstg30003"]="956.94299316406,-6.2729997634888,736.8740234375;947.2323,-6.572973,737.656555",
  ["bosstg30005"]="900.91497802734,-5.5170001983643,753.21099853516;893.516296,-6.737,752.623901",
  ["bosstg30006"]="845.34899902344,-4.7870001792908,694.47198486328;846.534851,-6.311,705.295532",
  ["bosstg06001"]="-363.14498901367,37.687999725342,-318.18399047852;-354.215424,37.336002,-311.33905",
  ["bosstg06002"]="-364.08499145508,37.687999725342,-315.62298583984;-356.335876,37.336002,-311.377197",
  ["bosstg06003"]="-362.44299316406,37.687999725342,-320.06100463867;-353.905548,37.336002,-311.937622",
  ["bosstg06004"]="-363.04800415039,37.687999725342,-317.71701049805;-352.20636,37.336002,-311.844788",
  ["bosstg06007"]="-362.550995,37.688,-319.065002;-352.183197,37.336002,-310.880432",
  ["bosstg06008"]="-321.57598876953,38.917999267578,-300.29501342773;-320.11096191406,38.917003631592,-300.33944702148",
  ["bosstg13001"]="964.95001220703,78.152000427246,476.44000244141;959.552368,78.152397,488.709747",
  ["bosstg13002"]="923.53497314453,78.152000427246,501.0419921875;932.921753,78.152397,490.20816",
  ["bosstg13005"]="948.44000244141,78.152000427246,492.53100585938;936.609924,78.152397,484.716858",
  ["bosstg13006"]="946.22100830078,78.152000427246,493.32501220703;934.213257,78.152397,483.683197",
  ["bosstg13007"]="1091.0589599609,81.273002624512,494.19000244141;1075.224731,81.272446,496.42395",
  ["bosstg13008"]="1088.3649902344,81.273002624512,445.92401123047;1077.539185,81.353775,463.519592",
  ["bosstg12001"]="-260.81201171875,43.374000549316,469.95098876953;-240.96402,42.241001,470.902344",
  ["bosstg12002"]="-274.31201171875,39.287998199463,565.43298339844;-275.828644,39.290001,570.130676",
  ["bosstg12004"]="-242.55999755859,39.287998199463,591.03302001953;-225.192383,39.269001,582.824768",
  ["bosstg12005"]="-262.37701416016,43.374000549316,469.87899780273;-243.329865,42.241001,470.385773",
  ["bosstg12003"]="-266.99899291992,42.444000244141,411.50799560547;-251.86702,41.2668,413.228241",
  ["bosstg12006"]="-262.32000732422,43.374000549316,471.59399414063;-245.26683,42.241001,471.297729",
  ["bosstg31001"]="1127.4270019531,45.041000366211,653.16400146484;1127.21521,45.041,660.992004",
  ["bosstg31002"]="1128.20703125,45.041000366211,652.19500732422;1130.425171,45.041,645.566833",
  ["bosstg31004"]="954.96997070313,62.680999755859,781.39898681641;958.964172,62.681004,774.724487",
  ["bosstg31003"]="1127.29296875,45.041000366211,652.26501464844;1129.697388,45.041,645.562561",
  ["bosstg31005"]="954.2509765625,62.680999755859,781.05401611328;959.345459,62.681004,776.172791",
  ["bosstg31009"]="954.71997070313,47.775001525879,543.71301269531;954.639954,44.790001,561.749023",
  ["bosstg23001"]="1454.9360351563,108.74800109863,-63.186000823975;1448.086304,108.749008,-61.455872",
  ["bosstg23004"]="1454.9739990234,108.74800109863,-63.576999664307;1447.834351,108.749008,-61.093658",
  ["bosstg23005"]="1454.7640380859,110.79599761963,-109.59899902344;1455.093994,108.143005,-95.870277",
  ["bosstg23007"]="1454.8909912109,108.2620010376,-147.82400512695;1454.130249,108.262009,-138.482315",
  ["bosstg23002"]="1454.7640380859,110.79599761963,-109.46399688721;1455.163208,108.143005,-95.339592",
  ["bosstg23003"]="1521.4229736328,108.15200042725,-139.39399719238;1518.949707,108.152008,-130.189713",
  ["bosstg17001"]="-15.651,37.113,821.118;-7.776051,36.534,810.171204",
  ["bosstg17004"]="-38.685001373291,26.114000320435,735.3759765625;-30.685383,26.091002,734.046387",
  ["bosstg17006"]="-63.504001617432,34.861999511719,764.29400634766;-51.745102,33.642002,773.207458",
  ["bosstg17007"]="-62.938999176025,34.863998413086,763.59197998047;-53.552254,33.639,772.040466",
  ["bosstg17005"]="-12.055999755859,36.583000183105,819.24102783203;-8.250524,36.534,809.673096",
  ["bosstg17008"]="-14.744999885559,36.537998199463,816.87200927734;-6.664351,36.534,811.470032",
  ["bosstg20001"]="809.6669921875,-18.818000793457,44.698001861572;809.667236,-18.817001,44.697979",
  ["bosstg20004"]="809.68701171875,-18.818000793457,44.845001220703;809.667236,-18.817001,44.697979",
  ["bosstg20007"]="809.78802490234,-18.818000793457,44.887001037598;809.687012,-18.817001,44.845001",
  ["bosstg20011"]="809.75897216797,-18.818000793457,44.863998413086;809.687012,-18.817001,44.845001",
  ["bosstg20006"]="809.67498779297,-18.818000793457,44.721000671387;809.687012,-18.817001,44.845001",
  ["bosstg20009"]="809.80401611328,-18.818000793457,44.877998352051;809.674988,-18.817001,44.721001",
  ["bosstg20003"]="809.84399414063,-18.818000793457,44.768001556396;809.804016,-18.817001,44.877998",
  ["bosstg18001"]="359.53399658203,-124.8450012207,1611.6280517578;363.863525,-124.846008,1612.044556",
  ["bosstg18002"]="304.89700317383,-141.75,1404.8370361328;303.734375,-143.695236,1393.614258",
  ["bosstg18003"]="422.80899047852,-141.88299560547,1526.8979492188;406.822388,-143.695236,1527.019531",
  ["bosstg18004"]="261.47299194336,-136.92500305176,1439.1700439453;262.034821,-136.924011,1433.125854",
  ["bosstg18006"]="288.62799072266,-141.49200439453,1352.9909667969;304.083313,-143.628006,1353.407471",
  ["bosstg18013"]="356.42300415039,-139.88400268555,1414.5880126953;361.162018,-141.889679,1404.44043",
  ["bosstg18014"]="358.56201171875,-139.88400268555,1414.7060546875;352.142365,-141.889679,1401.967285",
  ["bosstg19001"]="1407.5550537109,18.923000335693,2174.0009765625;1408.2261962891,18.258001327515,2184.6181640625",
  ["bosstg19002"]="1407.9460449219,18.787000656128,2173.6740722656;1408.2261962891,18.258001327515,2184.6181640625",
  ["bosstg19003"]="1049.4000244141,18.951000213623,2179.5;1049.1518554688,17.201021194458,2190.0744628906",
  ["bosstg19004"]="1279.875,18.683000564575,2333.4699707031;1281.1198730469,17.201021194458,2340.6750488281",
  ["bosstg19005"]="1068.6999511719,16.57200050354,2278.8999023438;1068.5317382813,16.087381362915,2269.2314453125",
  ["bosstg19006"]="1169.8859863281,18.063999176025,2259.7260742188;1169.7338867188,17.249000549316,2253.9067382813",
  ["bosstg19007"]="1170.0219726563,18.143999099731,2259.7670898438;1169.7338867188,17.249000549316,2253.9067382813",
  ["bosstg05004"]="412.88900756836,122.34999847412,119.61199951172;404.43936157227,122.38000488281,120.78707122803",
  ["bosstg05001"]="276.367,130.760,117.868;275.55102539063,130.7320098877,115.3062286377",
  ["bosstg05008"]="363.86999511719,122.31800079346,45.053001403809;361.42510986328,122.40300750732,45.077972412109",
  ["bosstg05010"]="180.08799743652,123.88999938965,61.951000213623;183.37394714355,123.88924407959,65.32755279541",
  ["bosstg05007"]="170.60000610352,125.06800079346,139.04600524902;170.49346923828,123.82600402832,128.58735656738",
  ["bosstg05003"]="162.46099853516,124.72899627686,120.15599822998;173.51055908203,123.82600402832,119.17123413086",
  ["bosstg05005"]="162.3509979248,124.72899627686,119.48000335693;173.51055908203,123.82600402832,119.17123413086",
  ["bosstg16001"]="875.61499,37.790001,873.380981;869.361816,34.729,859.00293",
  ["bosstg16002"]="849.234009,35.931999,862.862976;853.940979,34.571587,853.31366",
  ["bosstg16004"]="885.825012,35.792,847.481995;875.340515,34.571587,843.779541",
  ["bosstg16006"]="874.247009,37.785,874.20697;867.555481,34.811001,855.588745",
  ["bosstg16003"]="860.921997,37.791,875.697998;867.392334,37.785004,877.635681",
  ["bosstg16005"]="887.288025,37.791,864.612;883.455688,37.785004,871.013611",
  ["bosstg16007"]="876.830017,37.785,872.773987;867.703308,34.811001,855.494568",
  ["bosstg32001"]="1219.4050292969,34.138999938965,928.62799072266;1217.225,34.140,928.734",
  ["bosstg32002"]="1221.5109863281,34.150001525879,928.375;1217.225,34.140,928.734",
  ["bosstg32003"]="1242.1689453125,30.697999954224,872.54699707031;1241.256,30.701,884.621",
  ["bosstg32004"]="1242.0560302734,30.767999649048,982.86798095703;1242.823,30.770,972.353",
  ["bosstg32005"]="1128.0419921875,31.819999694824,928.11401367188;1098.608,26.232,927.430",
  ["bosstg32006"]="1127.7619628906,31.819999694824,927.98199462891;1098.608,26.232,927.430",
  ["bosstg25001"]="-782.35998535156,24.075000762939,733.375;-780.119,19.643,706.361",
  ["bosstg25002"]="-780.9169921875,24.075000762939,733.37298583984;-780.119,19.643,706.361",
  ["bosstg25003"]="-779.23101806641,24.075000762939,733.59600830078;-780.119,19.643,706.361",
  ["bosstg25004"]="-789.75598144531,21.277000427246,817.05603027344;-773.286,21.278,807.655",
  ["bosstg25005"]="-795.50598144531,22.718999862671,807.65399169922;-773.286,21.278,807.655",
  ["bosstg25006"]="-708.45501708984,23.264999389648,758.99499511719;-726.026,21.563,763.878",
  --["bosstg21001"]="-607.50299072266,93.353996276855,970.7509765625;-565.763,63.684,932.581",
  ["bosstg21002"]="-329.11700439453,41.571998596191,890.666015625;-321.37564086914,39.675933837891,882.97479248047",
  ["bosstg21003"]="-223.51699829102,16.857000350952,905.01599121094;-232.78889465332,14.876901626587,896.76397705078",
  ["bosstg21004"]="-528.28497314453,66.767997741699,898.10198974609;-519.10540771484,63.683689117432,888.884521484382",
  ["bosstg21005"]="-606.57098388672,93.355003356934,972.23498535156;-600.07440185547,93.353721618652,992.52282714844",
  ["bosstg21006"]="-224.78900146484,16.857000350952,906.43402099609;-232.44958496094,14.876899719238,897.94873046875",
  ["bosstg21007"]="-605.07598876953,93.355003356934,974.47302246094;-599.71710205078,93.353721618652,991.62976074219",
  ["bosstg26001"]="253.41799926758,10.781999588013,1082.5860595703;260.04895019531,9.5989980697632,1077.1423339844",
  ["bosstg26002"]="242.45799255371,12.508999824524,991.7080078125;255.93478393555,12.467469215393,984.70202636719",
  ["bosstg26003"]="243.7740020752,12.465999603271,992.44097900391;255.93478393555,12.467469215393,984.70202636719",
  ["bosstg26004"]="243.52099609375,12.413000106812,992.01702880859;255.93478393555,12.467469215393,984.70202636719",
  ["bosstg26005"]="242.87699890137,12.475999832153,991.27197265625;255.93478393555,12.467469215393,984.70202636719",
  ["bosstg26006"]="353.13900756836,10.604999542236,1024.1929931641;367.125,8.061,1013.853",
  ["bosstg26007"]="231.73100280762,7.9739999771118,1045.2459716797;228.190,7.923,1028",
}
function schoolDanceMapData(map)		
	if map == 'city05' then
		return {
		scene_id = 'city05',
		npc_id = 'SMSY_School09',		
		}
	end
	if map == 'city04' then
		return {
		scene_id = 'city04',
		npc_id = 'SMSY_School10',		
		}
	end	
	if map == 'school01' then
		return {
		scene_id = 'school01',
		npc_id = 'SMSY_School01',
		
		}
	end
	if map == 'school02' then
		return {
		scene_id = 'school02',
		npc_id = 'SMSY_School02',
		
		}
	end
	if map == 'school03' then
		return {
		scene_id = 'school03',
		npc_id = 'SMSY_School03',		
		}
	end
	if map == 'school04' then
		return {
		scene_id = 'school04',
		npc_id = 'SMSY_School04',		
		}
	end
	if map == 'school05' then
		return {
		scene_id = 'school05',
		npc_id = 'SMSY_School05',		
		}
	end
	if map == 'school06' then
		return {
		scene_id = 'school06',
		npc_id = 'SMSY_School06'		
		}
	end
	if map == 'school07' then
		return {
		scene_id = 'school07',
		npc_id = 'SMSY_School07'	
		}
	end
	if map == 'school08' then
		return {
		scene_id = 'school08',
		npc_id = 'SMSY_School08'		
		}
	end
	if map == 'school20' then    
		return {
		scene_id = 'school20',
		npc_id = 'SMSY_School20',
		}	   
	end
	if map == 'school22' then    
		return {
		scene_id = 'school22',
		npc_id = 'SMSY_School22',
		}	   
	end	   
	return nil
end	
auto_skill_start_stop = false
set_skill_start_stop = function(value)
	auto_skill_start_stop = value
end
get_skill_start_stop = function()
	return auto_skill_start_stop
end
get_auto_ai_info = function()
	return AUTO_AI_ARRAY
end
get_pick_item_auto = function(list_item,item_name)
	if isExistInStringList(list_item,item_name) then--string.find(list_item, item_name, 1, true) ~= nil then
		return true
	end
	return false
end
utf8ToWstr = function(content)
	return nx_function('ext_utf8_to_widestr', content)
end 
wstrToUtf8 = function(content)
	return nx_function('ext_widestr_to_utf8', content)
end 
showText = function(str, mode)
	if not str then return end
	local SystemCenterInfo = nx_value('SystemCenterInfo')
	if nx_is_valid(SystemCenterInfo) then
		if not mode then mode = 3 end
		SystemCenterInfo:ShowSystemCenterInfo(nx_widestr(str), mode)
	end
end 
showCodeText = function(codeStr, mode)
	if not mode then mode = 3 end
	showText(getText(codeStr), mode)
end 
showUtf8Text = function(str, mode)
	if not str then return end
	local SystemCenterInfo = nx_value('SystemCenterInfo')
	if nx_is_valid(SystemCenterInfo) then
		if not mode then mode = 3 end
		SystemCenterInfo:ShowSystemCenterInfo(utf8ToWstr(str), mode)
	end
end 
showSystemText = function(str, mode)
	local form_main_chat_logic = nx_value('form_main_chat')
	if nx_is_valid(form_main_chat_logic) then
		if not mode then mode = 3 end
		form_main_chat_logic:AddChatInfoEx(nx_widestr(str), mode, false)
	end
end
showSystemUtf8Text = function(str, mode)
	local form_main_chat_logic = nx_value('form_main_chat')
	if nx_is_valid(form_main_chat_logic) then
		form_main_chat_logic:AddChatInfoEx(utf8ToWstr(str), mode, false)
	end
end
copyText = function(text) 
	nx_function('ext_copy_wstr', nx_widestr(text))
end


utf8ToWstr_load = function(str)
	if not str then return nx_wstr("")
	else 
		return utf8ToWstr(str)
	end
end
function getPlayer()
	local game_client = nx_value('game_client')
	if nx_is_valid(game_client) then
		local client_player = game_client:GetPlayer()
		if nx_is_valid(client_player) then
			return client_player
		end
	end
	return nx_null()
end
function get_auto_record(xml_doc, recordName)
	local record = {}
	if not nx_is_valid(xml_doc) then
		return record
	end
	local xmlroot = xml_doc.RootElement
	if not nx_is_valid(xmlroot) then
		return record
	end
	local Record_List = xmlroot:GetChildList("Record")
	local Record
	for i = 1, table.getn(Record_List) do
		local child = Record_List[i]
		local name = util_dencrypt_string(child:QueryAttr("name"))
		if nx_string(utf8ToWstr(recordName)) == nx_string(name) then
			Record = child
			break
		end
	end
	if Record == nil then
		return record
	end
	local Item_List = Record:GetChildList("Item")
	for i = 1, table.getn(Item_List) do
		local child = Item_List[i]
		local item = {}
		item.name = util_dencrypt_string(child:QueryAttr("name"))
		item.content = util_dencrypt_string(child:QueryAttr("content"))
		item.time = util_dencrypt_string(child:QueryAttr("time"))
		table.insert(record, item)
	end
	return record
end
function get_auto_record_doc()
	return create_auto_record_doc()
end
function delete_auto_record(xml_doc, recordName, account_name)
	if not nx_is_valid(xml_doc) then
		return
	end
	local xmlroot = xml_doc.RootElement
	if not nx_is_valid(xmlroot) then
	return
	end
	local Record_List = xmlroot:GetChildList("Record")
	local Record
	for i = 1, table.getn(Record_List) do
		local child = Record_List[i]
		local name = util_dencrypt_string(child:QueryAttr("name"))
		if nx_string(utf8ToWstr(recordName)) == nx_string(name) then
			Record = child
			break
		end
	end
	if nx_is_valid(Record) then
		xmlroot:RemoveChild(Record)
		local full_filename = get_auto_record_path_name(account_name)
		xml_doc:SaveFile(full_filename)
	end
end

function is_jump()
	local state = getPlayerState()
	return state == 'locked' or state == 'jump_fall' or state == 'jump' or state == 'jump_second' or state == 'jump_third'
end

function getPlayerState( ... )
	local role = nx_value('role')
	if not nx_is_valid(role) then return end
	if not nx_find_custom(role, 'state') then return end
	return nx_string(role.state)
end
get_buff_for_text = function(text)	
	local game_client = nx_value("game_client")
	local player = game_client:GetPlayer()
	if not nx_is_valid(player) then return end
	local buffer_list = nx_function("get_buffer_list", player)
	local buffer_count = #buffer_list/2
	for i = 1, buffer_count do
		local buff_id = nx_string(buffer_list[i*2-1])
		if string.find(getUtf8Text(buff_id),getUtf8Text(text),1,true) ~= nil then
			return true
  		end	
	end	
	return false
end

function jump_skill()
	nx_pause(0.1)
	local game_visual = nx_value('game_visual')
	local role = util_get_role_model()
	if string.find(nx_string(role.state),nx_string('locked'),1,true) then 
		return
	end
	local visual_player = game_visual:GetPlayer()
	if not nx_is_valid(game_visual) or not nx_is_valid(visual_player) then return end	
	if nx_find_custom(visual_player, 'state_prop_new') and string.find(nx_string(visual_player.state_prop_new),nx_string('hurt_stun'),1,true) ~= nil then			
		return
	end	
	local obj = AutoGetCurSelect2()
	if isDead(obj) then return end
	if get_buff_info('buff_hurt_1') ~= nil then
		return
	end	
	if nx_string(role.state) ~= nx_string('locked') then 
		--game_visual:SwitchPlayerState(role,'jump',5)
		emit_player_input(role, 9)
	end
end
function jump_skill_es()
	local game_visual = nx_value('game_visual')
	local role = nx_value('role')
	if not nx_is_valid(game_visual) or not nx_is_valid(role) then return end
	local game_client = nx_value("game_client")
	local client_player = game_client:GetPlayer()
	if client_player:FindProp('CurSkillID') and client_player:QueryProp('CurSkillID') ~= '' then return end
	emit_player_input(role, 9)
	--game_visual:SwitchPlayerState(role,'jump',5)
	nx_execute('custom_sender', 'custom_active_parry', 1, 2)
end

function get_auto_record_path_name(account_name)
	local self_name = nil
	if account_name == nil then
		local game_client = nx_value("game_client")
		if not nx_is_valid(game_client) then
			return
		end
		local client_player = game_client:GetPlayer()
		if not nx_is_valid(client_player) then
			return
		end
		self_name = client_player:QueryProp("Name")
		self_name = utf8ToWstr(string.gsub(wstrToUtf8(self_name), "@.*", ""))
	else
		self_name = utf8ToWstr(account_name)
	end
	local file_name = util_encrypt_string("auto_record_" .. nx_string(self_name))
	local full_filename = util_get_account_path(account_name) .. file_name .. ".xml"
	return full_filename
end
function create_auto_record_doc(account_name)
	local xml_doc = nx_create("XmlDocument")
	if not nx_is_valid(xml_doc) then
		return nil
	end
	local full_filename = get_auto_record_path_name(account_name)
	if not full_filename then return end
	if not nx_find_method(xml_doc, "LoadFile") then
		return nil
	end
	if not xml_doc:LoadFile(full_filename) then
		local root = xml_doc:CreateRootElement("Records")
		if not xml_doc:SaveFile(full_filename) then
			nx_destroy(xml_doc)
			return nil
		end
	end
	return xml_doc
end
function get_auto_record(xml_doc, recordName)
	local record = {}
	if not nx_is_valid(xml_doc) then
		return record
	end
	local xmlroot = xml_doc.RootElement
	if not nx_is_valid(xmlroot) then
		return record
	end
	local Record_List = xmlroot:GetChildList("Record")
	local Record
	for i = 1, table.getn(Record_List) do
		local child = Record_List[i]
		local name = util_dencrypt_string(child:QueryAttr("name"))
		if nx_string(utf8ToWstr(recordName)) == nx_string(name) then
			Record = child
			break
		end
	end
	if Record == nil then
		return record
	end
	local Item_List = Record:GetChildList("Item")
	for i = 1, table.getn(Item_List) do
		local child = Item_List[i]
		local item = {}
		item.name = util_dencrypt_string(child:QueryAttr("name"))
		item.content = util_dencrypt_string(child:QueryAttr("content"))
		item.time = util_dencrypt_string(child:QueryAttr("time"))
		table.insert(record, item)
	end
	return record
end
function clear_all_auto_record(xml_doc, account_name)
	if not nx_is_valid(xml_doc) then
		return
	end
	local xmlroot = xml_doc.RootElement
	if not nx_is_valid(xmlroot) then
		return
	end
	local Record_List = xmlroot:GetChildList("Record")
	local count = table.getn(Record_List)
	for i = count, 1, -1 do
		xmlroot:RemoveChild(Record_List[i])
	end
	local full_filename = get_auto_record_path_name(account_name)
	xml_doc:SaveFile(full_filename)
end
function delete_auto_record(xml_doc, recordName, account_name)
	if not nx_is_valid(xml_doc) then
		return
	end
	local xmlroot = xml_doc.RootElement
	if not nx_is_valid(xmlroot) then
	return
	end
	local Record_List = xmlroot:GetChildList("Record")
	local Record
	for i = 1, table.getn(Record_List) do
		local child = Record_List[i]
		local name = util_dencrypt_string(child:QueryAttr("name"))
		if nx_string(utf8ToWstr(recordName)) == nx_string(name) then
			Record = child
			break
		end
	end
	if nx_is_valid(Record) then
		xmlroot:RemoveChild(Record)
		local full_filename = get_auto_record_path_name(account_name)
		xml_doc:SaveFile(full_filename)
	end
end
function write_auto_record(recordName, senderName, chat_content, account_name)	
	if not recordName or not senderName or not chat_content then
		return
	end
	chat_content = utf8ToWstr(chat_content)
	recordName = utf8ToWstr(recordName)
	senderName = utf8ToWstr(senderName)
	local xml_doc = create_auto_record_doc(account_name)
	if not nx_is_valid(xml_doc) then
		return
	end
	local full_filename = get_auto_record_path_name(account_name)
	if not nx_file_exists(full_filename) then
		clear_all_auto_record(xml_doc)
	end
	local xmlroot = xml_doc.RootElement
	if not nx_is_valid(xmlroot) then
		return
	end
	local encode_flag = util_encrypt_string(recordName)
	local Record_List = xmlroot:GetChildList("Record")
	local Record
	for i = 1, table.getn(Record_List) do
		local child = Record_List[i]
		local name = child:QueryAttr("name")
		if nx_string(name) == nx_string(encode_flag) then
			Record = child
			break
		end
	end
	if Record == nil then
		Record = xmlroot:CreateChild("Record")
		Record:SetAttr("name", nx_string(encode_flag))
	end
	local Time = os.date('*t', os.time())
	local chat_time = string.format('%d-%02d-%02d %02d:%02d', Time.year, Time.month, Time.day, Time.hour, Time.min)
	local Record_Item = Record:CreateChild("Item")
	Record_Item:SetAttr("name", nx_string(util_encrypt_string(senderName)))
	Record_Item:SetAttr("time", nx_string(util_encrypt_string(chat_time)))
	Record_Item:SetAttr("content", nx_string(util_encrypt_string(chat_content)))
	xml_doc:SaveFile(full_filename)
	local inifile = add_file_user('auto_ai') 
	if wstrToUtf8(recordName) == AUTO_CACK and nx_string(readIni(inifile,AUTO_AI, 'log_auto', '')) == nx_string('true') or wstrToUtf8(recordName) == AUTO_CACK and wstrToUtf8(senderName) == AUTO_QT then
		nx_execute('auto_new\\form_auto_news', 'Init_Form', wstrToUtf8(recordName))
	end
end
auto_script = function()

end
auto_core = function()

end
auto_cack = function()

end
local old_x, old_y, old_z = nil, nil, nil
local start_x, start_y, start_z = nil, nil, nil
getOldPos = function()
	return old_x, old_y, old_z
end
is_diff_dest_pos = function(x, y, z)	
	if x == old_x and y == old_y and z == old_z then
		return false
	end
	return true
end
is_not_move = function()
	local x, y, z = getCurPos()
	if x == start_x and y == start_y and z == start_z then
		return true
	end
	return false
end
get_old_pos = function()
	return old_x, old_y, old_z
end
moveTo = function(x, y, z, npc_id, scene_id)
	old_x, old_y, old_z = x, y, z
	local game_visual = nx_value("game_visual")
	local path_finding = nx_value("path_finding")
	local map_scene = nx_value("form_stage_main\\form_map\\form_map_scene")
	if nx_is_valid(game_visual) and  nx_is_valid(path_finding) and nx_is_valid(map_scene) then
		_curPos = nil
		if scene_id == nil and npc_id == nil then
			nx_value("path_finding"):FindPathScene(map_scene.current_map, nx_float(x), nx_float(y), nx_float(z), nx_float(-1.001))
		elseif npc_id == nil then
			nx_value("path_finding"):FindPathScene(map_scene.current_map, nx_float(x), nx_float(y), nx_float(z), nx_float(-1.001))
		elseif scene_id == nil then
			nx_value("path_finding"):TraceTargetByID(map_scene.current_map, nx_float(x), nx_float(y), nx_float(z), 1.8, npc_id)
		else 
			nx_value("path_finding"):TraceTargetByID(scene_id, nx_float(x), nx_float(y), nx_float(z), 1.8, npc_id)
		end
	else
		return
	end
end
moveToXZ = function(x, y, z, npc_id, scene_id)
	y = 0
	old_x, old_y, old_z = x, y, z
	local game_visual = nx_value("game_visual")
	local path_finding = nx_value("path_finding")
	local map_scene = nx_value("form_stage_main\\form_map\\form_map_scene")
	if nx_is_valid(game_visual) and  nx_is_valid(path_finding) and nx_is_valid(map_scene) then
		_curPos = nil
		if scene_id == nil and npc_id == nil then
			path_finding:FindPathScene(map_scene.current_map, nx_float(x), nx_float(y), nx_float(z), nx_float(-1.001))	
		elseif npc_id == nil then
			path_finding:FindPathScene(map_scene.current_map, nx_float(x), nx_float(y), nx_float(z), nx_float(-1.001))
		elseif scene_id == nil then
			path_finding:TraceTargetByID(map_scene.current_map, nx_float(x), nx_float(y), nx_float(z), 1.8, npc_id)		
		else 
			path_finding:TraceTargetByID(scene_id, nx_float(x), nx_float(y), nx_float(z), 1.8, npc_id)
		end
	else
		return
	end
end
function moveToNPC(scene_id, npc_config_id)
	local game_visual = nx_value("game_visual")
	local path_finding = nx_value("path_finding")
	local x, y, z = find_npc_pos(scene_id, npc_config_id)
	if nx_is_valid(game_visual) and  nx_is_valid(path_finding) and nx_int(x) ~= nx_int(-10000) then
		path_finding:TraceTargetByID(scene_id, nx_float(x), nx_float(y), nx_float(z), 1.8, npc_config_id)
	else
		return
	end
end
getCurPos = function()
	local game_client = nx_value("game_client")
	local game_visual = nx_value("game_visual")
	if not nx_is_valid(game_client) or  not nx_is_valid(game_visual) then return end
	local client_player = game_client:GetPlayer()
	local visual_player = game_visual:GetPlayer()
	if not nx_is_valid(client_player) or not nx_is_valid(visual_player) then return end
	return visual_player.PositionX, visual_player.PositionY, visual_player.PositionZ
end

get_obj_pos = function(obj)
	if not nx_is_valid(obj) then return end
	local game_visual = nx_value("game_visual")
	if not nx_is_valid(game_visual) or not nx_is_valid(obj) then
		return
	end
	local visual_obj = game_visual:GetSceneObj(obj.Ident)
	return visual_obj.PositionX, visual_obj.PositionY, visual_obj.PositionZ 
end

_curPos = nil
saveCurPos = function()
	if _curPos == nil then _curPos = {} end
	_curPos.x, _curPos.y, _curPos.z = getCurPos()
end
isLastPos = function()
	if _curPos == nil then 
		return false
	end
	local x, y, z = getCurPos()
	if x == nil then 
		return false
	end
	if nx_number(x) == nx_number(_curPos.x) and nx_number(y) == nx_number(_curPos.y) and nx_number(z) == nx_number(_curPos.z) then
		return true
	else
		return false
	end
end
isInTargetRadius = function(x, y, z, r)
  local game_visual = nx_value("game_visual")
  if not nx_is_valid(game_visual) then
    return false
  end
  local visual_player = game_visual:GetPlayer()
  if not nx_is_valid(visual_player) then
    return false
  end
  local rX = visual_player.PositionX - x
  local rY = visual_player.PositionY - y
  local rZ = visual_player.PositionZ - z
  local R2 = rX * rX + rY * rY + rZ * rZ
  if R2 <= r*r then
    return true
  end
  return false
end

getDistanceFromObjToPos = function(obj, x, y, z)
	if not nx_is_valid(obj) or x == nil then 
		return 99999
	end
	local game_visual = nx_value("game_visual")
	if not nx_is_valid(game_visual) or not nx_is_valid(obj) then
		return 999999
	end
	local visual_obj = game_visual:GetSceneObj(obj.Ident)
	if not nx_is_valid(visual_obj) then
		return 999999
	end
	local rX = visual_obj.PositionX - x
	local rY = visual_obj.PositionY - y
	local rZ = visual_obj.PositionZ - z
	local r = math.sqrt(rX * rX + rY * rY + rZ * rZ)
	return r
end
reset_current_pos = function(x,y,z)
	if x == nil then
		if get_status_ai() == true then		
			off_all_auto_ai()			
			if not init_auto_ai() then
				return
			end
			turn_on_ai()
			return false
		elseif nx_number(get_auto_cur_task()) == nx_number(AI_AB) then
			turn_off_auto_ab('Error Pos')
			exe_auto_ab_reset()
			nx_pause(5)
			turn_on_auto_ab()
			return false
		end
	end
	return false
end
getDistanceFromPos = function(x, y, z)
  if x == nil or z == nil then
	--reset_current_pos()
	return 999999 
  end
  local game_visual = nx_value("game_visual")
  if not nx_is_valid(game_visual) then
    return 999999
  end
  local visual_player = game_visual:GetPlayer()
  if not nx_is_valid(visual_player) then
    return 999999
  end
  local rX = visual_player.PositionX - x
  local rY = visual_player.PositionY - y
  local rZ = visual_player.PositionZ - z
  local r = math.sqrt(rX * rX + rY * rY + rZ * rZ)
  return r
end
get_dest_obj_distance = function(obj)
	local x, y, z = getCurPos()
	local offX = x - obj.DestX
	local offY = y - obj.DestY
	local offZ = z - obj.DestZ
	return math.sqrt(offX * offX + offY * offY + offZ * offZ)
end
getDistance = function(obj)
	local game_client = nx_value("game_client")
	local game_visual = nx_value("game_visual")
	if not nx_is_valid(game_client) or not nx_is_valid(game_visual) then 
		return 999999
	end
	local client_player = game_client:GetPlayer()
	local visual_player = game_visual:GetPlayer()
	if not nx_is_valid(client_player) or not nx_is_valid(visual_player) or not nx_is_valid(obj) then
		return 999999
	end
	local obj2_visual = game_visual:GetSceneObj(obj.Ident)
	if not nx_is_valid(obj2_visual) then
		return 999999
	end
	local offX = visual_player.PositionX - obj2_visual.PositionX
	local offY = visual_player.PositionY - obj2_visual.PositionY
	local offZ = visual_player.PositionZ - obj2_visual.PositionZ
	return math.sqrt(offX * offX + offY * offY + offZ * offZ)
end
get_diff_y = function(obj)
	local game_client = nx_value("game_client")
	local game_visual = nx_value("game_visual")
	if not nx_is_valid(game_client) or not nx_is_valid(game_visual) then 
		return 999999
	end
	local client_player = game_client:GetPlayer()
	local visual_player = game_visual:GetPlayer()
	if not nx_is_valid(client_player) or not nx_is_valid(visual_player) or not nx_is_valid(obj) then
		return 999999
	end
	local obj2_visual = game_visual:GetSceneObj(obj.Ident)
	if not nx_is_valid(obj2_visual) then
		return 999999
	end
	return math.abs(visual_player.PositionY - obj2_visual.PositionY)
end
get_diff_xyz = function(obj)
	local game_client = nx_value("game_client")
	local game_visual = nx_value("game_visual")
	if not nx_is_valid(game_client) or not nx_is_valid(game_visual) then 
		return 99999 ,999999,999999
	end
	local client_player = game_client:GetPlayer()
	local visual_player = game_visual:GetPlayer()
	if not nx_is_valid(client_player) or not nx_is_valid(visual_player) or not nx_is_valid(obj) then
		return 99999 ,999999,999999
	end
	local obj2_visual = game_visual:GetSceneObj(obj.Ident)
	if not nx_is_valid(obj2_visual) then
		return 99999 ,999999,999999
	end
	local offX = visual_player.PositionX - obj2_visual.PositionX
	local offY = visual_player.PositionY - obj2_visual.PositionY
	local offZ = visual_player.PositionZ - obj2_visual.PositionZ
	local range, range_xz, range_y = math.sqrt(offX * offX + offY * offY + offZ * offZ), math.sqrt(offX * offX + offZ * offZ), math.abs(offY)
	if range == nil or range_xz == nil or range_y == nil then 
		return 99999 ,999999,999999
	end
	return range, range_xz, range_y
end
function distance_2d(x1, z1, x2, z2)
	return math.sqrt((x1 - x2) * (x1 - x2) + (z1 - z2) * (z1 - z2))
end

function distance_3d(x1, y1, z1, x2, y2, z2)
	return math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2) + (z1 - z2) * (z1 - z2))
end
showNewItemsListSystem = function(oldList, curList,mode)
	if mode == nil then mode = 4 end
	for i = 1, table.maxn(curList) do
		local flag = false
		for j = 1, table.maxn(oldList) do
			if curList[i].id == curList[j].id then flag = true break end
		end
		if not flag then
			showSystemUtf8Text(curList[i].info, nx_int(mode))
		end
	end
end


function query_condtion_msg_auto()
  local form_name = "form_stage_main\\form_school_war\\form_newschool_school_msg_info"
  local form = util_get_form(form_name, true)
  if not nx_is_valid(form) then
    return
  end
  local condition_manager = nx_value("ConditionManager")
  if not nx_is_valid(condition_manager) then
    return
  end
  local game_client = nx_value("game_client")
  local player = game_client:GetPlayer()
  if not nx_is_valid(player) then
    return
  end
  local player_force = player:QueryProp("NewSchool")
  if nil == player_force or "" == player_force then
    return
  end
  local ini = nx_execute("util_functions", "get_ini", "share\\NewSchool\\NewSchoolUI\\NewSchoolCondition.ini")
  if not nx_is_valid(ini) then
    return
  end
  local sec_index = ini:FindSectionIndex("condition")
  if sec_index < 0 then
    return
  end
  local condition_pass = ""  
  for i = 0, ini:GetSectionItemCount(sec_index) - 1 do
    local condition = ini:GetSectionItemKey(sec_index, i)
    local force = ini:GetSectionItemValue(sec_index, i)	
    if nx_int(0) < nx_int(condition) and player_force == force then			
      if condition_manager:CanSatisfyCondition(player, player, nx_int(condition)) then	  
        condition_pack_auto[nx_string(condition)] = 1
      else
        condition_pack_auto[nx_string(condition)] = 0
      end
    end
  end 
end
function fresh_form_qn()
  local form = nx_value(FORM_NEWSCHOOL_INFO)
  if not nx_is_valid(form)  then
    form = util_show_form(FORM_NEWSCHOOL_INFO, true)
    if nx_is_valid(form) then form.Visible = false end
    return false
  end
  if not form.rbtn_m4.Checked then
    form.rbtn_m4.Checked = true
    nx_execute(FORM_NEWSCHOOL_INFO, 'on_m_checked_changed', form.rbtn_m4)
    return false
  end
  return true
end
function get_arraylist(global_name, recreate)
  local array_list_manager = nx_value("array_list_manager")
  if array_list_manager == nil or not nx_is_valid(array_list_manager) then
    array_list_manager = nx_create("ArrayList", "array_list_manager")
    nx_set_value("array_list_manager", array_list_manager)
  end
  if nx_find_custom(array_list_manager, global_name) then
    local array_list = nx_custom(array_list_manager, global_name)
    if nx_is_valid(array_list) then
      if recreate == nil or not recreate then
        return array_list
      end
      nx_destroy(array_list)
    end
  end
  local array_list = nx_create("ArrayList")
  array_list.Name = global_name
  nx_set_custom(array_list_manager, global_name, array_list)
  return array_list
end

function getCurMapScene()
  local taskmgr = nx_value('TaskManager')
  local game_client = nx_value('game_client')
  local client_scene = game_client:GetScene()
  if not nx_is_valid(client_scene) or not nx_is_valid(taskmgr) then return 0 end
  local gui = nx_value('gui')
  local config_id = client_scene:QueryProp('ConfigID')
  local scene_id = taskmgr:GetSceneId(nx_string(config_id))
  return scene_id
end

function get_task_state(task_id)
  local gui = nx_value("gui")
  local game_client = nx_value("game_client")
  local client_player = game_client:GetPlayer()
  if not nx_is_valid(client_player) then
    return -1
  end
  local row = client_player:FindRecordRow("Task_Accepted", 0, nx_int(task_id), 0)
  if row < 0 then
    return -1
  end
  local step = client_player:QueryRecord("Task_Accepted", row, 8)
  local status = client_player:QueryRecord('Task_Accepted', row, 6)  
  return step,status
end
function get_player()
  local game_client = nx_value('game_client')
  local player = game_client:GetPlayer()
  return player
end
function get_task_round(taskid,type_quest)
  query_condtion_msg_auto()   
  local force_task_info = get_arraylist("force_task_info")  
  local RW_ini = nx_execute("util_functions", "get_ini", "share\\NewSchool\\NewSchoolUI\\NewSchoolPlay.ini")
  if not nx_is_valid(RW_ini) then
    return
  end  
  local form_name = nx_value(FORM_NEWSCHOOL_INFO)
  local nType = nx_int(type_quest)  
  local forceId = form_name.force_id 
  local count = RW_ini:GetSectionCount()
  for nIndex = 0, count - 1 do
    local Type = RW_ini:ReadInteger(nIndex, "Type", 0)
    local Force = RW_ini:ReadInteger(nIndex, "Force", 0)
    local condition = RW_ini:ReadInteger(nIndex, "Condition", 0)		
    if nType == nx_int(Type) and forceId == Force and nx_int(1) == nx_int(condition_pack_auto[nx_string(condition)]) then		
	  local Name = RW_ini:GetSectionByIndex(nIndex)		  
      local MaxRoundNumber = RW_ini:ReadInteger(nIndex, "MaxRoundNumber", 0)
	  if forceId == 29 then MaxRoundNumber = 1 end
      local Npc = RW_ini:ReadString(nIndex, "Npcsearch", "")
      local task_id = RW_ini:ReadString(nIndex, "Task_id", "")		
		if nx_int(0) < nx_int(task_id) then				
			if force_task_info:FindChild(nx_string(task_id)) then				
				 local child = force_task_info:GetChild(nx_string(task_id))
				local round = child.round	
				if nx_number(task_id) == nx_number(taskid) then
					return task_id,Name,Npc,round,MaxRoundNumber
				end
			end
		 end
	  end
  end
  return false,false
end
function get_new_school()
  local game_client = nx_value("game_client")
  if not nx_is_valid(game_client) then
    return "0"
  end
  local client_player = game_client:GetPlayer()
  if not nx_is_valid(client_player) then
    return "0"
  end
  local playerschool = client_player:QueryProp("NewSchool")
  return nx_string(playerschool)
end
function show_form_qn() 
  local form = nx_value(FORM_NEWSCHOOL_INFO)
  if not nx_is_valid(form) then
    util_show_form(FORM_NEWSCHOOL_INFO, true)
    return false	
  end
  if not form.rbtn_m4.Checked then
    form.rbtn_m4.Checked = true
    nx_execute(FORM_NEWSCHOOL_INFO, 'on_m_checked_changed', form.rbtn_m4)
    return false
  end
  if not nx_find_custom(form, 'force_task_info') then
    nx_execute(FORM_NEWSCHOOL_INFO, 'on_m_checked_changed', form.rbtn_m4)
    return false
  end
  if not nx_is_valid(form.force_task_info) then
    nx_execute(FORM_NEWSCHOOL_INFO, 'on_m_checked_changed', form.rbtn_m4)
    return false
  end
  return true
end
function find_child_round(taskID)
  local form_name = 'form_stage_main\\form_school_war\\form_newschool_school_msg_info'
  local form = nx_value(form_name)
  if not nx_is_valid(form)  then
    return nil
  end
  if not form.rbtn_m4.Checked then
    return nil
  end
  if not nx_find_custom(form, 'force_task_info') then
    return nil
  end
  if not nx_is_valid(form.force_task_info) then
    return nil
  end
  if not form.force_task_info:FindChild(nx_string(taskID)) then
    return nil
  end
  return form.force_task_info:GetChild(nx_string(taskID))
end



function talkNpc(number)
  local form = nx_value('form_stage_main\\form_talk_movie')
  if form.Visible == false then
    return false
  end
  local menu_npctalk = form.mltbox_menu
  local menu_select = menu_npctalk:GetItemKeyByIndex(number - 1)
  nx_execute('form_stage_main\\form_talk_movie', 'menu_select', menu_select)
  nx_pause(2)
  return true
end
function close_movie()
  local scenario_manager = nx_value('scenario_npc_manager')
  if nx_is_valid(scenario_manager) then
    scenario_manager:StopScenarioImmediately()
  end
end
function getNpcJumpShort(npcid,x1,y1,z1)
	local npc = FindObject(npcid)
	local form = nx_value('form_stage_main\\form_talk_movie')	
	if npc and getDistance(npc) < 5 and not is_path_finding() then
		nx_execute('custom_sender','custom_select',npc.Ident)
		nx_pause(0.5)		
		nx_execute('custom_sender','custom_select',npc.Ident)
		return true
	else		
		if not tools_move_isArrived(x1,y1,z1) then
			local pos = {x1,y1,z1}
			jump_to(pos)
			return false
		end							
	end
	return false
end									
function getNpcJump(mapid,npcid)
	local npc = FindObject(npcid)
	local x,y,z = getPosNpc(mapid,npcid)
	local form = nx_value('form_stage_main\\form_talk_movie')	
	if npc and getDistance(npc) < 5 and not is_path_finding() then
		nx_execute('custom_sender','custom_select',npc.Ident)
		nx_pause(0.5)		
		nx_execute('custom_sender','custom_select',npc.Ident)
		return true
	else		
		jump_direct_to_pos({x,y,z},49,2)	
		return false	
	end
	return false
end
function checkNpc(npcid)
	local npc = FindObject(npcid)
	if npc then
		return true
	end
	return false
end
function getNpc(mapid,npcid)
	local npc = FindObject(npcid)
	local x,y,z = getPosNpc(mapid,npcid)
	local form = nx_value('form_stage_main\\form_talk_movie')		
	if npc and getDistance(npc) < 5 and not is_path_finding() then
		nx_execute('custom_sender','custom_select',npc.Ident)
		nx_pause(0.5)		
		nx_execute('custom_sender','custom_select',npc.Ident)
		return true
	else		
		autoMove(mapid,x,y,z)		
	end
	return false
end
use_item_no_delay = function(item_id)
	if item_id == nil or not item_id then return end
	local item_pos, view = nx_execute('auto_new\\autocack','find_item_pos',item_id)
	if item_pos ~= 0 then
		local amount = getAmountOfItem(nx_string(item_id))
		if amount > 0 then
			for i =1, amount do	
				nx_execute('custom_sender', 'custom_use_item', view, item_pos)
			end
		end
	end
end

function load_shortcut()
	local form = nx_value(FORM_MAIN_SHORTCUT)
	local grid = form.grid_shortcut_main
	local temp = grid.page
	grid.page = 19
	change_form_main_shortcut_cur_page(grid)
	nx_pause(1)
	grid.page = temp
	change_form_main_shortcut_cur_page(grid)
end	
function change_form_main_shortcut_cur_page(grid)	
	local game_config_info = nx_value('game_config_info')
	if nx_is_valid(game_config_info) then
		nx_execute('util_functions', 'util_set_property_key', game_config_info, 'shortcut_page', nx_int(grid.page))
	end
	local CustomizingManager = nx_value('customizing_manager')
	if nx_is_valid(CustomizingManager) then
		CustomizingManager:SaveConfigToServer()
	end
	nx_execute(FORM_MAIN_SHORTCUT, 'on_shortcut_record_change', grid)
end		
function FindItem(itemid, bag)
	local game_client = nx_value('game_client')
	local client_player = game_client:GetPlayer()
	if nx_is_valid(client_player) then
		local scene = game_client:GetScene()
		local view_table = game_client:GetViewList()
		for i = 1, table.getn(view_table) do
			local view = view_table[i]
			if view.Ident == nx_string(bag) then
				local view_obj_table = view:GetViewObjList()
				for k = 1, table.getn(view_obj_table) do
					local view_obj = view_obj_table[k]
					if view_obj:QueryProp('ConfigID') == itemid then
						return view_obj
					end
				end
			end
		end
	end
end
function isempty(s)
  return s == nil or s == ''
end
function getPosNpc(scene, configId)
	local mgr = nx_value('SceneCreator')
	if nx_is_valid(mgr) then
		local res = mgr:GetNpcPosition(scene, configId)
		if 3 <= table.getn(res) then
			return res[1], res[2], res[3]
		end
	end
	return nil
end
function FindObject(configid)
	local game_client = nx_value('game_client')
	local client_player = game_client:GetPlayer()
	if nx_is_valid(client_player) then
		local scene = game_client:GetScene()
		local visual_objlist = scene:GetSceneObjList()
		if nx_is_valid(scene) then
			for k = 1, table.getn(visual_objlist) do
				local object = visual_objlist[k]
				if nx_is_valid(object) then
					if not game_client:IsPlayer(object.Ident) then
						if object:FindProp('ConfigID') and nx_string(object:QueryProp('ConfigID')) == nx_string(configid) then
							return object
						end
					end
				end
			end
		end
	end
	return nil
end
oldPos = {}
stuck = 0
skill_list = {}
autoMoveBreak = 1
function autoMove(mapid, x, y, z, breakroute, npc) 
  local world = nx_value('world')
  local scene = world.MainScene
  if not nx_is_valid(scene) then
    return false
  end
  local terrain = scene.terrain
  if not nx_is_valid(terrain) then
    terrain = nx_value('terrain')
  end
  local game_visual = nx_value('game_visual')
  if nx_is_valid(game_visual) then
    local player = getPlayer()
    if nx_is_valid(player) then
      local role = game_visual:GetSceneObj(player.Ident)
      if nx_is_valid(role) then
        if breakroute ~= nil then
          autoMoveBreak = autoMoveBreak + 1
          if autoMoveBreak >= 30 then
            local path_finding = nx_value('path_finding')
            path_finding:FindPathScene(mapid, x, y, z, 0)
            autoMoveBreak = 1
          end
        end
        if nx_find_custom(role, 'path_finding') then
          if not is_path_finding(role) then
            local path_finding = nx_value('path_finding')
            path_finding:FindPathScene(mapid, x, y, z, 0)
          end
        else
          local path_finding = nx_value('path_finding')
          path_finding:FindPathScene(mapid, x, y, z, 0)
        end
        if oldPos[1] ~= nil then
          local distance = get_distance_pos(oldPos[1], oldPos[2], oldPos[3], player)
          if distance == 0 then
            stuck = stuck + 1
            if stuck >= 50 then
              if nx_function('find_buffer', player, 'buf_riding_01') then
                nx_execute('custom_sender', 'custom_remove_buffer', 'buf_riding_01')
              end
              nx_pause(1)
              nx_execute('custom_sender', 'custom_active_parry', 1, 2)
              nx_pause(1)
              nx_execute('custom_sender', 'custom_active_parry', 0, 2)
              nx_pause(1)
              local distance = 6
              local x = role.PositionX + distance * math.cos(role.AngleZ) * math.sin(role.AngleY)
              local y = role.PositionY + role.height * 0.5
              local z = role.PositionZ + distance * math.cos(role.AngleZ) * math.cos(role.AngleY)
              if npc ~= nil and nx_is_valid(npc) and 6 >= get_distance_obj(player, npc) then
                local target = game_visual:GetSceneObj(npc.Ident)
                x, y, z = target.PositionX, target.PositionY, target.PositionZ
              end
              emit_player_input(role, PLAYER_INPUT_HIT_SPACE, true)
              nx_pause(0.5)
              emit_player_input(role, PLAYER_INPUT_HIT_SPACE, true)
              nx_pause(0.5)
              emit_player_input(role, PLAYER_INPUT_HIT_SPACE, true)
              nx_pause(0.5)
              local higher_floor, higher_floor_y = get_pos_floor_index(role.scene.terrain, x, y, z)
              emit_player_input(role, PLAYER_INPUT_LOGIC, LOGIC_SERVER_JUMP_POS, x, higher_floor_y, z, 1, 1)
              stuck = 0
            end
          end
        end
        oldPos[1], oldPos[2], oldPos[3] = role.PositionX, role.PositionY, role.PositionZ
      end
    end
  end
end
function get_distance_pos(x, y, z, player)
  if not nx_is_valid(player) then
    return -1
  end
  local game_visual = nx_value('game_visual')
  local visual_scene_obj = game_visual:GetSceneObj(player.Ident)
  if not nx_is_valid(visual_scene_obj) then
    return
  end
  local player_x = visual_scene_obj.PositionX
  local player_y = visual_scene_obj.PositionY
  local player_z = visual_scene_obj.PositionZ
  local sx = x - player_x
  local sy = y - player_y
  local sz = z - player_z
  return math.sqrt(sx * sx + sy * sy + sz * sz)
end
function distance2d(bx, bz, dx, dz)
  return math.sqrt((dx - bx) * (dx - bx) + (dz - bz) * (dz - bz))
end
function distance3d(bx, by, bz, dx, dy, dz)
  return math.sqrt((dx - bx) * (dx - bx) + (dy - by) * (dy - by) + (dz - bz) * (dz - bz))
end

function SkillStaticQueryById(skill_id, prop_name)
  if not nx_is_valid(nx_value('data_query_manager')) then
    return ''
  end
  local static_data = 0
  if nx_is_valid(nx_value('fight')) and nx_is_valid(nx_value('fight'):FindSkill(skill_id)) and nx_value('fight'):FindSkill(skill_id):FindProp('StaticData') then
	static_data = nx_value('fight'):FindSkill(skill_id):QueryProp('StaticData')
  end
  if nx_is_valid(nx_value('data_query_manager')) then
	return nx_value('data_query_manager'):Query(STATIC_DATA_SKILL_STATIC, nx_int(static_data), prop_name)
  else
	return ''
  end  
end


function get_skill_target_type(config)
	return skill_static_query_by_id(config, "TargetType")
end
function use_skill_configid(skill_config, select_target, is_range)
	local skill_target = get_skill_target_type(skill_config)
	if nx_int(skill_target) == nx_int(1) then
		local game_visual = nx_value('game_visual')
		if not nx_is_valid(game_visual) or not nx_is_valid(select_target) then return end
		if nx_int(skill_target) == nx_int(1) then
			local visual_target = game_visual:GetSceneObj(select_target.Ident)
			if nx_is_valid(visual_target) then
				local x, y, z = visual_target.PositionX, visual_target.PositionY, visual_target.PositionZ
				nx_value('gui').GameHand:SetHand('groundpick', 'Default', 'map\\tex\\Target_area_G.dds', '' .. 4, 'xxx', nx_string(10))
				nx_execute('game_effect', 'hide_ground_pick_decal')
				nx_execute('game_effect', 'locate_ground_pick_decal', x, y, z, 30)
			end
		end
	end
	nx_value('fight'):TraceUseSkill(skill_config, (not is_range), false)
end
function get_captain_name()
  local player = getPlayer()
  if not nx_is_valid(player) then return nx_widestr('') end
  return nx_widestr(player:QueryProp('TeamCaptain'))
end
function get_player_name( ... )
  local player = getPlayer()
  if not nx_is_valid(player) then return nil end
  return nx_widestr(player:QueryProp('Name'))
end
function get_pos_player_dis(name)
  local game_client = nx_value('game_client')
  if not nx_is_valid(game_client) then return end
  local game_scene = game_client:GetScene()
  if not nx_is_valid(game_scene) then return  end
  local obj_list = game_scene:GetSceneObjList()
  for i,obj in pairs(obj_list) do
    if name == nx_widestr(obj:QueryProp('Name')) then return obj end
  end
  return nil
end
function get_obj_target_train(obj)
  if not nx_is_valid(obj) then return end
  local game_client = nx_value('game_client')
  if not nx_is_valid(game_client) then return end
  local re_obj = game_client:GetSceneObj(nx_string(obj:QueryProp('LastObject')))
  if nx_is_valid(re_obj) and not isDead(re_obj) then return re_obj end
  return nil
end
function isDead( obj )
	if not nx_is_valid(obj) then return true end
	return nx_number(obj:QueryProp('Dead')) == 1
end
function fight_target_train(obj)
  local vis_obj = getVisualObj(obj)
  if not nx_is_valid(vis_obj) then return false end
  local game_visual = nx_value('game_visual')
  if not nx_is_valid(game_visual) then return false end
  return game_visual:QueryRoleLogicState(vis_obj) == 1
end
function get_mon_target_caption(main_obj)
  if not nx_is_valid(main_obj) then return nil end
  local main_obj_ident = main_obj.Ident
  local npc = 1
  local distance = 9999999999
  local game_client = nx_value('game_client')
  local game_scene = game_client:GetScene()
  if not nx_is_valid(game_scene) then return end
  local obj_lst = game_scene:GetSceneObjList()
  for i,obj in pairs(obj_lst) do
    local die = nx_string(obj:QueryProp('Dead'))
    local target = nx_string(obj:QueryProp('LastObject'))
    if nx_string(target) == nx_string(main_obj_ident) and nx_string(die) ~= nx_string(1) then
      local d = getDistanceObjToObj(main_obj,obj)
      if d < distance then
        distance = d
        npc = obj
      end
    end

  end
  return npc
end

function getVisualObj(obj)
	if not nx_is_valid(obj) then return end
	local game_visual = nx_value('game_visual')
	local vObj = game_visual:GetSceneObj(obj.Ident)
	return vObj
end
function getDistanceObjToObj( obj_1, obj_2 )
  local vis_obj_1 = getVisualObj(obj_1)
  local vis_obj_2 = getVisualObj(obj_2)
  if not nx_is_valid(vis_obj_1) or not nx_is_valid(vis_obj_2) then return 999 end
  local x1,y1,z1 = vis_obj_1.PositionX, vis_obj_1.PositionY, vis_obj_1.PositionZ
  local x2,y2,z2 = vis_obj_2.PositionX, vis_obj_2.PositionY, vis_obj_2.PositionZ
  local dis = math.sqrt((x1-x2)*(x1-x2) + (y1-y2)*(y1-y2) + (z1-z2)*(z1-z2))
  return dis
end
function getPlayerLogicState( ... )
  local role = nx_value('role')
  if not nx_is_valid(role) then return 1 end
  local game_visual = nx_value('game_visual')
  if not nx_is_valid(game_visual) then return 1 end
  return game_visual:QueryRoleLogicState(role)
end
function is_mp_full_train()
  local player = getPlayer()
  if not nx_is_valid(player) then return true end
  local mp = nx_number(player:QueryProp('MPRatio'))
  local hp = nx_number(player:QueryProp('HPRatio'))
  local logic_state = getPlayerLogicState()
  return (logic_state ~= 102 and mp > 10 and hp > 30) or (mp > 90 and hp > 90)
end
function can_attack_obj_train( obj_1, obj_2 )
  local fight = nx_value('fight')
  return fight:CanAttackNpc(obj_1, obj_2)
end

function target_player_train(obj)
  local target = getTargetObj()
  if not nx_is_valid(target) then return false end
  return nx_id_equal(target, obj)
end
function target_player_train_obj(target,obj)
  local target = getTargetObj_cap(target)
  if not nx_is_valid(target) then return false end
  return nx_id_equal(target, obj)
end
function getTargetObj_cap(obj)
  local game_client = nx_value('game_client')
  if not nx_is_valid(game_client) then return end
  if not nx_is_valid(obj) then return end
  return game_client:GetSceneObj(nx_string(obj:QueryProp('LastObject')))
end
function getTargetObj()
  local game_client = nx_value('game_client')
  if not nx_is_valid(game_client) then return end
  local player = getPlayer()
  if not nx_is_valid(player) then return end
  return game_client:GetSceneObj(nx_string(player:QueryProp('LastObject')))
end
function select_npc_target( obj )
  if not nx_is_valid(obj) then return end
  nx_execute('custom_sender', 'custom_select', obj.Ident)
end
function get_mon_attack_player()
	local npc
	local distance = 9999999999
	local game_client = nx_value('game_client')
	local game_scene = game_client:GetScene()
	local player = getPlayer()
	if not nx_is_valid(game_scene) or not nx_is_valid(player) then return end
	local obj_lst = game_scene:GetSceneObjList()
	for i,obj in pairs(obj_lst) do
		local die = nx_string(obj:QueryProp('Dead'))
		local cfg = nx_string(obj:QueryProp('ConfigID'))
		local target = nx_string(obj:QueryProp('LastObject'))
		if nx_string(target) == nx_string(player.Ident) and nx_string(die) ~= nx_string(1) and nx_string(cfg) ~= nx_string('0') then
			local d = getDistancePlayerToObj(obj)
			if d < distance then
				distance = d 
				npc = obj
			end
		end
		
	end
	return npc
end
get_scene_caption = function()
	local game_client = nx_value('game_client')
    if not nx_is_valid(game_client) then
        return 
    end
    local client_player = game_client:GetPlayer()
    if not nx_is_valid(client_player) then
        return 
    end
	local TEAM_REC = 'team_rec'
	local row_num = client_player:GetRecordRows(TEAM_REC)
	 for index = 0, row_num - 1 do
		local player_name = client_player:QueryRecord(TEAM_REC, index, TEAM_REC_COL_NAME)
		if player_name == get_captain_name() then
			local scene_id = getUtf8Text(client_player:QueryRecord(TEAM_REC, nx_int(index), TEAM_REC_COL_SCENE))
			return scene_id
		end
	end
	return nil
end	
function get_pos_team(player_name)
  local team_manager = nx_value('team_manager')
  if not nx_is_valid(team_manager) then
    return 0,0,0
  end
  local record_table = team_manager:GetPlayerData(player_name)
  return record_table[TEAM_SUB_REC_COL_X+1], 0, record_table[TEAM_SUB_REC_COL_Z+1]
end
function is_dead_auto()
  local game_client = nx_value("game_client")
  local client_player = game_client:GetPlayer()
  if nx_is_valid(client_player) and client_player:FindProp("Dead") and client_player:QueryProp("Dead") > 0 then
    return true
  end
  return false
end
 function BuyItem(item, num)
	if nx_is_valid(nx_value("game_client"))then
		if nx_value("GoodsGrid"):GetItemCount(item) == 0 then
			if not nx_is_valid(nx_value("form_stage_main\\form_shop\\form_shop")) then
				nx_value("game_visual"):CustomSend(nx_int(165), 1)
			else				
				for i = 1, table.getn(nx_value("game_client"):GetViewList()) do
					local view = nx_value("game_client"):GetViewList()[i]
					if view.Ident == nx_string(61) then
						local view_obj_table = view:GetViewObjList()
						for k = 1, table.getn(view_obj_table) do
							local view_obj = view_obj_table[k]
							if nx_string(view_obj:QueryProp("ConfigID")) == item then
								if nx_number(view_obj.Ident) < 501 then
									nx_value("game_visual"):CustomSend(nx_int(70), "Shop_zahuo_00102", 0,nx_number(view_obj.Ident),nx_number(num))
									nx_value("game_visual"):CustomSend(nx_int(165), 0)
									break
								elseif nx_number(view_obj.Ident) < 1001 then
									nx_value("game_visual"):CustomSend(nx_int(70), "Shop_zahuo_00102", 1,(nx_number(view_obj.Ident)-500),nx_number(num))
									nx_value("game_visual"):CustomSend(nx_int(165), 0)
									break
								else
									nx_value("game_visual"):CustomSend(nx_int(70), "Shop_zahuo_00102", 2,(nx_number(view_obj.Ident)-1000),nx_number(num))
									nx_value("game_visual"):CustomSend(nx_int(165), 0)
									break
								end					
							end
						end
					end
				end
			end
		else
			if nx_is_valid(nx_value("form_stage_main\\form_shop\\form_shop")) then
				nx_value("game_visual"):CustomSend(nx_int(165), 0)
			end
		end		
	end
end
function IsBusy()	
	if nx_is_valid(nx_value("game_client")) then 		
		if nx_is_valid(nx_value("game_client"):GetPlayer()) then
			if string.find(nx_value("game_client"):GetPlayer():QueryProp("State"), "offact") or string.find(nx_value("game_client"):GetPlayer():QueryProp("State"), "interact") or string.find(nx_value("game_client"):GetPlayer():QueryProp("State"), "life") or nx_value("form_stage_main\\form_main\\form_main_curseloading") then
				return true
			end
		end
	end
	return false
end
--- Dùng Item theo ID ------
function UseItemByID(id)
	local view_table = nx_value("game_client"):GetViewList()
	for i = 1, table.getn(view_table) do
		local view = view_table[i]
		local view_obj_table = view:GetViewObjList()
		for j = 1, table.getn(view_obj_table) do
			local view_obj = view_obj_table[j]
			if nx_is_valid(view_obj) then
				if view_obj:FindProp("ConfigID") then
					if nx_widestr(view_obj:QueryProp("ConfigID")) == nx_widestr(id) then
						if nx_int(view_obj.Ident) ~= 0 then
							if not IsBusy() then
								nx_value("GoodsGrid"):ViewUseItem(nx_int(view.Ident), nx_int(view_obj.Ident), nx_null(), -1)
								break
							end
						end
					end
				end
			end
		end
	end
end

list_kyngo = {
	"gb340",	-- Thành Trường Nghĩa (Đả Cẩu Bổng)
	"wgm_qy002",	-- Người Thần Bí 
	"Npc_qygp_chz_002",	-- Thù Di (Tham Hợp Chỉ)
	"wd004",	-- Tiêu Dao Sơn Nhân (Thái Cực Quyền)
	"npc_qygp_zy_xlh2",	-- Từ Lão Hán (Nữ Nhi Hồng x4)
	"npc_qy_luxia_xiaomin_0",	-- Tiểu Mẫn (Thiết 1)
	"WorldNpc01146",	-- Tô Tú Vân (Thiết 2)
	"npc_qygp_cc_wu",	-- Ô Hạ (Nữ Nhi Hồng x4)
	"NPC_qygp_bybukuai",	-- Bốc Man Tài (Gà Nướng Trui)
	"funnpcskill002001",	-- Trần Tiểu Thành (Nghịch Thiên Tà Công)
	"WorldNpc_qywx_007",	-- Nhạc Minh Kha (Mảnh Thác Bản)
	"Npc_qygp_chz_003",	-- Ngô Quỳnh (Kim Ngân Hoa)
	"npc_cwqy_cc_01",	-- Chồn con (Điêu nhung)
	"qy_ng_cjbook_jh_201",	-- La Sát Nữ (Vô Vọng)
	"qy_ng_cjbook_jh_202", -- La Sát Nữ (Tàn Dương)
	"qy_ng_cjbook_jh_204", -- La Sát Nữ (Tử Hà)
	"WorldNpc09727",	-- Năng Chuyên Đô (Bệ Xảo 2)
	"WorldNpc09611",	-- Thành Bích Quân (Đả Cẩu Bổng)
	"WorldNpc00343",	-- Tổ Hưng (Long Trảo Thủ)
	"npc_qygp_dy_wle",	-- Lư Đại Thúc (Phệ Ma Tán)
	"sl006",	-- Võ tăng tuần tra (Long Trảo Thủ)
	"wd061",	-- Dị Hương (Thái Cực Quyền)
	"FuncNpc00718",	-- Thanh Pháp (Long Trảo Thủ)
	"wd013",	-- Lý Thu Hà (Thái Cực Quyền)
	"WorldNpc08409",	-- Phan Thắng Dịch (Đả Cấu Bổng)
	"WorldNpc10474",	-- Tằng Thị Lộc (Thái Cực Quyền)
	"wd016",	-- Phú Thương Cát Tiền (Du mộc)
	"NPC_qygp_tjq_jmy001",	-- Kiếm Ngô Khu (Phệ Ma Tán)
	"WorldNpc04349",	-- Bành Xương Quý (Đả Cẩu Bổng)
	"Npc_qygp_shl_002",	-- Mật Lư - Trị Giang (Yết Chi Thượng Hạng)
	"sz352_qy2",	--	Phong Ấn (Mua hên xui Kim hoặc Huyền Ngọc Phấn vì AD cũng chưa từng lụm được nên ko có dịp test)
	"NPC_szwe01129",	--	Phong Ấn
	"WorldNpc04812",	--	Tống Tuấn Thanh
	"ly192",	--	Ích Thánh Kiệt
	"worldnpc01999",	--	Lô Hạ
	"worldnpc03502",	--	Tần Phi
	"WorldNpc00490", --	Kim Trọng Lượng
	"cd107",	--	Tào Thiên
	"worldnpc09812",	--	Quyết Kiếm
	"FuncNpc00717",		--	Thanh Phục
	"WorldNpc04712",	--	Thanh Sấu
	"WorldNpc02396",	--	Diêu Hiền
	"WorldNpc09862",	--	Vạn Quân
	"worldnpc10536",	--	Ô Hạ
	"Npc_cwqy_lua01",	--	Đạm Thi Bình
	"worldnpc01224",	--	Lý Hàm Thu
	"qy_qiegao001",	--	Khế Khắc Não
	"WorldNpc01737",	--	Phong Tư	"Phượng Tư"
	"FuncNpc01308",	--	Hồng Bách Phương
	"WorldNpc01334",	--	Thạch Quần
	"WorldNpc00133",	--	Trần Xuyên Hương
	"WorldNpc02273",	--	Uông Phóng Phàm
	--"convoy30006",	--	Hắc Y Nhân
	--"worldnpc10957",	--	test
}

function check_boss_data_err(bossid)
	local boss_info = auto_split_string(nx_string(data_boss_err[bossid]), ';')
	if table.getn(boss_info) >= 2 then
	  return boss_info
	end	
  return nil
end
function fix_npc_find_pos_ti(scene_id, npc_id)
	local check_err = check_boss_data_err(npc_id)
	if check_err ~= nil then
		local pos = auto_split_string(check_err[1], ',')
		return nx_number(pos[1]),nx_number(pos[2]),nx_number(pos[3])
	end
    local x, y, z = find_npc_pos(scene_id, nx_string(npc_id))
    return x, y, z
end
function AutoGetCurSelect2()
  local selectobj = nx_value(GAME_SELECT_OBJECT)
  if not nx_is_valid(selectobj) then
    return false
  end
  local game_visual = nx_value('game_visual')
  if nx_is_valid(game_visual) then
    return selectobj
  end
  return false
end

function get_skill_sp(configid)
	local game_client = nx_value('game_client')
	local view_table = game_client:GetViewList()
	for i = 1, table.getn(view_table) do
		local view = view_table[i]
		if view.Ident == nx_string('40') then
			local view_obj_table = view:GetViewObjList()
			for k = 1, table.getn(view_obj_table) do
				local view_obj = view_obj_table[k]				
				if view_obj:QueryProp('ConfigID') == configid then				
					if view_obj:FindProp('AConsumeSP') then
						return view_obj:QueryProp('ConfigID')
					end
				end
			end
		end
	end
	return nil
end
get_weapon_by_id_uid = function(uid)
	if uid == nil then return end 
	local game_client = nx_value("game_client")
	if not nx_is_valid(game_client) then
		return
	end
	local view = game_client:GetView("121")
	if not nx_is_valid(view) then return end
	local viewobj_list = view:GetViewObjList()
	for i = 1 ,table.getn(viewobj_list) do
		local obj = viewobj_list[i]
		if nx_string(obj:QueryProp('UniqueID')) == nx_string(uid) then
			return obj.Ident,obj:QueryProp('ConfigID')
		end
	end	
	return nil	
end
get_weapon_use_by_uid = function(uid)
	if uid == nil then return end 
	local game_client = nx_value("game_client")
	if not nx_is_valid(game_client) then
		return
	end
	local view = game_client:GetView("1")
	if not nx_is_valid(view) then return end
	local viewobj_list = view:GetViewObjList()
	for i = 1 ,table.getn(viewobj_list) do
		local obj = viewobj_list[i]
		if nx_number(obj.Ident) == nx_number('22') then
			if obj:QueryProp('UniqueID') == uid then
				return obj.Ident,obj:QueryProp('ConfigID')
			end
		end
	end	
	return nil	
end
function swap_weapon_autoskill(uid)	
	if uid == nil then return end 
	local game_client = nx_value("game_client")
	if not nx_is_valid(game_client) then
		return
	end
	local ident,config = get_weapon_by_id_uid(uid)
	if ident ~= nil then
		local form = util_get_form('form_stage_main\\form_bag')
		if nx_is_valid(form) then
			nx_execute('form_stage_main\\form_bag_func', 'on_bag_right_click', form.imagegrid_equip, nx_number(ident) - 1)
		end
	end
end

function useSkilll_free(skill_data, select_target)	
	local player = getPlayer()
	local buffNC = get_buff_info('buf_CS_jl_shuangci07')	
	if skill_data.needSP > 0 and nx_number(player:QueryProp('SP')) >= nx_number(skill_data.needSP) and (buffNC == nil or buffNC < 3) then
		nx_value('fight'):TraceUseSkill(skill_data.id, true, false)
	end
	if nx_int(skill_data.target_type) == nx_int(1) then
		local game_visual = nx_value('game_visual')
		if not nx_is_valid(game_visual) or not nx_is_valid(select_target) then return end
		nx_value('gui').GameHand:SetHand('groundpick', 'Default', 'map\\tex\\Target_area_G.dds', '' .. 4, 'xxx', nx_string(10))
		nx_execute('game_effect', 'hide_ground_pick_decal')
		local visual_target = game_visual:GetSceneObj(select_target.Ident)
		nx_execute('game_effect', 'locate_ground_pick_decal', visual_target.PositionX, visual_target.PositionY, visual_target.PositionZ, 30)
	end
	nx_value('fight'):TraceUseSkill(skill_data.id, true, false)
end




function get_distance_obj(obj1, obj2)
  if not nx_is_valid(obj1) or not nx_is_valid(obj2) then
    return 100000000
  end
  local game_visual = nx_value("game_visual")
  local obj1_visual = game_visual:GetSceneObj(obj1.Ident)
  local obj2_visual = game_visual:GetSceneObj(obj2.Ident)
  if not nx_is_valid(obj1_visual) or not nx_is_valid(obj2_visual) then
    return 100000000
  end
  local offX = obj1_visual.PositionX - obj2_visual.PositionX
  local offY = obj1_visual.PositionY - obj2_visual.PositionY
  local offZ = obj1_visual.PositionZ - obj2_visual.PositionZ
  return math.sqrt(offX * offX + offY * offY + offZ * offZ)
end

function getSkillSp(configid)
  local game_client = nx_value("game_client")
  local view_table = game_client:GetViewList()
  for i = 1, table.getn(view_table) do
    local view = view_table[i]
    if view.Ident == nx_string("40") then
      local view_obj_table = view:GetViewObjList()
      for k = 1, table.getn(view_obj_table) do
        local view_obj = view_obj_table[k]
        if view_obj:QueryProp("ConfigID") == configid and view_obj:FindProp("AConsumeSP") then
          return view_obj:QueryProp("ConfigID")
        end
      end
    end
  end
  return nil
end

is_password_locked = function() 
	local game_client = nx_value('game_client')
	if not nx_is_valid(game_client) then
		return true 
	end 
	local client_player = game_client:GetPlayer() 
	if nx_number(client_player:QueryProp('IsHaveSecondWord')) ~= nx_number(0) and client_player : QueryProp('IsCheckPass') == nx_number(0) then
		return true 
	end 
	return false
end 
showNewItemsList = function(oldList, curList,mode)
	if mode == nil then mode = 4 end
	for i = 1, table.maxn(curList) do
		local flag = false
		for j = 1, table.maxn(oldList) do
			if curList[i].id == curList[j].id then flag = true break end
		end
		if not flag then
			showSystemUtf8Text(curList[i].info, nx_int(mode))
		end
	end
end
isTeamCaptain = function()
	local game_client = nx_value('game_client')	
	if not nx_is_valid(game_client) then
		return false
	end 
	local client_player = game_client:GetPlayer() 
	local C = client_player:QueryProp('TeamCaptain')
	local N = client_player:QueryProp('Name') 
	if C == N then
		return true 
	else
		return false
	end 
end 
getDistanceFromPosXZ = function(x, y, z)
  if x == nil or z == nil then
	--reset_current_pos()
	return 999999 
  end
  local game_visual = nx_value('game_visual')
  if not nx_is_valid(game_visual) then
    return 999999
  end
  local visual_player = game_visual:GetPlayer()
  if not nx_is_valid(visual_player) then
    return 999999
  end
  if x == nil then return end  
  local rX = visual_player.PositionX - x
  local rY = visual_player.PositionY - y
  local rZ = visual_player.PositionZ - z
  local r = math.sqrt(rX * rX + rZ * rZ)
  return r
end
get_cur_scene_id = function ()
	if isLoading() then return end
	local game_client = nx_value('game_client') 
	if not nx_is_valid(game_client) then return end
	local client_scene = game_client:GetScene() 
	if not nx_is_valid(client_scene) then return end
	return nx_string(client_scene:QueryProp('Resource'))
end

function sectionCount(inifile)	
    local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then
        return
    end
	ini.FileName = nx_string(inifile)
	if ini:LoadFromFile() then
		local count = ini:GetSectionCount()		
		nx_destroy(ini)
		return count
	else
		nx_destroy(ini)
		return 0
	end
end
auto_check_version = function()	
	local str = "https://autocack.net/config/version_update.php"
	nx_set_value("nockasdd_autocack_url_ver", str)
	local url = nx_value("nockasdd_autocack_url_ver")
	local httpclient = nx_create("GenericHTTPClient")
	if nil ~= url and "" ~= url and nx_is_valid(httpclient) then
		httpclient:Request(url, 1, "MERONG(0.9/;p)")
		nx_set_value("nockasdd_autocack_url_ver", nil)
	end
	local content = httpclient:QueryHTTPResponse()
	local split = auto_split_string(content,';')
	if nx_string(nx_execute('auto_new\\autocack','get_version_auto')) == nx_string(split[1]) then
		showUtf8Text(AUTO_VERSION_LOG,3)			
	else			
		showUtf8Text(AUTO_VERSION_LOG_NOT_VER..nx_string(nx_execute('auto_new\\autocack','get_version_auto'))..'/'..nx_string(split[1]),3)
	end
	local msg = split[2]
	if nx_string(msg) == '' or msg == nil then
		msg = ""
	end
	showUtf8Text(nx_string(msg),2)
end	
function getSectionName(inifile,index)	
	local set = {}
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then
        return
    end
	ini.FileName = nx_string(inifile)
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

function add_file(inifile)
	local game_client = nx_value('game_client')	
	local client_player = game_client:GetPlayer()	
	local game_config = nx_value('game_config')
	local stage = nx_value('stage')
	if not nx_is_valid(game_config) and not nx_is_valid(client_player) then return end	
	if stage == 'main' then
		local account = game_config.login_account
		local server_ID = game_config.server_id
		local dir = nx_function('ext_get_current_exe_path') .. 'nockasdd_'.. account..'_'..nx_string(server_ID) 
		local dir1 = nx_function('ext_get_current_exe_path') .. 'nockasdd_'.. account
		local all_char = wstrToUtf8(readIni(dir1..'\\Setting_all.ini',nx_string(AUTO_AI), "all_in_char", ""))	
		if nx_string(all_char) == nx_string('true') and nx_string(inifile) ~= nx_string('Active') and nx_string(inifile) ~= nx_string('auto_ti') and nx_string(inifile) ~= nx_string('auto_train') and nx_string(inifile) ~= nx_string('auto_ts') and nx_string(inifile) ~= nx_string('auto_qn') and nx_string(inifile) ~= nx_string('auto_crop') and nx_string(inifile) ~= nx_string('auto_ab') and nx_string(inifile) ~= nx_string('auto_sw') then
			dir = nx_resource_path() .. 'auto_data\\auto_ai' 
		end
		if not nx_function('ext_is_exist_directory', nx_string(dir)) then
		  nx_function('ext_create_directory', nx_string(dir))	 
		end
		local ini = nx_create('IniDocument')
		if not nx_is_valid(ini) then
			return
		end
		ini.FileName = dir .. '\\'..nx_string(inifile)..'.ini'
		return ini.FileName
	end
end
function add_file_user(inifile)
	local game_client = nx_value('game_client')	
	local client_player = game_client:GetPlayer()	
	local game_config = nx_value('game_config')
	local stage = nx_value('stage')
	if not nx_is_valid(game_config) and not nx_is_valid(client_player) then return end	
	if stage == 'main' then						
		local account = game_config.login_account
		local dir = nx_function('ext_get_current_exe_path') .. 'nockasdd_'.. account 
		local all_char = wstrToUtf8(readIni(dir..'\\Setting_all.ini',nx_string(AUTO_AI), "all_in_char", ""))		
		if nx_string(all_char) == nx_string('true') and nx_string(inifile) ~= nx_string('auto_skill') and nx_string(inifile) ~= nx_string('auto_func') and nx_string(inifile) ~= nx_string('setkey') and nx_string(inifile) ~= nx_string('Active') then
			dir = nx_resource_path() .. 'auto_data\\auto_ai' 
		end
		if not nx_function('ext_is_exist_directory', nx_string(dir)) then
		  nx_function('ext_create_directory', nx_string(dir))	 
		end
		local ini = nx_create('IniDocument')
		if not nx_is_valid(ini) then
			return
		end
		ini.FileName = dir .. '\\'..nx_string(inifile)..'.ini'
		return ini.FileName
	end
end
function add_file_res(inifile)
	local dir = nx_resource_path() .. 'auto_data' 
	if not nx_function('ext_is_exist_directory', nx_string(dir)) then
	  nx_function('ext_create_directory', nx_string(dir))	 
	end
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then
		return
	end
	ini.FileName = dir .. '\\'..nx_string(inifile)..'.ini'
	return ini.FileName	
end
function checkDateTimeCurrent(_hour,_minute)
	local date_table = os.date('*t')
	local ms = string.match(tostring(os.clock()), '%d%.(%d+)')
	local hour, minute, second = date_table.hour, date_table.min, date_table.sec
	local year, month, day = date_table.year, date_table.month, date_table.wday
	if _minute ~= nil then
		if (hour == _hour and minute == _minute) or (hour == _hour and minute > _minute) then
			return true
		end
	else
		if (hour == _hour) then
			return true
		end
	end	
	return false
end
function itemcount(configid)
  local goods_grid = nx_value('GoodsGrid')
  if not nx_is_valid(goods_grid) then
    return false
  end
  local count = goods_grid:GetItemCount(configid)
  if count == nil or count == 0 then
    return false
  end
  return count
end

function get_ini_value(ini_path, section, key, defaut)
  local ini = get_ini(ini_path, true)
  if not nx_is_valid(ini) then
    return defaut
  end
  local index = ini:FindSectionIndex(section)
  if index < 0 then
    return defaut
  end
  return ini:ReadString(index, key, defaut)
end


function is_path_finding()
	local game_client = nx_value('game_client')
	local game_visual = nx_value('game_visual')
	local client_player = game_client:GetPlayer()
	local visual_player = game_visual:GetPlayer()
	if not nx_is_valid(client_player) or not nx_is_valid(visual_player) then
		return	false
	end
	if nx_find_custom(visual_player, 'path_finding') and visual_player.path_finding then
		return true
	else
		return false
	end
end
function find_npc_pos(scene_id, search_npc_id)
	local mgr = nx_value('SceneCreator')
	if nx_is_valid(mgr) then
		local res = mgr:GetNearestNpcPos(scene_id, search_npc_id)
		if res ~= nil and table.getn(res) == 3 then
			return res[1], res[2], res[3]
		end
	end
	return nil
end
is_skill_on_cooling = function(skill_id)
	local cooltype = nx_execute(FORM_MAIN_SHORTCUT_RIDE, 'get_skill_info', skill_id, 'CoolDownCategory')
	local coolteam = nx_execute(FORM_MAIN_SHORTCUT_RIDE, 'get_skill_info', skill_id, 'CoolDownTeam')
	if nx_value('gui').CoolManager:IsCooling(cooltype, coolteam) then return true end
	return false
end


function autoSelectObj(Ident)
	nx_execute('custom_sender', 'custom_select', Ident)
	nx_pause(0.1)
	nx_execute('custom_sender', 'custom_select', Ident)
	nx_pause(0.1)
	nx_execute('custom_sender', 'custom_select', Ident)
end
function autoSelectOneObj(Ident)
	nx_execute('custom_sender', 'custom_select', Ident)
end
function autoSelectCancel()
	nx_execute('custom_sender', 'custom_select_cancel', Ident)
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
function isExistInStringList(list, value, isID)
	if value == nil or list == nil then return false end
	if #list == 0 then return false end
	for i = 1, table.getn(list) do
		local tmp = nil
		if isID then 
			tmp = list[i].id
		else
			tmp = list[i]
		end
		if nx_string(tmp) == nx_string(value) then return true end
	end
	return false
end

readIni = function(file, section, key, default)
  key = nx_string(key)
  local ini = nx_create('IniDocument')
  ini.FileName = file
  if not ini:LoadFromFile() then
    nx_destroy(ini)
    return nx_widestr(default)
  end
  local text = ini:ReadString(section, key, default)
  if text == nil or text == '' then
    return nx_widestr('0')
  end
  nx_destroy(ini)
  return utf8ToWstr(text)
end

writeIni = function(file, section, key, value)
  local ini = nx_create('IniDocument')
  ini.FileName = file
  if not ini:LoadFromFile() then
    local create_file = io.open(file, 'w+')
    create_file:close()
  end
  if not ini:LoadFromFile() then
    nx_destroy(ini)
    return 0
  end
  ini:WriteString(section, key, wstrToUtf8(nx_widestr(value)))
  ini:SaveToFile()
  nx_destroy(ini)
  return 1
end

getText = function(codeStr)
	return nx_value('gui').TextManager:GetText(codeStr)
end
getUtf8Text = function(codeStr)
	return wstrToUtf8(nx_value('gui').TextManager:GetText(codeStr))
end
timerStart = function()
  return os.clock()
end

timerDiff = function(t)
  if t == 0 then
    return 999999
  end
  return os.clock() - t
end

isLoading = function()
	local loading = nx_value('form_stage_main\\form_main\\form_main_curseloading')
	local form = nx_value('form_common\\form_loading')
    if nx_is_valid(loading) and loading.Visible and nx_is_valid(form) and form.Visible then		
		return true
    end	
	return false
end
getSilverFormat = function(capital)
	if capital == nil then return end
	local ding = math.floor(capital / 1000000)
	local liang = math.floor(capital % 1000000 / 1000)
	local wen = math.floor(capital % 1000)
	local str = nx_string(ding) .. ' D' .. nx_string(liang) .. ' L ' .. nx_string(wen) .. ' X'
	return str
end
function checkHCL()
	local bag = util_get_form('form_stage_main\\form_bag', true, true)
	if nx_is_valid(bag) then
		bag.rbtn_tool.Checked = true
	end	
	local GoodsGrid = nx_value('GoodsGrid')
	local numHCL = GoodsGrid:GetItemCount('backtown_tool_fc')
	local numQN61 = GoodsGrid:GetItemCount('box_6nei_prize_game01')
	local numQN62 = GoodsGrid:GetItemCount('box_6nei_prize_game02')
	local numQN63 = GoodsGrid:GetItemCount('box_6nei_prize_game03')
	local numQN64 = GoodsGrid:GetItemCount('box_6nei_prize_game04')
	local numQN65 = GoodsGrid:GetItemCount('box_6nei_prize_game05')
	local numQN66 = GoodsGrid:GetItemCount('box_6nei_prize_game06')
	if numHCL > 0 then
		nx_execute('form_stage_main\\form_bag_func', 'use_item_by_configid', 'backtown_tool_fc')
		nx_pause(6)
		tool_getPickForm()
	elseif numQN61 > 0 then
		nx_execute('form_stage_main\\form_bag_func', 'use_item_by_configid', 'box_6nei_prize_game01')
		nx_pause(6)
		tool_getPickForm()
	elseif numQN62 > 0 then
		nx_execute('form_stage_main\\form_bag_func', 'use_item_by_configid', 'box_6nei_prize_game02')
		nx_pause(6)
		tool_getPickForm()
	elseif numQN63 > 0 then
		nx_execute('form_stage_main\\form_bag_func', 'use_item_by_configid', 'box_6nei_prize_game03')
		nx_pause(6)
		tool_getPickForm()
	elseif numQN64 > 0 then
		nx_execute('form_stage_main\\form_bag_func', 'use_item_by_configid', 'box_6nei_prize_game04')
		nx_pause(6)
		tool_getPickForm()
	elseif numQN65 > 0 then
		nx_execute('form_stage_main\\form_bag_func', 'use_item_by_configid', 'box_6nei_prize_game05')
		nx_pause(6)
		tool_getPickForm()
	elseif numQN66 > 0 then
		nx_execute('form_stage_main\\form_bag_func', 'use_item_by_configid', 'box_6nei_prize_game06')
		nx_pause(6)
		tool_getPickForm()
	end
end							
function teleToHomePoint(idHomePoint)
	local game_client = nx_value('game_client')
	local game_visual = nx_value('game_visual')
	local client_player = game_client:GetPlayer()
	local form = nx_value('form_stage_main\\form_homepoint\\form_home_point')
	if not nx_is_valid(form) or not form.Visible or not nx_find_custom(form,'timer_down') then
		nx_execute('form_stage_main\\form_homepoint\\home_point_data', 'send_homepoint_msg_to_server',0)
		return false
	end
	if form.timer_down > 0 then
		checkHCL()
	else
		local is_exits_point = nx_execute('form_stage_main\\form_homepoint\\home_point_data', 'IsExistRecordHomePoint', nx_string(idHomePoint))
		if not is_exits_point then
			local last_point = client_player:GetRecordRows('HomePointList') - 1
			local point = client_player:QueryRecord('HomePointList', last_point, 0)
			nx_execute('form_stage_main\\form_homepoint\\home_point_data', 'send_homepoint_msg_to_server', 3, nx_string(point))
			nx_pause(2)
			nx_execute('form_stage_main\\form_homepoint\\home_point_data', 'send_homepoint_msg_to_server', 2, nx_string(idHomePoint))
			nx_pause(5)
		end
		local bRet, hp_info = GetHomePointFromHPid(nx_string(idHomePoint))
		if bRet then
			nx_execute('form_stage_main\\form_homepoint\\home_point_data', 'send_homepoint_msg_to_server', 1, hp_info[1], hp_info[8])
			nx_pause(15)
		end		
	end  
end

function GetHomePointFromHPid(hpid)
  local ini = nx_execute('util_functions', 'get_ini', 'share\\Rule\\HomePoint.ini')
  if not nx_is_valid(ini) then
    return false
  end
  local index = ini:FindSectionIndex(hpid)
  if index < 0 then
    return false
  end
  local hp_info = {}
  hp_info[1] = hpid
  hp_info[2] = ini:ReadInteger(index, 'SceneID', 0)
  hp_info[3] = ini:ReadString(index, 'Name', '')
  hp_info[4] = ini:ReadInteger(index, 'Safe', 0)
  local pos_text = ini:ReadString(index, 'PositonXYZ', '')
  hp_info[5] = util_split_string(nx_string(pos_text), ',')
  hp_info[6] = ini:ReadString(index, 'Ui_Introduction', '')
  hp_info[7] = ini:ReadString(index, 'Ui_Picture', '')
  hp_info[8] = ini:ReadInteger(index, 'Type', 0)
  hp_info[9] = ini:ReadString(index, 'SpecialSec', '')
  return true, hp_info
end


function get_current_map(showtext)
  local game_client = nx_value('game_client')
  if not nx_is_valid(game_client) then
    return nx_string('')
  end
  local game_scence = game_client:GetScene()
  if not nx_is_valid(game_scence) then
    return nx_string('')
  end
  if showtext == nil then
    return game_scence:QueryProp('Resource')
  else
    return game_scence:QueryProp('ConfigID')
  end
end

function getIni_Nc6(inifile,method,tree_1,tree_2,tree_3)
	local game_config = nx_value('game_config')
    local account = game_config.login_account
	local game_client = nx_value('game_client')	
	local client_player = game_client:GetPlayer()	
	local game_config = nx_value('game_config')
	if not nx_is_valid(game_config) and nx_is_valid(client_player) then return end
	local account = game_config.login_account
	local server_ID = game_config.server_id
	local dir = nx_function('ext_get_current_exe_path') .. 'nockasdd_'.. account..'_'..nx_string(server_ID) 
    local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then
        return
    end
	ini.FileName = dir .. '\\'..nx_string(inifile)   
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
function setItemSell(config_id,uniqueID,monney)
	local form_logic = nx_value('form_main_sysinfo')
	if nx_is_valid(form_logic) and nx_find_method(form_logic, 'SaveFightInfoToFile') then
	form_logic:SaveStallPriceInfo(nx_widestr(config_id) .. nx_widestr('/') .. nx_widestr(uniqueID) .. nx_widestr('/') .. nx_widestr(nx_int(nx_number(monney) / 1000000)) .. nx_widestr('/') .. nx_widestr(nx_int(nx_number(monney) % 1000000 / 1000)) .. nx_widestr('/') .. nx_widestr(nx_int(nx_number(monney) % 1000)) .. nx_widestr('/'))
	end
end
function remove_iniSection(inifile, section)
	local ini = nx_create('IniDocument')
	local file = inifile
	ini.FileName = file
	ini:LoadFromFile()
	if ini:LoadFromFile() then
		if ini:FindSection(section) then
			ini:DeleteSection(section)
			ini:SaveToFile()
			nx_destroy(ini)
		end
	end
end
function SaveSetting(type,method,nameElement,value)	
	local inifile = add_file_user('auto_skill')
    local ini = nx_create("IniDocument")
    if not nx_is_valid(ini) then
        return
    end
    ini.FileName = inifile	
	if ini:LoadFromFile() then
		if not ini:FindSection(type) then			
			ini:AddSection(nx_string(type))
			ini:SaveToFile()			
		end				
		if method == "String" then
			ini:WriteString(type,nx_string(nameElement),nx_string(value))
		end
		if method == "Int" then
			ini:WriteInteger(type,nx_string(nameElement),nx_string(value))
		end
	end
	ini:SaveToFile()
	nx_destroy(ini)
end
function getIni(inifile,method,tree_1,tree_2,tree_3)
	local inifile = add_file_user('auto_skill')
    local ini = nx_create("IniDocument")
    if not nx_is_valid(ini) then
        return
    end
    ini.FileName = inifile
	if not ini:LoadFromFile() then
		return false
	end
	local data = nil
	if method == "String" then
		data = ini:ReadString(tree_1, tree_2, tree_3)
	end
	if method == "Int" then
		data = nx_number(ini:ReadInteger(tree_1, tree_2, tree_3))
	end
	nx_destroy(ini)
	return data
end
function iniStringSelect(type,method,name)
	local inifile = add_file_user('auto_skill')
    local ini = nx_create("IniDocument")
    if not nx_is_valid(ini) then
        return
    end
    ini.FileName = inifile	
    local skill = {}
	local skillini = ""
	if ini:LoadFromFile() then	
		for i = 1, 9 do
			if method == "String"then
				skillini = ini:ReadString(nx_string(type), nx_string(name .. i), "")
			end
			if method == "Int" then
				skillini = nx_number(ini:ReadInteger(nx_string(type), nx_string(name .. i), ""))
			end
			if skillini ~= "" then
				table.insert(skill, skillini)					
			end
		end
	end
	return skill
end
function SaveSetting_nc6(inifile,type,method,nameElement,value)
	local game_config = nx_value('game_config')
    local account = game_config.login_account
	local game_client = nx_value('game_client')	
	local client_player = game_client:GetPlayer()	
	local game_config = nx_value('game_config')
	if not nx_is_valid(game_config) and nx_is_valid(client_player) then return end
	local account = game_config.login_account
	local server_ID = game_config.server_id
	local dir = nx_function('ext_get_current_exe_path') .. 'nockasdd_'.. account..'_'..nx_string(server_ID) 
	if not nx_function('ext_is_exist_directory', nx_string(dir)) then
      nx_function('ext_create_directory', nx_string(dir))	 
    end
    local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then
        return
    end
	ini.FileName = dir .. '\\'..nx_string(inifile)
	if not nx_function('ext_is_file_exist', ini.FileName) then
		local stringfile = nx_create('StringList')		
		stringfile:SaveToFile(ini.FileName)
	end
	if ini:LoadFromFile() then
		if not ini:FindSection(type) then			
			ini:AddSection(nx_string(type))	
			ini:SaveToFile()	
		end				
		if method == 'String' then
			ini:WriteString(type,nx_string(nameElement),nx_string(value))
			ini:SaveToFile()
		end
		if method == 'Int' then
			ini:WriteInteger(type,nx_string(nameElement),nx_string(value))
			ini:SaveToFile()
		end
	end	
	nx_destroy(ini)
end
show_log_system = function(str)
	local form_main_chat_logic = nx_value('form_main_chat')
	if nx_is_valid(form_main_chat_logic) then
		form_main_chat_logic:AddChatInfoEx(utf8ToWstr(str), 4, false)
	end
end
show_log_system_t = function(str)
	local form_main_chat_logic = nx_value('form_main_chat')
	if nx_is_valid(form_main_chat_logic) then
		form_main_chat_logic:AddChatInfoEx(utf8ToWstr(str), 17, false)
	end
end
auto_show_on_dev = function(type_dev)
	if nx_string(type_dev) == 'de' then
		util_auto_show_hide_form("form_test\\form_debug")
	elseif nx_string(type_dev) == 'col' then	
		nx_execute("util_gui", "util_auto_show_hide_form", "move_test\\form_collide_test")
	elseif nx_string(type_dev) == 're' then		
		local world = nx_value("world")
		world:ReloadAllEffect()
	elseif nx_string(type_dev) == 'a2' then	
		 assert(loadfile("E:\\auto\\" .. "a2.lua"))()
	elseif nx_string(type_dev) == 'posid' then	
		 getIDPos()	 
	elseif nx_string(type_dev) == 'npcid' then	
		 getIdNpc()		 
	elseif nx_string(type_dev) == 'pos' then
		getPos()
	elseif nx_string(type_dev) == 'skill' then
		getSkillID()
	end
end
function getIDPos()
  local selectobj = nx_value(GAME_SELECT_OBJECT)
  local id, x, y, z, o = selectobj:QueryProp("ConfigID"), string.format("%.5f", selectobj.PosiX), string.format("%.5f", selectobj.PosiY), string.format("%.5f", selectobj.PosiZ), string.format("%.5f", selectobj.Orient)
  local src = "ID: " .. id .. " X: " .. nx_string(x) .. " Y: " .. nx_string(y) .. " Z: " .. nx_string(z) .. " O: " .. nx_string(o)
  copyText(src)
end
function getIdNpc()
  local selectobj = nx_value(GAME_SELECT_OBJECT)
  local id = selectobj:QueryProp("ConfigID")
  copyText(id)
end
function getPos()
  local game_visual = nx_value("game_visual")
  if nx_is_valid(game_visual) then
    local game_player = game_visual:GetPlayer()
    local x = string.format("%.3f", game_player.PositionX)
    local y = string.format("%.3f", game_player.PositionY)
    local z = string.format("%.3f", game_player.PositionZ)
    local text = x .. "," .. y .. "," .. z
    copyText(text)
  end
end
function getSkillID()
  local selectobj = nx_value(GAME_SELECT_OBJECT)
  local id = selectobj:QueryProp("CurSkillID")
  local src = "IDSkill: " .. id
  copyText(src)
end
auto_show_check_blink = function()
	local form_map = nx_value('form_stage_main\\form_map\\form_map_scene')
	if not nx_is_valid(form_map) and not form_map.Visible then
		return
	end	
	if form_map.cbtn_enable_jump.Visible then
		form_map.cbtn_enable_jump.Visible = false
		form_map.cbtn_enable_jump.Checked = false
		nx_execute('form_stage_main\\form_map\\form_map_scene','set_show_tick_blink',false)
	else
		form_map.cbtn_enable_jump.Visible = true
		nx_execute('form_stage_main\\form_map\\form_map_scene','set_show_tick_blink',true)
	end
end
show_system_notice = function(str)
	local form_main_chat_logic = nx_value('form_main_chat')
	 local content = nx_function("ext_utf8_to_widestr", "<font color='#d90000'>[AutoCack]</font> " .. str)
	if nx_is_valid(form_main_chat_logic) then
		form_main_chat_logic:AddChatInfoEx(content, 17, false)
	end
end
function get_format_time_text_hd(time)
	nx_pause(0.5)
	if not time then return '' end	
	local msg_delay = nx_value('MessageDelay')
	local cur_date_time = string.format('%.0f',msg_delay:GetServerNowTime()/1000)
	local buf_time = time - cur_date_time
	local d = nx_int(buf_time/86400)
	local h = nx_int(buf_time / 3600)
	local m = nx_int(nx_int(buf_time)  / 60)
	local s = nx_int(buf_time) - nx_int(60 * m)
	return nx_string(d),nx_string(h),nx_string(m),nx_string(s)
end
get_date_from_unix = function(unix_time)
    local day_count, year, days, month = function(yr) return (yr % 4 == 0 and (yr % 100 ~= 0 or yr % 400 == 0)) and 366 or 365 end, 1970, math.ceil(unix_time/86400)

    while days >= day_count(year) do
        days = days - day_count(year) year = year + 1
    end
    local tab_overflow = function(seed, table) for i = 1, #table do if seed - table[i] <= 0 then return i, seed end seed = seed - table[i] end end
    month, days = tab_overflow(days, {31,(day_count(year) == 366 and 29 or 28),31,30,31,30,31,31,30,31,30,31})
    local hours, minutes, seconds = math.floor(unix_time / 3600 % 24), math.floor(unix_time / 60 % 60), math.floor(unix_time % 60)
    hours = hours > 12 and hours - 12 or hours == 0 and 12 or hours
    return string.format("%d/%d/%04d", days, month, year - 369)
end
show_expire_day_auto = function(file,lic_name,lic)
	nx_pause(0.1)
	local day,month,year,unix =  get_key_file_auto(file,lic)
	local datea,hour,min,sec = get_format_time_text_hd(unix)
	local lic_expire = "<font color='#a300d9'>"..nx_string(lic_name).."</font> "
	local expire = "<font color='#ff0040'>Đã hết hạn</font> "
	local check_expire = nx_string(day)..'/'..nx_string(month)..'/'..nx_string(year)..'<br> - Bạn còn lại: '..nx_string(datea)..' Ngày'
	local check_expire_2 = nx_string(day)..'/'..nx_string(month)..'/'..nx_string(year)..'- Bạn còn lại: '..nx_string(datea)..' Ngày'
	if nx_number(datea) < 0 then
		check_expire = expire
		check_expire_2 = 'Đã hết hạn'
	end
	show_system_notice('<br> - Key '..lic_expire..' Hạn Dùng: '..check_expire ..'<br>===================================================')	
	show_log_system(' - Key '..nx_string(lic_name)..' Hạn Dùng: ' ..check_expire_2)	
	show_log_system('===================================================')
end
function getInfoAccount()
	local game_client = nx_value('game_client')	
	local client_player = game_client:GetPlayer()	
	local game_config = nx_value('game_config')
	local account = string.lower(game_config.login_account)	
	local name_account = nx_function('ext_widestr_to_utf8',client_player:QueryProp('Name'))
	local serverName = game_config.cur_server_name
	local nameRemove = string.gsub(name_account,'@.*','')
	local server_ID = game_config.server_id
	local dir
	local serverID
    if server_ID == '7100028' then
		dir =  nx_function('ext_get_current_exe_path') .. 'nockasdd_'.. account..'_'..nx_string('7100028')
	elseif server_ID == '7100024' then	
		dir =  nx_function('ext_get_current_exe_path') .. 'nockasdd_'.. account..'_'..nx_string('7100024')
    else
		dir = nx_function('ext_get_current_exe_path') .. 'nockasdd_'.. account..'_'..nx_string(server_ID)
    end
    if not nx_function('ext_is_exist_directory', nx_string(dir)) then
      nx_function('ext_create_directory', nx_string(dir))	 
    end
	return dir,account,nameRemove 
end
show_date_time_expire = function()
	local dir,account,nameRemove = getInfoAccount()
	local ini_file = '\\Active.ini'
	local file1 = dir ..ini_file
	local lic_expire = ''
	local lic_name = ''
	if nx_function('ext_is_file_exist', file1) then
		local data = nx_string(readIni(file1,'key','lic_full',''))
		local data_ab = nx_string(readIni(file1,'key','lic_ab',''))
		local data_target = nx_string(readIni(file1,'key','lic_target',''))
		local data_thbb = nx_string(readIni(file1,'key','lic_thbb',''))
		local data_search_player = nx_string(readIni(file1,'key','lic_search_player',''))
		local data_def = nx_string(readIni(file1,'key','lic_def',''))
		local data_swap = nx_string(readIni(file1,'key','lic_swap',''))
		local data_ping_plus = nx_string(readIni(file1,'key','lic_ping_plus',''))
		local data_ping = nx_string(readIni(file1,'key','lic_ping',''))
		local data_undef = nx_string(readIni(file1,'key','lic_undef',''))
		local data_bugquat = nx_string(readIni(file1,'key','lic_bugquat',''))
		local data_auto_speed = nx_string(readIni(file1,'key','lic_auto_speed',''))
		local data_hpmp = nx_string(readIni(file1,'key','lic_auto_speed',''))
		if data and data ~= '0' and data ~= '' then
			lic_expire = 'lic_full'
			lic_name = 'Auto Full'
			show_expire_day_auto(file1,lic_name,lic_expire)				
		end	
		if data_ab and data_ab ~= '0' and data_ab ~= '' then
			lic_expire = 'lic_ab'	
			lic_name = 'Auto AB'
			show_expire_day_auto(file1,lic_name,lic_expire)	
		end	
		-- if data_target and data_target ~= '0' and data_target ~= '' then
			-- lic_expire = 'lic_target'	
			-- lic_name = 'Auto Target'
			-- show_expire_day_auto(file1,lic_name,lic_expire)	
		-- end		
		-- if data_thbb and data_thbb ~= '0' and data_thbb ~= '' then
			-- lic_expire = 'lic_thbb'	
			-- lic_name = 'Auto THBB'
			-- show_expire_day_auto(file1,lic_name,lic_expire)	
		-- end		
		-- if data_search_player and data_search_player ~= '0' and data_search_player ~= '' then
			-- lic_expire = 'lic_search_player'	
			-- lic_name = 'Auto TNV'
			-- show_expire_day_auto(file1,lic_name,lic_expire)	
		-- end		
		-- if data_def and data_def ~= '0' and data_def ~= '' then
			-- lic_expire = 'lic_def'	
			-- lic_name = 'Auto UnDef Skill'
			-- show_expire_day_auto(file1,lic_name,lic_expire)	
		-- end		
		-- if data_swap and data_swap ~= '0' and data_swap ~= '' then
			-- lic_expire = 'lic_swap'	
			-- lic_name = 'Auto Swap Plus'
			-- show_expire_day_auto(file1,lic_name,lic_expire)	
		-- end		
		-- if data_ping_plus and data_ping_plus ~= '0' and data_ping_plus ~= '' then
			-- lic_expire = 'lic_ping_plus'	
			-- lic_name = 'Auto Ping Plus'
			-- show_expire_day_auto(file1,lic_name,lic_expire)	
		-- end		
		-- if data_ping and data_ping ~= '0' and data_ping ~= '' then
			-- lic_expire = 'lic_ping'	
			-- lic_name = 'Auto Ping'
			-- show_expire_day_auto(file1,lic_name,lic_expire)	
		-- end		
		if data_undef and data_undef ~= '0' and data_undef ~= '' then
			lic_expire = 'lic_undef'	
			lic_name = 'Auto Undef'
			show_expire_day_auto(file1,lic_name,lic_expire)	
		end		
		if data_bugquat and data_bugquat ~= '0' and data_bugquat ~= '' then
			lic_expire = 'lic_bugquat'	
			lic_name = 'Auto Bug Quạt'
			show_expire_day_auto(file1,lic_name,lic_expire)	
		end		
		if data_hpmp and data_hpmp ~= '0' and data_hpmp ~= '' then
			lic_expire = 'lic_hpmp'	
			lic_name = 'Auto Buff HPMP'
			show_expire_day_auto(file1,lic_name,lic_expire)	
		end		
		-- if data_auto_speed and data_auto_speed ~= '0' and data_auto_speed ~= '' then
			-- lic_expire = 'lic_auto_speed'	
			-- lic_name = 'Auto Speed'
			-- show_expire_day_auto(file1,lic_name,lic_expire)	
		-- end		
		
	end		
end
select_ban_skill_taolu_mr = function()	
	nx_pause(1)
	local inifile = add_file_user('auto_ai')
	local ban1 = wstrToUtf8(readIni(inifile,nx_string(AUTO_TT), "selectskillban1", ""))
	local ban2 = wstrToUtf8(readIni(inifile,nx_string(AUTO_TT), "selectskillban2", ""))
	local form = nx_value("form_stage_main\\form_match\\form_banxuan_taolu")	
	if not nx_is_valid(form) or not form.Visible then
		return false
	end
	if nx_is_valid(form) and form.Visible then
		if check_score_revenge() > 11000  then
			if form.btn_1.Enabled == true and form.lbl_13.Text == nx_widestr("") then
				if check_exist_skill_taolu(ban1) then
					local skill_check = check_ban_skill(ban1)
					if skill_check ~= nil then
						form.btn_1.DataSource = nx_string(skill_check)
						nx_execute("form_stage_main\\form_match\\form_banxuan_taolu", "SendBanxuanOper", form)
					else
						nx_execute("form_stage_main\\form_match\\form_banxuan_taolu", "SendBanxuanOper", form)
					end
				else
					nx_execute("form_stage_main\\form_match\\form_banxuan_taolu", "SendBanxuanOper", form)				
				end
			elseif form.lbl_14.Text == nx_widestr("") then
				if check_exist_skill_taolu(ban2) then
					local skill_check = check_ban_skill(ban2)
					if skill_check ~= nil then
						form.btn_1.DataSource = nx_string(skill_check)
						nx_execute("form_stage_main\\form_match\\form_banxuan_taolu", "SendBanxuanOper", form)
					else
						nx_execute("form_stage_main\\form_match\\form_banxuan_taolu", "SendBanxuanOper", form)
					end
				else
					nx_execute("form_stage_main\\form_match\\form_banxuan_taolu", "SendBanxuanOper", form)				
				end
			end
		else
			if form.btn_1.Enabled == true and form.lbl_13.Text == nx_widestr("") then
				nx_pause(0.5)
				if not check_exist_skill_taolu(ban2) then
				  local skill_check = check_ban_skill(ban2)
				  if skill_check ~= nil then
					form.btn_1.DataSource = nx_string(skill_check)
					nx_execute("form_stage_main\\form_match\\form_banxuan_taolu", "SendBanxuanOper", form)
				  else
					nx_execute("form_stage_main\\form_match\\form_banxuan_taolu", "SendBanxuanOper", form)
				  end
				else
				  nx_execute("form_stage_main\\form_match\\form_banxuan_taolu", "SendBanxuanOper", form)
				end
			end			
		end		
	end
	nx_pause(1)
end
check_exist_skill_taolu = function(taolu)
	if taolu and taolu ~= "" then
		return true
	end
	return false
end
check_ban_skill = function(skill_id)
	local form = nx_value("form_stage_main\\form_match\\form_banxuan_taolu")
	if not nx_is_valid(form) or not form.Visible then
		return false
	end
	if nx_is_valid(form) then
		local row = form.textgrid_1.RowCount
		for i = 0, row - 1 do
			local taolu_config = form.textgrid_1:GetGridText(i, 1)
			if nx_string(taolu_config) == nx_string(skill_id) then
				return taolu_config
			end
		end
	end
	return nil
end
function send_homepoint_msg_to_server(...)
    local game_visual = nx_value('game_visual')
    if not nx_is_valid(game_visual) then
        return
    end
    game_visual:CustomSend(nx_int(CLIENT_CUSTOMMSG_SET_HOMEPOINT), unpack(arg))
end

function get_type_homepoint(type_name)
    local ini = nx_execute('util_functions', 'get_ini', HOMEPOINT_INI_FILE)
    if not nx_is_valid(ini) then
        return '', ''
    end
    local index = ini:FindSectionIndex(nx_string(type_name))
    if index < 0 then
        return '', ''
    end
    local hp = ini:ReadString(index, 'Type', '')
    local htext = ini:ReadString(index, 'Name', '')
    return hp, htext
end



function get_cur_time()
  local msg_delay = nx_value('MessageDelay')
    if not(nx_is_valid(msg_delay)) then return  0 end
    return math.floor(msg_delay:GetServerNowTime()/1000) + 7*3600
end
function get_tomorow_time()
  return get_today_time() + 86400
end
function get_today_time()
  local curTime = get_cur_time()
  return curTime - (curTime%86400)
end

function getMinAndMaxNeigong()
    local game_client = nx_value('game_client')
    if not nx_is_valid(game_client) then
        return '', ''
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return '', ''
    end
    local view = game_client:GetView(nx_string(43))
    if not nx_is_valid(view) then
        return '', ''
    end
    local viewobj_list = view:GetViewObjList()
    local minNeigongID = ''
    local maxNeigongID = ''
    local minNeigongVal = 1000
    local maxNeigongVal = 0
    for i = 1, table.getn(viewobj_list) do
		 local configid_neigong = player_client:QueryProp('CurNeiGong')
        local configid = viewobj_list[i]:QueryProp('ConfigID')
        local level = viewobj_list[i]:QueryProp('Level')
        local quality = viewobj_list[i]:QueryProp('Quality')
        local val = level * quality
        if val >= maxNeigongVal and nx_string(configid) ~= nx_string('ng_jh_306') and nx_string(configid) ~= nx_string('ng_jh_507') then
            maxNeigongID = configid_neigong
            maxNeigongVal = val
        end
        if val <= minNeigongVal then
            minNeigongID = configid
            minNeigongVal = val
        end
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return '', ''
    end
    return minNeigongID, maxNeigongID
end

function tools_move_isArrived(x, y, z, offset, fixedComparePos)
    local game_visual = nx_value('game_visual')
    if not nx_is_valid(game_visual) then
        return false
    end
    local game_player = game_visual:GetPlayer()
    if not nx_is_valid(game_player) then
        return false
    end
    if offset == nil then
        offset = 1
    end

    local px, py, pz
    if fixedComparePos == nil then
        px = string.format('%.3f', game_player.PositionX)
        py = string.format('%.3f', game_player.PositionY)
        pz = string.format('%.3f', game_player.PositionZ)
    else
        px = string.format('%.3f', fixedComparePos[1])
        py = string.format('%.3f', fixedComparePos[2])
        pz = string.format('%.3f', fixedComparePos[3])
    end

    local pxd = px - x
    local pyd = py - y
    local pzd = pz - z

    local distance = math.sqrt(pxd * pxd + pyd * pyd + pzd * pzd)

    if offset >= distance then
        return true
    end
    return false
end

function tools_move_isArrived2D(x, y, z, offset, fixedComparePos)
    local game_visual = nx_value('game_visual')
    if not nx_is_valid(game_visual) then
        return false
    end
    local game_player = game_visual:GetPlayer()
    if not nx_is_valid(game_player) then
        return false
    end
    if offset == nil then
        offset = 1
    end

    local px, py, pz
    if fixedComparePos == nil then
        px = string.format('%.3f', game_player.PositionX)
        py = string.format('%.3f', game_player.PositionY)
        pz = string.format('%.3f', game_player.PositionZ)
    else
        px = string.format('%.3f', fixedComparePos[1])
        py = string.format('%.3f', fixedComparePos[2])
        pz = string.format('%.3f', fixedComparePos[3])
    end

    local pxd = px - x
    local pyd = py - y
    local pzd = pz - z

    local distance = math.sqrt(pxd * pxd + pzd * pzd)

    if offset >= distance then
        return true
    end
    return false
end

function get_buff_info(buff_id, obj)
    local objGetBuff = nil
    if obj == nil then
        local game_client = nx_value('game_client')
        if not nx_is_valid(game_client) then
            return nil
        end
        objGetBuff = game_client:GetPlayer()
    else
        objGetBuff = obj
    end
    if not nx_is_valid(objGetBuff) then
        return nil
    end
    for i = 1, 25 do
        local buff = objGetBuff:QueryProp('BufferInfo' .. tostring(i))
        if buff ~= 0 and buff ~= '' then
            local buff_info = util_split_string(buff, ',')
            local buff_name = nx_string(buff_info[1])
            if nx_string(buff_id) == nx_string(buff_name) then
                local buff_time = buff_info[4]
                if nx_int(buff_time) == nx_int(0) then
                    return 0
                end
                local MessageDelay = nx_value('MessageDelay')
                if not nx_is_valid(MessageDelay) then
                    return nil
                end
                local server_now_time = MessageDelay:GetServerNowTime()
                local buff_diff_time = tonumber((buff_time - server_now_time) / 1000) -- Unit timesamp
                return buff_diff_time
            end
        end
    end
    return nil
end

function getInfoHeightOfPos(x, z)
    local scene = nx_value('game_scene')
    if not nx_is_valid(scene) then
        return nil
    end
    local terrain = scene.terrain
    if not nx_is_valid(terrain) then
        return nil
    end
    local posY = terrain:GetPosiY(x, z)
    local walkHeight = terrain:GetWalkHeight(x, z)
    local maxHeight = walkHeight
    local floorHeightTable = {}
    local floor_count = terrain:GetFloorCount(x, z)
    for i = floor_count - 1, 0, -1 do
        local floor_height = terrain:GetFloorHeight(x, z, i)
        if floor_height ~= posY then
            table.insert(floorHeightTable, floor_height)
        end
        if floor_height > maxHeight then
            maxHeight = floor_height
        end
    end
    local waterHeight = -10000
    if terrain:GetWalkWaterExists(x, z) then
        waterHeight = terrain:GetWalkWaterHeight(x, z)
    end
    if waterHeight > maxHeight then
        maxHeight = waterHeight
    end
    if waterHeight > walkHeight then
        walkHeight = waterHeight
    end
    return walkHeight, maxHeight, waterHeight
end

function tools_move(scene, x, y, z, passtest, findonlymap)
    local game_visual = nx_value('game_visual')
    if not nx_is_valid(game_visual) then
        return false
    end
    local game_player = game_visual:GetPlayer()
    if not nx_is_valid(game_player) then
        return false
    end
    if passtest ~= nil and passtest == true then       
        if findonlymap == nil then
            nx_value('path_finding'):FindPathScene(scene, x, y, z, 0)
        else
            nx_value('path_finding'):FindPath(x, y, z, 0)
        end
        return true
    end
    local beforeX = string.format('%.3f', game_player.PositionX)
    local beforeY = string.format('%.3f', game_player.PositionY)
    local beforeZ = string.format('%.3f', game_player.PositionZ)
    nx_pause(1)
    local game_visual = nx_value('game_visual')
    if not nx_is_valid(game_visual) then
        return false
    end
    local game_player = game_visual:GetPlayer()
    if not nx_is_valid(game_player) then
        return false
    end
    local afterX = string.format('%.3f', game_player.PositionX)
    local afterY = string.format('%.3f', game_player.PositionY)
    local afterZ = string.format('%.3f', game_player.PositionZ)

    local pxd = beforeX - afterX
    local pyd = beforeY - afterY
    local pzd = beforeZ - afterZ

      local distance = math.sqrt(pxd * pxd + pyd * pyd + pzd * pzd)
      if distance <= 0.6 then
        if findonlymap == nil then
            nx_value('path_finding'):FindPathScene(scene, x, y, z, 0)
        else
            nx_value('path_finding'):FindPath(x, y, z, 0)
        end
      end
end
function tools_difftime(t)
    if t == nil then
        return os.time()
    end
    return os.difftime(os.time(), t)
end

function jump_to(pos, stepDistance, stepPause, dissMisscheck)
if stepDistance == nil then
stepDistance = 50
end
if stepPause == nil then
stepPause = 2
end
if not tools_move_isArrived(pos[1], pos[2], pos[3], 0.5) then
local x = nx_float(pos[1])
local y = nx_float(pos[2])
local z = nx_float(pos[3])
local px = string.format('%.3f', nx_string(x))
local py = string.format('%.3f', nx_string(y))
local pz = string.format('%.3f', nx_string(z))

local game_visual = nx_value('game_visual')
if not nx_is_valid(game_visual) then
return false
end
local game_client = nx_value('game_client')
if not nx_is_valid(game_client) then
return false
end
local role = nx_value('role')
if not nx_is_valid(role) then
return false
end
local scene_obj = nx_value('scene_obj')
if not nx_is_valid(scene_obj) then
return false
end
local game_player = game_visual:GetPlayer()
if not nx_is_valid(game_player) then
return false
end
local player_client = game_client:GetPlayer()
if not nx_is_valid(player_client) then
return false
end
scene_obj:SceneObjAdjustAngle(role, x, z)
role.move_dest_orient = role.AngleY
role.server_pos_can_accept = true
role:SetPosition(role.PositionX, y, role.PositionZ)
game_visual:SetRoleMoveDestX(role, x)
game_visual:SetRoleMoveDestY(role, y)
game_visual:SetRoleMoveDestZ(role, z)
game_visual:SetRoleMoveDistance(role, stepDistance)
game_visual:SetRoleMaxMoveDistance(role, stepDistance)
game_visual:SwitchPlayerState(role, 1, 103)
nx_pause(stepPause)       
end
end

function jump_to_pos(pos, stepDistance, stepPause)
local form_map = nx_value('form_stage_main\\form_map\\form_map_scene')
local game_visual = nx_value('game_visual')
if pos == nil or pos[1] == nil or pos[2] == nil or pos[3] == nil or not nx_is_valid(game_visual) or nx_is_valid(nx_value('form_common\\form_loading')) then
return nil
end
local game_player = game_visual:GetPlayer()
if not nx_is_valid(game_player) or game_player == nil or not nx_is_valid(nx_value('path_finding')) or form_map == nil or not nx_is_valid(form_map) or form_map.current_map == nil then
return nil
end
local x, y, z = nx_float(pos[1]), nx_float(pos[2]), nx_float(pos[3])
local fx, fy, fz = nx_string(x),nx_string(y), nx_string(z)
fx, fy, fz = string.format('%.3f', fx), string.format('%.3f', fy), string.format('%.3f', fz)
local beforeX = string.format('%.3f', game_player.PositionX)
local beforeY = string.format('%.3f', game_player.PositionY)
local beforeZ = string.format('%.3f', game_player.PositionZ)
nx_pause(1)
if nx_is_valid(nx_value('form_common\\form_loading')) then
return nil
end
local afterX = string.format('%.3f', game_player.PositionX)
local afterY = string.format('%.3f', game_player.PositionY)
local afterZ = string.format('%.3f', game_player.PositionZ)
local pxd = beforeX - afterX
local pyd = beforeY - afterY
local pzd = beforeZ - afterZ
local distance = math.sqrt(pxd * pxd + pyd * pyd + pzd * pzd)
if distance <= 0.6 then  
local game_client = nx_value('game_client')
if not nx_is_valid(game_client) then
return false
end
local player = game_client:GetPlayer()
if not nx_is_valid(player) then
return false
end
local state = player:QueryProp('State')
if nx_string(state) == '' or state == nil or state == 0 then
jump_to(pos, stepDistance, stepPause)
end
end
return true
end
function jump_to_pos_new(x, y, z, map, fixedY, dissMisscheck)
local lastArrivePos = {x, y, z}
local walkHeight, maxHeight, waterHeight = getInfoHeightOfPos(lastArrivePos[1], lastArrivePos[3])
lastArrivePos[2] = walkHeight
if waterHeight == walkHeight then
lastArrivePos[2] = lastArrivePos[2] + 5
end
if fixedY ~= nil then      
lastArrivePos[2] = y
end   
local stepDistance = 90
local isPreCalculate = true 
local virtualCalcPos = nil
findPathBusy = true
while not tools_move_isArrived2D(lastArrivePos[1], lastArrivePos[2], lastArrivePos[3], 0.5) and findPathBusy do
local currentPos = nil
if isPreCalculate then
if virtualCalcPos == nil then            
currentPos = get_current_player_pos()
else          
currentPos = virtualCalcPos
end
else     
currentPos = get_current_player_pos()
end
if currentPos == nil then
showUtf8Text(ERROR_DATA, 2)
findPathBusy = false
nx_execute('form_stage_main\\form_map\\form_map_scene', 'stopJumpToPosMap')
return false
end     
local nextPos = nil     
local isFinalPos = false
if tools_move_isArrived(lastArrivePos[1], lastArrivePos[2], lastArrivePos[3], stepDistance, currentPos) then
nextPos = lastArrivePos
isFinalPos = true
else
local currentDst = 5
local setPos = nil
local radian = getAngleForward(currentPos[1], currentPos[3], lastArrivePos[1], lastArrivePos[3])
local angle = radian_to_degree(radian)
while 1 do
local xx = currentPos[1]
local zz = currentPos[3]
if angle <= 90 then
zz = zz + math.abs(math.sin(math.pi / 2 - radian) * currentDst)
xx = xx + math.abs(math.cos(math.pi / 2 - radian) * currentDst)
elseif angle > 90 and angle <= 180 then
zz = zz - math.abs(math.sin(math.pi * 3 / 2 - radian) * currentDst)
xx = xx + math.abs(math.cos(math.pi * 3 / 2 - radian) * currentDst)
elseif angle > 180 and angle <= 270 then
zz = zz - math.abs(math.sin(math.pi * 3 / 2 - radian) * currentDst)
xx = xx - math.abs(math.cos(math.pi * 3 / 2 - radian) * currentDst)
elseif angle > 270 then
zz = zz + math.abs(math.sin(math.pi * 3 / 2 - radian) * currentDst)
xx = xx - math.abs(math.cos(math.pi * 3 / 2 - radian) * currentDst)
end
	local posTmp = {xx, -10000, zz}
	local walkHeight, maxHeight = getInfoHeightOfPos(posTmp[1], posTmp[3])
	posTmp[2] = maxHeight + 20
	if tools_move_isArrived(posTmp[1], posTmp[2], posTmp[3], stepDistance, currentPos) then
		setPos = posTmp
	else
		break
	end
	currentDst = currentDst + 5
	if currentDst > stepDistance then
		break
		end
	end
		if setPos == nil then
			showUtf8Text(ERROR_BLINK_TERRAIN, 3)
			findPathBusy = false
			nx_execute('form_stage_main\\form_map\\form_map_scene', 'stopJumpToPosMap')
			return false
		end
		nextPos = setPos
	end
	if nextPos ~= nil then
		if isPreCalculate then             
			if isFinalPos then                
			isPreCalculate = false
		else                  
			virtualCalcPos = nextPos
		end
	else            
		local stepPause = 5
		if isFinalPos then              
			stepPause = 0
		end
			jump_to(nextPos, stepDistance, stepPause, dissMisscheck)
		end
	end
		nx_pause(0.05)
	end
	findPathBusy = false
	nx_execute('form_stage_main\\form_map\\form_map_scene', 'stopJumpToPosMap')
	showUtf8Text(FINISH_BLINK,3)
end
function get_pos_y_from_xz(terrain, x, z)
  if not nx_is_valid(terrain) then
    return 0, 0
  end
  local floor_index = 0
  local y = terrain:GetPosiY(x, z)
  if terrain:GetWalkWaterExists(x, z) and y < terrain:GetWalkWaterHeight(x, z) then
    y = terrain:GetWalkWaterHeight(x, z) + 15
  else
    local floor, floor_y = get_pos_floor_index(terrain, x, y, z)
    if floor > -1 then
      y = floor_y
      floor_index = floor
    end
  end
  return y + 20, floor_index
end
function radian_to_degree(radian)
  return math.floor(normalize_angle(radian) * 3600 / (math.pi * 2)) * 0.1
end
function getAngleForward(myposx, myposz, toposx, toposz)   
    local x1 = myposz
    local x2 = toposz
    local y1 = myposx
    local y2 = toposx
    if x2 == x1 then
        return 0
    end
    local tana = math.abs(y2 - y1) / math.abs(x2 - x1)
    local radian = math.atan(tana)
    if x2 > x1 and y2 > y1 then
        radian = radian
    elseif x2 < x1 and y2 > y1 then
        radian = math.pi - radian
    elseif x2 < x1 and y2 < y1 then
        radian = math.pi + radian
    elseif x2 > x1 and y2 < y1 then
        radian = (2 * math.pi) - radian
    end
    return radian
end
function normalize_angle(angle)
    local value = math.fmod(angle, math.pi * 2)
    if value < 0 then
        value = value + math.pi * 2
    end
    return value
end
function stop_jump_to_pos_new()
    findPathBusy = false
    nx_execute('form_stage_main\\form_map\\form_map_scene', 'stopJumpToPosMap')
end
function getPlayerPropStr(prop)
    local game_client = nx_value('game_client')
    if not nx_is_valid(game_client) then
        return nx_string('')
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return nx_string('')
    end
    return nx_string(player_client:QueryProp(nx_string(prop)))
end
function getPlayerPropWideStr(prop)
    local game_client = nx_value('game_client')
    if not nx_is_valid(game_client) then
        return nx_widestr('')
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return nx_widestr('')
    end
    return nx_widestr(player_client:QueryProp(nx_string(prop)))
end
function getPlayerPropInt(prop)
    local game_client = nx_value('game_client')
    if not nx_is_valid(game_client) then
        return nx_int(0)
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return nx_int(0)
    end
    return nx_int(player_client:QueryProp(nx_string(prop)))
end
getUpperSilver = function()
	local game_client = nx_value('game_client')
	local client_player = game_client:GetPlayer()
	if not nx_is_valid(client_player) then
		return
	end
	return client_player:QueryProp('CapitalType2')
end
function tool_getPickForm(itemIDs)
    local client = nx_value('game_client')
    if not nx_is_valid(client) then
        return 0
    end
    local game_visual = nx_value('game_visual')
    if not nx_is_valid(game_visual) then
        return 0
    end
    local client_player = client:GetPlayer()
    if not nx_is_valid(client_player) then
        return 0
    end
    local view = client:GetView(nx_string(80))
    if not nx_is_valid(view) then
        return 0
    end
    local viewobj_list = view:GetViewObjList()
    local numberItems = table.getn(viewobj_list)
    if numberItems > 0 then
        for k = 1, numberItems do
            local item = viewobj_list[k]
            local itemID = item:QueryProp('ConfigID')
            if itemIDs == nil or in_array(itemID, itemIDs) then
                nx_execute('custom_sender', 'custom_pickup_single_item', nx_int(item.Ident))
            end
        end
        nx_execute('custom_sender', 'custom_close_drop_box')
    end
    return numberItems
end
function stopPlayerHackMove()
    local role = nx_value('role')
    if not nx_is_valid(role) then
        return false
    end
    local game_visual = nx_value('game_visual')
    if not nx_is_valid(game_visual) then
        return false
    end
    game_visual:SwitchPlayerState(role, 'static', 1)
end
function in_array(item, array)
    for _,v in pairs(array) do
        if nx_string(v) == nx_string(item) then
            return true
        end
    end
    return false
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
  multitextbox.HAlign = 'Right'
  multitextbox.LineTextAlign = 'Center'
  multitextbox.Width = '45' 
  multitextbox.Height = '45'
  multitextbox.AutoSize = false
  multitextbox.Transparent = true
  multitextbox.Name = 'MultiTextBox'
  multitextbox.TextColor = '255,128,101,74'
  multitextbox.SelectBarColor = '0,0,0,0'
  multitextbox.MouseInBarColor = '0,0,0,0'
  multitextbox.Font = 'font_text'
  multitextbox.LineColor = '0,0,0,0'
  multitextbox.ShadowColor = '0,0,0,0'
  multitextbox.ViewRect = '0,0,310,80'
  return multitextbox
end
function create_button(funcauto, row,title,func,filename)
  local gui = nx_value('gui')
  local grp = gui:Create('GroupBox')
  grp.BackColor = '0,0,0,0'
  grp.LineColor = '0,0,0,0'
  local button = gui:Create('Button')
  if not nx_is_valid(button) then
    return
  end
  button.Top = 15
  button.ForeColor = '255,255,255,255'
  button.AutoSize = false
  button.NormalImage = 'gui\\common\\button\\btn_normal2_out.png'
  button.FocusImage = 'gui\\common\\button\\btn_normal2_on.png'
  button.PushImage = 'gui\\common\\button\\btn_normal2_down.png'
  button.DrawMode = 'ExpandH'
  button.Hight = 26
  button.row_index = row
  button.func_ai = funcauto
  if filename ~= nil then
	button.file_name = filename
  end
  button.Text = utf8ToWstr(title)
  nx_bind_script(button, nx_current())
  nx_callback(button, 'on_click',nx_string(func)) 
  grp:Add(button)
  return grp
end
function removeSection(inifile, section)	 
    local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then
        return
    end
	ini.FileName = nx_string(inifile) 
	if ini:LoadFromFile() then
		if ini:FindSection(section) then
			ini:DeleteSection(section)
			ini:SaveToFile()
			nx_destroy(ini)
		end
	end
end
getCurrentScene_id = function ()
	local game_client = nx_value('game_client') 
	if not nx_is_valid(game_client) then
		return false
	end 
	local client_scene = game_client:GetScene() 
	if not nx_is_valid(client_scene) then 
		return false
	end 
	return nx_string(client_scene:QueryProp('Resource'))
end 
find_item_pos_bag = function(item_name,bag)
	local game_client = nx_value('game_client')
	if not nx_is_valid(game_client) then return 0 end	
		local view = game_client:GetView(nx_string(bag)) 
		if nx_is_valid(view) then 
			local view_obj_table = view:GetViewObjList()
			for j = 1, table.getn(view_obj_table) do
				local view_obj = view_obj_table[j]
				local config_id = view_obj:QueryProp('ConfigID')
				local name = getUtf8Text(config_id)
				if nx_string(config_id) == nx_string(item_name) or string.find(name, item_name, 1, true) then
					local amount = 0
					if view_obj:FindProp('Amount') then
						amount = view_obj:QueryProp('Amount')
					end
					local cd_category = 0
					if view_obj:FindProp('CoolDownCategory') then
						cd_category = view_obj:QueryProp('CoolDownCategory')
					end
					return view_obj.Ident,bag , name, amount, cd_category
				end
			end
		end
	
	return 0
end
find_item_pos = function(item_name)
	local game_client = nx_value('game_client')
	if not nx_is_valid(game_client) then return 0 end
	viewID_List = { 2, 121, 123, 125} 
	for i = 1, table.getn(viewID_List) do 
		local view = game_client:GetView(nx_string(viewID_List[i])) 
		if nx_is_valid(view) then 
			local view_obj_table = view:GetViewObjList()
			for j = 1, table.getn(view_obj_table) do
				local view_obj = view_obj_table[j]
				local config_id = view_obj:QueryProp('ConfigID')
				local name = getUtf8Text(config_id)
				if nx_string(config_id) == nx_string(item_name) or string.find(name, item_name, 1, true) then
					local amount = 0
					if view_obj:FindProp('Amount') then
						amount = view_obj:QueryProp('Amount')
					end
					local cd_category = 0
					if view_obj:FindProp('CoolDownCategory') then
						cd_category = view_obj:QueryProp('CoolDownCategory')
					end
					return view_obj.Ident, viewID_List[i], name, amount, cd_category
				end
			end
		end
	end
	return 0
end
isInSpecificTVT_Time = function(str_id)
	local TimeLimitRecTableName = 'Time_Limit_Form_Rec' 
	local game_client = nx_value('game_client') 
	if not nx_is_valid(game_client) then return end
	local client_scene = game_client:GetScene() 
	if not nx_is_valid(client_scene) then return end
	if not client_scene:FindRecord(TimeLimitRecTableName) then return end
	local rows = client_scene:GetRecordRows(TimeLimitRecTableName)
	if rows == 0 then return end
	local gui = nx_value('gui') 
	for i = 0, rows - 1 do	
		local strId = client_scene:QueryRecord(TimeLimitRecTableName, i, 0)	
		if strId ~= nil then
			local strDescId = client_scene:QueryRecord(TimeLimitRecTableName, i, 1) 
			if nx_string(strDescId) == nx_string(str_id) then 
				return true
			end	
		end 
	end 
end 
local TVT_TYPE_SCHOOL_DANCE = 31	
local TVT_TYPE_YUNBIAO = 9			 
is_in_tvt_event = function(tvt_type)
	local form = nx_value(FORM_NOTICE_SHORTCUT) 
	if not nx_is_valid(form) then 
		return false
	end 
	local single_notice_str = nx_string(form.single_notice) 
	local common_notice_str = nx_string(form.common_notice)
	if string.find(nx_string(single_notice_str) .. nx_string(common_notice_str), ',' .. nx_string(tvt_type) .. ',', 1, true) then
		return true
	end 
	return false
end 
function isHaveNearPlayer(targetMe)
    local game_visual = nx_value('game_visual')
    if not nx_is_valid(game_visual) then
        return true
    end
    local game_client = nx_value('game_client')
    if not nx_is_valid(game_client) then
        return true
    end
    local game_scence = game_client:GetScene()
    if not nx_is_valid(game_scence) then
        return true
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return true
    end
    local gui = nx_value('gui')
    if not nx_is_valid(gui) then
        return true
    end
    local game_scence_objs = game_scence:GetSceneObjList()
    for i = 1, table.getn(game_scence_objs) do
        local obj = game_scence_objs[i]
        if nx_is_valid(obj) then
            if obj:QueryProp('Type') == 2 and player_client:QueryProp('Name') ~= obj:QueryProp('Name') and obj:QueryProp('OffLineState') == 0 and
               (targetMe == nil or nx_string(player_client.Ident) == nx_string(obj:QueryProp('LastObject')))
            then
                return true
            end
        end
    end
    return false
end
function get_cur_day_full()
    local MessageDelay = nx_value("MessageDelay")
    if not nx_is_valid(MessageDelay) then
        return 0
    end
    local cur_time = MessageDelay:GetServerSecond()
    local year = tonumber(os.date("%Y", cur_time))
    local month = tonumber(os.date("%m", cur_time))
    local day = tonumber(os.date("%d", cur_time))
    return os.date("%Y%m%d", cur_time), year, month, day
end
get_cur_day = function()
	local MessageDelay = nx_value("MessageDelay")
	if not nx_is_valid(MessageDelay) then
		return 0
	end
	local cur_time = MessageDelay:GetServerSecond()
	return tonumber(os.date("%Y%m%d", cur_time))
end
function getCompetitor()
    local game_client = nx_value('game_client')
    if not nx_is_valid(game_client) then
        return nx_null(), nx_null()
    end
    local game_scence = game_client:GetScene()
    if not nx_is_valid(game_scence) then
        return nx_null(), nx_null()
    end
    local game_visual = nx_value('game_visual')
    if not nx_is_valid(game_visual) then
        return nx_null(), nx_null()
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return nx_null(), nx_null()
    end
    if player_client:QueryProp('HPRatio') <= 0 then
        return nx_null(), nx_null()
    end
    local fight = nx_value('fight')
    if not nx_is_valid(fight) then
        return nx_null(), nx_null()
    end
    local game_scence_objs = game_scence:GetSceneObjList()
    for i = 1, table.getn(game_scence_objs) do
        local obj = game_scence_objs[i]
        if nx_is_valid(obj) then
            local visualObj = game_visual:GetSceneObj(obj.Ident)
            if nx_is_valid(visualObj) then
                local can_attack = fight:CanAttackPlayer(player_client, obj)
                if obj:QueryProp('Type') == 2 and can_attack and obj:QueryProp('HPRatio') > 0 then
                    return obj, visualObj
                end
            end
        end
    end
    return nx_null(), nx_null()
end
check_score_revenge = function()
	local game_client = nx_value('game_client')  
	local client_player = game_client:GetPlayer()
	if not nx_is_valid(client_player) then
		return
	end
	local curDiem = client_player:QueryProp('RevengeIntegral')
	return curDiem
end
select_room_mactch = function()
	local game_client = nx_value('game_client')  
	local client_player = game_client:GetPlayer()
	 local curDiem = client_player:QueryProp('RevengeIntegral')
	  local roomid = ''
	  if curDiem >= 0 then
		roomid = 'room1'
	  end
	  if curDiem >= 5000 then
		roomid = 'room2'
	  end
	  if curDiem >= 8000 then
		roomid = 'room3'
	  end
	  if curDiem >= 11000 then
		roomid = 'room4'
	  end
	  if curDiem >= 14000 then
		roomid = 'room5'
	  end
	  if curDiem >= 17000 then
		roomid = 'room6'
	  end
	 
	  nx_execute('custom_sender', 'custom_revenge_match', 0, roomid)
	  nx_execute('custom_sender', 'custom_revenge_match', 2, roomid)
end
find_mount_item = function()
	local game_client = nx_value('game_client')
	if not nx_is_valid(game_client) then return end
	local view = game_client:GetView(nx_string(2)) 
	if not nx_is_valid(view) then return end
	local view_obj_table = view:GetViewObjList()
	for j = 1, table.getn(view_obj_table) do
		local view_obj = view_obj_table[j]		
		if (string.find(nx_string(view_obj:QueryProp('ConfigID'):lower()), 'mount', 1, true) or string.find(nx_string(view_obj:QueryProp('ConfigID'):lower()), 'ride', 1, true)) and view_obj:FindProp('RideSkillID') and view_obj:FindProp('BindStatus') and (view_obj:FindProp('BeginTime') or string.find(nx_string(view_obj:QueryProp('ConfigID'):lower()), 'ride', 1, true)) then
			return view_obj.Ident
		end
	end
	return nil
end
getLuaTime = function(y, m, d, h, mi, s) 
	return os.time({day = nx_number(d), month = nx_number(m), year = nx_number(y), hour = nx_number(h), min = nx_number(mi), sec = nx_number(s)})
end
getCurTime = function() 
	local msg_delay = nx_value('MessageDelay')
	if not nx_is_valid(msg_delay) then return -1 end 
	return msg_delay:GetServerNowTime()/1000 
end 
get_cur_time_in_format = function()
	local msg_delay = nx_value('MessageDelay')
	if not nx_is_valid(msg_delay) then
		return
	end
	local cur_date_time = msg_delay:GetServerDateTime()
	local cur_year, cur_month, cur_day, cur_hour, cur_mins, cur_sec = nx_function('ext_decode_date', cur_date_time)
	local cur_time_in_format = string.format('%02d', cur_hour) .. ':' .. string.format('%02d', cur_mins) .. ':' .. string.format('%02d', cur_sec)
	return cur_time_in_format
end

find_client_player_prop = function(propName)
	local game_client = nx_value('game_client')
	local client_player = game_client:GetPlayer()
	if nx_is_valid(client_player) then 
		return client_player:FindProp(propName)
	end
end
get_client_player_prop = function(propName)
	local game_client = nx_value('game_client')
	local client_player = game_client:GetPlayer()
	if nx_is_valid(client_player) then 
		return client_player:QueryProp(propName)
	end
end
find_obj_prop = function(obj, propName)
	local game_visual = nx_value('game_visual')
	if not nx_is_valid(game_visual) or not nx_is_valid(obj) then return end
	return obj:FindProp(propName)
end

get_obj_prop = function(obj, propName)
	local game_visual = nx_value('game_visual')
	if not nx_is_valid(game_visual) or not nx_is_valid(obj) then return end
	if obj:FindProp(propName) then
		return obj:QueryProp(propName)
	end
end
get_logicstate = function()
	return get_client_player_prop('LogicState')
end
stop_sitcross = function()
	if get_logicstate() == LS_SITCROSS then
		nx_execute('custom_sender', 'custom_sitcross', 2)
	end
end
is_player_have_buff = function(buff_name)
	local game_client = nx_value('game_client')
	if not nx_is_valid(game_client) then return end
	local client_player = game_client:GetPlayer()
	if not nx_is_valid(client_player) then return end
	for j = 1, 32 do
		local str = nx_string('BufferInfo') .. nx_string(j)
		if client_player:FindProp(str) then
			if string.find(nx_string(client_player:QueryProp(str)) ,nx_string(buff_name), 1, true) then
				return true 
			end
		end
	end
	return false
end
is_obj_have_buff = function(scene_obj, buffName)
	for j = 1, 32 do
		local str = nx_string('BufferInfo') .. nx_string(j)
		if scene_obj:FindProp(str) then
			if string.find(nx_string(scene_obj:QueryProp(str)), nx_string(buffName), 1, true) then return true end
		end
	end
	return false
end
get_obj_buff_time = function(obj, buffName)
	if not nx_is_valid(obj) then return -1 end 
	for j = 1, 32 do
		local str = nx_string('BufferInfo') .. nx_string(j)
		if obj:FindProp(str) then
			local infoList = auto_split_string(nx_string(obj:QueryProp(str)), ',')
			if string.find(nx_string(infoList[1]), nx_string(buffName), 1, true) then
				local cur_time = getCurTime()
				local end_time = nx_int64(infoList[4])/1000 
				if cur_time < end_time then
					return (nx_int64(infoList[4])/1000 - getCurTime())
				else
					return 0
				end
			end
		end
	end
	return -1
end
get_buff_time = function(buffName)
	local game_client = nx_value('game_client')
	if not nx_is_valid(game_client) then return -1 end 
	local client_player = game_client:GetPlayer()
	if not nx_is_valid(client_player) then return -1 end 	
	if buffName == 'auto' then return -1 end 	
	for j = 1, 32 do
		local str = nx_string('BufferInfo') .. nx_string(j)
		if client_player:FindProp(str) then
			local infoList = auto_split_string(nx_string(client_player:QueryProp(str)), ',')
			if string.find(nx_string(infoList[1]), nx_string(buffName), 1, true) then
				local cur_time = getCurTime()
				local end_time = nx_int64(infoList[4])/1000 
				if cur_time < end_time then
					return (nx_int64(infoList[4])/1000 - getCurTime())
				else
					return 0
				end
			end
		end
	end
	return -1
end
get_buff_info_data = function(buf_name)
	local game_client = nx_value('game_client')
	if not nx_is_valid(game_client) then return end
	local client_player = game_client:GetPlayer()
	if not nx_is_valid(client_player) then return end
	for j = 1, 32 do
		local str = nx_string('BufferInfo') .. nx_string(j)
		if client_player:FindProp(str) then
			local buf_info = string.gsub(nx_string(client_player:QueryProp(str)), '|', '')
			local infoList = auto_split_string(buf_info, ',')
			if string.find(nx_string(infoList[1]), nx_string(buf_name), 1, true) then
				local buf_level = nx_string(infoList[3])
				local buf_stack = nx_string(infoList[5])
				local cur_time = getCurTime()
				local end_time = nx_int64(infoList[4])/1000 
				if cur_time < end_time then
					return buf_level, (nx_int64(infoList[4])/1000 - getCurTime()), buf_stack
				else
					return buf_level, 0, buf_stack
				end
			end
		end
	end
end
MoveAndSeek = function(strPos, npcName, r) 
	local posList = auto_split_string(strPos, ';')
	local posCount = table.getn(posList)
	local count = 1 
	if npcName == nil and posCount > 1 then 
		for i = posCount, 1, -1 do 
			local pos = auto_split_string(nx_string(posList[i]), ',') 
			local x, y, z = nx_number(pos[1]), nx_number(pos[2]), nx_number(pos[3]) 
			if x == nil or y == nil or z == nil then return end
			if isInTargetRadius(x, y, z, 20) then 
				count = i 
				break 
			end 
		end 
	end 
	while count <= posCount
	do
		local pos = auto_split_string(nx_string(posList[count]), ',') 
		local x, y, z = nx_number(pos[1]), nx_number(pos[2]), nx_number(pos[3]) 
		local onMove = false
		if x == nil or y == nil or z == nil then return end
		while not isInTargetRadius(x, y, z, 2)
		do
			if onMove == false then
				moveTo(x, y, z) 
				nx_pause(2) 
				onMove = true
			end
			saveCurPos()
			local ret = FindNPC(npcName, r) 
			if ret~= nil then return end
			nx_pause(1) 
			if isLastPos() then 
				if is_path_finding() then 
					dis_mount()
					nx_value('fight'):TraceUseSkill('cs_jh_cqgf02', false, false)
					nx_pause(2) 
					local game_visual = nx_value('game_visual')
					if not nx_is_valid(game_visual) then return end 
					local visual_player = game_visual:GetPlayer()
					if not nx_is_valid(visual_player) then return end 
					visual_player:SetAngle(0, visual_player.AngleY + math.pi*3/4, 0)
					game_visual:SwitchPlayerState(visual_player, 'jump_small', 9)
					nx_pause(1.5) 
					if not is_path_finding() then moveTo(x, y, z) end 
					nx_pause(2) 
					if isLastPos() and not isInTargetRadius(x, y, z, 2) then 
						auto_stop_path_finding()
						dis_mount()
						nx_pause(2)
						return 
					end 
				end
				if not isInTargetRadius(x, y, z, 2) then
					return
				end
			end
		end
		count = count + 1 
		if count > posCount then 
			nx_value('path_finding') :StopPathFind(nx_value('game_visual') : GetPlayer())
		end
	end
	if npcName ~= nil then
		return false
	else
		return true
	end
end
function FindNPC(npcName, r)
	if npcName == nil then return end
	if r == nil then r = 2 end
	local game_client = nx_value('game_client') 
	if not nx_is_valid(game_client) then return end
	local game_scene = game_client:GetScene() 
	if not nx_is_valid(game_scene) then return end
	local gui = nx_value('gui') 
	local client_obj_lst = game_scene:GetSceneObjList() 
	for i, client_obj in pairs(client_obj_lst) do 
		if nx_is_valid(client_obj) then 
			local name = nil 
			local config_id = '' 
			if nx_number(client_obj:QueryProp('Type')) == nx_number(4) then 
				config_id = client_obj:QueryProp('ConfigID')
				name = gui.TextManager:GetText(config_id) 
			elseif nx_number(client_obj:QueryProp('Type')) == nx_number(2) then 
				name = client_obj:QueryProp('Name') 
			end 
			if name == utf8ToWstr(npcName) or nx_string(npcName) == nx_string(config_id) then 
				if nx_is_valid(client_obj) then
					local x, y, z = 9999, 9999, 9999 
					while nx_is_valid(client_obj) and not isInTargetRadius(client_obj.DestX, client_obj.DestY, client_obj.DestZ, 2) do 
						if x ~= client_obj.DestX or y ~= client_obj.DestY or z ~= client_obj.DestZ then 
							x, y, z = client_obj.DestX, client_obj.DestY, client_obj.DestZ 
							moveTo(x, y, z)
							nx_pause(0.2) 
						else 
							nx_pause(0.2) 
						end 
					end
					while nx_is_valid(client_obj) and getDistance(client_obj) > r
					do
						nx_pause(0.5) 
					end
					if nx_is_valid(client_obj) then
						return client_obj
					end
					return 
				end
			end
		end
	end
	return 
end
-- function get_data_skill_id(skill_id) 
  -- local skill_query = nx_value('SkillQuery')
  -- if not nx_is_valid(skill_query) then
    -- return false
  -- end
  -- local fight = nx_value('fight')
  -- local gui = nx_value('gui')
  -- local data_query = nx_value('data_query_manager')
  -- if not nx_is_valid(data_query) then return nil end
  -- if nx_is_valid(fight) then
    -- local skill = fight:FindSkill(skill_id)
    -- if nx_is_valid(skill) then
		-- local name = gui.TextManager:GetText(skill_id)
		-- local level = skill:QueryProp('Level')
		-- local static_data = skill:QueryProp('StaticData')
		-- local skill_type = data_query:Query(0, nx_int(static_data), 'SkillType')-- 3 gia
		-- local is_dame = data_query:Query(0, nx_int(static_data), 'IsDamage') -- 0 gia
		-- local effect_type = data_query:Query(0, nx_int(static_data), 'EffectType')
		-- local taolu = data_query:Query(0, nx_int(static_data), 'TaoLu')	
		-- local cooltype = data_query:Query(0, nx_int(static_data), 'CoolDownCategory')
		-- local coolteam = data_query:Query(0, nx_int(static_data), 'CoolDownTeam')
		-- local target_type = data_query:Query(0, nx_int(static_data), 'TargetType')
		-- local needSP = nx_number(skill:QueryProp('AConsumeSP'))
		-- local uselimit = nx_number(skill:QueryProp('UseLimit'))
		-- local weapontype = skill_query:GetSkillWeaponType(uselimit)
		-- return name,skill,level, skill_type, effect_type, is_dame, taolu, cooltype,coolteam,target_type,needSP,weapontype
    -- end
  -- end
-- end
function get_data_skill_id(skill_item) 
  local skill_query = nx_value('SkillQuery')
  if not nx_is_valid(skill_query) then
    return false
  end
  local fight = nx_value('fight')
  if nx_is_valid(fight) then
    local skill = fight:FindSkill(skill_item)
    if nx_is_valid(skill) then
      local static_data = nx_number(skill:QueryProp('StaticData'))
      local skilltype = skill_static_query(static_data, 'EffectType')
      local cool_type = skill_static_query_by_id(skill_item, 'CoolDownCategory')
      local cool_team = skill_static_query_by_id(skill_item, 'CoolDownTeam')
      local target_type = skill_static_query_by_id(skill_item, 'TargetType')
      local needSP = nx_number(skill:QueryProp('AConsumeSP'))
      local uselimit = nx_number(skill:QueryProp('UseLimit'))
      local weapontype = skill_query:GetSkillWeaponType(uselimit)
      return cool_type, cool_team, target_type, skilltype, needSP, weapontype
    end
  end
end
function useSkillDef(skill_data, select_target)
	local cool_type, cool_team, target_type, skilltype, needSP, weapontype = get_data_skill_id(skill_data)	
	if nx_int(target_type) == nx_int(1) then
		local game_visual = nx_value('game_visual')
		if not nx_is_valid(game_visual) or not nx_is_valid(select_target) then return end
		if nx_int(target_type) == nx_int(1) then
			local visual_target = game_visual:GetSceneObj(select_target.Ident)
			if nx_is_valid(visual_target) then
				local x, y, z = visual_target.PositionX, visual_target.PositionY, visual_target.PositionZ
				nx_value('gui').GameHand:SetHand('groundpick', 'Default', 'map\\tex\\Target_area_G.dds', '' .. 4, 'xxx', nx_string(10))
				nx_execute('game_effect', 'hide_ground_pick_decal')
				nx_execute('game_effect', 'locate_ground_pick_decal', x, y, z, 30)
			end
		end
	end	
	nx_value('fight'):TraceUseSkill(skill_data, false, false)
end
function useSkill(skill_id, select_target,is_range,hide_skill)
	if not skill_id or skill_id == '' then return end
	local cool_type, cool_team, target_type, skilltype, needSP, weapontype = get_data_skill_id(skill_id)
	if nx_int(target_type) == nx_int(1) or nx_int(target_type) == nx_int(3) then
		local game_visual = nx_value('game_visual')
		if not nx_is_valid(game_visual) or not nx_is_valid(select_target) then return end		
		local visual_target = game_visual:GetSceneObj(select_target.Ident)
		if nx_is_valid(visual_target) then
			local x, y, z = visual_target.PositionX, visual_target.PositionY, visual_target.PositionZ
			if nx_int(target_type) == nx_int(3) then 
				nx_value('gui').GameHand:SetHand('groundpick', 'Default', 'map\\tex\\target_area_jysgy.dds', '' .. 4, 'xxx', nx_string(10))
			else	
				nx_value('gui').GameHand:SetHand('groundpick', 'Default', 'map\\tex\\Target_area_G.dds', '' .. 4, 'xxx', nx_string(10))
			end			
			nx_execute('game_effect', 'hide_ground_pick_decal')
			nx_execute('game_effect', 'locate_ground_pick_decal', x, y, z, 30)
		end		
	end	
	if nx_int(hide_skill) == nx_int(1) then
		nx_value('fight'):TraceUseSkill(skill_id..'_hide', (not is_range), false)
		return
	elseif nx_int(hide_skill) == nx_int(2) then
		nx_value('fight'):TraceUseSkill(skill_id..'_sky', (not is_range), false)
		return
	else
		nx_value('fight'):TraceUseSkill(skill_id, (not is_range), false)
		return
	end		
end
auto_skill_buff_other_skill = function(cur_sp,cur_mp)
	nx_pause(0.1)	
	local fight = nx_value('fight')
	-- if not auto_skill_buf_list then return end
	local auto_buff_skill = auto_skill_buf_list_change_weapon(cur_sp, cur_mp, auto_skill_buf_list)
	if auto_buff_skill and nx_string(get_cur_scene_id()) ~= nx_string('fight08') then		
		if not check_skill_weapon_enable(auto_buff_skill.weapontype) then
			local uid = check_skill_weapon(auto_buff_skill.weapontype)
			local weapon = get_weapon_use_by_uid(uid)
			if weapon == nil then					
				swap_weapon_autoskill(uid)	
				nx_pause(0.5)	
			end			
		end		
		fight:TraceUseSkill(auto_buff_skill.id, false, false)	
	end					
	local overlay_buf_skill_id =  auto_skill_overlay_buf_list_need_execute(cur_sp, cur_mp)
	if overlay_buf_skill_id and not is_skill_on_cooling(overlay_buf_skill_id) then
		fight:TraceUseSkill(overlay_buf_skill_id, false, false)			
	end	
end
auto_bag_right_click = function(click_index)
	local form = util_get_form('form_stage_main\\form_bag')
	if not nx_is_valid(form) then
		return
	end
	nx_execute('form_stage_main\\form_bag_func', 'on_bag_right_click', form.imagegrid_equip, nx_number(click_index) - 1)
end
function getBattlefieldWeapon()
  local game_client = nx_value('game_client')
  local ini = get_ini_safe('share\\ModifyPack\\SkillPack.ini')
  if nx_is_valid(game_client) then
    local view_table = game_client:GetViewList()
    local skillDamage = 0
    local CPDamage = 0
    local STDamage = 0
    local binhthuName = ''
    for i = 1, table.getn(view_table) do
      local view = view_table[i]
      if view.Ident == nx_string('1') then
        local view_obj_table = view:GetViewObjList()
        for k = 1, table.getn(view_obj_table) do
          local view_obj = view_obj_table[k]
          if string.find(nx_string(view_obj:QueryProp('ConfigID')), 'battlefield') and view_obj:QueryProp('EquipType') == 'Weapon' then
            return true
          end
        end
      end
    end
  end
  return false
end
function section_count_target(inifile)
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
	if ini:LoadFromFile() then
		local count = ini:GetSectionCount()		
		nx_destroy(ini)
		return count
	else
		nx_destroy(ini)
		return 0
	end
end
auto_swap_weapon_skill = function()
	if not auto_skill_weapon_uid then		
		local inifile = add_file_user('auto_skill')
		local skilltaolu = wstrToUtf8(readIni(inifile,'SettingSkill','Active',''))
		if skilltaolu ~= '' then
			local weaponuid = nx_string(readIni(inifile,skilltaolu,'item_uid',''))
			auto_skill_weapon_uid = weaponuid
		end
	end
	if not check_skill_weapon_enable(auto_skill_weapon_uid) then
		local weapon = get_weapon_use_by_uid(auto_skill_weapon_uid)
		if weapon == nil then
			nx_pause(0.5)
			swap_weapon_autoskill(auto_skill_weapon_uid)
		end
	end
end
auto_buff_skill_on_taolu = function(cur_sp, cur_mp)
	-- if not auto_skill_combat_buf_list then return end
	local fight = nx_value('fight')
	local buf_skill_id = auto_skill_buf_list_need_execute(cur_sp, cur_mp, auto_skill_combat_buf_list)
	if buf_skill_id and not is_skill_on_cooling(buf_skill_id) then
		fight:TraceUseSkill(buf_skill_id, false, false)		
	end
end
auto_parry = function()	
	nx_execute('custom_sender', 'custom_active_parry', nx_int(1), nx_int(2))
	nx_pause(0.1)
end
function is_jump_state()
	local target_role = nx_value("role")
	local link_role = target_role:GetLinkObject("actor_role")
	if nx_is_valid(link_role) then
		target_role = link_role
	end
	local action_list = target_role:GetActionBlendList()
	for i,action in pairs(action_list) do
		if string.find(action,"jump") ~= nil then return true end
	end
	return false
end

auto_use_skill_out = function(skill_id,target,range,type_sky)
	nx_pause(0.1)
	if not skill_id then return end
	if is_skill_on_cooling(skill_id) then return end
	if not target then target = nx_value('game_select_obj') end
	if range == nil then range = false end
	if not type_sky then type_sky = '' end
	local game_client = nx_value('game_client')
	local client_player = game_client:GetPlayer()
	local cur_sp = client_player:QueryProp('SP') 
	local cur_mp = client_player:QueryProp('MP') 
	local taolu_skill_hide = get_buff_time('buf_hideweapon')	
	if is_dead_auto() then return end
	if taolu_skill_hide ~= -1 then
		useSkill(skill_id, target,range ,1)		
		return
	end		
	if taolu_skill_hide == -1 then 
		if string.find(nx_string(type_sky) ,'sky',1,true) then
			nx_pause(0.1)
			if not is_jump() and get_buff_info('buf_match_wudi') == nil then
				jump_skill()
				nx_pause(0.1)	
			end				
			useSkill(skill_id, target,range ,2)				
		end	
		if auto_skill_spec_play_list then
			local jump_skill_id,list_spec =  auto_skill_spec_list_need_execute(cur_sp, cur_mp)
			if jump_skill_id then				
				useSkill(skill_id, target,range ,1)
				useSkill(skill_id, target, range,0)
				return
			end									
		end
		useSkill(skill_id, target, range,0)			
	end		
end
auto_execute = function(funcName, ...)
	if not funcName then return end	
	if nx_string(funcName) == 'auto_skill' then
		set_skill_start_stop(true)
	end
	if not nx_running(nx_current(), funcName) then
		return nx_execute(nx_current(), funcName, unpack(arg))
	end
end
auto_running = function(funcName)
	if not funcName then return end
	return nx_running(nx_current(), funcName)
end
auto_kill = function(funcName)
	if not funcName then return end
	if nx_string(funcName) == 'auto_skill' then
		set_skill_start_stop(false)
	end
	if nx_running(nx_current(), funcName) then
		nx_kill(nx_current(), funcName)
	end
end
auto_running_full = function(fileName,funcName)
	if not funcName then return end
	if not fileName then return end	
	return nx_running(fileName, funcName)
end
auto_execute_full = function(fileName,funcName, ...)
	if not funcName then return end	
	if not fileName then return end	
	if nx_string(funcName) == 'auto_skill' then
		set_skill_start_stop(true)
	end
	if not nx_running(fileName, funcName) then
		return nx_execute(fileName, funcName, unpack(arg))
	end
end
auto_kill_full = function(fileName,funcName)
	if not funcName then return end
	if not fileName then return end	
	if nx_string(funcName) == 'auto_skill' then
		set_skill_start_stop(false)
	end
	if nx_running(fileName, funcName) then
		nx_kill(fileName, funcName)
	end
end
check_auto_special_running = function()
	if auto_running_full('auto_new\\auto_script','auto_start_undef') then
		showUtf8Text('Auto Nhả Def '..auto_running_please_stop)
		return false
	end
	if auto_running_full('auto_new\\auto_script','auto_start_stop_quat') then
		showUtf8Text('Auto Bug Quạt '..auto_running_please_stop)
		return false
	end
	if auto_running_full('auto_new\\auto_script','autoSpeed') then
		showUtf8Text('Auto Speed '..auto_running_please_stop)
		return false
	end
	if auto_running_full('auto_new\\auto_script','crash_skill_test') then
		showUtf8Text('Auto Ping Pro '..auto_running_please_stop)
		return false
	end
	if auto_running_full('auto_new\\auto_script','crash_skill_test1') then
		showUtf8Text('Auto Ping Classic '..auto_running_please_stop)
		return false
	end
	if auto_running_full('auto_new\\auto_script','autoDefSkillCustom') then
		showUtf8Text('Auto Nhả Def Pro '..auto_running_please_stop)
		return false
	end
	if auto_running_full('auto_new\\auto_script','auto_start_def') then
		showUtf8Text('Auto Target '..auto_running_please_stop)
		return false
	end
	if auto_running_full('auto_new\\auto_script','autoTHBB') then
		showUtf8Text('Auto Thần Hành '..auto_running_please_stop)
		return false
	end
	return true
end
function setTargetCompetitor(obj)
    local game_client = nx_value('game_client')
    if not nx_is_valid(game_client) then
        return false
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return false
    end
    if not nx_is_valid(obj) then
        return false
    end
    local selObjID = player_client:QueryProp('LastObject')
    local selObj = game_client:GetSceneObj(nx_string(selObjID))
    if nx_is_valid(selObj) and selObj.Ident == obj.Ident then
        return true
    else
        nx_execute('custom_sender', 'custom_select', obj.Ident)
    end
    return false
end
function get_current_player_pos()
    local game_visual = nx_value('game_visual')
    if not nx_is_valid(game_visual) then
        return nil
    end
    local game_player = game_visual:GetPlayer()
    if not nx_is_valid(game_player) then
        return nil
    end
    return {game_player.PositionX, game_player.PositionY, game_player.PositionZ}
end
function rollPickItem()
    local has_item = false
    for i = 0, 2 do
        local FORM_DICE = 'form_stage_main\\form_dice'
        local form = nx_value(FORM_DICE .. nx_string(i))
        if nx_is_valid(form) then
            has_item = true
            if form.item then
                nx_execute('form_stage_main\\form_dice', 'return_choice', form, 2) 
            end
        end
    end
    return has_item
end
function getDistancePlayerToObj(obj)
	local vObj = getVisualObj(obj)
	if not nx_is_valid(vObj) then return 9999999999 end
	return getDistanceFromPos(vObj.PositionX, vObj.PositionY, vObj.PositionZ)
end

function is_skill_cooling(cooltype, coolteam)
	if not cooltype or not coolteam then return end	
	if nx_value('gui').CoolManager:IsCooling(cooltype, coolteam) then return true end
	return false
end
function use_skill_id_auto_default(player,stype,skill_list)
	if stype == 'no' and nx_number(player:QueryProp('SP')) >= nx_number(skill_list['sp'])  then
		nx_value('fight'):TraceUseSkill(skill_list['name'], false, false)
	elseif stype == 'sky' then
		use_skill_sky(skill_list['name'])
	end
	if stype ~= 'no' and stype ~= 'sky' then
		nx_value('fight'):TraceUseSkill(skill_list['name'], false, false)	
	end
end
get_version_auto = function()
	return AUTO_VERSION
end
local old_page_free = nil
local auto_skill_list_free = nil
local skill_2m_config_id_free = nil
local skill_normal_id_free = nil
local min_skill_request_mp_free = 1000
function Auto_Skill(page)
	if nx_running("auto_new\\autocack", 'autoSkill_free') then
		showUtf8Text('Ngừng auto skill', 3)
		nx_kill("auto_new\\autocack", 'autoSkill_free') 
		change_form_main_shortcut_cur_page_free(old_page_free) 
	else 
		nx_execute("auto_new\\autocack", 'autoSkill_free', page)
	end
end
FORM_MAIN_SHORTCUT = 'form_stage_main\\form_main\\form_main_shortcut'
FORM_MAIN_SHORTCUT_RIDE = 'form_stage_main\\form_main\\form_main_shortcut_ride'
function autoSkill_free(page)
	local form_shortcut = nx_value(FORM_MAIN_SHORTCUT)
	local grid = form_shortcut.grid_shortcut_main
	initAutoSkill_free(grid, page)
	if not auto_skill_list_free or #auto_skill_list_free == 0 then 
		 change_form_main_shortcut_cur_page_free(old_page_free) 
		showUtf8Text(' Vui lòng thêm skill vào', 3)
	return 
	end
	local t_page = page
	if not t_page then t_page = grid.page + 1 end
	showUtf8Text('Bắt đầu auto skill ở tab số ' .. nx_string(t_page), 3)
	local game_client = nx_value('game_client')
	local game_visual = nx_value('game_visual')
	if not nx_is_valid(game_client) or not nx_is_valid(game_visual) then
		return 
	end
	local client_player = game_client:GetPlayer()
	local visual_player = game_visual:GetPlayer()
	while nx_is_valid(game_client) and nx_is_valid(game_visual) and nx_is_valid(client_player) do 
		while nx_is_valid(client_player) and nx_is_valid(visual_player)  and client_player:FindProp('HP') and client_player:QueryProp('HP') > 0 do 
			local select_target_ident = client_player:QueryProp('LastObject') 
			local select_target = game_client:GetSceneObj(nx_string(select_target_ident)) 
			local range = getDistance(select_target) 
			if nx_is_valid(select_target) and not select_target:FindProp('Dead') then 
				local can_attack = nil 
				local obj_type = nx_number(select_target:QueryProp('Type')) 
				if obj_type == 4 then 
					can_attack = nx_value('fight'):CanAttackNpc(client_player, select_target)
					nx_pause(0.1)
				elseif obj_type == 2 then 
					can_attack = nx_value('fight'):CanAttackPlayer(client_player, select_target)
					nx_pause(0.1)
					end
				if can_attack then 
					local is_used_skill = false
					for i = 1, #auto_skill_list_free do
						if autoUseSkillByIndex_free(client_player, grid, i, range, select_target) then 
						nx_pause(0.2)
							is_used_skill = true
							nx_pause(0.1)
							break 
						end
					end
					if is_used_skill == false then
						--if nx_int(client_player:QueryProp('MP')) < nx_int(min_skill_request_mp_free) then -- out of mana
							--autoUseSkillByIndex_free(client_player, grid, #auto_skill_list_free, range, select_target)
							--nx_pause(2)
						--else
							nx_pause(0.1)
						--end
					else 
						nx_pause(0.1)
					end
				end
			else
				nx_pause(0.1) 
			end
		end
		nx_pause(0.1) 
	end
end
function auto_skill_grid_free(grid,page)
	if not auto_skill_list_free or #auto_skill_list_free == 0 then 
		change_form_main_shortcut_cur_page_free(old_page_free) 
		showUtf8Text(' Vui lòng thêm skill vào', 3)
		return 
	end
	local t_page = page
	if not t_page then t_page = grid.page + 1 end
	showUtf8Text('Bắt đầu auto skill ở tab số ' .. nx_string(t_page), 3)
	while 1 do 
		local game_client = nx_value('game_client')
		local game_visual = nx_value('game_visual')
		if  nx_is_valid(game_client) and  nx_is_valid(game_visual) then
			local client_player = game_client:GetPlayer()
			local visual_player = game_visual:GetPlayer()
			while not nx_is_valid(nx_value('form_loading')) and nx_string(nx_value('stage_main')) == nx_string('success') and not nx_is_valid(nx_value(FORM_GOTO_COVER)) and nx_is_valid(client_player) and nx_is_valid(visual_player) do 
				if auto_skill_status and nx_find_custom(visual_player, 'state') and visual_player.state ~= 'locked' and visual_player.state ~= 'sitcross' and not string.find(visual_player.state, 'injur') and not string.find(visual_player.state, 'hit') and visual_player.state ~= 'dead'  then
					local select_target_ident = client_player:QueryProp('LastObject') 
					local select_target = game_client:GetSceneObj(nx_string(select_target_ident)) 
					local range = getDistance(select_target) 
					if nx_is_valid(select_target) and not select_target:FindProp('Dead') then 
						local can_attack = nil 
						local obj_type = nx_number(select_target:QueryProp('Type')) 
						if obj_type == 4 then 
							can_attack = nx_value('fight'):CanAttackNpc(client_player, select_target)
						elseif obj_type == 2 then 
							can_attack = nx_value('fight'):CanAttackPlayer(client_player, select_target)							
						end
						if can_attack then 
							local is_used_skill = false
							for i = 1, #auto_skill_list_free do
								if autoUseSkillByIndex_free(client_player, grid, i, range, select_target) then 							
									is_used_skill = true
									nx_pause(0.1)
									break 
								end
							end
							if is_used_skill == false then						
								nx_pause(0.1)						
							else 
								nx_pause(0.1)
							end
							nx_pause(0.1) 
						end
						nx_pause(0.1) 
					else
						nx_pause(0.1) 
					end
					nx_pause(0.1) 
				end	
				nx_pause(0.1)	
			end			
		end		
		nx_pause(0.1) 
	end
end

function compareSP_free(a, b)
	return (nx_int(a.needSP) > nx_int(b.needSP)) or (a.needSP == b.needSP and (nx_int(a.cd) > nx_int(b.cd)))
end
function initAutoSkill_free(grid, page)
	auto_skill_status = false
	if auto_skill_list_free ~= nil then 
		for i = 1, #auto_skill_list_free do 
			auto_skill_list_free[i] = nil 
		end 
		auto_skill_list_free = nil 
	end 
	local fight = nx_value('fight')
	if auto_skill_list_free == nil then auto_skill_list_free = {} end 
	skill_2m_config_id_free = 'zs_normal_00'
	--skill_normal_id_free = fight:GetNormalAttackSkillID()
	old_page_free = nil 
	if page == nil then 
		page = grid.page
	else
		old_page_free = grid.page
		change_form_main_shortcut_cur_page_free(nx_string(nx_number(page) - nx_number(1)))
		nx_pause(1)
	end
	local beginindex = grid.beginindex + grid.page * (grid.RowNum * grid.ClomnNum)
	for index = 0, 9 do
		local row = nx_execute('shortcut_game', 'get_shortcut_row_by_index', beginindex + index)
		local i, itemType, skill_id = nx_execute('shortcut_game', 'get_shortcut_info_by_row', row)		
		if itemType == 'skill' or (itemType == 'func' and skill_id == 'normal_anqi_attack') then 			
			if nx_is_valid(fight:FindSkill(skill_id)) then
				add_skill_id_to_list_free(skill_id)
			end
		end
	end
	if #auto_skill_list_free == 0 then return end 
	table.sort(auto_skill_list_free, compareSP_free)
	auto_skill_status = true
	return true
end
function add_skill_id_to_list_free(skill_id)
	local isExsitSkillInList = false
	for _, v in pairs(auto_skill_list_free) do
		if nx_string(v.id) == nx_string(skill_id) then
			isExsitSkillInList = true
			break
		end
	end
	if not isExsitSkillInList then 
		local gui = nx_value('gui')
		local skill_query = nx_value('SkillQuery')
		local skill = nx_value('fight'):FindSkill(skill_id)
		local name = gui.TextManager:GetText(skill_id)
		local skill_type = skill_query:GetSkillType(skill_id)
		local static_data = skill:QueryProp('StaticData')
		local target_type = nx_execute('util_static_data', 'skill_static_query', static_data, 'TargetType')
		local cooltype = nx_execute(FORM_MAIN_SHORTCUT_RIDE, 'get_skill_info', skill_id, 'CoolDownCategory')
		local coolteam = nx_execute(FORM_MAIN_SHORTCUT_RIDE, 'get_skill_info', skill_id, 'CoolDownTeam')
		local t1, t2, h1, h2 = nil, nil, nil, nil
		if skill:FindProp('TargetShapePara1') then t1 = skill:QueryProp('TargetShapePara1') end
		if skill:FindProp('TargetShapePara2') then t2 = skill:QueryProp('TargetShapePara2') end
		if skill:FindProp('HitShapePara1') then h1 = skill:QueryProp('HitShapePara1') end
		if skill:FindProp('HitShapePara2') then h2 = skill:QueryProp('HitShapePara2') end
		if nx_int(target_type) ~= nx_int(2) then	--	tránh skill buff
			local needSP = 0
			local needMP = 0
			if skill:FindProp('AConsumeSP') then 
				needSP = nx_number(skill:QueryProp('AConsumeSP')) 
			end
			if skill:FindProp('AConsumeMP') then 
				needMP = nx_number(skill:QueryProp('AConsumeMP'))
				if nx_int(needMP) > nx_int(min_skill_request_mp_free) then
					min_skill_request_mp_free = needMP
				end
			end
			if nx_int(target_type) == nx_int(4) and not skill:FindProp('AConsumeSP') and nx_int(TargetShapePara2) ~= nx_int(2) then 
				skill_2m_config_id_free = nx_string(skill_id) 
			end 
			local cd = skill:QueryProp('CoolDownTime')
			local temp = {name = name, skill = skill, id = skill_id, grid_index = index, cd = cd, cooltype = cooltype, coolteam = coolteam, target_type = target_type, target1 = t1, target2 = t2, hit1 = h1, hit2 = h2, needSP = needSP, needMP = needMP}
			table.insert(auto_skill_list_free, temp)
		end
	end
end
function autoUseSkillByIndex_free(client_player, grid, auto_skill_list_index, range, select_target)
	skill_data = auto_skill_list_free[auto_skill_list_index]
	if isSkillCooling_free(skill_data) then
		return false
	end
	if not nx_is_valid(client_player) then return false end 
	if skill_data.needSP > 0 and client_player:QueryProp('SP') < skill_data.needSP then
		return false
	end
	if skill_data.needMP > 0 and client_player:QueryProp('MP') < skill_data.needMP then
		return false
	end
	--	in case close to skill 
	if skill_data.target1 and nx_int(skill_data.target2) > nx_int(skill_data.target1) and nx_int(range) < nx_int(skill_data.target1) then
		return false
	end
	local fight = nx_value('fight') 
	local game_visual = nx_value('game_visual') 
	local r = nx_number(range) 
	if nx_int(skill_data.target_type) == nx_int(4) then  
		useSkilll_free(skill_data, select_target) 
		while nx_is_valid(select_target) and is_path_finding() do 
			nx_pause(0.1) 
		end 
		nx_pause(0.1)
		if isSkillCooling_free(skill_data) then 
			nx_pause(0.9) 
			return true 
		end 
		return false 
	end
	if r > 2 then 
		local skill_range = nx_number(skill_data.hit2) 
		if skill_data.target2 then skill_range = nx_number(skill_data.target2) end 
		if r + 0.5  > skill_range then 
			fight:TraceUseSkill(skill_2m_config_id_free, true, false) 
			while nx_is_valid(select_target) and is_path_finding() and nx_number(getDistance(select_target)) + 0.5 > skill_range do 
				nx_pause(0.1) 
			end 
		end 
	end 
	useSkilll_free(skill_data, select_target) 
	nx_pause(0.1)
	if isSkillCooling_free(skill_data) then 
		nx_pause(0.9) 
		return true 
	end
	return false
end
function isSkillCooling_free(skill_data)
	local cooltype, coolteam = skill_data.cooltype, skill_data.coolteam
	if nx_value('gui').CoolManager:IsCooling(cooltype, coolteam) then
		return true
	end
	return false
end
auto_encrypt_pass_convert = function( chars, dist, inv )
	return string.char( ( string.byte( chars ) - 32 + ( inv and -dist or dist ) ) % 95 + 32 )
end
encrypt_auto = {78 ,32 ,48 ,32 ,67, 32, 75}
function auto_encrypt_pass(str, inv)
	local enc = ''
	if not inv then		
		str = nx_function('ext_encrypt_string', str)
	end
	for i = 1, #str do
		local inc = i % 4
		enc = enc .. auto_encrypt_pass_convert(string.sub(str, i, i), encrypt_auto[inc + 1], inv)
	end
	if inv then 		
		local subpass = string.gsub(str,'keystringcheck','')		
		enc = nx_function('ext_dencrypt_string', subpass)
	end
	return enc
end
get_pass_auto_encrypt = function(str)
	return auto_encrypt_pass(str)
end
save_record_pass_2 = function(str_encrypt_pass)
	local form = nx_value('auto_new\\form_auto_encrypt')
	if nx_is_valid(form) then
		local check_pass = form.edt_password_encrypt.Text
		write_auto_record('password_2_autocack', 'auto_pass_save_2', nx_string(check_pass))
		showUtf8Text(SAVE_PASS_SUCCESS, 3)
	end	
end
get_record_pass_2 = function()
	local xml_doc = create_auto_record_doc()
	local record = get_auto_record(xml_doc, 'password_2_autocack')
	if record == nil or table.getn(record) == 0 then return end
	if record[#record].content then
		return wstrToUtf8(record[#record].content)
	end
end
unlock_pass_auto_2 = function(str_pass)
	local game_visual = nx_value('game_visual')
	if not nx_is_valid(game_visual) then
		return
	end
	if str_pass == nil or str_pass == '' then
		str_pass = get_record_pass_2()
		if str_pass == nil or str_pass == '' then 
			showUtf8Text('not pass', 3)
			return 
		end
	end	
	local decrypt_pass_2 = auto_encrypt_pass(str_pass, true)
	local subpass = string.gsub(decrypt_pass_2,'keystringcheck','')	
	nx_value('game_visual'):CustomSend(nx_int(760), nx_int(1), nx_widestr(subpass))
end
save_record_pass_1 = function(str_encrypt_pass)
	local form = nx_value('auto_new\\form_auto_encrypt')
	if nx_is_valid(form) then
	local game_config = nx_value('game_config')
	local account = game_config.login_account 
	write_auto_record('password_1_autocack', 'auto_pass_save_1', str_encrypt_pass, nx_string(account))
	showUtf8Text('Save Pass Success', 3)
	end
end
get_record_pass_1 = function(account_name)
	local xml_doc = create_auto_record_doc(account_name)
	local record = get_auto_record(xml_doc, 'password_1_autocack', account_name)
	if record == nil or table.getn(record) == 0 then return end
	if record[#record].content then
		return wstrToUtf8(record[#record].content)
	end
end
get_unlock_pass_1 = function(account_name)
	local str_pass = get_record_pass_1(account_name)
	if str_pass == nil or str_pass == '' then return end
	local decrypt_pass_1 = auto_encrypt_pass(str_pass, true)
	local subpass = string.gsub(decrypt_pass_1,'keystringcheck','')	
	return subpass
end

function get_enc_pass(str)
 if str == nil or string.len(nx_string(str)) == 0 then
    return ''
  end
  str = str .. 'keystringcheck'
  return nx_function('ext_encrypt_string', str)
end
function get_pass(str)
 if str == nil or string.len(nx_string(str)) == 0 then
    return ''
  end
  local content = str
  local decpass = nx_function('ext_dencrypt_string', content)
  local subpass = string.gsub(decpass,'keystringcheck','') 
  return subpass
end
function save_password_enc()
	local form = nx_value('auto_new\\form_auto_encrypt')
	local game_config = nx_value('game_config')
	local account = game_config.login_account
	local server_ID = game_config.server_id
	local dir = nx_function('ext_get_current_exe_path') .. account 
	if nx_is_valid(form) then
		local check_pass = form.edt_password_encrypt.Text
		local file1 = io.open(dir .. '\\e_p.dat','w+')
		file1:write(nx_string(check_pass))
		file1:close()
		showUtf8Text(SAVE_PASS_SUCCESS, 3)
	end	
end
function set_pass_login(id)
	local dir = nx_function('ext_get_current_exe_path') .. id
	local file1 = dir .. nx_string('\\e_p.dat')	
	if nx_function('ext_is_file_exist', file1) then
		local file2 = io.open(dir .. '\\e_p.dat','r')	
		local data = file2:read('*a')
		local getpass = get_pass(data)
		return getpass
	end
end
function MoveToXYZ(x,y,z)	
	old_x, old_y, old_z = x, y, z	
	if find_pos_set(x,y,z) then return end	
	_curPos = nil
	move_to_pos_check(x,y,z)
end
CurMap = ''
function isExisPath(src_point, dest_point)
	if ClassPoint == nil or CurMap ~= get_cur_scene_id() then 
		ClassPoint = {}
		CurMap = ''
	end
	if not isClassPointHasPoint(src_point) then
		insert_class_point(src_point)
	end
	if not isClassPointHasPoint(dest_point) then
		insert_class_point(dest_point)
	end
	local src_class = getClassIndex(src_point)
	local dest_class = getClassIndex(dest_point)
	if src_class == 0 or dest_class == 0 then return false end
	if src_class == dest_class then
		return true
	end
	return false
end
function insert_class_point( point )
	temp_class = {}
	temp_class.LinkClass = {}
	temp_class.NotLinkClass = {}
	temp_class.ListPoint = {}
	GroupPoint = {}
	CurMap = get_cur_scene_id()
	PathFindObj = nx_value('path_finding')
	if not nx_is_valid(PathFindObj) then return false end
	local list = get_point_list( point )
	if list ~= nil then 
		temp_class.ListPoint = list
		table.insert(ClassPoint, temp_class)
	end
end
function find_pos_set( x,y,z )
	if not isPathFinding() then return false end
	local role = nx_value('role')
	if not nx_is_valid(role) then return false end
	if not nx_find_custom(role, 'FindPathX') or not nx_find_custom(role, 'FindPathY') or not nx_find_custom(role, 'FindPathZ') or not nx_find_custom(role, 'FindPathMap') or role.FindPathMap ~= get_cur_scene_id() then
		return false
	end
	return distance3d(x,y,z,role.FindPathX,role.FindPathY,role.FindPathZ) < 6
end

function move_to_pos_check( x,y,z )
	local path_finding = nx_value('path_finding')
    local role = nx_value('role')
    if not nx_is_valid(path_finding) or not nx_is_valid(role) then return false end
    if role.state == 'sitcross' then
    	stop_sitcross()
    	return 
    elseif not isStaticState() then
    	return
 	end
	if get_logicstate() == 102 then
    	stop_sitcross()
    	return false
    end  
    local map = get_cur_scene_id()		
    auto_move_find(x,y,z)
    if not isPathFinding() then 		
    	auto_find_path(x,y,z)
    end
    local role = nx_value('role')
    if not nx_is_valid(role) then return end
    role.FindPathX = x
    role.FindPathY = y
    role.FindPathZ = z
    role.FindPathMap = map
end


function isStaticState()
	local role = nx_value('role')
	if not nx_is_valid(role) then return false end
	if role.state ~= 'static' and  role.state ~= 'ride_stay' and role.state ~= 'swim_stop' and role.state ~= 'path_finding' and role.state ~= 'slide' then return false end
	local game_client = nx_value('game_client')
	local client_player = game_client:GetPlayer()
	local result = nx_string(client_player:QueryProp('State'))
	return result ~= 'hurt_stun_2'
end
function auto_find_path( x,y,z, err )
	local xo,yo,zo = getCurPos()
	local src_list = getNearPointList(xo,yo,zo,15)
	local dest_list = getNearPointList(x,y,z,15)
	local dest_point = 0
	local src_point = 0
	local dis = getDistanceFromPosXZ(x,y,z)
	if dis < 10 then
		return
	end
	if #src_list > 0 and dis > 15 then
		xo,yo,zo = getPosByPoint(dest_list[1])
		auto_move_find(xo,-10000,zo)
		if isPathFinding() then return end
	end
	
	for i=1,#src_list do
		for j=1,#dest_list do
			if try_line_to_point(src_list[i]) and isExisPath(src_list[i], dest_list[j])  then
				src_point = src_list[i]
				dest_point = dest_list[j]
				break
			end
		end
		if src_point ~= 0 then break end
	end
	if src_point == 0 then 
		for i=1,#src_list do
			for j=1,#dest_list do
				if isExisPath(src_list[i], dest_list[j]) then
					src_point = src_list[i]
					dest_point = dest_list[j]
					break
				end
			end
			if src_point ~= 0 then break end
		end
	end
	if src_point == 0 then 
		for i=1,#src_list do
			for j=1,#dest_list do
				if isCanLinkClass(getClassIndex(src_list[i]), getClassIndex(dest_list[j])) then
					src_point = src_list[i]
					dest_point = dest_list[j]
					break
				end
			end
			if src_point ~= 0 then break end
		end
	end
	if src_point == 0 then
		return
	end
	local src_class = getClassIndex(src_point)
	local dest_class = getClassIndex(dest_point)
	if src_class ~= dest_class then
		dest_point = getCanLinkPoint(src_class, dest_class)
	end	
	auto_move( x,y,z,src_point, dest_point)
end

function auto_move( x,y,z,src_point, dest_point)
	local src_x,src_y,src_z = getPosByPoint(src_point)
	local dest_x,dest_y,dest_z = getPosByPoint(dest_point)	
	if getDistanceFromPosXZ(dest_x, dest_y, dest_z) < 1 then
		return
	end
	auto_move_find(dest_x,dest_y,dest_z)
	if isPathFinding() then return end
	auto_move_find(dest_x,-10000,dest_z)
	if isPathFinding() then return end
	if getDistanceFromPosXZ(src_x, src_y, src_z) > 0.1 then
		auto_move_find(src_x,src_y,src_z)
		if isPathFinding() then return end
	end
end
function isPathFinding( ... )
	local role = nx_value("role")
  if not nx_is_valid(role) then return false end
  if not nx_find_custom(role, "state") then return false end
	local state = nx_string(role.state)
  return state == "path_finding" or state == "ride"
end

function auto_move_find( x,y,z )
	local path_finding = nx_value('path_finding')
	if not nx_is_valid(path_finding) then return end
	local map_scene = nx_value("form_stage_main\\form_map\\form_map_scene")	
	if getDistanceFromPosXZ(x,y,z) > 50 then		
		path_finding:FindPathScene(map_scene.current_map, nx_float(x), nx_float(y), nx_float(z), nx_float(0))
	else
		path_finding:FindPath(nx_float(x), nx_float(y), nx_float(z), nx_float(0))
	end
end

function try_line_to_point( point )
	local src_x,src_y,src_z = getPosByPoint(point)
	local x,y,z = getCurPos()
	local path_finding = nx_value('path_finding')
	if not nx_is_valid(path_finding) then return end
	return path_finding:TryLine(get_cur_scene_id(), x,y,z,src_x,src_y,src_z)
end

function getPosByPoint( point )
	local path_finding = nx_value('path_finding')
	local x,y,z  = path_finding:GetPathPointPos(get_cur_scene_id(), point)
	return x,y,z
end


function getNearPointList( x,y,z,dis )
	local list = {}
	local distance = {}
	local xo, yo, zo = 0,0,0
	local found = false
	local role = nx_value('role')
	local path_finding = nx_value('path_finding')
	if not nx_is_valid(path_finding) or not nx_is_valid(role) then return list end
	local map = get_cur_scene_id()
	local point_count = path_finding:GetPathPointCount(map)
	if point_count == 0 then return list end
	local d = 0
	local insert_index = 1
	for i=1,point_count do
		xo, yo, zo  = path_finding:GetPathPointPos(map, i)
		d = distance2d(x,z,xo,zo)
		if d < dis then
			distance[i] = d 
			insert_index = #list + 1
			for j=1,#list do
				if d < distance[list[j]] then
					insert_index = j 
					break
				end
			end
			table.insert(list,insert_index,i)
		end
	end
	return list
end

function getClassIndex( point )
	for i=1,#ClassPoint do
		if ClassPoint[i].ListPoint[point] == 1 then return i end
	end
	return 0
end

function getCanLinkPoint( src_class, dest_class )
	return ClassPoint[src_class].LinkClass[dest_class]
end

function isCanLinkClass( src_class, dest_class )
	local x0,y0,z0 = 0,0,0
	local x1,y1,z1 = 0,0,0
	local map = get_cur_scene_id()
	local path_finding = nx_value('path_finding')
	if not nx_is_valid(path_finding) then return false end
	for i,v1 in pairs(ClassPoint[src_class].NotLinkClass) do
		if i == dest_class then return false end
	end
	for i,v1 in pairs(ClassPoint[src_class].LinkClass) do
		if i == dest_class then return true end
	end
	local can_link = false
	for src_point,v1 in pairs(ClassPoint[src_class].ListPoint) do
		x0,y0,z0 = path_finding:GetPathPointPos(map,src_point)
		for dest_point,v2 in pairs(ClassPoint[dest_class].ListPoint) do
			x1,y1,z1 = path_finding:GetPathPointPos(map,dest_point)
			if distance3d(x0,y0,z0,x1,y1,z1) < 20 then
				ClassPoint[src_class].LinkClass[dest_class] = src_point
				ClassPoint[dest_class].LinkClass[src_class] = dest_point
				can_link = true
				break
			end
		end
		if can_link then break end
	end
	if can_link then return true end
	ClassPoint[src_class].NotLinkClass[dest_class] = 1
	ClassPoint[dest_class].NotLinkClass[src_class] = 1
	return false
end

function isClassPointHasPoint( point )
	for i=1,#ClassPoint do
		if ClassPoint[i].ListPoint[point] == 1 then return true end
	end
	return false
end


function get_point_list( point )
	local path_finding = nx_value('path_finding')
	if not nx_is_valid(path_finding) then return nil end
	local cur_map = get_cur_scene_id()
	local linked_list = {}
	local find_list = {}
	local search_list = {}
	table.insert(search_list, point)
	while #search_list > 0 do
		point = search_list[1]
		table.remove(search_list,1)
		linked_list[point] = 1
		local links = path_finding:GetLinkPoints(cur_map, point)
		for i=1,#links do
			if linked_list[links[i]] == nil and find_list[links[i]] == nil then
				find_list[links[i]] = 1
				table.insert(search_list,links[i])
			end
		end
	end
	return linked_list
end
function can_link_list_point( list1, list2 )
	local path_finding = nx_value('path_finding')
	if not nx_is_valid(path_finding) then return false end
	local x1,y1,z1 = 0,0,0
	local x2,y2,z2 = 0,0,0
	local map = get_cur_scene_id()
	for key1,value1 in pairs(list1) do
		
		for key2,value2 in pairs(list2) do
			if value1 == 1 and value2 == 1 then
				x1,y1,z1 = path_finding:GetPathPointPos(map, key1)
				x2,y2,z2 = path_finding:GetPathPointPos(map, key2)
				if path_finding:TryLine(map,x1,y1,z1,x2,y2,z2) then return true end
			end
		end
	end
	return false
end
moveTo = function(x, y, z, npc_id, scene_id)
	old_x, old_y, old_z = x, y, z
	local game_visual = nx_value("game_visual")
	local path_finding = nx_value("path_finding")
	local map_scene = nx_value("form_stage_main\\form_map\\form_map_scene")
	if nx_is_valid(game_visual) and  nx_is_valid(path_finding) and nx_is_valid(map_scene) then
		_curPos = nil
		if scene_id == nil and npc_id == nil then
			if getDistanceFromPosXZ(x,y,z) > 50 then		
				path_finding:FindPathScene(map_scene.current_map, nx_float(x), nx_float(y), nx_float(z), nx_float(0))
			else
				path_finding:FindPath(nx_float(x), nx_float(y), nx_float(z), nx_float(0))
			end
		elseif npc_id == nil then
			if getDistanceFromPosXZ(x,y,z) > 50 then		
				path_finding:FindPathScene(map_scene.current_map, nx_float(x), nx_float(y), nx_float(z), nx_float(0))
			else
				path_finding:FindPath(nx_float(x), nx_float(y), nx_float(z), nx_float(0))
			end
		elseif scene_id == nil then
			nx_value("path_finding"):TraceTargetByID(map_scene.current_map, nx_float(x), nx_float(y), nx_float(z), 1.8, npc_id)
		else 
			nx_value("path_finding"):TraceTargetByID(scene_id, nx_float(x), nx_float(y), nx_float(z), 1.8, npc_id)
		end
	else
		return
	end
end
moveToXZ = function(x, y, z, npc_id, scene_id)
	y = 0
	old_x, old_y, old_z = x, y, z
	local game_visual = nx_value("game_visual")
	local path_finding = nx_value("path_finding")
	local map_scene = nx_value("form_stage_main\\form_map\\form_map_scene")
	if nx_is_valid(game_visual) and  nx_is_valid(path_finding) and nx_is_valid(map_scene) then
		_curPos = nil
		if scene_id == nil and npc_id == nil then
			if getDistanceFromPosXZ(x,y,z) > 50 then		
				path_finding:FindPathScene(map_scene.current_map, nx_float(x), nx_float(y), nx_float(z), nx_float(0))
			else
				path_finding:FindPath(nx_float(x), nx_float(y), nx_float(z), nx_float(0))
			end
		elseif npc_id == nil then
			if getDistanceFromPosXZ(x,y,z) > 50 then		
				path_finding:FindPathScene(map_scene.current_map, nx_float(x), nx_float(y), nx_float(z), nx_float(0))
			else
				path_finding:FindPath(nx_float(x), nx_float(y), nx_float(z), nx_float(0))
			end
		elseif scene_id == nil then
			path_finding:TraceTargetByID(map_scene.current_map, nx_float(x), nx_float(y), nx_float(z), 1.8, npc_id)
		
		else 
			path_finding:TraceTargetByID(scene_id, nx_float(x), nx_float(y), nx_float(z), 1.8, npc_id)
		end
	else
		return
	end
end
function suicidePlayer(quick)
    local skill_id = 'CS_jh_tmjt06'
    if get_buff_info('buf_riding_01') ~= nil then
        nx_execute('custom_sender', 'custom_remove_buffer', 'buf_riding_01')
        nx_pause(0.2)
    end
    local fight = nx_value('fight')
    if not nx_is_valid(fight) then
        return false
    end
    local game_client = nx_value('game_client')
    if not nx_is_valid(game_client) then
        return false
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return false
    end
    local game_visual = nx_value('game_visual')
    if not nx_is_valid(game_visual) then
        return false
    end
    local game_player = game_visual:GetPlayer()
    if not nx_is_valid(game_player) then
        return false
    end
    local skill = fight:FindSkill(skill_id)   
    if nx_is_valid(skill) and nx_int(player_client:QueryProp('Dead')) == nx_int(0) and player_client:QueryProp('LogicState') ~= 121 then       
        if get_buff_info('buf_CS_jh_tmjt06') == nil then            
            fight:TraceUseSkill(skill_id, false, false)            
            local minNeigongID, maxNeigongID = getMinAndMaxNeigong()
            if minNeigongID == '' or maxNeigongID == '' then
                return false
            end            
            if player_client:QueryProp('CurNeiGong') ~= minNeigongID then
                nx_execute('custom_sender', 'custom_use_neigong', nx_string(minNeigongID))
                nx_pause(0.5)
            end           
            if not nx_is_valid(player_client) or not nx_is_valid(game_player) then
                return false
            end
			nx_pause(0.5)
            if player_client:QueryProp('CurNeiGong') ~= maxNeigongID then
                nx_execute('custom_sender', 'custom_use_neigong', nx_string(maxNeigongID))
            end
        end
        if get_buff_info('buf_CS_jh_tmjt06') ~= nil and quick ~= nil and not is_in_water(game_player) then
            local x = nx_float(game_player.PositionX)
            local y = nx_float(game_player.PositionY)
            local z = nx_float(game_player.PositionZ)
            local game_visual = nx_value('game_visual')
            local role = nx_value('role')
            local scene_obj = nx_value('scene_obj')
            scene_obj:SceneObjAdjustAngle(role, x, z)
            role.move_dest_orient = role.AngleY
            role.server_pos_can_accept = true
            game_visual:SwitchPlayerState(role, 1, 5)
            game_visual:SwitchPlayerState(role, 1, 6)
            game_visual:SwitchPlayerState(role, 1, 7)
            role:SetPosition(role.PositionX, y, role.PositionZ)
            game_visual:SetRoleMoveDestX(role, x)
            game_visual:SetRoleMoveDestY(role, y)
            game_visual:SetRoleMoveDestZ(role, z)
            game_visual:SetRoleMoveDistance(role, 1)
            game_visual:SetRoleMaxMoveDistance(role, 1)
            game_visual:SwitchPlayerState(role, 1, 103)
			 nx_pause(1)
            game_visual:SwitchPlayerState(role, 1, 5)
            game_visual:SwitchPlayerState(role, 1, 6)
            game_visual:SwitchPlayerState(role, 1, 7)
            role:SetPosition(role.PositionX, y, role.PositionZ)
            game_visual:SetRoleMoveDestX(role, x)
            game_visual:SetRoleMoveDestY(role, y)
            game_visual:SetRoleMoveDestZ(role, z)
            game_visual:SetRoleMoveDistance(role, 1)
            game_visual:SetRoleMaxMoveDistance(role, 1)
            game_visual:SwitchPlayerState(role, 1, 103)
        end
    end
end
function change_form_main_shortcut_cur_page_free(page)
	if not page then return end
	local form_shortcut = nx_value(FORM_MAIN_SHORTCUT)
	local grid = form_shortcut.grid_shortcut_main
	if nx_int(grid.page) == nx_int(page) then return end
	grid.page = nx_int(page) 
	local game_config_info = nx_value('game_config_info')
	if nx_is_valid(game_config_info) then
		nx_execute('util_functions', 'util_set_property_key', game_config_info, 'shortcut_page', nx_int(grid.page))
	end
	local CustomizingManager = nx_value('customizing_manager')
	if nx_is_valid(CustomizingManager) then
		CustomizingManager:SaveConfigToServer()
	end
	nx_execute(FORM_MAIN_SHORTCUT, 'on_shortcut_record_change', grid)
end

function getposFront(obj,dst)
	if not obj or obj == nil then return end
	local posBehindBoss = nil
	local xx = obj.DestX
	local zz = obj.DestZ	
	local radian = obj.DestOrient
	local angle = radian_to_degree(radian)
	if angle <= 90 then
		zz = zz - math.abs(math.sin(math.pi * 3 / 2 - radian) * dst)
		xx = xx - math.abs(math.cos(math.pi * 3 / 2 - radian) * dst)
	elseif angle > 90 and angle <= 180 then
		zz = zz + math.abs(math.sin(math.pi * 3 / 2 - radian) * dst)
		xx = xx - math.abs(math.cos(math.pi * 3 / 2 - radian) * dst)
	elseif angle > 180 and angle <= 270 then
		zz = zz + math.abs(math.sin(math.pi / 2 - radian) * dst)
		xx = xx + math.abs(math.cos(math.pi / 2 - radian) * dst)
	elseif angle > 270 then
		zz = zz - math.abs(math.sin(math.pi * 3 / 2 - radian) * dst)
		xx = xx + math.abs(math.cos(math.pi * 3 / 2 - radian) * dst)
	end
	posBehindBoss = {xx, obj.DestY, zz}
	return posBehindBoss
end
function getJumpFront(obj,dst)
	local posBehind = getposFront(obj,dst)
	if not tools_move_isArrived2D(posBehind[1], posBehind[2], posBehind[3], 0.5) then
		 local fight = nx_value('fight')		 
		fight:StopUseSkill()	
		nx_execute('custom_sender', 'custom_active_parry', nx_int(1), nx_int(0))
		jump_to_clone_low(posBehind,90,3)
	end
	if tools_move_isArrived2D(posBehind[1], posBehind[2], posBehind[3], 0.5) then
		return true
	end
	return false
end
CurMap = ''

get_pos_obj = function(obj)
	if not obj or obj == nil then return end
	local game_client = nx_value("game_client")
	local game_visual = nx_value("game_visual")
	if not nx_is_valid(game_client) or not nx_is_valid(game_visual) then 
		return nil
	end
	local client_player = game_client:GetPlayer()
	local visual_player = game_visual:GetPlayer()
	if not nx_is_valid(client_player) or not nx_is_valid(visual_player) or not nx_is_valid(obj) then
		return nil
	end
	local obj2_visual = game_visual:GetSceneObj(obj.Ident)
	if not nx_is_valid(obj2_visual) then
		return nil
	end
	local offX = visual_player.PositionX - obj2_visual.PositionX
	local offY = visual_player.PositionY - obj2_visual.PositionY
	local offZ = visual_player.PositionZ - obj2_visual.PositionZ	 
	local x,y,z = obj.DestX,obj.DestY, obj.DestZ
	return x,y,z,math.sqrt(offX * offX + offY * offY + offZ * offZ)
end
writeIniString = function(file, section, key, value)
  local ini = nx_create('IniDocument')
  ini.FileName = file
  if not ini:LoadFromFile() then
    local create_file = io.open(file, 'w+')
    create_file:close()
  end
  if not ini:LoadFromFile() then
    nx_destroy(ini)
    return 0
  end
  ini:WriteString(section, key, value)
  ini:SaveToFile()
  nx_destroy(ini)
  return 1
end
function jumpdan()	
local game_visual = nx_value('game_visual')
local role = util_get_role_model()
if nx_is_valid(role) and role.state ~= 'locked' then
role.move_dest_orient = role.AngleY
role.server_pos_can_accept = true
local visual_player = game_visual:GetPlayer()
game_visual:SwitchPlayerState(visual_player, 10000, 22)
end
end

function get_pos_y_from_xz_ga(x, z)
	local scene = nx_value('game_scene')
    if not nx_is_valid(scene) then
        return nil
    end
    local terrain = scene.terrain
	if not nx_is_valid(terrain) then
		return 0, 0
	end
  local floor_index = 0
  local y = terrain:GetPosiY(nx_number(x), nx_number(z))
  if terrain:GetFloorExists(nx_number(x), nx_number(z), floor_index) then
   y = terrain:GetFloorHeight(nx_number(x), nx_number(z), floor_index)
  else
    local floor, floor_y = get_pos_floor_index(terrain, nx_number(x),nx_number(y) ,nx_number(z))
    if floor > -1 then
      y = floor_y
      floor_index = floor
    end
  end
  return y
end
print_action_auto_run = function(auto_text)	
	if not auto_log_show then
		return
	end	
	if not auto_text then
		return
	end
	local form = nx_value('auto_new\\form_auto_log')
	local gui = nx_value('gui')		
	local game_client = nx_value('game_client')
	if nx_is_valid(form) and form.Visible then
		local mltbox = form.mltbox_content
		local scene = game_client:GetScene()		
		if nx_string(nx_value('loading')) == nx_string('false') and nx_string(nx_value('stage_main')) == nx_string('success') and nx_is_valid(scene) then			
			mltbox:Clear()	
			local title =  nx_function("ext_utf8_to_widestr", "<font color=\"#fc03e3\">Thao Tác</font>")
			mltbox:AddHtmlText(title, -1)
			local info_exe = nx_widestr(" - ") .. nx_function("ext_utf8_to_widestr", "<font color=\"#ff0000\">"..auto_text.." </font>")
			form.mltbox_content:AddHtmlText(info_exe, -2)
		end	
	else
		util_auto_show_hide_form('auto_new\\form_auto_log')
	end
end
function show_notice(text)
  text = utf8ToWstr(text)
  local gui = nx_value("gui")
  if not nx_is_valid(gui) then return end
  local dialog = nx_execute("util_gui", "util_get_form", "form_common\\form_confirm", true, false)
  nx_execute("form_common\\form_confirm", "show_common_text", dialog, text)
  dialog:ShowModal()
end
TALK_XUEX2 = {
	['talk_xuex_cbt_08_05'] = 'Thiên',
	['talk_xuex_cbt_08_06'] = 'Thiên',
	['talk_xuex_cbt_08_07'] = 'Thiên',
	['talk_xuex_cbt_08_08'] = 'Địa',
	['talk_xuex_cbt_08_09'] = 'Địa',
	['talk_xuex_cbt_08_10'] = 'Địa',
	['talk_xuex_cbt_08_11'] = 'Huyền',
	['talk_xuex_cbt_08_12'] = 'Huyền',
	['talk_xuex_cbt_08_13'] = 'Huyền',
	['talk_xuex_cbt_08_14'] = 'Hoàng',
	['talk_xuex_cbt_08_15'] = 'Hoàng',
	['talk_xuex_cbt_08_16'] = 'Hoàng',
}
get_sub_name_npc = function(sub_name)
	local game_client = nx_value('game_client')
	if not nx_is_valid(game_client) then
		return 
	end
	local game_scene = game_client:GetScene() 
	if not nx_is_valid(game_scene) then 
		return
	end
	if nx_is_valid(game_scene) then
		local scene_obj_table = game_scene:GetSceneObjList()
		for k = 1, table.getn(scene_obj_table) do
			local scene_obj = scene_obj_table[k]
			if nx_is_valid(scene_obj) then	
				local config_id = scene_obj:QueryProp("ConfigID")..'_1'				
				if getUtf8Text(config_id) == utf8ToWstr(sub_name) then
					return scene_obj
				end	
			end
		end
	end	
end

require('auto_cack')