//
//  GroupsMockView.swift
//

import SwiftUI

struct GroupsMockView: View {
    @State private var showComingSoon = false
    private let groups: [MockGroup] = MockGroup.samples
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: AppSpacing.md) {
                ForEach(groups) { group in
                    GroupRow(group: group)
                        .onTapGesture { showComingSoon = true }
                        .animatedOnAppear()
                }
            }
            .padding(.vertical, AppSpacing.lg)
        }
        .sheet(isPresented: $showComingSoon) {
            VStack(spacing: AppSpacing.md) {
                Text("Activity Groups")
                    .font(AppFonts.title2)
                Text("Coming soon")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.secondaryText)
                Button("Close") { showComingSoon = false }
                    .pressable()
                    .padding(.top, AppSpacing.md)
            }
            .padding()
            .presentationDetents([.medium])
        }
    }
}

private struct GroupRow: View {
    let group: MockGroup
    
    var body: some View {
        HStack(alignment: .top, spacing: AppSpacing.md) {
            ZStack {
                Circle()
                    .fill(group.sport.color.opacity(0.25))
                    .frame(width: 44, height: 44)
                Text(group.sport.emoji)
                    .font(.system(size: 20))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(group.name)
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(1)
                    Text("\(group.memberCount) members")
                        .font(AppFonts.footnote)
                        .foregroundColor(AppColors.secondaryText)
                    Spacer()
                    Text(group.lastMessageTime)
                        .font(AppFonts.footnote)
                        .foregroundColor(AppColors.secondaryText)
                }
                
                HStack(spacing: 6) {
                    Text(group.lastMessageSender)
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(1)
                    Text(": ")
                        .foregroundColor(AppColors.secondaryText)
                    Text(group.lastMessage)
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(1)
                    Spacer()
                    if group.unreadCount > 0 {
                        Text("\(group.unreadCount)")
                            .font(AppFonts.footnote)
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Capsule().fill(AppColors.accentBlue))
                    }
                }
            }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: AppCornerRadius.large).fill(AppColors.cardBackground))
        .overlay(RoundedRectangle(cornerRadius: AppCornerRadius.large).stroke(AppColors.dividerColor, lineWidth: 1))
    }
}

private struct MockGroup: Identifiable {
    let id = UUID().uuidString
    let sport: SportType
    let name: String
    let memberCount: Int
    let lastMessageSender: String
    let lastMessage: String
    let lastMessageTime: String
    let unreadCount: Int
    
    static let samples: [MockGroup] = [
        MockGroup(sport: .football, name: "Riyadh 5v5 Football", memberCount: 28, lastMessageSender: "Ahmed", lastMessage: "Match at 8?", lastMessageTime: "2m", unreadCount: 3),
        MockGroup(sport: .padel, name: "Padel Warriors", memberCount: 16, lastMessageSender: "Sara", lastMessage: "Court booked", lastMessageTime: "10m", unreadCount: 0),
        MockGroup(sport: .tennis, name: "Weekend Tennis Club", memberCount: 12, lastMessageSender: "Yazeed", lastMessage: "Anyone free Sat?", lastMessageTime: "1h", unreadCount: 5)
    ]
}


