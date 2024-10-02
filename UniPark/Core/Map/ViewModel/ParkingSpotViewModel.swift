//
//  ParkingSpotViewModel.swift
//  UniPark
//
//  Created by Ingrith barbosa on 30/09/24.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import MapKit

// Modelo de datos para los parqueaderos
struct ParkingSpot: Identifiable {
    @DocumentID var id: String?
    var address: String
    var capacity: Int
    var closingTime: Date
    var durationFullRate: Int
    var fullRate: Int
    var image: String
    var latitude: Double
    var longitude: Double
    var name: String
    var openingTime: Date
    var priceMinute: Int
    var review: Double
    var userID: Int
}

class ParkingSpotViewModel: ObservableObject {
    @Published var parkingSpots: [ParkingSpot] = []
    
    private var db = Firestore.firestore()
    
    // Función para obtener los datos desde Firebase Firestore
    func fetchParkingSpots(around location: CLLocationCoordinate2D, radiusInMeters: Double = 1000) {
        let lat = location.latitude
        let lon = location.longitude

        // Conversión de metros a grados (aproximado)
        let latDelta = radiusInMeters / 111_320.0 // 1 grado de latitud ≈ 111.32 km
        let lonDelta = radiusInMeters / (111_320.0 * cos(lat * .pi / 180)) // 1 grado de longitud varía con la latitud
        
        // Definir los límites del "bounding box"
        let lowerLat = lat - latDelta
        let upperLat = lat + latDelta
        let lowerLon = lon - lonDelta
        let upperLon = lon + lonDelta

        // Realizar la consulta en Firestore con filtros de latitud y longitud
        db.collection("Parking lots") // Asegúrate que este sea el nombre correcto
            .whereField("latitude", isGreaterThanOrEqualTo: lowerLat)
            .whereField("latitude", isLessThanOrEqualTo: upperLat)
            .whereField("longitude", isGreaterThanOrEqualTo: lowerLon)
            .whereField("longitude", isLessThanOrEqualTo: upperLon)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error al obtener los datos: \(error)")
                    return
                }

                if let snapshot = snapshot {
                    self.parkingSpots = snapshot.documents.compactMap { document in
                        let data = document.data()
                        guard let address = data["address"] as? String,
                              let capacity = data["capacity"] as? Int,
                              let closingTime = (data["closingTime"] as? Timestamp)?.dateValue(),
                              let durationFullRate = data["durationFullRate"] as? Int,
                              let fullRate = data["fullRate"] as? Int,
                              let image = data["image"] as? String,
                              let latitude = data["latitude"] as? Double,
                              let longitude = data["longitude"] as? Double,
                              let name = data["name"] as? String,
                              let openingTime = (data["openingTime"] as? Timestamp)?.dateValue(),
                              let priceMinute = data["priceMinute"] as? Int,
                              let review = data["review"] as? Double,
                              let userID = data["userID"] as? Int else {
                            print("Datos faltantes o incorrectos en el documento \(document.documentID)")
                            return nil
                        }
                        
                        return ParkingSpot(id: document.documentID, address: address, capacity: capacity, closingTime: closingTime, durationFullRate: durationFullRate, fullRate: fullRate, image: image, latitude: latitude, longitude: longitude, name: name, openingTime: openingTime, priceMinute: priceMinute, review: review, userID: userID)
                    }
                }
            }
    }

}

