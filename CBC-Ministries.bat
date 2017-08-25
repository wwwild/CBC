
@ECHO OFF

TITLE CBC Ministries

echo "INFO - Beginning CBC ministry generation process."

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
   echo INFO - cbcofconcrete.org is responding; continuing with CBC sermon process.
   echo " "
)

CALL build.bat -f build.xml generate_ministries

echo "INFO - Done with the CBC ministry generation process."

REM <end>