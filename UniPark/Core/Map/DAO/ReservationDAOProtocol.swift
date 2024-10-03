//
//  ReservationDAOProtocol.swift
//  UniPark
//
//  Created by Tomas Angel on 2/10/24.
//

import Foundation

protocol ReservationDAOProtocol {
    func createReservation(_ reservation: Reservation) async throws
    func fetchAllReservations() async throws -> [Reservation]
    func deleteReservation(_ reservationId: String) async throws
}
