::@echo off
set OLD_DIR=%CD%
cd %~dp0
echo %CD%

::APP_NAME Ӧ�ÿ����
::CFG_FILE ����������������ļ�
set APP_NAME=%~1
set CFG_FILE=qs.conf

if NOT EXIST %CFG_FILE% echo �Ҳ��������ļ� & pause > nul & goto :quit

::ѭ����ȡ����������������ļ����У�����ƥ��Ŀ�����������ַ�������ִ��start_app����
for /f "eol=; tokens=1-4 delims=," %%a in (%CFG_FILE%) do (
	if "%APP_NAME%" == "%%a" call :start_app "%%b" "%%c" "%%d" & goto :quit
)
echo �Ҳ������Ӧ��:%APP_NAME%
echo �Ͻ�ȥ���һ��
::������˳�
pause > nul
goto :quit


::����Ӧ���������
::EXE_NAME ��ִ���ļ���
::APP_PATH ��������
::APP_NOTE Ӧ��˵��/��ע
:start_app
	set EXE_NAME=%~1
	set APP_PATH=%~2
	set APP_NOTE=%~3
	set PATH=%APP_PATH%;%PATH%
	::���ɿ�������ļ�
	echo qs.bat %%~n0 > qs\%APP_NAME%.bat
	@echo on
	start /B "%APP_NOTE%" "%EXE_NAME%"
	@echo off
	goto :eof

:quit
	cd %OLD_DIR%
	goto :eof
