//
//  MapView.swift
//  ANISmock
//
//  Created by Salman on 08/02/1447 AH.
//

import SwiftUI
import MapKit
import Combine

struct MapView: View {
    @EnvironmentObject var viewModel: MapViewModel
    @EnvironmentObject var locationPermission: LocationPermissionManager
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 24.7136, longitude: 46.6753), // Riyadh
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    @State private var selectedActivity: Activity?
    @State private var showActivityDetail = false
    @State private var searchText = ""
    @State private var showFilters = false
    @State private var selectedSportFilter: SportType? = nil
    
    // Using activity ID to prevent reference issues
    @State private var selectedActivityId: String?
    
    // Filtered activities based on search
    private var filteredActivities: [Activity] {
        let base = viewModel.activities.filter { activity in
            if searchText.isEmpty { return true }
            return activity.title.localizedCaseInsensitiveContains(searchText) ||
            activity.sportType.displayName.localizedCaseInsensitiveContains(searchText) ||
            activity.hostName.localizedCaseInsensitiveContains(searchText) ||
            (activity.description?.localizedCaseInsensitiveContains(searchText) ?? false) ||
            (activity.location.address?.localizedCaseInsensitiveContains(searchText) ?? false)
        }
        if let filter = selectedSportFilter {
            return base.filter { $0.sportType == filter }
        }
        return base
    }
    
    // Get selected activity from ID to ensure it's always valid
    private var currentSelectedActivity: Activity? {
        guard let selectedActivityId = selectedActivityId else { return nil }
        return viewModel.activities.first { $0.id == selectedActivityId }
    }
    
    var body: some View {
        ZStack {
            // Modern iOS 17+ Map with MapContentBuilder
            Map(position: $cameraPosition) {
                ForEach(filteredActivities, id: \.id) { activity in
                    Annotation(
                        activity.title,
                        coordinate: activity.location.coordinate,
                        anchor: .center
                    ) {
                        ActivityPinView(activity: activity) {
                            print("DEBUG: Pin tapped for activity: \(activity.title)")
                            // Use activity ID to prevent reference issues
                            selectedActivityId = activity.id
                            selectedActivity = activity
                            
                            // Delay sheet presentation slightly to ensure state is updated
                            DispatchQueue.main.async {
                                showActivityDetail = true
                                print("DEBUG: Sheet presentation state set to: \(showActivityDetail)")
                                print("DEBUG: Selected activity ID: \(selectedActivityId ?? "nil")")
                            }
                        }
                    }
                }
            }
            .mapStyle(.standard(elevation: .realistic, pointsOfInterest: .excludingAll))
            .mapControls {
                MapCompass()
                MapScaleView()
            }
            .overlay(alignment: .top) {
                VStack(spacing: 0) {
                    // Search Bar
                    SearchBarView(searchText: $searchText, onFilterTapped: {
                        withAnimation(.easeInOut(duration: 0.25)) { 
                            showFilters.toggle() 
                        }
                    })
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, 60) // Under Dynamic Island
                    
                    // Filter chips section
                    if showFilters {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                sportChip(title: "All", emoji: "🏃‍♂️", isOn: selectedSportFilter == nil) {
                                    selectedSportFilter = nil
                                }
                                ForEach(SportType.allCases, id: \.self) { sport in
                                    sportChip(title: sport.displayName, emoji: sport.emoji, isOn: selectedSportFilter == sport) {
                                        selectedSportFilter = sport
                                    }
                                }
                            }
                            .padding(.horizontal, AppSpacing.lg)
                            .padding(.vertical, 8)
                        }
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    // Search results counter
                    if !searchText.isEmpty {
                        HStack {
                            Text("\(filteredActivities.count) result\(filteredActivities.count == 1 ? "" : "s") found")
                                .font(.caption)
                                .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.7))
                            Spacer()
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.vertical, 4)
                        .background(.ultraThinMaterial.opacity(0.8))
                        .transition(.opacity)
                    }
                    
                    Spacer()
                }
                .animation(.easeInOut(duration: 0.25), value: showFilters)
                .animation(.easeInOut(duration: 0.25), value: searchText.isEmpty)
            }
            .overlay(alignment: .bottomTrailing) {
                // User Location Button - moved to bottom right
                MapUserLocationButton()
                    .padding(.trailing, AppSpacing.lg)
                    .padding(.bottom, 100) // Above tab bar
            }
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.3), value: searchText)
        }
        .sheet(isPresented: $showActivityDetail) {
            if let activity = currentSelectedActivity {
                ActivityDetailSheet(
                    activity: activity,
                    isPresented: $showActivityDetail
                )
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(AppCornerRadius.xl)
                .onAppear {
                    print("DEBUG: Successfully presenting sheet for activity: \(activity.title)")
                }
            } else {
                // Fallback - try using selectedActivity directly
                if let activity = selectedActivity {
                    ActivityDetailSheet(
                        activity: activity,
                        isPresented: $showActivityDetail
                    )
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(AppCornerRadius.xl)
                    .onAppear {
                        print("DEBUG: Fallback - presenting sheet for activity: \(activity.title)")
                    }
                } else {
                    VStack(spacing: 16) {
                        Text("Unable to load activity details")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267))
                        
                        Text("Please try tapping the pin again")
                            .font(.subheadline)
                            .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.7))
                        
                        Button("Close") {
                            showActivityDetail = false
                        }
                        .padding()
                        .background(Color(red: 0.541, green: 0.757, blue: 0.522))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding()
                    .background(Color(red: 1.0, green: 0.957, blue: 0.867))
                    .onAppear {
                        print("DEBUG: ERROR - Both currentSelectedActivity and selectedActivity are nil")
                        print("DEBUG: selectedActivityId: \(selectedActivityId ?? "nil")")
                        print("DEBUG: Available activities count: \(viewModel.activities.count)")
                    }
                }
            }
        }
        .onAppear {
            // Add delay to ensure proper initialization
            DispatchQueue.main.async {
                viewModel.fetchActivities()
                locationPermission.requestWhenInUse()
            }
        }
        .onReceive(locationPermission.$lastKnownLocation.compactMap { $0 }) { coordinate in
            withAnimation(.snappy) {
                cameraPosition = .region(
                    MKCoordinateRegion(
                        center: coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    )
                )
            }
        }
        .onChange(of: showActivityDetail) { _, newValue in
            if !newValue {
                // Reset selection when sheet is dismissed
                selectedActivity = nil
                selectedActivityId = nil
                print("DEBUG: Sheet dismissed, cleared selection")
            }
        }
        .onChange(of: viewModel.focusedActivityId) { _, newValue in
            guard let id = newValue,
                  let activity = viewModel.activities.first(where: { $0.id == id }) else { return }
            selectedActivityId = id
            selectedActivity = activity
            withAnimation(.snappy) {
                cameraPosition = .region(
                    MKCoordinateRegion(
                        center: activity.location.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                    )
                )
                showActivityDetail = true
            }
            // reset trigger
            DispatchQueue.main.async { viewModel.focusedActivityId = nil }
        }
    }
}

struct SearchBarView: View {
    @Binding var searchText: String
    var onFilterTapped: () -> Void = {}
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // Modern search bar following HIG
            HStack(alignment: .center, spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                    .font(.system(size: 16, weight: .medium))
                    .frame(width: 16, height: 16)
                
                TextField("Search activities", text: $searchText)
                    .focused($isSearchFocused)
                    .textFieldStyle(.plain)
                    .font(.system(size: 16))
                    .submitLabel(.search)
                    .onSubmit {
                        isSearchFocused = false
                    }
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                        isSearchFocused = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                            .font(.system(size: 16))
                            .frame(width: 16, height: 16)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(height: 44)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.quaternary, lineWidth: 0.5)
            )
            
            // Filter button with consistent height
            Button {
                onFilterTapped()
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267))
                    .frame(width: 44, height: 44)
                    .background(.ultraThinMaterial, in: Circle())
                    .overlay(
                        Circle()
                            .stroke(.quaternary, lineWidth: 0.5)
                    )
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .animation(.easeInOut(duration: 0.2), value: searchText.isEmpty)
    }
}

extension MapView {
    @ViewBuilder
    fileprivate func sportChip(title: String, emoji: String, isOn: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(emoji)
                    .font(.system(size: 14))
                Text(title)
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundColor(isOn ? .white : Color(red: 0.082, green: 0.173, blue: 0.267))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule().fill(isOn ? Color(red: 0.541, green: 0.757, blue: 0.522) : Color.white.opacity(0.9))
            )
            .overlay(
                Capsule().stroke(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MapView()
        .environmentObject(MapViewModel())
        .environmentObject(LocationPermissionManager())
}

// Preview for SearchBarView
#Preview("SearchBarView") {
    @Previewable @State var searchText = ""
    return SearchBarView(searchText: $searchText)
        .padding()
} 