//
//  ANISApp.swift
//  ANISmock
//
//  Created by Salman on 08/02/1447 AH.
//

import SwiftUI
// Firebase import commented out for mock data phase
// import Firebase

@main
struct ANISApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    init() {
        // Firebase configuration commented out for mock data phase
        // FirebaseApp.configure()
        #if DEBUG
        // Reset onboarding/auth state on every Run from Xcode (Debug builds only)
        UserDefaults.standard.set(false, forKey: "isSignedIn")
        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
        UserDefaults.standard.set(false, forKey: "didShowAppSplash")
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .preferredColorScheme(.dark)
        }
    }
}
