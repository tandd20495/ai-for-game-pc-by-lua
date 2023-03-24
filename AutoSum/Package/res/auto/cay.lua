local file = assert(loadfile(nx_resource_path() .. "auto\\autoCreate\\so_nhap.lua"))
local so_nhap = file()

local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\multiple.lua"))
multiple = file()

local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\thanhanh.lua"))
file()




function story(isStarted)

local step =0
local targetboss=nil

while isStarted() do
  nx_pause(0.5)
  nx_execute("form_stage_main\\form_helper\\form_main_helper_manager" , "close_helper_form")
   

if step == 0 then

				local tran_nhan_id = "WorldNpc100025"
			if getNpcById(tran_nhan_id) ~= nil then
		 step = 1
			else
			add_chat_info("Dang Tra Cay")
			tools_move("city05", 298.002, 78.077, 854.825, true)
			end
		elseif step == 1 then
		    
				local tran_nhan_id = "WorldNpc100025"
			if getNpcById(tran_nhan_id) ~= nil then
			talk(tran_nhan_id, {0,0}, isStarted)
			step = 2
			end
		
		elseif step == 2 then
			    add_chat_info("Xong")
			break
		end


end
end




function joinschool_isStarted()
return auto_so_nhap_bat_phai
end

function joinschool()
if not joinschool_isStarted() then
  auto_so_nhap_bat_phai = true

  add_chat_info("Start Join School for all accounts")
  function run_story()

    story(joinschool_isStarted)
  end
  run_story()

  auto_so_nhap_bat_phai = false
else
  add_chat_info("Stop joining school")
  auto_so_nhap_bat_phai = false
end
end
joinschool()

