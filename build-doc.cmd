@echo off
Title=Building OpenCV SVN x64 Release
call "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" amd64
msbuild bin-vc10-x64\doc\html_docs.vcxproj /p:Configuration=Debug 
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

