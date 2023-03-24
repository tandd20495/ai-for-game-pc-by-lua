function ____auto_nhan_thu_started()
  return ____auto_nhan_thu_started_bool
end

local hs_lenh = "item_hsp_exchange01"
local minh_linh_dan = "faculty_yanwu_jhdw06"
local ngu_uan = "item_exchange_xm_mark" 
local the_thoi_trang = "haiwai_box_pingzheng_001"
local co_pho = "cjbook_CS_"
local tan_quyen = "ng_cjbook_jh_"
local hnp = "equip_tihuan_601"
local khiep_khach_lenh = "tiguan_ward_item_01"
local hd_lenh = "Item_xdm_exchange01"
local dao_quan = "item_xdm_dy_xgdh"
local mang_dong = "cropper_40020"
local duoc_kim_cham = "item_wgm_"
local duoc_lt = "item_jzsj_sh_"
local mang_xao_ruou = "caiyao10030"
local da_ngu_sac = "item_nlb_exchange01"
local Hop_da_ngu_sac = "Box_nlb_taskprize_4"
local bo_de_tu = "item_dmp_ptz"
function rut_qua(id, bag)
  add_chat_info("Đang nhận thư")
  -- rut_va_xoa_mail(ngu_uan, 125)
  -- rut_va_xoa_mail(the_thoi_trang, 2)
  -- rut_va_xoa_mail(hnp, 123)
  -- rut_va_xoa_mail(co_pho, 123)
  -- rut_va_xoa_mail(tan_quyen, 123)
  -- rut_va_xoa_mail(khiep_khach_lenh, 2)
  -- rut_va_xoa_mail(hs_lenh, 125)
  -- rut_va_xoa_mail(hd_lenh, 125)
  -- rut_va_xoa_mail(dao_quan, 125)
  --rut_va_xoa_mail(id, bag)
  rut_va_xoa_mail(Hop_da_ngu_sac, 2)
end

local items = {
  -- khiep_khach_lenh
  -- hs_lenh,
  --hd_lenh,
  --dao_quan
  --da_ngu_sac
  --bo_de_tu
  Hop_da_ngu_sac
}

local bagTypes = {
  2,
  --125,
  --125,
  --125,
  -- 2
  --125
}

local checkNumbers = {
  --0,
  --10,
  3,
  --10
}
function getitem()
	local item = {}
	local game_client = nx_value("game_client")
	local client_player = game_client:GetPlayer()
	if nx_is_valid(client_player) then
		local scene = game_client:GetScene()
		local view_table = game_client:GetViewList()
		for i = 1, table.getn(view_table) do
			local view = view_table[i]
			if view.Ident == nx_string("2")   then
    			local view_obj_table = view:GetViewObjList()
    			for k = 1, table.getn(view_obj_table) do
     				local view_obj = view_obj_table[k]
     				item[#item+1] = view_obj:QueryProp("ConfigID")
     			end
			end
		end
	end
	return item
end


local pass  ="123123"
if not ____auto_nhan_thu_started_bool then
  add_chat_info("Bắt đầu nhận thư")
  
 

	
   nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", "box_hsp_wxjz_luh_01")
  ____auto_nhan_thu_started_bool = false
else
  add_chat_info("Dừng nhận thư")
  ____auto_nhan_thu_started_bool = false
end

