@echo off
powershell -ExecutionPolicy Bypass Invoke-Pester .\7Series-Tests.ps1
pause