//
//  ChatView.swift
//  ANISmock
//
//  Created by Salman on 08/02/1447 AH.
//

import SwiftUI

struct ChatView: View {
    let activity: Activity?
    let chat: Chat?
    
    @State private var messageText = ""
    @StateObject private var viewModel = ChatViewModel()
    @Environment(\.dismiss) private var dismiss
    
    init(activity: Activity) {
        self.activity = activity
        self.chat = nil
    }
    
    init(chat: Chat) {
        self.activity = nil
        self.chat = chat
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.primaryBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(AppColors.primaryText)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(chatTitle)
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.primaryText)
                            
                            Text("\(participantCount) participants")
                                .font(AppFonts.footnote)
                                .foregroundColor(AppColors.mutedText)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // Show participants
                        }) {
                            Image(systemName: "person.2")
                                .font(.title2)
                                .foregroundColor(AppColors.primaryText)
                        }
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.lg)
                    
                    // Messages
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(spacing: AppSpacing.md) {
                                ForEach(viewModel.messages) { message in
                                    MessageView(message: message)
                                }
                            }
                            .padding(.horizontal, AppSpacing.lg)
                            .padding(.top, AppSpacing.lg)
                        }
                        .onChange(of: viewModel.messages.count) { _ in
                            if let lastMessage = viewModel.messages.last {
                                withAnimation(.easeOut(duration: 0.3)) {
                                    proxy.scrollTo(lastMessage.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                    
                    // Message input
                    HStack(spacing: AppSpacing.md) {
                        TextField("Message", text: $messageText, axis: .vertical)
                            .textFieldStyle(CustomTextFieldStyle())
                            .lineLimit(1...4)
                        
                        Button(action: sendMessage) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.title2)
                                .foregroundColor(messageText.isEmpty ? AppColors.mutedText : AppColors.accentBlue)
                        }
                        .disabled(messageText.isEmpty)
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.vertical, AppSpacing.md)
                    .background(
                        Rectangle()
                            .fill(AppColors.secondaryBackground)
                            .background(.ultraThinMaterial)
                    )
                }
            }
        }
        .onAppear {
            if let chat = chat {
                viewModel.fetchMessages(for: chat.id)
            } else if let activity = activity {
                // Create a new chat for this activity
                let newChat = viewModel.createChatForActivity(activity)
                viewModel.fetchMessages(for: newChat.id)
            }
        }
    }
    
    private var chatTitle: String {
        if let activity = activity {
            return activity.title
        } else if let chat = chat {
            return chat.activityTitle
        }
        return "Chat"
    }
    
    private var participantCount: Int {
        if let activity = activity {
            return activity.maxParticipants
        } else if let chat = chat {
            return chat.participants.count
        }
        return 0
    }
    
    private var currentChatId: String {
        return chat?.id ?? activity?.id ?? ""
    }
    
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        
        let content = messageText
        messageText = ""
        
        viewModel.sendMessage(
            content,
            to: currentChatId,
            from: "currentUser",
            senderName: "You"
        )
    }
}

struct MessageView: View {
    let message: Message
    
    private var isCurrentUser: Bool {
        message.senderId == "currentUser"
    }
    
    var body: some View {
        HStack {
            if isCurrentUser {
                Spacer()
            }
            
            VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: AppSpacing.xs) {
                if !isCurrentUser {
                    Text(message.senderName)
                        .font(AppFonts.footnote)
                        .foregroundColor(AppColors.mutedText)
                }
                
                Text(message.content)
                    .font(AppFonts.body)
                    .foregroundColor(isCurrentUser ? AppColors.primaryBackground : AppColors.primaryText)
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.vertical, AppSpacing.sm)
                    .background(
                        RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                            .fill(isCurrentUser ? AppColors.accentBlue : AppColors.secondaryBackground)
                    )
                
                Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.mutedText)
            }
            
            if !isCurrentUser {
                Spacer()
            }
        }
    }
}



#Preview {
    ChatView(activity: Activity(
        title: "Padel Match",
        description: "Looking for players",
        sportType: .padel,
        hostId: "user1",
        hostName: "Yazeed",
        location: Location(latitude: 24.7136, longitude: 46.6753),
        dateTime: Date().addingTimeInterval(3600),
        maxParticipants: 4,
        skillLevel: .intermediate
    ))
} 