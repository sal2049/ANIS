//
//  ANISApp.swift
//  ANISmock
//
//  Created by Salman on 08/02/1447 AH.
//

import SwiftUI
import UIKit
// Firebase import commented out for mock data phase
// import Firebase

@main
struct ANISApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var locationPermission = LocationPermissionManager()
    
    init() {
        // Firebase configuration commented out for mock data phase
        // FirebaseApp.configure()
        #if DEBUG
        // Reset onboarding/auth state on every Run from Xcode (Debug builds only)
        UserDefaults.standard.set(false, forKey: "isSignedIn")
        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
        UserDefaults.standard.set(false, forKey: "didShowAppSplash")
        #endif

        // Tab bar: liquid/blurred glass effect
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        let itemAppearance = UITabBarItemAppearance(style: .stacked)
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.secondaryLabel]
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().tintColor = UIColor(red: 0.541, green: 0.757, blue: 0.522, alpha: 1.0)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(locationPermission)
                .preferredColorScheme(.light)
        }
    }
}
