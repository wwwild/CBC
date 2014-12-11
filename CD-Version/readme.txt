
============
Introduction
============

This set of directories and files represents an automated system for maintaining the CBC media (i.e. sermon) web site.
(I didn't investigate the processing of the church calendar as I've never gotten confirmation about MS Publisher being able to save in PDF or some graphic format.)

This automation is implemented by a set of free, open source software obtained from the following locations:
* Ant - to run the scripts - http://ant.apache.org/bindownload.cgi
* cdrtools - to convert a CD file to WAV format - http://sourceforge.net/projects/cdrtoolswin/ 
* ffmpeg - to convert from WAV to MP3 format - https://www.ffmpeg.org/download.html (requires 7zip to process the download; also freely available)
* jython - Java-based scripting implementation - http://www.jython.org/downloads.html
* Ant and/or jython require the following Apache (www.apache.org) tools:
  * Apache_bsf - Download and copy bsf.jar to C:\CBC\Web
  * Apache_commons_logging - Download and copy commons-logging-1.1.1.jar to C:\CBC\Web
  * Apache_commons_net - Download and copy commons-net-3.3.jar to the Ant lib directory.  Modify the CLASSPATH in build.bat if necessary.

One prereq for this (aside from your computer being Windows and having a CD drive) is that you have a Java installed on your computer, most do.  If it's just a Java runtime (i.e. without JAVA_HOME set) then you are going to see an annoying error message like this:
  Unable to locate tools.jar. Expected to find it in C:\Program Files\Java\jre7\lib\tools.jar

By installing a Java JDK and setting JAVA_HOME you can avoid this error.  (I have setup the build.bat file specifically for my machine and yours may be different: @set JAVA_HOME=C:\Program Files\Java\jdk1.7.0_02)

Installation of this automation software should simply be unzipping the supplied zip to a suitable location; e.g.: C:\CBC\Web.


There are two basic use cases:
1. Normal weekly sermon process
2. Once a year setup

============================
Normal weekly sermon process 
============================
This process takes the sermon CD track, converts it to MP3, updates the HTML file, and FTPs the files to the server. For this process you need to have:
* The weekly service CD and the sermon has to have been recorded as a single track.  Some sound technicians, for some silly reason, break the sermon up into multiple tracks, which then have to be handled "manually"; see "Resolving Multiple Sermon Files" below.
* Once you have the CD use Windows Media Player or some piece of software to identify the sermon track; I always assume it's the longest one (not necessarily valid).
* You also need to know the sermon date (MM/DD/YYYY), title, passage, and speaker which is assume to be Rob (for variations see below).

To run this process open a Windows DOS command prompt, which you can do via:
 * Start Menu -> Run... : cmd
 * Window explorer, navigate to the location you unzipped the files to, press the shift key and mouse right-click (context menu) and select "Open command window here"
 * To verify the location and installation type: build -p, which should give you:
    Buildfile: c:\albatross\CBC\Web\build.xml

    Main targets:

     convert_cd_to_mp3  Convert a CD file (sermon) to MP3 format.
     ftp_file           FTP a file to the CBC server.
     modify_html_file   Modify the cbcmedia.html file for a weekly sermon.
     weekly_sermon      Convert CD sermon to MP3 and update HTML on web site.
     year_change        At year change rename cbcmedia.html and create a new file.

   Note the default speaker is "Pastor Rob Thomas".  If you need to specify a different speaker run the Ant command with: -Dcbc.sermon.speaker="Some name"; e.g.:
                          build modify_html_file -Dcbc.sermon.file=cbcserm09.02.2012 -Dpymonth=09 -Dpyday=02 -Dpyyear=12 -Dcbc.sermon.speaker="Pastor Bruce Martin"	
                          build ftp_file -Dftp.file=ServerFiles/cbcserm09.02.2012.mp3 -Dftp.binary.mode=true
                          

    Default target: help

* To run the process type: build weekly_sermon
* Here is the output from a typical session:

C:\albatross\CBC\Web>build weekly_sermon
Buildfile: C:\albatross\CBC\Web\build.xml

weekly_sermon:
     [echo]
    [input] Input the CD track number (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20)
10
     [echo] CD track 10 will be processed.
     [echo]
    [input] Enter month (01 - 12): (01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12)
12
     [echo]
    [input] Enter day (01 - 31): (01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22
, 23, 24, 25, 26, 27, 28, 29, 30, 31)
04
    [input] Enter year (11 - 20): (11, 12, 13, 14,  15,  16,  17,  18,  19,  20)
11

verify_sunday:
   [script] Confirmed the specified date (02/12/12) is a Sunday.
    [input] Is the following correct: CD track number=13 / Date=02/12/12 (yes, no)
yes

abort_cd_data:
     [echo] This script will produce cbcserm02.12.2012 from track 13 of the current CD.

convert_cd_to_mp3:
     [echo] CD Drive / SCSI bus: 0,1,0
     [echo]
     [echo] Converting from CD to WAV format ...

display_output:
     [echo]
     [echo] Converting from WAV to MP3 format ...

display_output:
     [move] Moving 1 file to C:\Alligator\aardvark\CBC\Dev\ServerFiles
   [delete] Deleting: C:\Alligator\aardvark\CBC\Dev\cbcserm02.12.2012.wav

modify_html_file:
     [echo] This script will add cbcserm02.12.2012.mp3 to cbcmedia.html.
    [input] Input the sermon title:
In His Steps
     [echo] The sermon title specified is:In His Steps.
    [input] Input the Bible passage (e.g. 1Peter 1:3-5):
1Peter 2:21-25
     [echo] The sermon passage specified is:1Peter 2:21-25.
     [echo] The default speaker is "Pastor Rob Thomas".  If you need to specify a different speaker run the Ant command
with: -Dcbc.sermon.speaker="Some name"
     [echo] Speaker is:Pastor Rob Thomas
    [input] Is the following correct: Title=In His Steps / Passage=1Peter 2:21-25 / Speaker=Pastor Rob Thomas? [yes, no]
 (yes, no)
yes

abort_sermon_data:
     [copy] Copying 1 file to C:\Alligator\aardvark\CBC\Dev\ServerFiles
     [echo] HTML backup file is: ServerFiles/cbcmedia.html-BACKUP051826
   [script] Processing cbcserm02.12.2012.mp3 to cbcmedia.html
   [script] Expected files and file structure found OK.

ftp_file:
     [echo] Attempting to FTP file ServerFiles/cbcserm02.12.2012.mp3 (format binary=true) to cbcofconcrete.org...
      [ftp] sending files
      [ftp] transferring C:\Alligator\aardvark\CBC\Dev\ServerFiles\cbcserm02.12.2012.mp3
      [ftp] 1 files sent

ftp_file:
     [echo] Attempting to FTP file ServerFiles/cbcmedia.html (format binary=false) to cbcofconcrete.org...
      [ftp] sending files
      [ftp] transferring C:\Alligator\aardvark\CBC\Dev\ServerFiles\cbcmedia.html
      [ftp] 1 files sent

BUILD SUCCESSFUL
Total time: 20 minutes 24 seconds



=================
Once a year setup
=================
This process takes the existing cbcmedia.html for the year (after you've entered the last sermon for the year), renames it, creates a new cbcmedia.html file and FTPs the file to the server.
* To run the process type: build year_change


====================
Issues and Debugging
====================
 * Sometimes the process will fail with an error like this:
   BUILD FAILED
   C:\albatross\CBC\Web\build.xml:53: The following error occurred while executing this line:
   C:\albatross\CBC\Web\build.xml:162: error during FTP transfer: java.net.SocketException: Connection reset
   ...
   The hosting server seems to have gotten a bit flakey and you just have to rerun the FTP for each file until it completes successfully; e.g.:
    build ftp_file -Dftp.file=ServerFiles/cbcsermMM.DD.YYYY.mp3 -Dftp.binary.mode=true
    build ftp_file -Dftp.file=ServerFiles/cbcmedia.html
 * The process can be terminated via Ctrl-C, but you need to be aware of where you are in the process and you may need to do some cleanup.  <Details TBD.>


===============================
Resolving Multiple Sermon Files
===============================
If the sound technician decides for some silly reason to break the sermon into a bunch of small files your work is significantly greater.  Roughly, the steps are:
* You have Audacity installed (beyond the scope of this document).
* Use a tool like Windows Media player, iTunes, etc. to identify the files that make up the sermon.
* Convert those files to MP3 or some other Audacity-compatible format (e.g. iTunes can do this if you have it configured).
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
I've written the code to be as simple and flexible as possible, but there are certain tradeoffs and limitations it may help you to be aware of. Namely:  
* I chose the software because it's free and easy to code in (specifically Ant & jython).
* But Ant limits the structure of scripts such that you can pass parameters down, but never up.  So, this means that I had to structure things the way I felt they would most likely work/fail so as to minimize wasted rerun time.  And since the FTP connection to cbcofconcrete.org seems sporadically inconsistent, I had to structure the data inputs for the CD processing separately from the HTML processing.  That is, the process for CD conversion can take many minutes and I didn't think someone would want to rerun that if, for instance, they mistyped the sermon title; and similarly if the FTP session failed I felt it better to structure this at the end because it's a relatively simple rerun.  So, the structure of the code and rerun pattern looks something like this:
 * weekly_sermon - this runs all the necessary targets
   * Obtaining of input values, CD track number and date, which you can verify and rerun if you get them wrong.
   * convert_cd_to_mp3 - Converion of CD to wav to MP3, depending on your computer horsepower this is going to take several minutes.
   * modify_html_file - obtains the input values, sermon title, speaker, etc. and edits the cbcsermon.html file.
   * ftp_file - called once for the mp3 file and once for the html file; again, the mp3 file can take several minutes.
This has been tested by only processing the input sequentially (by date).

<end>


