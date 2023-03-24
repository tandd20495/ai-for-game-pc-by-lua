local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\thanhanh.lua"))
file()
function getitem()
	local item = {}
	local game_client = nx_value("game_client")
	local client_player = game_client:GetPlayer()
	if nx_is_valid(client_player) then
		local scene = game_client:GetScene()
		local view_table = game_client:GetViewList()
		for i = 1, table.getn(view_table) do
			local view = view_table[i]
			if view.Ident == nx_string("121")  then
    			local view_obj_table = view:GetViewObjList()
    			for k = 1, table.getn(view_obj_table) do
     				local view_obj = view_obj_table[k]
					
     				item[#item+1] = view_obj:QueryProp("ConfigID")
					--add_chat_info(item[#item])
					--add_chat_info("ident"..view.Ident)
     			end
				end
		end
	end
	return item
end

function rollPickItem()
if  test then
		test = true
		add_chat_info("Bat dau")
		if not query_task_done_single(20996) then
			add_chat_info("chua xong")
			test = false
			else 
			add_chat_info("xong")
		end
		end
	--local item = getitem()
	
	
		--for r = 1, table.getn(item) do
		--	add_chat_info(item[r])
		--end
--nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", "Item_xdm_shaqi_001")
	--else
		--test = false
	--	add_chat_info("Ket Thuc")
	--end
end
	

rollPickItem()


