This is a set of files to automate maintaing the CBC media web page (http://cbcofconcrete.org/cbcmedia.html)from a CD-ROM or MP3 file.  

# Table of Contents  

1. Introduction  
1. Required software & installation  
    1. Validating your software installation  
1. Using the software  
    1. Normal weekly sermon process  
   +     1. Process Description  
        1. Changes to GitHub  
    1. Once a year setup  
    1. Important notes  
1. Issues and Debugging  
    1. Installation issues  
    1. Runtime issues  
    1. Resolving multiple sermon files  
1. Limitations  
1. TODOs  

# Introduction  

This set of directories and files represents an automated system for maintaining the CBC media web page; i.e., the sermon web page.  The rest of the www.cbcofconcrete.org web pages are outside the scope of this automation.  

This automation is implemented with free, open source software.  This automation has been developed on Windows, but should be portable to other operating systems that support Java (e.g. Mac OS, Linux), etc.; however, Windows-specific files (like .bat scripts) would need to be converted to be compatible with the target operating system. Unfortunately, the openness of this software raises some technical issues, mainly that over time the various versions are updated, creating dependencies, etc.  These are discussed below.  


# Required software & installation  


  * GitHub - the script software is stored publicly on GitHub and you can use the desktop client to access the CBC scripts, which is available from https://desktop.github.com/.  (However, if you just want to view the script code to see what's there you can use a browser with this URL: https://github.com/wwwild/CBC.git) 
    * Click the appropriate download link; e.g. Download for Windows (64 bit).  
    * Save the file.  
    * Run the executable.  
    * After installation will GitHub start.  
    * Select `Create your free account.` if you don't already have a login; otherwise, select `Sign into GitHub.com`.  
    * Enter your credentials and and click `Continue`.  
    * Deselect the option to send usage information and click Finish.  
    * Once the GitHub desktop client starts:  
      * On the `Select a repository` screen click `Clone a repository`.  
      * In the `Clone a repository` dialog enter the URL https://github.com/wwwild/CBC.git and your local path (you can take the default or specify a location of your choosing via the `Choose...` button, in this case the location you select will have "\CBC" added to the end of it automatically, for purposes of this documentation will assume a location of C:\aardvark\CBC) and click the `Clone` button. Cloning will take a few minutes.  
    * Copy the `CBC-Sermon-Desktop.bat` file to your Windows desktop.  


* Java - this is the foundation of these scripts as it is a prerequisite to Ant, jython, etc. If you already have a Java JDK installed on your computer (assuming it's a current version) you can ignore the remainder of this bullet.  
  * To confirm if a Java JDK (as opposed to just a JRE) is installed enter the following command at a command prompt:  
  > java -version  
  * As of this writing the current version of Java is 1.8. If necessary you should download and install the Java JDK from  http://www.oracle.com/technetwork/java/javase/downloads/index.html, click the Downloads tab and click the `Java Platform (JDK) Download` link, click the `Accept License Agreement` radio button and click the appropriate download for your platform.  Save the resulting file to your computer and execute it as appropriate. 
    * You will need to note the installation location of Java to later set the `JAVA_HOME` environment variable (see below).  


* Ant - this is the tool that runs the scripts. Generally you can use the latest version of Ant, but beginning with version 10.1 Java 1.8 is required; so, if your Java version is not at this level choose a lower, compatible version of Ant.  
    * Download Ant from: https://ant.apache.org/bindownload.cgi  
    * You will need to unzip the installation file to your target installation folder.  
    * Note the installation folder location for adding the Ant bin folder to the system `PATH` environment variable (e.g. if you unzip the Ant zip file to C:\Tools you would add c:\Tools\apache-ant-1.9.4\bin to the PATH) and for setting the `ANT_HOME` environment variable (see below). 


* Jython - this is Java implementation of the Python scripting language and is used to validate that a sermon date is a Sunday. 
    * Download Jython from http://www.jython.org/downloads.html using the Standalone Jar link, as of this writing the current version is 2.7.0. 
    * Place the jython jar file in the CBC folder created when you cloned the GitHub repository (e.g. C:\aardvark\CBC), this is where you will be running the scripts from. 
    * The jar file is typically named with the version of the release it corresponds to (e.g. jython-standalone-2.7.0.jar) and you must ensure that the reference in build.xml corresponds to that name; search for `TODO` in that file to find the location where the jar is referenced and change if necessary). 


* Ant and Jython require the following additional Apache (www.apache.org) tools:  
  * ant-contrib (http://ant-contrib.sourceforge.net/)
      * Download the binary zip from https://sourceforge.net/projects/ant-contrib/files/ant-contrib/1.0b3/ant-contrib-1.0b3-bin.zip/download 
      * You must extract the ant-contrib-1.0b3.jar file and place it in the Ant lib folder (e.g. C:\Tools\apache-ant-1.9.4\lib).  
  * Apache_bsf  
      * Download the binary zip from https://commons.apache.org/proper/commons-bsf/download_bsf.cgi 
      * You must extract the bsf jar file from the zip and place it in the CBC folder created when you cloned the GitHub repository (e.g. C:\aardvark\CBC). The jar file should be found in the lib folder of the zip.  
  * Apache_commons_logging  
      * Download the binary zip from https://commons.apache.org/proper/commons-logging/download_logging.cgi. 
      * You must extract the commons-logging jar file from the zip and place it in the CBC folder created when you cloned the GitHub repository. 
      * The jar file is typically named with the version of the release it corresponds to (e.g. commons-logging-1.2.jar) and you must ensure that the reference in build.xml corresponds to that name; search for `TODO` in that file to find the location where the jar is referenced). 
  * Apache_commons_net  
      * Download the binary zip from https://commons.apache.org/proper/commons-net/download_net.cgi and place the resulting jar file in the Ant lib folder.  
      * Modify the `CLASSPATH` variable in build.bat (in the CBC folder, e.g. C:\aardvark\CBC) if necessary; that is, the jar file is typically named with the version of the release it corresponds to (e.g. commons-net-3.6.jar) and you must ensure that the reference in build.bat corresponds to that name.  

* Local customizations - Before using the CBC scripts you need to setup local customizations:  
    * Create a SetEnvironment.bat file in the CBC folder created when you cloned the GitHub repository (e.g. C:\aardvark\CBC).  This file will set environment variables that are required by the scripts.  **This file should not be checked into GitHub** (which is why it's in the .gitignore file).  Make note of the comments (REM) in the sample below and use it to create your SetEnvironment.bat file:  
> REM This value of ANT_HOME is using the example from the steps above:  
> @SET ANT_HOME=c:\Tools\apache-ant-1.9.4  
>  
> REM You can use this setting as-is:  
> @SET PATH=%PATH%;%ANT_HOME%\bin  
>  
> REM Set the value of CBC_HOME to the CBC folder created when you cloned the GitHub repository  
> @SET CBC_HOME=C:\aardvark\CBC  
>  
> REM Note the substitutions you must make to these values: 
> @set FTP_USERID=`<replace with the userid for the cbcofconcrete server>`  
> @set FTP_PASSWORD=`<replace with the password for the cbcofconcrete server>`  


## Validating your software installation  

To confirm you have successfully installed the software run these commands (expected output shown):  
1. Open a Windows Command Processor window (a.k.a a DOS command prompt) via the Start button.  
2. Go to the directory where you've setup the GitHub repository; e.g. cd c:\CBC  
3. Set the required environment variables; e.g. SetEnvironment.bat  
4. Run: build -p  
  
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



[end]
