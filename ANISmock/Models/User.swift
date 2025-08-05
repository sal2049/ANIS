//
//  User.swift
//  ANISmock
//
//  Created by Salman on 08/02/1447 AH.
//

import Foundation
import SwiftUI

struct User: Identifiable, Codable {
    let id: String
    let name: String
    let email: String
    let age: Int?
    let interests: [SportType]
    let profileImageURL: String?
    let bio: String?
    let createdAt: Date
    let lastActive: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case age
        case interests
        case profileImageURL
        case bio
        case createdAt
        case lastActive
    }
    
    init(id: String, name: String, email: String, age: Int? = nil, interests: [SportType] = [], profileImageURL: String? = nil, bio: String? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.age = age
        self.interests = interests
        self.profileImageURL = profileImageURL
        self.bio = bio
        self.createdAt = Date()
        self.lastActive = Date()
    }
}

enum SportType: String, CaseIterable, Codable {
    case padel = "padel"
    case football = "football"
    case tennis = "tennis"
    case volleyball = "volleyball"
    case basketball = "basketball"
    case yoga = "yoga"
    case cycling = "cycling"
    case surfing = "surfing"
    case bowling = "bowling"
    case golf = "golf"
    case pilates = "pilates"
    case boardGames = "boardGames"
    
    var displayName: String {
        switch self {
        case .padel: return "Padel"
        case .football: return "Football"
        case .tennis: return "Tennis"
        case .volleyball: return "Volleyball"
        case .basketball: return "Basketball"
        case .yoga: return "Yoga"
        case .cycling: return "Cycling"
        case .surfing: return "Surfing"
        case .bowling: return "Bowling"
        case .golf: return "Golf"
        case .pilates: return "Pilates"
        case .boardGames: return "Board Games"
        }
    }
    
    var emoji: String {
        switch self {
        case .padel: return "🏓"
        case .football: return "⚽"
        case .tennis: return "🎾"
        case .volleyball: return "🏐"
        case .basketball: return "🏀"
        case .yoga: return "🧘‍♀️"
        case .cycling: return "🚴‍♂️"
        case .surfing: return "🏄‍♂️"
        case .bowling: return "🎳"
        case .golf: return "⛳"
        case .pilates: return "🧘‍♂️"
        case .boardGames: return "🎲"
        }
    }
    
    var color: Color {
        switch self {
        case .padel: return AppColors.padelColor
        case .football: return AppColors.footballColor
        case .tennis: return AppColors.tennisColor
        case .volleyball: return AppColors.volleyballColor
        case .basketball: return AppColors.basketballColor
        case .yoga: return AppColors.accentGreen
        case .cycling: return AppColors.accentBlue
        case .surfing: return AppColors.accentBlue
        case .bowling: return AppColors.accentOrange
        case .golf: return AppColors.accentGreen
        case .pilates: return AppColors.accentGreen
        case .boardGames: return AppColors.accentOrange
        }
    }
} 