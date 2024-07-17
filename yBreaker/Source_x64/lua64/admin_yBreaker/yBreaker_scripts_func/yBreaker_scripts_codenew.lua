require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")

-- Test code for new function of admin yBreaker
function new_function_admin_yBreaker()
	local file = assert(loadfile(nx_resource_path().."yBreaker\\scripts\\codenew.lua"))
	file()
end
