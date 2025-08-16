//
//  RequestsView.swift
//

import SwiftUI
import UIKit
import Combine

struct RequestsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = RequestsViewModel()
    @State private var topSegment: Int = 0 // 0 Requests, 1 Groups


    @State private var selectedUser: User?
    @State private var haptics = UIImpactFeedbackGenerator(style: .soft)
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.primaryBackground.ignoresSafeArea()
                VStack(spacing: 0) {
                    // Glass header
                    HStack {
                        Text("Activities")
                            .font(AppFonts.title2)
                            .foregroundColor(AppColors.primaryText)
                        Spacer()
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.vertical, AppSpacing.md)
                    .background(.ultraThinMaterial)
                    .overlay(Divider().background(AppColors.dividerColor), alignment: .bottom)
                    .animatedOnAppear()
                    
                    // Native Apple segmented control with liquid glass effect
                    Picker("View Mode", selection: $topSegment) {
                        Text("Requests").tag(0)
                        Text("Groups").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.md)
                    .animatedOnAppear(delay: 0.05)
                    
                    // Content
                    Group {
                        if topSegment == 0 {
                            // Requests
                            ScrollView(showsIndicators: false) {
                                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                                    // Incoming Section
                                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                                        Text("Incoming")
                                            .font(AppFonts.title3)
                                            .foregroundColor(AppColors.primaryText)
                                            .padding(.top, AppSpacing.lg)
                                            .padding(.horizontal, AppSpacing.lg)
                                            .animatedOnAppear()

                                        if viewModel.incoming.isEmpty {
                                            emptyState(text: "No incoming requests")
                                                .animatedOnAppear()
                                        } else {
                                            ScrollView(.horizontal, showsIndicators: false) {
                                                HStack(spacing: AppSpacing.md) {
                                                    ForEach(Array(viewModel.incoming.enumerated()), id: \.element.id) { index, req in
                                                        RequestCard(request: req, kind: .incoming) {
                                                            performAccept(req)
                                                        } onDecline: {
                                                            performDecline(req)
                                                        } onCancel: { } onViewProfile: {
                                                            performViewProfile(req)
                                                        }
                                                        .frame(width: 280)
                                                        .animatedOnAppear(delay: Double(index) * 0.04)
                                                    }
                                                }
                                                .padding(.horizontal, AppSpacing.lg)
                                            }
                                        }
                                    }

                                    // Pending Section
                                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                                        Text("Pending")
                                            .font(AppFonts.title3)
                                            .foregroundColor(AppColors.primaryText)
                                            .padding(.top, AppSpacing.lg)
                                            .padding(.horizontal, AppSpacing.lg)
                                            .animatedOnAppear()

                                        if viewModel.pending.isEmpty {
                                            emptyState(text: "No pending requests")
                                                .animatedOnAppear()
                                        } else {
                                            ScrollView(.horizontal, showsIndicators: false) {
                                                HStack(spacing: AppSpacing.md) {
                                                    ForEach(Array(viewModel.pending.enumerated()), id: \.element.id) { index, req in
                                                        RequestCard(request: req, kind: .pending) {
                                                            // none
                                                        } onDecline: { } onCancel: {
                                                            viewModel.cancel(request: req, by: authViewModel.currentUser?.id ?? "")
                                                        }
                                                        .frame(width: 280)
                                                        .animatedOnAppear(delay: Double(index) * 0.04)
                                                    }
                                                }
                                                .padding(.horizontal, AppSpacing.lg)
                                            }
                                        }
                                    }
                                }
                            }
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        } else {
                            // Groups
                            GroupsMockView()
                                .padding(.horizontal, AppSpacing.lg)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                    .animation(.snappy, value: viewModel.incoming.count)
                    .animation(.snappy, value: viewModel.pending.count)
                    .animation(.snappy, value: topSegment)
                    
                    Spacer(minLength: 0)
                }
            }
        .onAppear {
            if let id = authViewModel.currentUser?.id {
                viewModel.load(for: id)
            }
        }

        .sheet(item: $selectedUser) { user in
            OtherProfileView(user: user)
        }
        .onReceive(NotificationCenter.default.publisher(for: .didSendJoinRequest)) { _ in
            if let id = authViewModel.currentUser?.id {
                viewModel.load(for: id)
            }
        }
        }
    }
    
    @ViewBuilder
    private func emptyState(text: String) -> some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "tray")
                .font(.system(size: 40, weight: .semibold))
                .foregroundColor(AppColors.mutedText)
            Text(text)
                .font(AppFonts.body)
                .foregroundColor(AppColors.secondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func performAccept(_ req: JoinRequest) {
        haptics.impactOccurred()
        if let hostId = authViewModel.currentUser?.id {
            viewModel.accept(request: req, by: hostId)
        }
    }
    private func performDecline(_ req: JoinRequest) {
        haptics.impactOccurred()
        if let hostId = authViewModel.currentUser?.id {
            viewModel.decline(request: req, by: hostId)
        }
    }
    
    private func performViewProfile(_ req: JoinRequest) {
        haptics.impactOccurred()
        // For now, create a mock user based on the request data
        // In a real app, you'd fetch the user by requesterUserId
        let mockUser = User(
            id: req.requesterUserId,
            name: req.requesterName,
            email: "\(req.requesterName.lowercased())@example.com",
            age: Int.random(in: 20...35),
            interests: [req.sportType, SportType.allCases.randomElement() ?? .football],
            bio: "Sports enthusiast who loves \(req.sportType.displayName.lowercased()) and staying active!"
        )
        selectedUser = mockUser
    }
}


