function on_click_hyperlink(self, szLinkData)
  add_map_label_by_hyerlink(szLinkData)
  find_path_npc_item(szLinkData, true)

  if nx_function("ext_ws_find", szLinkData, nx_widestr("findpath")) >= 0 then
    nx_execute("admin_zdn\\zdn_logic_base", "RideZdnConfigMount")
  elseif nx_function("ext_ws_find", szLinkData, nx_widestr("findnpc_new")) >= 0 then
    nx_execute("admin_zdn\\zdn_logic_base", "RideZdnConfigMount")
  elseif nx_function("ext_ws_find", szLinkData, nx_widestr("findnpc")) >= 0 then
    nx_execute("admin_zdn\\zdn_logic_base", "RideZdnConfigMount")
  end
end
