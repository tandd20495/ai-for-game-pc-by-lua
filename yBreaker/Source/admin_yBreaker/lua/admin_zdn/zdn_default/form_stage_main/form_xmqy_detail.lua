function ShowConfirmInfo(nMoneyType, nMoneyPrize, op)
    if nx_execute("admin_zdn\\zdn_logic_noi6_tdbv", "IsRunning") then
        return true
    end
    local dialog = nx_execute("util_gui", "util_get_form", "form_common\\form_confirm", true, false, "chat")
    if not nx_is_valid(dialog) then
      return true
    end
    local gui = nx_value("gui")
    if not nx_is_valid(gui) then
      return true
    end
    local strInfo = nx_widestr("")
    if op == TRY_GET_AWARD_PLATE then
      if nx_number(nMoneyPrize) == nx_number(0) then
        strInfo = gui.TextManager:GetText("ui_xmqy_award_06")
      else
        strInfo = MakeInfoStr(op, nMoneyType, nMoneyPrize)
      end
    elseif op == TRY_OPEN_ONE_PLATE then
      strInfo = MakeInfoStr(op, nMoneyType, nMoneyPrize)
    end
    nx_execute("form_common\\form_confirm", "show_common_text", dialog, strInfo)
    dialog:ShowModal()
    local res = nx_wait_event(100000000, dialog, "confirm_return")
    return res == "ok"
end