//
//  MapPinStepView.swift
//

import SwiftUI
import MapKit
import CoreLocation

struct MapPinStepView: View {
    @Binding var selectedLocation: Location?
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var searchText: String = ""
    @StateObject private var searchHelper = CompleterWrapper()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 24.7136, longitude: 46.6753),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )
    @State private var currentCenter: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 24.7136, longitude: 46.6753)
    @State private var addressPreview: String = ""
    
    var body: some View {
        ZStack {
            Map(position: $cameraPosition)
                .mapControls { MapUserLocationButton(); MapCompass() }
                .onMapCameraChange { ctx in
                    currentCenter = ctx.region.center
                    reverseGeocode(center: currentCenter)
                }
                .onAppear { searchHelper.completer.resultTypes = .address }
                .task { reverseGeocode(center: currentCenter) }
            
            // Center marker with radius overlay
            VStack(spacing: 6) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 42))
                    .foregroundColor(.red)
                    .shadow(radius: 3)
                Circle()
                    .stroke(Color.red.opacity(0.5), lineWidth: 2)
                    .background(Circle().fill(Color.red.opacity(0.08)))
                    .frame(width: 120, height: 120)
            }
            
            VStack {
                // Top instruction + search
                VStack(spacing: 0) {
                    // Instruction bubble
                    VStack(spacing: 6) {
                        Text("Choose a general area")
                            .font(AppFonts.callout)
                            .foregroundColor(AppColors.primaryText)
                        Text("You can adjust details later")
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.secondaryText)
                    }
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: AppCornerRadius.large)
                            .fill(AppColors.secondaryBackground)
                            .shadow(color: AppColors.shadowColor.opacity(0.15), radius: 10, x: 0, y: 6)
                    )
                    .padding(.bottom, AppSpacing.sm)

                    // Search bar glass
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass").foregroundColor(AppColors.secondaryText)
                        TextField("Search for a place", text: $searchText)
                            .textInputAutocapitalization(.words)
                            .onChange(of: searchText) { _, q in
                                searchHelper.completer.queryFragment = q
                            }
                        if !searchText.isEmpty {
                            Button { searchText = "" } label: {
                                Image(systemName: "xmark.circle.fill").foregroundColor(AppColors.secondaryText)
                            }
                        }
                    }
                    .padding(12)
                    if !searchHelper.results.isEmpty {
                        Divider().background(AppColors.dividerColor)
                        ScrollView {
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(searchHelper.results, id: \.self) { s in
                                    Button {
                                        performSearch(selection: s)
                                    } label: {
                                        HStack {
                                            Image(systemName: "location.fill").foregroundColor(AppColors.secondaryText)
                                            VStack(alignment: .leading) {
                                                Text(s.title).foregroundColor(AppColors.primaryText)
                                                Text(s.subtitle).foregroundColor(AppColors.secondaryText).font(.caption)
                                            }
                                            Spacer()
                                        }
                                        .padding(12)
                                    }
                                }
                            }
                        }.frame(maxHeight: 200)
                    }
                }
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.large))
                .padding(.horizontal, AppSpacing.lg)
                .padding(.top, AppSpacing.lg)
                
                Spacer()
                
                if !addressPreview.isEmpty {
                    Text(addressPreview)
                        .font(AppFonts.footnote)
                        .foregroundColor(AppColors.primaryText)
                        .padding(.bottom, AppSpacing.sm)
                        .background(Color.clear)
                }
                
                Button(action: confirmLocation) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Set Activity Location")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(red: 0.541, green: 0.757, blue: 0.522), in: Capsule())
                    .padding(.horizontal, AppSpacing.xl)
                    .padding(.bottom, AppSpacing.lg)
                }
                .buttonStyle(.plain)
            }
        }
        // results handled via delegate wrapper
    }
    
    private func reverseGeocode(center: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: center.latitude, longitude: center.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, _ in
            if let place = placemarks?.first {
                let parts = [place.name, place.locality, place.administrativeArea].compactMap { $0 }
                addressPreview = parts.joined(separator: ", ")
            }
        }
    }
    
    private func performSearch(selection: MKLocalSearchCompletion) {
        let request = MKLocalSearch.Request(completion: selection)
        MKLocalSearch(request: request).start { response, _ in
            if let item = response?.mapItems.first {
                withAnimation(.snappy) {
                    cameraPosition = .region(MKCoordinateRegion(center: item.placemark.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
                }
            }
        }
    }
    
    private func confirmLocation() {
        selectedLocation = Location(latitude: currentCenter.latitude, longitude: currentCenter.longitude, address: addressPreview)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

final class CompleterWrapper: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var results: [MKLocalSearchCompletion] = []
    let completer = MKLocalSearchCompleter()
    override init() {
        super.init()
        completer.delegate = self
    }
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        results = completer.results
    }
}


