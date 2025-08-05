//
//  ActivityDetailSheet.swift
//  ANISmock
//
//  Created by Salman on 08/02/1447 AH.
//

import SwiftUI

struct ActivityDetailSheet: View {
    let activity: Activity
    @Binding var isPresented: Bool
    @State private var showChat = false
    @State private var isRequesting = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Handle indicator
                            RoundedRectangle(cornerRadius: 2.5)
                .fill(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.3)) // #152C44 with opacity for handle
                .frame(width: 36, height: 5)
                .padding(.top, 8)
            
            VStack(spacing: 20) {
                // Close button and title
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267)) // #152C44 - Dark blue for icons
                    }
                    
                    Spacer()
                    
                    Text(activity.sportType.displayName)
                        .font(.headline)
                        .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267)) // #152C44 - Dark blue for text
                    
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
                
                ScrollView {
                    VStack(spacing: 24) {
                        heroSection
                        infoCardsSection
                        participantsSection
                    }
                    .padding(.horizontal, 20)
                }
                
                // Action button
                actionButtonSection
            }
        }
        .background(Color(red: 1.0, green: 0.957, blue: 0.867)) // #FFF4DD - Using the user's preferred background color
        .sheet(isPresented: $showChat) {
            ChatView(activity: activity)
        }
    }
    
    // MARK: - View Components
    
    private var heroSection: some View {
        HStack(spacing: 16) {
            // Sport icon
            ZStack {
                Circle()
                    .fill(activity.sportType.color.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Text(activity.sportType.emoji)
                    .font(.system(size: 28))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(activity.hostName) is going for \(activity.sportType.displayName) on \(activity.dateTime.formatted(date: .abbreviated, time: .shortened))")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267)) // #152C44 - Dark blue for text
                    .multilineTextAlignment(.leading)
                
                if let description = activity.description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.7)) // #152C44 with opacity for secondary text
                        .lineLimit(2)
                }
            }
            
            Spacer()
        }
    }
    
    private var infoCardsSection: some View {
        VStack(spacing: 12) {
            // Date and time info card
            InfoCardView(
                icon: "calendar",
                title: "When",
                content: activity.dateTime.formatted(date: .abbreviated, time: .shortened)
            )
            
            // Location info card
            InfoCardView(
                icon: "location",
                title: "Location",
                content: activity.location.address ?? "Location not specified"
            )
            
            // Skill level info card
            InfoCardView(
                icon: "star.fill",
                title: "Skill Level",
                content: activity.skillLevel.displayName,
                accent: activity.skillLevel.color
            )
            
            // Description if available
            if let description = activity.description {
                InfoCardView(
                    icon: "text.alignleft",
                    title: "Details",
                    content: description
                )
            }
        }
    }
    
    private var participantsSection: some View {
        HStack(spacing: 12) {
            ForEach(0..<min(activity.maxParticipants, 5), id: \.self) { index in
                Circle()
                    .fill(index < activity.currentParticipants ? 
                          AnyShapeStyle(Color(red: 0.541, green: 0.757, blue: 0.522)) : 
                          AnyShapeStyle(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.3))) // #8AC185 for filled, #152C44 with opacity for empty
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: index < activity.currentParticipants ? "person.fill" : "person")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(index < activity.currentParticipants ? .white : Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.5))
                    )
            }
            
            Spacer()
        }
    }
    
    private var actionButtonSection: some View {
        Button {
            isRequesting = true
            // Handle join request
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                isRequesting = false
                showChat = true
            }
        } label: {
            HStack {
                if isRequesting {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Text("Request")
                        .font(.system(size: 18, weight: .semibold))
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(Color(red: 0.541, green: 0.757, blue: 0.522), in: RoundedRectangle(cornerRadius: 27)) // #8AC185 - Green accent from user's palette
        }
        .buttonStyle(.plain)
        .disabled(isRequesting)
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
}

// Modern info card component following HIG
struct InfoCardView: View {
    let icon: String
    let title: String
    let content: String
    let accent: Color?
    
    init(icon: String, title: String, content: String, accent: Color? = nil) {
        self.icon = icon
        self.title = title
        self.content = content
        self.accent = accent
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(accent ?? .accentColor)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.7)) // #152C44 with opacity for labels
                
                Text(content)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267)) // #152C44 for content
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.05), in: RoundedRectangle(cornerRadius: 10)) // Light #152C44 background for cards
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