-- Show/Hide for grocery of admin yBreaker
function show_hide_grocery()

	local form_shop = nx_value("form_stage_main\\form_shop\\form_shop")
	
    if nx_is_valid(form_shop) then
		nx_execute("custom_sender", "custom_open_mount_shop", 0)
    else
		nx_execute("custom_sender", "custom_open_mount_shop", 1)
    end
end
-- Exceute function 
-- Call function by event of xml
--show_hide_grocery()
