//
//  ParkingDetailView.swift
//  UniPark
//
//  Created by Ingrith barbosa on 22/09/24.
//

import SwiftUI
import MapKit

struct ParkingDetailView: View {
    var parkingSpot: MKMapItem?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Nombre del parqueadero
                Text(parkingSpot?.placemark.name ?? "Parking Spot")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)

                // Dirección del parqueadero
                if let address = parkingSpot?.placemark {
                    Text(formatAddress(from: address))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                // Imagen del parqueadero
                Image("parkingExample")  // Puedes usar una imagen local o cargarla desde una URL
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .cornerRadius(12)
                    .padding(.bottom)
                
                // Calificación simulada
                HStack {
                    Text("Rating: ")
                        .font(.headline)
                    ForEach(0..<4) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                    Image(systemName: "star")
                        .foregroundColor(.yellow)
                }
                .padding(.bottom)

            }
            .padding()
            .navigationTitle("Parking Detail")
        }
    }
}

extension ParkingDetailView {

    // Función para formatear la dirección desde CLPlacemark
    func formatAddress(from placemark: CLPlacemark) -> String {
        var addressString = ""
        if let street = placemark.thoroughfare {
            addressString += street
        }
        if let city = placemark.locality {
            addressString += ", \(city)"
        }
        if let country = placemark.country {
            addressString += ", \(country)"
        }
        return addressString
    }
}

#Preview {
    ParkingDetailView()
}

