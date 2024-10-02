//
//  ReservationViewModel.swift
//  UniPark
//
//  Created by Tomas Angel on 2/10/24.
//
import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class ReservationViewModel: ObservableObject {
    @Published var reservations = [Reservation]()
    @Published var currentReservation: Reservation?
    private var db = FirestoreService.shared.getFirestoreReference()
    
    // Function to create a new reservation
    func createReservation(arrivalTime: String, departureTime: String, licensePlate: String, parkingId: Int, userId: Int) async throws {
        print("Create reservation...")
        do {
            let reservationId = UUID().uuidString
            let reservation = Reservation(id: reservationId, arrivalTime: arrivalTime, departureTime: departureTime, licensePlate: licensePlate, parkingId: parkingId, userId: userId)
            
            let encodedReservation = try Firestore.Encoder().encode(reservation)
            try await db.collection("reservations").document(reservation.id).setData(encodedReservation)
            
            await fetchReservations(forUserId: userId)
        } catch {
            print("DEBUG: Failed to create reservation with error \(error.localizedDescription)")
        }
    }
    
    // Function to fetch all reservations for a specific user
    func fetchReservations(forUserId userId: Int) async {
        print("Fetching reservations...")
        do {
            let snapshot = try await db.collection("reservations").whereField("userId", isEqualTo: userId).getDocuments()
            self.reservations = try snapshot.documents.compactMap { document in
                return try document.data(as: Reservation.self)
            }
        } catch {
            print("DEBUG: Failed to fetch reservations with error \(error.localizedDescription)")
        }
    }

    // Function to delete a reservation
    func deleteReservation(reservationId: String) async {
        print("Delete reservation...")
        do {
            try await db.collection("reservations").document(reservationId).delete()
            self.reservations.removeAll { $0.id == reservationId }
        } catch {
            print("DEBUG: Failed to delete reservation with error \(error.localizedDescription)")
        }
    }
}
