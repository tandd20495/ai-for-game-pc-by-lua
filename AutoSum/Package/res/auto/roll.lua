local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\thanhanh.lua"))
file()
function rollPickItem()
if not test then
		test = true
		add_chat_info("Bat dau")
		while test == true do
		
    local has_item = false
	  nx_pause(0.05)
    for i = 0, 2 do
        local FORM_DICE = "form_stage_main\\form_dice"
        local form = nx_value(FORM_DICE .. nx_string(i))
        if nx_is_valid(form) then
            has_item = true
            if form.item then
                nx_execute("form_stage_main\\form_dice", "return_choice", form, 2) --lac
            end
        end
    end   
	end
	else
		test = false
		add_chat_info("Ket Thuc")
	end
end
	

rollPickItem()


