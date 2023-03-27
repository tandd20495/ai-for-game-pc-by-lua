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


GUI MAIN: /yt or /YT

--1: Mod PVC   	 /pvc		Chưa tự lưu PVC để apply cho lần sau đổi vũ khí
--2: Debug    	 /debug
--3: Codenew	 /codenew	Chạy file codenew.lua tại folder yBreaker\scripts
Có thể thực hiện lệnh /code _filename để chạy file code nháp yBreaker\scripts
4: AI			 /ai 		Gồm: LC,TN,VT,Q NC6,Cấm địa TDC/LTT,Trồng cây,Săn,Thu thập: Khoáng,Dược,Độc,...
--5: PVP			 /pvp 		Pre: Cần config acc trước. Gồm: Swap (có tích chọn: VK theo skill đánh/vk+oản 30%/bình thư/áo), Mạch + đồ, target, def, Đè ping.					
6: BUGS			 /bugs  	Gồm: Bảng FPS/ speed + tele Đảo + DHC + Blink + Lãm + Tự Tử + Tự nhảy k tốn KC(Làm /jump để nhảy liên tục) + Thêm/Xóa HC, Hải bố, Bộ khoái, 
--7: Thần hành	 /tele  	Nếu thêm điểm k thể tele thì bị mất vị trí đó
--8: Đàn đội	 /dan		Thêm chế độ: Đổi tên bài đàn dễ hiểu/ Chạy chỗ đàn
--9: Config	 	 /config    Lưu cache trước khi dùng tính năng PVP
--10: Tạp hóa	 /shop
--11: Sữa đồ	 /fix
--12: Tự rao	 /chat
--13: Auto Swap	 /swap  	Nút 1: swap cả đồ 30% + bình thư 10% , Nút 2 swap bình thư phòng ngự đã lưu cache
		***Nếu chưa swap oản 30% + bt 10% cùng 1 skill thì auto k lỗi, còn swap oản skill đó rồi nhưng vẫn ra skill đó tiếp theo sẽ bị giật bình thư 10% của skill đó
		***Nếu swap bt10% của skill đó trước vẫn k bị giật bt, chỉ khi đang ra skill mà tự swap sang bth khác thì auto sẽ giật khi swap lại bth của skill đang ra
		*** Ví dụ: Đang nộ Đạn chỉ
		* Auto tự swap oản + bth đạn chỉ, đang trong trạng thái ra skill mà tự swap quá bình thư khác auto sẽ giật để swap 2 bth
		* Còn swap oản + bth trước khi ra skill sẽ không giật
		
--14: Auto Skill /skill		CÓ thể dùng ném phi tiêu, có buff đội
--15: Đổi mạch	 /mach		
--16: Tìm đàn	 /timdan 	Chưa hiển thị được key pt của đàn
--17: Tìm cây	 /timcay 	
--18: Mắt thần	 /mat		Demo OK. Làm tiếp gồm: Tìm đàn, Tìm cây, Quét người xung quanh, Quét tên theo bang update tọa độ liên tục, tìm cóc, Info (Key PT, Nộ, Khoảng cách) 
--19: Blink	 	 /blink     Add thêm text cho user nhập bước nhảy
*** Lưu ý: 
Cần bật MAP + chọn điểm đến trên MAP mới ấn nút Blink để nhảy.
Dừng blink bằng cách tắt form
--20: Lãm	 /buff 		
--21: Tự sát /die
-- Show máu  /showhp
TODO:
- /help: Cách sử dụng và các lệnh trong yBreaker
- Mở form log: /log
- Tự mở pass rương khi đăng nhập
- Soi HP
- Soi nộ + khoảng cách + KeyPT + SL 
- Soi người đang target mình
- Auto tích THBB
- Thêm tính năng FPS
- Thêm khảo đoạn code trong form_main_chat của SUM có đoạn split string command chat



Buff đội	/buff		Thêm chế độ: tìm tên nhân vật chỉ định spam skill theo id (Chết thì hồi sinh lân cận nhanh rồi chạy ra tọa độ cũ)
Luyện đàn: /luyendan
Giới thiệu: /about
Luyện công	/lc
Thụ nghiệp	/tn

19: Trồng trọt	/farm
20: Săn bắt		/hunter
21: Hái lượm	/gatherer
