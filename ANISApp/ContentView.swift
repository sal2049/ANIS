//
//  ContentView.swift
//  ANISmock
//
//  Created by Salman on 08/02/1447 AH.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @AppStorage("didShowAppSplash") private var didShowAppSplash: Bool = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @State private var showSplash = true
    
    var body: some View {
        Group {
            if showSplash {
                SplashView()
                    .simultaneousGesture(TapGesture(count: 3).onEnded {
                        // Developer reset: triple tap to reset app state in Simulator
                        didShowAppSplash = false
                        hasCompletedOnboarding = false
                        UserDefaults.standard.set(false, forKey: "isSignedIn")
                    })
                    .onAppear {
                        let delay: TimeInterval = didShowAppSplash ? 0.8 : 1.6
                        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                didShowAppSplash = true
                                showSplash = false
                            }
                        }
                    }
            } else if !hasCompletedOnboarding {
                OnboardingView()
            } else if authViewModel.isAuthenticated {
                MainTabView()
            } else {
                OnboardingView()
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showSplash)
        .animation(.easeInOut(duration: 0.5), value: authViewModel.isAuthenticated)
        .onReceive(NotificationCenter.default.publisher(for: .resetAppState)) { _ in
            didShowAppSplash = false
            hasCompletedOnboarding = false
            showSplash = true
        }
    }
}

extension Notification.Name {
    static let resetAppState = Notification.Name("resetAppState")
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
        .environmentObject(LocationPermissionManager())
}
