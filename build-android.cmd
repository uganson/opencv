@echo off
Title=Building OpenCV SVN Android
if exist "android\scripts\wincfg.cmd" (
   call "android\scripts\cmake_android.cmd"
) else (
   echo Skipping android compilation.
   echo Please edit the configuration file:
   echo  android\scripts\wincfg.cmd
)
if errorlevel 1 (
   echo Error compiling
   pause
   exit /b 1
) else (
   echo Compiled OK
   if "%1" == "nopause" (
      rem ok
   ) else (
      pause
   )
   exit /b 0
)
