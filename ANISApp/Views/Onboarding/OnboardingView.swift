//
//  OnboardingView.swift
//  ANISmock
//
//  Created by Salman on 08/02/1447 AH.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentStep = 0
    @EnvironmentObject var authViewModel: AuthViewModel
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    
    var body: some View {
        ZStack {
            // Background - User's preferred color
            Color(red: 1.0, green: 0.957, blue: 0.867) // #FFF4DD
                .ignoresSafeArea()
            
            VStack {
                // Progress indicator
                HStack {
                    ForEach(0..<3) { index in
                        Rectangle()
                            .fill(index == currentStep ? Color(red: 0.541, green: 0.757, blue: 0.522) : Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.15))
                            .frame(height: 3)
                            .cornerRadius(1.5)
                    }
                }
                .padding(.horizontal, AppSpacing.xl)
                .padding(.top, AppSpacing.lg)
                
                // Content
                TabView(selection: $currentStep) {
                    WelcomeView(currentStep: $currentStep)
                        .tag(0)
                    
                    InterestsView(currentStep: $currentStep)
                        .tag(1)
                    
                    SignUpView(currentStep: $currentStep)
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.spring(response: 0.5, dampingFraction: 0.9), value: currentStep)
            }
        }
        .onChange(of: authViewModel.isAuthenticated) { _, newValue in
            if newValue { hasCompletedOnboarding = true }
        }
    }
}

struct WelcomeView: View {
    @Binding var currentStep: Int
    
    var body: some View {
        VStack(spacing: AppSpacing.xxl) {
            Spacer()
            
                // Welcome content without mascot
            VStack(spacing: AppSpacing.xl) {
                // Mascot
                Image("Mascot")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)

                // App logo text
                Text("ANIS")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267)) // #152C44
                
                VStack(spacing: AppSpacing.lg) {
                    Text("Connect through sports")
                        .font(AppFonts.title2)
                            .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppSpacing.xl)
                    
                    Text("Find, create, and join sports activities in your area with people who share your passion")
                        .font(AppFonts.body)
                            .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppSpacing.xl)
                }
            }
            
            Spacer()
            
            // Navigation buttons
            HStack {
                Button("Skip") {
                    currentStep = 2
                }
                .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267))
                .font(AppFonts.body)
                
                Spacer()
                
                // Page indicators
                HStack(spacing: AppSpacing.sm) {
                    Circle()
                        .fill(Color(red: 0.541, green: 0.757, blue: 0.522)) // #8AC185
                        .frame(width: 8, height: 8)
                    
                    Circle()
                        .fill(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.3))
                        .frame(width: 8, height: 8)
                    
                    Circle()
                        .fill(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.3))
                        .frame(width: 8, height: 8)
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.9)) {
                        currentStep += 1
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.541, green: 0.757, blue: 0.522)) // #8AC185
                            .frame(width: 50, height: 50)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                        
                        Image(systemName: "arrow.right")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                .pressable()
            }
            .padding(.horizontal, AppSpacing.xl)
            .padding(.bottom, AppSpacing.lg)
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AuthViewModel())
} 