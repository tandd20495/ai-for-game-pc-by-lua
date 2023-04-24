function add_form(notice_type, tvt_type)
    if tvt_type == 55 or tvt_type == 99 then
        return
    end
    local TVT_TYPE_SCHOOL_DANCE = 31
    local FORM = "form_stage_main\\form_main\\form_notice_shortcut"
    local form = nx_value(FORM)
    if not nx_is_valid(form) then
      return
    end
    local single_notice_str = form.single_notice
    local common_notice_str = form.common_notice
    if notice_type == 0 then
      if string.find(common_notice_str, "," .. nx_string(tvt_type) .. ",") then
        return
      end
      form.common_notice = form.common_notice .. nx_string(tvt_type) .. ","
    else
      if string.find(single_notice_str, "," .. nx_string(tvt_type) .. ",") then
        return
      end
      if tvt_type == TVT_TYPE_SCHOOL_DANCE then
        return
      end
      form.single_notice = form.single_notice .. nx_string(tvt_type) .. ","
    end
    refresh_form_size()
  end