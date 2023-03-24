function create_dynamic_form(formname, instance_id, ansynload)
  if formname == nil or string.len(formname) == 0 then
    return
  end
  local form, formname_instance
  if instance_id and instance_id ~= "" then
    formname_instance = formname .. nx_string(instance_id)
  else
    formname_instance = formname
  end
  if ansynload == nil then
    ansynload = false
  elseif ansynload ~= true then
    ansynload = false
  end
  local form = nx_value(formname_instance)
  if not nx_is_valid(form) then
    local gui = nx_value("gui")
    if not nx_is_valid(gui) or not nx_is_valid(gui.Loader) then
      return nx_null()
    end
    if ansynload then
      form = gui.Loader:LoadFormAsync(nx_resource_path(), "auto\\forms\\" .. formname .. ".xml")
    else
      form = gui.Loader:LoadForm(nx_resource_path(), "auto\\forms\\" .. formname .. ".xml")
    end
    if not nx_is_valid(form) then
      local error_text = nx_widestr(util_text("msg_CreateFormFailed - ")) .. nx_widestr("auto\\forms\\") .. nx_widestr(formname) .. nx_widestr(".xml")
      nx_msgbox(nx_string(error_text))
      return 0
    end
    form.Name = formname
    if instance_id then
      form.instance_id = instance_id
    end
    nx_set_value(formname_instance, form)
    local switchmgr = nx_value("SwitchManager")
    if nx_is_valid(switchmgr) then
      switchmgr:CheckFormItemVis(formname_instance)
    end
    if nx_is_valid(form) then
    end
    form.Visible = false
    return form, formname_instance
  end
  if nx_is_valid(form) then
  end
  return form, formname_instance
end

function show_dynamic_form(form)
  -- form.item = item
  -- form.item_info = item_info
  -- form.amount = amount
  -- form.wait_time = wait_time
  -- form.pos = pos
  -- form.Left = (gui.Width - form.Width) / 4
  -- form.Top = gui.Height / 1.5 - form.Height * pos
  form:Show()
end