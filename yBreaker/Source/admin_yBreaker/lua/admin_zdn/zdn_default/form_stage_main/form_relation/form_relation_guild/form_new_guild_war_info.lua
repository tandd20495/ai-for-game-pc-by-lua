function init_lm(form)
    form.tg_lm_rank:SetColTitle(0, nx_widestr(util_text("ui_lm_rank_001")))
    form.tg_lm_rank:SetColTitle(1, nx_widestr(util_text("ui_lm_rank_002")))
    form.tg_lm_rank:SetColTitle(2, nx_widestr(util_text("ui_lm_rank_003")))
    form.tg_lm_rank:SetColTitle(3, nx_widestr(util_text("ui_lm_rank_004")))
    form.tg_lm_rank:SetColTitle(4, nx_widestr(util_text("ui_lm_rank_005")))
    custom_league_matches(7)
    custom_league_matches(8)
    form.rbtn_lm_1.Checked = true
    form.rbtn_champion_war.Top = 90
end
