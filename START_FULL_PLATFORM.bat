@echo off
title TRADE AI - Full Platform Launcher
echo ===================================================
echo [1/2] Starting LSTM Neural Bridge (Python Flask)...
echo ===================================================
start "TRADE AI - Python Engine" cmd /k "cd backend && python flask_bridge.py"

echo.
echo Waiting for Neural Bridge to initialize (5s)...
timeout /t 5 > nul

echo ===================================================
echo [2/2] Starting Main Trading Platform (Java Spring Boot)...
echo ===================================================
:: Using the robust Java wrapper command from run-app.bat
start "TRADE AI - Core Platform" cmd /k "cd spring-boot-backend && java -Dmaven.multiModuleProjectDirectory=. -cp .mvn/wrapper/maven-wrapper.jar org.apache.maven.wrapper.MavenWrapperMain spring-boot:run"

echo.
echo ===================================================
echo SYSTEM DEPLOYED! 
echo Dashboard: http://localhost:8080
echo Neural Bridge: http://localhost:5000
echo ===================================================
echo Please ensure XAMPP (MySQL) is running before use.
pause
