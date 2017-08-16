
@ECHO OFF

TITLE CBC End of Year Processing

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

REM <end>