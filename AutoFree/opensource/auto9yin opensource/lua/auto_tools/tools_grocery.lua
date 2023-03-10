function auto_init()
	local form_shop = nx_value("form_stage_main\\form_shop\\form_shop")
	local FORM_RECLAIM = nx_value("form_stage_main\\form_life\\form_reclaim")
    if nx_is_valid(form_shop) then
		nx_execute("custom_sender", "custom_open_mount_shop", 0)
		FORM_RECLAIM:Close()
    else
		nx_execute("custom_sender", "custom_open_mount_shop", 1)
		nx_execute("form_stage_main\\form_life\\form_reclaim", "open_form", nx_int(65))
    end

end
