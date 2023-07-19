require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")

-- Các định nghĩa trong hộp thư
local SUB_CLIENT_SET_JINGMAI = 1

local LETTER_SYSTEM_TYPE_MIN = 100 -- Lớn hơn cái này
local LETTER_SYSTEM_POST_USER = 101
local LETTER_SYSTEM_TEACH_NOTIFY = 102
local LETTER_SYSTEM_SINGLE_DIVORCE_NOTIFY = 103
local LETTER_SYSTEM_LOVER_RELATION_FREE = 104
local LETTER_SYSTEM_FRIEND = 105
local LETTER_USER_POST_TASK = 106
local LETTER_USER_OWNER_CROP_RECORD = 108
local LETTER_SYSTEM_TYPE_MAX = 199 -- Nhỏ hơn cái này là thư hệ thống

local LETTER_USER_TYPE_MIN = 0 -- Lớn hơn cái này
local LETTER_USER_POST_USER = 1
local LETTER_USER_POST_BACK_USER_OUT_TIME = 2
local LETTER_USER_POST_BACK_USER_REFUSE = 3
local LETTER_USER_POST_BACK_USER_FULL = 4
local LETTER_USER_POST_TRADE = 5
local LETTER_USER_POST_TRADE_PAY = 6
local LETTER_USER_WHISPER_USER = 10
local LETTER_USER_TYPE_MAX = 99 -- Nhỏ hơn cái này thì là thư người chơi

local POST_TABLE_SENDNAME = 0
local POST_TABLE_SENDUID = 1
local POST_TABLE_TYPE = 2
local POST_TABLE_LETTERNAME = 3
local POST_TABLE_VALUE = 4
local POST_TABLE_GOLD = 5
local POST_TABLE_SILVER = 6
local POST_TABLE_APPEDIXVALUE = 7
local POST_TABLE_DATE = 8
local POST_TABLE_READFLAG = 9
local POST_TABLE_SERIALNO = 10
local POST_TABLE_TRADE_MONEY = 11
local POST_TABLE_SELECT = 12
local POST_TABLE_LEFT_TIME = 13
local POST_TABLE_TRADE_DONE = 14

-- Lấy item trong thư
-- Nếu trả về rỗng là không có item
-- Nếu trả về dấu - tức là chưa xác định được
-- Còn lại sẽ trả về configID của item đó
function getItemInMail(str_goods)
    local xmldoc = nx_create("XmlDocument")
    if not nx_is_valid(xmldoc) then
        return "-"
    end
    if not xmldoc:ParseXmlData(str_goods, 1) then
        nx_destroy(xmldoc)
        return ""
    end
    local xmlroot = xmldoc.RootElement
    local xmlelement = xmlroot:GetChildByIndex(0)
    if not nx_is_valid(xmlelement) then
        nx_destroy(xmldoc)
        return ""
    end
    local configid = xmlelement:QueryAttr("Config")
    if nx_string(configid) == "" then
        nx_destroy(xmldoc)
        return ""
    end
    nx_destroy(xmldoc)
    return nx_string(configid)
end

function xoathu(item_del)
	local Recv_rec_name = "RecvLetterRec"
	local game_client = nx_value("game_client")
    local player_client = game_client:GetPlayer()
           
	if nx_is_valid(player_client) then
	local rownum = player_client:GetRecordRows(Recv_rec_name)

		for row = 0, rownum - 1 do
			local ntype = player_client:QueryRecord(Recv_rec_name, row, POST_TABLE_TYPE)
			local str_goods = nx_string(player_client:QueryRecord(Recv_rec_name, row, POST_TABLE_APPEDIXVALUE))
			local serialno = nx_string(player_client:QueryRecord(Recv_rec_name, row, POST_TABLE_SERIALNO))
			local gold = nx_int(player_client:QueryRecord(Recv_rec_name, row, POST_TABLE_GOLD))
			local silver = nx_int(player_client:QueryRecord(Recv_rec_name, row, POST_TABLE_SILVER))

			-- Xóa các thư của hệ thống, không tiền không vàng
			-- Không có item hoặc chứa item thiết lập xóa
			local itemID = getItemInMail(str_goods)
			if  nx_int(ntype) > nx_int(LETTER_SYSTEM_TYPE_MIN) and nx_int(ntype) < nx_int(LETTER_SYSTEM_TYPE_MAX)
				and gold <= nx_int(0) and silver <= nx_int(0)
				and itemID == nx_string(item_del)
			then
				yBreaker_show_Utf8Text("Vật phẩm xóa: " .. nx_string(itemID))
				-- Xóa vật phẩm thì set lại thời gian
				nx_execute("custom_sender", "custom_del_letter_ok", 1, serialno)
				break
			end
		end
	end
end

-- Loop xóa thư
function loopXoaThu()
	if isRunning then
		isRunning = false
		yBreaker_show_Utf8Text("Tắt Xóa Thư")
	else
		isRunning = true
		yBreaker_show_Utf8Text("Mở Xóa Thư")
		while isRunning do
			nx_pause(1)
			-- fixitem_002: là công cục sữa chữa
			-- faculty_yanwu_jhdw06: Minh Linh đan
			-- Tìm vật phẩm trong file stringname.ides
			xoathu("faculty_yanwu_jhdw06")
		end
	end
end

-- Execute function
loopXoaThu()

