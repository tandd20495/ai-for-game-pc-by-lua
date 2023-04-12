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


- Hỗ trợ mặc định:
+ Done: Tự nhảy luyện công/ Thụ nghiệp
+ Done: Tiếp tục nội tu khi lên cấp
+ Done: Không bị connect ở màn hình login
+ Done: Mở giới hạn client game
+ Done: Tự đập trứng sôi nổi

GUI MAIN: /yt or /YT
HELP: /help or /HELP
AI			 /ai 		Gồm: LC,TN,VT,Q NC6,Cấm địa TDC/LTT,Trồng cây,Săn,Thu thập: Khoáng,Dược,Độc,...
-- Automation    /at
--1: Mod PVC   	 /pvc		Chưa tự lưu PVC để apply cho lần sau đổi vũ khí
--2: Debug    	 /debug
--3: Codenew	 /codenew	Chạy file codenew.lua tại folder yBreaker\scripts
--Có thể thực hiện lệnh /code _filename để chạy file code nháp yBreaker\scripts

--5: PVP		 /a 		
--13: Auto Swap	 /s  		Tích chọn Oản/VK 30% + Bình Thư + Áo (K swap đồ công thì swap về thủ)(Fix bug add id swap cho các bộ có võ kĩ)
-- Quét Info	 /d			
--18: Mắt thần	 /q		
--15: Đổi mạch	 /w
--6: BUGS		 /e  		
-- Bug Ping  	 /z			Nâng cấp khi đang khinh công vẫn đè ping đc
-- Quét Custom	 /x
-- Show máu  	 /c
--19: Blink	 	 /blink     Add thêm text cho user nhập bước nhảy

-- Tự tích THBB  /th 		Thêm Tự gọi PET
--7: Thần hành	 /tele  	Nếu thêm điểm k thể tele thì bị mất vị trí đó
--8: Cầm sư	 /dan		
--9: Config	 	 /config    
--10: Tạp hóa	 /shop
--11: Sữa đồ	 /fix
--12: Tự rao	 /chat		
--14: Auto Skill /skill		Tính năng này spam các ô skill từ 1 - 5
--16: Tìm đàn	 /timdan 	
--17: Tìm cây	 /timcay 	


-- Lãm	 /buff 		
-- Tự sát /die
-- Diễn vỡ Tâm Ma		/tm
-- Use vật phẩm ô đầu tiên trong hành trang /use
-- Tự nhận kỳ ngộ 		/kn
-- Treo shop			/stall
-- Luyện tửu			/lt
-- Spam mail			/sm
-- Luyện công			/lc
-- Thụ nghiệp			/tn
-- Vận tiêu				/vt
-- Mã hóa pass rương 	/pw 
-- Trồng trọt			/trongtrot
-- Câu cá				/cauca
-- Thu thập				/thuthap
-- Săn bắt				/sanbat
-- Setting khác			/set
-- Bấm Ctrl + P để bật bug mode và ấn Space để nhảy

*** Lưu ý tính năng swap:
Nếu chưa swap oản 30% + bt 10% cùng 1 skill thì auto k lỗi, còn swap oản skill đó rồi nhưng vẫn ra skill đó tiếp theo sẽ bị giật bình thư 10% của skill đó
Nếu swap bt10% của skill đó trước vẫn k bị giật bt, chỉ khi đang ra skill mà tự swap sang bth khác thì auto sẽ giật khi swap lại bth của skill đang ra
Ví dụ: Đang nộ Đạn chỉ
* Auto tự swap oản + bth đạn chỉ, đang trong trạng thái ra skill mà tự swap quá bình thư khác auto sẽ giật để swap 2 bth
* Còn swap oản + bth trước khi ra skill sẽ không giật

*** Lưu ý tính năng blink: 
Cần bật MAP + chọn điểm đến trên MAP mới ấn nút Blink để nhảy.
Dừng blink bằng cách tắt form

TODO:

- /help: Cách sử dụng và các lệnh trong yBreaker

- Mở form log: /log



