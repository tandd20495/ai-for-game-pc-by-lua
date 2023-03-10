# Auto Cửu Âm Chân Kinh Việt Nam

LINK TẢI: https://github.com/hoaquynhtim99/auto-cack-vn/releases/tag/v1.138.01 (tải 3 file lua.package, skin.package, text.package)

## Trong auto này có gì?

- Auto bắt cóc
- Auto trồng cây + Nuôi tằm
- Auto hái khoáng, dược, độc
- Auto chặt cây
- Auto câu cá
- Auto nhận kỳ ngộ (tổng hợp các kỳ ngộ xịn)
- Auto rao kênh thế giới, đội, map, gần, bang, thế lực, phái
- Auto check thời gian reset cóc
- Auto phát hiện cóc reset + tự động thổi
- Auto tung hoành tứ hải
- Auto bày shops online
- Auto phát hiện rương trong Khoái Hoạt Đảo (gần 20 loại bảo rương)
- Auto mở rương trong sự kiện Đấu Trường Hoạt Đảo
- Auto mở tạp hóa mọi nơi mà không cần mã tiêu hay lạc đà
- Auto đàn tự động đàn lại
- Auto tự trị thương lân cận khi bị đánh chết
- Auto các nhiệm vụ của Cổ Mộ: Đu dây, song tu, luyện mật ong.
- Auto vận tiêu
- Auto đánh cờ
- Mở khóa giới hạn mở tối đa 3 client
- Mở Map tân thế giới
- Auto luyện công, thụ nghiệp
- Auto nhiệm vụ đốt lửa Từ Gia Trang.

### Hướng dẫn auto Tung Hoành Tứ Hải

Đặt thư mục auto vào ổ `C:`.


Chú ý các thiết lập trong tools_tiguan.lua:

```lua
-- Thiết lập auto, sau này sẽ căn cứ vào config để build ra
local cfg = {
	numTiguan = 4, -- Số cấp khiêu chiến 1 => 4
	numGuanPerTiguan = { -- Số thể lực sẽ đánh ở mỗi cấp
		[1] = 1,
		[2] = 1,
		[3] = 4,
		[4] = 4
	},
	doType = 1, -- 1 đánh ngược hoặc 2 đánh xuôi:
	dissMissLastGuan = 1, -- Bỏ thế lực cuối nếu không ra boss đỏ.
	allowWinExec = false, -- Đặt là TRUE để khởi chạy chức năng điều khiển bàn phím, chuột (bật cái này thì cần phải để nguyên chuột và bàn phím)
	continueArrest = 1, -- Tiếp tục đánh nếu boss tiếp theo đỏ mặc dù đã đạt giới hạn số thế lực
	breakOne = false, -- Đặt là true thì sẽ dừng lại khi đánh xong mỗi thế lực
	pauseOne = { -- Đặt là true thì sẽ dừng lại khi xong boss để tự mở rương
		[1] = true,
		[2] = true,
		[3] = true,
		[4] = true
	}
}
```

Các phần khác vui lòng không sửa.

> Chú ý: Giá trị allowWinExec nếu đặt là TRUE thì phải đặt thư mục `New` ra Desktop khi đó tồn tại đường dẫn: `C:\Users\phant\Desktop\New\test.exe`. Hoặc có thể sửa giá trị

```lua
local WINEXEC_PATH = "C:\\Users\\phant\\Desktop\\New\\test.exe"
```

Thành giá trị thích hợp.


## Các file sửa đổi ( nên xem hàm nào thay đổi để sửa lại, copy nguyên file up lên phiên bản cao dễ gây lỗi )

### RES/SKIN

Dùng Winmerge để so sánh (do ít file)

skill/from_stage_main/form_main/form_main.xml

Thêm thư mục `auto_images` có file PSD để thiết kế nút

### RES/TEXT

Dùng Winmerge để so sánh (do chỉ có 1 file thay đổi)

interface.idres
### LUA

```
main.lua                                                         Mở khóa MAX CLIENT 

form_stage_main\form_give_item.lua                               Sửa lỗi khi auto nhận ITEM (ví dụ bán cóc xong nhận sửa công cụ)
form_stage_main\form_talk_movie.lua   x                          Ghi log MESSAGE ID và tên NPC khi nói chuyện (nhằm lấy mã để auto nhận kỳ ngộ, auto đối thoại ....) Log ghi vào C:/log.txt
form_stage_main\form_bag_func.lua                                Sửa khi CTRL+Click vào Item để đưa vào auto chat

form_stage_main\form_main\form_main.lua     x                    Sửa để thêm nút công cụ vào 3 nút Giang hồ, chiến đấu, cuộc sống
form_stage_main\form_main\form_main_request.lua     x            Sửa để xác nhận có REQUSET ví dụ mời tổ đội, mời giao dịch...

form_stage_main\form_map\form_map_scene.lua                      Mở khóa

form_stage_main\form_pick\form_droppick.lua      x               Sửa để auto nhận vật phẩm ví dụ khi trồng cây, nhấp vào nhận

form_stage_main\form_school_dance\form_school_dance_key.lua      Auto thụ nghiệp

form_stage_main\form_small_game\form_forgegame.lua               Auto game
form_stage_main\form_small_game\form_game_balance.lua            Không nhớ game gì
form_stage_main\form_small_game\form_game_bee.lua                Không nhớ game gì
form_stage_main\form_small_game\form_game_pick.lua               Không nhớ game gì
form_stage_main\form_small_game\form_game_question.lua           Không nhớ game gì
form_stage_main\form_small_game\form_game_rope_swing.lua         Auto game đu dây Cổ Mộ
form_stage_main\form_small_game\form_game_weiqi.lua              Không nhớ game gì
form_stage_main\form_small_game\form_jia_huo_game.lua            Auto đánh cờ
form_stage_main\form_small_game\form_qingame.lua                 Auto đàn kỹ nghệ nhận tâm đắc
form_stage_main\form_small_game\form_mini_qingame.lua            Auto đàn buff đội
form_stage_main\form_small_game\form_game_picture.lua			 Auto họa sư

form_stage_main\form_wuxue\form_team_faculty_dance.lua           Auto luyện nhóm
form_stage_main\form_wuxue\form_faculty_team.lua                 Gỡ bỏ auto chat khi mở thụ nghiệp
```

Các file thêm:

```
auto_tools/form_func_btns_tools.lua   Code xử lý khi để chuột vào nút Công Cụ
auto_tools/inspect.lua                Thư viện xử lý export một biến
auto_tools/tool_libs.lua              Thư viện các hàm dùng trong các chức năng Auto
auto_tools/tools_captureqt.lua        Auto nhận kỳ ngộ
auto_tools/tools_crop.lua             Auto trồng cây nuôi tằm
auto_tools/tools_chat.lua             Auto rao
auto_tools/tools_doabduct.lua         Auto bắt cóc
auto_tools/tools_dofile.lua           Thực thi file code.lua nằm tại C:/auto/code.lua nhằm mục đích phát triển
auto_tools/tools_escort.lua           Auto vận tiêu
auto_tools/tools_fish.lua             Auto câu cá
auto_tools/tools_grocery.lua          Auto mở tạp hóa ở bất kỳ đâu
auto_tools/tools_khddetect.lua        Auto phát hiện rương khoái hoạt đảo
auto_tools/tools_khdopenbox.lua       Auto mở rương Đấu Trường Hoạt Đảo
auto_tools/tools_lookupabduct.lua     Auto check thời gian reset cóc
auto_tools/tools_minemedi.lua         Auto đào khoáng, hái thuốc dược + độc
auto_tools/tools_qingame.lua          Auto đàn tự đàn lại
auto_tools/tools_relivenear.lua       Auto trị thương lân cận
auto_tools/tools_rsabduct.lua         Auto phát hiện cóc reset + tự thổi
auto_tools/tools_stallonline.lua      Auto bày shops online
auto_tools/tools_test.lua             Gọi lệnh DEBUG (có thể check được sát thủ cấm địa là ai)
auto_tools/tools_tiguan.lua           Auto THTH 
auto_tools/tools_woodcut.lua          Auto chặt cây
```

## Các phần mềm và hướng dẫn

- So sánh các file thay đổi sử dụng Winmerge: http://winmerge.org/
- Tạo project ảo dùng Visual SVN: https://www.visualsvn.com/server/

### Cách giải nén file .package

### Cách nén lại file .package


> Chú ý: Phần mềm này chạy trên XP, window khác sẽ báo lỗi có virut, cần cài máy ảo để chạy.

Hướng dẫn + link phần mềm xem: https://www.youtube.com/watch?v=pUCpXrNDrJM

