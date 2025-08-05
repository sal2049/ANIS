//
//  Activity.swift
//  ANISmock
//
//  Created by Salman on 08/02/1447 AH.
//

import Foundation
import CoreLocation
import SwiftUI
import MapKit

struct Activity: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let title: String
    let description: String?
    let sportType: SportType
    let hostId: String
    let hostName: String
    let location: Location
    let dateTime: Date
    let maxParticipants: Int
    let currentParticipants: Int
    let skillLevel: SkillLevel
    let status: ActivityStatus
    let chatId: String?
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case sportType
        case hostId
        case hostName
        case location
        case dateTime
        case maxParticipants
        case currentParticipants
        case skillLevel
        case status
        case chatId
        case createdAt
        case updatedAt
    }
    
    init(id: String = UUID().uuidString, title: String, description: String?, sportType: SportType, hostId: String, hostName: String, location: Location, dateTime: Date, maxParticipants: Int, skillLevel: SkillLevel) {
        self.id = id
        self.title = title
        self.description = description
        self.sportType = sportType
        self.hostId = hostId
        self.hostName = hostName
        self.location = location
        self.dateTime = dateTime
        self.maxParticipants = maxParticipants
        self.currentParticipants = 1 // Host is automatically included
        self.skillLevel = skillLevel
        self.status = .open
        self.chatId = nil
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    var isFull: Bool {
        return currentParticipants >= maxParticipants
    }
    
    var availableSlots: Int {
        return maxParticipants - currentParticipants
    }
    
    var timeUntilActivity: TimeInterval {
        return dateTime.timeIntervalSinceNow
    }
    
    var isUpcoming: Bool {
        return timeUntilActivity > 0
    }
    
    // MARK: - Equatable
    static func == (lhs: Activity, rhs: Activity) -> Bool {
        return lhs.id == rhs.id
    }
    
    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}



struct Location: Codable {
    let latitude: Double
    let longitude: Double
    let address: String?
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double, address: String? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
    }
}

enum SkillLevel: String, CaseIterable, Codable {
    case beginner = "beginner"
    case intermediate = "intermediate"
    case advanced = "advanced"
    
    var displayName: String {
        switch self {
        case .beginner: return "Beginner"
        case .intermediate: return "Intermediate"
        case .advanced: return "Advanced"
        }
    }
    
    var color: Color {
        switch self {
        case .beginner: return AppColors.accentGreen
        case .intermediate: return AppColors.accentBlue
        case .advanced: return AppColors.accentRed
        }
    }
}

enum ActivityStatus: String, CaseIterable, Codable {
    case open = "open"
    case full = "full"
    case cancelled = "cancelled"
    case completed = "completed"
    
    var displayName: String {
        switch self {
        case .open: return "Open"
        case .full: return "Full"
        case .cancelled: return "Cancelled"
        case .completed: return "Completed"
        }
    }
} 