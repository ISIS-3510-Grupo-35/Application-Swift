//
//  ReservationDAO.swift
//  UniPark
//
//  Created by Tomas Angel on 2/10/24.
//

import Foundation
import FirebaseFirestore

class ReservationDAO: ReservationDAOProtocol {
    private var db = FirestoreService.shared.getFirestoreReference()
    
    func createReservation(_ reservation: Reservation) async throws {
        let encodedReservation = try Firestore.Encoder().encode(reservation)
        try await db.collection("reservations").document(reservation.id).setData(encodedReservation)
    }
    
    func fetchAllReservations() async throws -> [Reservation] {
        let snapshot = try await db.collection("reservations").getDocuments()
        return try snapshot.documents.compactMap { document in
            return try document.data(as: Reservation.self)
        }
    }
    
    func deleteReservation(_ reservationId: String) async throws {
        try await db.collection("reservations").document(reservationId).delete()
    }
}

