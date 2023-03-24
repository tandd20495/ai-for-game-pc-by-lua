function get_data()
	local map = get_current_map()
	--Đảo thanh hải 1
	if map == "scene16" then
		return {
			"tighenpc_07", -- Bạch Thuật
		}
	end
	--Kim Lăng
	if map == "city03" then
		return {
			"drug_1004npc01", -- Bạch Thuật
			"toxicant_1004npc01", -- Mã Thiền Tử
			"kuangshi_1004npc01" -- Ngân Khoáng
		}
	end
	-- Quân Tử Đường
	if map == "school03" then
		return {
			"kuangshi_1002npc01", -- Đồng khoáng
			"drug_1002npc01", -- Khổ Tình Hoa
			"toxicant_1002npc01" -- Đoạn Trường Hoa
		}
	end
		-- Nga My
	if map == "school06" then
		return {
			"kuangshi_1002npc01", -- Đồng khoáng
		}
	end
	-- Đường Môn
	if map == "school05" then
		return {
			"kuangshi_1002npc01", -- Đồng khoáng
		}
	end
	-- Tô Châu
	if map == "city02" then
		return {
			"kuangshi_1003npc01", -- Diên Khoáng
			"drug_1003npc01", -- Ngải Thảo
			"toxicant_1003npc01" -- Độc Nhất Vị
		}
	end
	-- Thiên Đăng Trấn
	if map == "born04" then
		return {
			"kuangshi_1001npc01" -- Thiết Khoáng
		}
	end
	-- Thành Đô
	if map == "city05" then
		return {
			"kuangshi_1001npc01", -- Thiết Khoáng
			"toxicant_1001npc01" -- Hồng Phấn Bạch Chu
		}
	end
	-- Cực Lạc Cốc
	if map == "school04" then
		return {
			"kuangshi_1002npc01" -- Đồng khoáng
		}
	end
	-- Võ Đang
	if map == "school07" then
		return {
			"kuangshi_1002npc01" -- Đồng khoáng
		}
	end
	-- Yến Kinh
	if map == "city01" then
		return {
			"kuangshi_1003npc01" -- Diên Khoáng
		}
	end
	-- Lạc Dương
	if map == "city04" then
		return {
			"drug_1001npc01" -- Bạc Hà
		}
	end
	-- Yên Vũ Trang
	if map == "born03" then
		return {
			"toxicant_1001npc01", -- Hồng Phấn Bạch Chu
			"drug_1001npc01",	-- Bạc Hà
			"kuangshi_1001npc01", --Thiết Khoáng
		}
	end
	-- Kê Minh Dịch
	if map == "born01" then
		return {
				"drug_1001npc01",	-- Bạc Hà
				"kuangshi_1001npc01", --Thiết Khoáng
				"toxicant_1001npc01",		
		}
	end
	-- Ác Nhân Cốc
	if map == "born02" then
		return {
			"drug_1001npc01",	-- Bạc Hà
			"kuangshi_1001npc01", --Thiết Khoáng
			"toxicant_1001npc01" -- Hồng Phấn Bạch Chu
		}
	end
		-- Hoang Mạc Bao La
	if map == "scene14" then
		return {
			"jh_sh_gathernpc_1012" -- Tùng Mộc
		}
	end
	-- Cái Bang
	if map == "school02" then
		return {
			"kuangshi_1002npc01" -- Đồng khoáng
		}
	end
	return false
end
function get_data_pos(id, as)
	local map = get_current_map()
	-- Thanh hải 1
	if map == "scene16" then
		-- long nha thảo
		if id == util_text("tighenpc_07") then
			return 
			{
				{x = 141.274944, y = 425.421997 , z = -162.677002},
				{x = 141.274944, y = 425.421997 , z = -162.677002},
			}
		end
	end
	-- Quân Tử Đường
	if map == "school03" then
		-- Đồng khoáng
		if id == util_text("kuangshi_1002npc01") then
			return {
				{x = 1198.326, y = 8.314, z = 1121.685},
				{x = 1202.574, y = 4.250, z = 962.572},
				{x = 1523.266, y = -0.599, z = 966.391}
			}
		end
		-- Khổ Tình Hoa
		if id == util_text("drug_1002npc01") then
			return {
				{x = 1123.718, y = 5.854, z = 1193.623},
				{x = 953.082, y = 4.958, z = 1230.600}
			}
		end
		-- Đoạn Trường Hoa
		if id == util_text("toxicant_1002npc01") then
			return {
				{x = 1185.801, y = 46.857, z = 184.128},
				{x = 1011.254, y = 72.033, z = 51.547}
			}
		end
	end
		-- Cái Bang
	if map == "school02" then
		-- Đồng khoáng
		if id == util_text("kuangshi_1002npc01") then
			if as == util_text("B1") then
			return {
				{x = 284.359985, y = 17.064264, z = 670.473999},
				{x = 292.169006, y = -6.123811, z = 581.526978},
				{x = 170.1759956, y = 22.983662, z = 647.908997},
				{x = 313.208, y = 48.236, z = 861.647},
				{x = 330.281006, y = 49.638428, z = 856.802002}
			}
			end

		end
		
	end
	---Kim Lăng
	if map == "city03" then
		-- Ngân Khoáng
		
		if id == util_text("kuangshi_1004npc01") then
			if as == util_text("B1") then
			return {
				{x = 1782.656006, y = 13.594021, z = 176.419006},
				{x = 1791.207031, y = 22.953415, z = 190.348999},
				{x = 1644.18103, y = 2.800036, z = 113.524002},
				{x = 1631.285034, y = 1.727633, z = 145.253006},
				{x = 1530.36499, y = 9.50058, z = 33.526001},
				{x = 1566.590942, y = 9.944057, z = 11.047},
				{x = 1167.859985, y = 2.662972, z = 115.495003}
			}
			end
			if as == util_text("B2") then -- Tâm sida viết
			return {
				{x = 713.075989, y = 17.028954, z = 393.888},
				{x = 766.021973, y = 30.218628, z = 455.6690006},
				{x = 879.781982, y = 19.420984, z = 239.520004}
			}
			end
		end
		-- Bạch Thuật
		if id == util_text("drug_1004npc01") then
			return {
				{x = 976.707, y = 9.374, z = 2064.413}
			}
		end
		-- Mã Thiền Tử
		if id == util_text("toxicant_1004npc01") then
			return {
				{x = 1854.105, y = 1.394, z = 1829.869},
				{x = 1612.138, y = 10.529, z = 2121.125}
			}
		end
	end
	-- Đường Môn
	if map == "school05" then
		-- Đồng khoáng
		if id == util_text("kuangshi_1002npc01") then
			if as == util_text("B1") then
			return {
				{x = 610.244, y = 20.523, z = 618.751},
				{x = 503.201, y = -12.361, z = 622.314},
				{x = 516.398, y = 44.497, z = 772.539}
			}
			end
			if as == util_text("B2") then
			return {
				{x = 798.004028, y = -1.459381, z = 281.334991},
				{x = 801.594971, y = 29.778292, z = 614.268982},
			}
			end
			
		end
	end
	-- Tô Châu
	if map == "city02" then
		-- Diên khoáng
		if id == util_text("kuangshi_1003npc01") then
			if as == util_text("B1") then
			return {
				{x = 1734.842, y = 5.576, z = 327.667},
				{x = 1651.532, y = 2.233, z = 477.975},
				{x = 1758.140, y = 2.605, z = 759.232}
			}
			end
			if as == util_text("B2") then
			return {
				{x = 1184.630005, y = 18.65867, z = 1235.979004},
				{x = 1243.961, y = 0.361, z = 976.000},
				{x = 1302.343994, y = 6.265267, z = 980.075989}
			}
			end
		-- Ngải Thảo
		if id == util_text("drug_1003npc01") then
			return {
				{x = 547.365, y = -0.436, z = 875.354},
				{x = 237.859, y = 5.180, z = 878.576}
			}
		end
		-- Độc Nhất Vị
		if id == util_text("toxicant_1003npc01") then
			return {
				{x = 1499.334, y = 1.721, z = 443.073},
				{x = 1880.605, y = 24.153, z = 416.679}
			}
		end
		end
	end
	-- Thiên Đăng Trấn
	if map == "born04" then
		-- Thiết khoáng
		if id == util_text("kuangshi_1001npc01") then
			return {
				{x = 646.675, y = -43.181, z = 908.064},
				{x = 702.477, y = -36.092, z = 897.055},
				{x = 777.764, y = -31.803, z = 917.164}
			}
		end
	end
	-- Thành Đô
	if map == "city05" then
		-- Thiết khoáng
		if id == util_text("kuangshi_1001npc01") then
			return {
				{x = 484.545, y = 16.364, z = 996.176},
				{x = 735.914, y = 43.820, z = 1180.685}				
			}
		end
		-- Hồng Phấn Bạch Chu
		if id == util_text("toxicant_1001npc01") then
			return {
				{x = 264.100, y = 26.639, z = 543.837},
				{x = 244.386, y = 36.511, z = 654.556}				
			}
		end
	end
	-- Cực Lạc Cốc
	if map == "school04" then
		-- Đồng khoáng
		if id == util_text("kuangshi_1002npc01") then
			if as == util_text("B1") then
			return {
				{x = 872.036, y = 14.495, z = 300.579},
				{x = 810.543, y = 19.083, z = 465.835}
			}
			end
			if as == util_text("B2") then
			return {
				{x = 924.06897, y = 17.383715, z = 812.770996},
				{x = 640.859985, y = 4.889003, z = 950.070984},
				{x = 298.705994, y = 24.568701, z = 696.187988},
				{x = 470.654999, y = 8.052087, z = 563.072021},
			}
			end
			
		end
	end
	-- Yến Kinh
	if map == "city01" then
		-- Diên khoáng
		if id == util_text("kuangshi_1003npc01") then
			if as == util_text("B1") then
			return {
				{x = 1020.328, y = -76.435, z = 196.159},
				{x = 992.636, y = -71.380, z = -309.893}
			}
			end
			if as == util_text("B2") then
			return {
				{x = 1358.312988, y = -72.045219, z = 1609.141968},
				{x = 1253.307007, y =  -101.143547, z = 1308.266968},
				{x = 1087.28894, y =   -79.068657, z = 954.111023},
				{x = 1523.78894, y =   -75.374718, z = 978.745972},
			}
			end
		end
	end
	-- Nga My
	if map == "school06" then
		-- Đồng khoáng
		if id == util_text("kuangshi_1002npc01") then
			return {
				{x = 412.114, y = -7.435, z = 920.399},
				{x = 342.491, y = 15.958, z = 859.062},
				{x = 158.676, y = 0.705, z = 762.064}
			}
		end
	end
	-- Võ Đang
	if map == "school07" then
		-- Đồng khoáng
		if id == util_text("kuangshi_1002npc01") then
			if as == util_text("B1") then
			return {
				{x = 175.621, y = 16.550, z = 321.110},
				{x = 24.396, y = 28.483, z = 164.450},
				{x = -23.104, y = 39.803, z = 67.657}
			}
			end
			if as == util_text("B2") then
			return {
				{x = 824.859009, y = -4.268806, z = 571.627991},
				{x = 971.021973, y = 4.836304, z = 365.381989},
				{x = 1203.280029, y = -13.958677, z = 421.850006}
			}
			end
			if as == util_text("B3") then
			return {
				{x = 456.444, y = 3.441508, z = 1124.468018},
				{x = 262.868988, y = 32.037598, z = 1113.807983},
			}
			end
		end
	end
	-- Lạc Dương
	if map == "city04" then
		-- Bạc Hà
		if id == util_text("drug_1001npc01") then
			return {
				{x = 662.991, y = -19.687, z = 1150.124},
				{x = 809.397, y = -21.638, z = 1173.984},
				{x = 965.856, y = -13.374, z = 1190.551}
			}
		end
	end
	-- Kê Minh Dịch
	if map == "born01" then
		-- Bạc Hà
		if id == util_text("drug_1001npc01") then
			if as == util_text("B1") then
			return {
				{x = 924.019, y = 4.552, z = 222.297},
				{x = 948.336, y = 9.878, z = 99.335},
				{x = 1076.035, y = 43.566, z = 224.550}
			}
			end
			if as == util_text("B2") then
			return {
				{x = 399.868988, y = 1.511701, z = 318.042999},
				{x = 249.399002, y = 31.528879, z = 399.421997},
				{x = 73.889, y = 130.419464, z = 521.080017}
			}
			end
			if as == util_text("B3") then
			return {
				{x = -65.556999, y = 131.326462, z = 891.281006},
				{x = -125.75099, y = 172.987885, z = 689.567017}
			}
			end
		end
		if	id == util_text("kuangshi_1001npc01") then -- Thiết Khoáng
			if as == util_text("B1") then
			return {
				{x = 115.599998, y = 128.412872, z = 844.781982},
				{x = -72.524002, y = 139.289261, z = 652.057983},
				{x = -120.862999, y = 137.583725, z = 824.299988}
			}
			end
			if as == util_text("B2") then
						return {
				{x = 423.699005, y = 14.354462, z = 469.769012},
				{x = 220.992996, y = 0.904234, z = 185.944},
				{x = 78.413002, y = 131.670853, z = 411.296997}
			}
			end
			if as == util_text("B3") then
						return {
				{x = 423.699005, y = 14.354462, z = 469.769012},
				{x = 220.992996, y = 0.904234, z = 185.944},
				{x = 78.413002, y = 131.670853, z = 411.296997}
			}
			end
		end
		if	id == util_text("toxicant_1001npc01") then -- Hồng Phấn Bạch Chu
			if as == util_text("B1") then
			return {
				{x = 394.471008, y = 1.032688, z = 286.559998},
				{x = 201.389999, y = 70.764748, z = 471.052002},
				{x = 286.191986, y = 45.044643, z = 519.072021},
				{x = 249.233994, y = 105.891205, z = 690.807983}
			}
			end
			if as == util_text("B2") then
			return {
				{x = 1015.429016, y = 18.454231, z = 75.023003},
				{x = 957.867981, y = 4.446818, z = 287.058014},
			}
			end
		end
	end
	-- Yên Vũ Trang
	if map == "born03" then
		-- Hồng Phấn Bạch Chu
		if id == util_text("toxicant_1001npc01") then
			return {
				{x = 243.231, y = 48.496, z = 752.263},
				{x = 365.116, y = 40.909, z = 526.638},
				{x = 376.404, y = 78.971, z = 337.465}
			}
		end
		if	id == util_text("kuangshi_1001npc01") then -- Thiết Khoáng
			if as == util_text("B1") then
			return {
				{x = 644.182983, y = 96.9077, z = 471.53299},
				{x = 1112.982056, y = 81.755165, z = 570.317017},
				{x = 1068.13501, y = 78.925087, z = 342.04599}
			}
			end
			if as == util_text("B2") then
			return {
				{x = 723.914978, y = 127.800827, z = 74.638},
				{x = 503.796997, y = 157.43248, z = 177.524002},
				{x = 398.934998, y = 118.848595, z = 261.717987}
			}
			end
			if as == util_text("B3") then
						return {
				{x = 398.934998, y = 118.848595, z = 261.717987},
				{x = 260.462006, y = 137.312927, z = 123.296997},
				{x = 168.817993, y = 134.392258, z = 99.945999}
			}
			end
		end
		if id == util_text("drug_1001npc01") then
			return {
				{x = 242.266006, y = 163.750763, z = 434.653992},
				{x = 16.865, y = 93.753189, z = 571.153992},
			}
		end
	end
	-- Ác Nhân Cốc
	if map == "born02" then
			-- Bạc Hà
		if id == util_text("drug_1001npc01") then
			if as == util_text("B1") then
			return {
				{x = 412.053986, y = 4.105547, z = 248.953995},
				{x = 243.078995, y = 7.113964, z = 342.459015},
				{x = 110.113998, y = 12.268224, z = 422.766998}
			}
			end
			if as == util_text("B2") then
			return {
				{x = -200.979996, y = 3.090832, z = 524.249023},
				{x = -216.160995, y = -0.2786, z = 678.846008},
				{x = -611.794983, y = 20.348934, z = 716.383972},
			}
			end
			if as == util_text("B3") then
			return {
				{x = -93.866997, y = -3.57508, z = 17.965},
				{x = 25.379999, y = -3.000679, z = 92.82},
				{x = 217.621002, y = 6.521861, z = 52.529999}
			}
			end
		end
		-- Hồng Phấn Bạch Chu
		if id == util_text("toxicant_1001npc01") then
			if as == util_text("B1") then
			return {
				{x = 354.198, y = 10.057, z = 367.405},
				{x = 144.040, y = 5.976, z = 360.593},
				{x = 21.912, y = 4.566, z = 421.569}
			}
			end
			if as == util_text("B2") then
			return {
				{x = 394.817993, y = 10.672659, z = 452.03299},
				{x = 525.562988, y = 3.407488, z = 811.721008},
				{x = 176.322998, y = 29.652817, z = 777.867981}
			}
			end
			
		end
		if	id == util_text("kuangshi_1001npc01") then -- Thiết Khoáng
			if as == util_text("B1") then
			return {
				{x = -151.822006, y = 3.523445, z = 707.809998},
				{x = -73.991997, y = -0.303163, z = 544.189026},
				{x = -74.833, y = -1.324733, z = 421.483002}
			}
			end
			if as == util_text("B2") then
			return {
				{x = 183.785995, y = 8.447066, z = 413.356995},
				{x = 455.347992, y = 1.57416, z = 408.730988},
				{x = 428.279999, y = 21.818157, z = 581.322021},
				{x = 491.294006, y = 16.066301, z = 607.357971}
			}
			end
			
		end
	end
	return false
end
function get_data2()
	return {
	"B1", 
	"B2", 
	"B3", 
	"B4",
	"B5",
	"B6",
	}
end