function ___xoa_thu_isStarted()
  return xoa_thu_bool
end

if not ___xoa_thu_isStarted() then
  xoa_thu_bool = true
  add_chat_info("Bat dau xoa thu")
  while ___xoa_thu_isStarted() do
    nx_pause(0)
    --xoa_thu_rong()
    xoa_thu_by_items({"faculty_yanwu_jhdw06", "pingzheng_escort_001"})
  end
else 
  xoa_thu_bool = false
  add_chat_info("Dung xoa thu")
end