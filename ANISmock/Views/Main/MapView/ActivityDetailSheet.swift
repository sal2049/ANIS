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
                .fill(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.3))
                .frame(width: 36, height: 5)
                .padding(.top, 8)
            
            // Header with close button
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
                    .font(.headline)
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
            
            // Main content
            ScrollView {
                VStack(spacing: 24) {
                    // Simple hero section
                    VStack(spacing: 16) {
                        // Sport icon
                        ZStack {
                            Circle()
                                .fill(activity.sportType.color.opacity(0.2))
                                .frame(width: 60, height: 60)
                            
                            Text(activity.sportType.emoji)
                                .font(.system(size: 28))
                        }
                        
                        // Title and description
                        VStack(spacing: 8) {
                            Text(activity.title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267))
                            
                            Text("Hosted by \(activity.hostName)")
                                .font(.subheadline)
                                .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.7))
                            
                            Text(activity.dateTime.formatted(date: .abbreviated, time: .shortened))
                                .font(.subheadline)
                                .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.7))
                            
                            if let description = activity.description {
                                Text(description)
                                    .font(.body)
                                    .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267))
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 4)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Basic info cards
                    VStack(spacing: 12) {
                        // Location
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(Color(red: 0.541, green: 0.757, blue: 0.522))
                            Text(activity.location.address ?? "Location not specified")
                                .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267))
                            Spacer()
                        }
                        .padding()
                        .background(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.05))
                        .cornerRadius(10)
                        
                        // Participants
                        HStack {
                            Image(systemName: "person.2.fill")
                                .foregroundColor(Color(red: 0.541, green: 0.757, blue: 0.522))
                            Text("\(activity.currentParticipants)/\(activity.maxParticipants) participants")
                                .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267))
                            Spacer()
                        }
                        .padding()
                        .background(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.05))
                        .cornerRadius(10)
                        
                        // Skill level
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(Color(red: 0.541, green: 0.757, blue: 0.522))
                            Text(activity.skillLevel.displayName)
                                .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267))
                            Spacer()
                        }
                        .padding()
                        .background(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.05))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 20)
            }
            
            // Action button
            Button {
                isRequesting = true
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
            .disabled(isRequesting)
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .background(Color(red: 1.0, green: 0.957, blue: 0.867))
        .onAppear {
            print("DEBUG: ActivityDetailSheet displayed for: \(activity.title)")
        }
        .sheet(isPresented: $showChat) {
            ChatView(activity: activity)
        }
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