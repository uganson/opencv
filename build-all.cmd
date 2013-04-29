@echo off
call build 10 Win32 Debug nopause
if errorlevel 1 goto error
call build 10 Win32 Release nopause
if errorlevel 1 goto error
call build 10 x64 Debug nopause
if errorlevel 1 goto error
call build 10 x64 Release nopause
if errorlevel 1 goto error

call build 11 Win32 Debug nopause
if errorlevel 1 goto error
call build 11 Win32 Release nopause
if errorlevel 1 goto error
call build 11 x64 Debug nopause
if errorlevel 1 goto error
call build 11 x64 Release nopause
if errorlevel 1 goto error

goto end

:error
echo ERROR
pause
exit /b 1

:end
echo DONE
Title=DONE
pause
exit /b 0

