//
//  MainTabView.swift
//  ANISmock
//
//  Created by Salman on 08/02/1447 AH.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var showCreateActivity = false
    
    var body: some View {
        ZStack {
            // Main tab content
            TabView(selection: $selectedTab) {
                MapView()
                    .tabItem {
                        Image(systemName: "map.fill")
                        Text("Map")
                    }
                    .tag(0)
                
                ChatListView()
                    .tabItem {
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                        Text("Chat")
                    }
                    .tag(1)
                
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.circle.fill")
                        Text("Profile")
                    }
                    .tag(2)
            }
            .accentColor(Color(red: 0.541, green: 0.757, blue: 0.522)) // #8AC185 - User's preferred accent color
            
            // Modern floating action button following HIG
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button {
                        showCreateActivity = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 56, weight: .medium))
                            .foregroundColor(Color(red: 0.541, green: 0.757, blue: 0.522)) // #8AC185
                            .background(
                                Circle()
                                    .fill(.white)
                                    .frame(width: 60, height: 60)
                                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                            )
                            .scaleEffect(1.0)
                    }
                    .buttonStyle(.plain)
                    .offset(y: -25)
                    .accessibilityLabel("Create new activity")
                    .accessibilityHint("Opens activity creation form")
                    
                    Spacer()
                }
                .padding(.bottom, 34) // Account for tab bar height
            }
        }
        .sheet(isPresented: $showCreateActivity) {
            CreateActivityView()
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthViewModel())
} 