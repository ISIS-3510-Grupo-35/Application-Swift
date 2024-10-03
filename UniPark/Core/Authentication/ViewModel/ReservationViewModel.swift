import Combine
import Foundation

@MainActor
class ReservationViewModel: ObservableObject {
    @Published var reservations: [Reservation] = []
    @Published var currentReservation: Reservation?
    private let reservationDAO: ReservationDAOProtocol
    
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
}
