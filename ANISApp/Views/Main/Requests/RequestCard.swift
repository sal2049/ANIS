//
//  RequestCard.swift
//

import SwiftUI

enum RequestKind { case incoming, pending }

struct RequestCard: View {
    let request: JoinRequest
    let kind: RequestKind
    var onAccept: (() -> Void)?
    var onDecline: (() -> Void)?
    var onCancel: (() -> Void)?
    var onViewProfile: (() -> Void)?
    @State private var pressed: Bool = false
    @State private var showProfile = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack(spacing: AppSpacing.md) {
                // Tappable user info section
                Button(action: {
                    if kind == .incoming {
                        onViewProfile?()
                    }
                }) {
                    HStack(spacing: AppSpacing.md) {
                        ZStack {
                            Circle().fill(AppColors.secondaryBackground)
                                .frame(width: 48, height: 48)
                                .overlay(Circle().stroke(AppColors.dividerColor, lineWidth: 1))
                            Text(String(request.requesterName.prefix(1)))
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            HStack(spacing: 4) {
                                Text(request.requesterName)
                                    .font(AppFonts.headline)
                                    .foregroundColor(AppColors.primaryText)
                                if kind == .incoming {
                                    Image(systemName: "person.crop.circle")
                                        .font(.system(size: 14))
                                        .foregroundColor(AppColors.secondaryText)
                                }
                            }
                            Text("wants to join")
                                .font(AppFonts.subheadline)
                                .foregroundColor(AppColors.secondaryText)
                        }
                    }
                }
                .buttonStyle(.plain)
                .disabled(kind != .incoming)
                
                Spacer()
                
                // Sport emoji indicator
                ZStack {
                    Circle().fill(AppColors.secondaryBackground.opacity(0.5))
                        .frame(width: 32, height: 32)
                    Text(request.sportType.emoji).font(.system(size: 16))
                }
            }
            
            HStack(spacing: AppSpacing.lg) {
                HStack(spacing: 6) {
                    Text(request.sportType.emoji)
                    Text("Today 6:00 PM")
                }
                .font(AppFonts.footnote)
                .foregroundColor(AppColors.secondaryText)
                
                HStack(spacing: 6) {
                    Image(systemName: "mappin.and.ellipse")
                    Text("Central Park")
                }
                .font(AppFonts.footnote)
                .foregroundColor(AppColors.secondaryText)
            }
            
            HStack(spacing: AppSpacing.md) {
                if kind == .incoming {
                    Button(action: { onDecline?() }) {
                        HStack {
                            Image(systemName: "xmark")
                            Text("Decline")
                        }
                        .foregroundColor(AppColors.primaryText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(RoundedRectangle(cornerRadius: 18).fill(AppColors.secondaryBackground))
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: { onAccept?() }) {
                        HStack {
                            Image(systemName: "checkmark")
                            Text("Accept")
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(RoundedRectangle(cornerRadius: 18).fill(Color.white))
                    }
                    .buttonStyle(.plain)
                } else {
                    HStack {
                        Text("Pending")
                            .foregroundColor(AppColors.primaryText)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(AppColors.secondaryBackground))
                        Spacer()
                        if let onCancel = onCancel {
                            Button(action: onCancel) {
                                Text("Cancel")
                                    .foregroundColor(AppColors.accentRed)
                            }
                        }
                    }
                }
            }
        }
        .padding(AppSpacing.md)
        .background(RoundedRectangle(cornerRadius: AppCornerRadius.large).fill(AppColors.cardBackground))
        .overlay(RoundedRectangle(cornerRadius: AppCornerRadius.large).stroke(AppColors.dividerColor, lineWidth: 1))
        .shadow(color: AppColors.shadowColor.opacity(0.15), radius: 10, x: 0, y: 6)
        .scaleEffect(pressed ? 0.98 : 1)
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: pressed)
        .onLongPressGesture(minimumDuration: 0.01, pressing: { isPressing in pressed = isPressing }, perform: {})
        .accessibilityElement(children: .combine)
        .accessibilityLabel(kind == .incoming ? "Incoming request from \(request.requesterName)" : "Pending request for \(request.targetActivityTitle)")
    }
}


