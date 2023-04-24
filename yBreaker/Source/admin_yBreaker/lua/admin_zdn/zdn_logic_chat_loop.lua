require("util_gui")
require("util_functions")
require("admin_zdn\\zdn_util")

local Running = false
local ContentList = {}

function Start(chatType, txt)
    local content = ""
    local delay = 2
    if nx_function("ext_ws_find", txt, nx_widestr(" ")) == 0 then
        content = nx_function("ext_ws_substr", txt, 1, nx_ws_length(txt))
    else
        local prop = util_split_wstring(txt, " ")
        delay = nx_number(prop[1])
        if delay < 2 then
            delay = 2
        end
        content = nx_function("ext_ws_substr", txt, nx_ws_length(prop[1]), nx_ws_length(txt))
    end
    addToContentList(chatType, content, delay)
    if Running then
        return
    end
    showChatForm()
    Running = true
    while Running do
        loopChat()
        nx_pause(1)
    end
end

function Stop()
    Running = false
    ContentList = {}
end

function loopChat()
    local cnt = #ContentList
    for i = 1, cnt do
        local delay = ContentList[i][3]
        local lstChat = ContentList[i][4]
        if TimerDiff(lstChat) >= delay then
            nx_execute("custom_sender", "custom_chat", ContentList[i][1], ContentList[i][2])
            ContentList[i][4] = TimerInit()
            nx_pause(0.05)
        end
    end
end

function addToContentList(chatType, content, delay)
    local cnt = #ContentList
    for i = 1, cnt do
        if ContentList[i][1] == chatType then
            return
        end
    end
    local c = {}
    c[1] = chatType
    c[2] = content
    c[3] = delay
    c[4] = 0
    table.insert(ContentList, c)
end

function showChatForm()
    util_show_form("admin_zdn\\form_zdn_chat_loop", true)
    local fc = nx_value("form_stage_main\\form_main\\form_main_chat")
    if not nx_is_valid(fc) then
        return
    end
    local f = nx_value("admin_zdn\\form_zdn_chat_loop")
    if not nx_is_valid(f) then
        return
    end
    f.Left = 328
    f.Top = fc.group_chat_input.AbsTop
end
