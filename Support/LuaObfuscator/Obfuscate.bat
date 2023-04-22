echo off
cls

cd bin
for /r ../sources/ %%i in (*.lua) do "luajit.exe" -b "%%i" "%%i"

pause