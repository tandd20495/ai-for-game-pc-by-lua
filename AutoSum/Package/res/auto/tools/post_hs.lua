
function ____post_hs_isStarted()
  return ___is_auto_post_hoa_son
end

function ___post_hs(params)
  if not ___is_auto_post_hoa_son then
    ___is_auto_post_hoa_son = true
    add_chat_info("Start POST HS")
    local from = params[1]
    local to = params[2]
    local server = params[3] or ""

    local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\multiple.lua"))
    multiple = file()

    
		local file = assert(loadfile(nx_resource_path() .. "auto\\accounts\\qtd"..server..".lua"))
		local accounts = file()
		accounts = table.slice(accounts, from, to)
		local file = assert(loadfile(nx_resource_path() .. "auto\\autoCreate\\story_hs1.lua"))
		local story = file()

		function run_story()
			story(____post_hs_isStarted)
		end
    multiple(run_story, accounts, ____post_hs_isStarted)
    add_chat_info("DONE POST HS")
    ___is_auto_post_hoa_son = false
  else
    add_chat_info("STOP POST HS")
    ___is_auto_post_hoa_son = false
  end
end

return ___post_hs