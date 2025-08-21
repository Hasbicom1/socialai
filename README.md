# ZW - AI-Powered Mobile App Aggregation Platform

ZW is a revolutionary mobile application that transforms how you interact with your installed apps. It provides a unified, AI-powered feed that aggregates updates from all your selected applications, presenting them in an intuitive reel-style interface.

## 🚀 Features

### **Core Functionality**
- **App Discovery**: Automatically detects all installed applications on your device
- **Smart Selection**: Choose which apps ZW should monitor and aggregate
- **Unified Feed**: View updates from all selected apps in one beautiful, scrollable interface
- **AI Summarization**: Get intelligent summaries and insights about your app activity
- **Seamless Navigation**: Swipe right to open the source app, swipe back to return to ZW

### **AI-Powered Features**
- **Smart Categorization**: Automatically categorizes apps (Social, Messaging, Email, etc.)
- **Priority Detection**: Identifies high-priority updates and notifications
- **Usage Analytics**: Provides insights into your app usage patterns
- **Intelligent Recommendations**: Suggests optimizations and productivity improvements

### **User Experience**
- **Modern UI**: Beautiful dark theme with gradient accents and smooth animations
- **Reel-Style Interface**: Intuitive card-based navigation similar to popular social media apps
- **Real-time Updates**: Live synchronization with your selected apps
- **Customizable Filters**: Filter updates by app category or type
- **Gesture Support**: Intuitive swipe and tap interactions

## 📱 Screenshots

*[Screenshots will be added after the first build]*

## 🛠️ Technical Stack

- **Framework**: Flutter 3.24.5+
- **Language**: Dart
- **Backend**: Supabase (User profiles, preferences, analytics)
- **AI Integration**: TensorFlow Lite for on-device AI processing
- **Device Integration**: Accessibility services for app monitoring
- **UI/UX**: Custom Material Design with dark theme optimization

## 📋 Prerequisites

- Flutter SDK (^3.29.2)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Android SDK / Xcode (for iOS development)
- Android device with API level 21+ for testing

## 🚀 Installation & Setup

### 1. Clone the Repository
```bash
git clone https://github.com/Hasbicom1/socialai.git
cd socialai
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Configure Environment
Create an `env.json` file in the root directory:
```json
{
  "SUPABASE_URL": "your_supabase_url",
  "SUPABASE_ANON_KEY": "your_supabase_anon_key"
}
```

### 4. Run the Application

**Through CLI:**
```bash
flutter run --dart-define-from-file=env.json
```

**For VSCode:**
1. Open `.vscode/launch.json` (create if it doesn't exist)
2. Add configuration:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Launch ZW",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "args": ["--dart-define-from-file", "env.json"]
    }
  ]
}
```

**For IntelliJ / Android Studio:**
1. Go to Run > Edit Configurations
2. Select your Flutter configuration
3. Add to "Additional arguments": `--dart-define-from-file=env.json`

## 📁 Project Structure

```
socialai/
├── android/                    # Android-specific configuration
├── ios/                       # iOS-specific configuration
├── lib/
│   ├── core/                  # Core utilities and services
│   │   ├── utils/            # Utility classes
│   │   └── app_export.dart   # Common exports
│   ├── presentation/         # UI screens and widgets
│   │   ├── splash_screen/    # Splash screen
│   │   └── zw_dashboard/     # ZW main dashboard
│   │       ├── widgets/      # Dashboard widgets
│   │       │   ├── zw_reel_card.dart
│   │       │   ├── zw_ai_summary_panel.dart
│   │       │   └── zw_app_selector.dart
│   │       └── zw_dashboard_screen.dart
│   ├── services/             # Business logic services
│   │   └── zw_app_aggregator_service.dart
│   ├── routes/               # Application routing
│   ├── theme/                # Theme configuration
│   └── main.dart             # Application entry point
├── assets/                   # Static assets
│   ├── images/              # Images and icons
│   ├── animations/          # Lottie animations
│   └── icons/               # App icons
├── .github/workflows/       # GitHub Actions for CI/CD
│   └── build.yml           # APK build workflow
├── pubspec.yaml            # Project dependencies
└── README.md               # Project documentation
```

## 🔧 Key Components

### **ZWAppAggregatorService**
Core service that handles:
- Installed app discovery and categorization
- User preference management
- Update aggregation and AI summarization
- Permission management
- Device information collection

### **ZWDashboardScreen**
Main interface featuring:
- Reel-style feed with PageView
- Real-time AI status indicators
- Category-based filtering
- App selection modal
- AI summary panel

### **ZWReelCard**
Individual update cards with:
- App-specific styling and gradients
- Priority-based visual indicators
- Interactive action buttons
- Smooth animations and gestures

## 🎨 Design System

### **Color Palette**
- **Primary**: `#667EEA` (Blue gradient)
- **Secondary**: `#764BA2` (Purple gradient)
- **Accent**: `#F093FB` (Pink gradient)
- **Background**: `#0A0A1A` (Dark blue)
- **Surface**: `rgba(255,255,255,0.1)` (Glass effect)

### **Typography**
- **Headings**: SF Pro Display / Roboto
- **Body**: SF Pro Text / Roboto
- **Responsive**: Uses Sizer package for adaptive sizing

### **Animations**
- **Page Transitions**: Smooth slide animations
- **Card Interactions**: Scale and fade effects
- **Loading States**: Lottie animations
- **AI Indicators**: Pulsing and glowing effects

## 🔐 Permissions

ZW requires the following permissions:
- **Accessibility**: To monitor app activity and notifications
- **Notification Access**: To read and aggregate notifications
- **Storage**: To cache app data and preferences

## 🚀 Deployment

### **Build APK**
```bash
# Development build
flutter build apk --debug

# Release build
flutter build apk --release
```

### **Cloud Build (Recommended)**
The repository includes GitHub Actions workflow for automated APK builds:
1. Push code to the repository
2. GitHub Actions automatically builds the APK
3. Download the APK from the Actions tab

### **Installation**
1. Enable "Install from Unknown Sources" on your Android device
2. Download and install the APK
3. Grant required permissions when prompted
4. Start using ZW!

## 🔮 Future Enhancements

### **Planned Features**
- **Real AI Integration**: OpenAI/Claude API integration for advanced summarization
- **Notification Monitoring**: Real-time notification aggregation
- **Usage Analytics**: Detailed app usage insights and reports
- **Smart Scheduling**: AI-powered notification scheduling
- **Cross-Platform Sync**: Web dashboard for desktop access
- **Custom Themes**: User-customizable color schemes
- **Widget Support**: Home screen widgets for quick access

### **Technical Improvements**
- **Performance Optimization**: Lazy loading and caching improvements
- **Battery Optimization**: Efficient background processing
- **Offline Support**: Local caching and offline functionality
- **Accessibility**: Enhanced accessibility features
- **Testing**: Comprehensive unit and integration tests

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Flutter Team**: For the amazing cross-platform framework
- **Supabase**: For the backend infrastructure
- **Material Design**: For the design system inspiration
- **Open Source Community**: For the various packages and tools used

---

**Built with ❤️ using Flutter & Dart**

*ZW - Your AI-powered app companion*
