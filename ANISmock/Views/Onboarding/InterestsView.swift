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
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Select your interests to find activities that match your style")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
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
                // Save interests to user profile
                authViewModel.updateUserInterests(Array(selectedInterests))
                
                withAnimation {
                    currentStep += 1
                }
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
                    .foregroundColor(isSelected ? AppColors.primaryBackground : AppColors.primaryText)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(
                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                    .fill(isSelected ? AppColors.primaryText : AppColors.secondaryBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                            .stroke(AppColors.mutedText.opacity(0.3), lineWidth: 1)
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