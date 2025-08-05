//
//  CreateActivityView.swift
//  ANISmock
//
//  Created by Salman on 08/02/1447 AH.
//

import SwiftUI
import MapKit

struct CreateActivityView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = MapViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var currentStep = 0
    @State private var selectedSport: SportType = .padel
    @State private var title = ""
    @State private var description = ""
    @State private var dateTime = Date().addingTimeInterval(3600)
    @State private var maxParticipants = 4
    @State private var skillLevel: SkillLevel = .intermediate
    @State private var selectedLocation: Location?
    @State private var isCreating = false
    
    var body: some View {
        NavigationView {
                            ZStack {
                Color(red: 1.0, green: 0.957, blue: 0.867) // #FFF4DD - User's preferred background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button("Cancel") {
                            dismiss()
                        }
                        .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267)) // #152C44
                        
                        Spacer()
                        
                        Text("Create Activity")
                            .font(AppFonts.title2)
                            .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267)) // #152C44
                        
                        Spacer()
                        
                        Button {
                            if currentStep == 0 {
                                withAnimation {
                                    currentStep = 1
                                }
                            } else {
                                createActivity()
                            }
                        } label: {
                            if isCreating {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .tint(Color(red: 0.541, green: 0.757, blue: 0.522)) // #8AC185
                            } else {
                                Text(currentStep == 0 ? "Next" : "Create")
                                    .foregroundColor(canProceed ? Color(red: 0.541, green: 0.757, blue: 0.522) : Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.5)) // #8AC185 or muted #152C44
                            }
                        }
                        .disabled(!canProceed || isCreating)
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.lg)
                    
                    // Progress indicator
                    HStack {
                        ForEach(0..<2) { index in
                            Rectangle()
                                .fill(index <= currentStep ? Color(red: 0.541, green: 0.757, blue: 0.522) : Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.3)) // #8AC185 or muted #152C44
                                .frame(height: 3)
                                .cornerRadius(1.5)
                        }
                    }
                    .padding(.horizontal, AppSpacing.xl)
                    .padding(.top, AppSpacing.md)
                    
                    // Content
                    TabView(selection: $currentStep) {
                        DetailsStepView(
                            selectedSport: $selectedSport,
                            title: $title,
                            description: $description,
                            dateTime: $dateTime,
                            maxParticipants: $maxParticipants,
                            skillLevel: $skillLevel
                        )
                        .tag(0)
                        
                        LocationStepView(
                            selectedLocation: $selectedLocation
                        )
                        .tag(1)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .animation(.easeInOut(duration: 0.3), value: currentStep)
                }
            }
        }
    }
    
    private var canProceed: Bool {
        if currentStep == 0 {
            return !title.isEmpty
        } else {
            return selectedLocation != nil
        }
    }
    
    private var canCreate: Bool {
        !title.isEmpty && selectedLocation != nil
    }
    
    private func createActivity() {
        guard let location = selectedLocation,
              let currentUser = authViewModel.currentUser else { return }
        
        isCreating = true
        
        let activity = Activity(
            title: title,
            description: description.isEmpty ? nil : description,
            sportType: selectedSport,
            hostId: currentUser.id,
            hostName: currentUser.name,
            location: location,
            dateTime: dateTime,
            maxParticipants: maxParticipants,
            skillLevel: skillLevel
        )
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            viewModel.createActivity(activity)
            isCreating = false
            dismiss()
        }
    }
}

struct DetailsStepView: View {
    @Binding var selectedSport: SportType
    @Binding var title: String
    @Binding var description: String
    @Binding var dateTime: Date
    @Binding var maxParticipants: Int
    @Binding var skillLevel: SkillLevel
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                // Sport selection
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    Text("Choose Sport")
                        .font(AppFonts.headline)
                        .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267)) // #152C44
                    
                    // Sport Grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                        ForEach(SportType.allCases, id: \.self) { sport in
                            Button(action: {
                                selectedSport = sport
                            }) {
                                VStack(spacing: 8) {
                                    ZStack {
                                        Circle()
                                            .fill(selectedSport == sport ? 
                                                  Color(red: 0.541, green: 0.757, blue: 0.522) : // #8AC185 - Selected
                                                  Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.1)) // Light #152C44 - Unselected
                                            .frame(width: 60, height: 60)
                                        
                                        Text(sport.emoji)
                                            .font(.system(size: 24))
                                    }
                                    
                                    Text(sport.displayName)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(selectedSport == sport ? 
                                                        Color(red: 0.541, green: 0.757, blue: 0.522) : // #8AC185 - Selected
                                                        Color(red: 0.082, green: 0.173, blue: 0.267)) // #152C44 - Unselected
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .buttonStyle(.plain)
                }
                
                // Title
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text("Title")
                        .font(AppFonts.headline)
                        .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267)) // #152C44
                    
                    TextField("Activity title", text: $title)
                        .textFieldStyle(CreateActivityTextFieldStyle())
                }
                
                // Description
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text("Description")
                        .font(AppFonts.headline)
                        .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267)) // #152C44
                    
                    TextField("Description", text: $description, axis: .vertical)
                        .textFieldStyle(CreateActivityTextFieldStyle())
                        .lineLimit(3...6)
                }
                
                // Date and time
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    Text("Date & Time")
                        .font(AppFonts.headline)
                        .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267)) // #152C44
                    
                    HStack(spacing: AppSpacing.md) {
                        DatePicker("Date", selection: $dateTime, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .colorScheme(.dark)
                        
                        DatePicker("Time", selection: $dateTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.compact)
                            .colorScheme(.dark)
                    }
                }
                
                // Participants
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    Text("Max Participants")
                        .font(AppFonts.headline)
                        .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267)) // #152C44
                    
                    Stepper(value: $maxParticipants, in: 2...20) {
                        Text("\(maxParticipants) people")
                            .font(AppFonts.body)
                            .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267)) // #152C44
                    }
                    .accentColor(Color(red: 0.541, green: 0.757, blue: 0.522)) // #8AC185
                }
                
                // Skill level
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    Text("Skill Level")
                        .font(AppFonts.headline)
                        .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267)) // #152C44
                    
                    HStack(spacing: AppSpacing.md) {
                        ForEach(SkillLevel.allCases, id: \.self) { level in
                            Button(action: {
                                skillLevel = level
                            }) {
                                Text(level.displayName)
                                    .font(AppFonts.body)
                                    .foregroundColor(skillLevel == level ? .white : Color(red: 0.082, green: 0.173, blue: 0.267)) // White or #152C44
                                    .padding(.horizontal, AppSpacing.md)
                                    .padding(.vertical, AppSpacing.sm)
                                    .background(
                                        RoundedRectangle(cornerRadius: AppCornerRadius.small)
                                            .fill(skillLevel == level ? Color(red: 0.541, green: 0.757, blue: 0.522) : Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.1)) // #8AC185 or light #152C44
                                    )
                            }
                        }
                    }
                }
            }
            .padding(AppSpacing.lg)
        }

    }
}

struct LocationStepView: View {
    @Binding var selectedLocation: Location?
    @State private var showLocationPicker = false
    
    let popularLocations = [
        Location(latitude: 24.7136, longitude: 46.6753, address: "King Fahd Stadium"),
        Location(latitude: 24.7200, longitude: 46.6800, address: "Al Nakheel Sports Center"),
        Location(latitude: 24.7100, longitude: 46.6700, address: "Riyadh Tennis Club"),
        Location(latitude: 24.7150, longitude: 46.6850, address: "Prince Faisal Sports Complex"),
        Location(latitude: 24.7180, longitude: 46.6780, address: "Al Malaz Sports Center")
    ]
    
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            Text("Choose Location")
                .font(AppFonts.title2)
                .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267)) // #152C44
                .padding(.top, AppSpacing.xl)
            
            ScrollView {
                VStack(spacing: AppSpacing.md) {
                    // Current location option
                    Button(action: {
                        selectedLocation = Location(latitude: 24.7136, longitude: 46.6753, address: "Current Location")
                    }) {
                        LocationOptionView(
                            icon: "location.fill",
                            title: "Use Current Location",
                            subtitle: "GPS will determine your location",
                            isSelected: selectedLocation?.address == "Current Location"
                        )
                    }
                    .buttonStyle(.plain)
                    
                    // Popular locations
                    Text("Popular Sports Venues")
                        .font(AppFonts.headline)
                        .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267)) // #152C44
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, AppSpacing.md)
                    
                    ForEach(popularLocations, id: \.address) { location in
                        Button(action: {
                            selectedLocation = location
                        }) {
                            LocationOptionView(
                                icon: "building.2.fill",
                                title: location.address ?? "Unknown Location",
                                subtitle: "Tap to select this venue",
                                isSelected: selectedLocation?.address == location.address
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    
                    // Custom location option
                    Button(action: {
                        showLocationPicker = true
                    }) {
                        LocationOptionView(
                            icon: "map.fill",
                            title: "Select from Map",
                            subtitle: "Choose any location on the map",
                            isSelected: false
                        )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, AppSpacing.lg)
            }
            
            Spacer()
        }
        .actionSheet(isPresented: $showLocationPicker) {
            ActionSheet(
                title: Text("Map Integration"),
                message: Text("Map location picker coming soon!"),
                buttons: [
                    .default(Text("Use Diplomatic Quarter")) {
                        selectedLocation = Location(latitude: 24.7050, longitude: 46.6720, address: "Diplomatic Quarter Sports Club")
                    },
                    .cancel()
                ]
            )
        }
    }
}

struct LocationOptionView: View {
    let icon: String
    let title: String
    let subtitle: String
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(isSelected ? Color(red: 0.541, green: 0.757, blue: 0.522) : Color(red: 0.082, green: 0.173, blue: 0.267)) // #8AC185 or #152C44
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AppFonts.body)
                    .fontWeight(.medium)
                    .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267)) // #152C44
                
                Text(subtitle)
                    .font(AppFonts.caption)
                    .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.7)) // #152C44 with opacity
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color(red: 0.541, green: 0.757, blue: 0.522)) // #8AC185
                    .font(.title2)
            }
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                .fill(isSelected ? Color(red: 0.541, green: 0.757, blue: 0.522).opacity(0.1) : Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.05)) // Light green or light blue
                .overlay(
                    RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                        .stroke(isSelected ? Color(red: 0.541, green: 0.757, blue: 0.522) : Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.2), lineWidth: isSelected ? 2 : 1) // Green or light blue border
                )
        )
    }
}

struct CreateActivityTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                    .fill(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.05)) // Light #152C44
                    .overlay(
                        RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                            .stroke(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.2), lineWidth: 1) // Light border
                    )
            )
            .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267)) // #152C44
            .accentColor(Color(red: 0.541, green: 0.757, blue: 0.522)) // #8AC185 for cursor
    }
}

#Preview {
    CreateActivityView()
        .environmentObject(AuthViewModel())
} 