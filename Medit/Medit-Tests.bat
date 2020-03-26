@echo off
powershell -ExecutionPolicy Bypass Invoke-Pester .\Medit-Tests.ps1
pause