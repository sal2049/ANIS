//
//  MapView.swift
//  ANISmock
//
//  Created by Salman on 08/02/1447 AH.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @State private var cameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 24.7136, longitude: 46.6753), // Riyadh
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    @State private var selectedActivity: Activity?
    @State private var showActivityDetail = false
    
    var body: some View {
        ZStack {
            // Modern iOS 17+ Map with MapContentBuilder
            Map(position: $cameraPosition) {
                ForEach(viewModel.activities) { activity in
                    Annotation(
                        activity.title,
                        coordinate: activity.location.coordinate,
                        anchor: .center
                    ) {
                        ActivityPinView(activity: activity) {
                            print("DEBUG: Pin tapped for activity: \(activity.title)")
                            selectedActivity = activity
                            showActivityDetail = true
                            print("DEBUG: Sheet presentation state set to: \(showActivityDetail)")
                        }
                    }
                }
            }
            .mapStyle(.standard(elevation: .realistic, pointsOfInterest: .excludingAll))
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
            .safeAreaInset(edge: .top) {
                SearchBarView()
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.sm)
            }
            .ignoresSafeArea()
        }
        .sheet(isPresented: $showActivityDetail) {
            if let activity = selectedActivity {
                ActivityDetailSheet(
                    activity: activity,
                    isPresented: $showActivityDetail
                )
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(AppCornerRadius.xl)
                .onAppear {
                    print("DEBUG: Presenting sheet for activity: \(activity.title)")
                }
            } else {
                Text("No activity selected")
                    .foregroundColor(.red)
                    .padding()
                    .onAppear {
                        print("DEBUG: ERROR - selectedActivity is nil when trying to present sheet")
                    }
            }
        }

        .onAppear {
            viewModel.fetchActivities()
        }
    }
}

struct SearchBarView: View {
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            // Modern search bar following HIG
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                    .font(.system(size: 16, weight: .medium))
                
                TextField("Search activities", text: $searchText)
                    .focused($isSearchFocused)
                    .textFieldStyle(.plain)
                    .font(.system(size: 16))
                    .submitLabel(.search)
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                        isSearchFocused = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                            .font(.system(size: 16))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.quaternary, lineWidth: 0.5)
            )
            
            // Voice button
            Button {
                // Handle voice search
            } label: {
                Image(systemName: "mic.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                    .frame(width: 44, height: 44)
                    .background(.ultraThinMaterial, in: Circle())
            }
            .buttonStyle(.plain)
            
            // Profile button  
            Button {
                // Handle profile action
            } label: {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(AppColors.primaryText)
                    )
            }
            .buttonStyle(.plain)
        }
        .animation(.easeInOut(duration: 0.2), value: searchText.isEmpty)
    }
}

#Preview {
    MapView()
} 