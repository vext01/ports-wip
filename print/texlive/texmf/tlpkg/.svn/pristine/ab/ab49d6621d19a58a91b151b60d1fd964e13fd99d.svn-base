@echo off
setlocal
if exist "%~dpn0" (
  set TLROOT=%~dp0..\..
  set TLPROG=%~dpn0
) else (
  set TLROOT=%~f0\..
  set TLPROG=%~dp0tlpkg\installer\%~n0
)
for %%I in ("%TLROOT%") do set TLROOT=%%~fI
rem set TLINSTALLERDIR=%TLROOT%\install-tl-20100317
rem set PERL5LIB=%TLROOT%\tlpkg
"%TLROOT%\tlpkg\tlperl\bin\perl.exe" "%TLPROG%" %*
pause
