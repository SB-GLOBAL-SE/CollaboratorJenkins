REM @echo off

REM echo "Task 1"
REM tasklist

REM echo "***************************************************************************************************"

REM echo "Task 2"
REM ipconfig

echo "Running" >> JenkinsTest.log
date /T >> JenkinsTest.log
time /T >> JenkinsTest.log

REM Create Temporary Directory and copy files for testing.
mkdir c:\GitJenkins\Temp
copy C:\SCM\GitJenkins\Main.java C:\GitJenkins\Temp

REM Test compile .java file
javac C:\GitJenkins\Temp\Main.java > C:\SCM\GitJenkins\compileOut.txt 2>&1

REM Run Static Analysis using PMD on .java file
REM C:\PMD\bin\pmd.bat -d C:\GitJenkins\Temp\Main.java -f text -R rulesets/java/quickstart.xml > C:\GitJenkins\Temp\PMDOut.txt 2>&1
cmd /c "C:\PMD\bin\pmd.bat -d C:\GitJenkins\Temp\Main.java -f text -R rulesets/java/quickstart.xml -failOnViolation false" > C:\SCM\GitJenkins\staticOut.txt 2>&1


REM Set the login credentials
"c:\Program Files\Collaborator Client 12201\ccollab.exe" login http://127.0.0.1:8080 melgage melgage

REM Create a "New Review"
"c:\Program Files\Collaborator Client 12201\ccollab.exe" --no-browser admin review create --creator melgage --title "Main.java Review" --template Default

REM Attach Code file changes
"c:\Program Files\Collaborator Client 12201\ccollab.exe" --non-interactive addchanges last C:\SCM\GitJenkins\Main.java

REM Attach an external compile report
"c:\Program Files\Collaborator Client 12201\ccollab.exe" --non-interactive addchanges last C:\SCM\GitJenkins\compileOut.txt
REM Attach an external linting report
"c:\Program Files\Collaborator Client 12201\ccollab.exe" --non-interactive addchanges last C:\SCM\GitJenkins\staticOut.txt

REM Clean up temporary files
del /f /q /s C:\GitJenkins\Temp\*.* > NUL
rmdir /q /s C:\GitJenkins\Temp
rmdir /q /s C:\GitJenkins


REM pause
REM cmd /K
