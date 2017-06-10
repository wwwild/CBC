This is a set of files to automate maintaining the CBC media web page (http://cbcofconcrete.org/cbcmedia.html) from a CD-ROM or MP3 file.  
  
# Table of Contents  
  
1. Introduction  
1. Required software & installation  
    1. Validating your software installation  
1. Using the software  
    1. Normal weekly sermon process  
        1. Process description  
        1. Committing changes to GitHub  
    1. Once a year setup  
    1. Important notes  
1. Issues and Debugging  
    1. Installation issues  
    1. Runtime issues  
      1. FTP failures  
      1. Validation and other failures  
    1. Resolving multiple sermon files  
1. Limitations  
1. TODOs  
1. Weekly sermon process sample output  
  
  
# Introduction  
  
This set of directories and files represents an automated system for maintaining the CBC media web page; i.e., the sermon web page.  The rest of the www.cbcofconcrete.org web pages are outside the scope of this automation.  
  
This automation is implemented with free, open source software.  This automation has been developed on Windows, but should be portable to other operating systems that support Java (e.g. Mac OS, Linux), etc.; however, Windows-specific files (like .bat scripts) would need to be converted to be compatible with the target operating system. Unfortunately, the openness of this software raises some technical issues, mainly that over time the various versions are updated, creating dependencies, etc.  These are discussed below.  
  
  
# Required software & installation  
  
  
  * GitHub - the CBC script software is stored publicly on GitHub and you can use the GitHub desktop client to access the CBC scripts, which is available from https://desktop.github.com/.  (However, if you just want to view the script code to see what's there you can use a browser with this URL: https://github.com/wwwild/CBC.git) 
    * Click the appropriate download link (**ensure it is GitHubDesktopSetup, NOT GitHubSetup** - two entirely different applications; e.g. Download for Windows (64 bit).  
    * Save the file.  
    * Run the executable.  
    * After installation GitHub will start.  
    * Select `Create your free account.` if you don't already have a login; otherwise, select `Sign into GitHub.com`.  
    * Enter your credentials and and click `Continue`.  
    * Deselect the option to send usage information and click `Finish`.  
    * Once the GitHub desktop client starts:  
      * On the `Select a repository` screen click `Clone a repository`.  
      * In the `Clone a repository` dialog enter the URL https://github.com/wwwild/CBC.git and your local path (you can take the default or specify a location of your choosing via the `Choose...` button, in this case the location you select will have "\CBC" added to the end of it automatically, (for purposes of this documentation will assume a location of C:\aardvark\CBC) and click the `Clone` button. Cloning will take a few minutes.  
    * Copy the `CBC-Sermon-Desktop.bat` file, which is located in the CBC folder, to your Windows desktop.  
  
  
* **Java** - this is the foundation of these scripts as it is a prerequisite to Ant, jython, etc. If you already have a Java JDK installed on your computer (assuming it's a current version) you can ignore the remainder of this bullet.  
  * To confirm if a Java JDK (as opposed to just a JRE) is installed enter the following command at a command prompt:  
  > java -version  
  which should output something like ``java version "1.8..."``
  * As of this writing the current version of Java is 1.8. If necessary you should download and install the Java JDK from  http://www.oracle.com/technetwork/java/javase/downloads/index.html, click the `Downloads` tab and click the `Java Platform (JDK) Download` link, click the `Accept License Agreement` radio button and click the appropriate download for your platform.  Save the resulting file to your computer and execute it as appropriate. 
    * You will need to note the installation location of Java to later set the `JAVA_HOME` environment variable (see below).  
  
  
* **Ant** - this is the tool that runs the scripts. Generally you can use the latest version of Ant, but beginning with version 10.1 Java 1.8 is required; so, if your Java version is not at this level choose a lower, compatible version of Ant.  
    * Download Ant from: https://ant.apache.org/bindownload.cgi  
    * You will need to unzip the installation file to your target installation folder.  
    * Note the installation folder location for adding the Ant bin folder to the system `PATH` environment variable (e.g. if you unzip the Ant zip file to ``C:\Tools`` you would add ``c:\Tools\apache-ant-1.9.4\bin`` to the PATH) and for setting the `ANT_HOME` environment variable (see below). 
  
  
* **Jython** - this is Java implementation of the Python scripting language and is used to validate that a sermon date is a Sunday. 
    * Download Jython from http://www.jython.org/downloads.html using the Standalone Jar link, as of this writing the current version is 2.7.0. 
    * Place the jython jar file in the CBC folder created when you cloned the GitHub repository (e.g. ``C:\aardvark\CBC``), this is where you will be running the scripts from. 
    * The jar file is typically named with the version of the release it corresponds to (e.g. ``jython-standalone-2.7.0.jar``) and you must ensure that the reference in build.xml corresponds to that name; search for `TODO` in that file to find the location where the jar is referenced and change if necessary). 
  
  
* Ant and Jython require the following additional **Apache tools** (www.apache.org):  
  * **ant-contrib** (http://ant-contrib.sourceforge.net/)
      * Download the binary zip from https://sourceforge.net/projects/ant-contrib/files/ant-contrib/1.0b3/ant-contrib-1.0b3-bin.zip/download 
      * You must extract the ``ant-contrib-1.0b3.jar`` file and place it in the Ant lib folder (e.g. ``C:\Tools\apache-ant-1.9.4\lib``).  
  * **Apache_bsf**  
      * Download the binary zip (version 2.4.0) from https://commons.apache.org/proper/commons-bsf/download_bsf.cgi 
      * You must extract the bsf jar file from the zip and place it in the CBC folder created when you cloned the GitHub repository (e.g. ``C:\aardvark\CBC``). The jar file should be found in the lib folder of the zip.  
  * **Apache_commons_logging**  
      * Download the binary zip from https://commons.apache.org/proper/commons-logging/download_logging.cgi. 
      * You must extract the commons-logging jar file from the zip and place it in the CBC folder created when you cloned the GitHub repository. 
      * The jar file is typically named with the version of the release it corresponds to (e.g. ``commons-logging-1.2.jar``) and you must ensure that the reference in build.xml corresponds to that name; search for `TODO` in that file to find the location where the jar is referenced). 
  * **Apache_commons_net**  
      * Download the binary zip from https://commons.apache.org/proper/commons-net/download_net.cgi and place the resulting jar file in the Ant lib folder.  
      * Modify the `CLASSPATH` variable in build.bat (in the CBC folder, e.g. ``C:\aardvark\CBC``) if necessary; that is, the jar file is typically named with the version of the release it corresponds to (e.g. ``commons-net-3.6.jar``) and you must ensure that the reference in build.bat corresponds to that name.  
  
* Local customizations - Before using the CBC scripts you need to setup local customizations:  
    * Create a SetEnvironment.bat file in the CBC folder created when you cloned the GitHub repository (e.g. C:\aardvark\CBC).  This file will set environment variables that are required by the scripts.  **This file should not be checked into GitHub** (which is why it's in the .gitignore file).  Make note of the comments (REM) in the sample below and use it to create your SetEnvironment.bat file:  
```
 REM This value of ANT_HOME is using the example from the steps above:  
 @SET ANT_HOME=c:\Tools\apache-ant-1.9.4  
  
 REM You can use this setting as-is:  
 @SET PATH=%PATH%;%ANT_HOME%\bin  
  
 REM Set the value of JAVA_HOME as per the installation location; e.g.:
 @SET JAVA_HOME=C:\Program Files\Java\jdk1.8.0_131
  
 REM Set the value of CBC_HOME to the CBC folder created when you cloned the GitHub repository  
 @SET CBC_HOME=C:\aardvark\CBC  
  
 REM Note the substitutions you must make to these values: 
 @set FTP_USERID=`<replace with the userid for the cbcofconcrete server>`  
 @set FTP_PASSWORD=`<replace with the password for the cbcofconcrete server>`  
```
    * Set the ``CBC_HOME`` environment variable  
      * Right click `This PC` and select `Properties`  
      * Select `Advanced system settings`  
      * Click the `Environment Variables...` button  
      * In the `User variables` section click the `New...` button  
      * Enter ``CBC_HOME`` in the `Variable name:` field and the fully qualified path (e.g. ``C:\aardvark\CBC``) in the `Variable value` field  
      * Click OK three times to save the changes and close the resulting dialog boxes.
  
## Validating your software installation  
  
To confirm you have successfully installed the software follow these steps (expected output shown):  
1. Open a Windows Command Processor window (a.k.a a DOS command prompt) via the Windows Start button.  
2. Go to the directory where you've setup the GitHub repository; e.g. 
> cd c:\aardvark\CBC  
3. Set the required environment variables by typing `SetEnvironment.bat` and pressing enter:
> SetEnvironment.bat  
4. Run: 
> build -p  
  
This is the expected output:  
> Buildfile: c:\CBC\build.xml  
>  
> Main targets:  
>  
> ftp_file          FTP a file to the CBC server (called by weekly_sermon).  
>                   For example: build ftp_file -Dftp.file=ServerFiles/cbcserm09.02.2012.mp3 -Dftp.binary.mode=true  
>                   You must specify credentials via env. vars. FTP_USERID and FTP_PASSWORD  
> modify_html_file  Modify the cbcmedia.html file for a weekly sermon (called by weekly_sermon).  
> weekly_sermon     Copy MP3 file, update HTML, and FTP to web site.  
> year_change       At year change rename cbcmedia.html and create a new file.  
>Default target: help  
  
If this is not the output you get review error and correct (e.g. missing env. var., etc.).  
  
  
# Using the software  
  
  
There are two typical use cases:  
1. Normal weekly sermon process  
2. Once a year  
  
There are variations on the above in the event of errors; e.g. the server is down.  These are covered below under "Issues and debugging".  
  
  
## Normal weekly sermon process  
  
Normally, if you're the only one working on the CBC site you won't have to worry about anyone else's changes; but, to be sure you should fetch the latest changes before starting the process:  
1. Start the GitHub Desktop via the Windows Start button.  
2. Use the "Fetch origin" button on the upper right to ensure your environment has the latest changes.  
  
  
This remainder of the process copies the sermon MP3 file, updates the HTML file, and FTPs the files to the server. For this process you need to have:  
* The weekly service MP3 file on the CBC-supplied memory stick; insert this into a USB port.  
* The sermon information:  
  * Sermon title  
  * Bible passage  
  * Speaker, which defaults to Rob.  
  
  
To run the process double click the CBC-Sermon-Desktop.bat file (shortcut) on your Windows desktop and follow the prompts.  
  
  
Assumptions and defaults:  
1. The CBC memory stick inserted into a USB port will map to Windows drive E: - if this is not the case you can specify an alternate drive letter at the "RESPOND - Input the memory stick drive letter - press enter to accept the default: [E:]" prompt; e.g. G: (confirm the drive mapping with Windows Explorer).  
2. The newest MP3 file on the memory stick is the one you want to process - if this is not the case (e.g. you missed a week) you can specify an alternate filename, respond no to the prompt: "RESPOND - Is the following correct: Input file name=...." and then run this command:  
>   build weekly_sermon -Dlatest.mp3.file=FILENAME  

   where FILENAME is a fully qualified Windows file name; e.g. E:\170521_0316.mp3; note, you will not be prompted for the memory stick drive letter, which is why FILENAME must be fully qualified.  
3. Assumption: The MP3 file name on the memory stick is named using the pattern: YYMMDD_NNNN.mp3, where:  
  * YY = the two digit year  
  * MM = the two digit month  
  * YY = the two digit day  
  * NNNN = a four digit sequence number  
  * _ and .mp3 are invariant, as-is.  
   If the input file name does not follow this mapping you must respond no to the prompt: "RESPOND - Is the following correct: Input file name=...." and then run this command:  
>   build weekly_sermon -Dcbc.sermon.year=YY -Dcbc.sermon.month=MM -Dcbc.sermon.day=DD (where YY, MM, YY are as per the patterns above.)  
  
**Note:** The alternate processing for numbers two and three above can be combined; e.g.: build weekly_sermon -Dlatest.mp3.file=E:\170507_0313.mp3 -Dcbc.sermon.year=17 -Dcbc.sermon.month=05 -Dcbc.sermon.day=21  
  
  
  
### Process description  
  
  
1. CBC-Sermon-Desktop.bat is a convenience script to start the process from the Windows desktop, which:  
   A. Invokes %CBC_HOME%\CBC-Sermon.bat (which needs to be set in your system environment variables)  
2. CBC-Sermon.bat invokes:  
   A. Changes directory (cd) to %CBC_HOME% (which needs to be set in your system environment variables)  
   B. Calls SetEnvironment.bat to set required environment variables (see installation notes above)  
   C. Calls build.bat is_server_up - to verify that cbcofconcrete.org is running before running the process; if not, the script fails, otherwise:  
   D. Calls build.bat -f build.xml weekly_sermon - runs the remainder of the process using these Ant targets:  
      1. get_sermon_file_name  
         a. Inputs the memory stick drive letter  
         b. Obtains the latest mp3 file on the memory stick.  
      2. parse_date_from_file  
         a. Parses the mp3 file name to extract the year, month, and day  
      3. weekly_sermon  
         a. verify_sunday - verifies (Jython) that the input date falls on a Sunday  
         b. Prompts to confirm the file name and date, which is an opportunity to terminate the process  
         c. modify_html_file -  
            i. Prompts for the sermon title, Bible passage and speaker  
            ii. Prompts to confirm the sermon information, which is an opportunity to terminate the process  
            iii. Backs up and modifies the cbcmedia.html file (Jython) with the input values  
         d. ftp_file - FTPs the mp3 file to the cbcofconcrete.org web server  
         e. ftp_File - FTPs the cbcmedia.html file to the cbcofconcrete.org web server  
  
  
### Commiting changes to GitHub  
  
  
Periodically (e.g. weekly, monthly, or quarterly) you should commit changes to GitHub so they are backed up and available for others to view. (Remember,  not all files - e.g. mp3 file - are stored in GitHub, so a backup would require pulling together GitHub and what's on cbcofconcrete.org. If you wanted to add the mp3 files to GitHub you would need to modify the .gitignore file to remove the line: ``*.mp3``)  You will use the GitHub desktop to push the changes to the server.  Typically the cbcmedia.html is the only file that will have changed.  
  
1. Start the GitHub Desktop via the Windows Start button.  
2. The Changes tab (on the left) will show you the changed files with the details of the changes on the right.  
3. In the Summary line (near bottom left) enter a change summary and a more detailed description in the Description control.  
4. Use the "Commit to master" button on the bottom left to commit the changes to your local environment.  
5. Use the "Push origin" button on the upper right to push the changes to the GitHub server.  
  
  
  
## Once a year setup  
  
This process takes the existing cbcmedia.html for the year (after you've entered the last sermon for the year), renames it, creates a new cbcmedia.html file and FTPs the file to the server.  
  
* To run the process type:  
> build year_change  
  
  
The script doesn't do this, but you may want to: I create a subdirectory in the ServerFiles folder of the old year (e.g. 2017) and copy all the old files from the previous year there.  
  
  
### Example output  
  
```
>C:\CBC>build year_change  
  
 C:\CBC>ant year_change  
 Buildfile: C:\CBC\build.xml  
  
 year_change:  
     [input] What is the old year? (2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025, 2026)  
 2012  
      [move] Moving 1 file to C:\CBC\ServerFiles  
      [copy] Copying 1 file to C:\CBC\ServerFiles  
    [script] Expected files and file structure found OK.  
      [copy] Copying 1 file to C:\CBC\ServerFiles  
  
 ftp_file:  
      [echo] Attempting to FTP file ServerFiles/cbcmedia2012.html (format binary=false) to cbcofconcrete.org...  
       [ftp] sending files  
       [ftp] transferring C:\CBC\ServerFiles\cbcmedia2012.html  
       [ftp] 1 files sent  
  
 ftp_file:  
      [echo] Attempting to FTP file ServerFiles/cbcmedia.html (format binary=false) to cbcofconcrete.org...  
       [ftp] sending files  
       [ftp] transferring C:\CBC\ServerFiles\cbcmedia.html  
       [ftp] 1 files sent  
  
 BUILD SUCCESSFUL  
 Total time: 33 seconds  
```
  
  
  
## Important notes  
  
1. Never edit the cbcmedia.html file manually unless you know what you are doing.  The ant regex processing depends on the format established there; so, if you mess anything up it will break the process.  
2. The scope of this scripting is just the cbcmedia.html file and none of the other cbcofconcrete.org site files.  Therefore, you should have your own backup of these files.  Also, to simplify things it is assumed that the mp3 files on the cbcofconcrete.org site are the authortative versions; so, again, you should have your own backups.  (We could consider adding these to GitHub, and not a bad idea, just hasn't been done.)  
3. Windows paths use backslashes, but the Ant/Java environment is quite happy with forward slashes.  I didn't take the time to make this consistent (my/this PC uses cygwin, which is also forward/backslash agnostic).  This could cause some angst/errors.  
  
  
  
# Issues and debugging  
  
  
## Installation issues  
  
 * If you only have a Java runtime (JRE) installed and not a full JDK installed (i.e. without JAVA_HOME set) you will see this error:  
>  Unable to locate tools.jar. Expected to find it in C:\Program Files\Java\jre7\lib\tools.jar  
  
To resolve this error you must install a Java JDK and set the JAVA_HOME environment variable to point to that location (see build.bat).  
 * Various errors may be caused by not properly copying the various jar files as per the installation files above.
  
  
## Runtime issues  
  
### FTP failures  

 * The FTP process should not fail (the CBC-Sermon.bat file pre-checks that the server is reachable), but in the unlikely event it does fail this is typical of the error you might see:  
>    BUILD FAILED  
>    C:\albatross\CBC\Web\build.xml:53: The following error occurred while executing this line:  
>    C:\albatross\CBC\Web\build.xml:162: error during FTP transfer: java.net.SocketException: Connection reset  
>    ...  
 * In this event you must rerun the FTP for each file until it completes successfully; e.g.:  
>    build ftp_file  -Dftp.binary.mode=true -Dftp.file=ServerFiles/cbcsermMM.DD.YYYY.mp3  
>    build ftp_file -Dftp.file=ServerFiles/cbcmedia.html  
 * If FTP login fails, ensure the environment variables - ``FTP_USERID`` and ``FTP_PASSWORD`` - are correct and do NOT have any trailing space(s) after the values.
 * Various FTP failures can occur due to Anti-virus software and their firewall settings and controls.  To confirm if this is the issue turn off the anti-virus firewall and run the ``build is_server_up`` command to confirm.  Some anti-virus software, like AVG, must be completely uninstalled to turn off its firewall controls.
  
  
### Validation and other failures  

There are a number of validations (e.g. date, file name) done by the script, which can cause the script to fail, requiring restarting:  
 * If the script fails with ``BUILD FAILED`` review the messages and take the appropriate action.  
 * The build could fail mid-stream - e.g. Windows update or by forced termination via Ctrl-C. In these cases it's best to be aware of where you are in the process as you may need to do some cleanup.  
 * Unfortunately, specific details of all possible error scenarios and recovery steps are beyond the scope of this document; however, these are some guidelines that can assist in recovery (note that the commands below depend on cygwin being installed):  
   - Enter the web page URL to confirm if the html page and mp3 files were copied to the server: http://cbcofconcrete.org/cbcmedia.html If the page shows up with your latest edits - sermon date, title, etc. - then you can confirm if the mp3 file copied successfully.  To confirm the mp3 file click its `Download` link; if the file plays then it's OK and you're done.  
   - If either file is not on the server - html page or mp3 file - confirm that they are on your local PC.  In a Windows shell (or you can use Windows Explorer), in your CBC GitHub folder enter (dependent on cygwin, but you can do the equivalent with Windows Explorer by sorting by date):  
>      ls -1at ServerFiles/*.mp3 | head -1  
   You will get output like this:  
>      ServerFiles/cbcserm04.16.2017.mp3  
   which should be the last file you worked with from the memory stick.  If it's not you must start over from the beginning.  
   - Each time the script is run a backup of the .html file is created before adding the new sermon.  This backup is in the CBC\ServerFiles folder.  If the backup exists with a matching date to the last sermon file you worked with then you know the script processed at least this far.  To check if the BACKUP file exists:  
>   ls -lat ServerFiles/cbcmedia.html-BACKUP* | head -1  
   You will get output like this:  
> -rwxrwx---+ 1 wwwild None 12416 Jun  9 18:48 ServerFiles/cbcmedia.html-BACKUP064830
   If the date of the backup file matches the date you ran the sermon update process you know the script got as far as creating the backup.  
   
   - Then to confirm if the most recent cbcmedia.html file was updated run this cygwin command:
> ls -at ServerFiles/cbcmedia.html-BACKUP* ServerFiles/cbcmedia.html | xargs diff
   If no output is produced then no editing has yet taken place against cbcmedia.html and you can simply run the process again; otherwise, you should be able to FTP the files as per the steps in "FTP failures". 
  
## Resolving multiple sermon files  
  
  
This used to be a more common issue when we had to process sermons via CD; however, it could possibly still happen that the technician has to restart the recording process and we wind up with more than one MP3 file, which need to be combined into a single file. Roughly, the steps are:  
 * You have Audacity installed (beyond the scope of this document).  
 * Open two Audacity Windows.  
 * In one Audacity window open the first MP3 file and:  
   * Click the track drop-down window and select Split Stero Track  
   * Close one of the two (X) tracks  
   * Click the track drop-down window and select Mono  
   * Edit->Select All  
   * Edit->Copy  
 * In the second Audacity window past the clipboard contents (Edit -> Paste).  
 * Close the MP3 file in the first window and open the next MP3 file, doing the same two edit steps as before.  
 * In the second Audacity window you need to position to the end to paste the new audio:  
   * Edit -> Select All  
   * Edit -> Move Cursor ... -> to Selection End  
   * Edit -> Paste  
 * Continue in this mode until you have processed all files.  
 * In the Audacity window with the amalgamated audio you can export this as an MP3 file (e.g. cbcsermMM.DD.YYYY.mp3)  
 * Then to continue the build script process:  
   * FTP the MP3 file to the server; e.g.:  
>    build ftp_file -Dftp.binary.mode=true -Dftp.file=ServerFiles/cbcsermMM.DD.YYYY.mp3  

   * Update the HTML page by running the script using the sample below, substituting the appropriate values; e.g.:  
    build modify_html_file -Dpyfile=cbcserm11.27.11.mp3 -Dpymonth=11 -Dpyday=27 -Dpyyear=11  
   * FTP the modified HTML file to the server; e.g.:  
>    build ftp_file -Dftp.file=ServerFiles/cbcmedia.html  
  
  
  
# Limitations  
  
  
The code is written to be as simple and flexible as is reasonable, but there are certain tradeoffs and limitations it may help you to be aware of. Namely:  
* The software was chosen because it's free and easy to code with (specifically Ant & jython).  
* Ant limits the structure of scripts such that you can pass parameters down, but never up (sorry, a technical issue, not worth explaining).  So, this means that the process and script had to structure things to optimize recovering from failures  So, the structure of the code and rerun pattern looks something like this:  
 * weekly_sermon - this runs all the necessary targets  
   * Obtaining of input values, input file and date, which you can verify and rerun if you get them wrong.  
   * modify_html_file - obtains the input values, sermon title, speaker, etc. and edits the cbcsermon.html file.  
   * ftp_file - called once for the mp3 file and once for the html file; again, the mp3 file can take several minutes.  
  
  
  
# TODOs  
  
* Clear steps, procedures for using GitHub.  
  
  
  
# Weekly sermon process sample output  
  
User inputs are in **bold**.  
  
```
c:\Alligator\CBC> **build weekly_sermon**  
  
 INFO - Confirming that cbcofconcrete.org is up before continuing...  
  
 Buildfile: c:\Alligator\CBC\build.xml  
  
 is_server_up:  
      [echo] INFO - Attempting to access cbcofconcrete.org FTP server...  
       [ftp] listing files  
       [ftp] 0 files listed  
    [delete] Deleting: c:\Alligator\CBC\listing.txt  
  
 BUILD SUCCESSFUL  
 Total time: 1 second  
  
 INFO - cbcofconcrete.org is responding; continuing with CBC sermon process.  
  
 Buildfile: c:\Alligator\CBC\build.xml  
  
 get_sermon_file_name:  
      [echo]  
     [input] RESPOND - Input the memory stick drive letter - press enter to accept the default: [E:]  
  **[press enter here]**
      [echo] INFO - Latest MP3 file is:  E:\170521_0316.mp3  
  
 parse_date_from_file:  
  
 weekly_sermon:  
  
 verify_sunday:  
    [script] INFO - Confirmed the specified date (05/21/17) is a Sunday.  
     [input] RESPOND - Is the following correct: Input file name=E:\170521_0316.mp3 / Date=05/21/17?  [Yy]es, [Nn]o (Yes, yes, Y, y, No, no, N, n)  
 **y**  
  
 abort_input_data:  
      [echo] INFO - This script will produce cbcserm05.21.2017 from input MP3 file E:\170521_0316.mp3.  
      [copy] Copying 1 file to c:\Alligator\CBC\ServerFiles  
      [copy] Copying E:\170521_0316.mp3 to c:\Alligator\CBC\ServerFiles\cbcserm05.21.2017.mp3  
  
 modify_html_file:  
      [echo] INFO - This script will add cbcserm05.21.2017.mp3 to cbcmedia.html.  
     [input] RESPOND - Input the sermon title:  
 **Brighten Your Witness For Christ**  
      [echo] INFO - The sermon title specified is:Brighten Your Witness For Christ.  
     [input] RESPOND - Input the Bible passage (e.g. 1Peter 1:3-5):  
 **Phillipians 2:14-16**  
      [echo] INFO - The sermon passage specified is:Phillipians 2:14-16.  
     [input] RESPOND - Input the speaker's name (default is: Pastor Rob Thomas): [Pastor Rob Thomas]  
 **Duane S.**  
      [echo] INFO - The speaker specified is: Duane S..  
     [input] RESPOND - Is the following correct: Title=Brighten Your Witness For Christ / Passage=Phillipians 2:14-16 / Speaker=Duane S.? [Yy]es, [Nn]o (Yes, yes, Y, y, No, no, N, n)  
 **y**  
  
 abort_sermon_data:  
      [copy] Copying 1 file to c:\Alligator\CBC\ServerFiles  
      [echo] INFO - HTML backup file is: ServerFiles/cbcmedia.html-BACKUP021129  
    [script] Processing cbcserm05.21.2017.mp3 to cbcmedia.html  
    [script] Expected files and file structure found OK.  
  
 ftp_file:  
      [echo] INFO - Attempting to FTP file ServerFiles/cbcserm05.21.2017.mp3 (format binary=true) to cbcofconcrete.org...  
       [ftp] sending files  
       [ftp] transferring c:\Alligator\CBC\ServerFiles\cbcserm05.21.2017.mp3  
       [ftp] 1 files sent  
  
 ftp_file:  
      [echo] INFO - Attempting to FTP file ServerFiles/cbcmedia.html (format binary=false) to cbcofconcrete.org...  
       [ftp] sending files  
       [ftp] transferring c:\Alligator\CBC\ServerFiles\cbcmedia.html  
       [ftp] 1 files sent  
  
 BUILD SUCCESSFUL  
 Total time: 9 minutes 17 seconds  
```

[end]  
