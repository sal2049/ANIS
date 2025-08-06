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
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Firebase auth commented out for mock data phase
    // private let auth = Auth.auth()
    // private let db = Firestore.firestore()
    private let mockDataService = MockDataService.shared
    
    init() {
        setupAuthStateListener()
    }
    
    private func setupAuthStateListener() {
        // Firebase auth listener commented out for mock data phase
        // auth.addStateDidChangeListener { [weak self] _, user in
        //     DispatchQueue.main.async {
        //         self?.isAuthenticated = user != nil
        //         if let user = user {
        //             self?.fetchUserData(userId: user.uid)
        //         } else {
        //             self?.currentUser = nil
        //         }
        //     }
        // }
        
        // For mock data, simulate initial state
        Task {
            let mockUser = await mockDataService.fetchUser(id: "user1")
            await MainActor.run {
                self.currentUser = mockUser
                self.isAuthenticated = self.currentUser != nil
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
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func signOut() {
        // Simulate sign out for mock data
        isAuthenticated = false
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
            bio: user.bio
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
} 