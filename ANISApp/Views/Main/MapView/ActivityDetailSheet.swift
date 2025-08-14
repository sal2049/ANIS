//
//  ActivityDetailSheet.swift
//  ANISmock
//
//  Created by Salman on 08/02/1447 AH.
//

import SwiftUI
import MapKit
import Combine

struct ActivityDetailSheet: View {
    let activity: Activity
    @Binding var isPresented: Bool
    @State private var showRequestPending = false
    @State private var isRequesting = false
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Handle indicator
            RoundedRectangle(cornerRadius: 2.5)
                .fill(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.3))
                .frame(width: 36, height: 5)
                .padding(.top, 8)
            
            // Header with close button and sport name
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267))
                }
                
                Spacer()
                
                Text(activity.sportType.displayName)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267))
                
                Spacer()
                
                // Invisible button for balance
                Button(action: {}) {
                    Image(systemName: "xmark")
                        .font(.title2)
                }
                .opacity(0)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            
            // Main scrollable content
            ScrollView {
                VStack(spacing: 24) {
                    // Hero section with sport icon and details
                    HStack(spacing: 16) {
                        // Sport icon
                        ZStack {
                            Circle()
                                .fill(activity.sportType.color.opacity(0.2))
                                .frame(width: 60, height: 60)
                            
                Text(activity.sportType.emoji)
                                .font(.system(size: 28))
                        }
                        
                        // Activity details
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(activity.hostName) is going for \(activity.sportType.displayName) on \(activity.dateTime.formatted(date: .abbreviated, time: .shortened))")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267))
                                .multilineTextAlignment(.leading)
                            
                            if let description = activity.description {
                                Text(description)
                                    .font(.subheadline)
                                    .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.7))
                                    .lineLimit(3)
                                    .padding(.top, 2)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    // Participants inline avatar stack directly under hero
                    HStack(spacing: -10) {
                        let maxShown = min(activity.maxParticipants, 6)
                        ForEach(0..<maxShown, id: \.self) { index in
                            ZStack {
                                Circle()
                                    .fill(index < activity.currentParticipants ? Color(red: 0.541, green: 0.757, blue: 0.522) : Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.2))
                                    .frame(width: 32, height: 32)
                                Text(index < activity.currentParticipants ? "\(index+1)" : "")
                                    .font(.caption2)
                                    .foregroundColor(.white)
                            }
                            .overlay(Circle().stroke(Color.white.opacity(0.8), lineWidth: 1))
                        }
                        if activity.currentParticipants > 6 {
                            let overflow = activity.currentParticipants - 6
                            Text("+\(overflow)")
                                .font(AppFonts.footnote)
                                .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267))
                                .padding(.leading, 6)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    // Info cards section
                    VStack(spacing: 12) {
                        // When
                        InfoCard(
                            icon: "calendar",
                            iconColor: Color(red: 0.541, green: 0.757, blue: 0.522),
                            title: "When",
                            content: activity.dateTime.formatted(date: .abbreviated, time: .shortened)
                        )
                        
                        // Location
                        InfoCard(
                            icon: "location",
                            iconColor: Color(red: 0.541, green: 0.757, blue: 0.522),
                            title: "Location",
                            content: activity.location.address ?? "Location not specified"
                        )
                        
                        // Skill Level
                        InfoCard(
                            icon: "star.fill",
                            iconColor: Color(red: 0.541, green: 0.757, blue: 0.522),
                            title: "Skill Level",
                            content: activity.skillLevel.displayName
                        )
                        
                        // Details (if description exists)
                        if let description = activity.description {
                            InfoCard(
                                icon: "text.alignleft",
                                iconColor: Color(red: 0.541, green: 0.757, blue: 0.522),
                                title: "Details",
                                content: description
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Removed older large participants row to avoid duplication
                }
                .padding(.bottom, 20)
            }
            
            // Action button
            Button {
                isRequesting = true
                Task {
                    let uid = authViewModel.currentUser?.id
                    let requesterId = (MockDataService.shared.users.contains { $0.id == uid } ? (uid ?? "user1") : "user1")
                    _ = await MockDataService.shared.sendJoinRequest(activityId: activity.id, requesterUserId: requesterId)
                    await MainActor.run {
                        isRequesting = false
                        showRequestPending = true
                        NotificationCenter.default.post(name: .didSendJoinRequest, object: nil)
                    }
                }
            } label: {
                HStack {
                    if isRequesting {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Text("Request to Join")
                            .font(.system(size: 18, weight: .semibold))
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(Color(red: 0.541, green: 0.757, blue: 0.522), in: RoundedRectangle(cornerRadius: 27))
            }
            .buttonStyle(.plain)
            .pressable()
            .disabled(isRequesting)
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .background(Color(red: 1.0, green: 0.957, blue: 0.867))
        .onAppear {
            print("DEBUG: ActivityDetailSheet displayed for: \(activity.title)")
        }
        .alert("Request Sent", isPresented: $showRequestPending) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your request to join has been sent. You can track it under Requests > Pending.")
        }
    }
}

// Info card component that matches the design in the screenshot
struct InfoCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let content: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(iconColor)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.7))
                
                Text(content)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267))
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.05))
        .cornerRadius(10)
    }
}

#Preview {
    ZStack {
        Color(red: 1.0, green: 0.957, blue: 0.867) // #FFF4DD - Light background
            .ignoresSafeArea()
        
        ActivityDetailSheet(
            activity: Activity(
                title: "Padel Match",
                description: "Looking for players to join our game",
                sportType: .padel,
                hostId: "user1",
                hostName: "Yazeed",
                location: Location(latitude: 24.7136, longitude: 46.6753),
                dateTime: Date().addingTimeInterval(3600),
                maxParticipants: 4,
                skillLevel: .intermediate
            ),
            isPresented: .constant(true)
        )
    }
} 