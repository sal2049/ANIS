//
//  ChatListView.swift
//  ANISmock
//
//  Created by Salman on 08/02/1447 AH.
//

import SwiftUI

// Join Request Model
struct JoinRequest: Identifiable {
    let id = UUID()
    let userId: String
    let userName: String
    let userAvatar: String
    let sportType: SportType
    let activityTitle: String
    let activityId: String
}

struct ChatListView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var selectedChat: Chat?
    @State private var showChat = false
    @State private var joinRequests: [JoinRequest] = mockJoinRequests
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.082, green: 0.173, blue: 0.267) // #152C44 - Dark blue background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Activities")
                            .font(AppFonts.title)
                            .foregroundColor(Color(red: 1.0, green: 0.957, blue: 0.867)) // #FFF4DD
                        
                        Spacer()
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.lg)
                    
                    // Loading state
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: AppColors.primaryText))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            VStack(spacing: AppSpacing.lg) {
                                // Join Requests Section
                                if !joinRequests.isEmpty {
                                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                                        HStack {
                                            Text("Join Requests")
                                                .font(AppFonts.title2)
                                                .foregroundColor(Color(red: 1.0, green: 0.957, blue: 0.867)) // #FFF4DD
                                            
                                            Spacer()
                                        }
                                        .padding(.horizontal, AppSpacing.lg)
                                        
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: AppSpacing.md) {
                                                ForEach(joinRequests) { request in
                                                    JoinRequestCard(request: request) { action in
                                                        handleJoinRequest(request: request, action: action)
                                                    }
                                                }
                                            }
                                            .padding(.horizontal, AppSpacing.lg)
                                        }
                                    }
                                }
                                
                                // Group Chats Section
                                VStack(alignment: .leading, spacing: AppSpacing.md) {
                                    HStack {
                                        Text("Group Chats")
                                            .font(AppFonts.title2)
                                            .foregroundColor(Color(red: 1.0, green: 0.957, blue: 0.867)) // #FFF4DD
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal, AppSpacing.lg)
                                    
                                    LazyVStack(spacing: AppSpacing.md) {
                                        ForEach(viewModel.chats) { chat in
                                            ChatRowView(chat: chat) {
                                                selectedChat = chat
                                                showChat = true
                                            }
                                        }
                                    }
                                    .padding(.horizontal, AppSpacing.lg)
                                }
                            }
                            .padding(.top, AppSpacing.lg)
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchChats()
        }
        .sheet(isPresented: $showChat) {
            if let chat = selectedChat {
                ChatView(chat: chat)
            }
        }
    }
    
    private func handleJoinRequest(request: JoinRequest, action: JoinRequestAction) {
        withAnimation(.easeInOut(duration: 0.3)) {
            joinRequests.removeAll { $0.id == request.id }
        }
        
        // Handle the action (accept/decline)
        switch action {
        case .accept:
            print("Accepted request from \(request.userName)")
            // In real app, would call API to accept request
        case .decline:
            print("Declined request from \(request.userName)")
            // In real app, would call API to decline request
        }
    }
}

enum JoinRequestAction {
    case accept
    case decline
}

struct JoinRequestCard: View {
    let request: JoinRequest
    let onAction: (JoinRequestAction) -> Void
    
    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            // User Avatar with Sport Icon
            ZStack {
                Circle()
                    .fill(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.3)) // Light #152C44
                    .frame(width: 60, height: 60)
                
                // User emoji/icon
                Text(getUserEmoji(request.userName))
                    .font(.system(size: 24))
                
                // Sport badge
                VStack {
                    HStack {
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(request.sportType.color)
                                .frame(width: 20, height: 20)
                            
                            Text(request.sportType.emoji)
                                .font(.system(size: 10))
                        }
                        .offset(x: 4, y: -4)
                    }
                    Spacer()
                }
                .frame(width: 60, height: 60)
            }
            
            // User Name
            Text(request.userName)
                .font(AppFonts.headline)
                .foregroundColor(Color(red: 1.0, green: 0.957, blue: 0.867)) // #FFF4DD
                .lineLimit(1)
            
            // Action Buttons
            HStack(spacing: AppSpacing.xs) {
                // Decline Button
                Button(action: {
                    onAction(.decline)
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(red: 1.0, green: 0.957, blue: 0.867)) // #FFF4DD
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .fill(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.3)) // Light #152C44
                        )
                }
                .buttonStyle(.plain)
                
                // Accept Button
                Button(action: {
                    onAction(.accept)
                }) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .fill(Color(red: 0.541, green: 0.757, blue: 0.522)) // #8AC185 - Green
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(AppSpacing.md)
        .frame(width: 120)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                .fill(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.6)) // Semi-transparent #152C44
        )
    }
    
    private func getUserEmoji(_ name: String) -> String {
        let emojis = ["👤", "🧑‍💻", "👨‍🎓", "👩‍💼"]
        return emojis[abs(name.hashValue) % emojis.count]
    }
}

struct ChatRowView: View {
    let chat: Chat
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: AppSpacing.md) {
                // Chat icon
                ZStack {
                    Circle()
                        .fill(Color(red: 0.541, green: 0.757, blue: 0.522).opacity(0.2)) // Light #8AC185
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                        .foregroundColor(Color(red: 0.541, green: 0.757, blue: 0.522)) // #8AC185
                        .font(.system(size: 20))
                }
                
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    HStack {
                        Text(chat.activityTitle)
                            .font(AppFonts.headline)
                            .foregroundColor(Color(red: 1.0, green: 0.957, blue: 0.867)) // #FFF4DD
                        
                        Spacer()
                        
                        if let lastMessage = chat.lastMessage {
                            Text(lastMessage.timestamp.formatted(date: .omitted, time: .shortened))
                                .font(AppFonts.footnote)
                                .foregroundColor(Color(red: 1.0, green: 0.957, blue: 0.867).opacity(0.7)) // Light #FFF4DD
                        }
                    }
                    
                    HStack {
                        Text("\(chat.participants.count) participants")
                            .font(AppFonts.footnote)
                            .foregroundColor(Color(red: 1.0, green: 0.957, blue: 0.867).opacity(0.7)) // Light #FFF4DD
                        
                        Spacer()
                        
                        // Unread indicator
                        if chat.lastMessage != nil {
                            Circle()
                                .fill(Color(red: 0.541, green: 0.757, blue: 0.522)) // #8AC185
                                .frame(width: 8, height: 8)
                        }
                    }
                    
                    if let lastMessage = chat.lastMessage {
                        Text("\(lastMessage.senderName): \(lastMessage.content)")
                            .font(AppFonts.footnote)
                            .foregroundColor(Color(red: 1.0, green: 0.957, blue: 0.867).opacity(0.6)) // Light #FFF4DD
                            .lineLimit(1)
                    }
                }
            }
            .padding(AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                    .fill(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.3)) // Light #152C44
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Mock data
let mockChats = [
    Chat(
        activityId: "activity1",
        activityTitle: "Padel Warriors",
        participants: ["user1", "user2", "user3", "user4", "user5", "user6"],
        lastMessage: Message(
            senderId: "user1",
            senderName: "Yazeed",
            content: "Great game yesterday! Same time next week?",
            messageType: .text
        )
    ),
    Chat(
        activityId: "activity2",
        activityTitle: "Football Squad",
        participants: ["user1", "user2", "user3", "user4", "user5", "user6", "user7", "user8", "user9", "user10", "user11"],
        lastMessage: Message(
            senderId: "user2",
            senderName: "Ahmed",
            content: "Who's bringing the water bottles?",
            messageType: .text
        )
    ),
    Chat(
        activityId: "activity3",
        activityTitle: "Tennis Club",
        participants: ["user1", "user2", "user3", "user4"],
        lastMessage: Message(
            senderId: "user3",
            senderName: "Sarah",
            content: "Court booking confirmed for tomorrow",
            messageType: .text
        )
    ),
    Chat(
        activityId: "activity4",
        activityTitle: "Basketball Legends",
        participants: ["user1", "user2", "user3", "user4", "user5", "user6", "user7", "user8"],
        lastMessage: Message(
            senderId: "user4",
            senderName: "Mike",
            content: "Rain cancelled today's game 😔",
            messageType: .text
        )
    )
]

// Mock Join Requests
let mockJoinRequests = [
    JoinRequest(
        userId: "user5",
        userName: "Ahmed",
        userAvatar: "👤",
        sportType: .padel,
        activityTitle: "Padel Warriors",
        activityId: "activity1"
    ),
    JoinRequest(
        userId: "user6",
        userName: "Sarah",
        userAvatar: "👩",
        sportType: .tennis,
        activityTitle: "Tennis Club",
        activityId: "activity3"
    ),
    JoinRequest(
        userId: "user7",
        userName: "Mike",
        userAvatar: "🧑‍💻",
        sportType: .tennis,
        activityTitle: "Tennis Club",
        activityId: "activity3"
    ),
    JoinRequest(
        userId: "user8",
        userName: "Lisa",
        userAvatar: "👩‍💼",
        sportType: .basketball,
        activityTitle: "Basketball Legends",
        activityId: "activity4"
    )
]

#Preview {
    ChatListView()
} 