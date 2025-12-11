@echo off
echo FARM UP - Smart Farming Assistant
echo =================================
echo.
echo Starting documentation server...
echo.
echo Make sure you have Node.js installed.
echo If not, download it from https://nodejs.org/
echo.
echo Press any key to continue...
pause >nul
echo.
echo Installing dependencies...
npm install
echo.
echo Starting server...
echo Open your browser to http://localhost:3000
node server.js