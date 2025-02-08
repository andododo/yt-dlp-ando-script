@echo off
setlocal enabledelayedexpansion

:: Step 1: Change directory to Downloads
cd %USERPROFILE%\Downloads

:: Step 2: Create a folder with date and time
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set "datetime=%datetime:~0,8%_%datetime:~8,6%"
set "folder=yt-dlp_%datetime%"
mkdir %folder%

:: Step 3: Change directory to the folder
cd %folder%

:: Step 4: Get YouTube URL from user
set /p url="Enter YouTube URL: "

:: Run yt-dlp command the outputs a list of formats (-F)
yt-dlp -F %url%

:: Step 5: Get quality selection from user
:quality_selection
echo Select video quality:
echo [1] 144p
echo [2] 240p
echo [3] 360p
echo [4] 480p
echo [5] 720p
echo [6] 1080p
echo [7] 1440p
echo [8] 2160p
echo [9] Best
set /p quality_choice="Enter the number of your choice: "

:: Validate input
set "valid_input=false"
for %%i in (1 2 3 4 5 6 7 8 9) do (
    if "%quality_choice%"=="%%i" set "valid_input=true"
)

if "%valid_input%"=="true" (
    if "%quality_choice%"=="1" set "quality=144"
    if "%quality_choice%"=="2" set "quality=240"
    if "%quality_choice%"=="3" set "quality=360"
    if "%quality_choice%"=="4" set "quality=480"
    if "%quality_choice%"=="5" set "quality=720"
    if "%quality_choice%"=="6" set "quality=1080"
    if "%quality_choice%"=="7" set "quality=1440"
    if "%quality_choice%"=="8" set "quality=2160"
    if "%quality_choice%"=="9" set "quality=2160"
) else (
    echo Invalid selection. Please choose a number between 1 and 9.
    goto quality_selection
)

:: Run yt-dlp command with selected quality
yt-dlp -f "bv[height=!quality!][vcodec*=avc][protocol*=https]+ba[acodec*=mp] / bv[height=!quality!][vcodec*=av01]+ba[acodec*=mp] / bv[height=!quality!][vcodec*=vp]+ba[acodec*=mp] / bv[height<=!quality!][vcodec*=avc][protocol*=https]+ba[acodec*=mp]" %url%

:end
echo.
echo Press Enter to exit...
pause >nul