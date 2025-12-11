@echo off
echo FARM UP - Project Verification Script
echo ==================================

echo Checking Flutter installation...
flutter --version
if %errorlevel% neq 0 (
    echo ERROR: Flutter is not installed or not in PATH
    echo Please install Flutter from https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)

echo.
echo Checking project structure...
if exist "lib" (
    echo ✓ lib directory found
) else (
    echo ✗ lib directory missing
    pause
    exit /b 1
)

if exist "pubspec.yaml" (
    echo ✓ pubspec.yaml found
) else (
    echo ✗ pubspec.yaml missing
    pause
    exit /b 1
)

echo.
echo Installing dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo ERROR: Failed to install dependencies
    pause
    exit /b 1
)

echo.
echo Verifying project structure...
echo Main application entry point:
if exist "lib\main.dart" (
    echo ✓ lib/main.dart found
) else (
    echo ✗ lib/main.dart missing
)

echo Database helper:
if exist "lib\database\database_helper.dart" (
    echo ✓ lib/database/database_helper.dart found
) else (
    echo ✗ lib/database/database_helper.dart missing
)

echo Models directory:
if exist "lib\models" (
    echo ✓ lib/models directory found
) else (
    echo ✗ lib/models directory missing
)

echo Services directory:
if exist "lib\services" (
    echo ✓ lib/services directory found
) else (
    echo ✗ lib/services directory missing
)

echo Screens directory:
if exist "lib\screens" (
    echo ✓ lib/screens directory found
) else (
    echo ✗ lib/screens directory missing
)

echo.
echo Project verification complete!
echo You can now open this project in VS Code and run it with 'flutter run'
echo.
pause