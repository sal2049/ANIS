//
//  MapViewModel.swift
//  ANISmock
//
//  Created by Salman on 08/02/1447 AH.
//

import Foundation
import CoreLocation

@MainActor
class MapViewModel: ObservableObject {
    @Published var activities: [Activity] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let mockDataService = MockDataService.shared
    
    func fetchActivities() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedActivities = await mockDataService.fetchActivities()
                await MainActor.run {
                    self.activities = fetchedActivities
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to fetch activities"
                    self.isLoading = false
                }
            }
        }
    }
    
    // Firebase method commented out for mock data phase
    // func fetchActivitiesFromFirestore() {
    //     db.collection("activities")
    //         .whereField("status", isEqualTo: ActivityStatus.open.rawValue)
    //         .order(by: "dateTime", descending: false)
    //         .addSnapshotListener { [weak self] snapshot, error in
    //             DispatchQueue.main.async {
    //                 if let error = error {
    //                     self?.errorMessage = error.localizedDescription
    //                     return
    //                 }
    //                 
    //                 guard let documents = snapshot?.documents else {
    //                     self?.activities = []
    //                     return
    //                 }
    //                 
    //                 self?.activities = documents.compactMap { document in
    //                     try? document.data(as: Activity.self)
    //                 }
    //             }
    //         }
    // }
    
    func createActivity(_ activity: Activity) {
        Task {
            let success = await mockDataService.createActivity(activity)
            await MainActor.run {
                if success {
                    self.activities.append(activity)
                } else {
                    self.errorMessage = "Failed to create activity"
                }
            }
        }
    }
    
    func joinActivity(_ activityId: String, userId: String) {
        Task {
            let success = await mockDataService.joinActivity(activityId, userId: userId)
            await MainActor.run {
                if !success {
                    self.errorMessage = "Failed to join activity"
                } else {
                    // Refresh activities to show updated participant count
                    self.fetchActivities()
                }
            }
        }
    }
} 