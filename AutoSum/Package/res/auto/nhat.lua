local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\thanhanh.lua"))
file()
function rollPickItem()
if not test then
		test = true
		add_chat_info("Bat dau")
		while test == true do
		
nx_pause(0.5)
														local form_giveitems = util_get_form("form_stage_main\\form_give_item", true)
														if nx_is_valid(form_giveitems) then
															local form_giveitems1 = nx_value("form_stage_main\\form_give_item")
															if nx_is_valid(form_giveitems1) then
																--nx_execute("form_stage_main\\form_give_item", "on_btn_mail_click", form_giveitems1.btn_mail)
																nx_execute("form_stage_main\\form_give_item", "on_btn_close_click", form_giveitems1.btn_close)
															end
														end
	end
	else
		test = false
		add_chat_info("Ket Thuc")
	end
end
	

rollPickItem()


