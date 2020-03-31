@echo off
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

IF [%1] == [] (
	SET branch=master
) ELSE (
	SET branch=%1
)

IF EXIST "%temp%\diagnostic.ps1" DEL "%temp%\diagnostic.ps1"
powershell -ExecutionPolicy Unrestricted -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/dentalwings/validation/%branch%/diagnostic.ps1', '%temp%\diagnostic.ps1')"
powershell -ExecutionPolicy Bypass %temp%\diagnostic.ps1 -Branch %branch%
pause