@echo off
rem Universal script launcher
rem
rem Originally written 2009 by Tomasz M. Trzeciak
rem Public Domain

rem Make environment changes local
setlocal enableextensions disabledelayedexpansion
rem Get program/script name
if not defined TL_PROGNAME set TL_PROGNAME=%~n0
rem Check if this is 'sys' version of program
set TEX_SYS_PROG=
if /i "%TL_PROGNAME:~-4%"=="-sys" (
  set TL_PROGNAME=%TL_PROGNAME:~0,-4%
  set TEX_SYS_PROG=true
)

rem Reset command to execute
set CMD_LN=
set ERROR_MSG=
rem Make sure our dir is on the search path; avoid trailing backslash
set TL_ROOT=%~dp0?
set TL_ROOT=%TL_ROOT:\bin\win32\?=%
path %TL_ROOT%\bin\win32;%path%
rem Check for kpsewhich availability
if not exist "%TL_ROOT%\bin\win32\kpsewhich.exe" (
  echo %~nx0: kpsewhich not found: "%~dp0kpsewhich.exe">&2
  exit /b 1
)
rem Ask kpsewhich about root and texmfsys trees (the first line of output)
rem and location of the script (the second line of output)
rem (4NT shell acts wierd with 'if' statements in a 'for' loop,
rem so better process this output further in a subroutine)
for /f "tokens=1-2 delims=;" %%I in (
  'call "%~dp0kpsewhich.exe" --expand-var "$TEXMFSYSCONFIG/?;$TEXMFSYSVAR/?" --format texmfscripts ^
  "%TL_PROGNAME%.pl" "%TL_PROGNAME%.lua" "%TL_PROGNAME%.tlu" "%TL_PROGNAME%.rb" ^
  "%TL_PROGNAME%.py" "%TL_PROGNAME%.bat" "%TL_PROGNAME%.cmd" "%TL_PROGNAME%"'
) do (
  call :setcmdenv "%%~I" "%%~J"
  if defined CMD_LN goto :doit
)
if not defined ERROR_MSG set ERROR_MSG=no appropriate script or program found: %TL_PROGNAME%
echo %~nx0: %ERROR_MSG%>&2
exit /b 1

:doit
rem Unset program name variable and execute the command
set TL_PROGNAME=
%CMD_LN% %*
rem Finish with goto :eof (it will preserve the last errorlevel)
goto :eof

REM SUBROUTINES

:setcmdenv selfautoparent texmfsysconfig texmfsysvar
rem If there is only one argument it must be a script name
if "%~2"=="" goto :setcmd
rem Otherwise, it is the first line from kpsewhich, so to set up the environment
set PERL5LIB=%TL_ROOT%\tlpkg\tlperl\lib
set GS_LIB=%TL_ROOT%\tlpkg\tlgs\lib;%TL_ROOT%\tlpkg\tlgs\fonts
path %TL_ROOT%\tlpkg\tlgs\bin;%TL_ROOT%\tlpkg\tlperl\bin;%TL_ROOT%\tlpkg\installer;%TL_ROOT%\tlpkg\installer\wget;%path%
if not defined TEX_SYS_PROG goto :eof
rem Extra stuff for sys version
set TEXMFCONFIG=%~1
set TEXMFCONFIG=%TEXMFCONFIG:/?=%
set TEXMFVAR=%~2
set TEXMFVAR=%TEXMFVAR:/?=%
rem For sys version we might have an executable in the bin dir, so check for it
if exist "%TL_ROOT%\bin\win32\%TL_PROGNAME%.exe" set CMD_LN="%TL_ROOT%\bin\win32\%TL_PROGNAME%.exe"
goto :eof

:setcmd script
rem Set command based on the script extension
if /i "%~x1"==".bat" set CMD_LN=call "%~f1"
if /i "%~x1"==".cmd" set CMD_LN=call "%~f1"
if /i "%~x1"==".pl"  set CMD_LN="%TL_ROOT%\tlpkg\tlperl\bin\perl.exe" "%~f1"
if /i "%~x1"==".lua" set CMD_LN="%TL_ROOT%\bin\win32\texlua.exe" "%~f1"
if /i "%~x1"==".tlu" set CMD_LN="%TL_ROOT%\bin\win32\texlua.exe" "%~f1"
if defined CMD_LN goto :eof
rem For other scripts we also check if their interpreter is available
if /i "%~x1"==".rb"  set CMD_LN=#!ruby
if /i "%~x1"==".py"  set CMD_LN=#!python
rem For script w/o extension check its first line for #!
if "%~x1"=="" set /p CMD_LN=<"%~f1"
if not "%CMD_LN:~0,2%"=="#!" goto :noshebang
call :shebang %CMD_LN:~2%
if not defined CMD_LN goto :noshebang
for %%I in (%CMD_LN%) do set CMD_LN=%%~$PATH:I
if not defined CMD_LN goto :cmdnotfound
set CMD_LN="%CMD_LN%" "%~f1"
exit /b 0

:noshebang
set ERROR_MSG=don't know how to execute script: "%~f1"
set CMD_LN=
exit /b 1

:cmdnotfound
set ERROR_MSG=interpreter program not found (not distributed with TeX Live): %CMD_LN%
set CMD_LN=
exit /b 1

:shebang program [program]
rem Only the two most common cases are considered:
rem #!/path/to/program
rem #!/usr/bin/env program
set CMD_LN=%~n1.exe
if /i "%CMD_LN%"=="env" set CMD_LN=%~n2.exe
goto :eof
