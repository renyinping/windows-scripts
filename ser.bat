::putty.exe -serial COM1 -sercfg 9600,8,n,1,N
@echo off
set OLD_DIR=%CD%
cd %~dp0
echo %CD%

set COM_PATH=C:\MySpace\Apps\Tools\putty
set PATH=%COM_PATH%;%SCP_PATH%;%PATH%

::没有参数
if "%~1" == "" (
	start /B putty.exe -serial
)
elif NOT "%~2" == "" (
	set COM_PORT=COM%~1
	set BAUD_RATE=115200
	start /B putty.exe -serial %COM_PORT% -sercfg 115200,8,n,1,N
	goto :eof
)
else (
	set COM_PORT=COM%~1
	set BAUD_RATE=%~2
	start /B putty.exe -serial %COM_PORT% -sercfg %BAUD_RATE%,8,n,1,N
)

