::@echo off
set OLD_DIR=%CD%
cd %~dp0
echo %CD%

::APP_NAME 应用快捷名
::CFG_FILE 快捷启动命令配置文件
set APP_NAME=%~1
set CFG_FILE=qs.conf

if NOT EXIST %CFG_FILE% echo 找不到配置文件 & pause > nul & goto :quit

::循环读取快捷启动命令配置文件的行，发现匹配的快捷启动命令字符串，就执行start_app函数
for /f "eol=; tokens=1-4 delims=," %%a in (%CFG_FILE%) do (
	if "%APP_NAME%" == "%%a" call :start_app "%%b" "%%c" "%%d" & goto :quit
)
echo 找不到快捷应用:%APP_NAME%
echo 赶紧去添加一个
::任意键退出
pause > nul
goto :quit


::启动应用软件函数
::EXE_NAME 可执行文件名
::APP_PATH 环境变量
::APP_NOTE 应用说明/备注
:start_app
	set EXE_NAME=%~1
	set APP_PATH=%~2
	set APP_NOTE=%~3
	set PATH=%APP_PATH%;%PATH%
	::生成快捷启动文件
	echo qs.bat %%~n0 > qs\%APP_NAME%.bat
	@echo on
	start /B "%APP_NOTE%" "%EXE_NAME%"
	@echo off
	goto :eof

:quit
	cd %OLD_DIR%
	goto :eof
