@echo off
set OLD_DIR=%CD%
cd %~dp0
echo %CD%

::�����ļ�������ssh��scp
if "%~n0" == "ssh" set CONN=ssh_conn & fc ssh.bat scp.bat || copy /Y ssh.bat scp.bat
if "%~n0" == "scp" set CONN=scp_conn
if not defined CONN goto :quit

::DEV_NAME ���������
::CFG_FILE �����ļ�
set DEV_NAME=%~1
set CFG_FILE=ssh.conf
set SSH_PATH=C:\MySpace\Apps\Tools\putty
set SCP_PATH=C:\MySpace\Apps\Tools\winscp
set PATH=%SSH_PATH%;%SCP_PATH%;%PATH%

if NOT EXIST %CFG_FILE% echo �Ҳ��������ļ� & pause > nul & goto :quit

::ѭ����ȡ�����ļ����У�����ƥ����������������ִ��conn����
for /f "eol=; tokens=1-7 delims=," %%a in (%CFG_FILE%) do (
	if "%DEV_NAME%" == "%%a" call :%CONN% "%%b" "%%c" "%%d" "%%e" "%%f" "%%g" & goto :quit
)
echo �Ҳ������������:%DEV_NAME%
echo �Ͻ�ȥ���һ��
::������˳�
pause > nul
goto :quit


::���Ӻ���
::HOST ����host��ip
::PORT �˿�
::USER �û���
::PASSWD �û�����
::SSH_PROTO SSHЭ��汾(1 or 2)
::SCP_PROTO scp����Э��(scp or sftp)

:ssh_conn
	if     "%~1" == "" echo ȱ��������Ϣ & pause > nul & goto :quit
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
	if     "%~1" == "" echo ȱ��������Ϣ & pause > nul & goto :quit
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
