
@ECHO OFF

TITLE CBC End of Year Processing

echo "INFO - Beginning CBC end of year processing."
echo "       The last sermon for the year must have been processed before running this script."
set /p ANSWER="Do you want to continue? (y/n) "

if not "%ANSWER%" == "y" GOTO LEAVE


cd %CBC_HOME%

CALL SetEnvironment.bat

echo INFO - Confirming that cbcofconcrete.org is up before continuing...

CALL build.bat is_server_up
if errorlevel 1 (
   echo " "
   echo ERROR - CBC FTP server is not up; aborting: %errorlevel%
   echo ERROR - Try again later.
   exit /b %errorlevel%
) else (
   echo " "
   echo INFO - cbcofconcrete.org is responding; continuing with CBC end of year process.
   echo " "
)

CALL build.bat -f build.xml year_change  

echo "INFO - Done with the CBC end of year process."

exit /b

:LEAVE 

echo "INFO - Input was not y.  Leaving."


REM <end>