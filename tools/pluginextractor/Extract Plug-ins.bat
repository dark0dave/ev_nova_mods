@echo off
if [%1]==[] (
	echo %~nx0:
	echo Extracts archives and converts files into .rez plug-ins for EV Nova.
	echo Drag and drop a file or folder onto "%~nx0" to process it.
	echo Supported file types: .zip .sit .sitx .hqx .bin .rsrc .ndat
	pause
	goto:eof
)
set lsar="%~dp0unar\lsar.exe"
set unar="%~dp0unar\unar.exe"
set macbin="%~dp0unar\macbinconv.exe"
set rez="%~dp0unar\rez.exe"
type nul > %temp%\tmp
call:main "%~1"
del %temp%\tmp
if exist %temp%\lsar.log del %temp%\lsar.log
echo Task complete.
pause
goto:eof

:main
if exist %1\ (
	for /d /r %1 %%f in (*.app) do (
		rmdir /s /q "%%f"
		echo Deleted "%%~nxf".
	)
	for /r %1 %%f in (.DS_Store* Icon_*) do del "%%f"
	for /r %1 %%f in (*.bin) do call:unar "%%f"
	for /r %1 %%f in (*.rsrc *.ndat) do call:binrez "%%f"
) else (
	for %%e in (.zip .sit .sitx .hqx .bin) do if /i "%~x1"=="%%e" call:unar %1
	for %%e in (.rsrc .ndat) do if /i "%~x1"=="%%e" call:binrez %1
)
goto:eof

:unar
echo Extracting "%~nx1" ...
%unar% %1 -o "%~dp1\"
%lsar% %1 -i 0 > %temp%\lsar.log
for /f "delims=" %%f in (%temp%\lsar.log) do set output=%~dp1%%f
set rsrc=%output:/=%.rsrc
if not exist "%rsrc%" if not exist "%output%" set output=%~dpn1\
if exist "%rsrc%" call:binrez "%rsrc%"
if exist "%output%" call:main "%output%"
goto:eof

:binrez
if not exist "%~dpn1\" for %%f in ("%~dpn1") do if %%~zf==0 del "%~dpn1"
if exist "%~dpn1" (
	del %1
	if not exist "%~dpn1\" echo Discarded resource fork of "%~n1".
	goto:eof
)
echo Converting "%~nx1" to MacBinary ...
if "%~x1"==".rsrc" set format=ad
if "%~x1"==".ndat" set format=dfrf
%macbin% -%format% %temp%\tmp %1 -mb "%~dp1tmp.bin"
if not exist "%~dp1tmp.bin" (
	echo Error converting to MacBinary.
	pause
	goto:eof
)
echo Converting MacBinary to .rez ...
%rez% "%~dp1tmp.bin" > nul
if exist "%~dp1tmp.rez" (
	del %1
	ren "%~dp1tmp.rez" "%~n1.rez"
	echo Successfully converted to "%~n1.rez".
) else (
	echo Error converting to .rez.
	pause
)
del "%~dp1tmp.bin"
goto:eof
