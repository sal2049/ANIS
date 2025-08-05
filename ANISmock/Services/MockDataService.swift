//
//  MockDataService.swift
//  ANISmock
//
//  Created by Salman on 08/02/1447 AH.
//

import Foundation
import CoreLocation

@MainActor
class MockDataService: ObservableObject {
    static let shared = MockDataService()
    
    @Published var activities: [Activity] = []
    @Published var users: [User] = []
    @Published var chats: [Chat] = []
    @Published var messages: [String: [Message]] = [:] // chatId -> messages
    
    private init() {
        generateMockData()
    }
    
    private func generateMockData() {
        // Generate mock users
        users = [
            User(
                id: "user1",
                name: "Yazeed Al-Rashid",
                email: "yazeed@example.com",
                age: 28,
                interests: [.padel, .tennis, .football],
                bio: "Padel enthusiast and sports lover. Always up for a good game!"
            ),
            User(
                id: "user2", 
                name: "Ahmed Al-Mansouri",
                email: "ahmed@example.com",
                age: 24,
                interests: [.football, .basketball, .volleyball],
                bio: "Football captain looking for team players"
            ),
            User(
                id: "user3",
                name: "Sarah Johnson",
                email: "sarah@example.com", 
                age: 26,
                interests: [.tennis, .yoga, .pilates],
                bio: "Tennis coach and fitness enthusiast"
            ),
            User(
                id: "user4",
                name: "Mike Rodriguez",
                email: "mike@example.com",
                age: 30,
                interests: [.volleyball, .surfing, .cycling],
                bio: "Beach volleyball player and adventure seeker"
            ),
            User(
                id: "user5",
                name: "Lisa Chen",
                email: "lisa@example.com",
                age: 22,
                interests: [.basketball, .tennis, .yoga],
                bio: "Basketball player and wellness advocate"
            )
        ]
        
        // Generate mock activities
        let riyadhLocations = [
            Location(latitude: 24.7136, longitude: 46.6753, address: "King Fahd Stadium, Riyadh"),
            Location(latitude: 24.7200, longitude: 46.6800, address: "Al Nakheel Sports Center"),
            Location(latitude: 24.7100, longitude: 46.6700, address: "Riyadh Tennis Club"),
            Location(latitude: 24.7150, longitude: 46.6850, address: "Prince Faisal Sports Complex"),
            Location(latitude: 24.7180, longitude: 46.6780, address: "Al Malaz Sports Center"),
            Location(latitude: 24.7050, longitude: 46.6720, address: "Diplomatic Quarter Sports Club"),
            Location(latitude: 24.7220, longitude: 46.6820, address: "Al Hamra Sports Complex"),
            Location(latitude: 24.7080, longitude: 46.6680, address: "King Saud University Sports"),
        ]
        
        activities = [
            Activity(
                title: "Padel Warriors Match",
                description: "Looking for skilled players to join our regular padel session. Great for improving technique!",
                sportType: .padel,
                hostId: "user1",
                hostName: "Yazeed Al-Rashid",
                location: riyadhLocations[0],
                dateTime: Date().addingTimeInterval(3600), // 1 hour from now
                maxParticipants: 4,
                skillLevel: .intermediate
            ),
            Activity(
                title: "5-a-side Football",
                description: "Weekly football game at the local pitch. All skill levels welcome!",
                sportType: .football,
                hostId: "user2", 
                hostName: "Ahmed Al-Mansouri",
                location: riyadhLocations[1],
                dateTime: Date().addingTimeInterval(7200), // 2 hours from now
                maxParticipants: 10,
                skillLevel: .beginner
            ),
            Activity(
                title: "Tennis Doubles Championship",
                description: "Competitive doubles match for advanced players. Prize for winners!",
                sportType: .tennis,
                hostId: "user3",
                hostName: "Sarah Johnson", 
                location: riyadhLocations[2],
                dateTime: Date().addingTimeInterval(5400), // 1.5 hours from now
                maxParticipants: 4,
                skillLevel: .advanced
            ),
            Activity(
                title: "Beach Volleyball Training", 
                description: "Indoor volleyball practice session. Great for beginners to learn the basics.",
                sportType: .volleyball,
                hostId: "user4",
                hostName: "Mike Rodriguez",
                location: riyadhLocations[3],
                dateTime: Date().addingTimeInterval(9000), // 2.5 hours from now
                maxParticipants: 12,
                skillLevel: .intermediate
            ),
            Activity(
                title: "Basketball Pick-up Game",
                description: "Casual basketball game. Come ready to play!",
                sportType: .basketball,
                hostId: "user5", 
                hostName: "Lisa Chen",
                location: riyadhLocations[4],
                dateTime: Date().addingTimeInterval(10800), // 3 hours from now
                maxParticipants: 10,
                skillLevel: .intermediate
            ),
            Activity(
                title: "Morning Yoga Session",
                description: "Peaceful morning yoga in the park. All levels welcome.",
                sportType: .yoga,
                hostId: "user3",
                hostName: "Sarah Johnson",
                location: riyadhLocations[5],
                dateTime: Date().addingTimeInterval(19800), // Tomorrow morning
                maxParticipants: 20,
                skillLevel: .beginner
            ),
            Activity(
                title: "Cycling Adventure",
                description: "30km cycling route through Riyadh. Intermediate cyclists preferred.",
                sportType: .cycling,
                hostId: "user4",
                hostName: "Mike Rodriguez", 
                location: riyadhLocations[6],
                dateTime: Date().addingTimeInterval(25200), // Tomorrow afternoon
                maxParticipants: 8,
                skillLevel: .intermediate
            ),
            Activity(
                title: "Bowling Night",
                description: "Fun bowling night with friends. Pizza and drinks included!",
                sportType: .bowling,
                hostId: "user2",
                hostName: "Ahmed Al-Mansouri",
                location: riyadhLocations[7],
                dateTime: Date().addingTimeInterval(32400), // Tomorrow evening
                maxParticipants: 16,
                skillLevel: .beginner
            )
        ]
        
        // Generate mock chats
        chats = [
            Chat(
                activityId: activities[0].id,
                activityTitle: activities[0].title,
                participants: ["user1", "user2", "user3", "user4"],
                lastMessage: Message(
                    senderId: "user1",
                    senderName: "Yazeed",
                    content: "Great game yesterday! Same time next week?",
                    messageType: .text
                )
            ),
            Chat(
                activityId: activities[1].id,
                activityTitle: activities[1].title,
                participants: ["user1", "user2", "user3", "user4", "user5"],
                lastMessage: Message(
                    senderId: "user2", 
                    senderName: "Ahmed",
                    content: "Who's bringing the water bottles?",
                    messageType: .text
                )
            ),
            Chat(
                activityId: activities[2].id,
                activityTitle: activities[2].title,
                participants: ["user1", "user3", "user4", "user5"],
                lastMessage: Message(
                    senderId: "user3",
                    senderName: "Sarah",
                    content: "Court booking confirmed for tomorrow",
                    messageType: .text
                )
            ),
            Chat(
                activityId: activities[3].id,
                activityTitle: activities[3].title,
                participants: ["user1", "user2", "user4", "user5"],
                lastMessage: Message(
                    senderId: "user4",
                    senderName: "Mike", 
                    content: "Rain cancelled today's game 😔",
                    messageType: .text
                )
            )
        ]
        
        // Generate mock messages for each chat
        generateMockMessages()
    }
    
    private func generateMockMessages() {
        for chat in chats {
            var chatMessages: [Message] = []
            
            // Add some historical messages
            chatMessages.append(Message(
                senderId: chat.participants[0],
                senderName: getUserName(chat.participants[0]),
                content: "Hey everyone! Looking forward to the game",
                messageType: .text
            ))
            
            chatMessages.append(Message(
                senderId: "system",
                senderName: "System",
                content: "\(getUserName(chat.participants[1])) joined the activity",
                messageType: .join
            ))
            
            chatMessages.append(Message(
                senderId: chat.participants[1],
                senderName: getUserName(chat.participants[1]),
                content: "Thanks for having me! What should I bring?",
                messageType: .text
            ))
            
            if chat.participants.count > 2 {
                chatMessages.append(Message(
                    senderId: chat.participants[2],
                    senderName: getUserName(chat.participants[2]),
                    content: "I can bring extra equipment if needed",
                    messageType: .text
                ))
            }
            
            // Add the last message
            if let lastMessage = chat.lastMessage {
                chatMessages.append(lastMessage)
            }
            
            messages[chat.id] = chatMessages
        }
    }
    
    private func getUserName(_ userId: String) -> String {
        return users.first { $0.id == userId }?.name ?? "User"
    }
    
    // MARK: - API Methods
    
    func fetchActivities() async -> [Activity] {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        return activities.filter { $0.dateTime > Date() } // Only future activities
    }
    
    func fetchUser(id: String) async -> User? {
        try? await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
        return users.first { $0.id == id }
    }
    
    func createActivity(_ activity: Activity) async -> Bool {
        try? await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
        activities.append(activity)
        return true
    }
    
    func joinActivity(_ activityId: String, userId: String) async -> Bool {
        try? await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
        
        if let index = activities.firstIndex(where: { $0.id == activityId }) {
            let updatedActivity = Activity(
                id: activities[index].id,
                title: activities[index].title,
                description: activities[index].description,
                sportType: activities[index].sportType,
                hostId: activities[index].hostId,
                hostName: activities[index].hostName,
                location: activities[index].location,
                dateTime: activities[index].dateTime,
                maxParticipants: activities[index].maxParticipants,
                skillLevel: activities[index].skillLevel
            )
            // In real app, would update currentParticipants
            activities[index] = updatedActivity
            return true
        }
        return false
    }
    
    func fetchChats() async -> [Chat] {
        try? await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
        return chats
    }
    
    func fetchMessages(for chatId: String) async -> [Message] {
        try? await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
        return messages[chatId] ?? []
    }
    
    func sendMessage(_ message: Message, to chatId: String) async -> Bool {
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        if messages[chatId] != nil {
            messages[chatId]?.append(message)
        } else {
            messages[chatId] = [message]
        }
        
        // Update chat's last message
        if let chatIndex = chats.firstIndex(where: { $0.id == chatId }) {
            let updatedChat = Chat(
                id: chats[chatIndex].id,
                activityId: chats[chatIndex].activityId,
                activityTitle: chats[chatIndex].activityTitle,
                participants: chats[chatIndex].participants,
                lastMessage: message
            )
            chats[chatIndex] = updatedChat
        }
        
        return true
    }
    
    func updateUserInterests(_ interests: [SportType], for userId: String) async -> Bool {
        try? await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
        
        if let userIndex = users.firstIndex(where: { $0.id == userId }) {
            let updatedUser = User(
                id: users[userIndex].id,
                name: users[userIndex].name,
                email: users[userIndex].email,
                age: users[userIndex].age,
                interests: interests,
                profileImageURL: users[userIndex].profileImageURL,
                bio: users[userIndex].bio
            )
            users[userIndex] = updatedUser
            return true
        }
        return false
    }
    
    // MARK: - Utility Methods
    
    func getRandomActivity() -> Activity? {
        return activities.randomElement()
    }
    
    func getActivitiesByUser(_ userId: String) -> [Activity] {
        return activities.filter { $0.hostId == userId }
    }
    
    func getActivitiesBySport(_ sport: SportType) -> [Activity] {
        return activities.filter { $0.sportType == sport }
    }
}