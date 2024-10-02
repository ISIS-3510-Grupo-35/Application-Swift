//
//  User.swift
//  UniPark
//
//  Created by Tomas Angel on 21/09/24.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String
    //let isDriver: Bool
    //let balance: Int
    //let favoriteParkingLots: [String]
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return ""
    }
    
}

extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, fullname: "Kobe Bryant", email: "test@email.com") //, isDriver: true, balance: 0, favoriteParkingLots: [])
}
