require("util_gui")
require("util_move")
require("util_functions")
require("form_stage_main\\form_tiguan\\form_tiguan_util")
require("auto\\lib2")
require("auto\\lib")
require("auto_tools\\tool_libs")
local THIS_FORM = "auto\\auto_tiguan"
local FORM_TIGUAN_MAIN = "form_stage_main\\form_tiguan\\form_tiguan_one"
local FORM_TRACE  = "form_stage_main\\form_tiguan\\form_tiguan_ds_trace"
local FORM_DETAIL  = "form_stage_main\\form_tiguan\\form_tiguan_detail"
local FORM_TIGUAN_CHOICE_BOSS = "form_stage_main\\form_tiguan\\form_tiguan_choice_boss"
local MAP_FORM = "form_stage_main\\form_map\\form_map_scene"
local FORM_SKILL = "form_stage_main\\form_main\\form_main_shortcut_extraskill"
local FORM_SHORTCUT = "form_stage_main\\form_main\\form_main_shortcut"
-- require("batcoc")
local failed_get_bao_ruong = 0
local dont_find = {}
local black_list = {}
local pick_list = {}
local buff_list = {}
local skill_list = {
	{
		buff_nochieu = "",
		name = "cs_jh_chz", -- tham hop chi
		nochieu = "CS_jh_chz04",
		phadef = "CS_jh_chz07",
		combo = {"CS_jh_chz01","CS_jh_chz02","CS_jh_chz07"}
	},

	{
		buff_nochieu = "cs_tm_jsc03",
		name = "cs_tm_jsc", -- kim xa thich
		nochieu = "cs_tm_jsc06",
		phadef = "cs_tm_jsc04",
		combo = {"cs_tm_jsc02","cs_tm_jsc01","cs_tm_jsc07"}
	},
	{
		buff_nochieu = "",
		name = "cs_jh_cqgf", -- tho thien cong phu
		nochieu = "cs_jh_cqgf05",
		phadef = "cs_jh_cqgf02",
		combo = {"CS_jh_cqgf07","cs_jh_cqgf01","cs_jh_cqgf04"}
	},
}


function CheckIsLearning(skill_name)
  local wuxue_query = nx_value("WuXueQuery")
  if not nx_is_valid(wuxue_query) then
    return false
  end
  local fight = nx_value("fight")
  if not nx_is_valid(fight) then
    return false
  end
  local item_tab = wuxue_query:GetItemNames(2, nx_string(skill_name))
  for i = 1, table.getn(item_tab) do
    local item_name = item_tab[i]
    if item_name == NORMAL_ATTACK_ID then
      item_name = fight:GetNormalAttackSkillID()
    elseif item_name == ANQI_ATTACK_ID then
      item_name = fight:GetNormalAnqiAttackSkillID(false)
    end
    local skill = wuxue_query:GetLearnID_Skill(item_name)
    if nx_is_valid(skill) then
      return true
    end
  end
  return false
end

local err_boss = { -- thanh niên chôm của thằng auto9yin =)))
  "bosstg03001;Thẩm Thương Hải;340.734009,80.789001,814.367981;336.11499,80.039001,812.830933",
  "bosstg03004;Thẩm Bùi Giác;315.075012,77.473999,843.510986;319.04422,77.461411,843.615417",
  "bosstg03005;Thẩm Hi Giác;305.252014,78.082001,852.497009;308.160675,77.461411,842.004395",
  "bosstg03008;Từ Tâm Ninh;339.673004,80.735001,814.960999;335.298492,80.039001,812.472656",
  "bosstg03009;Ngọc Thiên Hoài;340.519989,80.735001,813.356018;335.791565,80.039001,813.058228",
  "bosstg28001;Công Tôn Kỳ;96.499001,-3.726,316.932007;88.721565,-3.728,317.060181",
  "bosstg28002;Công Tôn Hạo;84.081001,-3.758,401.67099;86.438858,-3.759,395.319275",
  "bosstg28003;Công Tôn Tán;54.707001,-7.46,291.997009;44.971172,-7.460211,297.435699",
  "bosstg28004;Công Tôn Giáng;61.005001,-7.46,301.891998;53.062046,-7.460211,308.240234",
  "bosstg28005;Công Tôn Đức;93.274002,-3.73,316.953003;88.789139,-3.728,317.341309",
  "bosstg02001;Đông Phương Hoàn;283.187012,42.587002,1127.953003;286.375427,42.398136,1115.780762",
  "bosstg02002;Diệp Nam Chi;251.882004,46.655998,1054.958984;256.076172,46.655567,1061.256958",
  "bosstg02003;Tần Tú Tú;283.097992,42.598,1127.968018;286.565063,42.398136,1113.785767",
  "bosstg02004;Tư Đồ Kính;283.212006,42.587002,1127.895996;287.068115,42.398136,1112.823975",
  "bosstg02005;Tư Khấu;250.199005,46.655998,1050.800049;253.30159,46.655567,1056.21167",
  "bosstg07003;Hồng Chiêu Dương;148.869003,20.344,1478.876953;149.06308,19.804461,1463.028198",
  "bosstg07004;Trần Hoài Tú;150.382996,20.344,1478.45105;144.991318,19.804461,1464.182251",
  "bosstg07001;Lưu Thái;134.537003,19.844,1437.94104;131.680099,18.633001,1425.852661",
  "bosstg07002;Hồ Bất Sầu;137.820007,19.922001,1436.887939;133.834106,18.633001,1425.262207",
  "bosstg29001;Lưu Thiết Đảm;1086.680054,46.458,379.653015;1078.979004,44.508533,372.907501",
  "bosstg29002;Đường Ngữ Hi;1059.119019,45.618999,429.953003;1060.298096,45.618004,421.698517",
  "bosstg29003;Hàn Tiếu;1058.300049,45.641998,429.614014;1059.151367,45.622002,421.517517",
  "bosstg29004;Trương Phi Vũ;1080.977051,46.452,408.756012;1066.394775,44.508533,413.475525",
  "bosstg29005;Tạ Khuyết Ngâm;1041.766968,46.466,423.691986;1039.767578,46.466003,425.482056",
  "bosstg29006;Thù Nghị;1080.938965,46.452,410.373993;1067.784546,44.508533,413.609711",
  "bosstg04001;Từ Vân Tĩnh;578.353027,39.367001,254.852005;585.033752,38.617001,251.229721",
  "bosstg04002;Từ Tử Khanh;591.828979,38.916,241.130005;589.123108,38.617001,249.597733",
  "bosstg04003;Từ Tử Lăng;594.89801,38.916,240.992004;588.631653,38.617001,250.401855",
  "bosstg04004;Từ Tử Sóc;580.091003,38.722,247.205994;585.239014,38.617001,247.170731",
  "bosstg04005;Từ Tử Tịch;607.163025,38.616001,260.597992;606.843933,38.617001,253.334854",
  "bosstg27001;Hùng Bá Thiên;-187.472,174.834,710.575989;-188.594849,172.091248,729.976379",
  "bosstg27002;Vạn Kiêu Chỉ;-188.977997,174.834,710.502991;-188.155914,172.06897,741.937256",
  "bosstg27003;Tần Thiên Báo;-146.026993,172.865005,727.388;-148.80809,172.670685,741.384338",
  "bosstg27004;Hoàng Khuê;-187.778,173.320999,716.370972;-188.97142,172.055466,730.606506",
  "bosstg27005;Hướng Vô Cực;-179.701004,172.102997,775.44397;-174.093689,172.35759,785.546387",
  "bosstg27006;Ngọa Nô Ngọc Không;-255.718994,179.546005,754.39502;-246.466202,178.40744,750.235046",
  "bosstg11001;Sử Thư Ưng;382.264008,88.153,1006.195007;376.398834,85.394234,993.715698",
  "bosstg11002;Sử Mạnh Hùng;404.134003,87.094002,996.661011;404.643799,87.094002,992.540466",
  "bosstg11003;Sử Vân Báo;338.358002,87.095001,1006.343994;338.892853,85.394234,990.890869",
  "bosstg11004;Sử Vũ Thi;383.127014,88.153,1006.280029;377.036499,85.394234,992.243469",
  "bosstg11005;Sử Diệu Hổ;381.411987,88.153,1006.169006;378.443085,85.394234,994.578552",
  "bosstg01001;Giang Tôn Đường;1342.527954,86.594002,707.247009;1346.630127,86.594002,707.106873",
  "bosstg01103;Giang Sính Đình;1320.994995,83.762001,652.825989;1320.198975,82.594025,671.329102",
  "bosstg01101;Cổ Tiêu Thiên;1266.633057,84.026001,679.513;1254.334106,84.106003,677.983582",
  "bosstg01201;Lương Ảnh Phong;1366.782959,82.594002,637.872009;1357.126221,82.594025,639.200195",
  "bosstg01102;Quân Hoài Minh;1344.005981,86.594002,706.797974;1347.072388,86.594002,704.544434",
  "bosstg01202;Tây Môn Yến;1299.237061,82.594002,632.893005;1292.523682,82.594025,642.609802",
  "bosstg30001;Quan Phùng Lôi;846.223022,-4.787,694.096008;845.961914,-6.311,704.752808",
  "bosstg30002;Hồng Hỉ;880.286987,-6.379,697.377014;884.528992,-6.378803,718.674622",
  "bosstg30003;Lưu Bách Thủ;956.942993,-6.273,736.874023;947.2323,-6.572973,737.656555",
  "bosstg30005;Lỗ Vượng Ai;900.914978,-5.517,753.210999;893.516296,-6.737,752.623901",
  "bosstg30006;Quan Ngọc Binh;845.348999,-4.787,694.471985;846.534851,-6.311,705.295532",
  "bosstg06001;Tô Bách Linh;-363.144989,37.688,-318.18399;-354.215424,37.336002,-311.33905",
  "bosstg06002;Trích Tinh Tử;-364.084991,37.688,-315.622986;-356.335876,37.336002,-311.377197",
  "bosstg06003;Thiên Hiểu Tử;-362.442993,37.688,-320.061005;-353.905548,37.336002,-311.937622",
  "bosstg06004;Ngọc Dương Tử;-363.048004,37.688,-317.71701;-352.20636,37.336002,-311.844788",
  "bosstg06007;Cẩn Nhi;-362.550995,37.688,-319.065002;-352.183197,37.336002,-310.880432",
  "bosstg06008;Xuất Trần Tử;-321.575989,38.917999,-300.295013;-320.11096191406,38.917003631592,-300.33944702148",
  "bosstg13001;Khúc Thiên;964.950012,78.152,476.440002;959.552368,78.152397,488.709747",
  "bosstg13002;Bành Hộ;923.534973,78.152,501.041992;932.921753,78.152397,490.20816",
  "bosstg13005;Phí Thanh;948.440002,78.152,492.531006;936.609924,78.152397,484.716858",
  "bosstg13006;Hoàng Hữu Thông;946.221008,78.152,493.325012;934.213257,78.152397,483.683197",
  "bosstg13007;Tinh Tà;1091.05896,81.273003,494.190002;1075.224731,81.272446,496.42395",
  "bosstg13008;Thiết Thịnh;1088.36499,81.273003,445.924011;1077.539185,81.353775,463.519592",
  "bosstg12001;Tả Nhất Minh;-260.812012,43.374001,469.950989;-240.96402,42.241001,470.902344",
  "bosstg12002;Mạc Y Nhân;-274.312012,39.287998,565.432983;-275.828644,39.290001,570.130676",
  "bosstg12004;Liễu Mộ Trần;-242.559998,39.287998,591.03302;-225.192383,39.269001,582.824768",
  "bosstg12005;Vĩnh Di;-262.377014,43.374001,469.878998;-243.329865,42.241001,470.385773",
  "bosstg12003;Thẩm Triệt;-266.998993,42.444,411.507996;-251.86702,41.2668,413.228241",
  "bosstg12006;Triệu Ngôn Vũ;-262.320007,43.374001,471.593994;-245.26683,42.241001,471.297729",
  "bosstg31001;Lão Đao Bá Tử;1127.427002,45.041,653.164001;1127.21521,45.041,660.992004",
  "bosstg31002;Câu Hồn Sứ Giả;1128.207031,45.041,652.195007;1130.425171,45.041,645.566833",
  "bosstg31004;Giáng Long;954.969971,62.681,781.398987;958.964172,62.681004,774.724487",
  "bosstg31003;Đoạt Phách Sứ Giả;1127.292969,45.041,652.265015;1129.697388,45.041,645.562561",
  "bosstg31005;Phục Hổ;954.250977,62.681,781.054016;959.345459,62.681004,776.172791",
  "bosstg31009;Hàn Nhược Cốc;954.719971,47.775002,543.713013;954.639954,44.790001,561.749023",
  "bosstg23001;Cơ Táng Hoa;1454.936035,108.748001,-63.186001;1448.086304,108.749008,-61.455872",
  "bosstg23004;Cơ phu nhân;1454.973999,108.748001,-63.577;1447.834351,108.749008,-61.093658",
  "bosstg23005;Cơ Lăng Phượng;1454.764038,110.795998,-109.598999;1455.093994,108.143005,-95.870277",
  "bosstg23007;Đông Quách Cao;1454.890991,108.262001,-147.824005;1454.130249,108.262009,-138.482315",
  "bosstg23002;Cơ Khổ Tình;1454.764038,110.795998,-109.463997;1455.163208,108.143005,-95.339592",
  "bosstg23003;Cơ Bi Tình;1521.422974,108.152,-139.393997;1518.949707,108.152008,-130.189713",
  "bosstg17001;Thù Bách Tuế;-16.188999,37.507,822.190979;-11.120433,36.584015,814.600891",---- sửa
  "bosstg17004;Vương Thanh;-38.685001,26.114,735.375977;-30.685383,26.091002,734.046387",
  "bosstg17006;Tiết Ác Hổ;-63.504002,34.862,764.294006;-51.745102,33.642002,773.207458",
  "bosstg17007;Viên Cưu;-62.938999,34.863998,763.59198;-53.552254,33.639,772.040466",
  "bosstg17005;Hùng Tề Sơn;-12.056,36.583,819.241028;-11.120433,36.584015,814.600891", ---- sửa
  "bosstg17008;Diêm Tiểu Long;-14.745,36.537998,816.872009;-11.120433,36.584015,814.600891", ---- sửa
  "bosstg20001;Yến Bách Khổ;809.666992,-18.818001,44.698002;809.667236,-18.817001,44.697979",
  "bosstg20004;Yến Cô Hồng;809.687012,-18.818001,44.845001;809.667236,-18.817001,44.697979",
  "bosstg20007;Yến Bạch Lâu;809.788025,-18.818001,44.887001;809.687012,-18.817001,44.845001",
  "bosstg20011;Khâu Kiếm Minh;809.758972,-18.818001,44.863998;809.687012,-18.817001,44.845001",
  "bosstg20006;Yến Hoa Phong;809.674988,-18.818001,44.721001;809.687012,-18.817001,44.845001",
  "bosstg20009;Yến Thất;809.804016,-18.818001,44.877998;809.674988,-18.817001,44.721001",
  "bosstg20003;Yến Tinh Tuyết;809.843994,-18.818001,44.768002;809.804016,-18.817001,44.877998",
  "bosstg18001;Đông Phương Thành;359.533997,-124.845001,1611.628052;363.863525,-124.846008,1612.044556",
  "bosstg18002;Long Tử Yên;304.897003,-141.75,1404.837036;303.734375,-143.695236,1393.614258",
  "bosstg18003;Đông Phương Vũ;422.80899,-141.882996,1526.897949;406.822388,-143.695236,1527.019531",
  "bosstg18004;Đông Phương Nhân;261.472992,-136.925003,1439.170044;262.034821,-136.924011,1433.125854",
  "bosstg18006;Đông Phương Tuyết;288.627991,-141.492004,1352.990967;304.083313,-143.628006,1353.407471",
  "bosstg18013;Đông Phương Sĩ;356.423004,-139.884003,1414.588013;361.162018,-141.889679,1404.44043",
  "bosstg18014;Đông Phương Ngôn;358.562012,-139.884003,1414.706055;352.142365,-141.889679,1401.967285",
  "bosstg19001;Mộ Dung Thiên Thu;984.296021,14.848,1327.677002;997.073914,14.848001,1330.752319",
  "bosstg19002;Mộ Dung Đại;985.221008,14.848,1328.005005;997.81665,14.848001,1327.180908",
  "bosstg19003;Mộ Dung Thần;979.195007,14.848,1284.724976;991.855164,14.848001,1283.736938",
  "bosstg19004;Mộ Dung Khanh;985.895996,14.848,1327.881958;996.641174,14.848001,1326.566406",
  "bosstg19005;Mộ Dung Càn;984.379028,14.848,1328.35498;998.972656,14.848001,1327.860596",
  "bosstg19006;Đinh Bất Dương;983.351013,17.66,1390.725952;992.855225,17.660002,1394.130005",
  "bosstg19007;Ngô Bất kính;983.445007,17.66,1391.459961;992.926453,17.660002,1393.961182",
  "bosstg05004;Nam Cung Bình;412.889008,122.349998,119.612;396.513916,122.169579,120.61911",
  "bosstg05001;Nam Cung Ngạo;274.513,128.251007,118.766998;275.099854,128.073013,114.121239",
  "bosstg05008;Nam Cung Chân;365.234985,125.25,50.535999;354.223511,124.045807,56.813126",
  "bosstg05010;Nam Cung Giác;149.488998,123.109001,118.413002;175.134155,122.116333,119.516556",
  "bosstg05007;Diệp Thúy Lan;170.600006,123.421997,142.186005;174.231949,122.120201,125.359276",
  "bosstg05003;Nam Cung Tuấn;171.985992,122.473999,134.156006;174.839981,122.117569,122.710381",
  "bosstg05005;Nam Cung Liệt;149.503006,123.148003,119.691002;173.788559,122.116997,119.666084",
  "bosstg16001;Trang Duật Hiền;875.61499,37.790001,873.380981;869.361816,34.729,859.00293",
  "bosstg16002;Vân Tố Vấn;849.234009,35.931999,862.862976;853.940979,34.571587,853.31366",
  "bosstg16004;Vệ Vô Phong;885.825012,35.792,847.481995;875.340515,34.571587,843.779541",
  "bosstg16006;Từ Vân Thành;874.247009,37.785,874.20697;867.555481,34.811001,855.588745",
  "bosstg16003;Trang Tiểu Tiên;860.921997,37.791,875.697998;867.392334,37.785004,877.635681",
  "bosstg16005;Trang Thanh Thanh;887.288025,37.791,864.612;884.730,37.786,868.909", -- sửa
  "bosstg16007;Trang Minh Châu;876.830017,37.785,872.773987;867.703308,34.811001,855.494568",
}

function CheckIsError(bossid)
  for k = 1, table.getn(err_boss) do
    local boss_info = util_split_string(nx_string(err_boss[k]), ";")
    if boss_info[1] == bossid then
      return boss_info
    end
  end
  return nil
end


function AutoSwitchTHTHLevel(level)
	local form = util_get_form(FORM_TIGUAN_MAIN, false)
	if nx_is_valid(form) and not form.Visible then
		return
	end
	local btn = "rbtn_level_" .. nx_string(level)
	form[btn].Checked = true
	nx_execute("form_stage_main\\form_tiguan\\form_tiguan_one", "on_rbtn_level_checked_changed", form[btn])
end

function AutoCheckBossInfo(level, sub)
	local form = util_get_form(FORM_TIGUAN_MAIN, false)
	if nx_is_valid(form) and not form.Visible then
		return 
	end
	local gui = nx_value("gui")
	local array_name = "guan" .. nx_string(level) .. "sub" .. nx_string(sub)
	local record_guan_id = nx_execute(FORM_TIGUAN_MAIN, "get_tiguan_record", array_name, "value1")
	local record_boss_index = nx_execute(FORM_TIGUAN_MAIN, "get_tiguan_record", array_name, "value2")
	local boss_id = nx_execute(FORM_TIGUAN_MAIN, "get_boss_id", nx_string(record_guan_id), nx_number(record_boss_index))
	local boss_name = gui.TextManager:GetText(boss_id)
	local iscomplete = nx_execute(FORM_TIGUAN_MAIN, "get_tiguan_record", array_name, "value7")
	local isbossred = nx_execute(FORM_TIGUAN_MAIN, "FindBossBeArrest", boss_id, sub)
	return boss_id, iscomplete, isbossred, record_guan_id, boss_name

end

function select_target_byName(playername)
  local game_client = nx_value("game_client")
  local game_visual = nx_value("game_visual")
  if not nx_is_valid(game_client) then
    return
  end
  if not nx_is_valid(game_visual) then
    return
  end
  local client_scene = game_client:GetScene()
  if not nx_is_valid(client_scene) then
    return
  end
  local obj_list = client_scene:GetSceneObjList()
  for i = 1, table.maxn(obj_list) do
    local client_scene_obj = obj_list[i]
    local visual_scene_obj = game_visual:GetSceneObj(client_scene_obj.Ident)
    local type = client_scene_obj:QueryProp("Type")
    if type == TYPE_PLAYER then
      local Name = client_scene_obj:QueryProp("Name")
      if nx_string(playername) == nx_string(Name) then
        local fight = nx_value("fight")
        fight:SelectTarget(visual_scene_obj)
      end
    else
    	local Name = client_scene_obj:QueryProp("ConfigID")
		if nx_string(playername) == nx_string(Name) then
			local fight = nx_value("fight")
			fight:SelectTarget(visual_scene_obj)
			return client_scene_obj
		end
    end
  end
end

function get_bao_ruong()
  local game_client = nx_value("game_client")
  local game_visual = nx_value("game_visual")
  if not nx_is_valid(game_client) then
    return
  end
  if not nx_is_valid(game_visual) then
    return
  end
  local client_scene = game_client:GetScene()
  if not nx_is_valid(client_scene) then
    return
  end
  local obj_list = client_scene:GetSceneObjList()
  for i = 1, table.maxn(obj_list) do
    local client_scene_obj = obj_list[i]
    local visual_scene_obj = game_visual:GetSceneObj(client_scene_obj.Ident)
    if not setContains(dont_find, client_scene_obj.Ident) and client_scene_obj:FindProp("NpcType") and client_scene_obj:QueryProp("NpcType") == 161 and not client_scene_obj:FindProp("Dead") and not client_scene_obj:FindProp("CanPick") then
      	return client_scene_obj
    end
  end
  return nx_null()
end

function auto_pickup()
	local form = util_get_form("auto_tiguan")
    local client = nx_value("game_client")
    if not nx_is_valid(client) then
      return 0
    end
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
      return 0
    end
    local client_player = client:GetPlayer()

    local view_table = client:GetViewList()
    for i = 1, table.getn(view_table) do
        local view = view_table[i]
        if view.Ident == "80" then
            local view_obj_table = view:GetViewObjList()
            for k = 1, table.getn(view_obj_table) do
                local view_obj = view_obj_table[k]
                local x = nx_function("ext_widestr_to_utf8", nx_ws_lower(util_text(view_obj:QueryProp("ConfigID"))))
                if is_in_pick_list(1, x) then
                	nx_execute("custom_sender", "custom_pickup_single_item", view_obj.Ident)
                end
            end
        end
 
    end
    return true
end



function get_boss_id_list(guan_id)
  local ini = nx_execute("util_functions", "get_ini", SHARE_CHANGGUAN_INI)
  if not nx_is_valid(ini) then
    return nil
  end
  local sec_index = ini:FindSectionIndex(nx_string(guan_id))
  local str_id = ini:ReadString(sec_index, "BossList", "")
  return util_split_string(str_id, ";")
end

function AutoSetStatus(status)
	local form = util_get_form(THIS_FORM, true)
	if form.auto_start then 
		form.btn_ok.Text = nx_function("ext_utf8_to_widestr", "Bắt đầu")
		form.auto_start = false
		return
	else 
		form.btn_ok.Text = nx_function("ext_utf8_to_widestr", "Kết thúc")
		form.auto_start = true
	end
end


function AutoTiguan(form)
	local current_boss, isbossred, iscomplete, start_fight, guan_id = nil, false, false, false, 0
	if not form.auto_oskill then
		if form.selectskill == 0 then 
			AutoSendMessage("Vui lòng chọn bộ skill bạn muốn đánh")
			return
		end
	end
	if form.auto_start then
		AutoSetStatus(false)
	else
		AutoSetStatus(true)
	end
	local start_x, start_y, start_z = 0,0,0
	while form.auto_start do
		nx_pause(0.5)
		local game_client = nx_value("game_client")
		local client_player = game_client:GetPlayer()
		if client_player:QueryProp("LogicState") == 120 then -- nếu chết thì quit auto
			nx_execute("custom_sender", "custom_tiguan_request_leave")
			AutoSetStatus(false)
		end
		local form_tiguan = util_get_form(FORM_TIGUAN_MAIN, true)
		local form_trace = util_get_form(FORM_TRACE, false)
		local form_detail = util_get_form(FORM_DETAIL, false)
		local form_map = nx_value(MAP_FORM)
		local loading_flag = nx_value("loading")
		if not loading_flag then -- Không trong quá trình tải map
			if nx_is_valid(form_trace) and form_trace.Visible then -- Đang trong khiêu chiến
				if nx_is_valid(form_tiguan) and form_tiguan.Visible then util_auto_show_hide_form(FORM_TIGUAN_MAIN) end -- Nếu mà form THTH vẫn còn thì tắt nó đi
				if nx_is_valid(form_map) then
					local game_client = nx_value("game_client")
					local game_visual = nx_value("game_visual")
					
					if nx_is_valid(game_client) and nx_is_valid(game_visual) then
						local scene = game_client:GetScene()
						if nx_is_valid(scene) then
                        local finish_cdts = nx_value("tiguan_finish_cdts")
                        local cdt_tab = finish_cdts:GetChildList()
                        for i = 1, table.getn(cdt_tab) do
                            local child = cdt_tab[i]
                            if nx_number(child.ismust) == 1 then
                                local cdt_ini = nx_execute("util_functions", "get_ini", "share\\War\\tiguan_success_condition.ini")
                                local index = cdt_ini:FindSectionIndex(nx_string(child.cdt_id))
                                if index > 0 then
                                    local loveu = cdt_ini:GetItemValueList(index, "r")
                                    local info_tab = util_split_string(nx_string(loveu[1]), ",")
                                    form.current_boss = info_tab[2]
                                end
                                
                          --      AutoSendMessage(index)
                            --    AutoSendMessage(nx_string(child.cdt_id))
                            end
                        end

                        local boss_x, boss_y, boss_z = nil,nil,nil
                        local fight_x, fight_y, fight_z = nil,nil,nil
                        local a1 = CheckIsError(form.current_boss)
                        if a1 ~= nil then
                            local a2 = util_split_string(a1[4], ",")
                            fight_x, fight_y, fight_z = a2[1],a2[2],a2[3] --vị trí đánh
                            a2 = util_split_string(a1[3], ",")
                            boss_x, boss_y, boss_z = a2[1],a2[2],a2[3] -- vị trí boss
                         --   AutoSendMessage(form.current_boss)
                        else
                            local mgr = nx_value("SceneCreator")
                            if nx_is_valid(mgr) then
                                local res = mgr:GetNpcPosition(scene:QueryProp("Resource"), form.current_boss)
                                if table.getn(res) >= 3 then
                                    boss_x, boss_y, boss_z = res[1],res[2],res[3]
                                    fight_x, fight_y, fight_z = res[1],res[2],res[3]
                                end 
                            end
                        end

							-- kết thúc kiểm tra

							if boss_z ~= nil then
								local client_player = game_client:GetPlayer()
								local visual_player = game_visual:GetPlayer()
								if nx_is_valid(client_player) and nx_is_valid(visual_player) then
									local px, py, pz = visual_player.PositionX, visual_player.PositionY, visual_player.PositionZ
								
									local boss_obj = select_target_byName(form.current_boss)

									if boss_obj ~= nil then
										if boss_obj:FindProp("LastObject") then
											if distance3d(fight_x,fight_y,fight_z,px,py,pz) <= 3 then
												if nx_function("find_buffer", client_player, "buf_riding_01") then -- Nếu đang trên ngựa thì cho nó xuống
								                	nx_execute("custom_sender", "custom_remove_buffer", "buf_riding_01")
							                	end
----------------- test
				local game_client = nx_value("game_client")
				if not nx_is_valid(game_client) then
					return false
				end
				local game_scence = game_client:GetScene()
				if not nx_is_valid(game_scence) then
					return false
				end
				local game_scence_objs = game_scence:GetSceneObjList()
				local game_scence_objsn = table.getn(game_scence_objs)
				local hasNPC = false
				for i = 1, game_scence_objsn do
					local obj = game_scence_objs[i]
					if obj:FindProp("Type") and obj:QueryProp("Type") == 4 and obj:FindProp("ConfigID") and obj:QueryProp("ConfigID") == form.current_boss then
						hasNPC = true
						bossID = obj.Ident
					--	nx_execute("custom_sender", "custom_select", obj.Ident)
						break
					end
				end
				if not hasNPC then
					bossID = ""
					break
				end
												local form_shortcut = nx_value("form_stage_main\\form_main\\form_main_shortcut")
                                                local grid = form_shortcut.grid_shortcut_main
                                                local game_shortcut = nx_value("GameShortcut")
                                                local actions = get_obj_actions_full(bossID) ---
					--console(actions) -- test log skill boss
					--console(form.current_boss)											
					if nx_is_valid(game_shortcut) then
						local allowUseSkill = false
						if check_boss_reset(form.current_boss) then
								game_shortcut:on_main_shortcut_useitem(grid, 8, true) -- boss reset thì ném phi tiêu để ở phím 9
						end
						-- Boss đỡ đòn thì xài skill phá def
						if in_array("parrying_up", actions) then
							allowUseSkill = true
							game_shortcut:on_main_shortcut_useitem(grid, 0, true)
						end
						if  getAllowUseSkill(form.current_boss, actions) == true then
							allowUseSkill = true
						end
						if allowUseSkill then
							-- Không có buff ôn thần, boss không bị ngã hoặc còn lại 5s thì mới xài
							local buffNC = get_buff_info("buf_CS_jl_shuangci07")
							if (buffNC == nil or buffNC < 5) and not in_array("hurtdown", actions) then
								allowUseSkill = true
								game_shortcut:on_main_shortcut_useitem(grid, 4, true)
							end
							if client_player:QueryProp("SP") >= 50 and client_player:QueryProp("MPRatio") <= 30 then -- nộ phím số 0 ()
                                 nx_execute("custom_sender", "custom_active_parry", 1, 1) -- đỡ đòn
                                 game_shortcut:on_main_shortcut_useitem(grid, 9, true)
                            end
							game_shortcut:on_main_shortcut_useitem(grid, 1, true)
							game_shortcut:on_main_shortcut_useitem(grid, 2, true)
							game_shortcut:on_main_shortcut_useitem(grid, 3, true)
							nx_execute("custom_sender", "custom_active_parry", 1, 1) -- đỡ đòn
						end
					end
----------- het test
												if form.auto_bathe or form.auto_x2 then -- auto dùng buff
							                    	local x = nx_function("ext_widestr_to_utf8", nx_ws_lower(util_text(form.current_boss)))
							                    	if is_in_pick_list(2, x) then
							                    		local form_skill = nx_value(FORM_SKILL)
							                    		if nx_is_valid(form_skill) then
							                    			local grid = form_skill.imagegrid_skill
							                    			local grid_count = grid.ClomnNum * grid.RowNum
							                    			for i = 0, grid_count - 1 do
							                    				local skill_id = nx_execute(FORM_SKILL, "get_skill_id_by_index", i)
							                    				local skill_flag = nx_execute(FORM_SKILL, "get_skill_flag_by_index", i)
							                    				if skill_id ~= "" then
							                    					if skill_id == "jn_drtg_001" and not nx_function("find_buffer", client_player, "buf_drtg_001_2") then
							                    						AutoSendMessage("Tìm thấy buff bá thể")
							                    						nx_execute("custom_sender", "custom_extra_skill", form_skill.type, skill_flag)
							                    					end
							                    					if skill_id == "jn_drtg_004" and not nx_function("find_buffer", boss_obj, "buf_drtg_004_2") then
							                    						AutoSendMessage("Tìm thấy buff x2")
							                    						nx_pause(5)
							                    						nx_execute("custom_sender", "custom_extra_skill", form_skill.type, skill_flag)
							                    					end
							                    				end
							                    			end
							                    		end
							                    	end
							                    end
											else
												if distance3d(px,py,pz,start_x,start_y,start_z) <= 1 then
													game_visual:SwitchPlayerState(visual_player, "jump", 5)
												end
												if not is_path_finding() then
													nx_execute("hyperlink_manager", "find_path_npc_item",  "findpath,"..scene:QueryProp("Resource")..","..fight_x..","..fight_y..","..fight_z, true) 
												end
											end
										else
											if distance3d(boss_x,boss_y,boss_z,px,py,pz) > 3 then
												if distance3d(px,py,pz,start_x,start_y,start_z) <= 1 then
													game_visual:SwitchPlayerState(visual_player, "jump", 5)
												end
												if nx_find_custom(visual_player, "path_finding")then
                                                    if not is_path_finding(visual_player) then
                                                        nx_execute("hyperlink_manager", "find_path_npc_item",  "findnpc_new,"..scene:QueryProp("Resource")..","..form.current_boss, true) 
                                                    end
                                                else
                                                    nx_execute("hyperlink_manager", "find_path_npc_item",  "findnpc_new,"..scene:QueryProp("Resource")..","..form.current_boss, true) 
                                                end
											end
										end
									else
										if distance3d(boss_x,boss_y,boss_z,px,py,pz) > 3 then
											if distance3d(px,py,pz,start_x,start_y,start_z) <= 1 then
												game_visual:SwitchPlayerState(visual_player, "jump", 5)
											end
											if nx_find_custom(visual_player, "path_finding")then
                                                if not is_path_finding(visual_player) then
                                                    nx_execute("hyperlink_manager", "find_path_npc_item",  "findnpc_new,"..scene:QueryProp("Resource")..","..form.current_boss, true) 
                                                end
                                            else
                                                nx_execute("hyperlink_manager", "find_path_npc_item",  "findnpc_new,"..scene:QueryProp("Resource")..","..form.current_boss, true) 
                                            end
										end
									end
									start_x,start_y,start_z=px,py,pz
								end


							else
								AutoSendMessage("Có lỗi xảy ra, không tìm thấy tọa độ boss")
							end
						end
					end
				end
			else
				if nx_is_valid(form_detail) and form_detail.Visible then -- Hoàn thành turn
					if nx_is_valid(form_map) then
						start_fight = false
						if form.auto_pickup then
							obj = get_bao_ruong()

							auto_pickup()
							
							if nx_is_valid(obj) then
								local game_visual = nx_value("game_visual")
								if not nx_is_valid(game_visual) then
									return false
								end
								local game_client = nx_value("game_client")
								if not nx_is_valid(game_client) then
									return false
								end

								local client_player = game_client:GetPlayer()
								local visual_player = game_visual:GetPlayer()
								local player_pos_x = visual_player.PositionX
								local player_pos_y = visual_player.PositionY
								local player_pos_z = visual_player.PositionZ
								local open_range = obj:QueryProp("OpenRange")
								local box_name = obj:QueryProp("ConfigID")
								local x, y, z = obj.PosiX, obj.PosiY, obj.PosiZ
								local id = obj.Ident
								local strData = nx_string("findpath,") .. nx_string(form_map.current_map) ..",".. nx_string(x) ..",".. nx_string(y) ..",".. nx_string(z)
								local pick_form = nx_value("form_stage_main\\form_pick\\form_droppick") 
								if nx_is_valid(pick_form) then -- Nếu có bảng đang nhặt
									nx_execute("custom_sender", "custom_close_drop_box") -- Tắt cmn đê
									if not setContains(black_list, id) then -- Thêm vào danh sách éo bao h nhặt nữa
										addToSet(black_list, id)
									end
								end
								if distance3d(player_pos_x, player_pos_y, player_pos_z, x, y, z) <= open_range then -- Nếu gần chỗ mở rương rồi
									if client_player:QueryProp("State") ~= "interact017" and client_player:QueryProp("State") ~= "interact041" then -- Nếu chưa mở thì mở
										nx_execute("custom_sender", "custom_select", id)
									end
								else
									if not is_path_finding() then
										local world = nx_value("world")
										local scene = world.MainScene
										local terrain = scene.terrain
										if can_forward_pos(terrain, visual_player, x, z) then -- tìm xem cái rương đó có bị kẹt k, kẹt thì thôi bỏ qua, k thì chạy đến mà nhặt
											nx_execute("hyperlink_manager", "find_path_npc_item",  strData, true) 
										else 
											addToSet(dont_find, id)
										end
									end
								end
							else
								failed_get_bao_ruong = failed_get_bao_ruong + 1
								if failed_get_bao_ruong >= 10 then -- Nếu không get đc cái bảo rương nào chưa mở trong 10 lần thì tự động chim cút
									nx_execute("custom_sender", "custom_tiguan_request_leave")
								end
							end
						else
							nx_execute("custom_sender", "custom_tiguan_request_leave")
						end
					end
				else
					if not start_fight and nx_is_valid(form) then
						if not form_tiguan.Visible then
							util_auto_show_hide_form(FORM_TIGUAN_MAIN)
						else
							if form_tiguan.friend_card_count == 0 then -- này là tránh lag form, lâu lâu nó lag k get đc info, thì tắt đi bật lại :3
								AutoSaveSetting(form)
								form:Close()
							else
							if nx_is_valid(form) then
							form:Show()
							end
								local game_client = nx_value("game_client")
								if not nx_is_valid(game_client) then
									return false
								end
---------- tự đớp cá sốt 
if not find_buffer("buff_csxingfen4") and item_count_id("caiyao10197") >  0  then -- buff cá sốt, số lượng cá sốt >0
	if CheckIsLearning("CS_xjz_xjz") then 
		use_skill_id("xjz_01")  --Câu Hỏa
		nx_pause(8)
	end
	use_item_id("caiyao10197") -- cá sốt canh
	nx_pause(5)
	local tuido = util_get_form("form_stage_main\\form_bag", true, true)
	tuido:Close()
end
---------- tự đớp cá sốt 
								local client_player = game_client:GetPlayer()
								if client_player:QueryProp("HPRatio") < 100 and client_player:QueryProp("LogicState") ~= 102 then -- tự ngồi thiền hồi máu mỗi khi xong
									local fight = nx_value("fight")
									fight:TraceUseSkill("zs_default_01", false, false)
								else
									if client_player:QueryProp("MPRatio") < 100 and client_player:QueryProp("LogicState") ~= 102 then
										local fight = nx_value("fight")
										fight:TraceUseSkill("zs_default_01", false, false)
									else
										if client_player:QueryProp("HPRatio") == 100 and client_player:QueryProp("MPRatio") == 100 then
											if client_player:FindProp("LogicState") and client_player:QueryProp("LogicState") == 102 then -- đầy máu rồi thì ngồi làm méo gì nữa ? =))
												local fight = nx_value("fight")
												fight:TraceUseSkill("zs_default_01", false, false)
											end
											local current_tab = form_tiguan.cur_tiguan_level
											local max_level = "tab_" .. current_tab .. "_input"
											failed_get_bao_ruong = 0
											for i = 1, nx_number(form[max_level].Text) do
												local next_btn = "cbtn_arrestboss" .. nx_string(i)
												form.current_boss, iscomplete, isbossred, guan_id, boss_name = AutoCheckBossInfo(current_tab, i)
												if iscomplete == 2 then 
													if i >= nx_number(form[max_level].Text) then
														if current_tab == form_tiguan.cur_level_limit then 
															if form_tiguan.reset_times > 0 then
																if form.auto_reset then
																	if form_tiguan.reset_times > 1 then
																		if form_tiguan.btn_double_model.Enabled and form.auto_dungvo then
																			nx_execute("custom_sender", "custom_send_danshua_tiguan_msg", CLIENT_MSG_DS_DOUBLE_MODEL) -- Dũng võ
																		else
																			nx_execute("custom_sender", "custom_send_danshua_tiguan_msg", CLIENT_MSG_DS_OFFSET_OMIT) -- Reset turn
																		end
																		nx_pause(1)
																		AutoSwitchTHTHLevel(1)
																	else -- Còn 1 turn reset cuối cùng
																		if form_tiguan.btn_double_model.Enabled then
																			if not form.auto_dungvo then -- nếu k check tự dũng võ thì stop
																				AutoSendMessage("Auto tự động dừng khi chỉ còn 1 turn và chưa dũng võ ")
																				AutoSetStatus(false)
																			else
																				nx_execute("custom_sender", "custom_send_danshua_tiguan_msg", CLIENT_MSG_DS_DOUBLE_MODEL) -- check tự dũng võ thì dũng võ thôi
																			end
																		end
																	end
																else
																	AutoSendMessage("Đã hoàn thành xong turn !")
																	AutoSetStatus(false)
																end
															else
																AutoSendMessage("Đã đạt giới hạn của tuần, auto tự động dừng")
																AutoSetStatus(false)
															end
														else
															if current_tab >= form_tiguan.cur_level_limit then 
																AutoSetStatus(false)
															else
																AutoSwitchTHTHLevel(current_tab + 1)
																nx_pause(1)
															end
															
														end
													end
												else
													
													if not form_tiguan.btn_start.Enabled then
														nx_execute(FORM_TIGUAN_MAIN, "on_cbtn_arrestboss_click", form_tiguan[next_btn])
													else
														
---- Mỗi vòng chọn 1 đối thủ fix 
if not form_tiguan.btn_double_model.Enabled and form.auto_usekcl and check_kcl(current_tab)then --nút dũng võ ẩn,tùy chọn dùng kcl và có kcl
chon_boss_do(current_tab,boss_name,guan_id,i)
end
local form_tiguan_one = nx_value(FORM_TIGUAN_MAIN)
if current_tab == 4 and form_tiguan_one.free_appoint == 1 then -- vòng 4, còn lượt free
chon_boss_do(current_tab,boss_name,guan_id,i)
end

----- Mỗi vòng chọn 1 đối thủ fix
														local form_choice = nx_value(FORM_TIGUAN_CHOICE_BOSS)
														if not nx_is_valid(form_choice) then -- có bảng chọn boss thì tạm dừng để chọn boss đỏ khi dùng kcl
															nx_execute(FORM_TIGUAN_MAIN, "on_btn_start_click", form_tiguan.btn_start) -- bắt đầu
															start_fight = true
														end
													end
													break
												end
											end
										end
									end
								end
							end
						end
					end
				end	
			end
		end
	end
end

function AutoLoadPickupList( form )
	local file = GetFileDir(1)
	if not form.string_list:LoadFromFile(file) then
		return 0
	end
	form.combobox_tab_6.DropListBox:ClearString()
	local gm_num = form.string_list:GetStringCount()
	for i = 0, gm_num - 1 do
		local gm = form.string_list:GetStringByIndex(i)
		if gm ~= "" then
			local x = nx_function("ext_utf8_to_widestr", gm)
				form.pick_str = form.pick_str .. gm .. ","
				form.combobox_tab_6.DropListBox:AddString(x)
		end
	end
end

function ReloadPickupList( form, content )
	local file = GetFileDir(1)
	form.string_list:ClearString()

	local a = util_split_string(form.pick_str, ",")
	form.pick_str = ""
	for i = 1, table.getn(a) do
		if string.len(nx_string(a[i])) > 0 then
			if a[i] ~= content then 
				form.string_list:AddString(a[i])
				form.pick_str = form.pick_str .. a[i] .. ","
			end
		end
	end
	form.string_list:SaveToFile(file)
end

function AutoLoadBossList( form )
	local file = GetFileDir(2)
	if not form.boss_list:LoadFromFile(file) then
		return 0
	end
	form.combobox_tab_9.DropListBox:ClearString()
	local gm_num = form.boss_list:GetStringCount()
	for i = 0, gm_num - 1 do
		local gm = form.boss_list:GetStringByIndex(i)
		if gm ~= "" then
			local x = nx_function("ext_utf8_to_widestr", gm)
				form.boss_str = form.boss_str .. gm .. ","
				form.combobox_tab_9.DropListBox:AddString(x)
		end
	end
end

function ReloadBossList( form, content )
	local file = GetFileDir(2)
	form.boss_list:ClearString()

	local a = util_split_string(form.boss_str, ",")
	form.boss_str = ""
	for i = 1, table.getn(a) do
		if string.len(nx_string(a[i])) > 0 then
			if a[i] ~= content then 
				form.boss_list:AddString(a[i])
				form.boss_str = form.boss_str .. a[i] .. ","
			end
		end
	end
	form.boss_list:SaveToFile(file)
end

function is_in_pick_list( type, content )
	local file = GetFileDir(type)
	local gm_list = nx_create("StringList")
	if not gm_list:LoadFromFile(file) then
		nx_destroy(gm_list)
		return 0
	end
	local gm_num = gm_list:GetStringCount()
	for i = 0, gm_num - 1 do
		local gm = gm_list:GetStringByIndex(i)
		if gm ~= "" and gm == content then
			return true
		end
	end
	return false
end

function AutoSaveSetting( form )
	local ini = nx_create("IniDocument")
	local file = GetFileDir(3)
	if not ini:LoadFromFile() then
	   
	end
  	ini.FileName = file
	ini:WriteString("thth", "auto_reset", nx_string(form.check_box_1.Checked))
	ini:WriteString("thth", "auto_pickup", nx_string(form.check_box_2.Checked))
	ini:WriteString("thth", "auto_bathe", nx_string(form.check_box_3.Checked))
	ini:WriteString("thth", "auto_x2", nx_string( form.check_box_4.Checked))
	ini:WriteString("thth", "auto_dungvo", nx_string(form.check_box_7.Checked))
	ini:WriteString("thth", "auto_boqua", nx_string(form.check_box_6.Checked))
	ini:WriteString("thth", "auto_usekcl", nx_string(form.check_box_5.Checked))
	ini:WriteString("thth", "auto_oskill", nx_string(form.check_box_8.Checked))
	ini:WriteInteger("thth", "selectskill", form.selectskill)
	ini:WriteInteger("thth", "tab1", nx_number(form.tab_1_input.Text))
	ini:WriteInteger("thth", "tab2", nx_number(form.tab_2_input.Text))
	ini:WriteInteger("thth", "tab3", nx_number(form.tab_3_input.Text))
	ini:WriteInteger("thth", "tab4", nx_number(form.tab_4_input.Text))
	ini:SaveToFile()
	nx_destroy(ini)
end

function AutoLoadSetting( form )
	local ini = nx_create("IniDocument")
	local file = GetFileDir(3)
  	ini.FileName = file
  	if not ini:LoadFromFile() then
  		return
  	end
  	form.auto_reset = nx_boolean(ini:ReadString("thth", "auto_reset", ""))
  	form.auto_pickup = nx_boolean(ini:ReadString("thth", "auto_pickup", ""))
  	form.auto_bathe = nx_boolean(ini:ReadString("thth", "auto_bathe", ""))
  	form.auto_x2 = nx_boolean(ini:ReadString("thth", "auto_x2", ""))
  	form.auto_usekcl = nx_boolean(ini:ReadString("thth", "auto_usekcl", ""))
  	form.auto_boqua = nx_boolean(ini:ReadString("thth", "auto_boqua", ""))
  	form.auto_dungvo = nx_boolean(ini:ReadString("thth", "auto_dungvo", ""))
  	form.auto_oskill = nx_boolean(ini:ReadString("thth", "auto_oskill", ""))
  	form.selectskill = ini:ReadInteger("thth", "selectskill", 0)
  	form.tab_1_input.Text = nx_widestr(ini:ReadString("thth", "tab1", 1))
  	form.tab_2_input.Text = nx_widestr(ini:ReadString("thth", "tab2", 1))
  	form.tab_3_input.Text = nx_widestr(ini:ReadString("thth", "tab3", 4))
  	form.tab_4_input.Text = nx_widestr(ini:ReadString("thth", "tab4", 4))
end

function on_tiguan_init(form)
	form.Fixed = false
	form.current_boss = nil
	form.auto_start = false
	form.auto_reset = false
	form.auto_pickup = false
	form.auto_bathe = false
	form.auto_x2 = false
	form.auto_usekcl = false
	form.auto_boqua = false
	form.auto_dungvo = false
	form.auto_oskill = false
	form.selectskill = 0
	form.pick_str = ""
	form.boss_str = ""
	form.string_list = nx_create("StringList")
	form.boss_list = nx_create("StringList")
end

function on_tiguan_open(self)
	self.combobox_tab_6.DropListBox:ClearString()
	AutoLoadPickupList(self)
	self.combobox_tab_9.DropListBox:ClearString()
	AutoLoadBossList(self)
	AutoLoadSetting(self)

	self.check_box_1.Checked = self.auto_reset 
	self.check_box_2.Checked = self.auto_pickup
	self.check_box_3.Checked = self.auto_bathe 
	self.check_box_4.Checked = self.auto_x2 
	self.check_box_5.Checked = self.auto_usekcl 
	self.check_box_6.Checked = self.auto_boqua 
	self.check_box_7.Checked = self.auto_dungvo 
	self.check_box_8.Checked = self.auto_oskill 


	self.combobox_tab_7.DropListBox:ClearString()

	local wuxue_query = nx_value("WuXueQuery")
	local type_tab = wuxue_query:GetMainNames(2)
	for i = 1, table.getn(type_tab) do
		local type_name = type_tab[i]
		local sub_type_tab = wuxue_query:GetSubNames(2, type_name)
	    for j = 1, table.getn(sub_type_tab) do
	    	local sub_type_name = sub_type_tab[j]
	    	if CheckIsLearning(sub_type_name) then
	    		self.combobox_tab_7.DropListBox:AddString(util_text(sub_type_name))
		    	
			end
		end
	end

	self.combobox_tab_7.OnlySelect = true
	-- if self.selectskill == 0 then
	-- 	self.combobox_tab_7.DropListBox.SelectIndex = 0
	-- else
	-- 	local gui = nx_value("gui")
	-- 	self.combobox_tab_7.InputEdit.Text = gui.TextManager:GetFormatText(skill_list[self.selectskill].name)
	-- 	self.combobox_tab_7.DropListBox.SelectIndex = self.selectskill - 1
	-- end
	
end

function on_tiguan_close(form)
AutoSaveSetting(form)
end

function on_cbtn_reset( cbtn )
	local form = cbtn.ParentForm
	form.auto_reset = cbtn.Checked
end
function on_cbtn_pickup( cbtn )
	local form = cbtn.ParentForm
	form.auto_pickup = cbtn.Checked
end
function on_cbtn_buffbathe( cbtn )
	local form = cbtn.ParentForm
	form.auto_bathe = cbtn.Checked
end
function on_cbtn_buffx2( cbtn )
	local form = cbtn.ParentForm
	form.auto_x2 = cbtn.Checked
end
function on_cbtn_usekcl( cbtn )
	local form = cbtn.ParentForm
	form.auto_usekcl = cbtn.Checked
end
function on_cbtn_boqua( cbtn )
	local form = cbtn.ParentForm
	form.auto_boqua = cbtn.Checked
end
function on_cbtn_dungvo( cbtn )
	local form = cbtn.ParentForm
	form.auto_dungvo = cbtn.Checked
end
function on_cbtn_oskill( cbtn )
	local form = cbtn.ParentForm
	form.auto_oskill = cbtn.Checked
end

function on_btn_ok_click(btn)
	local form = btn.ParentForm
    AutoTiguan(form)
    AutoSaveSetting(form)
end

function on_btn_tab_5( btn )
	local form = btn.ParentForm
	if string.len(nx_string(form.tab_5_input.Text)) > 0 and form.tab_5_input.Text ~= "" and form.tab_5_input.Text ~= nil then
		local x = nx_function("ext_widestr_to_utf8", nx_ws_lower(form.tab_5_input.Text))
		if is_in_pick_list(1, x) then
			AutoSendMessage("Vật phẩm <font color=\"#509D4D\">" .. x .. "</font> đã tồn tại trong danh sách sẽ nhặt")
		else
			local file = GetFileDir(1)
			form.pick_str = form.pick_str .. x .. ","
			form.string_list:AddString(x)
			form.string_list:SaveToFile(file)
			form.combobox_tab_6.DropListBox:AddString(form.tab_5_input.Text)
			form.tab_5_input.Text = ""
			AutoSendMessage("Vật phẩm <font color=\"#509D4D\">" .. x .. "</font> đã được thêm thành công")
		end
	else
		AutoSendMessage("Vui lòng điền vật phẩm bạn muốn thêm")
	end
end

function on_btn_tab_6( btn )
	local form = btn.ParentForm
	if string.len(nx_string(form.combobox_tab_6.Text)) > 0 and form.combobox_tab_6.Text ~= "" and form.combobox_tab_6.Text ~= nil then
		local x = nx_function("ext_widestr_to_utf8",  nx_ws_lower(form.combobox_tab_6.Text))
		if is_in_pick_list(1, x) then
			ReloadPickupList(form, x)
			form.combobox_tab_6.DropListBox:RemoveString(nx_widestr(form.combobox_tab_6.Text))
			form.combobox_tab_6.Text = ""
			AutoSendMessage("Đã xóa vật phẩm <font color=\"#509D4D\">" .. x .. "</font> ra khỏi danh sách thành công")
		else

			AutoSendMessage("Vật phẩm <font color=\"#509D4D\">" .. x .. "</font> không có trong danh sách")
		end
	else
		AutoSendMessage("Vui lòng chọn vật phẩm bạn muốn xóa")
	end
end
function on_btn_tab_8( btn )
	local form = btn.ParentForm
	if string.len(nx_string(form.tab_8_input.Text)) > 0 and form.tab_8_input.Text ~= "" and form.tab_8_input.Text ~= nil then
		local x = nx_function("ext_widestr_to_utf8", nx_ws_lower(form.tab_8_input.Text))
		if is_in_pick_list(2, x) then
			AutoSendMessage("Boss <font color=\"#509D4D\">" .. x .. "</font> đã tồn tại trong danh sách sẽ dùng buff")
		else
			local file = GetFileDir(2)
			form.boss_str = form.boss_str .. x .. ","
			form.boss_list:AddString(x)
			form.boss_list:SaveToFile(file)
			form.combobox_tab_9.DropListBox:AddString(form.tab_8_input.Text)
			form.tab_8_input.Text = ""
			AutoSendMessage("Boss <font color=\"#509D4D\">" .. x .. "</font> đã được thêm thành công")
		end
	else
		AutoSendMessage("Vui lòng điền boss bạn muốn thêm")
	end
end

function on_btn_tab_9( btn )
	local form = btn.ParentForm
	if string.len(nx_string(form.combobox_tab_9.Text)) > 0 and form.combobox_tab_9.Text ~= "" and form.combobox_tab_9.Text ~= nil then
		local x = nx_function("ext_widestr_to_utf8", nx_ws_lower(form.combobox_tab_9.Text))
		if is_in_pick_list(2, x) then
			ReloadBossList(form, x)
			form.combobox_tab_9.DropListBox:RemoveString(nx_widestr(form.combobox_tab_9.Text))
			form.combobox_tab_9.Text = ""
			AutoSendMessage("Đã xóa boss <font color=\"#509D4D\">" .. x .. "</font> ra khỏi danh sách thành công")
		else

			AutoSendMessage("Boss <font color=\"#509D4D\">" .. x .. "</font> không có trong danh sách")
		end
	else 
		AutoSendMessage("Vui lòng chọn boss bạn muốn xóa")
	end
end
function on_combobox_7_selected( self )
	local form = self.ParentForm
	form.selectskill = self.DropListBox.SelectIndex + 1
end
function TiguanClose ( form )
	util_auto_show_hide_form("auto\\auto_tiguan")
end

------- các hàm thêm
function get_arrest_boss(level, guanname)
	local form = nx_value(FORM_TIGUAN_MAIN)
	if not nx_is_valid(form) then
	end

	for i = 1, 7 do
		local guan_id = nx_execute(FORM_TIGUAN_MAIN, "get_arrest_data", level, i, 1)
		local boss_id = nx_execute(FORM_TIGUAN_MAIN, "get_arrest_data", level, i, 2)
		local guan_name = nx_widestr("")

		local gui = nx_value("gui")
		if not nx_is_valid(gui) then
			return 0
		end
		local ui_ini = form.guan_ui_ini
		if not nx_is_valid(ui_ini) then
			return 0
		end
		local index = ui_ini:FindSectionIndex(guan_id)
		if index >= 0 then
			guan_name = nx_execute(FORM_TIGUAN_MAIN, "get_desc_by_id", ui_ini:ReadString(index, "Name", ""))
		end
		if guanname == guan_name then
			return gui.TextManager:GetText(boss_id)
		end
	end
	return nx_widestr("")
end
function getAllowUseSkill(bossName, actions) -- check skill boss, nhưng éo ăn thua. =)) dm kệ cmn.
	if in_array("hurtdown", actions) or (in_array("fi_stand", actions) and table.getn(actions) == 2) or in_array("fi_ready", actions) then
		return true
	end
	-- Cơ Lăng Phượng
	if bossName == "bosstg23005" then
		-- Viên Nguyệt Loan Khai
		if in_array("buffloop", actions) and in_array("atk7", actions) then
			return false
		end
	end
	-- Nam Cung Bình
	if bossName == "bosstg05004" then
		if in_array("buffloop", actions) then
			return false
		end
	end
	-- Yến Cô Hồng
	if bossName == "bosstg20004" then
		if in_array("datk2", actions) then
			return false
		end
	end
	if bossName == "bosstg17005" then -- Hùng Tề Sơn
		if in_array("atk3", actions) then
			return false
		end
	end	
	if bossName == "bosstg31001" then -- lão đao bá tử
		if  in_array("atk3", actions) then
			return false
		end
	end	
	if bossName == "bosstg31005" then -- phục hổ
		if  in_array("atk3", actions) or in_array("atk2", actions)   then
			return false
		end
	end	
	if bossName == "bosstg01201" then -- lương ảnh phong -- test
		if  in_array("datk", actions) or in_array("atk", actions)   then
			return false
		end
	end		
	return true
end
function get_obj_actions_full(ident, action_id)
	return get_obj_actions(ident, action_id, 1)
end
function get_obj_actions(ident, action_id, isFull)
	local game_visual = nx_value("game_visual")
	local role = game_visual:GetSceneObj(nx_string(ident))
	if not nx_is_valid(role) then
		if action_id == nil then
			return {}
		else
			return false
		end
	end
	-- isFull: 0 chỉ có action cơ bản, 1 action cơ bản và acction cắt, 2 chỉ có action cắt
	if isFull == nil then
		isFull = 1
	end
	local actor_role = role:GetLinkObject("actor_role")
	if nx_is_valid(actor_role) then
	  role = actor_role
	end
	local mount_action_list = role:GetActionBlendList()
	local floor_count = table.maxn(mount_action_list)
	local action_name = ""
	local action_blended = false
	local action_unblending = false
	local action_loop = false
	local action_lists = {}

	for i = 0, floor_count - 1 do
		action_name = mount_action_list[i + 1]
	    action_blended = role:IsActionBlended(action_name)
	    action_unblending = role:IsActionUnblending(action_name)
	    action_loop = role:GetBlendActionLoop(action_name)
		if action_name == action_id then
			return true
		end
		if isFull == 0 or isFull == 1 then
			table.insert(action_lists, action_name)
		end
		if isFull == 1 or isFull == 2 then
			local action_name1 = nx_widestr(action_name)
			if nx_function("ext_ws_find", action_name1, nx_widestr("parrying_up")) > -1 then
				table.insert(action_lists, "parrying_up")
			elseif nx_function("ext_ws_find", action_name1, nx_widestr("hurt")) > -1 then
				table.insert(action_lists, "hurtdown")
			elseif nx_function("ext_ws_find", action_name1, nx_widestr("fi_stand")) > -1 then
				table.insert(action_lists, "fi_stand")
			elseif nx_function("ext_ws_find", action_name1, nx_widestr("fi_ready")) > -1 then
				table.insert(action_lists, "fi_ready")
			elseif nx_function("ext_ws_find", action_name1, nx_widestr("atk7")) > -1 then
				table.insert(action_lists, "atk7")
			elseif nx_function("ext_ws_find", action_name1, nx_widestr("datk2")) > -1 then
				table.insert(action_lists, "datk2")
			elseif nx_function("ext_ws_find", action_name1, nx_widestr("buffloop1")) > -1 then
				table.insert(action_lists, "buffloop")
			end
		end
	end
	if action_id == nil then
		return action_lists
	else
		return false
	end
end

function check_boss_reset(boss_id)
local game_client = nx_value("game_client")
local game_scence = game_client:GetScene()
local game_visual = nx_value("game_visual")
local visual_player = game_visual:GetPlayer()
local scene_obj_table = game_scence:GetSceneObjList()
for k = 1, table.getn(scene_obj_table) do
	local doituong = scene_obj_table[k]
    if nx_is_valid(doituong) then
		local id = doituong.Ident
		local target = game_visual:GetSceneObj(id)
		--local player_name = nx_function("ext_widestr_to_utf8", doituong:QueryProp("Name"))
		local name = doituong:QueryProp("ConfigID")
		if name == boss_id then
		local boss_ox, boss_oy, boss_oz = target.PositionX, target.PositionY, target.PositionZ
		local player_pos_x = visual_player.PositionX
		local player_pos_y = visual_player.PositionY
		local player_pos_z = visual_player.PositionZ
			if distance3d(boss_ox,boss_oy,boss_oz,player_pos_x,player_pos_y,player_pos_z) > 4 then
			--AutoSendMessage("Boss quá xa")
			return true
			else return false
			end
		end
	end
end
end
function on_main_form_open(form)
on_tiguan_open(self)
	form.is_minimize = false
end
function check_kcl(lv)
if lv == 1 or lv == 2 then
	if item_count_id("tiguan_reset_item_01") > 0 then
		return true
	end
return false
end
if lv == 3 then
	if item_count_id("tiguan_reset_item_02") > 0 then
		return true
	end
return false
end
if lv == 4 then
	if item_count_id("tiguan_reset_item_03") > 0 then
		return true
	end
return false
end
return false
end

function chon_boss_do(current_tab,boss_name,guan_id,i)
local form_tiguan_one = nx_value(FORM_TIGUAN_MAIN)
-- Xác định boss đỏ thế lực hiện tại
local ui_ini = form_tiguan_one.guan_ui_ini
if not nx_is_valid(ui_ini) then
	return 0
end
local gui = nx_value("gui")
if not nx_is_valid(gui) then
	return 0
end
local guan_name_text = nx_widestr("")
local index = ui_ini:FindSectionIndex(nx_string(guan_id))
if index >= 0 then
	guan_name_text = nx_execute(FORM_TIGUAN_MAIN, "get_desc_by_id", ui_ini:ReadString(index, "Name", ""))
end
local arrest_boss_name = get_arrest_boss(current_tab, guan_name_text) --- bọn boss đỏ
if arrest_boss_name ~= boss_name and current_tab ~= 1 then -- vòng 1 không dùng kcl
	local btn = form_tiguan_one["btn_choice" .. i]
	nx_execute(FORM_TIGUAN_MAIN, "on_btn_choice_click", btn)
	nx_pause(0.8)
	local chonboss = nx_value(FORM_TIGUAN_CHOICE_BOSS) -- cái bảng chọn boss đỏ
	if not nx_is_valid(chonboss) then
		return 0
	end	
	-- chọn boss đỏ
	for k = 1, chonboss.cur_gbox_count do
		local gbox = chonboss.groupscrollbox_1:Find("gbox_choice_boss_" .. nx_string(k))
		if nx_is_valid(gbox) then
			local cbtn_select = gbox:Find("cbtn_choice_boss_select_" .. nx_string(k))
			local cbtn_label = gbox:Find("lbl_choice_boss_name_" .. nx_string(k))
			if nx_is_valid(cbtn_select) and nx_is_valid(cbtn_label)  and cbtn_label.Text == arrest_boss_name then 
				cbtn_select.Checked = true --- chọn boss
			end
		end
	end
	nx_pause(0.5)
	if current_tab == 4 and form_tiguan_one.free_appoint == 1 then
	-- Mỗi ngày chọn 1 đối thủ
		if chonboss.free_appoint then
			chonboss.cbtn_spent_item.Checked = true
			nx_pause(0.2)
		end
	end
	local btn = chonboss.btn_select
	nx_execute(FORM_TIGUAN_CHOICE_BOSS, "on_btn_select_click", btn) --- ok
end
end

