//
//  SocialLinkButton.swift
//

import SwiftUI

enum ProfileSocialPlatform { case instagram, x, snapchat, tiktok, website }

struct ProfileSocialLinkButton: View {
    let platform: ProfileSocialPlatform
    let handle: String
    let showsEdit: Bool
    let onTap: () -> Void
    let onEdit: () -> Void

    private var iconName: String {
        switch platform {
        case .instagram: return "camera.aperture"
        case .x: return "xmark"
        case .snapchat: return "bolt.circle"
        case .tiktok: return "music.note"
        case .website: return "globe"
        }
    }

    private var platformTitle: String {
        switch platform {
        case .instagram: return "Instagram"
        case .x: return "X"
        case .snapchat: return "Snapchat"
        case .tiktok: return "TikTok"
        case .website: return "WhatsApp"
        }
    }

    private var backgroundView: some View {
        Group {
            switch platform {
            case .instagram:
                LinearGradient(colors: [Color.purple, Color.pink, Color.orange], startPoint: .leading, endPoint: .trailing)
            case .x:
                LinearGradient(colors: [Color.black.opacity(0.95), Color.gray.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing)
            case .website:
                Color(red: 0.11, green: 0.75, blue: 0.29) // WhatsApp-like green
            case .snapchat:
                Color.yellow
            case .tiktok:
                LinearGradient(colors: [Color.black, Color(red: 0.0, green: 0.72, blue: 0.8)], startPoint: .leading, endPoint: .trailing)
            }
        }
    }

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 10) {
                    Image(systemName: iconName)
                        .foregroundColor(.white)
                        .font(.headline)
                    Text(platformTitle)
                        .font(AppFonts.headline)
                        .foregroundColor(.white)
                    Spacer(minLength: 8)
                    if showsEdit {
                        ZStack {
                            Circle().fill(Color.white.opacity(0.22)).frame(width: 28, height: 28)
                            Image(systemName: "pencil").foregroundColor(.white).font(.footnote)
                        }
                        .onTapGesture { onEdit() }
                        .accessibilityLabel("Edit \(platformTitle)")
                    }
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.18))
                    Text(handle.isEmpty ? "Add \(platformTitle)" : handle)
                        .foregroundColor(.white)
                        .font(AppFonts.callout)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .padding(.horizontal, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(height: 36)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(backgroundView)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .shadow(color: AppColors.shadowColor, radius: 10, x: 0, y: 6)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
    }
}


