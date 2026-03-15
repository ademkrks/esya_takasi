@echo off
setlocal

set "PROJECT_ROOT=%~dp0"
if "%PROJECT_ROOT:~-1%"=="\" set "PROJECT_ROOT=%PROJECT_ROOT:~0,-1%"

set "FLUTTER_CMD="
where flutter.bat >NUL 2>&1 && set "FLUTTER_CMD=flutter.bat"
if not defined FLUTTER_CMD (
    echo.
    echo ERROR: flutter.bat was not found in PATH.
    echo.
    exit /b 1
)

if defined FLUTTERW_ASCII_REMAP goto runFlutter
call :remapProjectRoot %*
exit /b %ERRORLEVEL%

:runFlutter
pushd "%ASCII_DRIVE%\" >NUL
call %FLUTTER_CMD% %*
set "FLUTTERW_EXIT=%ERRORLEVEL%"
popd >NUL
exit /b %FLUTTERW_EXIT%

:remapProjectRoot
set "FLUTTERW_ASCII_REMAP=1"

for %%D in (Z Y X W V U T S R Q P O N M L K J) do (
    subst %%D: "%PROJECT_ROOT%" >NUL 2>&1
    if not errorlevel 1 (
        set "ASCII_DRIVE=%%D:"
        goto remapReady
    )
)

echo.
echo ERROR: Could not create a temporary ASCII drive mapping for Flutter.
echo.
exit /b 1

:remapReady
call "%PROJECT_ROOT%\flutterw.bat" %*
set "FLUTTERW_EXIT=%ERRORLEVEL%"
subst %ASCII_DRIVE% /d >NUL 2>&1
exit /b %FLUTTERW_EXIT%
