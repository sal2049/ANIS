//
//  ChatViewModel.swift
//  ANISmock
//
//  Created by Salman on 08/02/1447 AH.
//

import Foundation

@MainActor
class ChatViewModel: ObservableObject {
    @Published var chats: [Chat] = []
    @Published var messages: [Message] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let mockDataService = MockDataService.shared
    
    func fetchChats() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedChats = await mockDataService.fetchChats()
                await MainActor.run {
                    self.chats = fetchedChats
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to fetch chats"
                    self.isLoading = false
                }
            }
        }
    }
    
    func fetchMessages(for chatId: String) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedMessages = await mockDataService.fetchMessages(for: chatId)
                await MainActor.run {
                    self.messages = fetchedMessages
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to fetch messages"
                    self.isLoading = false
                }
            }
        }
    }
    
    func sendMessage(_ content: String, to chatId: String, from userId: String, senderName: String) {
        let message = Message(
            senderId: userId,
            senderName: senderName,
            content: content,
            messageType: .text
        )
        
        // Optimistically add the message
        messages.append(message)
        
        Task {
            let success = await mockDataService.sendMessage(message, to: chatId)
            await MainActor.run {
                if !success {
                    // Remove the message if sending failed
                    if let index = self.messages.firstIndex(where: { $0.id == message.id }) {
                        self.messages.remove(at: index)
                    }
                    self.errorMessage = "Failed to send message"
                }
            }
        }
    }
    
    func createChatForActivity(_ activity: Activity) -> Chat {
        let chat = Chat(
            activityId: activity.id,
            activityTitle: activity.title,
            participants: [activity.hostId] // Start with just the host
        )
        
        // Add to local chats
        chats.append(chat)
        
        return chat
    }
}