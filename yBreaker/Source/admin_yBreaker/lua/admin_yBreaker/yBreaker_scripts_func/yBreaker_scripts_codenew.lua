require("const_define")
require("util_gui")
require("util_move")
require("util_functions")
require("share\\server_custom_define")
require("define\\sysinfo_define")
require("share\\chat_define")
require("define\\request_type")
require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")

-- Test code for new function of admin yBreaker
function new_function_admin_yBreaker()
	--yBreaker_show_notice(util_text("Test load file from yBreaker\\scripts\\codenew.lua"))
	local file = assert(loadfile(nx_resource_path().."yBreaker\\scripts\\codenew.lua"))
	file()
end
