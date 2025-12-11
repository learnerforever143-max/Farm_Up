# FARM UP - VS Code Import Instructions

## 🎉 Complete Project Setup Guide

Follow these instructions to import and run the FARM UP application in Visual Studio Code.

## 📋 Prerequisites

Before importing the project, ensure you have the following installed:

1. **Visual Studio Code** - Download from https://code.visualstudio.com/
2. **Flutter SDK** - Download from https://flutter.dev/docs/get-started/install
3. **Git** - Download from https://git-scm.com/downloads
4. **Android Studio** (for Android development) - Download from https://developer.android.com/studio
5. **Xcode** (for iOS development, macOS only)

## 🚀 Importing the Project into VS Code

### Option 1: Clone from GitHub (Recommended)

1. **Open VS Code**
2. **Open Terminal** in VS Code (Ctrl+` or Terminal → New Terminal)
3. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/farm-up.git
   cd farm-up
   ```

### Option 2: Import Local Folder

1. **Open VS Code**
2. **File → Open Folder**
3. **Navigate to and select** the `farm up easy` folder
4. **Click "Select Folder"**

## 🔧 Initial Setup

After importing the project:

1. **Install Flutter dependencies**:
   ```bash
   flutter pub get
   ```

2. **Verify Flutter installation**:
   ```bash
   flutter doctor
   ```
   Fix any issues reported by the doctor command.

3. **Install recommended VS Code extensions**:
   - Flutter
   - Dart
   - Awesome Flutter Snippets
   - Flutter Widget Snippets

## 📁 Project Structure

Once imported, you'll see the following structure:

```
farm-up/
├── lib/
│   ├── models/          # Data models for all farming entities
│   ├── services/        # Business logic and API integrations
│   ├── screens/         # UI screens for all features
│   ├── widgets/         # Reusable UI components
│   ├── database/        # Local database management
│   └── utils/           # Utility functions and helpers
├── assets/              # Media and static assets
├── test/                # Unit and widget tests (if any)
├── pubspec.yaml         # Flutter dependencies and configuration
├── README.md            # Project documentation
├── LICENSE              # License information
└── .gitignore           # Git ignored files
```

## ▶️ Running the Application

### 1. Select Device/Emulator

1. **Start an emulator** or connect a physical device
2. **In VS Code**, look at the bottom-right status bar
3. **Click on the device name** to select a different device

### 2. Run the Application

#### Option A: Using VS Code UI
1. **Open `lib/main.dart`**
2. **Press F5** or click **Run → Start Debugging**
3. **Or press Ctrl+F5** for Run Without Debugging

#### Option B: Using Terminal
```bash
# Run on default device
flutter run

# Run on specific device
flutter run -d <device-name>

# Run on Chrome (web)
flutter run -d chrome
```

## 🛠️ Development Workflow

### Creating New Files
1. **Right-click** on the desired folder in the Explorer
2. **Select "New File"**
3. **Name the file** with `.dart` extension

### Hot Reload
1. **Save your changes** (Ctrl+S)
2. **Press Ctrl+F5** to hot reload
3. **Or press `r`** in the terminal where the app is running

### Debugging
1. **Set breakpoints** by clicking left of line numbers
2. **Use Debug Console** to inspect variables
3. **Use Flutter Inspector** to examine UI widgets

## 📱 Key Features Available

The FARM UP application includes:

1. **Soil Analysis & Crop Recommendation**
2. **Budget Calculator & Financial Planning**
3. **Real-Time Weather Forecasting**
4. **Water Management System**
5. **AI-Powered Disease Detection**
6. **Comprehensive Video Library**
7. **Livestock Management**
8. **Market Intelligence & Price Tracking**
9. **Equipment Marketplace**
10. **Government Schemes Tracker**
11. **Farmer Community Platform**
12. **Yield Tracking & Analytics**
13. **Organic Certification Support**
14. **Input Inventory Management**
15. **Insurance & Risk Management**
16. **Supply Chain & Traceability**
17. **Multi-Language Voice Assistant**
18. **Offline Functionality**
19. **Notification System**
20. **Dark Mode UI**
21. **Report Export (PDF/Excel)**

## 🧪 Testing

### Run Unit Tests
```bash
flutter test
```

### Run Integration Tests
```bash
flutter drive --target=test_driver/app.dart
```

## 📦 Building for Release

### Android
```bash
# Build APK
flutter build apk

# Build App Bundle
flutter build appbundle
```

### iOS (macOS only)
```bash
flutter build ios
```

### Web
```bash
flutter build web
```

## 🔧 Troubleshooting

### Common Issues

#### 1. "No Connected Devices"
- Start an emulator
- Connect a physical device via USB
- Enable Developer Options and USB Debugging on Android

#### 2. "Flutter Not Found"
- Ensure Flutter is added to your PATH
- Restart VS Code after Flutter installation

#### 3. "Pub Get Failed"
```bash
flutter pub cache repair
flutter clean
flutter pub get
```

#### 4. "Gradle Issues" (Android)
```bash
flutter clean
flutter pub get
```
Delete `android/.gradle` folder if needed

## 🎨 Customization

### Changing App Name
Edit `pubspec.yaml`:
```yaml
name: farm_up
description: Complete Smart Farming Assistant
```

### Changing App Icon
Replace images in `assets/` folder and update references

### Adding New Features
1. Create new model in `lib/models/`
2. Create new service in `lib/services/`
3. Create new screen in `lib/screens/`
4. Register routes in `lib/main.dart`

## 📚 Documentation

Access project documentation:
- [Final Project Summary](FINAL_PROJECT_SUMMARY.md)
- [Progress Summary](PROGRESS_SUMMARY.md)
- [Deployment Guide](DEPLOYMENT_GUIDE.md)
- [Usage Guide](USAGE.md)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgements

Special thanks to:
- Flutter team for the amazing framework
- All contributors to the packages used
- The open-source community

---

*"Empowering Every Farmer to Farm Smart, Earn Better!"* 🌾📱

**Happy Coding!**