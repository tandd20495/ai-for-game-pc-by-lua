function update_game(current_pos, current_pro)
    local form = nx_value("form_stage_main\\form_small_game\\form_game_rope_swing")
    if not nx_is_valid(form) then
        return
    end
    if current_pos <= -100 or current_pos >= 100 then
        return
    end
    local nDeltaLeft = form.groupbox_sbg.Width / 2 - form.lbl_ball.Width / 2
    local pos = nDeltaLeft * current_pos / 100
    form.lbl_ball.Left = nDeltaLeft + pos
    offset = math.abs(current_pos)
    zdnPlayGame(form, offset, current_pos)
    if nx_is_valid(form.Actor2) then
        form.Actor2.Speed = nx_number(math.abs(current_pos) / 30 + 1)
    end
    return
end

function zdnPlayGame(form, offset, current_pos)
    local cnt = 0
    if offset >= 70 then
        cnt = 6
    elseif offset >= 50 then
        cnt = 4
    elseif offset >= 40 then
        cnt = 3
    elseif offset >= 20 then
        cnt = 2
    elseif offset >= 10 then
        cnt = 1
    end
    while cnt > 0 do
        cnt = cnt - 1
        if current_pos > 0 then
            on_btn_left_click(form.btn_left)
        else
            on_btn_right_click(form.btn_right)
        end
    end
end
