//
//  InterestsView.swift
//  ANISmock
//
//  Created by Salman on 08/02/1447 AH.
//

import SwiftUI

struct InterestsView: View {
    @Binding var currentStep: Int
    @State private var selectedInterests: Set<SportType> = []
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            // Header
            VStack(spacing: AppSpacing.md) {
                Text("What are you into?")
                    .font(AppFonts.title)
                    .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267))
                    .multilineTextAlignment(.center)
                
                Text("Select your interests to find activities that match your style")
                    .font(AppFonts.body)
                    .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppSpacing.xl)
            }
            .padding(.top, AppSpacing.xl)
            
            // Interests grid
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: AppSpacing.md) {
                    ForEach(SportType.allCases, id: \.self) { sport in
                        InterestButton(
                            sport: sport,
                            isSelected: selectedInterests.contains(sport)
                        ) {
                            if selectedInterests.contains(sport) {
                                selectedInterests.remove(sport)
                            } else {
                                selectedInterests.insert(sport)
                            }
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
            }
            
            Spacer()
            
            // Complete button
            Button(action: {
                // Persist for onboarding handoff to sign-up
                let raw = selectedInterests.map { $0.rawValue }
                UserDefaults.standard.set(raw, forKey: "onboarding_selected_interests")
                // If user already exists (returning user redoing onboarding), update immediately
                if authViewModel.currentUser != nil {
                    authViewModel.updateUserInterests(Array(selectedInterests))
                }
                withAnimation { currentStep += 1 }
            }) {
                Text("Complete")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryBackground)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                            .fill(AppColors.primaryText)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
            }
            .disabled(selectedInterests.isEmpty)
            .opacity(selectedInterests.isEmpty ? 0.5 : 1.0)
            .padding(.horizontal, AppSpacing.xl)
            .padding(.bottom, AppSpacing.lg)
        }
        .onAppear {
            // Preload from current user or previously stored onboarding selection
            if let stored = UserDefaults.standard.array(forKey: "onboarding_selected_interests") as? [String] {
                let restored = stored.compactMap { SportType(rawValue: $0) }
                selectedInterests = Set(restored)
            } else if let userInterests = authViewModel.currentUser?.interests {
                selectedInterests = Set(userInterests)
            }
        }
    }
}

struct InterestButton: View {
    let sport: SportType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.sm) {
                Text(sport.emoji)
                    .font(.system(size: 32))
                
                Text(sport.displayName)
                    .font(AppFonts.body)
                    .foregroundColor(isSelected ? Color.white : Color(red: 0.082, green: 0.173, blue: 0.267))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(
                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                    .fill(isSelected ? Color(red: 0.082, green: 0.173, blue: 0.267) : Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                            .stroke(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.15), lineWidth: 1)
                    )
            )
            .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    InterestsView(currentStep: .constant(1))
        .environmentObject(AuthViewModel())
} 