//
//  ProfileView.swift
//  ANISmock
//
//  Created by Salman on 08/02/1447 AH.
//

import SwiftUI
import PhotosUI
import UIKit

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showSettings = false
    @State private var showEdit = false
    @State private var showImagePicker = false
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.primaryBackground.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppSpacing.lg) {
                        // Header
                        VStack(spacing: AppSpacing.md) {
                            ZStack {
                                if let image = selectedImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 120)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(AppColors.dividerColor, lineWidth: 2))
                                } else {
                                    Circle()
                                        .fill(AppColors.secondaryBackground)
                                        .frame(width: 120, height: 120)
                                        .overlay(Circle().stroke(AppColors.dividerColor, lineWidth: 2))
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 56, height: 56)
                                        .foregroundColor(AppColors.primaryText)
                                }

                                // Camera badge
                                VStack { Spacer() }
                                    .overlay(alignment: .bottomTrailing) {
                                        PhotosPicker(selection: $selectedItem, matching: .images) {
                                            ZStack {
                                                Circle().fill(Color.white)
                                                    .frame(width: 34, height: 34)
                                                Image(systemName: "camera")
                                                    .foregroundColor(.black)
                                                    .font(.caption)
                                            }
                                        }
                                    }
                                    .frame(width: 120, height: 120)
                            }

                            // Name and age chips
                            HStack(spacing: AppSpacing.md) {
                                Text(authViewModel.currentUser?.name ?? "User")
                                    .font(AppFonts.title2)
                                    .foregroundColor(AppColors.primaryText)
                                    .padding(.horizontal, AppSpacing.lg)
                                    .padding(.vertical, AppSpacing.sm)
                                    .background(RoundedRectangle(cornerRadius: AppCornerRadius.large).fill(AppColors.secondaryBackground))
                                if let age = authViewModel.currentUser?.age {
                                    Text("\(age)")
                                        .font(AppFonts.title3)
                                        .foregroundColor(AppColors.primaryText)
                                        .frame(width: 64)
                                        .padding(.vertical, AppSpacing.sm)
                                        .background(RoundedRectangle(cornerRadius: AppCornerRadius.large).fill(AppColors.secondaryBackground))
                                }
                            }
                        }
                        .padding(.top, AppSpacing.lg)

                        // Meta row
                        HStack(spacing: AppSpacing.lg) {
                            Label("Riyadh, Saudi Arabia", systemImage: "mappin.and.ellipse")
                                .font(AppFonts.callout)
                                .foregroundColor(AppColors.secondaryText)
                            Label("Joined March 2024", systemImage: "calendar")
                                .font(AppFonts.callout)
                                .foregroundColor(AppColors.secondaryText)
                        }

                        // Bio block
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text(authViewModel.currentUser?.bio ?? "Fitness enthusiast | Morning runner | Tennis player | Always up for new adventures in Riyadh")
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.primaryText)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: AppCornerRadius.large).fill(AppColors.secondaryBackground))
                        }
                        .padding(.horizontal, AppSpacing.lg)

                        // Connect grid (compact cards)
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("CONNECT").font(AppFonts.footnote).foregroundColor(AppColors.secondaryText).textCase(.uppercase)
                            let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)
                            LazyVGrid(columns: columns, spacing: 12) {
                                CompactSocialLinkCard(platform: .instagram, handle: authViewModel.currentUser?.instagram ?? "@username", onEdit: { showEdit = true })
                                CompactSocialLinkCard(platform: .website, handle: authViewModel.currentUser?.website ?? "+966 50 123 4567", onEdit: { showEdit = true })
                                CompactSocialLinkCard(platform: .x, handle: authViewModel.currentUser?.x ?? "@username", onEdit: { showEdit = true })
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal, AppSpacing.lg)

                        // Interests compact list
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            HStack {
                                Text("Sports Interests")
                                    .font(AppFonts.title3)
                                    .foregroundColor(AppColors.primaryText)
                                Spacer()
                                Text("\(authViewModel.currentUser?.interests.count ?? 0) sports")
                                    .font(AppFonts.footnote)
                                    .foregroundColor(AppColors.secondaryText)
                            }
                            .padding(.horizontal, AppSpacing.lg)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: AppSpacing.md) {
                                    ForEach(authViewModel.currentUser?.interests ?? [], id: \.self) { sport in
                                        InterestTag(sport: sport, size: .medium)
                                            .scaleEffect(1.0)
                                    }
                                    // If no interests yet, show add hint
                                    if (authViewModel.currentUser?.interests.isEmpty ?? true) {
                                        Text("Add your interests from Edit")
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

                        // Past Activities (redesigned)
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            HStack {
                                Text("Past Activities")
                                    .font(AppFonts.title3)
                                    .foregroundColor(AppColors.primaryText)
                                Spacer()
                                Text("\(mockPastActivities.count) activities")
                                    .font(AppFonts.footnote)
                                    .foregroundColor(AppColors.secondaryText)
                            }
                            VStack(spacing: AppSpacing.md) {
                                ForEach(mockPastActivities, id: \.id) { activity in
                                    ActivityHistoryCard(activity: activity)
                                }
                            }
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.bottom, AppSpacing.xl)
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showEdit = true }) {
                        HStack(spacing: 6) {
                            Image(systemName: "pencil.circle.fill")
                            Text("Edit")
                        }
                        .foregroundColor(AppColors.primaryText)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showSettings = true
                    }) {
                        Image(systemName: "gearshape")
                            .foregroundColor(AppColors.primaryText)
                    }
                }
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView().environmentObject(authViewModel)
        }
        .sheet(isPresented: $showEdit) {
            ProfileEditView().environmentObject(authViewModel)
        }
        .onChange(of: selectedItem) { _, newValue in
            guard let item = newValue else { return }
            Task {
                if let data = try? await item.loadTransferable(type: Data.self), let uiImage = UIImage(data: data) {
                    await MainActor.run { self.selectedImage = uiImage }
                }
            }
        }
    }
}

struct ProfileSection<Content: View>: View {
    let title: String
    let isExpanded: Bool
    let content: Content
    
    init(title: String, isExpanded: Bool = false, @ViewBuilder content: () -> Content) {
        self.title = title
        self.isExpanded = isExpanded
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text(title)
                    .font(AppFonts.title3)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.up")
                    .foregroundColor(AppColors.mutedText)
                    .rotationEffect(.degrees(isExpanded ? 0 : 180))
            }
            
            if isExpanded {
                content
            }
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                .fill(AppColors.secondaryBackground)
        )
    }
}

struct InterestTag: View {
    let sport: SportType
    enum Size { case small, medium, large }
    var size: Size = .small
    
    var body: some View {
        let height: CGFloat = {
            switch size { case .small: return 22; case .medium: return 28; case .large: return 34 }
        }()
        let font: Font = {
            switch size { case .small: return AppFonts.caption; case .medium: return AppFonts.subheadline; case .large: return AppFonts.body }
        }()
        HStack(spacing: AppSpacing.xs) {
            Text(sport.emoji).font(.system(size: size == .small ? 14 : size == .medium ? 16 : 18))
            Text(sport.displayName)
                .font(font)
                .foregroundColor(AppColors.primaryText)
        }
        .padding(.horizontal, AppSpacing.sm)
        .frame(height: height)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.small)
                .fill(sport.color.opacity(0.2))
        )
    }
}

struct ActivityHistoryCard: View {
    let activity: PastActivity
    
    private var statusColor: Color {
        switch activity.status {
        case .completed: return AppColors.accentGreen
        case .cancelled: return AppColors.accentRed
        }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: AppSpacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(activity.sport.color.opacity(0.25))
                    .frame(width: 56, height: 56)
                Text(activity.sport.emoji).font(.system(size: 22))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .center, spacing: 8) {
                    Text(activity.title)
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(1)
                    Spacer()
                    Text(activity.status.rawValue)
                        .font(AppFonts.footnote)
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(statusColor.opacity(0.9)))
                }
                Text(activity.sport.displayName)
                    .font(AppFonts.subheadline)
                    .foregroundColor(AppColors.secondaryText)
                
                HStack(spacing: AppSpacing.lg) {
                    HStack(spacing: 6) {
                        Image(systemName: "calendar")
                        Text(activity.date)
                    }
                    .foregroundColor(AppColors.secondaryText)
                    .font(AppFonts.footnote)
                    
                    HStack(spacing: 6) {
                        Image(systemName: "mappin.and.ellipse")
                        Text(activity.location)
                    }
                    .foregroundColor(AppColors.secondaryText)
                    .font(AppFonts.footnote)
                }
                
                HStack(spacing: AppSpacing.lg) {
                    HStack(spacing: 6) {
                        Image(systemName: "person.2")
                        Text("\(activity.participants) people")
                    }
                    .foregroundColor(AppColors.secondaryText)
                    .font(AppFonts.footnote)
                    
                    HStack(spacing: 6) {
                        Image(systemName: "clock")
                        Text(activity.duration)
                    }
                    .foregroundColor(AppColors.secondaryText)
                    .font(AppFonts.footnote)
                }
            }
        }
        .padding(AppSpacing.md)
        .background(RoundedRectangle(cornerRadius: AppCornerRadius.large).fill(AppColors.cardBackground))
        .overlay(
            RoundedRectangle(cornerRadius: AppCornerRadius.large)
                .stroke(AppColors.dividerColor, lineWidth: 1)
        )
    }
}

// Mock data
enum PastActivityStatus: String { case completed, cancelled }

struct PastActivity: Identifiable {
    let id = UUID().uuidString
    let title: String
    let sport: SportType
    let date: String
    let location: String
    let participants: Int
    let duration: String
    let status: PastActivityStatus
}

let mockPastActivities: [PastActivity] = [
    PastActivity(title: "Morning Football Match", sport: .football, date: "Jan 15, 2024", location: "King Fahd Stadium", participants: 22, duration: "2h 30m", status: .completed),
    PastActivity(title: "Tennis Tournament", sport: .tennis, date: "Jan 10, 2024", location: "Riyadh Tennis Club", participants: 8, duration: "4h 15m", status: .completed),
    PastActivity(title: "Basketball Practice", sport: .basketball, date: "Jan 8, 2024", location: "Sports City", participants: 12, duration: "1h 45m", status: .cancelled)
]

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
} 