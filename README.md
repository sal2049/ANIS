# 🏃‍♂️ ANISmock - Sports Activity Matching App

A modern iOS app built with SwiftUI that connects people through sports activities. Find, create, and join sports activities in your area with ease.

## ✨ Features

### 🗺️ Interactive Map
- **Activity Discovery**: Browse sports activities on an interactive map
- **Real-time Pins**: See activity locations with sport-specific icons
- **Location Services**: Find activities near you
- **Detailed Info**: Tap pins to see comprehensive activity details

### 📝 Activity Management
- **Create Activities**: Step-by-step wizard for creating sports activities
- **Sport Selection**: Choose from 12+ sports with interactive picker
- **Location Selection**: Popular venues or custom location selection
- **Skill Levels**: Beginner, Intermediate, and Advanced options
- **Participant Management**: Set and track participant limits

### 💬 Communication
- **Activity Chat**: Dedicated chat rooms for each activity
- **Real-time Messaging**: Stay connected with other participants
- **Join Requests**: Simple request system to join activities

### 🎨 Design & UX
- **Modern UI**: Clean, intuitive interface following iOS design guidelines
- **Custom Color Palette**: Carefully chosen colors (#152C44, #FFF4DD, #8AC185)
- **SF Symbols**: Native iOS icons throughout the app
- **Accessibility**: Full VoiceOver and accessibility support
- **Animations**: Smooth transitions and feedback

## 🚀 Getting Started

### Prerequisites
- **Xcode 15.0+**
- **iOS 18.5+** deployment target
- **macOS 14.0+** for development

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/ANISmock.git
   cd ANISmock
   ```

2. **Open in Xcode**
   ```bash
   open ANISmock.xcodeproj
   ```

3. **Build and Run**
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

### GitHub Setup
To connect this project to GitHub:

1. **Create a new repository** on GitHub.com:
   - Go to [github.com/new](https://github.com/new)
   - Name it `ANISmock`
   - Don't initialize with README (already exists)
   - Create repository

2. **Connect your local repository**:
   ```bash
   git remote add origin https://github.com/yourusername/ANISmock.git
   git branch -M main
   git push -u origin main
   ```

## 🏗️ Architecture

### Tech Stack
- **SwiftUI**: Modern declarative UI framework
- **MapKit**: Location services and mapping
- **Combine**: Reactive programming for data flow
- **Swift 5.9+**: Latest Swift features

### Project Structure
```
ANISmock/
├── Models/           # Data models (Activity, User, Message)
├── Views/           # SwiftUI views organized by feature
│   ├── Main/        # Core app screens
│   └── Onboarding/  # Welcome and setup flows
├── ViewModels/      # MVVM view models
├── Services/        # Data services and API layer
└── Utils/           # Utilities and constants
```

### Design Patterns
- **MVVM**: Model-View-ViewModel architecture
- **Service Layer**: Clean separation of data and business logic
- **Dependency Injection**: Flexible and testable code structure

## 🎨 Design System

### Color Palette
- **Primary Dark**: `#152C44` - Main text and UI elements
- **Background Light**: `#FFF4DD` - App background and cards
- **Accent Green**: `#8AC185` - Actions and highlights

### Typography
- **SF Pro**: System font family for consistency
- **Semantic Sizing**: Dynamic type support for accessibility

## 🚀 Features in Development

- [ ] **Real-time Location Tracking**
- [ ] **Push Notifications**
- [ ] **User Profiles & Reviews**
- [ ] **Activity History**
- [ ] **Social Features**
- [ ] **Payment Integration**

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📱 Screenshots

*Screenshots coming soon...*

## 🔧 Development Setup

### Mock Data
The app currently uses a mock data service for development:
- **Sample Activities**: Pre-populated sports activities
- **Mock Users**: Test user accounts
- **Simulated Chat**: Sample conversations

### Environment Configuration
```swift
// Development vs Production configuration
#if DEBUG
// Mock data and debug features
#else
// Production API and services
#endif
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Apple**: For the amazing SwiftUI framework
- **SF Symbols**: Beautiful iconography
- **Community**: Open source inspiration and libraries

---

**Built with ❤️ using SwiftUI**