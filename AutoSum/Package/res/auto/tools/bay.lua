
function ____bay_den_isStarted()
	return __auto_bay_den_bool
end

function ____thanhanh_bay_ben(points, distance)
  distance = distance or 50
	if not __auto_bay_den_bool then
    __auto_bay_den_bool = true
    points = util_split_string(points, ",")
    local current_point = 1
    while ____bay_den_isStarted() and current_point <= table.getn(points) do
      nx_pause(0)
      SendNotice("Đang nhảy đến điểm thứ " ..current_point, 1)
      local point = util_split_string(points[current_point], ".")
      thanhanh_bay_ben({point[1], 0, point[2]}, distance, ____bay_den_isStarted)
      current_point = current_point + 1
    end
    add_chat_info("Chuyến bay đã hạ cánh an toàn")
		__auto_bay_den_bool = false
	else
		__auto_bay_den_bool = false
	end
end

return ____thanhanh_bay_ben

--{608.306,7.312,645.803,1.345}