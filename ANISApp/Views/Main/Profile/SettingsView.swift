//
//  SettingsView.swift
//  ANISmock
//
//  Created by Salman on 08/02/1447 AH.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = true
    @AppStorage("didShowAppSplash") private var didShowAppSplash = true
    @State private var showLogoutAlert = false
    @State private var showDeleteAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.primaryBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header container with true centered title
                    HStack {
                        Button(action: { dismiss() }) {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .foregroundColor(AppColors.primaryText)
                        }
                        Spacer()
                    }
                    .overlay(alignment: .center) {
                        Text("Settings")
                            .font(AppFonts.title2)
                            .foregroundColor(AppColors.primaryText)
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.lg)

                    // Settings list
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: AppSpacing.md) {
                            // Settings options
                            VStack(spacing: 0) {
                                SettingsRow(icon: "person.crop.circle.badge.xmark", title: "Blocked users", action: {})
                                Divider().background(AppColors.mutedText.opacity(0.3)).padding(.leading, 60)
                                SettingsRow(icon: "exclamationmark.bubble", title: "Report an issue", action: {})
                                Divider().background(AppColors.mutedText.opacity(0.3)).padding(.leading, 60)
                                SettingsRow(icon: "star", title: "Leave a review", action: {})
                                Divider().background(AppColors.mutedText.opacity(0.3)).padding(.leading, 60)
                                SettingsRow(icon: "person", title: "Safety tips", action: {})
                            }
                            .background(RoundedRectangle(cornerRadius: AppCornerRadius.medium).fill(AppColors.secondaryBackground))
                            .padding(.horizontal, AppSpacing.lg)
                            .padding(.top, AppSpacing.lg)

                            // Action buttons
                            VStack(spacing: AppSpacing.md) {
                                Button(action: { showLogoutAlert = true }) {
                                    Text("Log out")
                                        .font(AppFonts.headline)
                                        .foregroundColor(AppColors.primaryText)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 52)
                                        .background(RoundedRectangle(cornerRadius: AppCornerRadius.medium).fill(AppColors.secondaryBackground))
                                }
                                Button(action: { showDeleteAlert = true }) {
                                    Text("Delete account")
                                        .font(AppFonts.headline)
                                        .foregroundColor(AppColors.accentRed)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 52)
                                        .background(RoundedRectangle(cornerRadius: AppCornerRadius.medium).fill(AppColors.secondaryBackground))
                                }
                                Button(action: {
                                    // Restart onboarding
                                    hasCompletedOnboarding = false
                                    didShowAppSplash = false
                                    NotificationCenter.default.post(name: .resetAppState, object: nil)
                                    dismiss()
                                }) {
                                    Text("Restart Onboarding")
                                        .font(AppFonts.headline)
                                        .foregroundColor(AppColors.primaryText)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 52)
                                        .background(RoundedRectangle(cornerRadius: AppCornerRadius.medium).fill(AppColors.secondaryBackground))
                                }
                            }
                            .padding(.horizontal, AppSpacing.lg)
                            .padding(.top, AppSpacing.lg)
                        }
                    }
                }
            }
        }
        .alert("Log Out", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Log Out", role: .destructive) {
                authViewModel.signOut()
                dismiss()
            }
        } message: {
            Text("Are you sure you want to log out?")
        }
        .alert("Delete Account", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                // Handle account deletion
                authViewModel.signOut()
                dismiss()
            }
        } message: {
            Text("This action cannot be undone. All your data will be permanently deleted.")
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.md) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(AppColors.primaryText)
                    .frame(width: 24)
                
                Text(title)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(AppColors.mutedText)
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
        .environmentObject(AuthViewModel())
} 