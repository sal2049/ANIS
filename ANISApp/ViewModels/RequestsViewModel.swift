//
//  RequestsViewModel.swift
//

import Foundation
import Combine

@MainActor
class RequestsViewModel: ObservableObject {
    @Published var incoming: [JoinRequest] = []
    @Published var pending: [JoinRequest] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let dataService = MockDataService.shared
    private var cancellable: AnyCancellable?
    private var currentUserId: String?
    
    func load(for userId: String) {
        currentUserId = userId
        isLoading = true
        errorMessage = nil
        Task {
            let res = await dataService.fetchJoinRequests(for: userId)
            await MainActor.run {
                self.incoming = res.incoming
                self.pending = res.pending
                self.isLoading = false
                // Demo seed: if no requests available, inject mock ones so UI is visible
                if self.incoming.isEmpty && self.pending.isEmpty {
                    let demoIncoming = JoinRequest(
                        requesterUserId: "user2",
                        requesterName: "Alex Chen",
                        requesterAvatar: nil,
                        sportType: .football,
                        targetActivityId: "act_demo_1",
                        targetActivityTitle: "Today 6:00 PM",
                        status: .incoming
                    )
                    let demoPending = JoinRequest(
                        requesterUserId: "user3",
                        requesterName: "Tom Gray",
                        requesterAvatar: nil,
                        sportType: .basketball,
                        targetActivityId: "act_demo_2",
                        targetActivityTitle: "Brooklyn Court",
                        status: .pending
                    )
                    self.incoming = [demoIncoming]
                    self.pending = [demoPending]
                }
            }
        }
        // Subscribe once to live updates from the mock data store
        if cancellable == nil {
            cancellable = dataService.$joinRequests.sink { [weak self] _ in
                guard let self = self, let uid = self.currentUserId else { return }
                Task {
                    let res = await self.dataService.fetchJoinRequests(for: uid)
                    await MainActor.run {
                        self.incoming = res.incoming
                        self.pending = res.pending
                    }
                }
            }
        }
    }
    
    func accept(request: JoinRequest, by hostId: String) {
        Task {
            let ok = await dataService.acceptJoinRequest(request.id, by: hostId)
            if ok { self.load(for: hostId) }
        }
    }
    
    func decline(request: JoinRequest, by hostId: String) {
        Task {
            let ok = await dataService.declineJoinRequest(request.id, by: hostId)
            if ok { self.load(for: hostId) }
        }
    }
    
    func cancel(request: JoinRequest, by userId: String) {
        // For mock: mark as declined locally (remove from pending)
        if let idx = pending.firstIndex(where: { $0.id == request.id }) {
            pending.remove(at: idx)
        }
    }
}


