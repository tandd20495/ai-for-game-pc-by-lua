* Quy trình can thiệp vào file game gốc của Snail, ví dụ lua.package:
1. UnPack/Mở gói lua.package bằng công cụ Unpack
2. Decompile/Biên dịch ngược file .lua gốc bằng công cụ UnLUA (Set up môi trường Java để dùng unluac.jar)
	. Trường hợp Decompile file .lua nhị phân không được thì file đã được bảo vệ bằng cách Encode/ Mã hóa
	=> Phải Decode/ Giải mã trước bằng công cụ khác rồi mới biên dịch ngược lại để ra code.
3. Add/Change/Fix/Update code gì đó.
4. Encode/Mã hóa (nếu có), Compile (biên dịch) lại file .lua (nếu cần)
5. Pack/ Đóng gói lại file .package
6. Paste đè file chỉnh sữa vào folder game gốc để apply auto.

* Tools:
1. UnPACK: Dùng tool mở file .package.
2. UnLUA: Copy file .lua cần biên dịch rồi chạy file unluaall.bat (biên dịch ngược toàn bộ file .lua có trong folder.)