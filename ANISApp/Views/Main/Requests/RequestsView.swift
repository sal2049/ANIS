//
//  RequestsView.swift
//

import SwiftUI
import UIKit

struct RequestsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = RequestsViewModel()
    @State private var topSegment: Int = 0 // 0 Requests, 1 Groups
    @State private var showProfileShare: Bool = false
    @State private var haptics = UIImpactFeedbackGenerator(style: .soft)
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.primaryBackground.ignoresSafeArea()
                VStack(spacing: 0) {
                    // Glass header
                    HStack {
                        Text("Requests")
                            .font(AppFonts.title2)
                            .foregroundColor(AppColors.primaryText)
                        Spacer()
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.vertical, AppSpacing.md)
                    .background(.ultraThinMaterial)
                    .overlay(Divider().background(AppColors.dividerColor), alignment: .bottom)
                    
                    // Top-level segmented control: Requests / Groups
                    Picker("TopSegment", selection: $topSegment) {
                        Text("Requests").tag(0)
                        Text("Groups").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.md)
                    
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
                                            .animatedOnAppear()

                                        if viewModel.incoming.isEmpty {
                                            emptyState(text: "No incoming requests")
                                                .animatedOnAppear()
                                        } else {
                                            VStack(spacing: AppSpacing.md) {
                                                ForEach(Array(viewModel.incoming.enumerated()), id: \.element.id) { index, req in
                                                    RequestCard(request: req, kind: .incoming) {
                                                        performAccept(req)
                                                    } onDecline: {
                                                        performDecline(req)
                                                    } onCancel: { }
                                                    .animatedOnAppear(delay: Double(index) * 0.04)
                                                }
                                            }
                                        }
                                    }

                                    // Pending Section
                                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                                        Text("Pending")
                                            .font(AppFonts.title3)
                                            .foregroundColor(AppColors.primaryText)
                                            .padding(.top, AppSpacing.lg)
                                            .animatedOnAppear()

                                        if viewModel.pending.isEmpty {
                                            emptyState(text: "No pending requests")
                                                .animatedOnAppear()
                                        } else {
                                            VStack(spacing: AppSpacing.md) {
                                                ForEach(Array(viewModel.pending.enumerated()), id: \.element.id) { index, req in
                                                    RequestCard(request: req, kind: .pending) {
                                                        // none
                                                    } onDecline: { } onCancel: {
                                                        viewModel.cancel(request: req, by: authViewModel.currentUser?.id ?? "")
                                                    }
                                                    .animatedOnAppear(delay: Double(index) * 0.04)
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, AppSpacing.lg)
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
                } else {
                    // Fallback to seeded mock current user for request syncing
                    viewModel.load(for: "user1")
                }
            }
        }
        .sheet(isPresented: $showProfileShare) {
            ProfileShareSheet().environmentObject(authViewModel)
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                showProfileShare = true
            }
        }
    }
    private func performDecline(_ req: JoinRequest) {
        haptics.impactOccurred()
        if let hostId = authViewModel.currentUser?.id {
            viewModel.decline(request: req, by: hostId)
        }
    }
}


