local CLIENT_CUSTOMMSG_SMAILL_GAME_MSG = 505
local SMALLGAME_MSG_OPEN_WHACK_EGG_END = 6
local SMALLGAME_MSG_PRIZE_WHACK_EGG = 7
local SINKER_IMAGE = "gui\\special\\life\\puzzle_quest\\smahing_egg\\hammer.png"

function on_main_form_open(form)
    form.Fixed = true
    local visual = nx_value("game_visual")
    visual:CustomSend(nx_int(CLIENT_CUSTOMMSG_SMAILL_GAME_MSG), nx_int(SMALLGAME_MSG_PRIZE_WHACK_EGG))
    visual:CustomSend(nx_int(CLIENT_CUSTOMMSG_SMAILL_GAME_MSG), nx_int(SMALLGAME_MSG_OPEN_WHACK_EGG_END))
    turn_to_full_screen(form)
    form.goal_fuqi = 0
    form.goal_jinlong = 0
    form.goal_feichui = 0
    form.special_num_1 = 0
    form.special_num_2 = 0
    form.special_num_3 = 0
    form.break_num_1 = 0
    form.break_num_2 = 0
    form.break_num_3 = 0
    form.game_time = 0
    form.pause_time = 0
    form.game_batch = 0
    form.batch_time = 0
    form.max_goal = 0
    form.end_success = false
    form.Cursor = SINKER_IMAGE
    init_mole(form)
    play_music("gem_egg_start")
end

function on_game_over(state)
    local gui = nx_value("gui")
    if not nx_is_valid(gui) then
      return
    end
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
      return
    end
    if state then
      create_img_ani("win", gui.Desktop.Width / 2 - 868, gui.Desktop.Height / 5)
      play_sound("win")
      game_visual:CustomSend(nx_int(CLIENT_CUSTOMMSG_SMAILL_GAME_MSG), nx_int(SMALLGAME_MSG_PRIZE_WHACK_EGG))
    else
    --   create_img_ani("lose", gui.Desktop.Width / 2 - 868, gui.Desktop.Height / 5)
    --   play_sound("lose")
        create_img_ani("win", gui.Desktop.Width / 2 - 868, gui.Desktop.Height / 5)
        play_sound("win")
        game_visual:CustomSend(nx_int(CLIENT_CUSTOMMSG_SMAILL_GAME_MSG), nx_int(SMALLGAME_MSG_PRIZE_WHACK_EGG))
    end
    game_visual:CustomSend(nx_int(CLIENT_CUSTOMMSG_SMAILL_GAME_MSG), nx_int(SMALLGAME_MSG_OPEN_WHACK_EGG_END))
    gui.GameHand:ClearHand()
  end