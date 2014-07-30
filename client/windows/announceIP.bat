@echo off
setlocal

rem Defining name (and location) of the configuration file
set CONFIG_FILE=%~n0.cfg

rem Ensure existence of the configuration file
if not exist %CONFIG_FILE% (
    call :error Configuration File "%CONFIG_FILE%" not found! || exit /b 1
)

rem Load configuration values
for /f "usebackq delims=" %%x in (`findstr /B /R /I "[A-Z][A-Z]*=" %CONFIG_FILE%`) do (set "%%x")

rem Validate configuration values
if "%SERVER%"=="" call :error Configuration File does not configure SERVER! || exit /b 1
if "%CLIENT%"=="" call :error Configuration File does not configure CLIENT! || exit /b 1
if "%SECRET%"=="" call :error Configuration File does not configure SECRET! || exit /b 1
if "%WGET%"==""   call :error Configuration File does not configure WGET!   || exit /b 1


rem Determine own local IP address
for /f "skip=1 delims={}, " %%A in ('wmic nicconfig get ipaddress') do for /f "tokens=1" %%B in ("%%~A") do set "LOCAL_IP=%%~B"

rem echo *   SERVER = %SERVER%
rem echo *   CLIENT = %CLIENT%
rem echo *   SECRET = %SECRET%
rem echo * LOCAL_IP = %LOCAL_IP%

rem Build URI
set "URI=%SERVER%?CLIENT=%CLIENT%&SECRET=%SECRET%&LOCAL_IP=%LOCAL_IP%"

rem echo *       URI = %URI:&=^&%

rem Announce the IP to the Server
%WGET% "%URI%"

echo * done.

goto :eof




:error
    echo.
    echo ERROR! 1>&2
    echo %* 1>&2
    echo.
    exit /b 1
goto :eof