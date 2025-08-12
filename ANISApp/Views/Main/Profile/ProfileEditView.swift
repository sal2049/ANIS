//
//  ProfileEditView.swift
//

import SwiftUI

struct ProfileEditView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var segment = 0
    @State private var bio: String = ""
    @State private var selected: Set<SportType> = []
    @State private var instagram: String = ""
    @State private var x: String = ""
    @State private var snapchat: String = ""
    @State private var tiktok: String = ""
    @State private var website: String = "" // Using for WhatsApp/website field
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                        Text("Cancel")
                    }
                    .foregroundColor(AppColors.secondaryText)
                    Spacer()
                    Text("Edit Profile").font(AppFonts.title2).foregroundColor(AppColors.primaryText)
                    Spacer()
                    Button("Save") { save() }
                        .foregroundColor(AppColors.accentGreen)
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.vertical, AppSpacing.md)
                .background(AppColors.primaryBackground.opacity(0.9))
                
                Picker("Section", selection: $segment) {
                    Text("About Me").tag(0)
                    Text("Interests").tag(1)
                    Text("Connects").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, AppSpacing.lg)
                
                TabView(selection: $segment) {
                    aboutTab.tag(0)
                    interestsTab.tag(1)
                    accountTab.tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .onAppear { hydrate() }
            .background(AppColors.primaryBackground.ignoresSafeArea())
        }
    }
    
    private var aboutTab: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Tell people about you").font(AppFonts.headline).foregroundColor(AppColors.primaryText)
            TextEditor(text: $bio)
                .frame(height: 160)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: AppCornerRadius.medium).fill(AppColors.secondaryBackground))
                .foregroundColor(AppColors.primaryText)
            HStack { Spacer(); Text("\(bio.count) chars").font(AppFonts.footnote).foregroundColor(AppColors.secondaryText) }
            Spacer()
        }
        .padding()
    }
    
    private var interestsTab: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: AppSpacing.md) {
                ForEach(SportType.allCases, id: \.self) { sport in
                    Button(action: {
                        if selected.contains(sport) { selected.remove(sport) } else { selected.insert(sport) }
                    }) {
                        HStack { Text(sport.emoji); Text(sport.displayName).font(AppFonts.body) }
                            .frame(maxWidth: .infinity).padding().background(RoundedRectangle(cornerRadius: AppCornerRadius.medium).fill(selected.contains(sport) ? sport.color.opacity(0.3) : AppColors.secondaryBackground))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }
    
    private var accountTab: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Connect your profiles").font(AppFonts.headline).foregroundColor(AppColors.primaryText)
            VStack(spacing: AppSpacing.md) {
                socialTextField(title: "Instagram", placeholder: "@ahmed_riyadh", text: $instagram, systemIcon: "camera.aperture")
                socialTextField(title: "X", placeholder: "@ahmed_riyadh", text: $x, systemIcon: "xmark")
                socialTextField(title: "WhatsApp", placeholder: "+966 50 123 4567", text: $website, systemIcon: "message")
            }
            Spacer()
        }
        .padding()
    }

    private func socialTextField(title: String, placeholder: String, text: Binding<String>, systemIcon: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Image(systemName: systemIcon).foregroundColor(AppColors.primaryText)
                Text(title).foregroundColor(AppColors.primaryText).font(AppFonts.callout)
            }
            TextField(placeholder, text: text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(12)
                .background(RoundedRectangle(cornerRadius: AppCornerRadius.medium).fill(AppColors.secondaryBackground))
                .foregroundColor(AppColors.primaryText)
        }
    }
    
    private func hydrate() {
        bio = authViewModel.currentUser?.bio ?? ""
        selected = Set(authViewModel.currentUser?.interests ?? [])
        instagram = authViewModel.currentUser?.instagram ?? ""
        x = authViewModel.currentUser?.x ?? ""
        snapchat = authViewModel.currentUser?.snapchat ?? ""
        tiktok = authViewModel.currentUser?.tiktok ?? ""
        website = authViewModel.currentUser?.website ?? ""
    }
    
    private func save() {
        switch segment {
        case 0:
            authViewModel.updateBio(bio)
        case 1:
            authViewModel.updateUserInterests(Array(selected))
        default:
            let links = SocialLinks(instagram: instagram, x: x, snapchat: snapchat, tiktok: tiktok, website: website)
            authViewModel.updateSocialLinks(links)
        }
        dismiss()
    }
}


