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
    // Social links
    let instagram: String?
    let x: String?
    let snapchat: String?
    let tiktok: String?
    let website: String?
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
        case instagram
        case x
        case snapchat
        case tiktok
        case website
        case createdAt
        case lastActive
    }
    
    init(
        id: String,
        name: String,
        email: String,
        age: Int? = nil,
        interests: [SportType] = [],
        profileImageURL: String? = nil,
        bio: String? = nil,
        instagram: String? = nil,
        x: String? = nil,
        snapchat: String? = nil,
        tiktok: String? = nil,
        website: String? = nil
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.age = age
        self.interests = interests
        self.profileImageURL = profileImageURL
        self.bio = bio
        self.instagram = instagram
        self.x = x
        self.snapchat = snapchat
        self.tiktok = tiktok
        self.website = website
        self.createdAt = Date()
        self.lastActive = Date()
    }
}

enum SportType: String, CaseIterable, Codable {
    case gym = "gym"
    case yoga = "yoga"
    case padel = "padel"
    case football = "football"
    case tennis = "tennis"
    case cycling = "cycling"
    case running = "running"
    case golf = "golf"
    case volleyball = "volleyball"
    case pilates = "pilates"
    case basketball = "basketball"
    
    var displayName: String {
        switch self {
        case .gym: return "Gym"
        case .yoga: return "Yoga"
        case .padel: return "Padel"
        case .football: return "Football"
        case .tennis: return "Tennis"
        case .cycling: return "Cycling"
        case .running: return "Running"
        case .golf: return "Golf"
        case .volleyball: return "Volleyball"
        case .pilates: return "Pilates"
        case .basketball: return "Basketball"
        }
    }
    
    var emoji: String {
        switch self {
        case .gym: return "🏋️‍♂️"
        case .yoga: return "🧘"
        case .padel: return "🏓"
        case .football: return "⚽"
        case .tennis: return "🎾"
        case .cycling: return "🚴"
        case .running: return "🏃"
        case .golf: return "⛳"
        case .volleyball: return "🏐"
        case .pilates: return "🤸"
        case .basketball: return "🏀"
        }
    }
    
    var color: Color {
        switch self {
        case .gym: return AppColors.accentOrange
        case .yoga: return AppColors.accentGreen
        case .padel: return AppColors.padelColor
        case .football: return AppColors.footballColor
        case .tennis: return AppColors.tennisColor
        case .cycling: return AppColors.accentBlue
        case .running: return AppColors.accentBlue
        case .golf: return AppColors.accentGreen
        case .volleyball: return AppColors.volleyballColor
        case .pilates: return AppColors.accentGreen
        case .basketball: return AppColors.basketballColor
        }
    }
} 