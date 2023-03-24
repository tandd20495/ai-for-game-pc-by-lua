--[ Đổi kinh mạch nhanh--]
require("form_stage_main\\form_wuxue\\form_wuxue_util")
require("share\\itemtype_define")
local SUB_CLIENT_SET_JINGMAI = 1
local SUB_CLIENT_ACTIVE_JINGMAI = 1
local SUB_CLIENT_CLOSE_JINGMAI = 2

-- Define jingmai - Kinh Mạch
local mach_nm = "jm_shoutaiyin"
local mach_ttc = "jm_shoutaiyin_ni"
local mach_clc = "jm_shoushaoyang"
local mach_nt = "jm_shoushaoyang_ni"
local mach_cb = "jm_shoutaiyang"
local mach_tptc = "jm_shoutaiyang_ni"
local mach_vd = "jm_zushaoyin"
local mach_cm = "jm_zushaoyin_ni"
local mach_qtd = "jm_zujueyin"
local mach_hs = "jm_zujueyin_ni"
local mach_dm  = "jm_zutaiyin"
local mach_nlb  = "jm_zutaiyin_ni"
local mach_cyv = "jm_zushaoyang"
local mach_hdm = "jm_zushaoyang_ni"
local mach_tl = "jm_zuyangming"
local mach_mg = "jm_shouyangming"
local mach_tcd = "jm_shouyangming_ni"
local mach_ts = "jm_zutaiyang"
local mach_tmc = "jm_zutaiyang_ni"
local mach_dat_ma = "jm_zuyangming_ni"
local mach_am_khieu = "jm_yinqiao"
local mach_duong_khieu = "jm_yangqiao"
local mach_am_duy = "jm_yinwei"
local mach_duong_duy = "jm_yangwei"
local tu_khi = "jm_dantian"



local all_mach = {
	mach_nm,
	mach_ttc,
	mach_clc,
	mach_nt,
	mach_cb,
	mach_tptc,
	mach_vd,
	mach_cm,
	mach_qtd,
	mach_hs,
	mach_dm,
	mach_nlb,
	mach_cyv,
	mach_hdm,
	mach_tl,
	mach_dat_ma,
	mach_mg,
	mach_tcd,
	mach_ts,
	mach_tmc,
	mach_am_khieu,
	mach_duong_khieu,
	mach_am_duy,
	mach_duong_duy,
	tu_khi
}

-- Mạch Nội 6 bỏ qua + 2 GH
local mach_noi_full_bo_qua = {
	mach_nm,
	mach_ttc,
	mach_clc,
	mach_nt,
	mach_tptc,
	mach_qtd,
	mach_am_khieu,
	mach_duong_khieu,
}

-- Mạch Nội 5 bỏ qua + CYV + 2GH
local mach_noi_damage_cyv = {
	mach_cyv,
	mach_ttc,
	mach_clc,
	mach_nt,
	mach_tptc,
	mach_qtd,
	mach_am_khieu,
	mach_duong_khieu,
}

-- Mạch Ngoại Full STBK
local mach_ngoai_stbk = {
	mach_cb,
	mach_hs,
	mach_dm,
	mach_nlb,
	mach_hdm,
	mach_tcd,
	mach_am_khieu,
	mach_duong_khieu,
}

-- Mạch Ngoại Full Thủ
local mach_ngoai_normal = {
	mach_cb,
	mach_hs,
	mach_dat_ma,
	mach_nlb,
	mach_hdm,
	mach_tcd,
	mach_am_khieu,
	mach_duong_khieu,
}

function active_mach(id)
	nx_execute("custom_sender", "custom_jingmai_msg", SUB_CLIENT_ACTIVE_JINGMAI, id)
end

function remove_mach(id)
	nx_execute("custom_sender", "custom_jingmai_msg", SUB_CLIENT_CLOSE_JINGMAI, id)
end

function remove_all_mach()
	for i = 1, table.getn(all_mach) do
		remove_mach(all_mach[i])
	end
end

function dung_mach(listMach)
	for i = 1, table.getn(listMach) do
		active_mach(listMach[i])
	end
end

function chinh_tu_mach(jingmai_id)
	local wuxue_query = nx_value("WuXueQuery")
  local jingmai = wuxue_query:GetLearnID_JingMai(jingmai_id)
  if nx_is_valid(jingmai) and not check_wuxue_is_maxlevel(jingmai, WUXUE_JINGMAI) then
		nx_execute("custom_sender", "custom_jingmai_wuji_msg", SUB_CLIENT_SET_JINGMAI, jingmai_id)
  end
end

function mach_is_max(id)
	local wuxue_query = nx_value("WuXueQuery")
	local jingmai = wuxue_query:GetLearnID_JingMai(id)
	return check_wuxue_is_maxlevel(jingmai, WUXUE_JINGMAI)
end

function query_mach_info(id)
	local game_client = nx_value("game_client")
	local view = game_client:GetView(nx_string(45))
	local viewobj_list = view:GetViewObjList()
	for index, mach in pairs(viewobj_list) do
		if mach:QueryProp("ConfigID") == id then
			return {
				["Level"] = mach:QueryProp("Level"),
				["MaxLevel"] = mach:QueryProp("MaxLevel"),
				["TotalFillValue"] = mach:QueryProp("TotalFillValue"),
				["CurFillValue"] = mach:QueryProp("CurFillValue")
			}
		end
	end
end

function ___mach(name)
	remove_all_mach()
	if name == "noi" then
		dung_mach(mach_noi)
	elseif name == "noidi" then
		dung_mach(mach_noi_di)
	elseif name == "ngoai" then
		dung_mach(mach_ngoai)
	end
end

query_mach_info(mach_tmc)
--dung_mach(mach_ngoai_normal)
--___mach()
--active_mach("jm_shouyangming_ni")
 --remove_all_mach()
-- chinh_tu_mach(mach_nm)

