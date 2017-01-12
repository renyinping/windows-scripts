@echo off
set OLD_DIR=%CD%
cd %~dp0
echo %CD%

::根据文件名启用ssh或scp
if "%~n0" == "ssh" set CONN=ssh_conn & fc ssh.bat scp.bat || copy /Y ssh.bat scp.bat
if "%~n0" == "scp" set CONN=scp_conn
if not defined CONN goto :quit

::DEV_NAME 主机快捷名
::CFG_FILE 配置文件
set DEV_NAME=%~1
set CFG_FILE=ssh.conf
set SSH_PATH=C:\MySpace\Apps\Tools\putty
set SCP_PATH=C:\MySpace\Apps\Tools\winscp
set PATH=%SSH_PATH%;%SCP_PATH%;%PATH%

if NOT EXIST %CFG_FILE% echo 找不到配置文件 & pause > nul & goto :quit

::循环读取配置文件的行，发现匹配的主机快捷名，就执行conn函数
for /f "eol=; tokens=1-7 delims=," %%a in (%CFG_FILE%) do (
	if "%DEV_NAME%" == "%%a" call :%CONN% "%%b" "%%c" "%%d" "%%e" "%%f" "%%g" & goto :quit
)
echo 找不到主机快捷名:%DEV_NAME%
echo 赶紧去添加一个
::任意键退出
pause > nul
goto :quit


::连接函数
::HOST 主机host或ip
::PORT 端口
::USER 用户名
::PASSWD 用户密码
::SSH_PROTO SSH协议版本(1 or 2)
::SCP_PROTO scp连接协议(scp or sftp)

:ssh_conn
	if     "%~1" == "" echo 缺少主机信息 & pause > nul & goto :quit
	                   set HOST=%~1
	if NOT "%~2" == "" set PORT=-P %~2
	if NOT "%~3" == "" set USER=%~3@
	if NOT "%~4" == "" set PASSWD=-pw %~4
	if NOT "%~5" == "" set SSH_PROTO=-%~5
	@echo on
	start /B putty.exe -ssh %SSH_VER% %USER%%HOST% %PASSWD% %PORT%
	@echo off
	goto :eof

:scp_conn
	if     "%~1" == "" echo 缺少主机信息 & pause > nul & goto :quit
	                   set HOST=%~1
	if NOT "%~2" == "" set PORT=:%~2
	if NOT "%~4" == "" set PASSWD=:%~4
	if NOT "%~3" == "" set USER=%~3%PASSWD%@
	                   set SCP_PROTO=scp://
	if NOT "%~6" == "" set SCP_PROTO=%~6://
	@echo on
	start /B winscp.exe %SCP_PROTO%%USER%%HOST%%PORT%
	@echo off
	goto :eof

:quit
	cd %OLD_DIR%
	goto :eof
