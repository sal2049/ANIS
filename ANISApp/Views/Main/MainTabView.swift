//
//  MainTabView.swift
//  ANISmock
//
//  Created by Salman on 08/02/1447 AH.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedTab: Int = 0
    @State private var showCreateActivity: Bool = false
    @StateObject private var mapViewModel: MapViewModel = MapViewModel()
    @StateObject private var locationPermission: LocationPermissionManager = LocationPermissionManager()
    
    var body: some View {
        ZStack {
            // Main tab content
            TabView(selection: $selectedTab) {
                MapView()
                    .environmentObject(mapViewModel)
                    .environmentObject(locationPermission)
                    .tabItem {
                        Image(systemName: "map.fill")
                        Text("Map")
                    }
                    .tag(0)
                
                RequestsView()
                    .tabItem {
                        Image(systemName: "sportscourt")
                        Text("Activities")
                    }
                    .tag(1)
                
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.crop.circle.fill")
                        Text("Profile")
                    }
                    .tag(2)
            }
            .tint(Color(red: 0.541, green: 0.757, blue: 0.522))
            // Liquid Glass tab bar styling with iOS version guards
            .modifier(TabBarAppearanceModifier())
            
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
            CreateActivityView(onCreated: { activity in
                selectedTab = 0
                mapViewModel.focusedActivityId = activity.id
            })
            .environmentObject(mapViewModel)
            .environmentObject(locationPermission)
        }
    }
}

private struct TabBarAppearanceModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 18.0, *) {
            content
                .toolbarBackground(.ultraThinMaterial, for: .tabBar)
                .toolbarBackgroundVisibility(.visible, for: .tabBar)
                .toolbarColorScheme(.dark, for: .tabBar)
        } else if #available(iOS 16.0, *) {
            content
                .toolbarBackground(.ultraThinMaterial, for: .tabBar)
                .toolbarColorScheme(.dark, for: .tabBar)
        } else {
            content
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthViewModel())
} 