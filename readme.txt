
============
Introduction
============

This set of directories and files represents an automated system for maintaining the CBC media (i.e. sermon) web site.
(I didn't investigate the processing of the church calendar as I've never gotten confirmation about MS Publisher being able to save in PDF or some graphic format.)

This automation is implemented by a set of free, open source software obtained from the following locations:
* Ant - to run the scripts - http://ant.apache.org/bindownload.cgi
* jython - Java-based scripting implementation - http://www.jython.org/downloads.html
* Ant and/or jython require the following Apache (www.apache.org) tools* Ant and/or jython require the following Apache (www.apache.org) tools:
  * Apache_bsf - Download and copy bsf.jar to C:\CBC\Web
  * Apache_commons_logging - Download and copy commons-logging-1.1.1.jar to C:\CBC\Web
  * Apache_commons_net - Download and copy commons-net-3.3.jar to the Ant lib directory.  Modify the CLASSPATH in build.bat if necessary.
  
One prereq for this (aside from your computer being Windows) is that you have a Java installed on your computer, most do.  If it's just a Java runtime (i.e. without JAVA_HOME set) then you are going to see an annoying error message like this:

  Unable to locate tools.jar. Expected to find it in C:\Program Files\Java\jre7\lib\tools.jar

By installing a Java JDK and setting JAVA_HOME you can avoid this error.  (I have setup the build.bat file specifically for my machine and yours may be different: @set JAVA_HOME=C:\Program Files\Java\jdk1.7.0_02)

Installation of this automation software is:
1. Unzipping the provided zip file to a suitable location; e.g.: C:\CBC\Web.
2. Installing the open source software above:
   a) Download the Ant zip and unzip to C:\CBC\Web, for instance.
      Modify build.bat to reflect this location
   b) Download Jython and install. Copy jython.jar to C:\CBC\Web (otherwise a change to build.xml will be needed to point to any alternate location).
   c) Set environment variables for the FTP credentials or add them to build.bat:
      @set FTP_USERID=user
      @set FTP_PASSWORD=password


There are two basic use cases:
1. Normal weekly sermon process
2. Once a year setup

============================
Normal weekly sermon process 
============================
This process takes the sermon MP3, updates the HTML file, and FTPs the files to the server. For this process you need to have:
  * The weekly service MP3 file (assuming the sermon is recorded as a single MP3 file).  Some sound technicians, for some silly reason, break the sermon up into multiple tracks, which then have to be handled "manually"; see "Resolving Multiple Sermon Files" below.
  * Copy the sermon MP3 file to C:\CBC\Web\ServerFiles\MP3s
  * You also need to know the sermon date (MM/DD/YYYY), title, Bible passage, and speaker, which is assumed to be Rob (for variations see below).

Open a Windows DOS command prompt, which you can do via one of these two mechanisms:
 * Start Menu -> Run..., typing cmd, and pressing enter
 * Window explorer, navigate to the location you unzipped the files to, press the shift key and mouse right-click (context menu) and select "Open command window here"

To verify the location and installation type: build -p, which should give you; e.g.:
    Buildfile: c:\albatross\CBC\Web\build.xml

    Main targets:

     ftp_file                FTP a file to the CBC server.
                             build ftp_file -Dftp.file=ServerFiles/cbcserm09.02.2012.mp3 -Dftp.binary.mode=true
                             You must specify credentials via env. vars. FTP_USERID and FTP_PASSWORD 
     modify_html_file        Modify the cbcmedia.html file for a weekly sermon.
     weekly_sermon  Copy sermon MP3 and update HTML on web site.
     year_change             At year change rename cbcmedia.html and create a new file and template. See "Once a year setup" below.

    Default target: help

To run the process type: build weekly_sermon
Follow the prompts.


=================
Once a year setup
=================
This process takes the existing cbcmedia.html for the year (after you've entered the last sermon for the year), renames it, creates a new cbcmedia.html file and FTPs the file to the server.
* To run the process type: build year_change

The script doesn't do this, but you may want to: I create a subdirectory in the ServerFiles and MP3s folders of the old year and copy all the old files from the previous year there.

Example output:
C:\Alligator\aardvark\CBC\Dev>build year_change

C:\Alligator\aardvark\CBC\Dev>ant year_change
Buildfile: C:\Alligator\aardvark\CBC\Dev\build.xml

year_change:
    [input] What is the old year? (2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020)
2012
     [move] Moving 1 file to C:\Alligator\aardvark\CBC\Dev\ServerFiles
     [copy] Copying 1 file to C:\Alligator\aardvark\CBC\Dev\ServerFiles
   [script] Expected files and file structure found OK.
     [copy] Copying 1 file to C:\Alligator\aardvark\CBC\Dev\ServerFiles

ftp_file:
     [echo] Attempting to FTP file ServerFiles/cbcmedia2012.html (format binary=false) to cbcofconcrete.org...
      [ftp] sending files
      [ftp] transferring C:\Alligator\aardvark\CBC\Dev\ServerFiles\cbcmedia2012.html
      [ftp] 1 files sent

ftp_file:
     [echo] Attempting to FTP file ServerFiles/cbcmedia.html (format binary=false) to cbcofconcrete.org...
      [ftp] sending files
      [ftp] transferring C:\Alligator\aardvark\CBC\Dev\ServerFiles\cbcmedia.html
      [ftp] 1 files sent

BUILD SUCCESSFUL
Total time: 33 seconds


====================
Issues and Debugging
====================
 * Sometimes the FTP process will fail with an error like this:
    BUILD FAILED
    C:\albatross\CBC\Web\build.xml:53: The following error occurred while executing this line:
    C:\albatross\CBC\Web\build.xml:162: error during FTP transfer: java.net.SocketException: Connection reset
    ...
   This is caused by the hosting server sometimes failing and you just have to rerun the FTP for each file until it completes successfully; e.g.:
    build ftp_file  -Dftp.binary.mode=true -Dftp.file=ServerFiles/cbcsermMM.DD.YYYY.mp3
    build ftp_file -Dftp.file=ServerFiles/cbcmedia.html

 * There are a number of validations done by the script, which can cause the script to fail, requiring restarting.  If the script fails with BUILD FAILED review the messages and take the appropriate action.

 * The process can be terminated via Ctrl-C, but you need to be aware of where you are in the process and you may need to do some cleanup.  Details are beyond the scope of this document, but essentially involves reading the build.xml file and output to identify the location and cause of the failure.

 * Each time the script is run a backup of the .html file is created in the ServerFiles folder with the a suffix of -BACKUP and the time of day; e.g.: cbcmedia.html-BACKUP010332

===============================
Resolving Multiple Sermon Files
===============================
If the sound technician decides for some silly reason to break the sermon into a bunch of small files your work is significantly greater.  Roughly, the steps are:
* You have Audacity installed (beyond the scope of this document).
* Open two Audacity Windows.
* In one Audacity window open the first MP3 file and:
  * Click the track drop-down window and select Split Stero Track
  * Close one of the two (X)
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

<end>


