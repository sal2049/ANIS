//
//  OtherProfileView.swift
//

import SwiftUI

struct OtherProfileView: View {
    let user: User
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.primaryBackground.ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppSpacing.lg) {
                        // Header avatar
                        ZStack {
                            Circle().fill(AppColors.secondaryBackground)
                                .frame(width: 110, height: 110)
                                .overlay(Circle().stroke(AppColors.dividerColor, lineWidth: 1))
                            Text(String(user.name.prefix(1)))
                                .font(AppFonts.title)
                                .foregroundColor(AppColors.primaryText)
                        }
                        
                        Text(user.name)
                            .font(AppFonts.title2)
                            .foregroundColor(AppColors.primaryText)
                        
                        // Bio
                        if let bio = user.bio, !bio.isEmpty {
                            Text(bio)
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.primaryText)
                                .multilineTextAlignment(.center)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: AppCornerRadius.large).fill(AppColors.secondaryBackground))
                                .padding(.horizontal, AppSpacing.lg)
                        }
                        
                        // Interests
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            HStack {
                                Text("Sports Interests")
                                    .font(AppFonts.title3)
                                    .foregroundColor(AppColors.primaryText)
                                Spacer()
                                Text("\(user.interests.count) sports")
                                    .font(AppFonts.footnote)
                                    .foregroundColor(AppColors.secondaryText)
                            }
                            .padding(.horizontal, AppSpacing.lg)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: AppSpacing.sm) {
                                    ForEach(user.interests, id: \.self) { InterestTag(sport: $0) }
                                }
                                .padding(.horizontal, AppSpacing.lg)
                            }
                        }
                        
                        Spacer(minLength: AppSpacing.xl)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) { Image(systemName: "chevron.left") }
                        .foregroundColor(AppColors.primaryText)
                }
                ToolbarItem(placement: .principal) {
                    Text("Profile").font(AppFonts.title2).foregroundColor(AppColors.primaryText)
                }
            }
        }
    }
}

#Preview {
    OtherProfileView(user: User(id: "userX", name: "Ahmed", email: "a@a.com", age: 28, interests: [.football, .tennis], bio: "Hello!"))
}


