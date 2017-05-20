
Table of Contents

1. Introduction
2. Required software
   A. Validating your software installation
3. Using the software
   A. Normal weekly sermon process
   B. Once a year setup
   C. Important notes
4. Issues and Debugging
   A. Installation issues
   B. Runtime issues
   C. Resolving multiple sermon files
5. Limitations
6. TODOs


============
Introduction
============

This set of directories and files represents an automated system for maintaining the CBC media web page; i.e., the sermon web page.  The rest of the www.cbcofconcrete.org web pages are outside the scope of this automation.

This automation is implemented with free, open source software.  This automation has been developed on Windows, but should be portable to other operating systems that support Java (e.g. Mac OS, Linux); however, Windows-specific files (like .bat scripts) would need to be converted to be compatible with the target operating system. Unfortunately, the openness of this software raises some technical issues, mainly that over time the various versions are updated, creating dependencies, etc.  These are discussed below:


=================
Required software
=================
  
* GitHub - the script software is stored publicly on GitHub and it's easiest to use the desktop client to access the CBC scripts, which is available from https://desktop.github.com/.  (However, if you just want to view the script code to see what's there you can use this URL: https://github.com/wwwild/CBC.git) 

These are the steps for Windows (in this case Windows 7 and, unfortunately, they will vary for other Windows versions):
  * Click the appropriate download link; e.g. Download for Windows (64 bit).
  * Save the file.
  * Run the executable.
  * After installation GitHub starts.
  * Select "Create your free account." if you don't already have a login; otherwise, select "Sign into GitHub.com".
  * Enter your credentials and and click Continue.
  * Deselect the option to send usage information and click Finish.
  * Once the GitHub desktop client starts:
    * On the Select a repository screen click "Clone a repository".
    * In the "Clone a repository" dialog enter the URL https://github.com/wwwild/CBC.git and your local path (you can take the default or specify a location of your choosing via the Choose... button, in this case the location you select will have "\CBC" added to the end of it automatically) and click the Clone button. Cloning will take a few minutes.


* Java - this is the foundation of these scripts as it is a prerequisite to Ant, jython, etc. If you already have a Java JDK installed on your computer (assuming it's a current version) you can ignore the remainder of this bullet.  To confirm if Java is installed enter the following command at a command prompt:
java -version
As of this writing the current version of Java is 1.8. If necessary you should download and install the Java JDK from  http://www.oracle.com/technetwork/java/javase/downloads/index.html, click the Downloads tab and click the Java Platform (JDK) Download link, click the Accept License Agreement radio button and click the appropriate download for your platform.  Save the resulting file to your computer and execute it as appropriate. You will need to note the installation location of Java to later set the JAVA_HOME environment variable (see below).  

* Ant - this is the tool that runs the scripts. Generally you can use the latest version of Ant, but beginning with version 10.1 Java 1.8 is required; so, if your Java version is not at this level choose a lower, compatible version.  Download Ant from: https://ant.apache.org/bindownload.cgi  You will need to unzip the installation file to your target installation folder and note its location for adding the Ant bin folder to the system PATH environment variable (e.g. if you unzip the Ant zip file to C:\Tools you would add c:\Tools\apache-ant-1.9.4\bin to the PATH) and for setting the ANT_HOME environment variable (see below). (To change the Windows system PATH environment variable (version dependent): Start Button, right click Computer and select Properties, select Advanced System Settings, click Environment Variables, in System variables select Path and click Edit..., add "" to the end of the Variable value: (do not replace it), and click OK; back out of the series of dialogs and windows by clicking OK as needed.)

* Jython - this is Java implementation of the Python scripting language and is used to validate that a sermon date is a Sunday. Download Jython from http://www.jython.org/downloads.html using the Standalone Jar link, as of this writing the current version is 2.7.0. Place the jython jar file in the CBC folder created when you cloned the GitHub repository, this is where you will be running the scripts from. The jar file is typically named with the version of the release it corresponds to (e.g. jython-standalone-2.7.0.jar) and you must ensure that the reference in build.xml corresponds to that name; search for TODO in that file to find the location where the jar is referenced). 

* Ant and Jython require the following additional Apache (www.apache.org) tools:
  * Apache_bsf - Download the binary zip from https://commons.apache.org/proper/commons-bsf/download_bsf.cgi.  You must extract the bsf jar file from the zip and place it in the CBC folder created when you cloned the GitHub repository. The jar file should be found in the lib folder of the zip.
  * Apache_commons_logging - Download the binary zip from https://commons.apache.org/proper/commons-logging/download_logging.cgi. You must extract the commons-logging jar file from the zip and place it in the CBC folder created when you cloned the GitHub repository. The jar file is typically named with the version of the release it corresponds to (e.g. commons-logging-1.2.jar) and you must ensure that the reference in build.xml corresponds to that name; search for TODO in that file to find the location where the jar is referenced). 
  * Apache_commons_net - Download the binary zip from https://commons.apache.org/proper/commons-net/download_net.cgi and place the resulting jar file in the Ant lib folder and modify the CLASSPATH variable in build.bat (in the CBC folder) if necessary (i.e., the jar file is typically named with the version of the release it corresponds to (e.g. commons-net-3.6.jar) and you must ensure that the reference in build.bat corresponds to that name).

* Local customization - Before using the CBC scripts you need to setup local customizations to set expected environment variables.  These are the required environment variables in the format appropriate for a Windows .bat file (e.g. SetEnvironment.bat - note, this file is not checked into GitHub as it contains our private credentials) that you would run prior to running the Ant script; for example:  
SET ANT_HOME=c:\Tools\apache-ant-1.9.4
@set FTP_USERID=<replace with the userid for the cbcofconcrete server>
@set FTP_PASSWORD=<replace with the password for the cbcofconcrete server>


=====================================
Validating your software installation
=====================================

To confirm you have successfully installed the software run these commands (expected output shown):
1. Open a Windows Command Processor window (a.k.a a DOS command prompt) via the Start button.
2. Go to the directory where you've setup the GitHub repository; e.g. cd c:\CBC
3. Set the required environment variables; e.g. SetEnvironment.bat
4. Run: build -p
This is the expected output:
Buildfile: c:\CBC\build.xml

Main targets:

 ftp_file          FTP a file to the CBC server (called by weekly_sermon).
                   For example: build ftp_file -Dftp.file=ServerFiles/cbcserm09.02.2012.mp3 -Dftp.binary.mode=true
                   You must specify credentials via env. vars. FTP_USERID and FTP_PASSWORD
 modify_html_file  Modify the cbcmedia.html file for a weekly sermon (called by weekly_sermon).
 weekly_sermon     Copy MP3 file, update HTML, and FTP to web site.
 year_change       At year change rename cbcmedia.html and create a new file.
Default target: help


==================
Using the software
==================

There are two typical use cases:
1. Normal weekly sermon process
2. Once a year 

There are variations on the above in the event of errors; e.g. the server is down.  These are covered below under "Issues and debugging".


============================
Normal weekly sermon process 
============================
This process takes the sermon MP3, updates the HTML file, and FTPs the files to the server. For this process you need to have:
  * The weekly service MP3 file (assuming the sermon is recorded as a single MP3 file; otherwise, see "Resolving multiple sermon files" below). You will reference this when prompted by the script; e.g. e:\170514_0314.mp3 (depending where Windows mounts the memory stick, or you can copy it to another location and reference it from there).
  * The sermon date (which will be promped for as a two-digit month, two-digit day, and two-digit year), title, Bible passage, and speaker, which is assumed to be Rob (for variations see below).

Open a Windows DOS command prompt, which you can do via one of these two mechanisms:
 * Start Menu -> Run..., typing cmd, and pressing enter; then go to the location of the GitHub repository; e.g.: cd c:\CBC
 * Window explorer, navigate to the location you unzipped the files to, press the shift key and mouse right-click (context menu) and select "Open command window here" (probably Windows version and configuration dependent)

To run the process type: build weekly_sermon
Follow the prompts.


=================
Once a year setup
=================
This process takes the existing cbcmedia.html for the year (after you've entered the last sermon for the year), renames it, creates a new cbcmedia.html file and FTPs the file to the server.
* To run the process type: build year_change

The script doesn't do this, but you may want to: I create a subdirectory in the ServerFiles and MP3s folders of the old year and copy all the old files from the previous year there.

Example output:
C:\CBC>build year_change

C:\CBC>ant year_change
Buildfile: C:\CBC\build.xml

year_change:
    [input] What is the old year? (2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020)
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


===============
Important notes
===============

1. Always process the sermons in date order; i.e. oldest first. No idea what happens if you deviate from this, but I assume it will break the process/HTML file.
2. Never edit the cbcmedia.html file manually unless you know what you are doing.  The ant regex processing depends on the format I've established; so, if you mess anything up it will break the process.
3. The scope of this is just the cbcmedia.html file and none of the other cbcofconcrete.org site files.  Therefore, you should have your own backup of these files.  Also, to simplify things I assume that the mp3 files on the cbcofconcrete.org site are the authortative versions; so, again, you should have your own backups.  (We could consider adding these to GitHub, and not a bad idea, I've just not done that.)
4. Windows paths use backslashes, but the Ant/Java environment is quite happy with forward slashes.  I didn't take the time to make this consistent (my/this PC uses cygwin, which is also forward/backslash agnostic).  This could cause some angst/errors.


====================
Issues and debugging
====================

Installation issues:

If you only have a Java runtime (JRE) installed and not a full JDK installed (i.e. without JAVA_HOME set) you will see this error:

  Unable to locate tools.jar. Expected to find it in C:\Program Files\Java\jre7\lib\tools.jar

To resolve this error you must install a Java JDK and set the JAVA_HOME environment variable to point to that location (see build.bat).



Runtime issues:

 * Sometimes the FTP process will fail with a network error like this:
    BUILD FAILED
    C:\albatross\CBC\Web\build.xml:53: The following error occurred while executing this line:
    C:\albatross\CBC\Web\build.xml:162: error during FTP transfer: java.net.SocketException: Connection reset
    ...
   This is caused by the hosting server sometimes failing and you just have to rerun the FTP for each file until it completes successfully; e.g.:
    build ftp_file  -Dftp.binary.mode=true -Dftp.file=ServerFiles/cbcsermMM.DD.YYYY.mp3
    build ftp_file -Dftp.file=ServerFiles/cbcmedia.html

 * Also, there are a number of validations (e.g. date, file name) done by the script, which can cause the script to fail, requiring restarting.  
 
 * If the script fails with BUILD FAILED review the messages and take the appropriate action.

 * Also, the build could fail mid-stream - e.g. Windows update or by forced termination via Ctrl-C. In these cases it's best to be aware of where you are in the process as you may need to do some cleanup.  
 
 Unfortunately, specific details of all possible error scenarios and recovery steps are beyond the scope of this document; however, these are some guidelines that can assist in recovery:
   -) Enter the web page URL to confirm if the html page and mp3 files were copied to the server: file:///C:/CBC/ServerFiles/cbcmedia.html If the page shows up with your latest edits - sermon date, title, etc. - then you can confirm if the mp3 file copied successfully.  To confirm the mp3 file click it's "Download" link; if the file plays then it's likely OK and you're done.
   -) If either file is not on the server - html page or mp3 file - confirm that they are on your local PC.  In a Windows shell, in  your CBC GitHub folder enter:
      ls -1at ServerFiles/MP3s/*.mp3 | head -1
   You will get output like this:
      ServerFiles/MP3s/170416_0310.mp3
   which should be the last file you worked with from the memory stick.  If it's not you can start over from the beginning.
   Otherwise, confirm the script copied and renamed this file for copying to the server:
     ls -1at ServerFiles/*.mp3 | head -1
   You will get output like this:
     ServerFiles/cbcserm04.16.2017.mp3
   If the date portion of the two files don't match then continue in this list of steps; matching files would be, e.g. from above: "170416" & "04.16.2017".
   -) Each time the script is run a backup of the .html file is created before adding the new sermon.  This backup is in the CBC\ServerFiles folder.  If the backup exists with a matching date to the last sermon file you worked with then you know the script processed at least this far.  To check if the BACKUP file exists:
   ls -1at ServerFiles/cbcmedia.html-BACKUP* | head -1
   and if the date portion matches your latest sermon file date you know the script got as far as creating the backup.
   TODO
   Then to confirm if the most recent cbcmedia.html file was updated...
   
 
===============================
Resolving multiple sermon files
===============================

This used to be more of an issue when we had to process sermons via CD; however, it could possibly still happen that the technician has to restart the recording process and we wind up with more than one MP3 file, which need to be combined into a single file. Roughly, the steps are:
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
    build ftp_file -Dftp.binary.mode=true -Dftp.file=ServerFiles/cbcsermMM.DD.YYYY.mp3 
  * Update the HTML page by running the script using the sample below, substituting the appropriate values; e.g.:
    build modify_html_file -Dpyfile=cbcserm11.27.11.mp3 -Dpymonth=11 -Dpyday=27 -Dpyyear=11
  * FTP the modified HTML file to the server; e.g.:
    build ftp_file -Dftp.file=ServerFiles/cbcmedia.html

===========
Limitations
===========

I've written the code to be as simple and flexible as possible, but there are certain tradeoffs and limitations it may help you to be aware of. Namely;
* I chose the software because it's free and easy to code in (specifically Ant & jython).
* But Ant limits the structure of scripts such that you can pass parameters down, but never up.  So, this means that I had to structure things the way I felt they would most likely work/fail so as to minimize wasted rerun time.  So, the structure of the code and rerun pattern looks something like this:
 * weekly_sermon - this runs all the necessary targets
   * Obtaining of input values, input file and date, which you can verify and rerun if you get them wrong.
   * modify_html_file - obtains the input values, sermon title, speaker, etc. and edits the cbcsermon.html file.
   * ftp_file - called once for the mp3 file and once for the html file; again, the mp3 file can take several minutes.

=====
TODOs   
=====

* Automate script to pick up file from date input, with optional -D override
* Add Git commands to script
* Change backup to use date input    

<end>
