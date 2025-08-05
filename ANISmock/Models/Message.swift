//
//  Message.swift
//  ANISmock
//
//  Created by Salman on 08/02/1447 AH.
//

import Foundation

struct Message: Identifiable, Codable {
    let id: String
    let senderId: String
    let senderName: String
    let content: String
    let timestamp: Date
    let messageType: MessageType
    
    enum CodingKeys: String, CodingKey {
        case id
        case senderId
        case senderName
        case content
        case timestamp
        case messageType
    }
    
    init(id: String = UUID().uuidString, senderId: String, senderName: String, content: String, messageType: MessageType = .text) {
        self.id = id
        self.senderId = senderId
        self.senderName = senderName
        self.content = content
        self.timestamp = Date()
        self.messageType = messageType
    }
}

enum MessageType: String, Codable {
    case text = "text"
    case system = "system"
    case join = "join"
    case leave = "leave"
    
    var isSystemMessage: Bool {
        return self == .system || self == .join || self == .leave
    }
}

struct Chat: Identifiable, Codable {
    let id: String
    let activityId: String
    let activityTitle: String
    var participants: [String] // User IDs
    var lastMessage: Message?
    let createdAt: Date
    var updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case activityId
        case activityTitle
        case participants
        case lastMessage
        case createdAt
        case updatedAt
    }
    
    init(id: String = UUID().uuidString, activityId: String, activityTitle: String, participants: [String] = [], lastMessage: Message? = nil) {
        self.id = id
        self.activityId = activityId
        self.activityTitle = activityTitle
        self.participants = participants
        self.lastMessage = lastMessage
        self.createdAt = Date()
        self.updatedAt = Date()
    }
} 