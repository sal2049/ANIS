//
//  ChatListView.swift
//  ANISmock
//
//  Created by Salman on 08/02/1447 AH.
//

import SwiftUI

struct ChatListView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var selectedChat: Chat?
    @State private var showChat = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.primaryBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Chat")
                            .font(AppFonts.title)
                            .foregroundColor(AppColors.primaryText)
                        
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
                        // Chat list
                        ScrollView {
                            LazyVStack(spacing: AppSpacing.md) {
                                ForEach(viewModel.chats) { chat in
                                    ChatRowView(chat: chat) {
                                        selectedChat = chat
                                        showChat = true
                                    }
                                }
                            }
                            .padding(.horizontal, AppSpacing.lg)
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
                        .fill(AppColors.secondaryBackground)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "message.2")
                        .foregroundColor(AppColors.primaryText)
                        .font(.system(size: 20))
                }
                
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    HStack {
                        Text(chat.activityTitle)
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        if let lastMessage = chat.lastMessage {
                            Text(lastMessage.timestamp.formatted(date: .omitted, time: .shortened))
                                .font(AppFonts.footnote)
                                .foregroundColor(AppColors.mutedText)
                        }
                    }
                    
                    HStack {
                        Text("\(chat.participants.count) participants")
                            .font(AppFonts.footnote)
                            .foregroundColor(AppColors.mutedText)
                        
                        Spacer()
                        
                        // Unread indicator
                        if chat.lastMessage != nil {
                            Circle()
                                .fill(AppColors.accentBlue)
                                .frame(width: 8, height: 8)
                        }
                    }
                    
                    if let lastMessage = chat.lastMessage {
                        Text("\(lastMessage.senderName): \(lastMessage.content)")
                            .font(AppFonts.footnote)
                            .foregroundColor(AppColors.secondaryText)
                            .lineLimit(1)
                    }
                }
            }
            .padding(AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                    .fill(AppColors.secondaryBackground)
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

#Preview {
    ChatListView()
} 