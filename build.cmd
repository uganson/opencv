@echo off
rem build <compiler_version> <platform> <build_type>
if (%1) == () goto usage
if (%2) == () goto usage
if (%3) == () goto usage
rem if not (%4) == () goto usage

if "%2" == "Win32" (
   set platform1=x86
   set platform2=Win32
) else (
   if "%2" == "x64" (
      set platform1=amd64
      set platform2=x64
   ) else (
      echo Unknown platform: %2
      goto usage
   )
)

if "%3" == "Debug" (
   set type=Debug
) else (
   if "%3" == "Release" (
      set type=Release
   ) else (
      echo Unknown build type: %3
      goto usage
   )
)

if "%1" == "10" (
   set version=10
) else (
   if "%1" == "11" (
      set version=11
   ) else (
      echo Unsupported compiler version: %1
      goto usage
   )
)

set flags=%4

set solution=bin-vc%version%-%platform2%\OpenCV.sln
if not exist %solution% (
   echo.
   echo Solution file %solution% not found. Skipping compilation of OpenCV ^(VC%version%, %platform2%, %type%^)
   echo.
   goto end
)

echo.
echo Building OpenCV ^(VC%version%, %platform2%, %type%^)...
echo.

Title=CV ^(VC%version%, %platform2%, %type%^) building ... 

set programfiles32="%programfiles(x86)%"
if %programfiles32%=="" (
   set program="%programfiles%\Microsoft Visual Studio %version%.0\VC\vcvarsall.bat"
) else (
   set program="%programfiles(x86)%\Microsoft Visual Studio %version%.0\VC\vcvarsall.bat"
)

if not exist %program% (
   echo Visual Studio not found. Skipping compilation.
   goto end
)

set path_backup=%PATH%
set include_backup=%INCLUDE%
call %program% %platform1%
if errorlevel 1 (
   call :vcvarsclean
   Title=ERROR calling Visual Studio tools
   echo Error calling Visual Studio tools
   goto end
)

msbuild %solution% /m /p:Configuration=%type% /p:Platform=%platform2%

if errorlevel 1 (
   call :vcvarsclean
   Title=ERROR ^(VC%version%, %platform2%, %type%^) in OpenCV build.
   echo Error compiling OpenCV ^(VC%version%, %type%, %platform2%^)
   if not "%flags%" == "nopause" (
      pause
   )
   exit /b 1
) else (
   call :vcvarsclean
   Title=DONE ^(VC%version%, %platform2%, %type%^) building OpenCV.
   echo Compiled OpenCV ^(VC%version%, %type%, %platform2%^)
   if not "%flags%" == "nopause" (
      pause
   )
   exit /b 0
)

if not "%flags%" == "nopause" (
   pause
)

goto end

:vcvarsclean

set CommandPromptType=
set ExtensionSdkDir=
set Framework35Version=
set FrameworkDir=
set FrameworkDIR64=
set FrameworkVersion=
set FrameworkVersion64=
set FSHARPINSTALLDIR=
set Platform=
set VCInstallDir=
set VisualStudioVersion=
set VSINSTALLDIR=
set WindowsSdkDir=C:\Program Files (x86)\Windows Kits\8.0\
set WindowsSdkDir_35=C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\Bin\
set WindowsSdkDir_old=C:\Program Files (x86)\Microsoft SDKs\Windows\v8.0A\ 

set PATH=%path_backup%
set INCLUDE=%include_backup%

goto end

:usage

echo.
echo usage: build ^<compiler_version^> ^<platform^> ^<build_type^>
echo     compiler_version   10^|11
echo     platform           Win32^|x64
echo     build_type         Debug^|Release
echo.

:end

