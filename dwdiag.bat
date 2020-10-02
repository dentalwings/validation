@echo off
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exIt /B )

IF [%1] == [] (
	SET branch=kbase
) ELSE (
	SET branch=%1
)

SET target="%temp%\dwdiag.ps1"
IF EXIST %target% DEL %target%
powershell -ExecutionPolicy Unrestricted -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/dentalwings/validation/%branch%/dwdiag.ps1', '%target%')"
powershell -ExecutionPolicy Bypass %target% -Branch %branch%
pause
