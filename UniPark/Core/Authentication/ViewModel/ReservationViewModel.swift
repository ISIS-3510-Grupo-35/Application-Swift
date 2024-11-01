//
//  AuthViewModel.swift
//  UniPark
//
//  Created by Tomas Angel on 21/09/24.
//

import SwiftUI
import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine
import Foundation

@Observable
class ReservationViewModel {
    var reservations: [Reservation] = []
    var currentReservation: Reservation?
    private let reservationDAO: ReservationDAOProtocol
    private var db = FirestoreService.shared.getFirestoreReference()
    
    // Initialize with a specific DAO implementation
    init(reservationDAO: ReservationDAOProtocol = ReservationDAO()) async {
        self.reservationDAO = reservationDAO
        await fetchAllReservations() // Fetch reservations on initialization
    }
    
    // Function to create a new reservation
    func createReservation(arrivalTime: String, departureTime: String, licensePlate: String, parkingId: Int, userId: Int) async {
        let reservation = Reservation(id: UUID().uuidString, arrivalTime: arrivalTime, departureTime: departureTime, licensePlate: licensePlate, parkingId: parkingId, userId: userId)
        do {
            try await reservationDAO.createReservation(reservation)
            await fetchAllReservations() // Refresh reservations after creation
        } catch {
            print("Error creating reservation: \(error.localizedDescription)")
        }
    }
    
    // Function to fetch all reservations
    func fetchAllReservations() async {
        do {
            self.reservations = try await reservationDAO.fetchAllReservations()
        } catch {
            print("Error fetching reservations: \(error.localizedDescription)")
        }
    }

    // Function to delete a reservation
    func deleteReservation(reservationId: String) async {
        do {
            try await reservationDAO.deleteReservation(reservationId) // Assuming deleteReservation is part of your DAO
            self.reservations.removeAll { $0.id == reservationId }
        } catch {
            print("Error deleting reservation: \(error.localizedDescription)")
        }
    }
    
    // Function to calculate the full capacity of the parkinglot
    func getFullCapacityTimes(parkingLotId: String, dayOfWeek: Int) async -> [Date]? {
            do {
                let snapshot = try await db.collection("parkingLots")
                    .document(parkingLotId)
                    .collection("availabilityHistory")
                    .whereField("availableSpots", isEqualTo: 0)
                    .whereField("dayOfWeek", isEqualTo: dayOfWeek)
                    .getDocuments()
                
                let fullCapacityTimes = snapshot.documents.compactMap { document in
                    return document["timestamp"] as? Date
                }
                
                return fullCapacityTimes
            } catch {
                print("Error fetching full capacity times: \(error)")
                return nil
            }
        }

        // Function to schedule full capacity notifications
        func scheduleFullCapacityNotification(parkingLotId: String, dayOfWeek: Int) async {
            if let fullCapacityTimes = await getFullCapacityTimes(parkingLotId: parkingLotId, dayOfWeek: dayOfWeek) {
                if let latestFullCapacity = fullCapacityTimes.max() {
                    // Schedule a notification for the next day at this time minus 30 minutes
                    let notificationTime = Calendar.current.date(byAdding: .minute, value: -30, to: latestFullCapacity)
                    
                    // Implement notification scheduling logic here
                    print("Notification should be scheduled at \(String(describing: notificationTime))")
                    
                    // Notification manager here
                }
            }
        }
    
}
