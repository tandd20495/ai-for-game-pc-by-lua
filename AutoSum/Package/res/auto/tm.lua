

function tm()
	if not test then
		test = true
		
		while test == true do
		
nx_value("game_visual"):CustomSend(nx_int(1003),nx_int(0), nx_int(0))
  nx_pause(0.05)

		end
	else
		test = false
		
	end
end

tm()