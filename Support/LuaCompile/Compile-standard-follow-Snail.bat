echo off
cls

cd bin
for /r ../sources/ %%i in (*.lua) do "luac.exe" -o "%%i" "%%i"

pause