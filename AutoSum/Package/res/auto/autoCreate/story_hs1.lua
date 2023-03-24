-- tu 14 ve sau
function story_hs2(isStarted)
	local step = 1 
	while isStarted() do
		nx_pause(1)
		add_chat_info("Step: " ..step)
		local form = util_get_form("form_stage_main\\form_movie_new", false, false)
		if nx_is_valid(form) then
			nx_execute("form_stage_main\\form_movie_new", "on_btn_end_click", form.btn_end)
		end
		do_confirm()
		if step == 1 then
			local pos = {1427.935,175.339,689.583,-1.842}
			local npc = "npc_hsp_001"
			den_pos(pos, isStarted)
			talk(npc, {0}, isStarted)
			step = 2
		elseif step == 2 then
			-- close form
			step = 3
		elseif step == 3 then
			local pos = {1472.567,171.627,713.034,-0.249}
			local npc = "npc_hsp_cc_008"
			while isStarted() and not arrived(pos, 3) do
				nx_pause(0)
				move(pos, 3)
			end
			if arrived(pos, 3) then
				talk(npc, {1}, isStarted)
				talk(npc, {0, 0}, isStarted)
				step = 4
			end
		end

		if step == 4 then
			break
		end
	end
end

return story_hs2