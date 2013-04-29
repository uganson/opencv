@echo off

set tbbversion=tbb41_20120718oss
set basedir=%~dp0..\..
set libdir=%basedir%\libraries

set versions=vc10 vc11
set platforms=Win32 x64

set programfiles32="%programfiles(x86)%"
if %programfiles32%=="" (
   set programfiles32="%programfiles%"
)

call :DeQuote programfiles32

set CMAKE="%programfiles32%\CMake 2.8\bin\cmake.exe"

if not exist bootstrap-config.cmd (
   echo rem Bootstrap configuration file. > bootstrap-config.cmd
   echo. >> bootstrap-config.cmd
   echo rem Uncomment and edit appropriate lines. >> bootstrap-config.cmd
   echo. >> bootstrap-config.cmd
   echo rem - cmake.exe location >> bootstrap-config.cmd
   echo rem set CMAKE=%CMAKE% >> bootstrap-config.cmd
   echo rem - TBB version >> bootstrap-config.cmd
   echo rem set tbbversion=%tbbversion% >> bootstrap-config.cmd
   echo rem - Base directory >> bootstrap-config.cmd
   echo rem set basedir=%basedir% >> bootstrap-config.cmd
   echo rem - Libraries directory >> bootstrap-config.cmd
   echo rem set libdir=^%basedir^%\libraries >> bootstrap-config.cmd
   echo rem - Versions to generate the config for >> bootstrap-config.cmd
   echo rem set versions=%versions% >> bootstrap-config.cmd
   echo rem - Platforms to generate the config for >> bootstrap-config.cmd
   echo rem set platforms=%platforms% >> bootstrap-config.cmd
   echo.
   echo Bootstrap config file generated. Edit the file and run bootstrap again
   goto finish
)

call bootstrap-config.cmd

if not exist %CMAKE% (
   echo CMake not found. Skipping compilation.
   goto finish
)

for %%G in (%versions%) do (
   for %%H in (%platforms%) do (
      call :folders %%G %%H
      if errorlevel 1 (
         echo.
         echo There was an error running CMAKE
         goto finish
      )
   )
)

echo.
echo All scripts generated correctly

Title=DONE

goto finish

rem subroutines

:folders

Title=CMAKE %1 %2

set folder=bin-%1-%2
set version=%1
set moreopts=
if "%1" == "vc10" (
   set versionnum=10
   set versionintel=vc10
) else (
   if "%1" == "vc11" (
      set versionnum=11
      set versionintel=vc10
      rem set moreopts=-D "CMAKE_CXX_FLAGS:STRING=/Dcopy_exception=make_exception_ptr"
   ) else (
      echo Unknown version: %1
      goto end
   )
)
if "%2" == "Win32" (
   set platformgen=
   set platformintel=ia32
) else (
   if "%2" == "x64" (
      set platformgen= Win64
      set platformintel=intel64
   ) else (
      echo Unknown platform: %2
      goto end
   )
)

set vsscript="%programfiles32%\Microsoft Visual Studio %versionnum%.0\VC\vcvarsall.bat"
if not exist %vsscript% (
   echo Visual Studio %versionnum% not found. Skipping compilation.
   goto end
)

set generator=Visual Studio %versionnum%%platformgen%

rem echo folder: %folder%
mkdir %folder% 2>nul
pushd %folder%
echo on
%CMAKE% %moreopts%^
  -D "BUILD_opencv_ts:BOOL=OFF" ^
  -D "WITH_TBB:BOOL=ON" ^
  -D "WITH_VIDEOINPUT:BOOL=OFF" ^
  -D "WITH_CUDA:BOOL=OFF" ^
  -D "WITH_IPP:BOOL=ON" ^
  -D "EIGEN_INCLUDE_PATH:PATH=%libdir%\Eigen.HG" ^
  -D "IPP_H_PATH:PATH=%basedir%\Intel\ComposerXE-2011\ipp\include" ^
  -D "TBB_INCLUDE_DIRS:PATH=%libdir%\%tbbversion%\include" ^
  -D "TBB_LIB_DIR:PATH=%libdir%\%tbbversion%\lib\%platformintel%\%versionintel%" ^
  -G "%generator%" ..
@echo off
popd

goto end

:DeQuote
for /f "delims=" %%A in ('echo %%%1%%') do set %1=%%~A
Goto :end

:finish
if not "%1"=="nopause" (
   pause
)
goto end

:end
