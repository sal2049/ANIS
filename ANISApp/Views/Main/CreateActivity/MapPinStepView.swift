//
//  MapPinStepView.swift
//

import SwiftUI
import MapKit
import CoreLocation
import Combine

struct MapPinStepView: View {
    @Binding var selectedLocation: Location?
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @EnvironmentObject var locationPermission: LocationPermissionManager
    @State private var searchText: String = ""
    @StateObject private var searchHelper = CompleterWrapper()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 24.7136, longitude: 46.6753),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )
    @State private var currentCenter: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 24.7136, longitude: 46.6753)
    @State private var addressPreview: String = ""
    
    var body: some View {
        let topSearch = VStack(spacing: 8) {
            HStack(spacing: 10) {
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
            .padding(.horizontal, 12)
            .frame(height: 40)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.dividerColor, lineWidth: 1)
                    )
            )
            if !searchHelper.results.isEmpty {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(searchHelper.results, id: \.self) { s in
                            Button { performSearch(selection: s) } label: {
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
                            Divider().background(AppColors.dividerColor)
                        }
                    }
                }
                .frame(maxHeight: 200)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 8)

        let bottomCTA = VStack(spacing: 8) {
            if !addressPreview.isEmpty {
                Text(addressPreview)
                    .font(AppFonts.footnote)
                    .foregroundColor(AppColors.primaryText)
                    .padding(.bottom, 4)
            }
            Button(action: confirmLocation) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Set Activity Location")
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color(red: 0.541, green: 0.757, blue: 0.522), in: RoundedRectangle(cornerRadius: 26))
                .padding(.horizontal, 16)
                .padding(.bottom, 10)
            }
            .buttonStyle(.plain)
        }

        return ZStack {
            Map(position: $cameraPosition)
                .mapControls { MapUserLocationButton(); MapCompass() }
                .onMapCameraChange { ctx in
                    currentCenter = ctx.region.center
                    reverseGeocode(center: currentCenter)
                }
                .onAppear { searchHelper.completer.resultTypes = .address }
                .task {
                    locationPermission.requestWhenInUse()
                    reverseGeocode(center: currentCenter)
                }
                .ignoresSafeArea()

            Image(systemName: "mappin.and.ellipse")
                .font(.system(size: 44))
                .foregroundColor(.red)
                .shadow(radius: 2)
        }
        .overlay(topSearch, alignment: .top)
        .overlay(bottomCTA, alignment: .bottom)
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


