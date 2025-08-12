//
//  JoinRequest.swift
//  ANISmock
//
//  Created by Assistant.
//

import Foundation

struct JoinRequest: Identifiable, Codable {
    var id: String
    let requesterUserId: String
    let requesterName: String
    let requesterAvatar: String?
    let sportType: SportType
    let targetActivityId: String
    let targetActivityTitle: String
    var status: Status
    let createdAt: Date
    
    enum Status: String, Codable {
        case incoming
        case pending
        case accepted
        case declined
    }
    
    init(
        id: String = UUID().uuidString,
        requesterUserId: String,
        requesterName: String,
        requesterAvatar: String? = nil,
        sportType: SportType,
        targetActivityId: String,
        targetActivityTitle: String,
        status: Status,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.requesterUserId = requesterUserId
        self.requesterName = requesterName
        self.requesterAvatar = requesterAvatar
        self.sportType = sportType
        self.targetActivityId = targetActivityId
        self.targetActivityTitle = targetActivityTitle
        self.status = status
        self.createdAt = createdAt
    }
}

struct SocialLinks: Codable, Equatable {
    var instagram: String?
    var x: String?
    var snapchat: String?
    var tiktok: String?
    var website: String?
}


