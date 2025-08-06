//
//  ProfileView.swift
//  ANISmock
//
//  Created by Salman on 08/02/1447 AH.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showSettings = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.primaryBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppSpacing.xl) {
                        // Profile header
                        VStack(spacing: AppSpacing.lg) {
                            // Profile image
                            ZStack {
                                Circle()
                                    .fill(AppColors.secondaryBackground)
                                    .frame(width: 100, height: 100)
                                
                                if let user = authViewModel.currentUser {
                                    Text(user.name.prefix(1))
                                        .font(AppFonts.largeTitle)
                                        .foregroundColor(AppColors.primaryText)
                                } else {
                                    Image(systemName: "person")
                                        .font(.system(size: 40))
                                        .foregroundColor(AppColors.primaryText)
                                }
                            }
                            
                            VStack(spacing: AppSpacing.sm) {
                                if let user = authViewModel.currentUser {
                                    Text(user.name)
                                        .font(AppFonts.title2)
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    if let age = user.age {
                                        Text("\(age) years old")
                                            .font(AppFonts.body)
                                            .foregroundColor(AppColors.secondaryText)
                                    }
                                }
                            }
                        }
                        .padding(.top, AppSpacing.xl)
                        
                        // Profile sections
                        VStack(spacing: AppSpacing.lg) {
                            // About Me section
                            ProfileSection(
                                title: "About Me",
                                isExpanded: true
                            ) {
                                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                                    HStack {
                                        Text(authViewModel.currentUser?.bio ?? "I love sports and meeting new people")
                                            .font(AppFonts.body)
                                            .foregroundColor(AppColors.primaryText)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "pencil")
                                            .foregroundColor(AppColors.mutedText)
                                    }
                                }
                            }
                            
                            // Interests section
                            ProfileSection(
                                title: "Interests",
                                isExpanded: true
                            ) {
                                LazyVGrid(columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ], spacing: AppSpacing.sm) {
                                    ForEach(authViewModel.currentUser?.interests ?? [.padel, .football, .tennis], id: \.self) { sport in
                                        InterestTag(sport: sport)
                                    }
                                }
                            }
                            
                            // Past activities section
                            ProfileSection(
                                title: "Past Activities",
                                isExpanded: true
                            ) {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: AppSpacing.md) {
                                        ForEach(mockPastActivities, id: \.date) { activity in
                                            PastActivityCard(activity: activity)
                                        }
                                    }
                                    .padding(.horizontal, AppSpacing.sm)
                                }
                            }
                        }
                        .padding(.horizontal, AppSpacing.lg)
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
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
            SettingsView()
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
    
    var body: some View {
        HStack(spacing: AppSpacing.xs) {
            Text(sport.emoji)
                .font(.system(size: 14))
            
            Text(sport.displayName)
                .font(AppFonts.footnote)
                .foregroundColor(AppColors.primaryText)
        }
        .padding(.horizontal, AppSpacing.sm)
        .padding(.vertical, AppSpacing.xs)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.small)
                .fill(sport.color.opacity(0.2))
        )
    }
}

struct PastActivityCard: View {
    let activity: PastActivity
    
    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            Text(activity.date)
                .font(AppFonts.footnote)
                .foregroundColor(AppColors.mutedText)
            
            Text(activity.sport.emoji)
                .font(.system(size: 24))
            
            Text(activity.sport.displayName)
                .font(AppFonts.caption)
                .foregroundColor(AppColors.primaryText)
        }
        .frame(width: 80, height: 80)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                .fill(AppColors.accentBlue.opacity(0.2))
        )
    }
}

// Mock data
struct PastActivity {
    let date: String
    let sport: SportType
}

let mockPastActivities = [
    PastActivity(date: "7 Sep", sport: .padel),
    PastActivity(date: "21 Oct", sport: .tennis),
    PastActivity(date: "26 Jan", sport: .tennis)
]

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
} 