// TODO

- Luyện công (Tự vào pt, tự tạo PT LC, tự chạy map LC)
- Thụ nghiệp (Tự tele map thụ nghiệp)
- Tiếp tục nội tu khi lên cấp/ Tự cắn nội tu vật phẩm
- Đàn/ Luyện đàn/ Tự chạy đàn/ Ném boom
- Vận tiêu
- Auto PVP (Auto Swap oản, Vũ khí, Def, Đè ping)
- Auto PVE (Auto swap oản, bình thư, vũ khí, def, đè ping)
- Auto blink
- Auto swap (Ám khí/Vũ khí theo skill, vũ khí/oản/áo/bình thư)
- Bug lãm
- Tìm Đàn/ Tìm cây
- Auto skill
- Debug
- CodeNew
- Không bị disconnect màn hình login
- Count bộ nhớ
- Mode PVC
- Thần hành
- Tự tích THBB + LHQ


TODO:
Admin:
* Mod PVC
* Debug
* Codenew

- Hỗ trợ mặc định:
+ Done: Tự nhảy luyện công/ Thụ nghiệp
+ Done: Tiếp tục nội tu khi lên cấp
+ Done: Không bị connect ở màn hình login
+ Done: Skip cốt truyện
+ DOne: Mở giới hạn client game
+ Nhận kỳ ngộ

- Cần thiết:
+ Tạp hóa
+ Thần hành
+ Tự sửa đồ

- Auto AI:
+ Chạy Luyện công
+ Chạy thụ nghiệp
+ Chạy Q NC 6
+ Chạy Q cấm địa tuần TDC

- Nghề:
+ Luyện đàn/ kì/ thư sinh/ họa sư
+ Trồng trọt
+ Thợ săn

- Nâng cao:
- Swap oản/ vũ khí
- Đàn/ luyện đàn
- Tìm đàn/ tìm cây
- Blink
- Bug lãm
- Bug Speed
- Soi máu/ Nộ/ PT
- Def/ Đè ping



// HEADER OF FILE
--[[DO: FILE HEADER --]]

// BLOCK CODE FOR TOOLS
Line comment:
--[ADD: function name... for yBreaker
	code new

--CHANGE: 
--code org
  code new
--]

--REM:

Block comment:
--[[ code 
	new 
	do
	something
--]]


GUI MAIN: /admin

--1: Mod PVC   	 /pvc		Chưa tự lưu PVC để apply cho lần sau đổi vũ khí
--2: Debug    	 /debug
--3: Codenew	 /code		Đổi thành lệnh /a filename.lua để code nháp nhiều file hơn
4: AI			 /ai 		Gồm: LC,TN,VT,Q NC6,Cấm địa TDC/LTT,Trồng cây,Săn,Thu thập: Khoáng,Dược,Độc,...
--5: PVP			 /pvp 		Pre: Cần config acc trước. Gồm: Swap (có tích chọn: VK theo skill đánh/vk+oản 30%/bình thư/áo), Mạch + đồ, target, def, Đè ping.					
6: BUGS			 /bugs  	Gồm: Bảng bug speed + tele Đảo + DHC+ Blink + Lãm + Tự Tử + KC + Thêm/Xóa HC, Hải bố, Bộ khoái, 
--7: Thần hành	 /tele  	Nếu thêm điểm k thể tele thì bị mất vị trí đó
--8: Đàn đội	 /dan		Thêm chế độ: Đổi tên bài đàn dễ hiểu/ Chạy chỗ đàn
--9: Config	 	 /config    Setting theo nhân vật		
--10: Tạp hóa	 /shop
--11: Sữa đồ	 /fix
--12: Tự rao	 /chat
--13: Auto Swap	 /swap  	Swap cả đồ 30% + bình thư/ Lỗi: Chưa swap oản bộ trịch bút: Lỗi line 526 AutoGetCurSelect2
--14: Auto Skill /skill		
--15: Đổi mạch	 /mach		
--16: Tìm đàn	 /timdan 	Chưa hiển thị được key pt của đàn
--17: Tìm cây	 /timcay 	
18: Lĩnh vực	 /mat		Gồm: Tìm đàn, Tìm cây, Quét người xung quanh, Quét tên theo bang update tọa độ liên tục, tìm cóc, Info, 
--19: Blink		 /blink 	Lỗi: 218 khi chưa chọn điểm đến trên maps. / Set được khoảng cách blink
--20: Lãm		 /buff 		
--21: Tự sát	 /die

TODO:
- Tự mở pass rương khi đăng nhập
- Soi HP
- Soi nộ + khoảng cách + KeyPT + SL 
- Soi người đang target mình
- Auto tích THBB

Buff đội	/buff		Thêm chế độ: tìm tên nhân vật chỉ định spam skill theo id (Chết thì hồi sinh lân cận nhanh rồi chạy ra tọa độ cũ)
Luyện đàn: /luyendan
Giới thiệu: /about
Luyện công	/lc
Thụ nghiệp	/tn

19: Trồng trọt	/farm
20: Săn bắt		/hunter
21: Hái lượm	/gatherer
