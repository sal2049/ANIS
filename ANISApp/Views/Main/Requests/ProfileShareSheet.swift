//
//  ProfileShareSheet.swift
//

import SwiftUI

struct ProfileShareSheet: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            AppColors.primaryBackground.ignoresSafeArea()
            VStack(spacing: AppSpacing.lg) {
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.top, AppSpacing.md)
                
                VStack(spacing: AppSpacing.md) {
                    ZStack {
                        Circle().fill(.ultraThinMaterial).frame(width: 84, height: 84)
                            .overlay(Circle().stroke(AppColors.dividerColor, lineWidth: 1))
                        Text(authViewModel.currentUser?.name.prefix(1) ?? "A")
                            .font(AppFonts.title)
                            .foregroundColor(AppColors.primaryText)
                    }
                    Text(authViewModel.currentUser?.name ?? "Me")
                        .font(AppFonts.title3)
                        .foregroundColor(AppColors.primaryText)
                }
                
                VStack(spacing: AppSpacing.sm) {
                    SocialLinkButton(platform: .instagram, handle: authViewModel.currentUser?.instagram ?? "Add Instagram", showsEdit: false, onTap: {}, onEdit: {})
                }
                .padding(.horizontal, AppSpacing.lg)
                Spacer()
            }
            .background(.ultraThinMaterial)
        }
    }
}

enum SocialPlatform { case instagram }

struct SocialLinkButton: View {
    let platform: SocialPlatform
    let handle: String
    let showsEdit: Bool
    let onTap: () -> Void
    let onEdit: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Image(systemName: "camera.aperture")
                    .foregroundColor(.white)
                Text(handle)
                    .foregroundColor(.white)
                Spacer()
                if showsEdit {
                    ZStack {
                        Circle().fill(Color.white.opacity(0.2)).frame(width: 28, height: 28)
                        Image(systemName: "pencil")
                            .foregroundColor(.white)
                            .font(.footnote)
                    }
                    .onTapGesture { onEdit() }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                LinearGradient(colors: [Color.purple, Color.red, Color.orange], startPoint: .leading, endPoint: .trailing)
            )
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}


