//
//  MockDataService.swift
//  ANISmock
//
//  Created by Salman on 08/02/1447 AH.
//

import Foundation
import CoreLocation
import Combine

@MainActor
class MockDataService: ObservableObject {
    static let shared = MockDataService()
    
    @Published var activities: [Activity] = []
    @Published var users: [User] = []
    @Published var joinRequests: [JoinRequest] = []
    
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
                interests: [.volleyball, .cycling],
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
            )
        ]

        // Seed join requests (incoming for hosts and pending for current user user1)
        joinRequests = [
            JoinRequest(
                id: UUID().uuidString,
                requesterUserId: "user2",
                requesterName: "Ahmed Al-Mansouri",
                requesterAvatar: nil,
                sportType: .football,
                targetActivityId: activities[0].id,
                targetActivityTitle: activities[0].title,
                status: .incoming,
                createdAt: Date().addingTimeInterval(-3600)
            ),
            JoinRequest(
                id: UUID().uuidString,
                requesterUserId: "user1",
                requesterName: "Yazeed Al-Rashid",
                requesterAvatar: nil,
                sportType: .tennis,
                targetActivityId: activities[2].id,
                targetActivityTitle: activities[2].title,
                status: .pending,
                createdAt: Date().addingTimeInterval(-7200)
            )
        ]
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
    
    // MARK: - Requests
    func fetchJoinRequests(for userId: String) async -> (incoming: [JoinRequest], pending: [JoinRequest]) {
        try? await Task.sleep(nanoseconds: 200_000_000)
        // Incoming are those targeting activities where user is host and status is incoming
        let incoming = joinRequests.filter { req in
            if let activity = activities.first(where: { $0.id == req.targetActivityId }) {
                return activity.hostId == userId && req.status == .incoming
            }
            return false
        }
        let pending = joinRequests.filter { $0.requesterUserId == userId && $0.status == .pending }
        return (incoming, pending)
    }
    
    func sendJoinRequest(activityId: String, requesterUserId: String) async -> Bool {
        try? await Task.sleep(nanoseconds: 150_000_000)
        guard let activity = activities.first(where: { $0.id == activityId }),
              let requester = users.first(where: { $0.id == requesterUserId }) else { return false }
        // Prevent duplicates
        if joinRequests.contains(where: { $0.targetActivityId == activityId && $0.requesterUserId == requesterUserId && $0.status == .pending }) {
            return true
        }
        let newReq = JoinRequest(
            id: UUID().uuidString,
            requesterUserId: requester.id,
            requesterName: requester.name,
            requesterAvatar: nil,
            sportType: activity.sportType,
            targetActivityId: activity.id,
            targetActivityTitle: activity.title,
            status: .pending,
            createdAt: Date()
        )
        joinRequests.append(newReq)
        return true
    }
    
    func acceptJoinRequest(_ id: String, by hostId: String) async -> Bool {
        try? await Task.sleep(nanoseconds: 120_000_000)
        guard let idx = joinRequests.firstIndex(where: { $0.id == id }) else { return false }
        // Validate host owns the activity
        if let activity = activities.first(where: { $0.id == joinRequests[idx].targetActivityId }), activity.hostId == hostId {
            joinRequests[idx].status = .accepted
            return true
        }
        return false
    }
    
    func declineJoinRequest(_ id: String, by hostId: String) async -> Bool {
        try? await Task.sleep(nanoseconds: 120_000_000)
        guard let idx = joinRequests.firstIndex(where: { $0.id == id }) else { return false }
        if let activity = activities.first(where: { $0.id == joinRequests[idx].targetActivityId }), activity.hostId == hostId {
            joinRequests[idx].status = .declined
            return true
        }
        return false
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
                bio: users[userIndex].bio,
                instagram: users[userIndex].instagram,
                x: users[userIndex].x,
                snapchat: users[userIndex].snapchat,
                tiktok: users[userIndex].tiktok,
                website: users[userIndex].website
            )
            users[userIndex] = updatedUser
            return true
        }
        return false
    }

    func updateUserName(userId: String, name: String) async -> Bool {
        try? await Task.sleep(nanoseconds: 150_000_000)
        if let userIndex = users.firstIndex(where: { $0.id == userId }) {
            let updatedUser = User(
                id: users[userIndex].id,
                name: name,
                email: users[userIndex].email,
                age: users[userIndex].age,
                interests: users[userIndex].interests,
                profileImageURL: users[userIndex].profileImageURL,
                bio: users[userIndex].bio,
                instagram: users[userIndex].instagram,
                x: users[userIndex].x,
                snapchat: users[userIndex].snapchat,
                tiktok: users[userIndex].tiktok,
                website: users[userIndex].website
            )
            users[userIndex] = updatedUser
            return true
        }
        return false
    }
    
    func updateUserBio(userId: String, bio: String) async -> Bool {
        try? await Task.sleep(nanoseconds: 150_000_000)
        if let userIndex = users.firstIndex(where: { $0.id == userId }) {
            let updatedUser = User(
                id: users[userIndex].id,
                name: users[userIndex].name,
                email: users[userIndex].email,
                age: users[userIndex].age,
                interests: users[userIndex].interests,
                profileImageURL: users[userIndex].profileImageURL,
                bio: bio,
                instagram: users[userIndex].instagram,
                x: users[userIndex].x,
                snapchat: users[userIndex].snapchat,
                tiktok: users[userIndex].tiktok,
                website: users[userIndex].website
            )
            users[userIndex] = updatedUser
            return true
        }
        return false
    }
    
    func updateUserSocialLinks(userId: String, links: SocialLinks) async -> Bool {
        try? await Task.sleep(nanoseconds: 200_000_000)
        if let userIndex = users.firstIndex(where: { $0.id == userId }) {
            let updatedUser = User(
                id: users[userIndex].id,
                name: users[userIndex].name,
                email: users[userIndex].email,
                age: users[userIndex].age,
                interests: users[userIndex].interests,
                profileImageURL: users[userIndex].profileImageURL,
                bio: users[userIndex].bio,
                instagram: links.instagram,
                x: links.x,
                snapchat: links.snapchat,
                tiktok: links.tiktok,
                website: links.website
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

// MARK: - Notifications
extension Notification.Name {
    static let didSendJoinRequest = Notification.Name("didSendJoinRequest")
}