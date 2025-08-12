//
//  CompactSocialLinkCard.swift
//

import SwiftUI

struct CompactSocialLinkCard: View {
    let platform: ProfileSocialPlatform
    let handle: String
    var onEdit: () -> Void = {}
    
    private var iconName: String {
        switch platform {
        case .instagram: return "camera.aperture"
        case .x: return "xmark"
        case .snapchat: return "bolt.circle"
        case .tiktok: return "music.note"
        case .website: return "globe"
        }
    }
    
    private var background: some View {
        Group {
            switch platform {
            case .instagram:
                LinearGradient(colors: [Color.purple, Color.pink, Color.orange], startPoint: .topLeading, endPoint: .bottomTrailing)
            case .x:
                LinearGradient(colors: [Color.black.opacity(0.95), Color.gray.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing)
            case .website:
                Color(red: 0.11, green: 0.75, blue: 0.29)
            case .snapchat:
                Color.yellow
            case .tiktok:
                LinearGradient(colors: [Color.black, Color(red: 0.0, green: 0.72, blue: 0.8)], startPoint: .leading, endPoint: .trailing)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Image(systemName: iconName)
                    .foregroundColor(.white)
                    .font(.subheadline)
                Text(handle.isEmpty ? "Add" : handle)
                    .font(AppFonts.subheadline)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Spacer()
                Image(systemName: "pencil")
                    .foregroundColor(.white.opacity(0.9))
                    .font(.footnote)
                    .onTapGesture { onEdit() }
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 12)
        .frame(height: 56)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: AppColors.shadowColor.opacity(0.2), radius: 6, x: 0, y: 4)
    }
}


