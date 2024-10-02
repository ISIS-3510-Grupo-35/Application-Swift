//
//  MapView.swift
//  UniPark
//
//  Created by Ingrith Barbosa on 22/09/24.
//

import SwiftUI
import MapKit
import Combine
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var userLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
    }

    func requestLocation() {
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            self.userLocation = lastLocation.coordinate
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error al obtener la ubicación: \(error)")
    }
}


struct MapView: View {
    @ObservedObject var locationManager = LocationManager()
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var searchText = ""
    @State private var results = [MKMapItem]()
    @State private var mapSelection: MKMapItem?
    
    @StateObject var viewModel = ParkingSpotViewModel()
    @State var selectedFilter = 1
    
    var filteredParkingSpots: [ParkingSpot] {
            if selectedFilter == 2 {
                // Filtrar solo los parqueaderos con una calificación mayor a 4.5
                return viewModel.parkingSpots.filter { $0.review >= 4.5 }
            } else {
                // Mostrar todos los parqueaderos
                return viewModel.parkingSpots
            }
        }

    var body: some View {
        NavigationView {
            VStack {
                Image("uniparkSign")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 100)
                
                VStack {
                    TextField("Search for a location...", text: $searchText)
                        .font(.subheadline)
                        .padding(12)
                        .background(Color.yellow)
                        .padding(.horizontal)
                        .shadow(radius: 10)
                        .onChange(of: searchText) { newValue in
                            Task { await searchPlaces() }
                        }

                    if !results.isEmpty {
                        List(results, id: \.self) { result in
                            Button(action: {
                                selectPlace(result)
                            }) {
                                Text(result.placemark.name ?? "Unknown place")
                            }
                        }
                        .frame(height: 200)
                    }
                }

                // Mapa con los marcadores
                Map(position: $cameraPosition, selection: $mapSelection) {
                                    Annotation("My location", coordinate: locationManager.userLocation ?? CLLocationCoordinate2D(latitude: 1000, longitude: 1000)) {
                                        ZStack {
                                            Circle()
                                                .frame(width: 32, height: 32)
                                                .foregroundColor(.blue.opacity(0.25))
                                            Circle()
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(.white)
                                            Circle()
                                                .frame(width: 12, height: 12)
                                                .foregroundColor(.blue)
                                        }
                                    }

                                    // Mostrar marcadores desde Firebase Firestore
                                    ForEach(viewModel.parkingSpots) { spot in
                                        Marker(spot.name, systemImage: "parkingsign.circle.fill", coordinate: CLLocationCoordinate2D(latitude: spot.latitude, longitude: spot.longitude))
                                    }
                                }
                .onAppear {
                        locationManager.requestLocation()
                }
                .onChange(of: locationManager.userLocation) { newLocation in
                    if let userLocation = newLocation {
                        viewModel.fetchParkingSpots(around: userLocation)
                    } else {
                            print("Ubicación del usuario no disponible aún.")
                        }
                }
                .onChange(of: mapSelection) { _, newValue in
                    if let selectedPlace = newValue {
                        Task {viewModel.fetchParkingSpots(around: selectedPlace.placemark.coordinate) }
                    }
                }
                .mapControls {
                    MapCompass()
                    MapUserLocationButton()
                }
                VStack {
                    Picker("Filter", selection: $selectedFilter.animation()) {
                        Text("All")
                            .tag(1)
                        Text("Top rated")
                            .tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
        
                    List(filteredParkingSpots) { spot in
                        NavigationLink(destination: ParkingDetailView(parkingSpot: spot)) {
                            VStack(alignment: .leading) {
                                Text(spot.name)
                                    .font(.headline)
                                Text(spot.address)
                                    .font(.subheadline)
                                Text("Capacity: \(spot.capacity)")
                                    .font(.caption)
                                Text("Review: \(spot.review)")
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}


extension MapView {
    func searchPlaces() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        if let userLocation = locationManager.userLocation {
            request.region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
        }
        let searchResults = try? await MKLocalSearch(request: request).start()
        self.results = searchResults?.mapItems ?? []
    }

    func selectPlace(_ place: MKMapItem) {
        cameraPosition = .region(MKCoordinateRegion(center: place.placemark.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000))
        mapSelection = place
        Marker(place.placemark.name ?? "Selected Place", coordinate: place.placemark.coordinate)
            .tint(.blue)

        results.removeAll()
        Task {viewModel.fetchParkingSpots(around: place.placemark.coordinate) }
    }
    func filterParkingSpots(){
        
    }
}


#Preview {
    MapView()
}



