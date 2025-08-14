//
//  CompactSocialLinkCard.swift
//

import SwiftUI

struct CompactSocialLinkCard: View {
    let platform: ProfileSocialPlatform
    let handle: String
    var onEdit: () -> Void = {}
    
    private var brandAssetName: String? {
        switch platform {
        case .instagram: return "icon_instagram"
        case .x: return "icon_x"
        case .website: return "icon_whatsapp"
        default: return nil
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
        HStack(spacing: 10) {
            Group {
                if let asset = brandAssetName, UIImage(named: asset) != nil {
                    Image(asset)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                } else {
                    Image(systemName: platform == .website ? "globe" : (platform == .x ? "xmark" : "camera"))
                }
            }
            .frame(width: 20, height: 20)
            .foregroundColor(.white)

            Text(handle.isEmpty ? "Add" : handle)
                .font(AppFonts.subheadline)
                .foregroundColor(.white)
                .lineLimit(1)
                .truncationMode(.tail)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(height: 60)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: AppColors.shadowColor.opacity(0.2), radius: 6, x: 0, y: 4)
        .overlay(alignment: .topTrailing) {
            Image(systemName: "pencil")
                .foregroundColor(.white.opacity(0.9))
                .font(.footnote)
                .padding(8)
                .contentShape(Rectangle())
                .onTapGesture { onEdit() }
        }
    }
}


