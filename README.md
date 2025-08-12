# ANIS

A modern iOS SwiftUI application for finding, creating, and joining sports activities in your area.

## 📱 Features

- **Interactive Map**: Discover sports activities on an interactive map with custom pins
- **Activity Search**: Real-time search functionality to find activities by sport, location, or skill level
- **Create Activities**: Easy-to-use interface for creating new sports activities
- **Requests (Incoming & Pending)**: Manage activity join requests without chat
- **Join Requests**: Send and manage requests to join activities
- **User Profiles**: Personalized user profiles and settings

## 🎨 Design

The app features a clean, modern design with a carefully chosen color palette:
- **Primary**: #152C44 (Deep Navy)
- **Background**: #FFF4DD (Warm Cream)
- **Accent**: #8AC185 (Fresh Green)

## 🏗️ Architecture

- **Framework**: SwiftUI + iOS 18.5+
- **Architecture**: MVVM (Model-View-ViewModel)
- **State Management**: @State, @StateObject, @Binding
- **Maps**: MapKit integration
- **UI Components**: Custom reusable components

## 📂 Project Structure

```
ANISApp/
├── Views/
│   ├── Main/
│   │   ├── MapView/          # Map interface and activity pins
│   │   ├── Chat/             # Messaging and chat functionality
│   │   ├── Activities/       # Activity lists and management
│   │   └── Profile/          # User profile and settings
│   └── Onboarding/           # Welcome and sign-up flows
├── Models/                   # Data models (Activity, User, Message, etc.)
├── ViewModels/              # Business logic and state management
├── Services/                # Mock data and external services
└── Utils/                   # Constants, helpers, and utilities
```

## 🚀 Getting Started

### Prerequisites

- Xcode 16.0+
- iOS 18.5+ deployment target
- macOS for development

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/sal2049/ANIS.git
   cd ANIS
   ```

2. Open the project in Xcode:
   ```bash
   open ANIS.xcodeproj
   ```

3. Build and run the project (⌘+R)

Note: Group chat is mock-only for now. The Requests tab consolidates Incoming and Pending requests; Group list is a non-functional preview.

## 🎯 Core Components

### MapView
- Interactive map with custom activity pins
- Real-time search with filtering
- Activity detail sheets with join functionality

### Activity Management
- Grid-style sport selection
- Skill level categorization
- Date/time scheduling
- Location selection

### Requests
- Incoming and Pending tabs
- Accept, decline, and cancel flows with haptics and animations

## 🔧 Development

### Building
```bash
xcodebuild -scheme ANIS -destination 'platform=iOS Simulator,name=iPhone 16' build
```

### Testing
```bash
xcodebuild test -scheme ANIS -destination 'platform=iOS Simulator,name=iPhone 16'
```

## 📱 Supported Devices

- iPhone (iOS 18.5+)
- iPad (iOS 18.5+)
- Optimized for iPhone 16 and newer

## 🎨 UI Components

- Custom search bar with real-time filtering
- Interactive activity pins with detailed popups
- Modern onboarding flow
- Responsive grid layouts
- SF Symbols integration

## 🗺️ Key Features in Detail

### Smart Search
- Real-time activity filtering
- Search by sport type, location, host name
- Results counter with smooth animations

### Activity Creation
- Three-step creation with a full Pinpoint-on-Map step (interactive map + search)
- Visual sport selection grid
- Skill level and timing options

### Map Integration
- Custom activity pins with sport emojis
- Detailed activity sheets
- Location-based discovery

## 🔄 Recent Updates

- ✅ Replaced Chat with Requests tab (Incoming & Pending)
- ✅ Added interactive Pinpoint on Map step in Create Activity
- ✅ Redesigned Profile to Instagram-like layout with social capsule buttons
- ✅ Restricted Sports list across app and mock data

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Contact

- GitHub: [@sal2049](https://github.com/sal2049)
- Project Link: [https://github.com/sal2049/ANIS](https://github.com/sal2049/ANIS)

## 🙏 Acknowledgments

- SwiftUI framework
- MapKit for location services
- SF Symbols for iconography
- Community feedback and testing