REM @echo off

REM echo "Task 1"
REM tasklist

REM echo "***************************************************************************************************"

REM echo "Task 2"
REM ipconfig
REM echo "JenkinsBatTest.bat <CollabHost> <user> <password> <outPutPath> "


SET sourcePath=
SET outputPath=
SET melJenkins=
SET pmdBin=C:\PMD\bin
SET host=
SET user=
SET password=
SET collabclient = ccollab

:set_default 
SET melJenkins = C:\GitJenkins
SET sourcePath = %melJenkins%Temp
SET outputPath = C:\SCM\GitJenkins
SET user = melgage
SET password = melgage
SET host = http://127.0.0.1:8080
SET collabclient = "c:\Program Files\Collaborator Client 12201\ccollab.exe"
echo The value of sourcePath is %sourcePath% 
echo The value of outputPath is %outputPath% 
EXIT /B 0

:set_env
SET sourcePath = %~dp0
SET outputPath = %4%
SET user = %2%
SET password = %4%
SET host = %1%
echo The value of sourcePath is %sourcePath% 
echo The value of outputPath is %outputPath% 
EXIT /B 0

:cleanup
REM Clean up temporary files
del /f /q /s %sourcePath%\*.* > NUL
rmdir /q /s %sourcePath%
rmdir /q /s C:\GitJenkins
EXIT /B 0


if [%1%]==[] ( call :set_default ) ELSE (call :set_env )
echo "Running" >> JenkinsTest.log
date /T >> JenkinsTest.log
time /T >> JenkinsTest.log

REM Create Temporary Directory and copy files for testing.
mkdir %sourcePath%
copy %outputPath%\Main.java %sourcePath%

REM Test compile .java file
javac %sourcePath%\Main.java > %outputPath%\compileOut.txt 2>&1

REM Run Static Analysis using PMD on .java file
REM C:\PMD\bin\pmd.bat -d %sourcePath%\Main.java -f text -R rulesets/java/quickstart.xml > %sourcePath%\PMDOut.txt 2>&1
cmd /c "%pmdBin%\pmd.bat -d %sourcePath%\Main.java -f text -R rulesets/java/quickstart.xml -failOnViolation false" > %outputPath%\staticOut.txt 2>&1


REM Set the login credentials
%collabClient% login %host% %user% %password%

REM Create a "New Review"
%collabClient% --no-browser admin review create --creator %user% --title "Main.java Review" --template Default

REM Attach Code file changes
%collabClient% --non-interactive addchanges last %outputPath%\Main.java

REM Attach an external compile report
%collabClient% --non-interactive addchanges last %outputPath%\compileOut.txt
REM Attach an external linting report
%collabClient% --non-interactive addchanges last %outputPath%\staticOut.txt



if [%1%]==[] ( call :cleanup )

REM pause
REM cmd /K
