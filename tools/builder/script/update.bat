@echo off
setlocal enabledelayedexpansion

set ZIPFILE=var\update.zip
set DESTDIR=%CD%\..\..
set TEMP_UNPACK=%TEMP%\update_unpack

echo "Unpack %ZIPFILE% to %TEMP_UNPACK%..."
rmdir /s /q "%TEMP_UNPACK%" >nul 2>&1
powershell -ExecutionPolicy Bypass -Command "Expand-Archive -Path '%ZIPFILE%' -DestinationPath '%TEMP_UNPACK%' -Force"

if errorlevel 1 (
    echo "Failed to unpack updade."
    goto end
)

echo "Detecting root folder inside ZIP..."

set "SOURCE_SUBDIR="
for /d %%D in ("%TEMP_UNPACK%\*") do (
    set "SOURCE_SUBDIR=%%D"
    goto found_dir
)

:found_dir
if not defined SOURCE_SUBDIR (
    echo "No folder found inside ZIP!"
    goto end
)

echo "Copying from !SOURCE_SUBDIR! to %DESTDIR%..."
xcopy "!SOURCE_SUBDIR!\*" "%DESTDIR%\" /E /I /Y /Q

echo "Cleanup..."
rmdir /s /q "%TEMP_UNPACK%" >nul 2>&1

:end
echo "Done!"
pause
start /b %cd%\\Libertica.exe
exit 0
endlocal