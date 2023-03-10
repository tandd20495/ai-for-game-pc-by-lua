require("util_gui")
require("util_move")
require("util_functions")
require("form_stage_main\\form_tiguan\\form_tiguan_util")
require("auto\\lib2")
require("auto\\lib")

local THIS_FORM = "auto\\auto_tiguan_today"
local FORM_DETAIL  = "form_stage_main\\form_tiguan\\form_tiguan_detail"
local FORM_SHORTCUT = "form_stage_main\\form_main\\form_main_shortcut"
local FORM_TVT_TIGUAN = "form_stage_main\\form_tvt\\form_tvt_tiguan"
local FORM_TVT_TIGUAN_GUAN = "form_stage_main\\form_tvt\\form_tvt_tiguan_guan"
-- require("batcoc")
local failed_get_bao_ruong = 0
local dont_find = {}
local black_list = {}
local pick_list = {}
local buff_list = {}

local tiguan_id = {
    {guan_id=1,mapid="city05",npcid="TGnpc001"},
    {guan_id=2,mapid="born04",npcid="TGnpc004"},
    {guan_id=3,mapid="city05",npcid="TGnpc007"},
    {guan_id=4,mapid="city05",npcid="TGnpc012"},
    {guan_id=5,mapid="city05",npcid="TGnpc017"},
    {guan_id=6,mapid="born02",npcid="TGnpc025"},
    {guan_id=7,mapid="born03",npcid="TGnpc022"},
    {guan_id=11,mapid="school02",npcid="TGnpc037"},
    {guan_id=12,mapid="school08",npcid="TGnpc040"},
    {guan_id=13,mapid="born03",npcid="TGnpc052"},
    {guan_id=15,mapid="city01",npcid="TGnpc034"},
    {guan_id=16,mapid="school05",npcid="TGnpc046"},
    {guan_id=17,mapid="school05",npcid="TGnpc055"},
    {guan_id=18,mapid="city01",npcid="TGnpc058"},
    {guan_id=19,mapid="city02",npcid="TGnpc061"},
    {guan_id=20,mapid="city04",npcid="TGnpc064"},
    {guan_id=21,mapid="born02",npcid="TGnpc067"},
    {guan_id=23,mapid="city01",npcid="TGnpc073"},
    {guan_id=24,mapid="scene08",npcid="TGnpc076"},
    {guan_id=25,mapid="born03",npcid="TGnpc079"},
    {guan_id=26,mapid="city04",npcid="TGnpc082"},
    {guan_id=27,mapid="born01",npcid="TGnpc085"},
    {guan_id=28,mapid="city04",npcid="TGnpc088"},
    {guan_id=29,mapid="school05",npcid="TGnpc091"},
    {guan_id=30,mapid="school07",npcid="TGnpc094"},
    {guan_id=31,mapid="school01",npcid="TGnpc097"},
    {guan_id=32,mapid="scene08",npcid="TGnpc100"}
}

function GetTiguanId(gid)
    for k = 1, table.getn(tiguan_id) do
        if nx_number(tiguan_id[k].guan_id) == nx_number(gid) then
            return tiguan_id[k]
        end
    end
end



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

local err_boss = {
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
  "bosstg17001;Thù Bách Tuế;-16.188999,37.507,822.190979;-7.776051,36.534,810.171204",
  "bosstg17004;Vương Thanh;-38.685001,26.114,735.375977;-30.685383,26.091002,734.046387",
  "bosstg17006;Tiết Ác Hổ;-63.504002,34.862,764.294006;-51.745102,33.642002,773.207458",
  "bosstg17007;Viên Cưu;-62.938999,34.863998,763.59198;-53.552254,33.639,772.040466",
  "bosstg17005;Hùng Tề Sơn;-12.056,36.583,819.241028;-8.250524,36.534,809.673096",
  "bosstg17008;Diêm Tiểu Long;-14.745,36.537998,816.872009;-6.664351,36.534,811.470032",
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
  -- "bosstg05004;Nam Cung Bình;412.889008,122.349998,119.612;396.513916,122.169579,120.61911",
  -- "bosstg05001;Nam Cung Ngạo;274.513,128.251007,118.766998;275.099854,128.073013,114.121239",
  -- "bosstg05008;Nam Cung Chân;365.234985,125.25,50.535999;354.223511,124.045807,56.813126",
  -- "bosstg05010;Nam Cung Giác;149.488998,123.109001,118.413002;175.134155,122.116333,119.516556",
  "bosstg05007;Diệp Thúy Lan;170.600006,123.421997,142.186005;174.231949,122.120201,125.359276",
  "bosstg05003;Nam Cung Tuấn;171.985992,122.473999,134.156006;174.839981,122.117569,122.710381",
  "bosstg05005;Nam Cung Liệt;149.503006,123.148003,119.691002;173.788559,122.116997,119.666084",
  "bosstg16001;Trang Duật Hiền;875.61499,37.790001,873.380981;869.361816,34.729,859.00293",
  "bosstg16002;Vân Tố Vấn;849.234009,35.931999,862.862976;853.940979,34.571587,853.31366",
  "bosstg16004;Vệ Vô Phong;885.825012,35.792,847.481995;875.340515,34.571587,843.779541",
  "bosstg16006;Từ Vân Thành;874.247009,37.785,874.20697;867.555481,34.811001,855.588745",
  "bosstg16003;Trang Tiểu Tiên;860.921997,37.791,875.697998;867.392334,37.785004,877.635681",
  "bosstg16005;Trang Thanh Thanh;887.288025,37.791,864.612;883.455688,37.785004,871.013611",
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
  local visual_player = game_visual:GetPlayer()
  local obj_list = client_scene:GetSceneObjList()
  for i = 1, table.maxn(obj_list) do
    local client_scene_obj = obj_list[i]
    local visual_scene_obj = game_visual:GetSceneObj(client_scene_obj.Ident)
    if nx_is_valid(visual_scene_obj) then
        local dis = distance3d(visual_scene_obj.PositionX,visual_scene_obj.PositionY,visual_scene_obj.PositionZ,visual_player.PositionX,visual_player.PositionY,visual_player.PositionZ)
        if dis <= 10 and not setContains(dont_find, client_scene_obj.Ident) and client_scene_obj:FindProp("NpcType") and client_scene_obj:QueryProp("NpcType") == 161 and not client_scene_obj:FindProp("Dead") and not client_scene_obj:FindProp("CanPick") then
            return client_scene_obj
        end
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

function TeleportTest()
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
  local x, y, z, a = visual_player.PositionX, visual_player.PositionY, visual_player.PositionZ, visual_player.face_orient

  x = x - math.sin ( math.rad(a) ) * 20 
  y = y + math.cos ( math.rad(a) ) * 20 

  game_visual:EmitPlayerInput(visual_player, PLAYER_INPUT_LOCATION, x, y, z, 1, 1)
  nx_pause(0.2)
  visual_player:SetPosition(x,y,z)
  local scene_obj = nx_value("scene_obj")
end


function AutoTiguan(form)

	if form.auto_start then
		AutoSetStatus(false)
	else
		AutoSetStatus(true)
	end
	local start_x, start_y, start_z = 0,0,0
  local stuck = 0
	while form.auto_start do
		nx_pause(0.5)
		local game_visual = nx_value("game_visual")
        local game_client = nx_value("game_client")
        if nx_is_valid(game_visual) and nx_is_valid(game_client) then
            local client_player = game_client:GetPlayer()
            local visual_player = game_visual:GetPlayer()
            local scene = game_client:GetScene()
            local loading_flag = nx_value("loading")
            if not loading_flag and nx_is_valid(client_player) and nx_is_valid(visual_player) and nx_is_valid(scene) then

                if client_player:FindProp("Dead") then
                   nx_execute("custom_sender", "custom_relive", 2, 0)
                end
                local px, py, pz = visual_player.PositionX, visual_player.PositionY, visual_player.PositionZ
                if client_player:FindProp("CurGuanID") then
                    local form_detail = util_get_form(FORM_DETAIL, false)
                    if nx_is_valid(form_detail) and form_detail.Visible then
                        nx_execute("custom_sender", "custom_active_parry", 0, 1)
                        local obj = get_bao_ruong()
                        auto_pickup()
                        if nx_is_valid(obj) then
                            local open_range = obj:QueryProp("OpenRange")
                            local box_name = obj:QueryProp("ConfigID")
                            local x, y, z = obj.PosiX, obj.PosiY, obj.PosiZ
                            local id = obj.Ident
                            local strData = nx_string("findpath,") .. scene:QueryProp("Resource") ..",".. nx_string(x) ..",".. nx_string(y) ..",".. nx_string(z)
                            local pick_form = nx_value("form_stage_main\\form_pick\\form_droppick") 
                            if nx_is_valid(pick_form) then -- Nếu có bảng đang nhặt
                                nx_execute("custom_sender", "custom_close_drop_box") -- Tắt cmn đê
                                if not setContains(black_list, id) then -- Thêm vào danh sách éo bao h nhặt nữa
                                    addToSet(black_list, id)
                                end
                            end
                            if distance3d(px, py, pz, x, y, z) <= open_range then -- Nếu gần chỗ mở rương rồi
                                if client_player:QueryProp("State") ~= "interact017" and client_player:QueryProp("State") ~= "interact041" then -- Nếu chưa mở thì mở
                                    nx_execute("custom_sender", "custom_select", id)
                                end
                            else
                                if nx_find_custom(visual_player, "path_finding")then
                                    if not is_path_finding(visual_player) then
                                        local world = nx_value("world")
                                        local scene = world.MainScene
                                        local terrain = scene.terrain
                                        if can_forward_pos(terrain, visual_player, x, z) then -- tìm xem cái rương đó có bị kẹt k, kẹt thì thôi bỏ qua, k thì chạy đến mà nhặt
                                            nx_execute("hyperlink_manager", "find_path_npc_item",  strData, true) 
                                        else 
                                            addToSet(dont_find, id)
                                        end
                                    end
                                else
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
                                failed_get_bao_ruong = 0
                                nx_execute("custom_sender", "custom_tiguan_request_leave")
                            end
                        end
                    else
                        local form_tvt = util_get_form(FORM_TVT_TIGUAN, false)
                        if nx_is_valid(form_tvt) and form_tvt.Visible then
                            nx_destroy(form_tvt)
                        end
                        local current_boss = nil
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
                                    current_boss = info_tab[2]
                                end
                                
                               
                            end
                        end
                        local fight = nx_value("fight")
                        local boss_x, boss_y, boss_z = nil,nil,nil
                        local fight_x, fight_y, fight_z = nil,nil,nil
                        local a1 = CheckIsError(current_boss)
                        if a1 ~= nil then
                            local a2 = util_split_string(a1[4], ",")
                            fight_x, fight_y, fight_z = a2[1],a2[2],a2[3]
                            a2 = util_split_string(a1[3], ",")
                            boss_x, boss_y, boss_z = a2[1],a2[2],a2[3]
                        else
                            local mgr = nx_value("SceneCreator")
                            if nx_is_valid(mgr) then
                                local res = mgr:GetNpcPosition(scene:QueryProp("Resource"), current_boss)
                                if table.getn(res) >= 3 then
                                    boss_x, boss_y, boss_z = res[1],res[2],res[3]
                                    fight_x, fight_y, fight_z = res[1],res[2],res[3]
                                end 
                            end
                        end

                        if boss_z ~= nil then
                            local boss_obj = select_target_byName(current_boss)
                            if boss_obj ~= nil then
                                if boss_obj:FindProp("LastObject") then
                                  local can_attack = fight:CanAttackNpc(client_player, boss_obj)
                                  if can_attack then
                                      if distance3d(fight_x,fight_y,fight_z,px,py,pz) <= 4 then
                                          if nx_function("find_buffer", client_player, "buf_riding_01") then -- Nếu đang trên ngựa thì cho nó xuống
                                              nx_execute("custom_sender", "custom_remove_buffer", "buf_riding_01")
                                          end
                                          local form_shortcut = nx_value("form_stage_main\\form_main\\form_main_shortcut")
                                          local grid = form_shortcut.grid_shortcut_main
                                          local game_shortcut = nx_value("GameShortcut")
                                          -- if boss_obj:FindProp("CurSkillID") and boss_obj:QueryProp("CurSkillID") ~= "" then
                                          --     nx_execute("custom_sender", "custom_active_parry", 1, 1)
                                          -- else
                                              if nx_is_valid(game_shortcut) then
                                                      if distance3d(px, py, pz, boss_obj.PosiX, boss_obj.PosiY, boss_obj.PosiZ) > 4 then
                                                        nx_execute("custom_sender", "custom_select", boss_obj.Ident)
                                                        fight:TraceUseSkill("hw_normal_fb", true, true)
                                                      end
                                                      if client_player:QueryProp("HPRatio") <= 30 then
                                                        fight:TraceUseSkill("cs_wd_tjj03", true, false) 
                                                        fight:TraceUseSkill("cs_wd_tjj02", true, false) 
                                                      else
                                                        if nx_function("find_buffer", boss_obj, "BuffInParry") then
                                                          game_shortcut:on_main_shortcut_useitem(grid, 0, true)
                                                        end
                                                        if client_player:QueryProp("SP") >= 25 then
                                                          if not nx_function("find_buffer", client_player, "buf_CS_jl_shuangci07") then
                                                            nx_execute("custom_sender", "custom_active_parry", 1, 1)
                                                            game_shortcut:on_main_shortcut_useitem(grid, 4, true)
                                                          end
                                                        end
														if client_player:QueryProp("SP") >= 50 then -- nộ phím số 0 ()
															nx_execute("custom_sender", "custom_active_parry", 1, 1) -- đỡ đòn
															game_shortcut:on_main_shortcut_useitem(grid, 9, true)
														end

                                                        for k = 1, 3 do
                                                            nx_execute("custom_sender", "custom_active_parry", 1, 1)
                                                            if nx_function("find_buffer", boss_obj, "BuffInParry") then
                                                                game_shortcut:on_main_shortcut_useitem(grid, 0, true)
                                                            else
                                                                game_shortcut:on_main_shortcut_useitem(grid, k, true)
                                                            end
                                                        end 
                                                      end
                                                  
                                              end
                                          -- end
                                      else
                                          nx_execute("custom_sender", "custom_active_parry", 0, 1)
                                          if distance3d(px,py,pz,start_x,start_y,start_z) < 1 then
                                              stuck = stuck + 1
                                              if stuck >= 4 then
                                                game_visual:SwitchPlayerState(visual_player, "jump", 5)
                                                -- TeleportTest()
                                                stuck = 0
                                              end
                                          end
                                          if nx_find_custom(visual_player, "path_finding") then
                                              if not is_path_finding(visual_player) then
                                                  nx_execute("hyperlink_manager", "find_path_npc_item",  "findpath,"..scene:QueryProp("Resource")..","..fight_x..","..fight_y..","..fight_z, true) 
                                              end
                                          else
                                              nx_execute("hyperlink_manager", "find_path_npc_item",  "findpath,"..scene:QueryProp("Resource")..","..fight_x..","..fight_y..","..fight_z, true) 
                                          end
                                      end
                                  
                                  end
                                
                                else
                                  if distance3d(px,py,pz,start_x,start_y,start_z) <= 1 then
                                    if nx_function("find_buffer", client_player, "buf_riding_01") then -- Nếu đang trên ngựa thì cho nó xuống
                                        nx_execute("custom_sender", "custom_remove_buffer", "buf_riding_01")
                                    end
                                    nx_execute("custom_sender", "custom_select", boss_obj.Ident)
                                    fight:TraceUseSkill("hw_normal_fb", true, true)
                                  end
                                end
                            else
                                if distance3d(boss_x,boss_y,boss_z,px,py,pz) > 5 then
                                    if distance3d(px,py,pz,start_x,start_y,start_z) <= 1 then
                                        stuck = stuck + 1
                                        if stuck >= 4 then
                                          game_visual:SwitchPlayerState(visual_player, "jump", 5)
                                          TeleportTest()
                                          stuck = 0
                                        end
                                    end
                                    if nx_find_custom(visual_player, "path_finding") then
                                        if not is_path_finding(visual_player) then
                                            nx_execute("hyperlink_manager", "find_path_npc_item",  "findpath,"..scene:QueryProp("Resource")..","..fight_x..","..fight_y..","..fight_z, true)
                                        end
                                    else
                                        nx_execute("hyperlink_manager", "find_path_npc_item",  "findpath,"..scene:QueryProp("Resource")..","..fight_x..","..fight_y..","..fight_z, true)
                                    end
                                end
                            end
                            start_x,start_y,start_z = px,py,pz
                        else
                            AutoSendMessage("Không tìm thấy tọa độ boss !")
                        end
                    end
                else
                    local guan_ui_ini = nx_execute("util_functions", "get_ini", "ini\\ui\\tiguan\\changguan.ini")
                    if not nx_is_valid(guan_ui_ini) then
                        return 0
                    end
                    local form_tvt = util_get_form(FORM_TVT_TIGUAN, false)
                    if not nx_is_valid(form_tvt) then
                        util_auto_show_hide_form(FORM_TVT_TIGUAN)
                        nx_pause(5)
                    else
                        if form_tvt.ani_connect.PlayMode ~= 0 then
                         
                            
                            -- if not IsPlayerHaveBuff("buf_pet_xiong_cd") then
                            --     if nx_function("find_buffer", client_player, "buf_riding_01") then -- Nếu đang trên ngựa thì cho nó xuống
                            --         nx_execute("custom_sender", "custom_remove_buffer", "buf_riding_01")
                            --     end
                            --     local game_visual = nx_value("game_visual")
                            --     if not nx_is_valid(game_visual) then
                            --         return
                            --     end
                            --     game_visual:CustomSend(nx_int(248), 1, nx_string("pet_panda_act3"), nx_number(1))
                            -- end
                            if client_player:QueryProp("HPRatio") < 100 and client_player:QueryProp("LogicState") ~= 102 then
                                if nx_function("find_buffer", client_player, "buf_riding_01") then -- Nếu đang trên ngựa thì cho nó xuống
                                    nx_execute("custom_sender", "custom_remove_buffer", "buf_riding_01")
                                end
                                local fight = nx_value("fight")
                                fight:TraceUseSkill("zs_default_01", false, false)

                            else
                                if client_player:QueryProp("MPRatio") < 100 and client_player:QueryProp("LogicState") ~= 102 then
                                    local fight = nx_value("fight")
                                    fight:TraceUseSkill("zs_default_01", false, false)
                                else
                                    if client_player:QueryProp("HPRatio") == 100 and client_player:QueryProp("MPRatio") == 100  then
                                        if client_player:FindProp("LogicState") and client_player:QueryProp("LogicState") == 102 then -- đầy máu rồi thì ngồi làm méo gì nữa ? =))
                                            local fight = nx_value("fight")
                                            fight:TraceUseSkill("zs_default_01", false, false)
                                        end

                                        local section_count = guan_ui_ini:GetSectionCount()
                                        for i = section_count, 1, -1 do
                                            local guan_id = guan_ui_ini:GetSectionByIndex(i - 1)
                                            local isopen = guan_ui_ini:ReadString(i - 1, "IsOpen", "1")
                                            local gui = nx_value("gui")
                                            if nx_number(isopen) ~= 0 and nx_number(guan_id) ~= 4 then
                                                local name_id = nx_string(guan_ui_ini:ReadString(i - 1, "Name", ""))
                                                local name = nx_function("ext_widestr_to_utf8", gui.TextManager:GetText(nx_string(name_id)))
                                                local guan_node = form_tvt.tree_guan.RootNode:FindNode(gui.TextManager:GetText(nx_string(name_id)))
                                                if nx_is_valid(guan_node) then
                                                    if nx_number(guan_node.entercount) < nx_number(guan_node.limitcount) then
                                                        if nx_number(guan_node.todaysucceed) < nx_number(guan_node.limitsucceed) then
                                                            local tiguan_id = GetTiguanId(guan_id)
                                                            if scene:QueryProp("Resource") ~= tiguan_id.mapid then
                                                                if form_tvt.switch == 1 then 
                                                                    game_visual:CustomSend(nx_int(874), nx_int(guan_id))
                                                                    local form_tvt = util_get_form(FORM_TVT_TIGUAN, false)
                                                                    if nx_is_valid(form_tvt) and form_tvt.Visible then
                                                                        nx_destroy(form_tvt)
                                                                    end
                                                                else
                                                                    if not is_busy() then
                                                                        if nx_find_custom(visual_player, "path_finding") then
                                                                            if not is_path_finding(visual_player) then
                                                                                nx_execute("hyperlink_manager", "find_path_npc_item", "findnpc_new," .. tiguan_id.mapid .. ",".. tiguan_id.npcid, 1)
                                                                            end
                                                                        else
                                                                            nx_execute("hyperlink_manager", "find_path_npc_item", "findnpc_new," .. tiguan_id.mapid .. ",".. tiguan_id.npcid, 1)
                                                                        end
                                                                    end
                                                                end
                                                            else
                                                                local boss_x, boss_y, boss_z = nil, nil, nil
                                                                local mgr = nx_value("SceneCreator")
                                                                if nx_is_valid(mgr) then
                                                                    local res = mgr:GetNpcPosition(tiguan_id.mapid, tiguan_id.npcid)
                                                                    if table.getn(res) >= 3 then
                                                                        boss_x, boss_y, boss_z = res[1],res[2],res[3]
                                                                    end 
                                                                end
                                                                if boss_z ~= nil then
                                                                    if distance3d(px,py,pz,boss_x,boss_y,boss_z) <= 3 then
                                                                        local form_tiguan_go = util_get_form("form_stage_main\\form_tiguan\\form_tiguan_go")
                                                                        if nx_is_valid(form_tiguan_go) and form_tiguan_go.Visible then
                                                                             nx_execute("form_stage_main\\form_tiguan\\form_tiguan_go", "on_btn_step_click", form_tiguan_go)
                                                                        else
                                                                            local form_tiguan_ready = util_get_form("form_stage_main\\form_tiguan\\form_tiguan_ready")
                                                                            if nx_is_valid(form_tiguan_ready) and form_tiguan_ready.Visible then
                                                                                nx_execute("form_stage_main\\form_tiguan\\form_tiguan_ready", "on_btn_ok_click", form_tiguan_ready)
                                                                            else
                                                                                local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
                                                                                if not form_talk.Visible then
                                                                                    local obj_list = scene:GetSceneObjList()
                                                                                    for i = 1, table.maxn(obj_list) do
                                                                                        local client_scene_obj = obj_list[i]
                                                                                        if client_scene_obj:FindProp("ConfigID") and client_scene_obj:QueryProp("ConfigID") == tiguan_id.npcid then
                                                                                            nx_execute("custom_sender", "custom_select", client_scene_obj.Ident)
                                                                                            nx_pause(0.5)
                                                                                            nx_execute("custom_sender", "custom_select", client_scene_obj.Ident)
                                                                                            break
                                                                                        end
                                                                                    end
                                                                                else
                                                                                    AutoExecMenu(nil, nil, 0)
                                                                                end
                                                                            end
                                                                        end
                                                                    else
                                                                        if form_tvt.switch == 1 then 
                                                                            game_visual:CustomSend(nx_int(874), nx_int(guan_id))
                                                                            local form_tvt = util_get_form(FORM_TVT_TIGUAN, false)
                                                                            if nx_is_valid(form_tvt) and form_tvt.Visible then
                                                                                nx_destroy(form_tvt)
                                                                            end
                                                                        else
                                                                            if not is_busy() then
                                                                                if nx_find_custom(visual_player, "path_finding") then
                                                                                    if not is_path_finding(visual_player) then
                                                                                        nx_execute("hyperlink_manager", "find_path_npc_item", "findnpc_new," .. tiguan_id.mapid .. ",".. tiguan_id.npcid, 1)
                                                                                    end
                                                                                else
                                                                                    nx_execute("hyperlink_manager", "find_path_npc_item", "findnpc_new," .. tiguan_id.mapid .. ",".. tiguan_id.npcid, 1)
                                                                                end
                                                                            end
                                                                        end
                                                                    end
                                                                else
                                                                    AutoSendMessage("Không thể tìm thấy tọa độ NPC !")
                                                                end
                                                            end
                                                            -- AutoSendMessage(guan_id..". "..name.."("..guan_node.todaysucceed.."/"..guan_node.limitsucceed..")".." - Limit enter: "..guan_node.entercount.."/"..guan_node.limitcount)
                                                            break
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        else
                            if nx_is_valid(form_tvt) then
                                util_auto_show_hide_form(FORM_TVT_TIGUAN)
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


function on_tiguan_init(form)
	form.Fixed = false
	form.current_boss = nil
	form.auto_start = false
	form.pick_str = ""
	form.string_list = nx_create("StringList")
end

function on_tiguan_open(self)
	self.combobox_tab_6.DropListBox:ClearString()
	AutoLoadPickupList(self)
end

function on_tiguan_close(form)
	
end


function on_btn_ok_click(btn)
	local form = btn.ParentForm
    AutoTiguan(form)
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

function TiguanClose ( form )
	util_auto_show_hide_form("auto\\auto_tiguan_today")
end