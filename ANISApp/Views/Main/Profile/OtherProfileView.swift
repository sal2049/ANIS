//
//  OtherProfileView.swift
//

import SwiftUI

struct OtherProfileView: View {
    let user: User
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            AppColors.primaryBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                // Custom header bar
                HStack {
                    Button(action: { dismiss() }) { 
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                    }
                    
                    Spacer()
                    
                    Text(user.name)
                        .font(AppFonts.title2)
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    // Balance space
                    Color.clear.frame(width: 24, height: 24)
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.vertical, AppSpacing.md)
                .background(.ultraThinMaterial)
                .overlay(Divider().background(AppColors.dividerColor), alignment: .bottom)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppSpacing.lg) {
                        // Header Section - Similar to ProfileView but read-only
                        OtherProfileHeaderSection(user: user)
                            .padding(.top, AppSpacing.lg)

                        // Meta Information Row - Location and joined date
                        OtherProfileMetaRow()

                        // Bio Section
                        if let bio = user.bio, !bio.isEmpty {
                            OtherProfileBioBlock(bio: bio)
                                .padding(.horizontal, AppSpacing.lg)
                        }

                        // Social Links Grid - Read-only version
                        OtherProfileConnectGrid(user: user)
                            .padding(.horizontal, AppSpacing.lg)

                        // Interests Section
                        OtherProfileInterestsSection(interests: user.interests)

                        // Past Activities Section (if available)
                        OtherProfilePastActivitiesSection()
                            .padding(.horizontal, AppSpacing.lg)
                            .padding(.bottom, AppSpacing.xl)
                    }
                }
            }
        }
        .onAppear {
            // Ensure immediate visibility on appear
        }
    }
}

// MARK: - Other Profile Components

private struct OtherProfileHeaderSection: View {
    let user: User
    
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            // Profile Image - No photo picker for other users
            ZStack {
                Circle()
                    .fill(AppColors.secondaryBackground)
                    .frame(width: 120, height: 120)
                    .overlay(Circle().stroke(AppColors.dividerColor, lineWidth: 2))
                
                Text(String(user.name.prefix(1)))
                    .font(.system(size: 48, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
            }
            
            // Name and Age
            HStack(spacing: AppSpacing.md) {
                Text(user.name)
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.primaryText)
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.vertical, AppSpacing.sm)
                    .background(RoundedRectangle(cornerRadius: AppCornerRadius.large).fill(AppColors.secondaryBackground))
                
                if let age = user.age {
                    Text("\(age)")
                        .font(AppFonts.title3)
                        .foregroundColor(AppColors.primaryText)
                        .frame(width: 64)
                        .padding(.vertical, AppSpacing.sm)
                        .background(RoundedRectangle(cornerRadius: AppCornerRadius.large).fill(AppColors.secondaryBackground))
                }
            }
        }
    }
}

private struct OtherProfileMetaRow: View {
    var body: some View {
        HStack(spacing: AppSpacing.lg) {
            Label("Riyadh, Saudi Arabia", systemImage: "mappin.and.ellipse")
                .font(AppFonts.callout)
                .foregroundColor(AppColors.secondaryText)
            Label("Member since 2024", systemImage: "calendar")
                .font(AppFonts.callout)
                .foregroundColor(AppColors.secondaryText)
        }
    }
}

private struct OtherProfileBioBlock: View {
    let bio: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text(bio)
                .font(AppFonts.body)
                .foregroundColor(AppColors.primaryText)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding()
                .background(RoundedRectangle(cornerRadius: AppCornerRadius.large).fill(AppColors.secondaryBackground))
        }
    }
}

private struct OtherProfileConnectGrid: View {
    let user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("CONNECT")
                .font(AppFonts.footnote)
                .foregroundColor(AppColors.secondaryText)
                .textCase(.uppercase)
            
            let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 2)
            LazyVGrid(columns: columns, spacing: 12) {
                ReadOnlySocialLinkCard(platform: .instagram, handle: user.instagram ?? "@username")
                ReadOnlySocialLinkCard(platform: .website, handle: user.website ?? "+966 50 123 4567")
                ReadOnlySocialLinkCard(platform: .x, handle: user.x ?? "@username")
            }
            .frame(maxWidth: .infinity)
        }
    }
}

private struct ReadOnlySocialLinkCard: View {
    let platform: ProfileSocialPlatform
    let handle: String
    
    private var brandAssetName: String? {
        switch platform {
        case .instagram: return "icon_instagram"
        case .x: return "icon_x"
        case .website: return "icon_whatsapp"
        default: return nil
        }
    }
    
    private var background: some View {
        Group {
            switch platform {
            case .instagram:
                LinearGradient(colors: [Color.purple, Color.pink, Color.orange], startPoint: .topLeading, endPoint: .bottomTrailing)
            case .x:
                LinearGradient(colors: [Color.black.opacity(0.95), Color.gray.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing)
            case .website:
                Color(red: 0.11, green: 0.75, blue: 0.29)
            case .snapchat:
                Color.yellow
            case .tiktok:
                LinearGradient(colors: [Color.black, Color(red: 0.0, green: 0.72, blue: 0.8)], startPoint: .leading, endPoint: .trailing)
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 10) {
            Group {
                if let asset = brandAssetName, UIImage(named: asset) != nil {
                    Image(asset)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                } else {
                    Image(systemName: platform == .website ? "globe" : (platform == .x ? "xmark" : "camera"))
                }
            }
            .frame(width: 20, height: 20)
            .foregroundColor(.white)

            Text(handle.isEmpty ? "Not provided" : handle)
                .font(AppFonts.subheadline)
                .foregroundColor(.white)
                .lineLimit(1)
                .truncationMode(.tail)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(height: 60)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: AppColors.shadowColor.opacity(0.2), radius: 6, x: 0, y: 4)
        // No edit pencil icon for read-only view
    }
}

private struct OtherProfileInterestsSection: View {
    let interests: [SportType]
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack {
                Text("Sports Interests")
                    .font(AppFonts.title3)
                    .foregroundColor(AppColors.primaryText)
                Spacer()
                Text("\(interests.count) sports")
                    .font(AppFonts.footnote)
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(.horizontal, AppSpacing.lg)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.md) {
                    ForEach(interests, id: \.self) { sport in
                        InterestTag(sport: sport, size: .medium)
                            .scaleEffect(1.0)
                    }
                    if interests.isEmpty {
                        Text("No interests listed")
                            .font(AppFonts.footnote)
                            .foregroundColor(AppColors.secondaryText)
                            .padding(.horizontal, AppSpacing.md)
                            .padding(.vertical, AppSpacing.sm)
                            .background(RoundedRectangle(cornerRadius: AppCornerRadius.small).fill(AppColors.secondaryBackground))
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
            }
        }
    }
}

private struct OtherProfilePastActivitiesSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack {
                Text("Recent Activities")
                    .font(AppFonts.title3)
                    .foregroundColor(AppColors.primaryText)
                Spacer()
                Text("Private")
                    .font(AppFonts.footnote)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            VStack(spacing: AppSpacing.sm) {
                Text("Activity history is private")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: AppCornerRadius.large).fill(AppColors.secondaryBackground))
            }
        }
    }
}

#Preview {
    OtherProfileView(user: User(id: "userX", name: "Ahmed", email: "a@a.com", age: 28, interests: [.football, .tennis], bio: "Hello!"))
}


