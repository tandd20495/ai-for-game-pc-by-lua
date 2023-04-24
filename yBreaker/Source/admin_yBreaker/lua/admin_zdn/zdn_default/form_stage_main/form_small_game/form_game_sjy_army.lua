function handle_fall_element(form, btn_ele)
    if not nx_is_valid(btn_ele) then
      return
    end
    if not nx_is_valid(form) then
      return
    end
    if btn_ele.Top >= form.groupbox_main.Height then
      btn_ele.status = ELE_DEAD
      return
    end
    local y_percent = (btn_ele.Top + btn_ele.Height) / form.groupbox_main.Height
    local fall_pixel = calc_fall_speed(btn_ele.speed, y_percent)
    fall_pixel = math.max(fall_pixel, 1)
    btn_ele.Top = btn_ele.Top + fall_pixel
    on_btn_ele_click(btn_ele)
  end
