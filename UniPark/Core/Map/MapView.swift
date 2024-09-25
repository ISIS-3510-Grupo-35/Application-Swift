//
//  MapView.swift
//  UniPark
//
//  Created by Ingrith Barbosa on 22/09/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var searchText = ""
    @State private var results = [MKMapItem]()
    @State private var parkingSpots = [MKMapItem]()
    @State private var mapSelection: MKMapItem?

    var body: some View {
        NavigationView {
            VStack {
                Image("uniparkSign")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 100)
                // Campo de búsqueda y lista de resultados
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

                    // Lista de resultados de la búsqueda
                    if !results.isEmpty {
                        List(results, id: \.self) { result in
                            Button(action: {
                                selectPlace(result)
                            }) {
                                Text(result.placemark.name ?? "Unknown place")
                            }
                        }
                        .frame(height: 200) // Limitar el tamaño de la lista
                    }
                }
                // Mapa con los marcadores
                Map(position: $cameraPosition, selection: $mapSelection) {
                    Annotation("My location", coordinate: .userlocation) {
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

                    // Marcadores de parqueaderos
                    ForEach(parkingSpots, id: \.self) { spot in
                        Marker(spot.placemark.name ?? "Parking Spot", systemImage: "parkingsign.circle.fill", coordinate: spot.placemark.coordinate)
                    }
                }
                .onAppear {
                    CLLocationManager().requestWhenInUseAuthorization()
                    Task { await fetchParkingSpots(for: .userlocation) }
                }
                .onChange(of: mapSelection) { _, newValue in
                                    if let selectedPlace = newValue {
                                        Task { await fetchParkingSpots(for: selectedPlace.placemark.coordinate) }
                                    }
                                }
                .mapControls {
                    MapCompass()
                    MapUserLocationButton()
                }
                
                // Lista de parqueaderos
                List(parkingSpots, id: \.self) { spot in
                    NavigationLink(destination: ParkingDetailView(parkingSpot: spot)) {
                        Text(spot.placemark.name ?? "Unknown")
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 400)
            }
        }
    }
}

extension MapView {
    func searchPlaces() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = .userRegion
        let searchResults = try? await MKLocalSearch(request: request).start()
        self.results = searchResults?.mapItems ?? []
    }
    
    func fetchParkingSpots(for coordinate: CLLocationCoordinate2D) async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "parking"
        request.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        let results = try? await MKLocalSearch(request: request).start()
        self.parkingSpots = results?.mapItems ?? []
    }

    func selectPlace(_ place: MKMapItem) {
        // Seleccionar el lugar y ajustar la cámara
        cameraPosition = .region(MKCoordinateRegion(center: place.placemark.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000))
        mapSelection = place
        Marker(place.placemark.name ?? "Selected Place", coordinate: place.placemark.coordinate)
            .tint(.blue)
        
        // Limpiar los resultados de búsqueda y buscar parqueaderos
        results.removeAll()
        Task { await fetchParkingSpots(for: place.placemark.coordinate) }
    }
}

extension CLLocationCoordinate2D {
    static var userlocation: CLLocationCoordinate2D {
        return .init(latitude: 4.6015, longitude: -74.0661)
    }
}

extension MKCoordinateRegion {
    static var userRegion: MKCoordinateRegion {
        return .init(center: .userlocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
    }
}

#Preview {
    MapView()
}


