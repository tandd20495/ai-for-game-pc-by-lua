local FORM_NAME = "form_stage_main\\form_main\\form_main_shortcut"
local form = nx_value(FORM_NAME)
if not nx_is_valid(form) then
  return
end
local absleft = form.grid_shortcut_2.AbsLeft - 22
local abstop = form.grid_shortcut_2.AbsTop - form.groupbox_shortcut_2.Height - 20
local gui = nx_value("gui")
form.groupbox_skill.AbsLeft = absleft
form.groupbox_skill.AbsTop = abstop
form.groupbox_skill_1.AbsLeft = absleft
form.groupbox_skill_1.AbsTop = abstop - form.groupbox_skill_1.Height
form.groupbox_skill_2.AbsLeft = absleft - form.groupbox_skill_2.Width
form.groupbox_skill_2.AbsTop = form.lbl_page.AbsTop - form.groupbox_skill_2.Height + 80
form.groupbox_skill_3.AbsLeft = absleft - form.groupbox_skill_3.Width * 2 + 20
form.groupbox_skill_3.AbsTop =  form.lbl_page.AbsTop - form.groupbox_skill_2.Height + 80
form.groupbox_ng.AbsLeft = form.lbl_page.AbsLeft + 18
form.groupbox_ng.AbsTop = form.lbl_page.AbsTop - form.groupbox_ng.Height / 4 + 4
