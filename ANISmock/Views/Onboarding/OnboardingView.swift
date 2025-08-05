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
    
    var body: some View {
        ZStack {
            // Background
            AppColors.primaryBackground
                .ignoresSafeArea()
            
            VStack {
                // Progress indicator
                HStack {
                    ForEach(0..<3) { index in
                        Rectangle()
                            .fill(index == currentStep ? AppColors.accentBlue : AppColors.mutedText)
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
                .animation(.easeInOut(duration: 0.3), value: currentStep)
            }
        }
    }
}

struct WelcomeView: View {
    @Binding var currentStep: Int
    
    var body: some View {
        VStack(spacing: AppSpacing.xxl) {
            Spacer()
            
            // Owl mascot
            ZStack {
                Circle()
                    .fill(AppColors.secondaryBackground)
                    .frame(width: 150, height: 150)
                    .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
                
                // Owl face
                VStack(spacing: 12) {
                    // Eyes
                    HStack(spacing: 25) {
                        Circle()
                            .fill(AppColors.primaryText)
                            .frame(width: 25, height: 25)
                        Circle()
                            .fill(AppColors.primaryText)
                            .frame(width: 25, height: 25)
                    }
                    
                    // Beak
                    Triangle()
                        .fill(AppColors.mutedText)
                        .frame(width: 15, height: 10)
                }
            }
            
            VStack(spacing: AppSpacing.lg) {
                Text("من البادل للجرى... كل الأنشطة اللى تهمك بمكان واحد")
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppSpacing.xl)
                
                Text("شارك التمرين، الحماس، والضحك مع ناس يشبهونك")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppSpacing.xl)
            }
            
            Spacer()
            
            // Navigation buttons
            HStack {
                Button("Skip") {
                    currentStep = 2
                }
                .foregroundColor(AppColors.primaryText)
                .font(AppFonts.body)
                
                Spacer()
                
                // Page indicators
                HStack(spacing: AppSpacing.sm) {
                    Circle()
                        .fill(AppColors.accentBlue)
                        .frame(width: 8, height: 8)
                    
                    Circle()
                        .fill(AppColors.mutedText)
                        .frame(width: 8, height: 8)
                    
                    Circle()
                        .fill(AppColors.mutedText)
                        .frame(width: 8, height: 8)
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        currentStep += 1
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(AppColors.secondaryBackground)
                            .frame(width: 50, height: 50)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                        
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(AppColors.primaryText)
                    }
                }
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