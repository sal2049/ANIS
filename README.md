# Anis (أنيس) - iOS Sports Activity App

A modern iOS app that connects people through sports activities in Saudi Arabia. Built with SwiftUI and Firebase.

## 🎯 Project Overview

**Problem Statement:** Young adults in Saudi cities struggle to quickly fill or join group activities when plans change last minute, so spontaneous fun is often lost.

**Solution:** A focused, low-friction app that lets users see, host, or join real-time group sports within minutes.

## 🏗️ Architecture

- **Framework:** SwiftUI + MVVM
- **Backend:** Firebase (Firestore + Auth)
- **Maps:** MapKit with dark mode
- **Target:** iOS 17+
- **Design:** Dark mode focused with frosted glass effects

## 🎨 Design System

### Color Palette
- **Primary Background:** Dark blue-grey (#1A1A2E)
- **Secondary Background:** Dark grey (#2A2A3E)
- **Accent Colors:** Green (#4CAF50), Red (#FF0000), Blue (#007AFF), Pink (#FF69B4)
- **Text:** White (primary), Light grey (secondary)

### Typography
- **Primary Font:** San Francisco (System)
- **Weights:** Regular, Medium, Bold
- **Sizes:** 12pt (caption) to 34pt (large title)

## 📱 Key Features

### ✅ Implemented (MVP)
1. **Onboarding Flow**
   - Splash screen with Anis owl mascot
   - Welcome screen with Arabic text
   - Interests selection
   - Apple Sign In

2. **Live Map View**
   - Dark-mode MapKit integration
   - Activity pins with sport icons
   - Search bar with frosted glass effect
   - Activity detail sheets

3. **Activity Management**
   - Two-step create flow (Details → Location)
   - Activity listing with join requests
   - Skill level tagging (Beginner/Intermediate/Advanced)

4. **Chat System**
   - Activity-specific group chats
   - Real-time messaging (Firebase)
   - Join/leave notifications

5. **Profile & Settings**
   - User profile with interests
   - Past activities tracking
   - Settings with safety features

### 🔄 Current State
- **Mock Data Backend**: Complete implementation with simulated network delays
- **Ready for Firebase**: Easy migration path when ready for production backend
- **Functional MVP**: All features working with realistic mock data
- **Performance Optimized**: Efficient loading states and animations

## 🚀 Implementation Plan

### Phase 1: Foundation (Days 1-2) ✅
- [x] Project setup and navigation
- [x] Design system implementation
- [x] Basic UI components
- [x] Color scheme and typography

### Phase 2: Core Features (Days 3-6) ✅
- [x] Map integration with MapKit
- [x] Activity creation flow
- [x] Basic chat functionality
- [x] Mock data implementation

### Phase 3: Polish & Integration (Days 7-9) ✅
- [x] Activity detail sheets
- [x] Join/request functionality
- [x] Chat UI completion
- [x] Profile screens

### Phase 4: Onboarding & Auth (Days 10-11) ✅
- [x] Splash screen with animations
- [x] Welcome flow with Arabic text
- [x] Interests selection
- [x] Sign up process

### Phase 5: Testing & Launch Prep (Days 12-14) 🔄
- [ ] Bug fixes and optimization
- [ ] Firebase integration
- [ ] TestFlight preparation
- [ ] App Store assets

## 📁 Project Structure

```
ANISmock/
├── App/
│   ├── ANISmockApp.swift
│   └── ContentView.swift
├── Views/
│   ├── Onboarding/
│   │   ├── SplashView.swift
│   │   ├── OnboardingView.swift
│   │   ├── InterestsView.swift
│   │   └── SignUpView.swift
│   ├── Main/
│   │   ├── MainTabView.swift
│   │   ├── MapView/
│   │   │   ├── MapView.swift
│   │   │   ├── ActivityPinView.swift
│   │   │   └── ActivityDetailSheet.swift
│   │   ├── Activities/
│   │   │   └── ActivitiesListView.swift
│   │   ├── Chat/
│   │   │   ├── ChatListView.swift
│   │   │   └── ChatView.swift
│   │   └── Profile/
│   │       ├── ProfileView.swift
│   │       └── SettingsView.swift
│   └── CreateActivityView.swift
├── Models/
│   ├── User.swift
│   ├── Activity.swift
│   └── Message.swift
├── ViewModels/
│   ├── AuthViewModel.swift
│   └── MapViewModel.swift
└── Utils/
    └── Constants.swift
```

## 🛠️ Setup Instructions

### Prerequisites
- Xcode 15.0+
- iOS 17.0+
- Firebase account

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd ANISmock
   ```

2. **Open in Xcode**
   ```bash
   open ANISmock.xcodeproj
   ```

3. **Configure Firebase**
   - Create a new Firebase project
   - Download `GoogleService-Info.plist`
   - Replace the placeholder file in the project
   - Enable Authentication and Firestore

4. **Add Firebase dependencies**
   - Add via Swift Package Manager:
     - `https://github.com/firebase/firebase-ios-sdk`
   - Select: FirebaseAuth, FirebaseFirestore

5. **Build and run**
   - Select your target device
   - Press Cmd+R to build and run

## 🎯 User Personas

### Hadi – Host
- 26 y/o padel fan
- Wants fast way to publish openings
- Needs to build balanced teams

### Leila – Joiner
- 23 y/o newcomer to Riyadh
- Seeks safe, nearby sports
- Wants to join spontaneously

### Omar – Captain
- 30 y/o football enthusiast
- Organizes weekly pick-up games
- Needs one hub for coordination

## 📊 Success Metrics

### Quantitative (30 days post-launch)
- 500+ unique users
- ≥20% Day-7 retention
- ≥50 sports activities created
- ≥70% average fill-rate
- ≥98% crash-free session rate

### Qualitative
- Ship stable MVP in <60s activity creation
- Focused, low-friction experience
- No social-media noise

## 🔧 Technical Stack

### Frontend
- **SwiftUI** - Modern declarative UI
- **MapKit** - Location and mapping
- **Combine** - Reactive programming

### Backend
- **Firebase Auth** - User authentication
- **Firestore** - Real-time database
- **Firebase Storage** - File storage (future)

### Design
- **Dark Mode** - Primary theme
- **Frosted Glass** - Modern iOS aesthetic
- **Arabic Support** - Localized content

## 🚨 Known Issues & TODOs

### High Priority
- [ ] Implement real Firebase integration
- [ ] Add Apple Sign In functionality
- [ ] Implement location services
- [ ] Add push notifications

### Medium Priority
- [ ] Add activity filtering
- [ ] Implement user blocking
- [ ] Add activity reporting
- [ ] Add activity search

### Low Priority
- [ ] Add activity photos
- [ ] Implement team balancing
- [ ] Add social media links
- [ ] Add activity reminders

## 📱 Screenshots

The app includes the following key screens:
1. **Splash Screen** - Anis owl mascot with Arabic tagline
2. **Onboarding** - Welcome, interests selection, sign up
3. **Map View** - Dark mode map with activity pins
4. **Activity Details** - Bottom sheet with join functionality
5. **Chat** - Activity-specific group conversations
6. **Profile** - User information and settings

## 🤝 Contributing

This is a 14-day MVP sprint. For contributions:
1. Follow the existing code style
2. Use the established design system
3. Add tests for new features
4. Update documentation

## 📄 License

This project is proprietary and confidential.

## 📞 Support

For questions or issues:
- Create an issue in the repository
- Contact the development team
- Check the Firebase documentation

---

**Built with ❤️ for the Saudi sports community** 