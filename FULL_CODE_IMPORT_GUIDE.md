# FARM UP - Complete Smart Farming Assistant
## Full Code Import Guide for VS Code

This document provides complete instructions for importing and running the FARM UP application in Visual Studio Code.

## Project Overview

FARM UP is a complete smart farming assistant that empowers farmers with data-driven decision-making, real-time guidance, and market intelligence—all in their native language. The application includes 25 core features covering all aspects of modern agriculture.

## Prerequisites

Before importing the project, ensure you have the following installed:
1. Visual Studio Code (latest version)
2. Flutter SDK (3.0.0 or higher)
3. Dart SDK (bundled with Flutter)
4. Android Studio or Xcode (for mobile development)
5. Git (optional, for version control)

## Importing the Project into VS Code

### Method 1: Using VS Code Workspace File (Recommended)

1. Open Visual Studio Code
2. Go to `File` > `Open Workspace from File...`
3. Navigate to the project directory and select `farm_up.code-workspace`
4. The workspace will load with all project files and configurations

### Method 2: Opening the Project Folder

1. Open Visual Studio Code
2. Go to `File` > `Open Folder...`
3. Select the project root directory (`farm_up`)

## Project Structure

The project follows a clean architecture with the following structure:

```
lib/
├── database/           # Database helper and connection management
├── models/             # Data models for all features
├── screens/            # UI screens for each feature
├── services/           # Business logic and external service integrations
├── utils/              # Utility functions and helpers
└── widgets/            # Reusable UI components
```

## Dependencies

All required dependencies are listed in `pubspec.yaml`. Key packages include:

- `flutter_tts`: Text-to-speech functionality
- `speech_to_text`: Speech recognition
- `sqflite`: Local database management
- `flutter_local_notifications`: Notification system
- `pdf`: PDF report generation
- `excel`: Excel report generation

## Running the Application

### Initial Setup

1. Open a terminal in VS Code (`Terminal` > `New Terminal`)
2. Run the following command to install dependencies:
   ```
   flutter pub get
   ```

### Running on Different Platforms

#### Mobile (Android/iOS)
```
flutter run
```

#### Web
```
flutter run -d chrome
```

#### Desktop (Windows/macOS/Linux)
```
flutter run -d windows
```

## Building Release Versions

### Android APK
```
flutter build apk
```

### Web Deployment
```
flutter build web
```

## Key Features Implemented

1. Soil Analysis & Crop Recommendation
2. Budget Calculator & Financial Planning
3. Real-Time Weather Forecasting
4. Water Management System
5. AI-Powered Disease & Pest Detection
6. Comprehensive Video Library
7. Livestock Management
8. Crop Health Monitoring
9. Market Intelligence & Price Tracking
10. Farming Tools & Equipment Marketplace
11. Government Schemes & Subsidy Tracker
12. Farmer Community & Knowledge Sharing
13. Yield Tracking & Analytics
14. Organic Certification Support
15. Input Inventory Management
16. Insurance & Risk Management
17. Supply Chain & Traceability
18. Multi-Language Voice Assistant
19. Offline Functionality
20. Notification System
21. Dark Mode
22. Report Export (PDF/Excel)

## Configuration Files

The project includes pre-configured VS Code settings:
- `.vscode/settings.json`: Workspace settings
- `.vscode/launch.json`: Debug configurations
- `.vscode/tasks.json`: Custom tasks

## Troubleshooting

### Common Issues

1. **Flutter not found**: Ensure Flutter is properly installed and added to PATH
2. **Dependencies not resolved**: Run `flutter pub get` to install packages
3. **Device not detected**: Check device connections and developer options

### Getting Help

- Refer to `README.md` for detailed documentation
- Check `IMPLEMENTATION_SUMMARY.md` for feature descriptions
- Review `DATABASE_SCHEMA.md` for database structure

## Next Steps

After successfully importing the project:
1. Run the application to verify setup
2. Explore the codebase through the organized folder structure
3. Customize features as needed for your specific requirements
4. Test all functionalities in the development environment

## Support

For any issues or questions regarding the FARM UP application, please refer to the documentation files included in the project or contact the development team.