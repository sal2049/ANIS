//
//  ActivitiesListView.swift
//  ANISmock
//
//  Created by Salman on 08/02/1447 AH.
//

import SwiftUI

struct ActivitiesListView: View {
    @StateObject private var viewModel = MapViewModel()
    @State private var selectedActivity: Activity?
    @State private var showActivityDetail = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.primaryBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Activities")
                            .font(AppFonts.title)
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        // Notification badge
                        ZStack {
                            Circle()
                                .fill(AppColors.accentRed)
                                .frame(width: 20, height: 20)
                            
                            Text("4")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                        }
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.lg)
                    
                    // Join Requests section
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        Text("Join Requests")
                            .font(AppFonts.title2)
                            .foregroundColor(AppColors.primaryText)
                            .padding(.horizontal, AppSpacing.lg)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AppSpacing.md) {
                                ForEach(mockJoinRequests, id: \.name) { request in
                                    JoinRequestCard(request: request)
                                }
                            }
                            .padding(.horizontal, AppSpacing.lg)
                        }
                    }
                    .padding(.vertical, AppSpacing.lg)
                    
                    // Activity Groups section
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        Text("Activity Groups")
                            .font(AppFonts.title2)
                            .foregroundColor(AppColors.primaryText)
                            .padding(.horizontal, AppSpacing.lg)
                        
                        ScrollView {
                            LazyVStack(spacing: AppSpacing.md) {
                                ForEach(viewModel.activities) { activity in
                                    ActivityCardView(activity: activity) {
                                        selectedActivity = activity
                                        showActivityDetail = true
                                    }
                                }
                            }
                            .padding(.horizontal, AppSpacing.lg)
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchActivities()
        }
        .sheet(isPresented: $showActivityDetail) {
            if let activity = selectedActivity {
                ActivityDetailSheet(
                    activity: activity,
                    isPresented: $showActivityDetail
                )
            }
        }
    }
}

struct JoinRequestCard: View {
    let request: JoinRequest
    
    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            // Profile image
            ZStack {
                Circle()
                    .fill(AppColors.secondaryBackground)
                    .frame(width: 60, height: 60)
                
                Text(request.name.prefix(1))
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.primaryText)
                
                // Sport icon overlay
                VStack {
                    HStack {
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(request.sport.color)
                                .frame(width: 20, height: 20)
                            
                            Text(request.sport.emoji)
                                .font(.system(size: 10))
                        }
                    }
                    
                    Spacer()
                }
                .frame(width: 60, height: 60)
            }
            
            Text(request.name)
                .font(AppFonts.body)
                .foregroundColor(AppColors.primaryText)
            
            // Action buttons
            HStack(spacing: AppSpacing.sm) {
                Button(action: {
                    // Decline request
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                        .frame(width: 24, height: 24)
                        .background(
                            Circle()
                                .fill(AppColors.secondaryBackground)
                        )
                }
                
                Button(action: {
                    // Accept request
                }) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                        .frame(width: 24, height: 24)
                        .background(
                            Circle()
                                .fill(AppColors.accentGreen)
                        )
                }
            }
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.shadowColor, radius: 3, x: 0, y: 1)
        )
        .frame(width: 120)
    }
}

struct ActivityCardView: View {
    let activity: Activity
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: AppSpacing.md) {
                // Sport icon
                ZStack {
                    Circle()
                        .fill(AppColors.secondaryBackground)
                        .frame(width: 50, height: 50)
                    
                    Text(activity.sportType.emoji)
                        .font(.system(size: 24))
                }
                
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    HStack {
                        Text(activity.title)
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        // Unread messages badge
                        if activity.sportType == .football {
                            ZStack {
                                Circle()
                                    .fill(AppColors.accentBlue)
                                    .frame(width: 20, height: 20)
                                
                                Text("3")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(AppColors.primaryText)
                            }
                        }
                    }
                    
                    HStack {
                        Image(systemName: "person.2")
                            .foregroundColor(AppColors.mutedText)
                        
                        Text("\(activity.currentParticipants)/\(activity.maxParticipants)")
                            .font(AppFonts.footnote)
                            .foregroundColor(AppColors.mutedText)
                    }
                    
                    Text("\(activity.hostName): Looking for players to join!")
                        .font(AppFonts.footnote)
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(1)
                    
                    HStack {
                        Spacer()
                        
                        Text("2h ago")
                            .font(AppFonts.footnote)
                            .foregroundColor(AppColors.mutedText)
                    }
                }
            }
            .padding(AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                    .fill(AppColors.cardBackground)
                    .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Mock data
struct JoinRequest {
    let name: String
    let sport: SportType
}

let mockJoinRequests = [
    JoinRequest(name: "Ahmed", sport: .padel),
    JoinRequest(name: "Sarah", sport: .football),
    JoinRequest(name: "Mike", sport: .tennis),
    JoinRequest(name: "Lisa", sport: .basketball)
]



#Preview {
    ActivitiesListView()
} 