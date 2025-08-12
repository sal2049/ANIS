//
//  AuthViewModel.swift
//  ANISmock
//
//  Created by Salman on 08/02/1447 AH.
//

import Foundation
// Firebase imports commented out for mock data phase
// import Firebase
// import FirebaseAuth
// import FirebaseFirestore

@MainActor
class AuthViewModel: ObservableObject {
    private let signedInFlagKey = "isSignedIn"
    @Published var isAuthenticated: Bool = UserDefaults.standard.bool(forKey: "isSignedIn")
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Firebase auth commented out for mock data phase
    // private let auth = Auth.auth()
    // private let db = Firestore.firestore()
    private let mockDataService = MockDataService.shared
    
    init() {
        // Restore authentication state from persistence
        isAuthenticated = UserDefaults.standard.bool(forKey: signedInFlagKey)
        if isAuthenticated {
            // Only hydrate a user if already signed in
            Task {
                let mockUser = await mockDataService.fetchUser(id: "user1")
                await MainActor.run {
                    self.currentUser = mockUser
                }
            }
        }
    }
    
    func signInWithApple() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Simulate network delay
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
            
            // Create a new user for mock data
            let user = User(
                id: "user_\(UUID().uuidString)",
                name: "Current User",
                email: "user@example.com",
                age: 25,
                interests: [.padel, .football]
            )
            
            // For mock data, we don't need to save new users - they already exist in mock data
            
            self.currentUser = user
            self.isAuthenticated = true
            UserDefaults.standard.set(true, forKey: signedInFlagKey)

            // If onboarding interests were selected prior to sign-in, apply them now
            if let stored = UserDefaults.standard.array(forKey: "onboarding_selected_interests") as? [String] {
                let restored = stored.compactMap { SportType(rawValue: $0) }
                if !restored.isEmpty {
                    self.updateUserInterests(restored)
                    UserDefaults.standard.removeObject(forKey: "onboarding_selected_interests")
                }
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func signOut() {
        // Simulate sign out for mock data
        isAuthenticated = false
        UserDefaults.standard.set(false, forKey: signedInFlagKey)
        currentUser = nil
        // Firebase sign out commented out for mock data phase
        // do {
        //     try auth.signOut()
        // } catch {
        //     errorMessage = error.localizedDescription
        // }
    }
    
    // Firebase methods commented out for mock data phase
    // private func fetchUserData(userId: String) {
    //     db.collection("users").document(userId).getDocument { [weak self] document, error in
    //         DispatchQueue.main.async {
    //             if let document = document, document.exists {
    //                 do {
    //                     let user = try document.data(as: User.self)
    //                     self?.currentUser = user
    //                 } catch {
    //                     self?.errorMessage = "Failed to decode user data"
    //                 }
    //             } else {
    //                 // User doesn't exist in Firestore, create new user
    //                 self?.createNewUser(userId: userId)
    //             }
    //         }
    //     }
    // }
    //
    // private func createNewUser(userId: String) {
    //     let user = User(
    //         id: userId,
    //         name: "New User",
    //         email: auth.currentUser?.email ?? "",
    //         age: nil,
    //         interests: []
    //     )
    //     
    //     Task {
    //         await saveUserToFirestore(user)
    //     }
    // }
    //
    // private func saveUserToFirestore(_ user: User) async {
    //     do {
    //         try db.collection("users").document(user.id).setData(from: user)
    //     } catch {
    //         errorMessage = "Failed to save user data"
    //     }
    // }
    
    func updateUserInterests(_ interests: [SportType]) {
        guard let user = currentUser else { return }
        
        let updatedUser = User(
            id: user.id,
            name: user.name,
            email: user.email,
            age: user.age,
            interests: interests,
            profileImageURL: user.profileImageURL,
            bio: user.bio,
            instagram: user.instagram,
            x: user.x,
            snapchat: user.snapchat,
            tiktok: user.tiktok,
            website: user.website
        )
        
        Task {
            let success = await MockDataService.shared.updateUserInterests(interests, for: user.id)
            await MainActor.run {
                if success {
                    self.currentUser = updatedUser
                }
            }
        }
    }

    func updateBio(_ bio: String) {
        guard let user = currentUser else { return }
        let updatedUser = User(
            id: user.id,
            name: user.name,
            email: user.email,
            age: user.age,
            interests: user.interests,
            profileImageURL: user.profileImageURL,
            bio: bio,
            instagram: user.instagram,
            x: user.x,
            snapchat: user.snapchat,
            tiktok: user.tiktok,
            website: user.website
        )
        Task {
            // Reuse interests update as persistence is mock; replace entire user via social links method if needed
            _ = await MockDataService.shared.updateUserInterests(user.interests, for: user.id)
            await MainActor.run { self.currentUser = updatedUser }
        }
    }
    
    func updateSocialLinks(_ links: SocialLinks) {
        guard let user = currentUser else { return }
        Task {
            let ok = await MockDataService.shared.updateUserSocialLinks(userId: user.id, links: links)
            if ok {
                let updated = User(
                    id: user.id,
                    name: user.name,
                    email: user.email,
                    age: user.age,
                    interests: user.interests,
                    profileImageURL: user.profileImageURL,
                    bio: user.bio,
                    instagram: links.instagram,
                    x: links.x,
                    snapchat: links.snapchat,
                    tiktok: links.tiktok,
                    website: links.website
                )
                await MainActor.run { self.currentUser = updated }
            }
        }
    }
} 