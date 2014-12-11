@set ANT_HOME=%CD%\apache-ant-1.9.4-bin
@set PATH=%PATH%;%ANT_HOME%\bin
@set JAVA_HOME=C:\Program Files\Java\jdk1.7.0_02
@set CLASSPATH=%CD%\apache-ant-1.9.4-bin\lib\commons-net-3.3.jar

ant %*
