//
//  Reservation.swift
//  UniPark
//
//  Created by Tomas Angel on 2/10/24.
//

import Foundation

struct Reservation: Identifiable, Codable {
    let id: String
    let arrivalTime: String
    let departureTime: String
    let licensePlate: String
    let parkingId: Int
    let userId: Int
}

extension Reservation {
    static var MOCK_RESERVATION = Reservation(id: NSUUID().uuidString, arrivalTime: "Tuesay, 11:00:00 a.m. UTC-5", departureTime: "Tuesday, 17:00:00 a.m. UTC-5", licensePlate: "KLM505", parkingId: 001, userId: 11223344)
}
