@echo off
SET MavenWrapperDir=spring-boot-backend\.mvn\wrapper
SET MavenWrapperJar=%MavenWrapperDir%\maven-wrapper.jar
SET MavenWrapperProps=%MavenWrapperDir%\maven-wrapper.properties

IF NOT EXIST "%MavenWrapperDir%" mkdir "%MavenWrapperDir%"

IF NOT EXIST "%MavenWrapperProps%" (
    echo distributionUrl=https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.9.6/apache-maven-3.9.6-bin.zip > "%MavenWrapperProps%"
    echo wrapperUrl=https://repo.maven.apache.org/maven2/org/apache/maven/wrapper/maven-wrapper/3.2.0/maven-wrapper-3.2.0.jar >> "%MavenWrapperProps%"
)

IF NOT EXIST "%MavenWrapperJar%" (
    echo Downloading Maven Wrapper...
    powershell -Command "Invoke-WebRequest -Uri https://repo.maven.apache.org/maven2/org/apache/maven/wrapper/maven-wrapper/3.2.0/maven-wrapper-3.2.0.jar -OutFile '%MavenWrapperJar%'"
)

echo Starting Spring Boot Backend...
IF EXIST "pom.xml" (
    java -Dmaven.multiModuleProjectDirectory=. -cp .mvn/wrapper/maven-wrapper.jar org.apache.maven.wrapper.MavenWrapperMain spring-boot:run
) ELSE IF EXIST "spring-boot-backend\pom.xml" (
    cd spring-boot-backend
    java -Dmaven.multiModuleProjectDirectory=. -cp .mvn/wrapper/maven-wrapper.jar org.apache.maven.wrapper.MavenWrapperMain spring-boot:run
) ELSE (
    echo ERROR: Could not find pom.xml. Please run this from the project root.
)
