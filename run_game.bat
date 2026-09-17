@echo off
rem Double-click to play The Last Dungeon Master.
rem Finds the Godot 4.7.2 console binary installed via winget and runs this folder as the project.
set "GODOT="
for /f "delims=" %%f in ('dir /b /s "%LOCALAPPDATA%\Microsoft\WinGet\Packages\Godot_v4.7.2-stable_win64_console.exe" 2^>nul') do set "GODOT=%%f"
if not defined GODOT (
  echo Godot 4.7.2 console exe not found under %%LOCALAPPDATA%%\Microsoft\WinGet\Packages.
  echo Install it with:
  echo   winget install --id GodotEngine.GodotEngine --version 4.7.2 --exact --silent --accept-package-agreements --accept-source-agreements
  pause
  exit /b 1
)
rem NOTE: %~dp0 ends with a backslash, and "--path "C:\dir\"" breaks
rem Godot's arg parsing (the \" escapes the quote). Strip it first.
set "ROOT=%~dp0"
set "ROOT=%ROOT:~0,-1%"
"%GODOT%" --path "%ROOT%"
if errorlevel 1 pause
