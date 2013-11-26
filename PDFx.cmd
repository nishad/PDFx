echo off
set version=1.3.1
TITLE Lime PDFx Utility

REM Here we set paths for portable use
set TMP=%~dp0temp
set TEMP=%~dp0temp
Set path=%~dp0bin;%~dp0bin\ImageMagick;%~dp0bin\Tesseract\;%~dp0bin\ScanTailor\
Set TESSDATA_PREFIX=%~dp0bin\Tesseract\
Set MAGICK_HOME=%~dp0bin\ImageMagick
Set MAGICK_CONFIGURE_PATH=%~dp0bin\ImageMagick\config
Set MAGICK_CODER_FILTER_PATH=%~dp0bin\ImageMagick\modules\filters
Set MAGICK_CODER_MODULE_PATH=%~dp0bin\ImageMagick\modules\coders
Set LD_LIBRARY_PATH=%~dp0bin\ImageMagick

REM Here we show our branding stuff
cls
echo ________________________________________________________________________________
chgcolor A
echoj $09 
chgcolor f9
echoj " PDFx  %version% "
chgcolor B 
echoj " PDF Creator Application for Windows" $0a $0a
chgcolor A
echoj $09 "Created for Dyuthi Project of CUSAT. Relesed under GNU GPL v3" $0a
echoj $09 "(c) 2013 Lime Consultants [www.limeconsultants.com]" $0a $0a
chgcolor D
echoj $09 "Put your scanTailor project file or processed TIF files" $0a $09 "insie 'in' folder. PDFx will automatically create your PDF file"  $0a $09 "with or without OCR inside 'out' folder." $0a
chgcolor 7
echo ________________________________________________________________________________
echo.

REM Here we create directories, if they don't exist
IF NOT EXIST "%~dp0in" MKDIR "%~dp0in"
IF NOT EXIST "%~dp0completed" MKDIR "%~dp0completed"
IF NOT EXIST "%~dp0out" MKDIR "%~dp0out"
IF NOT EXIST "%~dp0log" MKDIR "%~dp0log"
IF NOT EXIST "%~dp0temp" MKDIR "%~dp0temp"

goto menu


:menu
  ECHO.
  ECHO 1 - Pre or Post ScanTailor and PDF Creation with OCR
  ECHO 2 - Pre or Post ScanTailor and PDF Creation without OCR
  ECHO 3 - Quit PDFx Utility

  ECHO.
  SET /P M=Type 1, 2, or 3 then press ENTER : 
  IF (%M%) == () GOTO menuerror
  IF %M%==1 GOTO dometa
  IF %M%==2 GOTO dometa
  IF %M%==3 GOTO killme
  IF DEFINED (%M%) GOTO menuerror
  
REM Title, Author, Subject, and Keywords
:dometa
  chgcolor B
  echoj $0a "Enter Metadata for PDF File" $0a 
  chgcolor 7
  SET /P ptitle=Enter Title : 
  SET /P pautor=Enter Author : 
  SET /P psubject=Enter Subject : 
  SET /P pkwds=Enter Keywords : 

  cd %~dp0in
  echo Title^: ^"%ptitle%^" >  metadata.txt
  echo Author^: ^"%pautor%^" >>  metadata.txt
  echo Subject^: ^"%psubject%^" >>  metadata.txt
  echo Keywords^: ^"%pkwds%^" >>  metadata.txt
  echo Application^: ^"Lime PDFx %version%^" >>  metadata.txt
  goto dost

REM Error entry in choice will be diverted to menu again
:menuerror
  echo. 
  chgcolor c
  echoj "You entered an invalid option" 
  chgcolor 7
  echo.
  goto menu


REM Here we do Scan Tailoring
:dost
  timer /nologo /q
  cd %~dp0in
  FOR %%a in (*.ScanTailor) DO (
    echoj $0a "Found %%a, started to process with ScanTailor" $0a
    scantailor-cli.exe -v %%a %~dp0in
    rmdir /S /Q cache
    echo.
  )
  IF %M%==2 GOTO dopdf
  goto setlang

REM Here we set language for OCR
:setlang
  chgcolor 7
  echoj "Select Language for OCR" 
  echo.
  tesseract.exe --list-langs
  echo.
  SET /P lang=Enter OCR Language code : 
  IF (%lang%) == () GOTO setlang
  IF NOT EXIST %~dp0bin\Tesseract\tessdata\%lang%.traineddata GOTO resetlang
  goto doocr

REM We Warn the user for non existing OCR language
:resetlang
  chgcolor c
  echoj "You entered a wrong language code" 
  chgcolor 7
  echo.
  GOTO setlang

REM Here we do OCR with tesseract
:doocr
  cd %~dp0in
  FOR %%a in (*.tif) DO (
    echoj $0a "Processing %%a with" $0a
    tesseract.exe -l %lang% %%a %%~na hocr
  )
  goto dopdf


REM Here we create PDF
:dopdf
  cd %~dp0in
  pdfbeads.exe --pagelayout SinglePage --meta metadata.txt *.tif > out.pdf
  move out.pdf %~dp0OUT > NUL 2>&1
  echo.
  cd %~dp0
  echo Process Completed, elapsed time is
  timer /nologo /s
  echo.
  goto dorename


REM Here we rename output pdf
:dorename
  SET /P fname=Enter File Name for PDF : 
  IF (%fname%) == () GOTO dorename 
  IF EXIST "OUT\%fname%.pdf" (
    echo.
    echo Filename Already exist, Please enter a new name
    GOTO dorename 
  ) ELSE (
    cd OUT
    ren "out.pdf" "%fname%.pdf"
    cd %~dp0
    mkdir "COMPLETED\%fname%"
    move /Y %~dp0IN\*.tif "COMPLETED\%fname%" > NUL 2>&1
    move /Y %~dp0IN\*.ScanTailor "COMPLETED\%fname%" > NUL 2>&1
    cd %~dp0IN
    FOR %%A IN (*.*) DO DEL /F %%A
    goto doend
  )


REM Here we finish the process.
:doend
  echo.
  busybox rm -r %~dp0temp
  cd ..
  echo.
  pause
  
REM Kill the app without confirmation
:killme
  exit
  