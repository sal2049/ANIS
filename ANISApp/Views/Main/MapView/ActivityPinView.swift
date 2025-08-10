//
//  ActivityPinView.swift
//  ANISmock
//
//  Created by Salman on 08/02/1447 AH.
//

import SwiftUI

struct ActivityPinView: View {
    let activity: Activity
    let onTap: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Modern pin design following Apple Maps style
                Circle()
                    .fill(.ultraThickMaterial)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Circle()
                            .fill(activity.sportType.color.opacity(0.1))
                    )
                    .overlay(
                        Circle()
                            .stroke(activity.sportType.color, lineWidth: 2)
                    )
                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                    .scaleEffect(isPressed ? 0.95 : 1.0)
                
                // Sport icon with proper contrast
                Text(activity.sportType.emoji)
                    .font(.system(size: 20))
                
                // Modern availability badge
                if activity.availableSlots > 0 {
                    VStack {
                        HStack {
                            Spacer()
                            
                            Text("\(activity.availableSlots)")
                                .font(.system(size: 11, weight: .semibold, design: .rounded))
                                .foregroundStyle(.white)
                                .frame(width: 18, height: 18)
                                .background(
                                    Circle()
                                        .fill(Color.green.gradient)
                                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                                )
                                .offset(x: 6, y: -6)
                        }
                        
                        Spacer()
                    }
                    .frame(width: 44, height: 44)
                }
            }
        }
        .buttonStyle(.plain)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .accessibilityLabel("\(activity.sportType.displayName) activity")
        .accessibilityHint("Tap to view details")
        .accessibilityValue("\(activity.availableSlots) spots available")
    }
}

// Special pin for venues/places
struct VenuePinView: View {
    let name: String
    let type: String
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 2) {
                // Pin icon
                ZStack {
                    Circle()
                        .fill(AppColors.accentRed)
                        .frame(width: 40, height: 40)
                        .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                    
                    Image(systemName: "building.2")
                        .foregroundColor(AppColors.primaryText)
                        .font(.system(size: 16))
                }
                
                // Venue name
                Text(name)
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.primaryText)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppColors.secondaryBackground.opacity(0.9))
                    )
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 20) {
        ActivityPinView(
            activity: Activity(
                title: "Padel Match",
                description: "Looking for players",
                sportType: .padel,
                hostId: "user1",
                hostName: "Ahmed",
                location: Location(latitude: 24.7136, longitude: 46.6753),
                dateTime: Date().addingTimeInterval(3600),
                maxParticipants: 4,
                skillLevel: .intermediate
            )
        ) {
            print("Activity tapped")
        }
        
        VenuePinView(
            name: "Gravity Trampoline",
            type: "Entertainment"
        ) {
            print("Venue tapped")
        }
    }
    .padding()
    .background(AppColors.primaryBackground)
} 